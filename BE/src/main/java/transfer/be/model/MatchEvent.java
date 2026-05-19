package transfer.be.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "match_event", indexes = {
    @Index(name = "idx_match_event_fixture", columnList = "fixture_id"),
    @Index(name = "idx_match_event_player",  columnList = "player_name"),
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class MatchEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "event_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fixture_id", nullable = false)
    private Fixture fixture;

    @Column(nullable = false)
    private int minute;

    /** goal | yellow | red | sub */
    @Column(nullable = false, length = 10)
    private String type;

    @Column(name = "team_name", nullable = false)
    private String teamName;

    @Column(name = "player_name", nullable = false)
    private String playerName;

    /** 어시스트 선수 (골 이벤트에만 존재) */
    @Column(name = "assist_name")
    private String assistName;

    /** API-Football detail 필드 (Own Goal, Penalty 등) */
    @Column(length = 80)
    private String detail;
}
