package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "verification")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Verification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "verification_id")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "news_id", nullable = false)
    private TransferNews transferNews;

    @Column(name = "is_confirmed", nullable = false)
    private Boolean isConfirmed;

    @Column(name = "confirmed_at")
    private LocalDateTime confirmedAt;

    /** 공식 발표 URL */
    @Column(name = "source_url")
    private String sourceUrl;

    /** 확정 뉴스를 올린 기자 */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "confirmed_by")
    private Journalist confirmedBy;

    public void update(boolean isConfirmed, String sourceUrl, Journalist confirmedBy) {
        this.isConfirmed = isConfirmed;
        this.confirmedAt = isConfirmed ? LocalDateTime.now() : null;
        this.sourceUrl = sourceUrl;
        this.confirmedBy = confirmedBy;
    }
}