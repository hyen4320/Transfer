package transfer.be.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.Player;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PlayerRepository extends JpaRepository<Player, Long> {

    List<Player> findByContractUntilBetweenOrderByContractUntilAsc(LocalDate from, LocalDate to);

    Optional<Player> findByNameIgnoreCase(String name);

    List<Player> findByNameContainingIgnoreCase(String name, Pageable pageable);
}
