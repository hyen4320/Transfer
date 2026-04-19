package transfer.be.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.TransferNewsService;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class NewsControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
        when(transferNewsService.search(any(), any()))
                .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 20), 0));
    }

    @Test
    @DisplayName("GET /api/news → 200 빈 페이지 반환")
    void getFeed_200() throws Exception {
        mockMvc.perform(get("/api/news"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    @DisplayName("GET /api/news?status=CONFIRMED → 200")
    void status_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/news?status=CONFIRMED"))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("GET /api/news?status=INVALID → 400")
    void status_잘못된값_400() throws Exception {
        mockMvc.perform(get("/api/news?status=INVALID"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/news?season=51&window=SUMMER → 200")
    void season_window_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/news?season=51&window=SUMMER"))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("GET /api/news?window=INVALID → 400")
    void window_잘못된값_400() throws Exception {
        mockMvc.perform(get("/api/news?window=INVALID"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/news?position=FW&minFeeEur=50000000 → 200")
    void position_fee_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/news?position=FW&minFeeEur=50000000"))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("GET /api/news?from=2025-06-01&to=2025-09-01 → 200")
    void date_범위_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/news?from=2025-06-01&to=2025-09-01"))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("전체 파라미터 조합 → 200")
    void 전체_파라미터_200() throws Exception {
        mockMvc.perform(get("/api/news")
                        .param("status", "CONFIRMED")
                        .param("season", "51")
                        .param("window", "SUMMER")
                        .param("leagueId", "1")
                        .param("journalistId", "1")
                        .param("position", "FW")
                        .param("nationality", "English")
                        .param("minFeeEur", "50000000")
                        .param("maxFeeEur", "200000000")
                        .param("from", "2025-06-01")
                        .param("to", "2025-09-01")
                        .param("toClubId", "1")
                        .param("fromClubId", "2")
                        .param("minReliability", "3")
                        .param("minCredibility", "70")
                        .param("verified", "true"))
                .andExpect(status().isOk());
    }
}
