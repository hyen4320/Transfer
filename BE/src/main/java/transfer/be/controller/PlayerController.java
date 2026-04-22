package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.PlayerResponse;
import transfer.be.exception.NotFoundException;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.Player;
import transfer.be.repository.PlayerRepository;
import transfer.be.service.TransferNewsService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/players")
@RequiredArgsConstructor
public class PlayerController {

    private final PlayerRepository playerRepository;
    private final TransferNewsService transferNewsService;

    /** 선수 상세 */
    @GetMapping("/{id}")
    public PlayerResponse getById(@PathVariable Long id) {
        Player player = playerRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Player not found: " + id));
        return PlayerResponse.from(player);
    }

    /** 선수 이름 자동완성 검색 */
    @GetMapping("/search")
    public List<PlayerResponse> search(
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "8") int size
    ) {
        if (q.isBlank()) return List.of();
        return playerRepository.findByNameContainingIgnoreCase(q, PageRequest.of(0, size))
                .stream().map(PlayerResponse::from).toList();
    }

    /** 계약 만료 임박 선수 목록 (기본 6개월 이내) */
    @GetMapping("/expiring")
    public List<PlayerResponse> getExpiring(@RequestParam(defaultValue = "6") int months) {
        LocalDate from = LocalDate.now();
        LocalDate to   = from.plusMonths(months);
        return playerRepository.findByContractUntilBetweenOrderByContractUntilAsc(from, to)
                .stream().map(PlayerResponse::from).toList();
    }

    /** 선수 이적 히스토리 */
    @GetMapping("/{id}/transfers")
    public List<TransferNewsResponse> getTransfers(@PathVariable Long id) {
        Player player = playerRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Player not found: " + id));
        return transferNewsService.findByPlayer(player).stream()
                .map(TransferNewsResponse::from)
                .toList();
    }
}
