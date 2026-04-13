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

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    private void prePersist() {
        this.createdAt = LocalDateTime.now();
    }
}