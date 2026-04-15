package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.League;

public interface LeagueRepository extends JpaRepository<League, Long> {
}
