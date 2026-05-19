package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class MatchLineupItem {
    private String teamName;
    private String formation;
    private List<LineupPlayerItem> startXI;
    private List<LineupPlayerItem> substitutes;
}
