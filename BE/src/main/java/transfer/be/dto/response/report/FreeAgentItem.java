package transfer.be.dto.response.report;

public record FreeAgentItem(
        String leagueName,
        Long count
) {
    public static FreeAgentItem from(Object[] row) {
        return new FreeAgentItem(
                (String) row[0],
                ((Number) row[1]).longValue()
        );
    }
}
