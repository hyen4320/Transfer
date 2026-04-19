package transfer.be.dto.request;

import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.time.LocalDate;

public record TransferNewsSearchCondition(
        TransferNews.Status status,
        Short season,
        TransferNews.TransferWindow window,
        Long leagueId,
        Long journalistId,
        Player.Position position,
        Long minFeeEur,
        Long maxFeeEur,
        LocalDate from,
        LocalDate to,
        Long toClubId,
        Long fromClubId,
        String nationality,
        Byte minReliability,
        Float minCredibility,
        Boolean verified
) {}
