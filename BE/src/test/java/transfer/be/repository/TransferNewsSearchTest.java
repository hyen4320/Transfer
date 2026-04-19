package transfer.be.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.dto.request.TransferNewsSearchCondition;
import transfer.be.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class TransferNewsSearchTest {

    @Autowired TransferNewsRepository transferNewsRepository;
    @Autowired LeagueRepository leagueRepository;
    @Autowired ClubRepository clubRepository;
    @Autowired PlayerRepository playerRepository;
    @Autowired JournalistRepository journalistRepository;
    @Autowired PostRepository postRepository;
    @Autowired VerificationRepository verificationRepository;

    private League league;
    private Club fromClub, toClub;
    private Player fwPlayer, gkPlayer;
    private Journalist highCred, lowCred;
    private TransferNews news1, news2, news3;

    @BeforeEach
    void setUp() {
        league   = leagueRepository.save(League.builder().name("Premier League").countryCode("GB").tier(1).build());
        fromClub = clubRepository.save(Club.builder().league(league).name("Arsenal").shortName("ARS").countryCode("GB").build());
        toClub   = clubRepository.save(Club.builder().league(league).name("Chelsea").shortName("CHE").countryCode("GB").build());

        fwPlayer = playerRepository.save(Player.builder().name("Saka").nationality("English")
                .position(Player.Position.FW).currentClub(fromClub).build());
        gkPlayer = playerRepository.save(Player.builder().name("Raya").nationality("Spanish")
                .position(Player.Position.GK).currentClub(fromClub).build());

        highCred = journalistRepository.save(Journalist.builder().xHandle("romano").name("Romano")
                .credibilityScore(95f).followerCount(20_000_000).build());
        lowCred  = journalistRepository.save(Journalist.builder().xHandle("lowcred").name("Low")
                .credibilityScore(30f).followerCount(1_000).build());

        // news1: CONFIRMED, season=51, SUMMER, FW, fee=80M, reliability=5, highCred
        news1 = save(fwPlayer, fromClub, toClub, TransferNews.Status.CONFIRMED,
                (short) 51, TransferNews.TransferWindow.SUMMER, 80_000_000L, (byte) 5,
                highCred, LocalDateTime.of(2025, 7, 1, 0, 0));

        // news2: RUMOR, season=49, WINTER, GK, fee=10M, reliability=2, lowCred
        news2 = save(gkPlayer, fromClub, toClub, TransferNews.Status.RUMOR,
                (short) 49, TransferNews.TransferWindow.WINTER, 10_000_000L, (byte) 2,
                lowCred, LocalDateTime.of(2025, 1, 15, 0, 0));

        // news3: CONFIRMED, season=51, SUMMER, FW, fee=150M, reliability=4, highCred
        news3 = save(fwPlayer, toClub, fromClub, TransferNews.Status.CONFIRMED,
                (short) 51, TransferNews.TransferWindow.SUMMER, 150_000_000L, (byte) 4,
                highCred, LocalDateTime.of(2025, 8, 1, 0, 0));

        // news1만 검증됨
        verificationRepository.save(Verification.builder().transferNews(news1).isConfirmed(true).build());
    }

    private TransferNews save(Player player, Club from, Club to, TransferNews.Status status,
                               short season, TransferNews.TransferWindow window,
                               Long fee, byte reliability, Journalist journalist, LocalDateTime publishedAt) {
        Post post = postRepository.save(Post.builder()
                .journalist(journalist).xPostId("x-" + System.nanoTime())
                .content("transfer news").postedAt(publishedAt).build());
        return transferNewsRepository.save(TransferNews.builder()
                .post(post).player(player).fromClub(from).toClub(to)
                .status(status).season(season).window(window)
                .feeEur(fee).reliability(reliability).publishedAt(publishedAt).build());
    }

    private Page<TransferNews> search(TransferNewsSearchCondition c) {
        return transferNewsRepository.findAll(TransferNewsSpecification.from(c), PageRequest.of(0, 20));
    }

    private TransferNewsSearchCondition empty() {
        return new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, null);
    }

    @Test
    @DisplayName("조건 없음 → 전체 반환")
    void noFilter_전체반환() {
        assertThat(search(empty()).getTotalElements()).isEqualTo(3);
    }

    @Test
    @DisplayName("status=CONFIRMED → 2건")
    void status_필터() {
        var c = new TransferNewsSearchCondition(TransferNews.Status.CONFIRMED, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("season=51 → 2건")
    void season_필터() {
        var c = new TransferNewsSearchCondition(null, (short) 51, null, null, null, null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("window=WINTER → 1건")
    void window_필터() {
        var c = new TransferNewsSearchCondition(null, null, TransferNews.TransferWindow.WINTER, null, null, null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("leagueId → toClub 소속 리그 기준 3건")
    void leagueId_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, league.getId(), null, null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(3);
    }

    @Test
    @DisplayName("journalistId=highCred → 2건")
    void journalistId_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, highCred.getId(), null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("position=FW → 2건")
    void position_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, Player.Position.FW,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("nationality=Spanish → 1건")
    void nationality_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, null, "Spanish", null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("minFeeEur=50M → 2건")
    void minFeeEur_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                50_000_000L, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("maxFeeEur=50M → 1건")
    void maxFeeEur_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, 50_000_000L, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("from/to 날짜 범위 → SUMMER 기간 2건")
    void date_범위_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, LocalDate.of(2025, 6, 1), LocalDate.of(2025, 9, 1),
                null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("toClubId → 2건")
    void toClubId_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, toClub.getId(), null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("fromClubId → 2건")
    void fromClubId_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, fromClub.getId(), null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("minReliability=4 → 2건")
    void minReliability_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, null, null, (byte) 4, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("minCredibility=80 → highCred 기자 뉴스 2건")
    void minCredibility_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, 80f, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("verified=true → 검증된 1건")
    void verified_필터() {
        var c = new TransferNewsSearchCondition(null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, true);
        assertThat(search(c).getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("season=51 + window=SUMMER + status=CONFIRMED → 2건")
    void 복합_조건_필터() {
        var c = new TransferNewsSearchCondition(TransferNews.Status.CONFIRMED, (short) 51,
                TransferNews.TransferWindow.SUMMER, null, null, null,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("season=51 + position=GK → 0건")
    void 복합_조건_결과없음() {
        var c = new TransferNewsSearchCondition(null, (short) 51, null, null, null, Player.Position.GK,
                null, null, null, null, null, null, null, null, null, null);
        assertThat(search(c).getTotalElements()).isEqualTo(0);
    }
}
