package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.MatchEvent;

import java.util.List;

public interface MatchEventRepository extends JpaRepository<MatchEvent, Long> {

    List<MatchEvent> findByFixtureId(Long fixtureId);

    /** 선수의 시즌 골 목록 */
    @Query("select e from MatchEvent e join e.fixture f where e.playerName = :player and f.season = :season and e.type = 'goal'")
    List<MatchEvent> findGoalsByPlayerAndSeason(@Param("player") String player, @Param("season") int season);

    /** 선수의 시즌 이벤트 전체 (골+카드+교체) */
    @Query("select e from MatchEvent e join e.fixture f where e.playerName = :player and f.season = :season order by f.date asc")
    List<MatchEvent> findByPlayerAndSeason(@Param("player") String player, @Param("season") int season);

    /** 리그 시즌 득점 순위용 집계 */
    @Query("select e.playerName, e.teamName, count(e) as goals from MatchEvent e join e.fixture f " +
           "where f.leagueId = :leagueId and f.season = :season and e.type = 'goal' " +
           "group by e.playerName, e.teamName order by goals desc")
    List<Object[]> findTopScorersByLeagueAndSeason(@Param("leagueId") String leagueId, @Param("season") int season);
}
