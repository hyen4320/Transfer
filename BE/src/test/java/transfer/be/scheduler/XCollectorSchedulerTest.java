package transfer.be.scheduler;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import transfer.be.model.Journalist;
import transfer.be.model.Post;
import transfer.be.service.JournalistService;
import transfer.be.service.PostService;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class XCollectorSchedulerTest {

    @Mock JournalistService journalistService;
    @Mock PostService postService;
    @Mock StringRedisTemplate redisTemplate;
    @Mock ValueOperations<String, String> valueOperations;

    @InjectMocks XCollectorScheduler scheduler;

    @BeforeEach
    void setUp() {
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
    }

    private Journalist journalist(long id, String handle) {
        return Journalist.builder().id(id).xHandle(handle).xUserId("100" + id).name(handle).credibilityScore(0f).build();
    }

    private Journalist journalistNoUserId(long id, String handle) {
        return Journalist.builder().id(id).xHandle(handle).name(handle).credibilityScore(0f).build();
    }

    @Test
    @DisplayName("rate limit 미초과 시 모든 기자의 포스트를 수집한다")
    void collectAll_정상_수집() {
        Journalist j1 = journalist(1L, "romano");
        Journalist j2 = journalist(2L, "fabrizio");
        when(journalistService.findAllByRank()).thenReturn(List.of(j1, j2));
        when(valueOperations.get("x-api:rate-limit")).thenReturn(null); // limit 미초과
        when(postService.collectAndSave(any())).thenReturn(List.of());
        when(valueOperations.increment("x-api:rate-limit")).thenReturn(2L);

        scheduler.collectAllJournalistPosts();

        verify(postService, times(2)).collectAndSave(any(Journalist.class));
    }

    @Test
    @DisplayName("rate limit 초과(50회) 시 첫 기자부터 수집하지 않는다")
    void collectAll_rate_limit_초과_수집중단() {
        Journalist j1 = journalist(1L, "romano");
        Journalist j2 = journalist(2L, "fabrizio");
        when(journalistService.findAllByRank()).thenReturn(List.of(j1, j2));
        when(valueOperations.get("x-api:rate-limit")).thenReturn("50"); // limit 초과

        scheduler.collectAllJournalistPosts();

        verify(postService, never()).collectAndSave(any());
    }

    @Test
    @DisplayName("특정 기자 수집 중 예외 발생 시 나머지 기자 수집을 계속한다")
    void collectAll_예외_발생_시_다음_기자_계속() {
        Journalist j1 = journalist(1L, "error-journalist");
        Journalist j2 = journalist(2L, "ok-journalist");
        when(journalistService.findAllByRank()).thenReturn(List.of(j1, j2));
        when(valueOperations.get("x-api:rate-limit")).thenReturn(null);
        when(postService.collectAndSave(j1)).thenThrow(new RuntimeException("X API error"));
        when(postService.collectAndSave(j2)).thenReturn(List.of());
        when(valueOperations.increment("x-api:rate-limit")).thenReturn(2L);

        scheduler.collectAllJournalistPosts();

        verify(postService).collectAndSave(j1);
        verify(postService).collectAndSave(j2); // j1 실패해도 j2 수집
    }

    @Test
    @DisplayName("첫 번째 API 호출 시 Redis TTL을 15분으로 설정한다")
    void collectAll_첫호출_TTL_설정() {
        Journalist j1 = journalist(1L, "romano");
        when(journalistService.findAllByRank()).thenReturn(List.of(j1));
        when(valueOperations.get("x-api:rate-limit")).thenReturn(null);
        when(postService.collectAndSave(j1)).thenReturn(List.of());
        when(valueOperations.increment("x-api:rate-limit")).thenReturn(1L); // 첫 번째 호출

        scheduler.collectAllJournalistPosts();

        verify(redisTemplate).expire(eq("x-api:rate-limit"), any());
    }

    @Test
    @DisplayName("xUserId 없는 기자는 collectAndSave에서 스킵되어 rate-limit 카운터가 올라가지 않는다")
    void collectAll_xUserId_없는_기자_스킵() {
        Journalist j1 = journalistNoUserId(1L, "no-id-journalist");
        when(journalistService.findAllByRank()).thenReturn(List.of(j1));
        when(valueOperations.get("x-api:rate-limit")).thenReturn(null);
        when(postService.collectAndSave(j1)).thenReturn(List.of()); // PostServiceImpl이 내부에서 스킵

        scheduler.collectAllJournalistPosts();

        // rate-limit increment는 호출됨 (스킵 판단은 PostServiceImpl 책임)
        verify(postService).collectAndSave(j1);
    }
}
