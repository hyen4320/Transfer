package transfer.be.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * GET /2/users/:id/tweets 응답
 */
public record XTweetResponse(List<XTweet> data, Meta meta) {

    public record XTweet(
            String id,
            String text,
            @JsonProperty("author_id") String authorId,
            @JsonProperty("created_at") String createdAt,
            @JsonProperty("public_metrics") PublicMetrics publicMetrics
    ) {}

    public record PublicMetrics(
            @JsonProperty("like_count") int likeCount,
            @JsonProperty("retweet_count") int retweetCount,
            @JsonProperty("reply_count") int replyCount,
            @JsonProperty("impression_count") int impressionCount   // view_count
    ) {}

    public record Meta(
            @JsonProperty("newest_id") String newestId,
            @JsonProperty("oldest_id") String oldestId,
            @JsonProperty("result_count") int resultCount,
            @JsonProperty("next_token") String nextToken
    ) {}
}