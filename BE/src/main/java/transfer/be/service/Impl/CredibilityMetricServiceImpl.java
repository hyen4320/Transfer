package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.CredibilityMetric;
import transfer.be.model.Journalist;
import transfer.be.repository.CredibilityMetricRepository;
import transfer.be.repository.JournalistRepository;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.CredibilityMetricService;
import transfer.be.service.JournalistService;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CredibilityMetricServiceImpl implements CredibilityMetricService {

    private static final float WEIGHT_SPEED    = 0.3f;
    private static final float WEIGHT_ACCURACY = 0.5f;
    private static final float WEIGHT_IMPACT   = 0.2f;

    private final CredibilityMetricRepository credibilityMetricRepository;
    private final TransferNewsRepository transferNewsRepository;
    private final JournalistRepository journalistRepository;
    private final JournalistService journalistService;

    @Override
    @Transactional(readOnly = true)
    public List<CredibilityMetric> findByJournalist(Journalist journalist) {
        return credibilityMetricRepository.findByJournalistIdOrderByMeasuredDateDesc(journalist.getId());
    }

    @Override
    @Transactional
    public CredibilityMetric calculateAndSave(Journalist journalist, LocalDate measuredDate) {
        float speedScore    = calculateSpeedScore(journalist);
        float accuracyScore = calculateAccuracyScore(journalist);
        float impactScore   = calculateImpactScore(journalist);

        float credibilityScore = speedScore    * WEIGHT_SPEED
                               + accuracyScore * WEIGHT_ACCURACY
                               + impactScore   * WEIGHT_IMPACT;

        CredibilityMetric metric = credibilityMetricRepository
                .findByJournalistAndMeasuredDate(journalist, measuredDate)
                .map(existing -> CredibilityMetric.builder()
                        .journalist(journalist)
                        .speedScore(speedScore)
                        .accuracyScore(accuracyScore)
                        .impactScore(impactScore)
                        .measuredDate(measuredDate)
                        .build())
                .orElseGet(() -> CredibilityMetric.builder()
                        .journalist(journalist)
                        .speedScore(speedScore)
                        .accuracyScore(accuracyScore)
                        .impactScore(impactScore)
                        .measuredDate(measuredDate)
                        .build());

        CredibilityMetric saved = credibilityMetricRepository.save(metric);
        journalistService.updateCredibilityScore(journalist.getId(), credibilityScore);

        log.info("Credibility calculated for @{}: speed={}, accuracy={}, impact={}, total={}",
                journalist.getXHandle(), speedScore, accuracyScore, impactScore, credibilityScore);

        return saved;
    }

    @Override
    @Transactional
    public void calculateAllForCurrentMonth() {
        LocalDate firstOfMonth = LocalDate.now().withDayOfMonth(1);
        journalistRepository.findAll()
                .forEach(journalist -> calculateAndSave(journalist, firstOfMonth));
    }

    /**
     * 속도 점수: 최초 보도 건수 / 전체 뉴스 건수
     */
    private float calculateSpeedScore(Journalist journalist) {
        long total = transferNewsRepository.countByJournalistId(journalist.getId());
        if (total == 0) return 0f;
        long firstReports = transferNewsRepository.countFirstReportByJournalistId(journalist.getId());
        return (float) firstReports / total * 100;
    }

    /**
     * 정확도 점수: 검증된 뉴스 / 전체 뉴스 비율
     */
    private float calculateAccuracyScore(Journalist journalist) {
        long total = transferNewsRepository.countByJournalistId(journalist.getId());
        if (total == 0) return 0f;
        long confirmed = transferNewsRepository.countConfirmedByJournalistId(journalist.getId());
        return (float) confirmed / total * 100;
    }

    /**
     * 파급력 점수: (retweet×3 + like + view×0.1) / follower 정규화 (0~100 클램핑)
     */
    private float calculateImpactScore(Journalist journalist) {
        if (journalist.getFollowerCount() == null || journalist.getFollowerCount() == 0) return 0f;

        double rawScore = transferNewsRepository.findByPostJournalistIdOrderByPublishedAtDesc(journalist.getId())
                .stream()
                .mapToDouble(tn -> {
                    var post = tn.getPost();
                    int rt   = post.getRetweetCount() != null ? post.getRetweetCount() : 0;
                    int like = post.getLikeCount()     != null ? post.getLikeCount()    : 0;
                    int view = post.getViewCount()     != null ? post.getViewCount()    : 0;
                    return rt * 3.0 + like + view * 0.1;
                })
                .average()
                .orElse(0.0);

        float score = (float) (rawScore / journalist.getFollowerCount() * 100);
        return Math.min(score, 100f);
    }
}