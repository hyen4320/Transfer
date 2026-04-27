package transfer.be.dto.response;

import transfer.be.model.CredibilityMetric;
import transfer.be.model.Journalist;

public record JournalistResponse(
        Long id,
        String xHandle,
        String name,
        String profileImageUrl,
        Integer followerCount,
        Float credibilityScore,
        Integer rank,
        Float speedScore,
        Float accuracyScore,
        Float impactScore,
        Boolean isBot
) {
    public static JournalistResponse from(Journalist j) {
        return from(j, null);
    }

    public static JournalistResponse from(Journalist j, CredibilityMetric metric) {
        return new JournalistResponse(
                j.getId(),
                j.getXHandle(),
                j.getName(),
                j.getProfileImageUrl(),
                j.getFollowerCount(),
                j.getCredibilityScore(),
                j.getRank(),
                metric != null ? metric.getSpeedScore()    : null,
                metric != null ? metric.getAccuracyScore() : null,
                metric != null ? metric.getImpactScore()   : null,
                Boolean.TRUE.equals(j.getIsBot())
        );
    }
}
