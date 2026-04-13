package transfer.be.api;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import transfer.be.api.dto.XTweetResponse;
import transfer.be.api.dto.XUserResponse;

/**
 * X API v2 클라이언트
 * <p>
 * 사용 전 application.properties에 x.api.bearer-token 설정 필요.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class XApiClient {

    private static final String USER_FIELDS  = "profile_image_url,public_metrics";
    private static final String TWEET_FIELDS = "created_at,public_metrics,author_id";

    private final RestClient xRestClient;
    private final XApiProperties props;

    /**
     * X 계정명으로 사용자 정보 조회.
     *
     * @param username x_handle (@ 제외)
     */
    public XUserResponse getUserByUsername(String username) {
        log.debug("X API - getUserByUsername: {}", username);
        return xRestClient.get()
                .uri(uri -> uri
                        .path("/2/users/by/username/{username}")
                        .queryParam("user.fields", USER_FIELDS)
                        .build(username))
                .retrieve()
                .body(XUserResponse.class);
    }

    /**
     * 특정 사용자의 최근 트윗 목록 조회.
     *
     * @param userId  X 사용자 ID
     * @param sinceId 이 ID 이후 트윗만 수집 (null이면 최신 n건)
     */
    public XTweetResponse getUserTweets(String userId, String sinceId) {
        log.debug("X API - getUserTweets: userId={}, sinceId={}", userId, sinceId);
        return xRestClient.get()
                .uri(uri -> {
                    var builder = uri
                            .path("/2/users/{userId}/tweets")
                            .queryParam("max_results", props.getMaxResults())
                            .queryParam("tweet.fields", TWEET_FIELDS);
                    if (sinceId != null) {
                        builder.queryParam("since_id", sinceId);
                    }
                    return builder.build(userId);
                })
                .retrieve()
                .body(XTweetResponse.class);
    }

    /**
     * 페이지네이션 토큰을 이용해 다음 페이지 트윗 조회.
     *
     * @param userId         X 사용자 ID
     * @param paginationToken XTweetResponse.meta().nextToken()
     */
    public XTweetResponse getUserTweetsNextPage(String userId, String paginationToken) {
        log.debug("X API - getUserTweetsNextPage: userId={}, token={}", userId, paginationToken);
        return xRestClient.get()
                .uri(uri -> uri
                        .path("/2/users/{userId}/tweets")
                        .queryParam("max_results", props.getMaxResults())
                        .queryParam("tweet.fields", TWEET_FIELDS)
                        .queryParam("pagination_token", paginationToken)
                        .build(userId))
                .retrieve()
                .body(XTweetResponse.class);
    }
}