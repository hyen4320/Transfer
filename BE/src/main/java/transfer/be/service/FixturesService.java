package transfer.be.service;

import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchLineupItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.dto.response.StandingItem;

import java.time.LocalDate;
import java.util.List;

public interface FixturesService {
    List<FixtureItem> getFixtures(String leagueId, String date);
    List<FixtureItem> getFixturesByWeek(String leagueId, int season, LocalDate from);
    List<StandingItem> getStandings(String leagueId, int season);
    List<MatchEventItem> getMatchEvents(long fixtureId);
    MatchStatItem getMatchStats(long fixtureId);
    List<MatchLineupItem> getMatchLineups(long fixtureId);
}
