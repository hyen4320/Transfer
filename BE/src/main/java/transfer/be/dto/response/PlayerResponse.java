package transfer.be.dto.response;

import transfer.be.model.Player;

public record PlayerResponse(
        Long id,
        String name,
        String nationality,
        String position,
        String currentClubName,
        String currentLeagueName,
        String contractUntil,
        String contractStatus,
        String profileImageUrl
) {
    public static PlayerResponse from(Player p) {
        String leagueName = null;
        if (p.getCurrentClub() != null && p.getCurrentClub().getLeague() != null) {
            leagueName = p.getCurrentClub().getLeague().getName();
        }
        return new PlayerResponse(
                p.getId(),
                p.getName(),
                p.getNationality(),
                p.getPosition() != null ? p.getPosition().name() : null,
                p.getCurrentClub() != null ? p.getCurrentClub().getName() : null,
                leagueName,
                p.getContractUntil() != null ? p.getContractUntil().toString() : null,
                p.getContractStatus() != null ? p.getContractStatus().name() : null,
                p.getProfileImageUrl()
        );
    }
}
