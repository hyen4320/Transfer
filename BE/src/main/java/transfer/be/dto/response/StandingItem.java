package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class StandingItem {
    private int rank;
    private String teamName;
    private int played;
    private int won;
    private int drawn;
    private int lost;
    private int goalsFor;
    private int goalsAgainst;
    private int goalsDiff;
    private int points;
    private String form;
}
