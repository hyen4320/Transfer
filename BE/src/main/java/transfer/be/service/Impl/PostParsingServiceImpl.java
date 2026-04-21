package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.client.ClaudeApiClient;
import transfer.be.client.dto.ParseResult;
import transfer.be.model.*;
import transfer.be.repository.ClubAliasRepository;
import transfer.be.repository.ClubRepository;
import transfer.be.repository.PlayerRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.PostParsingService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostParsingServiceImpl implements PostParsingService {

    private final ClaudeApiClient claudeApiClient;
    private final PlayerRepository playerRepository;
    private final ClubRepository clubRepository;
    private final ClubAliasRepository clubAliasRepository;
    private final TransferNewsRepository transferNewsRepository;

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
        ParseResult result = claudeApiClient.parseTransferTweet(post.getContent());

        if (!result.isTransferNews() || result.playerName() == null || result.toClub() == null) {
            log.debug("[Parsing] post_id={} — 이적 뉴스 아님, 스킵", post.getId());
            return;
        }

        Optional<Player> playerOpt = playerRepository.findByNameIgnoreCase(result.playerName());
        if (playerOpt.isEmpty()) {
            log.info("[Parsing] 선수 미등록: '{}' — 스킵", result.playerName());
            return;
        }

        Club toClub = resolveClub(result.toClub());
        if (toClub == null) {
            log.info("[Parsing] toClub 미등록: '{}' — 스킵", result.toClub());
            return;
        }

        Club fromClub = result.fromClub() != null ? resolveClub(result.fromClub()) : null;

        TransferNews news = TransferNews.builder()
                .post(post)
                .player(playerOpt.get())
                .fromClub(fromClub)
                .toClub(toClub)
                .feeEur(result.feeEur())
                .status(parseStatus(result.status()))
                .reliability((byte) 3)
                .season(determineSeason())
                .window(determineWindow())
                .publishedAt(post.getPostedAt() != null ? post.getPostedAt() : LocalDateTime.now())
                .build();

        transferNewsRepository.save(news);
        log.info("[Parsing] TransferNews 생성 — {} → {} ({})", result.fromClub(), result.toClub(), result.status());
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
        int year = now.getYear() % 100;
        return now.getMonthValue() >= 7
                ? (short) (year + (year + 1))
                : (short) ((year - 1) + year);
    }

    private TransferNews.TransferWindow determineWindow() {
        int month = LocalDate.now().getMonthValue();
        return (month >= 6 && month <= 9)
                ? TransferNews.TransferWindow.SUMMER
                : TransferNews.TransferWindow.WINTER;
    }
}
