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
import transfer.be.model.Club;
import transfer.be.model.League;
import transfer.be.repository.ClubRepository;
import transfer.be.repository.LeagueRepository;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.TransferNewsService;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class LeagueControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean LeagueRepository leagueRepository;
    @MockitoBean ClubRepository clubRepository;
    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    private League league(Long id, String name, String country) {
        return League.builder().id(id).name(name).countryCode(country).tier(1).build();
    }

    @Test
    @DisplayName("GET /api/leagues → 200 전체 리그 목록")
    void getAll_200() throws Exception {
        when(leagueRepository.findAll()).thenReturn(List.of(
                league(1L, "Premier League", "GB"),
                league(2L, "La Liga", "ES"),
                league(3L, "Bundesliga", "DE")
        ));

        mockMvc.perform(get("/api/leagues"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(3))
                .andExpect(jsonPath("$[0].name").value("Premier League"))
                .andExpect(jsonPath("$[1].countryCode").value("ES"));
    }

    @Test
    @DisplayName("GET /api/leagues/{id}/clubs → 200 리그 소속 구단 반환")
    void getClubs_200() throws Exception {
        League epl = league(1L, "Premier League", "GB");
        when(leagueRepository.findById(1L)).thenReturn(Optional.of(epl));
        when(clubRepository.findByLeague(epl)).thenReturn(List.of(
                Club.builder().id(1L).name("Arsenal").countryCode("GB").league(epl).build(),
                Club.builder().id(2L).name("Chelsea").countryCode("GB").league(epl).build()
        ));

        mockMvc.perform(get("/api/leagues/1/clubs"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].name").value("Arsenal"));
    }

    @Test
    @DisplayName("GET /api/leagues/{id}/clubs → 없는 리그면 404")
    void getClubs_없는_리그_404() throws Exception {
        when(leagueRepository.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/leagues/99/clubs"))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /api/leagues/{id}/news → 200 리그별 이적 뉴스")
    void getNews_200() throws Exception {
        League epl = league(1L, "Premier League", "GB");
        when(leagueRepository.findById(1L)).thenReturn(Optional.of(epl));
        when(transferNewsService.findByLeague(any(), any()))
                .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 20), 0));

        mockMvc.perform(get("/api/leagues/1/news"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(0));
    }
}
