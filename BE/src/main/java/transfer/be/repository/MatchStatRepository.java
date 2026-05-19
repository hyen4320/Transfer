package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.MatchStat;

import java.util.List;
import java.util.Optional;

public interface MatchStatRepository extends JpaRepository<MatchStat, Long> {

    Optional<MatchStat> findByFixtureId(Long fixtureId);

    /** 특정 팀의 시즌 평균 스탯 (홈 기준) */
    @Query("select avg(s.homePossession), avg(s.homeShots), avg(s.homeXg) " +
           "from MatchStat s join s.fixture f " +
           "where f.homeTeam = :team and f.season = :season")
    List<Object[]> findAvgHomeStatsByTeamAndSeason(@Param("team") String team, @Param("season") int season);

    /** 특정 팀의 시즌 평균 스탯 (어웨이 기준) */
    @Query("select avg(s.awayPossession), avg(s.awayShots), avg(s.awayXg) " +
           "from MatchStat s join s.fixture f " +
           "where f.awayTeam = :team and f.season = :season")
    List<Object[]> findAvgAwayStatsByTeamAndSeason(@Param("team") String team, @Param("season") int season);
}
