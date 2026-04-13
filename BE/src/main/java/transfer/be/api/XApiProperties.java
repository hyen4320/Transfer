package transfer.be.api;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "x.api")
public class XApiProperties {

    /** X Developer Portal에서 발급받은 Bearer Token */
    @Value("x.api.bearer-token")
    private String bearerToken;

    private String baseUrl = "https://api.twitter.com";

    /** 한 번에 가져올 최대 트윗 수 (max 100) */
    private int maxResults = 10;
}