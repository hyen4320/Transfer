package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Club;
import transfer.be.model.League;

import java.util.List;
import java.util.Optional;

public interface ClubRepository extends JpaRepository<Club, Long> {

    Optional<Club> findByName(String name);

    List<Club> findByLeague(League league);

    List<Club> findByCountryCode(String countryCode);

    @Query("select cs.club from ClubSeason cs where cs.season = :season")
    List<Club> findBySeason(@Param("season") Short season);

    @Query("select cs.club from ClubSeason cs where cs.season = :season and cs.league.id = :leagueId")
    List<Club> findBySeasonAndLeagueId(@Param("season") Short season, @Param("leagueId") Long leagueId);
}