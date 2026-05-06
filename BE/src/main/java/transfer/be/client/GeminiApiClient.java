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
public class GeminiApiClient {

    @Qualifier("geminiRestClient")
    private final RestClient geminiRestClient;
    private final GeminiApiProperties props;
    private final ObjectMapper objectMapper;

    public ParseResult parseTransferTweet(String tweetContent) {
        String uri = "/v1beta/models/" + props.getModel() + ":generateContent?key=" + props.getApiKey();

        Map<String, Object> body = Map.of(
                "contents", List.of(Map.of(
                        "role", "user",
                        "parts", List.of(Map.of("text",
                                "Extract football transfer information from this tweet: " + tweetContent))
                )),
                "tools", List.of(Map.of("functionDeclarations", List.of(buildFunctionDeclaration()))),
                "toolConfig", Map.of(
                        "functionCallingConfig", Map.of(
                                "mode", "ANY",
                                "allowedFunctionNames", List.of("extract_transfer")
                        )
                )
        );

        try {
            String response = geminiRestClient.post()
                    .uri(uri)
                    .body(body)
                    .retrieve()
                    .body(String.class);

            return parseResponse(response);
        } catch (Exception e) {
            log.warn("[Gemini] 파싱 실패: {}", e.getMessage());
            return ParseResult.notTransfer();
        }
    }

    private ParseResult parseResponse(String json) throws Exception {
        JsonNode root = objectMapper.readTree(json);
        JsonNode usage = root.path("usageMetadata");
        log.debug("[Gemini] 토큰 사용량 — 입력: {}, 출력: {}",
                usage.path("promptTokenCount").asInt(),
                usage.path("candidatesTokenCount").asInt());

        JsonNode parts = root.path("candidates").path(0).path("content").path("parts");
        for (JsonNode part : parts) {
            if (!part.path("functionCall").isMissingNode()) {
                JsonNode args = part.path("functionCall").path("args");
                return new ParseResult(
                        args.path("isTransferNews").asBoolean(false),
                        nullableText(args, "playerName"),
                        nullableText(args, "fromClub"),
                        nullableText(args, "toClub"),
                        nullableText(args, "status"),
                        args.path("feeEur").isNull() ? null : args.path("feeEur").asLong()
                );
            }
        }
        return ParseResult.notTransfer();
    }

    private String nullableText(JsonNode node, String field) {
        JsonNode v = node.path(field);
        return (v.isNull() || v.isMissingNode()) ? null : v.asText();
    }

    private Map<String, Object> buildFunctionDeclaration() {
        return Map.of(
                "name", "extract_transfer",
                "description", "Extract football transfer information from a journalist's tweet",
                "parameters", Map.of(
                        "type", "object",
                        "properties", Map.of(
                                "isTransferNews", Map.of("type", "boolean", "description", "True if the tweet mentions any player movement, transfer rumor, negotiation, loan, club interest, or denial of a transfer rumor. False only for pure match reports or content completely unrelated to player transfers."),
                                "playerName",    Map.of("type", "string",  "description", "Full name of the player"),
                                "fromClub",      Map.of("type", "string",  "description", "Current/source club name, null if free agent"),
                                "toClub",        Map.of("type", "string",  "description", "Destination club name"),
                                "status",        Map.of("type", "string",  "description", "Transfer status. Use CONFIRMED only when the transfer is officially done (e.g. 'here we go!', 'done deal', 'medical complete', 'contract signed', official club announcement). Use DENIED when a club or player officially rejects the move. Use LOAN for confirmed loan moves. Use CONTRACT_EXTENSION for confirmed renewals. Default to RUMOR for any interest, talks, negotiations, offers, or uncertainty.", "enum", List.of("RUMOR", "CONFIRMED", "DENIED", "LOAN", "CONTRACT_EXTENSION")),
                                "feeEur",        Map.of("type", "integer", "description", "Transfer fee in euros, null if unknown or free")
                        ),
                        "required", List.of("isTransferNews")
                )
        );
    }
}
