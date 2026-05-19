package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MatchStatItem {
    private int[] possession;      // [home%, away%]
    private int[] shots;
    private int[] shotsOnTarget;
    private double[] xG;
    private int[] passes;
    private int[] corners;
}
