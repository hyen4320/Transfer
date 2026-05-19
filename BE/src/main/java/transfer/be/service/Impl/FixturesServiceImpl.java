package transfer.be.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.LineupPlayerItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchLineupItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.dto.response.StandingItem;
import transfer.be.service.FixturesService;

import java.time.Duration;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class FixturesServiceImpl implements FixturesService {

    private static final Map<String, Integer> LEAGUE_MAP = Map.of(
            "pl", 39,
            "ll", 140,
            "bl", 78,
            "sa", 135,
            "l1", 61
    );

    @Qualifier("apiFootballRestClient")
    private final RestClient apiFootballRestClient;
    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public List<FixtureItem> getFixtures(String leagueId, String date) {
        String cacheKey = "fixtures:" + leagueId + ":" + date;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return deserialize(cached, FixtureItem.class);
        }

        Integer apiLeagueId = LEAGUE_MAP.get(leagueId);
        if (apiLeagueId == null) return List.of();

        try {
            String response = apiFootballRestClient.get()
                    .uri("/fixtures?league={lid}&date={date}&season={season}",
                            apiLeagueId, date, currentSeason())
                    .retrieve()
                    .body(String.class);

            List<FixtureItem> items = parseFixtures(response, leagueId);
            redisTemplate.opsForValue().set(cacheKey, serialize(items), Duration.ofMinutes(5));
            return items;
        } catch (RestClientException e) {
            log.warn("API-Football request failed for {}/{}: {}", leagueId, date, e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<FixtureItem> getFixturesByWeek(String leagueId, int season, LocalDate from) {
        String cacheKey = "fixtures:week:" + leagueId + ":" + season + ":" + from;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return deserialize(cached, FixtureItem.class);
        }

        Integer apiLeagueId = LEAGUE_MAP.get(leagueId);
        if (apiLeagueId == null) return List.of();

        LocalDate to = from.plusDays(6);

        try {
            String response = apiFootballRestClient.get()
                    .uri("/fixtures?league={lid}&season={season}&from={from}&to={to}",
                            apiLeagueId, season, from, to)
                    .retrieve()
                    .body(String.class);

            List<FixtureItem> items = parseFixtures(response, leagueId);
            redisTemplate.opsForValue().set(cacheKey, serialize(items), Duration.ofMinutes(5));
            return items;
        } catch (RestClientException e) {
            log.warn("API-Football week fixtures failed for {}: {}", leagueId, e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<StandingItem> getStandings(String leagueId, int season) {
        String cacheKey = "standings:" + leagueId + ":" + season;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return deserialize(cached, StandingItem.class);
        }

        Integer apiLeagueId = LEAGUE_MAP.get(leagueId);
        if (apiLeagueId == null) return List.of();

        try {
            String response = apiFootballRestClient.get()
                    .uri("/standings?league={lid}&season={season}", apiLeagueId, season)
                    .retrieve()
                    .body(String.class);

            List<StandingItem> items = parseStandings(response);
            redisTemplate.opsForValue().set(cacheKey, serialize(items), Duration.ofHours(1));
            return items;
        } catch (RestClientException e) {
            log.warn("API-Football standings failed for {}: {}", leagueId, e.getMessage());
            return List.of();
        }
    }

    // ─── Match detail ─────────────────────────────────────────────────────────────

    @Override
    public List<MatchEventItem> getMatchEvents(long fixtureId) {
        String cacheKey = "events:" + fixtureId;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) return deserialize(cached, MatchEventItem.class);
        try {
            String response = apiFootballRestClient.get()
                    .uri("/fixtures/events?fixture={id}", fixtureId)
                    .retrieve().body(String.class);
            List<MatchEventItem> items = parseEvents(response);
            redisTemplate.opsForValue().set(cacheKey, serialize(items), Duration.ofMinutes(5));
            return items;
        } catch (RestClientException e) {
            log.warn("API-Football events failed for fixture {}: {}", fixtureId, e.getMessage());
            return List.of();
        }
    }

    @Override
    public MatchStatItem getMatchStats(long fixtureId) {
        String cacheKey = "stats:" + fixtureId;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            try { return objectMapper.readValue(cached, MatchStatItem.class); } catch (Exception ignored) {}
        }
        try {
            String response = apiFootballRestClient.get()
                    .uri("/fixtures/statistics?fixture={id}", fixtureId)
                    .retrieve().body(String.class);
            MatchStatItem item = parseStats(response);
            if (item != null) redisTemplate.opsForValue().set(cacheKey, serialize(item), Duration.ofMinutes(5));
            return item;
        } catch (RestClientException e) {
            log.warn("API-Football stats failed for fixture {}: {}", fixtureId, e.getMessage());
            return null;
        }
    }

    @Override
    public List<MatchLineupItem> getMatchLineups(long fixtureId) {
        String cacheKey = "lineups:" + fixtureId;
        String cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) return deserialize(cached, MatchLineupItem.class);
        try {
            String response = apiFootballRestClient.get()
                    .uri("/fixtures/lineups?fixture={id}", fixtureId)
                    .retrieve().body(String.class);
            List<MatchLineupItem> items = parseLineups(response);
            redisTemplate.opsForValue().set(cacheKey, serialize(items), Duration.ofHours(1));
            return items;
        } catch (RestClientException e) {
            log.warn("API-Football lineups failed for fixture {}: {}", fixtureId, e.getMessage());
            return List.of();
        }
    }

    // ─── Parsers ────────────────────────────────────────────────────────────────

    private List<FixtureItem> parseFixtures(String json, String leagueId) {
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode resp = root.path("response");
            List<FixtureItem> result = new ArrayList<>();
            for (JsonNode f : resp) {
                JsonNode fix    = f.path("fixture");
                JsonNode teams  = f.path("teams");
                JsonNode goals  = f.path("goals");
                JsonNode status = fix.path("status");
                JsonNode lg     = f.path("league");

                String dateStr = fix.path("date").asText();
                String date    = dateStr.length() >= 10 ? dateStr.substring(0, 10) : dateStr;
                String kickoff = dateStr.length() >= 16 ? dateStr.substring(11, 16) : "--:--";

                String stateShort = status.path("short").asText();
                String state = toState(stateShort);

                String roundStr = lg.path("round").asText("");
                int matchday = 0;
                try {
                    String digits = roundStr.replaceAll("[^0-9]", "");
                    if (!digits.isEmpty()) matchday = Integer.parseInt(digits);
                } catch (NumberFormatException ignored) {}

                result.add(FixtureItem.builder()
                        .id(fix.path("id").asLong())
                        .leagueId(leagueId)
                        .date(date)
                        .kickoff(kickoff)
                        .state(state)
                        .minute(status.path("elapsed").isNull() ? 0 : status.path("elapsed").asInt())
                        .homeTeam(teams.path("home").path("name").asText())
                        .awayTeam(teams.path("away").path("name").asText())
                        .homeScore(goals.path("home").isNull() || goals.path("home").isTextual() ? null : goals.path("home").asInt())
                        .awayScore(goals.path("away").isNull() || goals.path("away").isTextual() ? null : goals.path("away").asInt())
                        .matchday(matchday)
                        .venue(fix.path("venue").path("name").asText(""))
                        .referee(fix.path("referee").asText(""))
                        .build());
            }
            return result;
        } catch (Exception e) {
            log.error("parseFixtures error: {}", e.getMessage());
            return List.of();
        }
    }

    private List<StandingItem> parseStandings(String json) {
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode rows = root.path("response").get(0).path("league").path("standings").get(0);
            List<StandingItem> result = new ArrayList<>();
            for (JsonNode r : rows) {
                JsonNode all = r.path("all");
                result.add(StandingItem.builder()
                        .rank(r.path("rank").asInt())
                        .teamName(r.path("team").path("name").asText())
                        .played(all.path("played").asInt())
                        .won(all.path("win").asInt())
                        .drawn(all.path("draw").asInt())
                        .lost(all.path("lose").asInt())
                        .goalsFor(all.path("goals").path("for").asInt())
                        .goalsAgainst(all.path("goals").path("against").asInt())
                        .goalsDiff(r.path("goalsDiff").asInt())
                        .points(r.path("points").asInt())
                        .form(r.path("form").asText(""))
                        .build());
            }
            return result;
        } catch (Exception e) {
            log.error("parseStandings error: {}", e.getMessage());
            return List.of();
        }
    }

    private List<MatchEventItem> parseEvents(String json) {
        try {
            JsonNode resp = objectMapper.readTree(json).path("response");
            List<MatchEventItem> result = new ArrayList<>();
            for (JsonNode ev : resp) {
                String apiType   = ev.path("type").asText("");
                String apiDetail = ev.path("detail").asText("");
                String type = switch (apiType) {
                    case "Goal" -> "goal";
                    case "Card" -> (apiDetail.contains("Red") || apiDetail.contains("Second Yellow")) ? "red" : "yellow";
                    case "subst" -> "sub";
                    default -> "event";
                };
                JsonNode assistNode = ev.path("assist").path("name");
                result.add(MatchEventItem.builder()
                        .minute(ev.path("time").path("elapsed").asInt())
                        .type(type)
                        .teamName(ev.path("team").path("name").asText())
                        .player(ev.path("player").path("name").asText())
                        .assist(assistNode.isNull() || assistNode.isMissingNode() ? null : assistNode.asText())
                        .detail(apiDetail)
                        .build());
            }
            return result;
        } catch (Exception e) {
            log.error("parseEvents error: {}", e.getMessage());
            return List.of();
        }
    }

    private MatchStatItem parseStats(String json) {
        try {
            JsonNode resp = objectMapper.readTree(json).path("response");
            if (resp.size() < 2) return null;
            Map<String, JsonNode> home = buildStatMap(resp.get(0).path("statistics"));
            Map<String, JsonNode> away = buildStatMap(resp.get(1).path("statistics"));
            return MatchStatItem.builder()
                    .possession(new int[]{ intStat(home.get("Ball Possession")), intStat(away.get("Ball Possession")) })
                    .shots(new int[]{ intStat(home.get("Total Shots")), intStat(away.get("Total Shots")) })
                    .shotsOnTarget(new int[]{ intStat(home.get("Shots on Goal")), intStat(away.get("Shots on Goal")) })
                    .xG(new double[]{ dblStat(home.get("expected_goals")), dblStat(away.get("expected_goals")) })
                    .passes(new int[]{ intStat(home.get("Total passes")), intStat(away.get("Total passes")) })
                    .corners(new int[]{ intStat(home.get("Corner Kicks")), intStat(away.get("Corner Kicks")) })
                    .build();
        } catch (Exception e) {
            log.error("parseStats error: {}", e.getMessage());
            return null;
        }
    }

    private List<MatchLineupItem> parseLineups(String json) {
        try {
            JsonNode resp = objectMapper.readTree(json).path("response");
            List<MatchLineupItem> result = new ArrayList<>();
            for (JsonNode team : resp) {
                List<LineupPlayerItem> startXI = new ArrayList<>();
                for (JsonNode p : team.path("startXI")) {
                    JsonNode pl = p.path("player");
                    JsonNode grid = pl.path("grid");
                    startXI.add(LineupPlayerItem.builder()
                            .name(pl.path("name").asText())
                            .number(pl.path("number").asInt())
                            .pos(pl.path("pos").asText(""))
                            .grid(grid.isNull() || grid.isMissingNode() ? null : grid.asText())
                            .build());
                }
                List<LineupPlayerItem> subs = new ArrayList<>();
                for (JsonNode p : team.path("substitutes")) {
                    JsonNode pl = p.path("player");
                    subs.add(LineupPlayerItem.builder()
                            .name(pl.path("name").asText())
                            .number(pl.path("number").asInt())
                            .pos(pl.path("pos").asText(""))
                            .grid(null)
                            .build());
                }
                result.add(MatchLineupItem.builder()
                        .teamName(team.path("team").path("name").asText())
                        .formation(team.path("formation").asText(""))
                        .startXI(startXI)
                        .substitutes(subs)
                        .build());
            }
            return result;
        } catch (Exception e) {
            log.error("parseLineups error: {}", e.getMessage());
            return List.of();
        }
    }

    private Map<String, JsonNode> buildStatMap(JsonNode statistics) {
        Map<String, JsonNode> map = new java.util.HashMap<>();
        for (JsonNode s : statistics) map.put(s.path("type").asText(), s.path("value"));
        return map;
    }

    private int intStat(JsonNode node) {
        if (node == null || node.isNull() || node.isMissingNode()) return 0;
        try { return Integer.parseInt(node.asText("0").replace("%", "").trim()); }
        catch (NumberFormatException e) { return 0; }
    }

    private double dblStat(JsonNode node) {
        if (node == null || node.isNull() || node.isMissingNode()) return 0.0;
        try { return Double.parseDouble(node.asText("0")); }
        catch (NumberFormatException e) { return 0.0; }
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────────

    private String toState(String short_) {
        return switch (short_) {
            case "FT", "AET", "PEN", "AWD", "WO" -> "finished";
            case "1H", "HT", "2H", "ET", "BT", "P", "SUSP", "INT", "LIVE" -> "live";
            default -> "scheduled";
        };
    }

    private int currentSeason() {
        int year = LocalDate.now().getYear();
        return LocalDate.now().getMonthValue() >= 8 ? year : year - 1;
    }

    private String serialize(Object obj) {
        try { return objectMapper.writeValueAsString(obj); }
        catch (Exception e) { return "[]"; }
    }

    private <T> List<T> deserialize(String json, Class<T> clazz) {
        try { return objectMapper.readValue(json, objectMapper.getTypeFactory().constructCollectionType(List.class, clazz)); }
        catch (Exception e) { return List.of(); }
    }
}
