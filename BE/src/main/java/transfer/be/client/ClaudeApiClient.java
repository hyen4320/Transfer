package transfer.be.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import transfer.be.client.dto.ParseResult;

import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class ClaudeApiClient {

    @Qualifier("claudeRestClient")
    private final RestClient claudeRestClient;
    private final ClaudeApiProperties props;
    private final ObjectMapper objectMapper;

    public ParseResult parseTransferTweet(String tweetContent) {
        Map<String, Object> body = Map.of(
                "model", props.getModel(),
                "max_tokens", 512,
                "tools", List.of(buildTool()),
                "tool_choice", Map.of("type", "tool", "name", "extract_transfer"),
                "messages", List.of(Map.of(
                        "role", "user",
                        "content", "Extract football transfer information from this tweet: " + tweetContent
                ))
        );

        try {
            String response = claudeRestClient.post()
                    .uri("/v1/messages")
                    .body(body)
                    .retrieve()
                    .body(String.class);

            return parseResponse(response);
        } catch (Exception e) {
            log.warn("[Claude] 파싱 실패: {}", e.getMessage());
            return ParseResult.notTransfer();
        }
    }

    private ParseResult parseResponse(String json) throws Exception {
        JsonNode root = objectMapper.readTree(json);
        JsonNode content = root.path("content");

        for (JsonNode block : content) {
            if ("tool_use".equals(block.path("type").asText())) {
                JsonNode input = block.path("input");
                return new ParseResult(
                        input.path("isTransferNews").asBoolean(false),
                        nullableText(input, "playerName"),
                        nullableText(input, "fromClub"),
                        nullableText(input, "toClub"),
                        nullableText(input, "status"),
                        input.path("feeEur").isNull() ? null : input.path("feeEur").asLong()
                );
            }
        }
        return ParseResult.notTransfer();
    }

    private String nullableText(JsonNode node, String field) {
        JsonNode v = node.path(field);
        return (v.isNull() || v.isMissingNode()) ? null : v.asText();
    }

    private Map<String, Object> buildTool() {
        return Map.of(
                "name", "extract_transfer",
                "description", "Extract football transfer information from a journalist's tweet",
                "input_schema", Map.of(
                        "type", "object",
                        "properties", Map.of(
                                "isTransferNews", Map.of("type", "boolean", "description", "Whether the tweet is about a football transfer, contract extension, or loan"),
                                "playerName",    Map.of("type", "string",  "description", "Full name of the player"),
                                "fromClub",      Map.of("type", "string",  "description", "Current/source club name, null if free agent"),
                                "toClub",        Map.of("type", "string",  "description", "Destination club name"),
                                "status",        Map.of("type", "string",  "enum", List.of("INTEREST", "RUMOR", "CONFIRMED", "DENIED", "LOAN", "CONTRACT_EXTENSION")),
                                "feeEur",        Map.of("type", "integer", "description", "Transfer fee in euros, null if unknown or free")
                        ),
                        "required", List.of("isTransferNews")
                )
        );
    }
}
