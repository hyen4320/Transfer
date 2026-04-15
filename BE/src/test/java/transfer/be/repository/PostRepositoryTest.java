package transfer.be.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.Journalist;
import transfer.be.model.Post;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class PostRepositoryTest {

    @Autowired PostRepository postRepository;
    @Autowired JournalistRepository journalistRepository;

    private Journalist journalist;

    @BeforeEach
    void setUp() {
        journalist = journalistRepository.save(Journalist.builder()
                .xHandle("test_postRepo").name("Test Reporter").credibilityScore(0f).build());
    }

    private Post savePost(String xPostId, LocalDateTime postedAt) {
        return postRepository.save(Post.builder()
                .journalist(journalist).xPostId(xPostId).content("news")
                .postedAt(postedAt).build());
    }

    @Test
    @DisplayName("xPostId가 존재하면 true를 반환한다")
    void existsByXPostId_존재하면_true() {
        savePost("existing-tweet", LocalDateTime.now());

        assertThat(postRepository.existsByXPostId("existing-tweet")).isTrue();
    }

    @Test
    @DisplayName("xPostId가 없으면 false를 반환한다")
    void existsByXPostId_없으면_false() {
        assertThat(postRepository.existsByXPostId("non-existent")).isFalse();
    }

    @Test
    @DisplayName("xPostId로 단건 조회한다")
    void findByXPostId_조회() {
        savePost("find-tweet", LocalDateTime.now());

        assertThat(postRepository.findByXPostId("find-tweet")).isPresent();
        assertThat(postRepository.findByXPostId("not-here")).isEmpty();
    }

    @Test
    @DisplayName("기자의 가장 최근 포스트를 반환한다")
    void findTopByJournalistOrderByPostedAtDesc_최신_포스트() {
        savePost("old-tweet", LocalDateTime.now().minusDays(2));
        savePost("new-tweet", LocalDateTime.now());

        Optional<Post> result = postRepository.findTopByJournalistOrderByPostedAtDesc(journalist);

        assertThat(result).isPresent();
        assertThat(result.get().getXPostId()).isEqualTo("new-tweet");
    }

    @Test
    @DisplayName("기자의 포스트가 없으면 빈 Optional을 반환한다")
    void findTopByJournalistOrderByPostedAtDesc_포스트없으면_빈Optional() {
        Optional<Post> result = postRepository.findTopByJournalistOrderByPostedAtDesc(journalist);
        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("기자의 포스트를 최신순으로 목록 조회한다")
    void findByJournalistOrderByPostedAtDesc_최신순_목록() {
        savePost("t1", LocalDateTime.now().minusDays(1));
        savePost("t2", LocalDateTime.now());
        savePost("t3", LocalDateTime.now().minusDays(2));

        List<Post> result = postRepository.findByJournalistOrderByPostedAtDesc(journalist);

        assertThat(result).hasSize(3);
        assertThat(result.get(0).getXPostId()).isEqualTo("t2");   // 가장 최신
        assertThat(result.get(2).getXPostId()).isEqualTo("t3");   // 가장 오래된
    }
}
