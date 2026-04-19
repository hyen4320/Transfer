package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "journalist")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Journalist implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "journalist_id")
    private Long id;

    /** X(Twitter) 계정명 */
    @Column(name = "x_handle", unique = true, nullable = false)
    private String xHandle;

    /** X API v2 숫자형 사용자 ID — getUserTweets 호출 시 사용 */
    @Column(name = "x_user_id", unique = true)
    private String xUserId;

    @Column(nullable = false)
    private String name;

    @Column(name = "profile_image_url")
    private String profileImageUrl;

    @Column(name = "follower_count")
    private Integer followerCount;

    /** 종합 공신력 점수 (0~100), credibility_score = speed×0.3 + accuracy×0.5 + impact×0.2 */
    @Column(name = "credibility_score")
    private Float credibilityScore;

    /** 공신력 기반 순위 */
    private Integer rank;

    @Column(name = "last_synced_at")
    private LocalDateTime lastSyncedAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    private void prePersist() {
        this.createdAt = LocalDateTime.now();
    }
}