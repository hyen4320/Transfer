package transfer.be.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "fixture", indexes = {
    @Index(name = "idx_fixture_league_date", columnList = "league_id, date"),
    @Index(name = "idx_fixture_team",        columnList = "home_team"),
    @Index(name = "idx_fixture_team2",       columnList = "away_team"),
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
public class Fixture {

    /** API-Football fixture ID — 외부 ID를 PK로 사용 */
    @Id
    @Column(name = "fixture_id")
    private Long id;

    @Column(name = "league_id", nullable = false, length = 8)
    private String leagueId;

    /** 프로젝트 시즌 인코딩: 24/25 → 49 (24+25) */
    @Column(nullable = false)
    private int season;

    @Column(nullable = false)
    private LocalDate date;

    /** HH:mm (UTC+1 기준 킥오프) */
    @Column(length = 5)
    private String kickoff;

    @Column(name = "home_team", nullable = false)
    private String homeTeam;

    @Column(name = "away_team", nullable = false)
    private String awayTeam;

    @Column(name = "home_score")
    private Integer homeScore;

    @Column(name = "away_score")
    private Integer awayScore;

    @Column(nullable = false)
    private int matchday;

    private String venue;
    private String referee;

    @Column(name = "saved_at", nullable = false)
    private LocalDateTime savedAt;

    @OneToMany(mappedBy = "fixture", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MatchEvent> events;

    @OneToOne(mappedBy = "fixture", cascade = CascadeType.ALL, orphanRemoval = true)
    private MatchStat stat;

    public void updateResult(Integer homeScore, Integer awayScore) {
        this.homeScore = homeScore;
        this.awayScore = awayScore;
    }
}
