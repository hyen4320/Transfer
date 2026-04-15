package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.Player;

public interface PlayerRepository extends JpaRepository<Player, Long> {
}
