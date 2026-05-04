package transfer.be.dto.response.report;

public record PositionTrendItem(
        String position,
        Long count
) {
    public static PositionTrendItem from(Object[] row) {
        return new PositionTrendItem(
                row[0] != null ? row[0].toString() : "UNKNOWN",
                ((Number) row[1]).longValue()
        );
    }
}
