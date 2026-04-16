package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "credibility_metric")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CredibilityMetric {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "metric_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "journalist_id", nullable = false)
    private Journalist journalist;

    /** 최초 보도까지 걸린 시간 역수 환산 */
    @Column(name = "speed_score")
    private Float speedScore;

    /** 검증된 뉴스 / 전체 뉴스 비율 */
    @Column(name = "accuracy_score")
    private Float accuracyScore;

    /** (retweet×3 + like + view×0.1) / follower 정규화 */
    @Column(name = "impact_score")
    private Float impactScore;

    /** 지표 산출 기준일 (월별 스냅샷) */
    @Column(name = "measured_date", nullable = false)
    private LocalDate measuredDate;

    /**
     * 시즌 인코딩: 앞두자리 + 뒷두자리 (예: 24/25 → 49, 25/26 → 51)
     */
    @Column(name = "season")
    private Short season;

    /** 이적 윈도우: SUMMER (6~9월) | WINTER (1~2월) */
    @Enumerated(EnumType.STRING)
    @Column(name = "transfer_window")
    private TransferWindow window;

    /** 해당 시즌+윈도우 기준 공신력 순위 */
    @Column(name = "rank")
    private Integer rank;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    private void prePersist() {
        this.createdAt = LocalDateTime.now();
    }

    public enum TransferWindow {
        SUMMER, WINTER
    }
}