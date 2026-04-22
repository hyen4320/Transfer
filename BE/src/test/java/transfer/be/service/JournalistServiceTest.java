package transfer.be.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import transfer.be.api.XApiClient;
import transfer.be.api.dto.XUserResponse;
import transfer.be.exception.NotFoundException;
import transfer.be.model.Journalist;
import transfer.be.repository.JournalistRepository;
import transfer.be.service.impl.JournalistServiceImpl;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class JournalistServiceTest {

    @Mock JournalistRepository journalistRepository;
    @Mock XApiClient xApiClient;
    @InjectMocks JournalistServiceImpl journalistService;

    @Test
    @DisplayName("findAllByRank는 레포지토리에 위임한다")
    void findAllByRank_레포지토리_위임() {
        List<Journalist> expected = List.of(
                Journalist.builder().xHandle("a").name("A").credibilityScore(90f).rank(1).build(),
                Journalist.builder().xHandle("b").name("B").credibilityScore(60f).rank(2).build()
        );
        when(journalistRepository.findAllByOrderByRankAsc()).thenReturn(expected);

        List<Journalist> result = journalistService.findAllByRank();

        assertThat(result).isEqualTo(expected);
        verify(journalistRepository).findAllByOrderByRankAsc();
    }

    @Test
    @DisplayName("findById에서 없는 ID는 IllegalArgumentException을 던진다")
    void findById_없는ID_예외() {
        when(journalistRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> journalistService.findById(99L))
                .isInstanceOf(NotFoundException.class)
                .hasMessageContaining("Journalist not found: 99");
    }

    @Test
    @DisplayName("findOrRegisterByXHandle은 기존 기자가 있으면 X API를 호출하지 않는다")
    void findOrRegisterByXHandle_기존_기자_반환() {
        Journalist existing = Journalist.builder().xHandle("Romano").name("Romano").credibilityScore(0f).build();
        when(journalistRepository.findByXHandle("Romano")).thenReturn(Optional.of(existing));

        Journalist result = journalistService.findOrRegisterByXHandle("Romano");

        assertThat(result.getXHandle()).isEqualTo("Romano");
        verify(xApiClient, never()).getUserByUsername(any());
    }

    @Test
    @DisplayName("findOrRegisterByXHandle은 신규 기자면 X API에서 등록한다")
    void findOrRegisterByXHandle_신규_기자_등록() {
        when(journalistRepository.findByXHandle("newHandle")).thenReturn(Optional.empty());

        XUserResponse.PublicMetrics metrics = new XUserResponse.PublicMetrics(5_000_000, 500, 30000);
        XUserResponse.XUser xUser = new XUserResponse.XUser("123", "New Reporter", "newHandle", "http://img", metrics);
        when(xApiClient.getUserByUsername("newHandle")).thenReturn(new XUserResponse(xUser));
        when(journalistRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Journalist result = journalistService.findOrRegisterByXHandle("newHandle");

        assertThat(result.getXHandle()).isEqualTo("newHandle");
        assertThat(result.getFollowerCount()).isEqualTo(5_000_000);
        verify(journalistRepository).save(any(Journalist.class));
    }

    @Test
    @DisplayName("updateCredibilityScore는 id를 포함해 저장한다 (INSERT 버그 방지)")
    void updateCredibilityScore_id_포함_저장() {
        Journalist existing = Journalist.builder()
                .id(1L).xHandle("Romano").name("Romano")
                .credibilityScore(50f).rank(2).build();
        when(journalistRepository.findById(1L)).thenReturn(Optional.of(existing));

        journalistService.updateCredibilityScore(1L, 80f);

        ArgumentCaptor<Journalist> captor = ArgumentCaptor.forClass(Journalist.class);
        verify(journalistRepository).save(captor.capture());

        Journalist saved = captor.getValue();
        assertThat(saved.getId()).isEqualTo(1L);          // id 포함 → UPDATE
        assertThat(saved.getCredibilityScore()).isEqualTo(80f);
        verify(journalistRepository).updateAllRanks();
    }
}
