package transfer.be.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import transfer.be.service.FixtureStorageService;

import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class FixtureStorageScheduler {

    private final FixtureStorageService fixtureStorageService;

    /** 매일 새벽 3시 — 전날 5개 리그 경기 결과를 DB에 저장 */
    @Scheduled(cron = "0 0 3 * * *", zone = "Europe/London")
    public void storeYesterdayFixtures() {
        String yesterday = LocalDate.now().minusDays(1).toString();
        log.info("FixtureStorageScheduler: storing fixtures for {}", yesterday);
        try {
            fixtureStorageService.storeAllLeaguesDate(yesterday);
        } catch (Exception e) {
            log.error("FixtureStorageScheduler failed for {}: {}", yesterday, e.getMessage());
        }
    }
}
