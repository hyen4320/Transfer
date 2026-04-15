package transfer.be.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import transfer.be.model.*;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.impl.TransferNewsServiceImpl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TransferNewsServiceTest {

    @Mock TransferNewsRepository transferNewsRepository;
    @InjectMocks TransferNewsServiceImpl transferNewsService;

    @Test
    @DisplayName("findById에서 없는 ID는 예외를 던진다")
    void findById_없는ID_예외() {
        when(transferNewsRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> transferNewsService.findById(99L))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("TransferNews not found: 99");
    }

    @Test
    @DisplayName("updateStatus는 id를 포함해 저장한다 (INSERT 버그 방지)")
    void updateStatus_id_포함_저장() {
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
        when(transferNewsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        transferNewsService.updateStatus(5L, TransferNews.Status.CONFIRMED);

        ArgumentCaptor<TransferNews> captor = ArgumentCaptor.forClass(TransferNews.class);
        verify(transferNewsRepository).save(captor.capture());

        TransferNews saved = captor.getValue();
        assertThat(saved.getId()).isEqualTo(5L);                        // id 포함 → UPDATE
        assertThat(saved.getStatus()).isEqualTo(TransferNews.Status.CONFIRMED);
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
        Journalist journalist = Journalist.builder().xHandle("Romano").name("Romano").credibilityScore(0f).build();
        when(transferNewsRepository.findByPostJournalistOrderByPublishedAtDesc(journalist))
                .thenReturn(List.of());

        List<TransferNews> result = transferNewsService.findByJournalist(journalist);

        assertThat(result).isEmpty();
        verify(transferNewsRepository).findByPostJournalistOrderByPublishedAtDesc(journalist);
    }
}
