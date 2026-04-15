package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.ClubResponse;
import transfer.be.dto.response.LeagueResponse;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.League;
import transfer.be.repository.ClubRepository;
import transfer.be.repository.LeagueRepository;
import transfer.be.service.TransferNewsService;

import java.util.List;

@RestController
@RequestMapping("/api/leagues")
@RequiredArgsConstructor
public class LeagueController {

    private final LeagueRepository leagueRepository;
    private final ClubRepository clubRepository;
    private final TransferNewsService transferNewsService;

    /** 5대 리그 목록 */
    @GetMapping
    public List<LeagueResponse> getAll() {
        return leagueRepository.findAll().stream()
                .map(LeagueResponse::from)
                .toList();
    }

    /** 리그 소속 구단 (지도 마커용 lat/lon 포함) */
    @GetMapping("/{id}/clubs")
    public List<ClubResponse> getClubs(@PathVariable Long id) {
        League league = leagueRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("League not found: " + id));
        return clubRepository.findByLeague(league).stream()
                .map(ClubResponse::from)
                .toList();
    }

    /** 리그별 이적 뉴스 (최신순) */
    @GetMapping("/{id}/news")
    public Page<TransferNewsResponse> getNews(
            @PathVariable Long id,
            @PageableDefault(size = 20) Pageable pageable
    ) {
        League league = leagueRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("League not found: " + id));
        return transferNewsService.findByLeague(league, pageable)
                .map(TransferNewsResponse::from);
    }
}
