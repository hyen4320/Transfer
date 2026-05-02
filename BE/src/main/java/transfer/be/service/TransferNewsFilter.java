package transfer.be.service;

import org.springframework.stereotype.Component;
import transfer.be.model.TransferNews.Status;

import java.util.List;
import java.util.Locale;
import java.util.Map;

@Component
public class TransferNewsFilter {

    private static final Map<Status, List<String>> STATUS_KEYWORDS = Map.of(
            Status.CONFIRMED, List.of(
                    "confirmed", "done deal", "official", "signs", "signed", "completed",
                    "sealed", "agreement reached", "here we go", "personal terms agreed"
            ),
            Status.CONTRACT_EXTENSION, List.of(
                    "extends contract", "contract extension", "new contract", "renews contract",
                    "contract renewal", "signs new deal", "extended his contract", "extended her contract",
                    "new deal signed", "penned new deal", "contract extended"
            ),
            Status.LOAN, List.of(
                    "loan deal", "on loan", "loan move", "loan fee", "loan agreement",
                    "loan spell", "season-long loan"
            ),
            Status.DENIED, List.of(
                    "denies", "denied", "rejects", "rejected", "not leaving", "stays",
                    "ruled out", "no deal", "no move", "off"
            ),
            Status.RUMOR, List.of(
                    "in talks", "advanced talks", "close to", "bid", "offer", "fee agreed",
                    "medical", "set to join", "move closer", "deal close", "negotiations",
                    "interested", "targeting", "considering", "monitoring", "scouting",
                    "eyeing", "contact made", "enquiry", "approach"
            )
    );

    // CONFIRMED > CONTRACT_EXTENSION > LOAN > DENIED > RUMOR 순 우선순위
    private static final List<Status> STATUS_PRIORITY = List.of(
            Status.CONFIRMED, Status.CONTRACT_EXTENSION, Status.LOAN, Status.DENIED, Status.RUMOR
    );

    public boolean isTransferRelated(String text) {
        return detectStatus(text) != null;
    }

    /**
     * 우선순위 순으로 첫 번째 매칭 상태를 반환.
     * 이적 관련 게시글이 아니면 null.
     */
    public Status detectStatus(String text) {
        if (text == null || text.isBlank()) return null;
        String lower = text.toLowerCase(Locale.ENGLISH);

        for (Status status : STATUS_PRIORITY) {
            for (String keyword : STATUS_KEYWORDS.get(status)) {
                if (lower.contains(keyword)) {
                    return status;
                }
            }
        }
        return null;
    }
}
