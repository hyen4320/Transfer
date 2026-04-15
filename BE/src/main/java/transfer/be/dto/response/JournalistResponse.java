package transfer.be.dto.response;

import transfer.be.model.Journalist;

public record JournalistResponse(
        Long id,
        String xHandle,
        String name,
        String profileImageUrl,
        Integer followerCount,
        Float credibilityScore,
        Integer rank
) {
    public static JournalistResponse from(Journalist j) {
        return new JournalistResponse(
                j.getId(),
                j.getXHandle(),
                j.getName(),
                j.getProfileImageUrl(),
                j.getFollowerCount(),
                j.getCredibilityScore(),
                j.getRank()
        );
    }
}
