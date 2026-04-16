package transfer.be.dto.response;

import transfer.be.model.Journalist;
import transfer.be.model.TransferNews;

import java.time.LocalDateTime;

public record TransferNewsResponse(
        Long id,
        Long journalistId,
        String playerName,
        String fromClubName,
        String toClubName,
        Long feeEur,
        String status,
        Byte reliability,
        LocalDateTime publishedAt,
        String journalistXHandle,
        String journalistName,
        Float journalistCredibility,
        String postContent
) {
    public static TransferNewsResponse from(TransferNews tn) {
        Journalist journalist = tn.getPost().getJournalist();
        return new TransferNewsResponse(
                tn.getId(),
                journalist.getId(),
                tn.getPlayer().getName(),
                tn.getFromClub() != null ? tn.getFromClub().getName() : null,
                tn.getToClub().getName(),
                tn.getFeeEur(),
                tn.getStatus().name(),
                tn.getReliability(),
                tn.getPublishedAt(),
                journalist.getXHandle(),
                journalist.getName(),
                journalist.getCredibilityScore(),
                tn.getPost().getContent()
        );
    }
}
