package transfer.be.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import transfer.be.api.XApiClient;
import transfer.be.api.dto.XTweetResponse;
import transfer.be.model.Journalist;
import transfer.be.model.Post;
import transfer.be.repository.PostRepository;
import transfer.be.service.impl.PostServiceImpl;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PostServiceTest {

    @Mock PostRepository postRepository;
    @Mock XApiClient xApiClient;
    @InjectMocks PostServiceImpl postService;

    private Journalist journalist() {
        return Journalist.builder().id(1L).xHandle("Romano").name("Romano").credibilityScore(0f).build();
    }

    private XTweetResponse.PublicMetrics metrics(int like, int retweet, int reply, int view) {
        return new XTweetResponse.PublicMetrics(like, retweet, reply, view);
    }

    private XTweetResponse.Meta meta(int count) {
        return new XTweetResponse.Meta(null, null, count, null);
    }

    @Test
    @DisplayName("findByJournalist는 레포지토리에 위임한다")
    void findByJournalist_레포지토리_위임() {
        Journalist j = journalist();
        List<Post> expected = List.of(Post.builder().xPostId("t1").content("news").build());
        when(postRepository.findByJournalistOrderByPostedAtDesc(j)).thenReturn(expected);

        List<Post> result = postService.findByJournalist(j);

        assertThat(result).isEqualTo(expected);
        verify(postRepository).findByJournalistOrderByPostedAtDesc(j);
    }

    @Test
    @DisplayName("collectAndSave: API 응답이 null이면 빈 리스트를 반환한다")
    void collectAndSave_API_응답_null_빈리스트() {
        Journalist j = journalist();
        when(postRepository.findTopByJournalistOrderByPostedAtDesc(j)).thenReturn(Optional.empty());
        when(xApiClient.getUserTweets(anyString(), isNull())).thenReturn(null);

        List<Post> result = postService.collectAndSave(j);

        assertThat(result).isEmpty();
        verify(postRepository, never()).save(any());
    }

    @Test
    @DisplayName("collectAndSave: API data가 null이면 빈 리스트를 반환한다")
    void collectAndSave_data_null_빈리스트() {
        Journalist j = journalist();
        when(postRepository.findTopByJournalistOrderByPostedAtDesc(j)).thenReturn(Optional.empty());
        when(xApiClient.getUserTweets(anyString(), isNull()))
                .thenReturn(new XTweetResponse(null, meta(0)));

        List<Post> result = postService.collectAndSave(j);

        assertThat(result).isEmpty();
        verify(postRepository, never()).save(any());
    }

    @Test
    @DisplayName("collectAndSave: 이미 저장된 포스트는 중복 저장하지 않는다")
    void collectAndSave_중복_포스트_스킵() {
        Journalist j = journalist();
        when(postRepository.findTopByJournalistOrderByPostedAtDesc(j)).thenReturn(Optional.empty());

        XTweetResponse.XTweet tweet = new XTweetResponse.XTweet(
                "dup-tweet", "content", null, "2024-01-01T00:00:00Z", metrics(5, 10, 2, 100));
        when(xApiClient.getUserTweets(anyString(), isNull()))
                .thenReturn(new XTweetResponse(List.of(tweet), meta(1)));
        when(postRepository.existsByXPostId("dup-tweet")).thenReturn(true);

        List<Post> result = postService.collectAndSave(j);

        assertThat(result).isEmpty();
        verify(postRepository, never()).save(any());
    }

    @Test
    @DisplayName("collectAndSave: 신규 포스트를 저장하고 반환한다")
    void collectAndSave_신규_포스트_저장() {
        Journalist j = journalist();
        when(postRepository.findTopByJournalistOrderByPostedAtDesc(j)).thenReturn(Optional.empty());

        XTweetResponse.XTweet tweet = new XTweetResponse.XTweet(
                "new-tweet", "Transfer news", null, "2024-01-01T00:00:00Z", metrics(5, 10, 3, 1000));
        when(xApiClient.getUserTweets(anyString(), isNull()))
                .thenReturn(new XTweetResponse(List.of(tweet), meta(1)));
        when(postRepository.existsByXPostId("new-tweet")).thenReturn(false);
        when(postRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        List<Post> result = postService.collectAndSave(j);

        assertThat(result).hasSize(1);
        Post saved = result.get(0);
        assertThat(saved.getXPostId()).isEqualTo("new-tweet");
        assertThat(saved.getLikeCount()).isEqualTo(5);
        assertThat(saved.getRetweetCount()).isEqualTo(10);
        assertThat(saved.getViewCount()).isEqualTo(1000);
        verify(postRepository).save(any(Post.class));
    }

    @Test
    @DisplayName("collectAndSave: 마지막 포스트의 xPostId를 sinceId로 전달한다")
    void collectAndSave_sinceId_사용() {
        Journalist j = journalist();
        Post lastPost = Post.builder().xPostId("since-999").content("old").build();
        when(postRepository.findTopByJournalistOrderByPostedAtDesc(j)).thenReturn(Optional.of(lastPost));
        when(xApiClient.getUserTweets("Romano", "since-999")).thenReturn(null);

        postService.collectAndSave(j);

        verify(xApiClient).getUserTweets("Romano", "since-999");
    }
}
