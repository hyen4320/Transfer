package transfer.be.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.CredibilityMetric;
import transfer.be.model.Journalist;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class CredibilityMetricRepositoryTest {

    @Autowired CredibilityMetricRepository credibilityMetricRepository;
    @Autowired JournalistRepository journalistRepository;

    private Journalist journalist;

    @BeforeEach
    void setUp() {
        journalist = journalistRepository.save(Journalist.builder()
                .xHandle("test_credRepo").name("Test Reporter").credibilityScore(0f).build());
    }

    private CredibilityMetric saveMetric(LocalDate date, float speed, float accuracy, float impact) {
        return credibilityMetricRepository.save(CredibilityMetric.builder()
                .journalist(journalist).measuredDate(date)
                .speedScore(speed).accuracyScore(accuracy).impactScore(impact).build());
    }

    @Test
    @DisplayName("기자와 측정일로 지표를 조회한다")
    void findByJournalistAndMeasuredDate_존재하면_반환() {
        LocalDate today = LocalDate.now();
        saveMetric(today, 50f, 60f, 5f);

        Optional<CredibilityMetric> result =
                credibilityMetricRepository.findByJournalistAndMeasuredDate(journalist, today);

        assertThat(result).isPresent();
        assertThat(result.get().getSpeedScore()).isEqualTo(50f);
        assertThat(result.get().getAccuracyScore()).isEqualTo(60f);
    }

    @Test
    @DisplayName("해당 기자/날짜 지표가 없으면 빈 Optional을 반환한다")
    void findByJournalistAndMeasuredDate_없으면_빈Optional() {
        Optional<CredibilityMetric> result =
                credibilityMetricRepository.findByJournalistAndMeasuredDate(journalist, LocalDate.of(2000, 1, 1));

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("기자의 지표 이력을 최신순으로 조회한다")
    void findByJournalistOrderByMeasuredDateDesc_최신순() {
        saveMetric(LocalDate.of(2024, 1, 1), 30f, 40f, 2f);
        saveMetric(LocalDate.of(2024, 3, 1), 70f, 80f, 8f);
        saveMetric(LocalDate.of(2024, 2, 1), 50f, 60f, 5f);

        List<CredibilityMetric> result =
                credibilityMetricRepository.findByJournalistIdOrderByMeasuredDateDesc(journalist.getId());

        assertThat(result).hasSize(3);
        assertThat(result.get(0).getMeasuredDate()).isEqualTo(LocalDate.of(2024, 3, 1)); // 최신
        assertThat(result.get(2).getMeasuredDate()).isEqualTo(LocalDate.of(2024, 1, 1)); // 가장 오래된
    }

    @Test
    @DisplayName("같은 기자의 지표만 조회한다")
    void findByJournalistOrderByMeasuredDateDesc_다른_기자_제외() {
        Journalist other = journalistRepository.save(Journalist.builder()
                .xHandle("other_credRepo").name("Other").credibilityScore(0f).build());
        credibilityMetricRepository.save(CredibilityMetric.builder()
                .journalist(other).measuredDate(LocalDate.now())
                .speedScore(10f).accuracyScore(10f).impactScore(1f).build());

        saveMetric(LocalDate.now(), 50f, 60f, 5f);

        List<CredibilityMetric> result =
                credibilityMetricRepository.findByJournalistIdOrderByMeasuredDateDesc(journalist.getId());

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getSpeedScore()).isEqualTo(50f);
    }
}
