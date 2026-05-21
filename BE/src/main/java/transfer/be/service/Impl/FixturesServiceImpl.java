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

    private static final Map<String, String> LEAGUE_MAP = Map.of(
            "pl", "PL",
            "ll", "PD",
            "bl", "BL1",
            "sa", "SA",
            "l1", "FL1"
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

        String code = LEAGUE_MAP.get(leagueId);
        if (code == null) return List.of();

        try {
            String response = apiFootballRestClient.get()
                    .uri(b -> b.path("/competitions/{code}/matches")
                            .queryParam("dateFrom", date)
                            .queryParam("dateTo", date)
                            .queryParam("season", currentSeason())
                            .build(code))
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

        String code = LEAGUE_MAP.get(leagueId);
        if (code == null) return List.of();

        LocalDate to = from.plusDays(6);

        try {
            String response = apiFootballRestClient.get()
                    .uri(b -> b.path("/competitions/{code}/matches")
                            .queryParam("dateFrom", from)
                            .queryParam("dateTo", to)
                            .queryParam("season", season)
                            .build(code))
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

        String code = LEAGUE_MAP.get(leagueId);
        if (code == null) return List.of();

        try {
            String response = apiFootballRestClient.get()
                    .uri(b -> b.path("/competitions/{code}/standings")
                            .queryParam("season", season)
                            .build(code))
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

    @Override
    public List<MatchEventItem> getMatchEvents(long fixtureId) {
        return List.of();
    }

    @Override
    public MatchStatItem getMatchStats(long fixtureId) {
        return null;
    }

    @Override
    public List<MatchLineupItem> getMatchLineups(long fixtureId) {
        return List.of();
    }

    // ─── Parsers ─────────────────────────────────────────────────────────────────

    private List<FixtureItem> parseFixtures(String json, String leagueId) {
        try {
            JsonNode matches = objectMapper.readTree(json).path("matches");
            List<FixtureItem> result = new ArrayList<>();
            for (JsonNode m : matches) {
                String utcDate = m.path("utcDate").asText();
                String date    = utcDate.length() >= 10 ? utcDate.substring(0, 10) : utcDate;
                String kickoff = utcDate.length() >= 16 ? utcDate.substring(11, 16) : "--:--";

                JsonNode fullTime = m.path("score").path("fullTime");
                JsonNode referees = m.path("referees");
                String referee = (referees.isArray() && referees.size() > 0)
                        ? referees.get(0).path("name").asText("") : "";

                result.add(FixtureItem.builder()
                        .id(m.path("id").asLong())
                        .leagueId(leagueId)
                        .date(date)
                        .kickoff(kickoff)
                        .state(toState(m.path("status").asText()))
                        .minute(0)
                        .homeTeam(m.path("homeTeam").path("name").asText())
                        .awayTeam(m.path("awayTeam").path("name").asText())
                        .homeScore(fullTime.path("home").isNull() ? null : fullTime.path("home").asInt())
                        .awayScore(fullTime.path("away").isNull() ? null : fullTime.path("away").asInt())
                        .matchday(m.path("matchday").asInt(0))
                        .venue(m.path("venue").asText(""))
                        .referee(referee)
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
            JsonNode standings = objectMapper.readTree(json).path("standings");
            JsonNode table = null;
            for (JsonNode s : standings) {
                if ("TOTAL".equals(s.path("type").asText())) {
                    table = s.path("table");
                    break;
                }
            }
            if (table == null) return List.of();

            List<StandingItem> result = new ArrayList<>();
            for (JsonNode r : table) {
                result.add(StandingItem.builder()
                        .rank(r.path("position").asInt())
                        .teamName(r.path("team").path("name").asText())
                        .played(r.path("playedGames").asInt())
                        .won(r.path("won").asInt())
                        .drawn(r.path("draw").asInt())
                        .lost(r.path("lost").asInt())
                        .goalsFor(r.path("goalsFor").asInt())
                        .goalsAgainst(r.path("goalsAgainst").asInt())
                        .goalsDiff(r.path("goalDifference").asInt())
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

    // ─── Helpers ─────────────────────────────────────────────────────────────────

    private String toState(String status) {
        return switch (status) {
            case "FINISHED", "AWARDED" -> "finished";
            case "IN_PLAY", "PAUSED", "LIVE" -> "live";
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
