package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.model.Fixture;
import transfer.be.model.MatchEvent;
import transfer.be.model.MatchStat;
import transfer.be.repository.FixtureRepository;
import transfer.be.repository.MatchEventRepository;
import transfer.be.repository.MatchStatRepository;
import transfer.be.service.FixtureStorageService;
import transfer.be.service.FixturesService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class FixtureStorageServiceImpl implements FixtureStorageService {

    private static final List<String> ALL_LEAGUES = List.of("pl", "ll", "bl", "sa", "l1");

    private final FixtureRepository    fixtureRepository;
    private final MatchEventRepository matchEventRepository;
    private final MatchStatRepository  matchStatRepository;
    private final FixturesService      fixturesService;

    @Override
    @Transactional
    public void storeIfFinished(FixtureItem item) {
        if (!"finished".equals(item.getState())) return;
        if (fixtureRepository.existsById(item.getId()))  return;

        Fixture fixture = fixtureRepository.save(Fixture.builder()
                .id(item.getId())
                .leagueId(item.getLeagueId())
                .season(encodedSeason())
                .date(LocalDate.parse(item.getDate()))
                .kickoff(item.getKickoff())
                .homeTeam(item.getHomeTeam())
                .awayTeam(item.getAwayTeam())
                .homeScore(item.getHomeScore())
                .awayScore(item.getAwayScore())
                .matchday(item.getMatchday())
                .venue(item.getVenue())
                .referee(item.getReferee())
                .savedAt(LocalDateTime.now())
                .build());

        saveEvents(fixture);
        saveStat(fixture);

        log.info("Stored fixture {} ({} {} - {} {})",
                fixture.getId(), fixture.getHomeTeam(), fixture.getHomeScore(),
                fixture.getAwayScore(), fixture.getAwayTeam());
    }

    @Override
    public void storeDateFixtures(String leagueId, String date) {
        fixturesService.getFixtures(leagueId, date).forEach(this::storeIfFinished);
    }

    @Override
    public void storeAllLeaguesDate(String date) {
        ALL_LEAGUES.forEach(league -> storeDateFixtures(league, date));
    }

    // ─── private helpers ─────────────────────────────────────────────────────

    private void saveEvents(Fixture fixture) {
        try {
            List<MatchEventItem> items = fixturesService.getMatchEvents(fixture.getId());
            List<MatchEvent> entities = items.stream()
                    .map(e -> MatchEvent.builder()
                            .fixture(fixture)
                            .minute(e.getMinute())
                            .type(e.getType())
                            .teamName(e.getTeamName())
                            .playerName(e.getPlayer())
                            .assistName(e.getAssist())
                            .detail(e.getDetail())
                            .build())
                    .toList();
            matchEventRepository.saveAll(entities);
        } catch (Exception ex) {
            log.warn("events save failed for fixture {}: {}", fixture.getId(), ex.getMessage());
        }
    }

    private void saveStat(Fixture fixture) {
        try {
            MatchStatItem s = fixturesService.getMatchStats(fixture.getId());
            if (s == null) return;
            matchStatRepository.save(MatchStat.builder()
                    .fixture(fixture)
                    .homePossession(s.getPossession()[0])
                    .awayPossession(s.getPossession()[1])
                    .homeShots(s.getShots()[0])
                    .awayShots(s.getShots()[1])
                    .homeShotsOnTarget(s.getShotsOnTarget()[0])
                    .awayShotsOnTarget(s.getShotsOnTarget()[1])
                    .homeXg(s.getXG()[0])
                    .awayXg(s.getXG()[1])
                    .homePasses(s.getPasses()[0])
                    .awayPasses(s.getPasses()[1])
                    .homeCorners(s.getCorners()[0])
                    .awayCorners(s.getCorners()[1])
                    .build());
        } catch (Exception ex) {
            log.warn("stat save failed for fixture {}: {}", fixture.getId(), ex.getMessage());
        }
    }

    /** 프로젝트 시즌 인코딩: 24/25 → 49 (24+25) */
    private int encodedSeason() {
        int year = LocalDate.now().getYear();
        int start = LocalDate.now().getMonthValue() >= 8 ? year : year - 1;
        return (start % 100) + ((start + 1) % 100);
    }
}
