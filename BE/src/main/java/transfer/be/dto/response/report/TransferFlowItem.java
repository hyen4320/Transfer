package transfer.be.dto.response.report;

public record TransferFlowItem(
        String fromCountryCode,
        String toCountryCode,
        Long count
) {
    public static TransferFlowItem from(Object[] row) {
        return new TransferFlowItem(
                (String) row[0],
                (String) row[1],
                ((Number) row[2]).longValue()
        );
    }
}
