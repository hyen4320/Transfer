package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Club;
import transfer.be.model.Journalist;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.util.List;

public interface TransferNewsRepository extends JpaRepository<TransferNews, Long> {

    List<TransferNews> findByPlayerOrderByPublishedAtDesc(Player player);

    List<TransferNews> findByStatus(TransferNews.Status status);

    List<TransferNews> findByToClubOrderByPublishedAtDesc(Club club);

    /** 기자의 전체 뉴스 수 (공신력 정확도 계산용) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            WHERE tn.post.journalist = :journalist
            """)
    long countByJournalist(@Param("journalist") Journalist journalist);

    /** 기자의 확정된 뉴스 수 (accuracy_score 분자) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            JOIN Verification v ON v.transferNews = tn
            WHERE tn.post.journalist = :journalist
              AND tn.status = 'CONFIRMED'
              AND v.isConfirmed = true
            """)
    long countConfirmedByJournalist(@Param("journalist") Journalist journalist);

    /** 동일 선수 루머 중 해당 기자가 최초 보도한 건수 (speed_score 분자) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            WHERE tn.post.journalist = :journalist
              AND tn.post.postedAt = (
                  SELECT MIN(tn2.post.postedAt) FROM TransferNews tn2
                  WHERE tn2.player = tn.player
              )
            """)
    long countFirstReportByJournalist(@Param("journalist") Journalist journalist);
}