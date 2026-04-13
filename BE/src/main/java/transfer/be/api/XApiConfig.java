package transfer.be.api;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class XApiConfig {

    @Bean
    public RestClient xRestClient(XApiProperties props) {
        return RestClient.builder()
                .baseUrl(props.getBaseUrl())
                .defaultHeader("Authorization", "Bearer " + props.getBearerToken())
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}