package transfer.be.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import transfer.be.model.Journalist;
import transfer.be.model.Post;
import transfer.be.service.JournalistService;
import transfer.be.service.PostService;

import java.time.Duration;
import java.util.List;

/**
 * 15분마다 등록된 기자들의 X 게시물을 수집하는 스케줄러.
 * Redis rate-limit 카운터로 X API 호출 횟수를 제어한다.
 */
@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnBean(StringRedisTemplate.class)
public class XCollectorScheduler {

    private static final String RATE_LIMIT_KEY = "x-api:rate-limit";
    /** X API Basic 티어: 15분 윈도우 당 최대 요청 수 */
    private static final int RATE_LIMIT_MAX = 50;

    private final JournalistService journalistService;
    private final PostService postService;
    private final StringRedisTemplate redisTemplate;

    @Scheduled(fixedDelay = 15 * 60 * 1000)
    public void collectAllJournalistPosts() {
        List<Journalist> journalists = journalistService.findAllByRank();
        log.info("[XCollector] 수집 시작 — 대상 기자: {}명", journalists.size());

        for (Journalist journalist : journalists) {
            if (isRateLimitExceeded()) {
                log.warn("[XCollector] X API rate limit 초과, 수집 중단");
                break;
            }
            try {
                List<Post> collected = postService.collectAndSave(journalist);
                incrementRateLimit();
                if (!collected.isEmpty()) {
                    log.info("[XCollector] @{} — 신규 포스트 {}건 수집", journalist.getXHandle(), collected.size());
                }
            } catch (Exception e) {
                log.error("[XCollector] @{} 수집 실패: {}", journalist.getXHandle(), e.getMessage());
            }
        }

        log.info("[XCollector] 수집 완료");
    }

    private boolean isRateLimitExceeded() {
        String count = redisTemplate.opsForValue().get(RATE_LIMIT_KEY);
        return count != null && Integer.parseInt(count) >= RATE_LIMIT_MAX;
    }

    private void incrementRateLimit() {
        Long count = redisTemplate.opsForValue().increment(RATE_LIMIT_KEY);
        // 첫 번째 요청일 때 TTL 15분 설정
        if (count != null && count == 1) {
            redisTemplate.expire(RATE_LIMIT_KEY, Duration.ofMinutes(15));
        }
    }
}
