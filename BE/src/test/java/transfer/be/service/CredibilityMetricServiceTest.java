package transfer.be.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import transfer.be.model.*;
import transfer.be.repository.CredibilityMetricRepository;
import transfer.be.repository.JournalistRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.impl.CredibilityMetricServiceImpl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.within;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CredibilityMetricServiceTest {

    @Mock CredibilityMetricRepository credibilityMetricRepository;
    @Mock TransferNewsRepository transferNewsRepository;
    @Mock JournalistRepository journalistRepository;
    @Mock JournalistService journalistService;
    @InjectMocks CredibilityMetricServiceImpl credibilityMetricService;

    @Test
    @DisplayName("공신력 점수 공식: speed×0.3 + accuracy×0.5 + impact×0.2 를 검증한다")
    void calculateAndSave_공신력_공식_검증() {
        Journalist journalist = Journalist.builder()
                .id(1L).xHandle("Romano").name("Romano")
                .credibilityScore(0f).followerCount(10_000).build();

        // speed: 전체 2건, 최초 보도 1건 → speedScore = 50
        when(transferNewsRepository.countByJournalist(journalist)).thenReturn(2L);
        when(transferNewsRepository.countFirstReportByJournalist(journalist)).thenReturn(1L);

        // accuracy: 전체 2건, 확정 1건 → accuracyScore = 50
        when(transferNewsRepository.countConfirmedByJournalist(journalist)).thenReturn(1L);

        // impact: retweet=30, like=100, view=1000 → rawScore = 30*3+100+1000*0.1 = 290
        // impactScore = 290 / 10000 * 100 = 2.9
        Post post = Post.builder().journalist(journalist).xPostId("t1").content("news")
                .retweetCount(30).likeCount(100).viewCount(1000)
                .postedAt(LocalDateTime.now()).build();
        Club toClub = Club.builder().id(1L).name("Arsenal").countryCode("GB")
                .league(League.builder().id(1L).name("EPL").countryCode("GB").tier(1).build()).build();
        Player player = Player.builder().id(1L).name("Saka").nationality("EN").build();
        TransferNews tn = TransferNews.builder()
                .post(post).player(player).toClub(toClub)
                .status(TransferNews.Status.RUMOR).build();
        when(transferNewsRepository.findByPostJournalistOrderByPublishedAtDesc(journalist))
                .thenReturn(List.of(tn));

        when(credibilityMetricRepository.findByJournalistAndMeasuredDate(any(), any()))
                .thenReturn(Optional.empty());
        when(credibilityMetricRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CredibilityMetric result = credibilityMetricService.calculateAndSave(journalist, LocalDate.now());

        // expected: 50*0.3 + 50*0.5 + 2.9*0.2 = 15 + 25 + 0.58 = 40.58
        assertThat(result.getSpeedScore()).isEqualTo(50f);
        assertThat(result.getAccuracyScore()).isEqualTo(50f);
        assertThat(result.getImpactScore()).isCloseTo(2.9f, within(0.1f));

        float expectedScore = 50f * 0.3f + 50f * 0.5f + result.getImpactScore() * 0.2f;
        verify(journalistService).updateCredibilityScore(eq(1L), floatThat(s -> Math.abs(s - expectedScore) < 0.1f));
    }

    @Test
    @DisplayName("followerCount가 0이면 impactScore는 0이다")
    void calculateImpactScore_팔로워_없으면_0() {
        Journalist journalist = Journalist.builder()
                .id(1L).xHandle("new").name("New")
                .credibilityScore(0f).followerCount(0).build();

        // countByJournalist=0 → speed/accuracy 조기 반환, followerCount=0 → impact 조기 반환
        when(transferNewsRepository.countByJournalist(journalist)).thenReturn(0L);
        when(credibilityMetricRepository.findByJournalistAndMeasuredDate(any(), any()))
                .thenReturn(Optional.empty());
        when(credibilityMetricRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CredibilityMetric result = credibilityMetricService.calculateAndSave(journalist, LocalDate.now());

        assertThat(result.getImpactScore()).isEqualTo(0f);
        assertThat(result.getSpeedScore()).isEqualTo(0f);
        assertThat(result.getAccuracyScore()).isEqualTo(0f);
    }

    @Test
    @DisplayName("calculateAllForCurrentMonth는 모든 기자에 대해 계산한다")
    void calculateAllForCurrentMonth_전체_기자_처리() {
        Journalist j1 = Journalist.builder().id(1L).xHandle("a").name("A").credibilityScore(0f).followerCount(0).build();
        Journalist j2 = Journalist.builder().id(2L).xHandle("b").name("B").credibilityScore(0f).followerCount(0).build();
        when(journalistRepository.findAll()).thenReturn(List.of(j1, j2));
        // countByJournalist=0 이면 speed/accuracy 모두 즉시 0f 반환 → countFirstReport/countConfirmed 미호출
        // followerCount=0 이면 impact 즉시 0f 반환 → findByPostJournalist 미호출
        when(transferNewsRepository.countByJournalist(any())).thenReturn(0L);
        when(credibilityMetricRepository.findByJournalistAndMeasuredDate(any(), any())).thenReturn(Optional.empty());
        when(credibilityMetricRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        credibilityMetricService.calculateAllForCurrentMonth();

        verify(credibilityMetricRepository, times(2)).save(any());
        verify(journalistService, times(2)).updateCredibilityScore(anyLong(), anyFloat());
    }
}
