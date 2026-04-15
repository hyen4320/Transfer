package transfer.be.dto.response;

import transfer.be.model.Club;

import java.math.BigDecimal;

public record ClubResponse(
        Long id,
        String name,
        String shortName,
        String logoUrl,
        String city,
        String countryCode,
        BigDecimal latitude,
        BigDecimal longitude,
        String stadiumName,
        String leagueName
) {
    public static ClubResponse from(Club c) {
        return new ClubResponse(
                c.getId(),
                c.getName(),
                c.getShortName(),
                c.getLogoUrl(),
                c.getCity(),
                c.getCountryCode(),
                c.getLatitude(),
                c.getLongitude(),
                c.getStadiumName(),
                c.getLeague() != null ? c.getLeague().getName() : null
        );
    }
}
