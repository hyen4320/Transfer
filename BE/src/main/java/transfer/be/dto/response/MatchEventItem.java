package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MatchEventItem {
    private int minute;
    private String type;      // goal | yellow | red | sub | event
    private String teamName;
    private String player;
    private String assist;
    private String detail;
}
