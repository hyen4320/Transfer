package transfer.be.dto.response.report;

public record LeagueSpendingItem(
        String leagueName,
        String countryCode,
        Long totalFeeEur,
        Long count
) {
    public static LeagueSpendingItem from(Object[] row) {
        return new LeagueSpendingItem(
                (String) row[0],
                (String) row[1],
                row[2] != null ? ((Number) row[2]).longValue() : 0L,
                ((Number) row[3]).longValue()
        );
    }
}
