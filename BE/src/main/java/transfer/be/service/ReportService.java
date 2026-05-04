package transfer.be.service;

import transfer.be.dto.response.report.ClubActivityItem;
import transfer.be.dto.response.report.FreeAgentItem;
import transfer.be.dto.response.report.LeagueSpendingItem;
import transfer.be.dto.response.report.PositionTrendItem;
import transfer.be.dto.response.report.TopDealItem;
import transfer.be.dto.response.report.TransferFlowItem;

import java.util.List;

public interface ReportService {
    List<LeagueSpendingItem> getLeagueSpending(Short season);
    List<PositionTrendItem> getPositionTrend(Short season);
    List<ClubActivityItem> getClubActivity(Short season);
    List<TransferFlowItem> getTransferFlow(Short season);
    List<TopDealItem> getTopDeals(Short season);
    List<FreeAgentItem> getFreeAgentLeagues(Short season);
    void generateDataReports(Short season);
}
