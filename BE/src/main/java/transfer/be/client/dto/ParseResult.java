package transfer.be.client.dto;

public record ParseResult(
        boolean isTransferNews,
        String playerName,
        String fromClub,
        String toClub,
        String status,
        Long feeEur
) {
    public static ParseResult notTransfer() {
        return new ParseResult(false, null, null, null, null, null);
    }
}
