package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchLineupItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.dto.response.StandingItem;
import transfer.be.service.FixturesService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/fixtures")
@RequiredArgsConstructor
public class FixturesController {

    private final FixturesService fixturesService;

    /** 특정 날짜 + 리그 경기 목록. date 미지정 시 오늘. */
    @GetMapping
    public ResponseEntity<List<FixtureItem>> getFixtures(
            @RequestParam(defaultValue = "pl") String leagueId,
            @RequestParam(required = false) String date) {
        String targetDate = (date != null && !date.isBlank()) ? date : LocalDate.now().toString();
        return ResponseEntity.ok(fixturesService.getFixtures(leagueId, targetDate));
    }

    /** 특정 주(7일) 경기 목록. from 미지정 시 오늘 기준. */
    @GetMapping("/week")
    public ResponseEntity<List<FixtureItem>> getWeekFixtures(
            @RequestParam(defaultValue = "pl") String leagueId,
            @RequestParam(required = false) Integer season,
            @RequestParam(required = false) String from) {
        int s = season != null ? season : currentSeason();
        LocalDate fromDate = (from != null && !from.isBlank()) ? LocalDate.parse(from) : LocalDate.now();
        return ResponseEntity.ok(fixturesService.getFixturesByWeek(leagueId, s, fromDate));
    }

    @GetMapping("/{fixtureId}/events")
    public ResponseEntity<List<MatchEventItem>> getEvents(@PathVariable long fixtureId) {
        return ResponseEntity.ok(fixturesService.getMatchEvents(fixtureId));
    }

    @GetMapping("/{fixtureId}/stats")
    public ResponseEntity<MatchStatItem> getStats(@PathVariable long fixtureId) {
        MatchStatItem item = fixturesService.getMatchStats(fixtureId);
        return item != null ? ResponseEntity.ok(item) : ResponseEntity.noContent().build();
    }

    @GetMapping("/{fixtureId}/lineups")
    public ResponseEntity<List<MatchLineupItem>> getLineups(@PathVariable long fixtureId) {
        return ResponseEntity.ok(fixturesService.getMatchLineups(fixtureId));
    }

    private int currentSeason() {
        int year = LocalDate.now().getYear();
        return LocalDate.now().getMonthValue() >= 8 ? year : year - 1;
    }
}
