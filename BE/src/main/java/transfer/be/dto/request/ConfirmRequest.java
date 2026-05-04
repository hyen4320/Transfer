package transfer.be.dto.request;

import transfer.be.model.TransferNews;

public record ConfirmRequest(
        TransferNews.Status status,
        String sourceUrl,
        Long confirmedByJournalistId
) {}
