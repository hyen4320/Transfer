package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.ClubResponse;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.Club;
import transfer.be.repository.ClubRepository;
import transfer.be.service.TransferNewsService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/clubs")
@RequiredArgsConstructor
public class ClubController {

    private final ClubRepository clubRepository;
    private final TransferNewsService transferNewsService;

    /** 구단 상세 */
    @GetMapping("/{id}")
    public ClubResponse getById(@PathVariable Long id) {
        Club club = clubRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Club not found: " + id));
        return ClubResponse.from(club);
    }

    /** 구단 이적 인/아웃 */
    @GetMapping("/{id}/transfers")
    public Map<String, List<TransferNewsResponse>> getTransfers(@PathVariable Long id) {
        Club club = clubRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Club not found: " + id));

        List<TransferNewsResponse> incoming = transferNewsService.findByToClub(club).stream()
                .map(TransferNewsResponse::from)
                .toList();
        List<TransferNewsResponse> outgoing = transferNewsService.findByFromClub(club).stream()
                .map(TransferNewsResponse::from)
                .toList();

        return Map.of("incoming", incoming, "outgoing", outgoing);
    }
}
