package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.League;
import transfer.be.model.TransferNews;
import transfer.be.repository.LeagueRepository;
import transfer.be.service.TransferNewsService;

@RestController
@RequestMapping("/api/news")
@RequiredArgsConstructor
public class NewsController {

    private final TransferNewsService transferNewsService;
    private final LeagueRepository leagueRepository;

    /**
     * 이적 뉴스 피드 (최신순, 페이지네이션)
     * ?status=CONFIRMED  → 상태 필터
     * ?leagueId=1        → 리그 필터
     */
    @GetMapping
    public Page<TransferNewsResponse> getFeed(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long leagueId,
            @PageableDefault(size = 20, sort = "publishedAt") Pageable pageable
    ) {
        if (status != null) {
            TransferNews.Status s = TransferNews.Status.valueOf(status.toUpperCase());
            return transferNewsService.findByStatusPaged(s, pageable)
                    .map(TransferNewsResponse::from);
        }
        if (leagueId != null) {
            League league = leagueRepository.findById(leagueId)
                    .orElseThrow(() -> new IllegalArgumentException("League not found: " + leagueId));
            return transferNewsService.findByLeague(league, pageable)
                    .map(TransferNewsResponse::from);
        }
        return transferNewsService.findFeed(pageable).map(TransferNewsResponse::from);
    }
}
