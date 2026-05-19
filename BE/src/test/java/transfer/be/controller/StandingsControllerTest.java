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
import transfer.be.dto.response.StandingItem;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.FixturesService;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class StandingsControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean FixturesService fixturesService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

        List<StandingItem> sample = List.of(
                StandingItem.builder().rank(1).teamName("Arsenal")
                        .played(36).won(25).drawn(7).lost(4)
                        .goalsFor(84).goalsAgainst(35).goalsDiff(49)
                        .points(82).form("WWWDL").build(),
                StandingItem.builder().rank(2).teamName("Liverpool")
                        .played(36).won(24).drawn(5).lost(7)
                        .goalsFor(79).goalsAgainst(38).goalsDiff(41)
                        .points(77).form("LWWWD").build()
        );
        when(fixturesService.getStandings(anyString(), anyInt())).thenReturn(sample);
    }

    @Test
    @DisplayName("GET /api/standings/pl → 200, 순위표 반환")
    void getStandings_pl_200() throws Exception {
        mockMvc.perform(get("/api/standings/pl"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].rank").value(1))
                .andExpect(jsonPath("$[0].teamName").value("Arsenal"))
                .andExpect(jsonPath("$[0].points").value(82))
                .andExpect(jsonPath("$[0].form").value("WWWDL"));
    }

    @Test
    @DisplayName("GET /api/standings/ll → 200")
    void getStandings_ll_200() throws Exception {
        mockMvc.perform(get("/api/standings/ll"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    @DisplayName("GET /api/standings/pl?season=2025 → 200")
    void getStandings_season_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/standings/pl").param("season", "2025"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    @DisplayName("GET /api/standings/pl → 응답 필드 검증 (goalsDiff, played, won, drawn, lost)")
    void getStandings_필드검증_200() throws Exception {
        mockMvc.perform(get("/api/standings/pl"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].played").value(36))
                .andExpect(jsonPath("$[0].won").value(25))
                .andExpect(jsonPath("$[0].drawn").value(7))
                .andExpect(jsonPath("$[0].lost").value(4))
                .andExpect(jsonPath("$[0].goalsDiff").value(49));
    }

    @Test
    @DisplayName("GET /api/standings/pl → 빈 목록 반환 시 200 빈 배열")
    void getStandings_빈목록_200() throws Exception {
        when(fixturesService.getStandings(anyString(), anyInt())).thenReturn(List.of());
        mockMvc.perform(get("/api/standings/pl"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    @DisplayName("GET /api/standings/pl → 2위 항목 확인")
    void getStandings_2위항목_200() throws Exception {
        mockMvc.perform(get("/api/standings/pl"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[1].rank").value(2))
                .andExpect(jsonPath("$[1].teamName").value("Liverpool"))
                .andExpect(jsonPath("$[1].points").value(77));
    }
}
