package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.Player;

import java.time.LocalDate;
import java.util.List;

public interface PlayerRepository extends JpaRepository<Player, Long> {

    List<Player> findByContractUntilBetweenOrderByContractUntilAsc(LocalDate from, LocalDate to);
}
