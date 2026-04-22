package transfer.be.client;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "gemini")
public class GeminiApiProperties {
    private String apiKey;
    private String model = "gemini-2.5-flash";
    private String baseUrl = "https://generativelanguage.googleapis.com";
}
