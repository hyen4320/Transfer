package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.client.GeminiApiClient;
import transfer.be.client.dto.ParseResult;
import transfer.be.model.*;
import transfer.be.repository.ClubAliasRepository;
import transfer.be.repository.ClubRepository;
import transfer.be.repository.PlayerRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.repository.VerificationRepository;
import transfer.be.service.PostParsingService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostParsingServiceImpl implements PostParsingService {

    private final GeminiApiClient geminiApiClient;
    private final PlayerRepository playerRepository;
    private final ClubRepository clubRepository;
    private final ClubAliasRepository clubAliasRepository;
    private final TransferNewsRepository transferNewsRepository;
    private final VerificationRepository verificationRepository;

    @Override
    @Transactional
    public void parseAndSave(List<Post> posts) {
        for (Post post : posts) {
            try {
                parseSingle(post);
            } catch (Exception e) {
                log.error("[Parsing] post_id={} 파싱 실패: {}", post.getId(), e.getMessage());
            }
        }
    }

    private void parseSingle(Post post) {
        ParseResult result = geminiApiClient.parseTransferTweet(post.getContent());

        if (!result.isTransferNews() || result.playerName() == null) {
            log.debug("[Parsing] post_id={} — 이적 뉴스 아님, 스킵", post.getId());
            return;
        }

        TransferNews.Status status = parseStatus(result.status());
        boolean isFa = status == TransferNews.Status.FREE_AGENT;

        // FA가 아닌 경우 toClub 필수
        if (!isFa && result.toClub() == null) {
            log.debug("[Parsing] post_id={} — toClub null (FA 아님), 스킵", post.getId());
            return;
        }

        Optional<Player> playerOpt = playerRepository.findByNameIgnoreCase(result.playerName());
        if (playerOpt.isEmpty()) {
            log.info("[Parsing] 선수 미등록: '{}' — 스킵", result.playerName());
            return;
        }
        Player player = playerOpt.get();

        Club toClub = null;
        if (!isFa) {
            toClub = resolveClub(result.toClub());
            if (toClub == null) {
                log.info("[Parsing] toClub 미등록: '{}' — 스킵", result.toClub());
                return;
            }
        }

        // 재계약은 이적이 아니므로 fromClub = toClub
        Club fromClub;
        if (status == TransferNews.Status.CONTRACT_EXTENSION) {
            fromClub = toClub;
        } else {
            fromClub = result.fromClub() != null ? resolveClub(result.fromClub()) : null;
            // Gemini가 현재 구단을 추출 못했으면 Player.currentClub 사용
            if (fromClub == null) {
                fromClub = player.getCurrentClub();
            }
        }

        short season = determineSeason();
        boolean isConfirmation = status != TransferNews.Status.RUMOR;

        // 확정/부인/임차 계열: 기존 RUMOR 업그레이드 우선
        if (isConfirmation && toClub != null) {
            Optional<TransferNews> existingOpt = transferNewsRepository
                    .findFirstByPlayerAndToClubAndSeasonOrderByPublishedAtDesc(player, toClub, season);
            if (existingOpt.isPresent()) {
                TransferNews existing = existingOpt.get();
                if (existing.getStatus() == TransferNews.Status.RUMOR) {
                    existing.updateStatus(status);
                    autoVerify(existing, post, status);
                    syncPlayerClub(player, toClub, status);
                    log.info("[AutoVerify] {} → {} 루머 → {} 자동 확정", result.playerName(), result.toClub(), status);
                }
                return;
            }
        }

        // 루머이고 이미 동일 기록 있으면 중복 스킵 (FA는 toClub=null이므로 체크 스킵)
        if (!isConfirmation && toClub != null && transferNewsRepository.existsByPlayerAndToClubAndSeason(player, toClub, season)) {
            log.debug("[Parsing] 중복 TransferNews 스킵 — player={} toClub={} season={}", result.playerName(), result.toClub(), season);
            return;
        }

        TransferNews news = TransferNews.builder()
                .post(post)
                .player(player)
                .fromClub(fromClub)
                .toClub(toClub)
                .feeEur(result.feeEur())
                .status(status)
                .reliability((byte) 3)
                .season(season)
                .window(determineWindow())
                .publishedAt(post.getPostedAt() != null ? post.getPostedAt() : LocalDateTime.now())
                .build();

        transferNewsRepository.save(news);
        log.info("[Parsing] TransferNews 생성 — {} → {} ({})", result.fromClub(), result.toClub(), result.status());

        if (isConfirmation) {
            autoVerify(news, post, status);
            syncPlayerClub(player, toClub, status);
        }
    }

    private void autoVerify(TransferNews news, Post post, TransferNews.Status status) {
        boolean isConfirmed = status != TransferNews.Status.DENIED;
        String sourceUrl = "https://x.com/" + post.getJournalist().getXHandle() + "/status/" + post.getXPostId();

        Verification existing = verificationRepository.findByTransferNews(news).orElse(null);
        if (existing == null) {
            verificationRepository.save(Verification.builder()
                    .transferNews(news)
                    .isConfirmed(isConfirmed)
                    .confirmedAt(isConfirmed ? LocalDateTime.now() : null)
                    .sourceUrl(sourceUrl)
                    .confirmedBy(post.getJournalist())
                    .build());
        } else {
            existing.update(isConfirmed, sourceUrl, post.getJournalist());
        }
    }

    private void syncPlayerClub(Player player, Club toClub, TransferNews.Status status) {
        switch (status) {
            case CONFIRMED, CONTRACT_EXTENSION -> player.updateCurrentClub(toClub, Player.ContractStatus.CONTRACTED);
            case LOAN -> player.updateCurrentClub(toClub, Player.ContractStatus.LOANED);
            case FREE_AGENT -> player.updateCurrentClub(null, Player.ContractStatus.FREE_AGENT);
            default -> {}
        }
    }

    private Club resolveClub(String name) {
        return clubAliasRepository.findByAliasIgnoreCase(name)
                .map(ClubAlias::getClub)
                .or(() -> clubRepository.findByName(name))
                .orElse(null);
    }

    private TransferNews.Status parseStatus(String raw) {
        if (raw == null) return TransferNews.Status.RUMOR;
        try {
            return TransferNews.Status.valueOf(raw.toUpperCase());
        } catch (IllegalArgumentException e) {
            return TransferNews.Status.RUMOR;
        }
    }

    private Short determineSeason() {
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear() % 100;
        // 3~5월: 다가오는 여름 이적시장(26/27) 기준으로 다음 시즌
        if (month >= 3 && month <= 5) {
            return (short) (year + (year + 1));
        }
        return month >= 7
                ? (short) (year + (year + 1))
                : (short) ((year - 1) + year);
    }

    private TransferNews.TransferWindow determineWindow() {
        int month = LocalDate.now().getMonthValue();
        // 3~5월: 다가오는 여름 이적시장
        if (month >= 3 && month <= 5) return TransferNews.TransferWindow.SUMMER;
        return (month >= 6 && month <= 9)
                ? TransferNews.TransferWindow.SUMMER
                : TransferNews.TransferWindow.WINTER;
    }
}
