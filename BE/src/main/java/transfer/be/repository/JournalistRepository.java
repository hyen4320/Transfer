package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import transfer.be.model.Journalist;

import java.util.List;
import java.util.Optional;

public interface JournalistRepository extends JpaRepository<Journalist, Long> {

    Optional<Journalist> findByXHandle(String xHandle);

    boolean existsByXHandle(String xHandle);

    List<Journalist> findAllByOrderByRankAsc();

    /** 공신력 점수 기준으로 순위 일괄 업데이트 */
    @Modifying
    @Query("""
            UPDATE Journalist j
            SET j.rank = (
                SELECT COUNT(j2) + 1
                FROM Journalist j2
                WHERE j2.credibilityScore > j.credibilityScore
            )
            """)
    void updateAllRanks();
}