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
import transfer.be.model.League;
import transfer.be.model.TransferNews;
import transfer.be.repository.LeagueRepository;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.TransferNewsService;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class NewsControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean LeagueRepository leagueRepository;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    @DisplayName("GET /api/news → 200 페이지네이션 반환")
    void getFeed_200() throws Exception {
        when(transferNewsService.findFeed(any()))
                .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 20), 0));

        mockMvc.perform(get("/api/news"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    @DisplayName("GET /api/news?status=CONFIRMED → status 필터 적용")
    void getFeed_status_필터() throws Exception {
        when(transferNewsService.findByStatusPaged(any(), any()))
                .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 20), 0));

        mockMvc.perform(get("/api/news?status=CONFIRMED"))
                .andExpect(status().isOk());

        verify(transferNewsService).findByStatusPaged(any(TransferNews.Status.class), any());
    }

    @Test
    @DisplayName("GET /api/news?leagueId=1 → 리그 필터 적용")
    void getFeed_leagueId_필터() throws Exception {
        League league = League.builder().id(1L).name("EPL").countryCode("GB").tier(1).build();
        when(leagueRepository.findById(1L)).thenReturn(Optional.of(league));
        when(transferNewsService.findByLeague(any(), any()))
                .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 20), 0));

        mockMvc.perform(get("/api/news?leagueId=1"))
                .andExpect(status().isOk());

        verify(transferNewsService).findByLeague(any(League.class), any());
    }

    @Test
    @DisplayName("GET /api/news?leagueId=999 → 없는 리그면 404")
    void getFeed_없는_리그_404() throws Exception {
        when(leagueRepository.findById(999L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/news?leagueId=999"))
                .andExpect(status().isNotFound());
    }
}
