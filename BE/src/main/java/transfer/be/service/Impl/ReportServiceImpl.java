package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.dto.response.report.ClubActivityItem;
import transfer.be.dto.response.report.FreeAgentItem;
import transfer.be.dto.response.report.LeagueSpendingItem;
import transfer.be.dto.response.report.PositionTrendItem;
import transfer.be.dto.response.report.TopDealItem;
import transfer.be.dto.response.report.TransferFlowItem;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.ReportService;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final TransferNewsRepository transferNewsRepository;

    @Override
    @Transactional(readOnly = true)
    public List<LeagueSpendingItem> getLeagueSpending(Short season) {
        return transferNewsRepository.findLeagueSpendingBySeason(season)
                .stream().map(LeagueSpendingItem::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PositionTrendItem> getPositionTrend(Short season) {
        return transferNewsRepository.findPositionTrendBySeason(season)
                .stream().map(PositionTrendItem::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClubActivityItem> getClubActivity(Short season) {
        return transferNewsRepository.findClubIncomingActivityBySeason(season, PageRequest.of(0, 20))
                .stream().map(ClubActivityItem::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferFlowItem> getTransferFlow(Short season) {
        return transferNewsRepository.findTransferFlowBySeason(season, PageRequest.of(0, 20))
                .stream().map(TransferFlowItem::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<TopDealItem> getTopDeals(Short season) {
        return transferNewsRepository.findTopDealsBySeason(season, PageRequest.of(0, 5))
                .stream().map(TopDealItem::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<FreeAgentItem> getFreeAgentLeagues(Short season) {
        return transferNewsRepository.findFreeAgentLeaguesBySeason(season)
                .stream().map(FreeAgentItem::from).toList();
    }
}
