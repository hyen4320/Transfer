package transfer.be.client;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.junit.jupiter.api.extension.ExtendWith;
import transfer.be.client.dto.ParseResult;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 실제 Gemini API를 호출하는 통합 테스트.
 * DB / Redis 없이 GeminiApiClient 빈만 로드.
 * GEMINI_API_KEY는 test/resources/application.properties에서 읽음.
 */
@ExtendWith(SpringExtension.class)
@Import({GeminiApiConfig.class, GeminiApiClient.class})
@EnableConfigurationProperties(GeminiApiProperties.class)
@TestPropertySource(locations = "classpath:application.properties")
class GeminiParsingIntegrationTest {

    @Autowired
    GeminiApiClient geminiApiClient;

    static Stream<Arguments> tweets() {
        return Stream.of(
            Arguments.of(
                "CONFIRMED: Kylian Mbappe joins Real Madrid on a free transfer! 5-year deal signed.",
                true, "Mbappe", "Real Madrid", "CONFIRMED"
            ),
            Arguments.of(
                "Victor Osimhen to Chelsea — discussions ongoing, fee around €80m. Not done yet.",
                true, "Osimhen", "Chelsea", "RUMOR"
            ),
            Arguments.of(
                "Ruben Neves LOAN to Al-Qadsiah confirmed. Barcelona retain buy-back clause.",
                true, "Neves", null, "LOAN"
            ),
            Arguments.of(
                "Manchester City DENY interest in Florian Wirtz. Reports are completely false.",
                true, "Wirtz", null, "DENIED"
            ),
            Arguments.of(
                "What a match at Old Trafford last night! United's pressing was incredible.",
                false, null, null, null
            )
        );
    }

    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("tweets")
    @DisplayName("Gemini 파싱 정확도 확인")
    void parseAccuracy(String tweet, boolean expectTransfer, String expectPlayer, String expectToClub, String expectStatus) {
        ParseResult result = geminiApiClient.parseTransferTweet(tweet);

        System.out.printf("[결과] isTransfer=%b | player=%s | from=%s | to=%s | status=%s | fee=%s%n",
                result.isTransferNews(), result.playerName(), result.fromClub(),
                result.toClub(), result.status(), result.feeEur());

        assertThat(result.isTransferNews()).isEqualTo(expectTransfer);
        if (expectPlayer != null) {
            assertThat(result.playerName()).containsIgnoringCase(expectPlayer);
        }
        if (expectToClub != null) {
            assertThat(result.toClub()).containsIgnoringCase(expectToClub);
        }
        if (expectStatus != null) {
            assertThat(result.status()).isEqualToIgnoringCase(expectStatus);
        }
    }
}
