package transfer.be.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchLineupItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.dto.response.LineupPlayerItem;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.FixturesService;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class FixturesControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean FixturesService fixturesService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    private FixtureItem sampleFixture;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

        sampleFixture = FixtureItem.builder()
                .id(123L)
                .leagueId("pl")
                .date("2026-05-15")
                .kickoff("20:00")
                .state("scheduled")
                .minute(0)
                .homeTeam("Arsenal")
                .awayTeam("Liverpool")
                .homeScore(null)
                .awayScore(null)
                .matchday(37)
                .venue("Emirates Stadium")
                .referee("Anthony Taylor")
                .build();

        when(fixturesService.getFixtures(anyString(), anyString()))
                .thenReturn(List.of(sampleFixture));
        when(fixturesService.getFixturesByWeek(anyString(), anyInt(), any(java.time.LocalDate.class)))
                .thenReturn(List.of(sampleFixture));
        when(fixturesService.getMatchEvents(anyLong()))
                .thenReturn(List.of());
        when(fixturesService.getMatchStats(anyLong()))
                .thenReturn(null);
        when(fixturesService.getMatchLineups(anyLong()))
                .thenReturn(List.of());
    }

    // ─── GET /api/fixtures ────────────────────────────────────────────────────

    @Test
    @DisplayName("GET /api/fixtures → 200, 기본 leagueId=pl 적용")
    void getFixtures_기본값_200() throws Exception {
        mockMvc.perform(get("/api/fixtures"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(123))
                .andExpect(jsonPath("$[0].leagueId").value("pl"))
                .andExpect(jsonPath("$[0].homeTeam").value("Arsenal"))
                .andExpect(jsonPath("$[0].awayTeam").value("Liverpool"));
    }

    @Test
    @DisplayName("GET /api/fixtures?leagueId=ll&date=2026-05-15 → 200")
    void getFixtures_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/fixtures")
                        .param("leagueId", "ll")
                        .param("date", "2026-05-15"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    @DisplayName("GET /api/fixtures — 서비스 빈 목록 반환 시 200 빈 배열")
    void getFixtures_빈목록_200() throws Exception {
        when(fixturesService.getFixtures(anyString(), anyString())).thenReturn(List.of());
        mockMvc.perform(get("/api/fixtures"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(0));
    }

    // ─── GET /api/fixtures/week ───────────────────────────────────────────────

    @Test
    @DisplayName("GET /api/fixtures/week → 200, 기본 leagueId=pl")
    void getWeekFixtures_기본값_200() throws Exception {
        mockMvc.perform(get("/api/fixtures/week"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].state").value("scheduled"));
    }

    @Test
    @DisplayName("GET /api/fixtures/week?leagueId=bl&season=2025 → 200")
    void getWeekFixtures_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/fixtures/week")
                        .param("leagueId", "bl")
                        .param("season", "2025"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    // ─── GET /api/fixtures/{id}/events ───────────────────────────────────────

    @Test
    @DisplayName("GET /api/fixtures/123/events → 200 빈 배열 (경기 전)")
    void getEvents_빈배열_200() throws Exception {
        mockMvc.perform(get("/api/fixtures/123/events"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    @DisplayName("GET /api/fixtures/123/events → 200, 이벤트 포함")
    void getEvents_이벤트포함_200() throws Exception {
        MatchEventItem goal = MatchEventItem.builder()
                .minute(45)
                .type("goal")
                .teamName("Arsenal")
                .player("Saka")
                .assist("Odegaard")
                .detail("Normal Goal")
                .build();
        when(fixturesService.getMatchEvents(123L)).thenReturn(List.of(goal));

        mockMvc.perform(get("/api/fixtures/123/events"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].type").value("goal"))
                .andExpect(jsonPath("$[0].minute").value(45))
                .andExpect(jsonPath("$[0].player").value("Saka"));
    }

    // ─── GET /api/fixtures/{id}/stats ────────────────────────────────────────

    @Test
    @DisplayName("GET /api/fixtures/123/stats → 204 (통계 없음)")
    void getStats_없음_204() throws Exception {
        mockMvc.perform(get("/api/fixtures/123/stats"))
                .andDo(print())
                .andExpect(status().isNoContent());
    }

    @Test
    @DisplayName("GET /api/fixtures/123/stats → 200, 통계 포함")
    void getStats_있음_200() throws Exception {
        MatchStatItem stats = MatchStatItem.builder()
                .possession(new int[]{55, 45})
                .shots(new int[]{14, 8})
                .shotsOnTarget(new int[]{6, 3})
                .xG(new double[]{1.8, 0.9})
                .passes(new int[]{520, 380})
                .corners(new int[]{7, 3})
                .build();
        when(fixturesService.getMatchStats(123L)).thenReturn(stats);

        mockMvc.perform(get("/api/fixtures/123/stats"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.possession").isArray())
                .andExpect(jsonPath("$.shots").isArray());
    }

    // ─── GET /api/fixtures/{id}/lineups ──────────────────────────────────────

    @Test
    @DisplayName("GET /api/fixtures/123/lineups → 200 빈 배열 (미확정)")
    void getLineups_빈배열_200() throws Exception {
        mockMvc.perform(get("/api/fixtures/123/lineups"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    @DisplayName("GET /api/fixtures/123/lineups → 200, 라인업 포함")
    void getLineups_있음_200() throws Exception {
        LineupPlayerItem player = LineupPlayerItem.builder()
                .name("Raya").number(22).pos("G").grid("1:1").build();
        MatchLineupItem lineup = MatchLineupItem.builder()
                .teamName("Arsenal")
                .formation("4-3-3")
                .startXI(List.of(player))
                .substitutes(List.of())
                .build();
        when(fixturesService.getMatchLineups(123L)).thenReturn(List.of(lineup));

        mockMvc.perform(get("/api/fixtures/123/lineups"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].teamName").value("Arsenal"))
                .andExpect(jsonPath("$[0].formation").value("4-3-3"))
                .andExpect(jsonPath("$[0].startXI[0].name").value("Raya"));
    }
}
