package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import transfer.be.service.TrendingService;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TrendingServiceImpl implements TrendingService {

    private static final String KEY = "trending:players";

    private final StringRedisTemplate redisTemplate;

    @Override
    public void recordSearch(String playerName) {
        redisTemplate.opsForZSet().incrementScore(KEY, playerName, 1);
    }

    @Override
    public List<String> getTrendingPlayers(int days, int limit) {
        Set<String> result = redisTemplate.opsForZSet().reverseRange(KEY, 0, limit - 1);
        return result != null ? new ArrayList<>(result) : List.of();
    }

    // 매주 월요일 자정에 집계 초기화
    @Scheduled(cron = "0 0 0 * * MON")
    public void resetWeekly() {
        redisTemplate.delete(KEY);
    }
}
