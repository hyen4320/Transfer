package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LineupPlayerItem {
    private String name;
    private int number;
    private String pos;
    private String grid;
}
