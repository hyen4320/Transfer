package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.TransferNews;
import transfer.be.model.Verification;

import java.util.Optional;

public interface VerificationRepository extends JpaRepository<Verification, Long> {

    Optional<Verification> findByTransferNews(TransferNews transferNews);

    boolean existsByTransferNews(TransferNews transferNews);
}