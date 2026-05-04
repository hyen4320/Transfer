package transfer.be.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import transfer.be.exception.NotFoundException;
import transfer.be.model.*;
import transfer.be.repository.JournalistRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.repository.VerificationRepository;
import transfer.be.service.impl.TransferNewsServiceImpl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TransferNewsServiceTest {

    @Mock TransferNewsRepository transferNewsRepository;
    @Mock VerificationRepository verificationRepository;
    @Mock JournalistRepository journalistRepository;
    @InjectMocks TransferNewsServiceImpl transferNewsService;

    @Test
    @DisplayName("findById에서 없는 ID는 예외를 던진다")
    void findById_없는ID_예외() {
        when(transferNewsRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> transferNewsService.findById(99L))
                .isInstanceOf(NotFoundException.class)
                .hasMessageContaining("TransferNews not found: 99");
    }

    @Test
    @DisplayName("updateStatus는 엔티티 status 필드를 직접 변경한다")
    void updateStatus_엔티티_status_변경() {
        Journalist journalist = Journalist.builder().id(1L).xHandle("Romano").name("Romano").credibilityScore(0f).build();
        Post post = Post.builder().id(1L).journalist(journalist).xPostId("tweet-1").content("news").build();
        Club toClub = Club.builder().id(1L).name("Arsenal").countryCode("GB")
                .league(League.builder().id(1L).name("EPL").countryCode("GB").tier(1).build()).build();
        Player player = Player.builder().id(1L).name("Saka").nationality("EN").build();

        TransferNews existing = TransferNews.builder()
                .id(5L).post(post).player(player).toClub(toClub)
                .status(TransferNews.Status.RUMOR)
                .publishedAt(LocalDateTime.now()).build();

        when(transferNewsRepository.findById(5L)).thenReturn(Optional.of(existing));

        transferNewsService.updateStatus(5L, TransferNews.Status.CONFIRMED);

        // dirty checking으로 처리 — save() 불필요, 엔티티 status만 검증
        assertThat(existing.getStatus()).isEqualTo(TransferNews.Status.CONFIRMED);
        verify(transferNewsRepository).findById(5L);
    }

    @Test
    @DisplayName("findFeed는 publishedAt 내림차순 페이지를 반환한다")
    void findFeed_페이지네이션() {
        Pageable pageable = PageRequest.of(0, 20);
        Page<TransferNews> expected = new PageImpl<>(List.of(), pageable, 0);
        when(transferNewsRepository.findAllByOrderByPublishedAtDesc(pageable)).thenReturn(expected);

        Page<TransferNews> result = transferNewsService.findFeed(pageable);

        assertThat(result).isEqualTo(expected);
        verify(transferNewsRepository).findAllByOrderByPublishedAtDesc(pageable);
    }

    @Test
    @DisplayName("findByLeague는 리그 + 페이지 조건으로 조회한다")
    void findByLeague_레포지토리_위임() {
        League league = League.builder().id(1L).name("EPL").countryCode("GB").tier(1).build();
        Pageable pageable = PageRequest.of(0, 10);
        Page<TransferNews> expected = new PageImpl<>(List.of(), pageable, 0);
        when(transferNewsRepository.findByLeagueOrderByPublishedAtDesc(eq(league), eq(pageable)))
                .thenReturn(expected);

        Page<TransferNews> result = transferNewsService.findByLeague(league, pageable);

        assertThat(result).isEqualTo(expected);
    }

    @Test
    @DisplayName("findByJournalist는 기자 기준으로 조회한다")
    void findByJournalist_기자_기준_조회() {
        Journalist journalist = Journalist.builder().id(1L).xHandle("Romano").name("Romano").credibilityScore(0f).build();
        when(transferNewsRepository.findByPostJournalistIdOrderByPublishedAtDesc(journalist.getId()))
                .thenReturn(List.of());

        List<TransferNews> result = transferNewsService.findByJournalist(journalist);

        assertThat(result).isEmpty();
        verify(transferNewsRepository).findByPostJournalistIdOrderByPublishedAtDesc(journalist.getId());
    }
}
