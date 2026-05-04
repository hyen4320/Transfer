package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.report.ClubActivityItem;
import transfer.be.dto.response.report.FreeAgentItem;
import transfer.be.dto.response.report.LeagueSpendingItem;
import transfer.be.dto.response.report.PositionTrendItem;
import transfer.be.dto.response.report.TopDealItem;
import transfer.be.dto.response.report.TransferFlowItem;
import transfer.be.service.ReportService;

import java.util.List;

@RestController
@RequestMapping("/api/report")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @GetMapping("/league-spending")
    public List<LeagueSpendingItem> leagueSpending(@RequestParam Short season) {
        return reportService.getLeagueSpending(season);
    }

    @GetMapping("/position-trend")
    public List<PositionTrendItem> positionTrend(@RequestParam Short season) {
        return reportService.getPositionTrend(season);
    }

    @GetMapping("/club-activity")
    public List<ClubActivityItem> clubActivity(@RequestParam Short season) {
        return reportService.getClubActivity(season);
    }

    @GetMapping("/transfer-flow")
    public List<TransferFlowItem> transferFlow(@RequestParam Short season) {
        return reportService.getTransferFlow(season);
    }

    @GetMapping("/top-deals")
    public List<TopDealItem> topDeals(@RequestParam Short season) {
        return reportService.getTopDeals(season);
    }

    @GetMapping("/free-agent")
    public List<FreeAgentItem> freeAgent(@RequestParam Short season) {
        return reportService.getFreeAgentLeagues(season);
    }

    @PostMapping("/generate")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void generate(@RequestParam Short season) {
        reportService.generateDataReports(season);
    }
}
