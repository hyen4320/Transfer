package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;
import transfer.be.repository.PlayerRepository;
import transfer.be.repository.TransferNewsRepository;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final PlayerRepository playerRepository;
    private final TransferNewsRepository transferNewsRepository;

    /** 인터셉터가 통과시켜야 도달 — 토큰 유효성 검증 */
    @GetMapping("/verify")
    public Map<String, String> verify() {
        return Map.of("status", "ok");
    }

    /**
     * 모든 선수의 currentClub을 최근 TransferNews 기준으로 동기화.
     * CONFIRMED → LOAN → 나머지 순으로 우선순위를 매겨 가장 최근 구단을 적용.
     */
    @PostMapping("/sync-player-clubs")
    @Transactional
    public Map<String, Object> syncPlayerClubs() {
        List<Player> players = playerRepository.findAll();
        int updated = 0;

        for (Player player : players) {
            List<TransferNews> history = transferNewsRepository.findByPlayerOrderByPublishedAtDesc(player);
            if (history.isEmpty()) continue;

            // CONFIRMED → LOAN → RUMOR 순으로 최우선 뉴스 선택
            TransferNews best = history.stream()
                    .filter(n -> n.getStatus() == TransferNews.Status.CONFIRMED)
                    .findFirst()
                    .or(() -> history.stream()
                            .filter(n -> n.getStatus() == TransferNews.Status.LOAN)
                            .findFirst())
                    .or(() -> history.stream().findFirst())
                    .orElse(null);

            if (best == null || best.getToClub() == null) continue;

            Player.ContractStatus contractStatus = switch (best.getStatus()) {
                case LOAN -> Player.ContractStatus.LOANED;
                case CONFIRMED, CONTRACT_EXTENSION -> Player.ContractStatus.CONTRACTED;
                default -> Player.ContractStatus.CONTRACTED;
            };

            player.updateCurrentClub(best.getToClub(), contractStatus);
            updated++;
            log.info("[AdminSync] {} → {} ({})", player.getName(), best.getToClub().getName(), contractStatus);
        }

        return Map.of("total", players.size(), "updated", updated);
    }
}
