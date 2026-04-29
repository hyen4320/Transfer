package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Journalist;

import java.util.List;
import java.util.Optional;

public interface JournalistRepository extends JpaRepository<Journalist, Long> {

    @Query("SELECT j FROM Journalist j WHERE j.xHandle = :xHandle")
    Optional<Journalist> findByXHandle(@Param("xHandle") String xHandle);

    @Query("SELECT CASE WHEN COUNT(j) > 0 THEN true ELSE false END FROM Journalist j WHERE j.xHandle = :xHandle")
    boolean existsByXHandle(@Param("xHandle") String xHandle);

    List<Journalist> findAllByOrderByRankAsc();

    @Query("select j from Journalist j where j.xUserId is null")
    List<Journalist> findAllByXUserIdIsNull();

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