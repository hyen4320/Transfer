package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "transfer_news")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class TransferNews {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "news_id")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    /** 이적 출발 구단 — null이면 자유계약 */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_club_id")
    private Club fromClub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_club_id", nullable = false)
    private Club toClub;

    /** 이적료 (유로) — null이면 불명 */
    @Column(name = "fee_eur")
    private Long feeEur;

    /** RUMOR | CONFIRMED | DENIED | LOAN */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status;

    /** 기사 자체 신뢰도 레이블 (1~5) */
    private Byte reliability;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    public enum Status {
        RUMOR, CONFIRMED, DENIED, LOAN
    }
}