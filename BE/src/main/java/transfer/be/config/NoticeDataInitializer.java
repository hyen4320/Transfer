package transfer.be.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;
import transfer.be.model.Notice;
import transfer.be.repository.NoticeRepository;

import java.time.LocalDate;
import java.util.List;

@Component
@RequiredArgsConstructor
public class NoticeDataInitializer implements ApplicationRunner {

    private final NoticeRepository noticeRepository;

    @Override
    public void run(ApplicationArguments args) {
        if (noticeRepository.count() > 0) return;

        noticeRepository.saveAll(List.of(
            Notice.builder()
                .tag(Notice.Tag.UPDATE)
                .title("v1.1 — Club alias matching & search")
                .body("Club name aliases (e.g. \"Man City\" → Manchester City) are now resolved automatically when parsing transfer tweets. The search panel also supports filtering by season, window, and transfer status.")
                .publishedAt(LocalDate.of(2026, 4, 21))
                .build(),
            Notice.builder()
                .tag(Notice.Tag.NOTICE)
                .title("Transfer data is sourced from verified journalists only")
                .body("All transfer news shown on TransferMap is parsed from posts by credibility-ranked journalists. Credibility scores are calculated based on report speed, accuracy, and impact.")
                .publishedAt(LocalDate.of(2026, 4, 10))
                .build(),
            Notice.builder()
                .tag(Notice.Tag.UPDATE)
                .title("v1.0 — Initial launch")
                .body("TransferMap launches with interactive European map, journalist rankings, and real-time transfer news feed powered by X (Twitter) API.")
                .publishedAt(LocalDate.of(2026, 4, 1))
                .build()
        ));
    }
}
