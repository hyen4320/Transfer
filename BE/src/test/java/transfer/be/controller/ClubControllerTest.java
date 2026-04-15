package transfer.be.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import transfer.be.model.Club;
import transfer.be.model.League;
import transfer.be.repository.ClubRepository;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.TransferNewsService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class ClubControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean ClubRepository clubRepository;
    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    private Club stubClub() {
        League league = League.builder().id(1L).name("Premier League").countryCode("GB").tier(1).build();
        return Club.builder()
                .id(1L).name("Arsenal").shortName("ARS")
                .city("London").countryCode("GB")
                .latitude(new BigDecimal("51.555")).longitude(new BigDecimal("-0.108"))
                .stadiumName("Emirates Stadium").league(league).build();
    }

    @Test
    @DisplayName("GET /api/clubs/{id} → 200 구단 상세 반환")
    void getById_200() throws Exception {
        when(clubRepository.findById(1L)).thenReturn(Optional.of(stubClub()));

        mockMvc.perform(get("/api/clubs/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Arsenal"))
                .andExpect(jsonPath("$.stadiumName").value("Emirates Stadium"))
                .andExpect(jsonPath("$.leagueName").value("Premier League"));
    }

    @Test
    @DisplayName("GET /api/clubs/{id} → 존재하지 않으면 404")
    void getById_없으면_404() throws Exception {
        when(clubRepository.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/clubs/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Club not found: 99"));
    }

    @Test
    @DisplayName("GET /api/clubs/{id}/transfers → 200 인/아웃 이적 반환")
    void getTransfers_인아웃_200() throws Exception {
        when(clubRepository.findById(1L)).thenReturn(Optional.of(stubClub()));
        when(transferNewsService.findByToClub(any())).thenReturn(List.of());
        when(transferNewsService.findByFromClub(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/clubs/1/transfers"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.incoming").isArray())
                .andExpect(jsonPath("$.outgoing").isArray());
    }
}
