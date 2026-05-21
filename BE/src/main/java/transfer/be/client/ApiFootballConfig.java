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
                .defaultHeader("X-Auth-Token", props.getKey())
                .build();
    }
}
