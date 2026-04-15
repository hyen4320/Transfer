package transfer.be.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;
import java.util.Map;

@Configuration
@ConditionalOnProperty(name = "spring.cache.type", havingValue = "redis", matchIfMissing = true)
public class RedisConfig {

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory factory) {
        RedisCacheConfiguration defaults = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(10))
                .serializeKeysWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(new JdkSerializationRedisSerializer()));

        Map<String, RedisCacheConfiguration> cacheConfigs = Map.of(
                "journalist:ranking", defaults.entryTtl(Duration.ofMinutes(30))
        );

        return RedisCacheManager.builder(factory)
                .cacheDefaults(defaults)
                .withInitialCacheConfigurations(cacheConfigs)
                .build();
    }
}
