package transfer.be.client;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "api.football")
public class ApiFootballProperties {
    private String key = "";
    private String baseUrl = "https://v3.football.api-sports.io";
}
