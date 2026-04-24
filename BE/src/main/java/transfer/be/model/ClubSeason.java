package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "club_season",
    uniqueConstraints = @UniqueConstraint(columnNames = {"club_id", "season"})
)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ClubSeason {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "club_season_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "club_id", nullable = false)
    private Club club;

    /** 시즌 인코딩: 25/26 → 51 (TransferNews.season과 동일 방식) */
    @Column(nullable = false)
    private Short season;

    /** 해당 시즌에 속한 리그 (승강제로 변동 가능) */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "league_id", nullable = false)
    private League league;
}
