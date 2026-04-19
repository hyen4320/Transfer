package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.request.TransferNewsSearchCondition;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;
import transfer.be.service.TransferNewsService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/news")
@RequiredArgsConstructor
public class NewsController {

    private final TransferNewsService transferNewsService;

    /**
     * 이적 뉴스 복합 조건 검색
     *
     * ?status=CONFIRMED&season=51&window=SUMMER&leagueId=1
     * &journalistId=1&position=FW&nationality=French
     * &minFeeEur=50000000&maxFeeEur=200000000
     * &from=2025-06-01&to=2025-09-01
     * &toClubId=1&fromClubId=2
     * &minReliability=3&minCredibility=70&verified=true
     */
    @GetMapping
    public Page<TransferNewsResponse> search(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Short season,
            @RequestParam(required = false) String window,
            @RequestParam(required = false) Long leagueId,
            @RequestParam(required = false) Long journalistId,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) Long minFeeEur,
            @RequestParam(required = false) Long maxFeeEur,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(required = false) Long toClubId,
            @RequestParam(required = false) Long fromClubId,
            @RequestParam(required = false) String nationality,
            @RequestParam(required = false) Byte minReliability,
            @RequestParam(required = false) Float minCredibility,
            @RequestParam(required = false) Boolean verified,
            @PageableDefault(size = 20, sort = "publishedAt") Pageable pageable
    ) {
        TransferNewsSearchCondition condition = new TransferNewsSearchCondition(
                status   != null ? TransferNews.Status.valueOf(status.toUpperCase()) : null,
                season,
                window   != null ? TransferNews.TransferWindow.valueOf(window.toUpperCase()) : null,
                leagueId,
                journalistId,
                position != null ? Player.Position.valueOf(position.toUpperCase()) : null,
                minFeeEur,
                maxFeeEur,
                from,
                to,
                toClubId,
                fromClubId,
                nationality,
                minReliability,
                minCredibility,
                verified
        );
        return transferNewsService.search(condition, pageable).map(TransferNewsResponse::from);
    }
}
