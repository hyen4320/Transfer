package transfer.be.service;

import org.junit.jupiter.api.Test;
import transfer.be.model.TransferNews.Status;

import static org.assertj.core.api.Assertions.assertThat;

class TransferNewsFilterTest {

    private final TransferNewsFilter filter = new TransferNewsFilter();

    @Test
    void confirmed_키워드_감지() {
        assertThat(filter.detectStatus("BREAKING: Mbappe signs for Arsenal. Done deal confirmed."))
                .isEqualTo(Status.CONFIRMED);
    }

    @Test
    void loan_키워드_감지() {
        assertThat(filter.detectStatus("Rashford set for loan move to AC Milan. Loan deal agreed."))
                .isEqualTo(Status.LOAN);
    }

    @Test
    void denied_키워드_감지() {
        assertThat(filter.detectStatus("Salah's agent denies any contact with Real Madrid."))
                .isEqualTo(Status.DENIED);
    }

    @Test
    void rumor_키워드_감지() {
        assertThat(filter.detectStatus("Arsenal in advanced talks to sign Osimhen. Medical soon."))
                .isEqualTo(Status.RUMOR);
    }

    @Test
    void interest_키워드는_RUMOR로_감지() {
        assertThat(filter.detectStatus("Chelsea are interested in signing Wirtz this summer."))
                .isEqualTo(Status.RUMOR);
    }

    @Test
    void 이적_무관_게시글은_null() {
        assertThat(filter.detectStatus("What a match last night. City were incredible in the second half."))
                .isNull();
        assertThat(filter.detectStatus("My player of the season so far: Salah. No contest."))
                .isNull();
    }

    @Test
    void confirmed가_RUMOR보다_우선순위_높음() {
        // "confirmed"와 "interested" 둘 다 포함 → CONFIRMED
        assertThat(filter.detectStatus("Clubs interested but deal now confirmed and signed."))
                .isEqualTo(Status.CONFIRMED);
    }

    @Test
    void null_입력_처리() {
        assertThat(filter.detectStatus(null)).isNull();
        assertThat(filter.detectStatus("")).isNull();
        assertThat(filter.detectStatus("   ")).isNull();
    }

    @Test
    void 대소문자_무관() {
        assertThat(filter.detectStatus("CONFIRMED deal for the striker!"))
                .isEqualTo(Status.CONFIRMED);
    }
}
