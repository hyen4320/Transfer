package transfer.be.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import transfer.be.model.Club;
import transfer.be.model.League;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.util.List;

public interface TransferNewsRepository extends JpaRepository<TransferNews, Long>, JpaSpecificationExecutor<TransferNews> {

    List<TransferNews> findByPlayerOrderByPublishedAtDesc(Player player);

    List<TransferNews> findByStatus(TransferNews.Status status);

    Page<TransferNews> findByStatusOrderByPublishedAtDesc(TransferNews.Status status, Pageable pageable);

    List<TransferNews> findByToClubOrderByPublishedAtDesc(Club club);

    List<TransferNews> findByToClubAndSeasonOrderByPublishedAtDesc(Club club, Short season);

    List<TransferNews> findByFromClubOrderByPublishedAtDesc(Club club);

    List<TransferNews> findByFromClubAndSeasonOrderByPublishedAtDesc(Club club, Short season);

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

    /** 동일 시즌에 같은 선수 → 같은 구단 이적 뉴스 중복 체크 */
    @Query("""
            select count(tn) > 0 from TransferNews tn
            where tn.player = :player
              and tn.toClub = :toClub
              and tn.season = :season
            """)
    boolean existsByPlayerAndToClubAndSeason(
            @Param("player") Player player,
            @Param("toClub") Club toClub,
            @Param("season") Short season);

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
