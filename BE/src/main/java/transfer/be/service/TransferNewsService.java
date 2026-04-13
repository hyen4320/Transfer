package transfer.be.service;

import transfer.be.model.Club;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.util.List;

public interface TransferNewsService {

    TransferNews findById(Long id);

    List<TransferNews> findByPlayer(Player player);

    List<TransferNews> findByStatus(TransferNews.Status status);

    List<TransferNews> findByToClub(Club club);

    TransferNews save(TransferNews transferNews);

    void updateStatus(Long newsId, TransferNews.Status status);
}