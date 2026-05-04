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
    boolean existsByPlayerAndToClubAndSeason(Player player, Club toClub, Short season);

    /** 기간 내 선수별 언급 횟수 — trending 집계용 */
    @Query("""
            select p.name, count(tn) as cnt
            from TransferNews tn
            join tn.player p
            where tn.publishedAt >= :since
            group by p.id, p.name
            order by count(tn) desc
            """)
    List<Object[]> findTrendingPlayerNames(@Param("since") java.time.LocalDateTime since, Pageable pageable);

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

    /** [Report] 시즌별 리그 이적 지출 합계 — CONFIRMED 뉴스, 이적료 있는 것만 */
    @Query("""
            select tn.toClub.league.name, tn.toClub.league.countryCode, sum(tn.feeEur), count(tn)
            from TransferNews tn
            where tn.season = :season
              and tn.feeEur is not null
              and tn.status = 'CONFIRMED'
              and tn.toClub is not null
            group by tn.toClub.league.id, tn.toClub.league.name, tn.toClub.league.countryCode
            order by sum(tn.feeEur) desc
            """)
    List<Object[]> findLeagueSpendingBySeason(@Param("season") Short season);

    /** [Report] 시즌별 포지션별 이적 뉴스 수 */
    @Query("""
            select tn.player.position, count(tn)
            from TransferNews tn
            where tn.season = :season
              and tn.player.position is not null
            group by tn.player.position
            order by count(tn) desc
            """)
    List<Object[]> findPositionTrendBySeason(@Param("season") Short season);

    /** [Report] 시즌별 구단 영입 건수 + 지출 합계 (상위 N) */
    @Query("""
            select tn.toClub.name, tn.toClub.league.name, count(tn), sum(tn.feeEur)
            from TransferNews tn
            where tn.season = :season
              and tn.toClub is not null
            group by tn.toClub.id, tn.toClub.name, tn.toClub.league.name
            order by count(tn) desc
            """)
    List<Object[]> findClubIncomingActivityBySeason(@Param("season") Short season, Pageable pageable);

    /** [Report] 시즌별 국가 간 이적 흐름 (상위 N, 국내 이적 제외) */
    @Query("""
            select tn.fromClub.countryCode, tn.toClub.countryCode, count(tn)
            from TransferNews tn
            where tn.season = :season
              and tn.fromClub is not null
              and tn.toClub is not null
              and tn.fromClub.countryCode <> tn.toClub.countryCode
            group by tn.fromClub.countryCode, tn.toClub.countryCode
            order by count(tn) desc
            """)
    List<Object[]> findTransferFlowBySeason(@Param("season") Short season, Pageable pageable);

    /** [Report] 시즌 최고액 확정 이적 (상위 N) */
    @Query("""
            select tn.player.name, fc.name, tn.toClub.name, tn.toClub.league.name, tn.feeEur
            from TransferNews tn
            left join tn.fromClub fc
            where tn.season = :season
              and tn.status = 'CONFIRMED'
              and tn.feeEur is not null
              and tn.toClub is not null
            order by tn.feeEur desc
            """)
    List<Object[]> findTopDealsBySeason(@Param("season") Short season, Pageable pageable);

    /** [Report] 자유계약(fromClub=null) 이적을 리그별로 집계 */
    @Query("""
            select tn.toClub.league.name, count(tn)
            from TransferNews tn
            where tn.season = :season
              and tn.fromClub is null
              and tn.toClub is not null
            group by tn.toClub.league.id, tn.toClub.league.name
            order by count(tn) desc
            """)
    List<Object[]> findFreeAgentLeaguesBySeason(@Param("season") Short season);
}
