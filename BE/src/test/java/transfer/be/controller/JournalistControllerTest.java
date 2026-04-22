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
import transfer.be.exception.NotFoundException;
import transfer.be.model.Journalist;
import transfer.be.scheduler.XCollectorScheduler;
import transfer.be.service.JournalistService;
import transfer.be.service.TransferNewsService;

import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
class JournalistControllerTest {

    @Autowired WebApplicationContext context;
    MockMvc mockMvc;

    @MockitoBean JournalistService journalistService;
    @MockitoBean TransferNewsService transferNewsService;
    @MockitoBean XCollectorScheduler xCollectorScheduler;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    @DisplayName("GET /api/journalists → 200 기자 목록 반환")
    void getAll_200() throws Exception {
        Journalist journalist = Journalist.builder()
                .id(1L).xHandle("FabrizioRomano").name("Fabrizio Romano")
                .followerCount(10_000_000).credibilityScore(92.5f).rank(1).build();
        when(journalistService.findAllByRank()).thenReturn(List.of(journalist));

        mockMvc.perform(get("/api/journalists"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].xHandle").value("FabrizioRomano"))
                .andExpect(jsonPath("$[0].rank").value(1));
    }

    @Test
    @DisplayName("GET /api/journalists/{id} → 200 기자 상세 반환")
    void getById_200() throws Exception {
        Journalist journalist = Journalist.builder()
                .id(1L).xHandle("Romano").name("Fabrizio Romano")
                .followerCount(10_000_000).credibilityScore(90f).rank(1).build();
        when(journalistService.findById(1L)).thenReturn(journalist);

        mockMvc.perform(get("/api/journalists/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("Fabrizio Romano"));
    }

    @Test
    @DisplayName("GET /api/journalists/{id} → 존재하지 않으면 404")
    void getById_없으면_404() throws Exception {
        when(journalistService.findById(99L))
                .thenThrow(new NotFoundException("Journalist not found: 99"));

        mockMvc.perform(get("/api/journalists/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Journalist not found: 99"));
    }

    @Test
    @DisplayName("GET /api/journalists/{id}/news → 200 이적 뉴스 목록")
    void getNews_200() throws Exception {
        Journalist journalist = Journalist.builder()
                .id(1L).xHandle("Romano").name("Romano").credibilityScore(0f).build();
        when(journalistService.findById(1L)).thenReturn(journalist);
        when(transferNewsService.findByJournalist(journalist)).thenReturn(List.of());

        mockMvc.perform(get("/api/journalists/1/news"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }
}
