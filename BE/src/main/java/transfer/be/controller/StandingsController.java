package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import transfer.be.dto.response.StandingItem;
import transfer.be.service.FixturesService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/standings")
@RequiredArgsConstructor
public class StandingsController {

    private final FixturesService fixturesService;

    @GetMapping("/{leagueId}")
    public ResponseEntity<List<StandingItem>> getStandings(
            @PathVariable String leagueId,
            @RequestParam(required = false) Integer season) {
        int s = season != null ? season : currentSeason();
        return ResponseEntity.ok(fixturesService.getStandings(leagueId, s));
    }

    private int currentSeason() {
        int year = LocalDate.now().getYear();
        return LocalDate.now().getMonthValue() >= 8 ? year : year - 1;
    }
}
