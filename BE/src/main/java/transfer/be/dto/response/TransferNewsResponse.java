package transfer.be.dto.response;

import transfer.be.model.Journalist;
import transfer.be.model.TransferNews;

import java.time.LocalDateTime;

public record TransferNewsResponse(
        Long id,
        Long playerId,
        Long journalistId,
        String playerName,
        String fromClubName,
        String toClubName,
        String fromCountryCode,
        String toCountryCode,
        Long feeEur,
        String status,
        Byte reliability,
        LocalDateTime publishedAt,
        String journalistXHandle,
        String journalistName,
        Float journalistCredibility,
        String postContent,
        String sourceUrl
) {
    public static TransferNewsResponse from(TransferNews tn) {
        Journalist journalist = tn.getPost().getJournalist();
        String xHandle = journalist.getXHandle();
        String xPostId = tn.getPost().getXPostId();
        String sourceUrl = "https://x.com/" + xHandle + "/status/" + xPostId;

        return new TransferNewsResponse(
                tn.getId(),
                tn.getPlayer().getId(),
                journalist.getId(),
                tn.getPlayer().getName(),
                tn.getFromClub() != null ? tn.getFromClub().getName() : null,
                tn.getToClub() != null ? tn.getToClub().getName() : null,
                tn.getFromClub() != null ? tn.getFromClub().getCountryCode() : null,
                tn.getToClub() != null ? tn.getToClub().getCountryCode() : null,
                tn.getFeeEur(),
                tn.getStatus().name(),
                tn.getReliability(),
                tn.getPublishedAt(),
                xHandle,
                journalist.getName(),
                journalist.getCredibilityScore(),
                tn.getPost().getContent(),
                sourceUrl
        );
    }
}
