package transfer.be.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Club;
import transfer.be.model.League;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.util.List;

public interface TransferNewsRepository extends JpaRepository<TransferNews, Long> {

    List<TransferNews> findByPlayerOrderByPublishedAtDesc(Player player);

    List<TransferNews> findByStatus(TransferNews.Status status);

    Page<TransferNews> findByStatusOrderByPublishedAtDesc(TransferNews.Status status, Pageable pageable);

    List<TransferNews> findByToClubOrderByPublishedAtDesc(Club club);

    List<TransferNews> findByFromClubOrderByPublishedAtDesc(Club club);

    Page<TransferNews> findAllByOrderByPublishedAtDesc(Pageable pageable);

    /** 기자 ID로 작성 뉴스 조회 — 엔티티 대신 ID 사용 (DevTools classloader 충돌 방지) */
    List<TransferNews> findByPostJournalistIdOrderByPublishedAtDesc(Long journalistId);

    /** 리그 소속 구단의 영입 이적 뉴스 조회 */
    @Query("""
            SELECT tn FROM TransferNews tn
            WHERE tn.toClub.league = :league
            ORDER BY tn.publishedAt DESC
            """)
    Page<TransferNews> findByLeagueOrderByPublishedAtDesc(@Param("league") League league, Pageable pageable);

    /** 기자의 전체 뉴스 수 (공신력 정확도 계산용) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            WHERE tn.post.journalist.id = :journalistId
            """)
    long countByJournalistId(@Param("journalistId") Long journalistId);

    /** 기자의 확정된 뉴스 수 (accuracy_score 분자) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            JOIN Verification v ON v.transferNews = tn
            WHERE tn.post.journalist.id = :journalistId
              AND tn.status = 'CONFIRMED'
              AND v.isConfirmed = true
            """)
    long countConfirmedByJournalistId(@Param("journalistId") Long journalistId);

    /** 동일 선수 루머 중 해당 기자가 최초 보도한 건수 (speed_score 분자) */
    @Query("""
            SELECT COUNT(tn) FROM TransferNews tn
            WHERE tn.post.journalist.id = :journalistId
              AND tn.post.postedAt = (
                  SELECT MIN(tn2.post.postedAt) FROM TransferNews tn2
                  WHERE tn2.player = tn.player
              )
            """)
    long countFirstReportByJournalistId(@Param("journalistId") Long journalistId);
}
