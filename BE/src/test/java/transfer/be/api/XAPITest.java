package transfer.be.api;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import transfer.be.api.dto.XTweetResponse;
import transfer.be.api.dto.XUserResponse;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * X API v2 실제 호출 통합 테스트.
 * application.properties의 x.api.bearer-token이 설정되어 있어야 합니다.
 */
@Tag("integration")
@SpringBootTest
class XAPITest {

    // 테스트에 사용할 실존 기자 계정
    private static final String TEST_HANDLE = "FabrizioRomano";

    @Autowired
    private XApiClient xApiClient;

    @Test
    @DisplayName("X 계정명으로 사용자 정보를 조회한다")
    void getUserByUsername() {
        XUserResponse response = xApiClient.getUserByUsername(TEST_HANDLE);

        System.out.println("=== User Info ===");
        System.out.println("ID            : " + response.data().id());
        System.out.println("Name          : " + response.data().name());
        System.out.println("Username      : " + response.data().username());
        System.out.println("Followers     : " + response.data().publicMetrics().followersCount());
        System.out.println("Profile Image : " + response.data().profileImageUrl());

        assertThat(response).isNotNull();
        assertThat(response.data()).isNotNull();
        assertThat(response.data().username()).isEqualToIgnoringCase(TEST_HANDLE);
        assertThat(response.data().publicMetrics().followersCount()).isPositive();
    }

    @Test
    @DisplayName("사용자 ID로 최근 트윗 목록을 조회한다")
    void getUserTweets() {
        // 1단계: handle → userId
        XUserResponse userResponse = xApiClient.getUserByUsername(TEST_HANDLE);
        String userId = userResponse.data().id();

        // 2단계: 최신 트윗 조회
        XTweetResponse tweetResponse = xApiClient.getUserTweets(userId, null);

        System.out.println("=== Tweets ===");
        if (tweetResponse.data() != null) {
            tweetResponse.data().forEach(tweet -> {
                System.out.println("----------------------------------------");
                System.out.println("Tweet ID    : " + tweet.id());
                System.out.println("Text        : " + tweet.text());
                System.out.println("Posted At   : " + tweet.createdAt());
                System.out.println("Likes       : " + tweet.publicMetrics().likeCount());
                System.out.println("Retweets    : " + tweet.publicMetrics().retweetCount());
                System.out.println("Replies     : " + tweet.publicMetrics().replyCount());
                System.out.println("Views       : " + tweet.publicMetrics().impressionCount());
            });
        }
        System.out.println("Result Count : " + tweetResponse.meta().resultCount());
        System.out.println("Next Token   : " + tweetResponse.meta().nextToken());

        assertThat(tweetResponse).isNotNull();
        assertThat(tweetResponse.data()).isNotEmpty();
        assertThat(tweetResponse.meta().resultCount()).isPositive();
    }

    @Test
    @DisplayName("페이지네이션 토큰으로 다음 페이지 트윗을 조회한다")
    void getUserTweetsNextPage() {
        String userId = xApiClient.getUserByUsername(TEST_HANDLE).data().id();

        XTweetResponse firstPage = xApiClient.getUserTweets(userId, null);
        String nextToken = firstPage.meta().nextToken();

        if (nextToken == null) {
            System.out.println("No next page (tweet count <= max_results)");
            return;
        }

        XTweetResponse secondPage = xApiClient.getUserTweetsNextPage(userId, nextToken);

        System.out.println("=== Second Page Tweets ===");
        System.out.println("Result Count : " + secondPage.meta().resultCount());

        assertThat(secondPage).isNotNull();
        assertThat(secondPage.data()).isNotEmpty();

        // 두 페이지의 트윗 ID가 겹치지 않아야 함
        var firstIds  = firstPage.data().stream().map(XTweetResponse.XTweet::id).toList();
        var secondIds = secondPage.data().stream().map(XTweetResponse.XTweet::id).toList();
        assertThat(secondIds).doesNotContainAnyElementsOf(firstIds);
    }
}