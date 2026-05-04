package transfer.be.dto.response.report;

public record ClubActivityItem(
        String clubName,
        String leagueName,
        Long incomingCount,
        Long totalFeeEur
) {
    public static ClubActivityItem from(Object[] row) {
        return new ClubActivityItem(
                (String) row[0],
                (String) row[1],
                ((Number) row[2]).longValue(),
                row[3] != null ? ((Number) row[3]).longValue() : 0L
        );
    }
}
