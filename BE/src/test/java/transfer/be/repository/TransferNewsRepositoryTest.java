package transfer.be.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.*;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class TransferNewsRepositoryTest {

    @Autowired TransferNewsRepository transferNewsRepository;
    @Autowired LeagueRepository leagueRepository;
    @Autowired ClubRepository clubRepository;
    @Autowired PlayerRepository playerRepository;
    @Autowired JournalistRepository journalistRepository;
    @Autowired PostRepository postRepository;
    @Autowired VerificationRepository verificationRepository;

    private Journalist journalist;
    private League league;
    private Club fromClub;
    private Club toClub;
    private Player player;

    @BeforeEach
    void setUp() {
        league    = leagueRepository.save(League.builder().name("Premier League").countryCode("GB").tier(1).build());
        fromClub  = clubRepository.save(Club.builder().league(league).name("Arsenal").shortName("ARS").countryCode("GB").build());
        toClub    = clubRepository.save(Club.builder().league(league).name("Chelsea").shortName("CHE").countryCode("GB").build());
        player    = playerRepository.save(Player.builder().name("Bukayo Saka").nationality("English").position(Player.Position.FW).currentClub(fromClub).build());
        journalist = journalistRepository.save(Journalist.builder().xHandle("test_newsRepo_journalist").name("Fabrizio Romano").credibilityScore(90f).followerCount(10_000_000).build());
    }

    private Post savePost(String xPostId, int rt, int like, int view) {
        return postRepository.save(Post.builder()
                .journalist(journalist).xPostId(xPostId).content("Transfer news")
                .retweetCount(rt).likeCount(like).viewCount(view)
                .postedAt(LocalDateTime.now()).build());
    }

    private TransferNews saveNews(Post post, TransferNews.Status status) {
        return transferNewsRepository.save(TransferNews.builder()
                .post(post).player(player).fromClub(fromClub).toClub(toClub)
                .status(status).publishedAt(LocalDateTime.now()).build());
    }

    @Test
    @DisplayName("기자 기준 이적 뉴스 수를 센다")
    void countByJournalist() {
        saveNews(savePost("t1", 10, 5, 100), TransferNews.Status.RUMOR);
        saveNews(savePost("t2", 20, 10, 200), TransferNews.Status.CONFIRMED);

        long count = transferNewsRepository.countByJournalistId(journalist.getId());

        assertThat(count).isEqualTo(2);
    }

    @Test
    @DisplayName("기자의 이적 뉴스를 최신순으로 조회한다")
    void findByPostJournalistOrderByPublishedAtDesc() {
        transferNewsRepository.save(TransferNews.builder()
                .post(savePost("t-old", 10, 5, 100)).player(player).fromClub(fromClub).toClub(toClub)
                .status(TransferNews.Status.RUMOR).publishedAt(LocalDateTime.now().minusDays(1)).build());
        transferNewsRepository.save(TransferNews.builder()
                .post(savePost("t-new", 10, 5, 100)).player(player).fromClub(fromClub).toClub(toClub)
                .status(TransferNews.Status.CONFIRMED).publishedAt(LocalDateTime.now()).build());

        List<TransferNews> result = transferNewsRepository.findByPostJournalistIdOrderByPublishedAtDesc(journalist.getId());

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getPost().getXPostId()).isEqualTo("t-new"); // 최신이 앞
    }

    @Test
    @DisplayName("리그 기준 이적 뉴스를 페이지네이션으로 조회한다")
    void findByLeagueOrderByPublishedAtDesc_페이지네이션() {
        saveNews(savePost("t1", 10, 5, 100), TransferNews.Status.RUMOR);
        saveNews(savePost("t2", 10, 5, 100), TransferNews.Status.CONFIRMED);

        Page<TransferNews> page = transferNewsRepository
                .findByLeagueOrderByPublishedAtDesc(league, PageRequest.of(0, 10));

        assertThat(page.getTotalElements()).isEqualTo(2);
    }

    @Test
    @DisplayName("검증된 확정 뉴스만 카운트한다")
    void countConfirmedByJournalist() {
        TransferNews confirmed = saveNews(savePost("t1", 10, 5, 100), TransferNews.Status.CONFIRMED);
        saveNews(savePost("t2", 10, 5, 100), TransferNews.Status.RUMOR);
        verificationRepository.save(Verification.builder().transferNews(confirmed).isConfirmed(true).build());

        long count = transferNewsRepository.countConfirmedByJournalistId(journalist.getId());

        assertThat(count).isEqualTo(1);
    }
}
