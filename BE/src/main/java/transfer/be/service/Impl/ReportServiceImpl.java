package transfer.be.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import transfer.be.model.EditorialReport;
import transfer.be.repository.EditorialReportRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.ReportService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final TransferNewsRepository transferNewsRepository;
    private final EditorialReportRepository editorialReportRepository;
    private final ObjectMapper objectMapper;

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

    @Override
    @Transactional
    public void generateDataReports(Short season) {
        editorialReportRepository.deleteByTypeAndTagsContaining(EditorialReport.ReportType.DATA, "season:" + season);

        var league   = transferNewsRepository.findLeagueSpendingBySeason(season).stream().map(LeagueSpendingItem::from).toList();
        var position = transferNewsRepository.findPositionTrendBySeason(season).stream().map(PositionTrendItem::from).toList();
        var club     = transferNewsRepository.findClubIncomingActivityBySeason(season, PageRequest.of(0, 20)).stream().map(ClubActivityItem::from).toList();
        var flow     = transferNewsRepository.findTransferFlowBySeason(season, PageRequest.of(0, 20)).stream().map(TransferFlowItem::from).toList();
        var deals    = transferNewsRepository.findTopDealsBySeason(season, PageRequest.of(0, 5)).stream().map(TopDealItem::from).toList();
        var fa       = transferNewsRepository.findFreeAgentLeaguesBySeason(season).stream().map(FreeAgentItem::from).toList();

        String label = seasonLabel(season);

        List<EditorialReport> reports = new ArrayList<>();
        reports.add(build(season, "league-spending",  "Which League Is Spending the Most?",  leagueDeck(league, label),   "blue",     "bars",  "dashboard", 0.94f, 4, league));
        reports.add(build(season, "top-deals",        "The Biggest Confirmed Deals",          dealsDeck(deals, label),     "amber",    "orbit", "dashboard", 0.97f, 3, deals));
        reports.add(build(season, "position-trends",  "What Position Is the Market Chasing?", positionDeck(position, label),"graphite","grid",  "brief",     0.91f, 2, position));
        reports.add(build(season, "club-activity",    "Who Is Signing the Most Players?",     clubDeck(club, label),       "gold",     "bars",  "brief",     0.89f, 3, club));
        reports.add(build(season, "transfer-flow",    "How Are Players Crossing Borders?",    flowDeck(flow, label),       "sky",      "lines", "dashboard", 0.88f, 3, flow));
        reports.add(build(season, "free-agents",      "How Big Is the Free Agent Market?",    faDeck(fa, label),           "crimson",  "orbit", "brief",     0.93f, 2, fa));

        editorialReportRepository.saveAll(reports);
    }

    private EditorialReport build(Short season, String category, String title, String deck,
                                  String tone, String motif, String format,
                                  float confidence, int readMinutes, Object data) {
        String tags = "data-auto," + category + ",season:" + season;
        String blocks;
        try {
            blocks = objectMapper.writeValueAsString(List.of(Map.of(
                    "id", category + "-" + season,
                    "kind", "data-raw",
                    "category", category,
                    "items", data
            )));
        } catch (Exception e) {
            blocks = "[]";
        }
        EditorialReport.ReportFormat fmt = switch (format) {
            case "dashboard" -> EditorialReport.ReportFormat.DASHBOARD;
            case "brief"     -> EditorialReport.ReportFormat.BRIEF;
            default          -> EditorialReport.ReportFormat.LONGFORM;
        };
        return EditorialReport.builder()
                .title(title)
                .deck(deck)
                .type(EditorialReport.ReportType.DATA)
                .format(fmt)
                .classification(EditorialReport.Classification.OPEN_SOURCE)
                .confidence(confidence)
                .readMinutes(readMinutes)
                .coverTone(tone)
                .coverMotif(motif)
                .tags(tags)
                .blocks(blocks)
                .status(EditorialReport.ReportStatus.PUBLISHED)
                .createdAt(LocalDateTime.now())
                .publishedAt(LocalDateTime.now())
                .build();
    }

    private String seasonLabel(short season) {
        int y1 = (season - 1) / 2;
        int y2 = (season + 1) / 2;
        return String.format("%02d/%02d", y1, y2);
    }

    private String fmtEur(long eur) {
        if (eur == 0) return "—";
        if (eur >= 1_000_000_000) return String.format("€%.1fB", eur / 1_000_000_000.0);
        if (eur >= 1_000_000)     return String.format("€%.0fM", eur / 1_000_000.0);
        return String.format("€%.0fK", eur / 1_000.0);
    }

    private String leagueDeck(List<LeagueSpendingItem> data, String label) {
        if (data.isEmpty()) return "Cross-league spending data for the " + label + " transfer window.";
        var top = data.get(0);
        return top.leagueName() + " leads the " + label + " window with " + fmtEur(top.totalFeeEur())
                + " across " + top.count() + " confirmed deal" + (top.count() != 1 ? "s" : "")
                + " — the biggest single-league commitment so far.";
    }

    private String dealsDeck(List<TopDealItem> data, String label) {
        if (data.isEmpty()) return "The top confirmed transfer deals of the " + label + " season, ranked by fee.";
        var top = data.get(0);
        String from = top.fromClubName() != null ? top.fromClubName() : "a free transfer";
        return top.playerName() + " tops the " + label + " window at " + fmtEur(top.feeEur())
                + ", moving from " + from + " to " + top.toClubName() + ". Five biggest confirmed deals charted.";
    }

    private String positionDeck(List<PositionTrendItem> data, String label) {
        if (data.isEmpty()) return "Positional demand breakdown across all top-five league clubs in " + label + ".";
        var top = data.get(0);
        long total = data.stream().mapToLong(PositionTrendItem::count).sum();
        Map<String, String> posLabel = Map.of("GK", "Goalkeeper", "DF", "Defender", "MF", "Midfielder", "FW", "Forward");
        String posName = posLabel.getOrDefault(top.position(), top.position()) + "s";
        int pct = total > 0 ? (int) Math.round(top.count() * 100.0 / total) : 0;
        return posName + " dominate the " + label + " transfer market, accounting for " + pct + "% of all reported activity.";
    }

    private String clubDeck(List<ClubActivityItem> data, String label) {
        if (data.isEmpty()) return "Club-by-club recruitment activity ranked by incoming transfer reports in " + label + ".";
        var top = data.get(0);
        return top.clubName() + " leads all clubs with " + top.incomingCount()
                + " incoming transfers in " + label + " — more than any other team in Europe's top five leagues.";
    }

    private String flowDeck(List<TransferFlowItem> data, String label) {
        if (data.isEmpty()) return "Cross-border transfer corridors mapped across European football in " + label + ".";
        var top = data.get(0);
        return "The " + top.fromCountryCode().toUpperCase() + " → " + top.toCountryCode().toUpperCase()
                + " corridor is the busiest cross-border route of the " + label + " window with " + top.count() + " reported moves.";
    }

    private String faDeck(List<FreeAgentItem> data, String label) {
        long total = data.stream().mapToLong(FreeAgentItem::count).sum();
        if (total == 0) return "Free agent transfer activity across Europe's top five leagues in " + label + ".";
        return total + " free agent signings reported across the " + label
                + " window — clubs strengthening without paying transfer fees, a trend rising across all five leagues.";
    }
}
