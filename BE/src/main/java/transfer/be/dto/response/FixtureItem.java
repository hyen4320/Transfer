package transfer.be.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FixtureItem {
    private long id;
    private String leagueId;
    private String date;
    private String kickoff;
    private String state;
    private Integer minute;
    private String homeTeam;
    private String awayTeam;
    private Integer homeScore;
    private Integer awayScore;
    private int matchday;
    private String venue;
    private String referee;
}
