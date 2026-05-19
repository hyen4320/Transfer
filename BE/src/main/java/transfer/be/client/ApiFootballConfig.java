package transfer.be.client;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class ApiFootballConfig {

    @Bean("apiFootballRestClient")
    public RestClient apiFootballRestClient(ApiFootballProperties props) {
        return RestClient.builder()
                .baseUrl(props.getBaseUrl())
                .defaultHeader("x-apisports-key", props.getKey())
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}
