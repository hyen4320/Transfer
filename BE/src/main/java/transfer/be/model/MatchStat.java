package transfer.be.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "match_stat")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class MatchStat {

    @Id
    @Column(name = "fixture_id")
    private Long fixtureId;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "fixture_id")
    private Fixture fixture;

    @Column(name = "home_possession")
    private int homePossession;

    @Column(name = "away_possession")
    private int awayPossession;

    @Column(name = "home_shots")
    private int homeShots;

    @Column(name = "away_shots")
    private int awayShots;

    @Column(name = "home_shots_on_target")
    private int homeShotsOnTarget;

    @Column(name = "away_shots_on_target")
    private int awayShotsOnTarget;

    @Column(name = "home_xg")
    private double homeXg;

    @Column(name = "away_xg")
    private double awayXg;

    @Column(name = "home_passes")
    private int homePasses;

    @Column(name = "away_passes")
    private int awayPasses;

    @Column(name = "home_corners")
    private int homeCorners;

    @Column(name = "away_corners")
    private int awayCorners;
}
