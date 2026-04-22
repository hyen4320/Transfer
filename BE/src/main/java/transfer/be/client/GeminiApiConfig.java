package transfer.be.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class GeminiApiConfig {

    @Bean
    public RestClient geminiRestClient(GeminiApiProperties props) {
        return RestClient.builder()
                .baseUrl(props.getBaseUrl())
                .defaultHeader("Content-Type", "application/json")
                .build();
    }

    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }
}
