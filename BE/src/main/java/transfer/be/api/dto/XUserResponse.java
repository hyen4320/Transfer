package transfer.be.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * GET /2/users/by/username/:username 응답
 */
public record XUserResponse(XUser data) {

    public record XUser(
            String id,
            String name,
            String username,
            @JsonProperty("profile_image_url") String profileImageUrl,
            @JsonProperty("public_metrics") PublicMetrics publicMetrics
    ) {}

    public record PublicMetrics(
            @JsonProperty("followers_count") int followersCount,
            @JsonProperty("following_count") int followingCount,
            @JsonProperty("tweet_count") int tweetCount
    ) {}
}