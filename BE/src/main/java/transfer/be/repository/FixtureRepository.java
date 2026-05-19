package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Fixture;

import java.time.LocalDate;
import java.util.List;

public interface FixtureRepository extends JpaRepository<Fixture, Long> {

    List<Fixture> findByLeagueIdAndDateBetweenOrderByDateAsc(
            String leagueId, LocalDate from, LocalDate to);

    List<Fixture> findByLeagueIdAndSeasonOrderByDateAsc(String leagueId, int season);

    /** 특정 팀의 시즌 전체 경기 (홈+어웨이) */
    @Query("select f from Fixture f where f.season = :season and (f.homeTeam = :team or f.awayTeam = :team) order by f.date asc")
    List<Fixture> findByTeamAndSeason(@Param("team") String team, @Param("season") int season);

    /** 두 팀 간 맞대결 전적 */
    @Query("select f from Fixture f where (f.homeTeam = :a and f.awayTeam = :b) or (f.homeTeam = :b and f.awayTeam = :a) order by f.date desc")
    List<Fixture> findHeadToHead(@Param("a") String teamA, @Param("b") String teamB);

    boolean existsById(Long fixtureId);
}
