package transfer.be.dto.response;

import transfer.be.model.League;

public record LeagueResponse(
        Long id,
        String name,
        String countryCode,
        String logoUrl,
        Integer tier
) {
    public static LeagueResponse from(League l) {
        return new LeagueResponse(
                l.getId(),
                l.getName(),
                l.getCountryCode(),
                l.getLogoUrl(),
                l.getTier()
        );
    }
}
