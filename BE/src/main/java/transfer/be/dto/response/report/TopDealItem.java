package transfer.be.dto.response.report;

public record TopDealItem(
        String playerName,
        String fromClubName,
        String toClubName,
        String toLeagueName,
        Long feeEur
) {
    public static TopDealItem from(Object[] row) {
        return new TopDealItem(
                (String) row[0],
                (String) row[1],
                (String) row[2],
                (String) row[3],
                row[4] != null ? ((Number) row[4]).longValue() : 0L
        );
    }
}
