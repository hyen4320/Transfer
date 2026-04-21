package transfer.be.client;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "anthropic")
public class ClaudeApiProperties {
    private String apiKey;
    private String model = "claude-haiku-4-5-20251001";
    private String baseUrl = "https://api.anthropic.com";
}
