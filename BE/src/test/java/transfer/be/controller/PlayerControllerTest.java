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
import transfer.be.model.Player;
import transfer.be.repository.PlayerRepository;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.TransferNewsService;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class PlayerControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean PlayerRepository playerRepository;
    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    private Player stubPlayer() {
        League league = League.builder().id(1L).name("EPL").countryCode("GB").tier(1).build();
        Club club = Club.builder().id(1L).name("Arsenal").countryCode("GB").league(league).build();
        return Player.builder()
                .id(1L).name("Bukayo Saka").nationality("English")
                .position(Player.Position.FW).currentClub(club)
                .contractUntil(LocalDate.of(2027, 6, 30)).build();
    }

    @Test
    @DisplayName("GET /api/players/{id} → 200 선수 상세 반환")
    void getById_200() throws Exception {
        when(playerRepository.findById(1L)).thenReturn(Optional.of(stubPlayer()));

        mockMvc.perform(get("/api/players/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Bukayo Saka"))
                .andExpect(jsonPath("$.position").value("FW"))
                .andExpect(jsonPath("$.currentClubName").value("Arsenal"))
                .andExpect(jsonPath("$.contractUntil").value("2027-06-30"));
    }

    @Test
    @DisplayName("GET /api/players/{id} → 존재하지 않으면 404")
    void getById_없으면_404() throws Exception {
        when(playerRepository.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/players/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Player not found: 99"));
    }

    @Test
    @DisplayName("GET /api/players/{id}/transfers → 200 이적 히스토리 반환")
    void getTransfers_200() throws Exception {
        Player player = stubPlayer();
        when(playerRepository.findById(1L)).thenReturn(Optional.of(player));
        when(transferNewsService.findByPlayer(player)).thenReturn(List.of());

        mockMvc.perform(get("/api/players/1/transfers"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }
}
