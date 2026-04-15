package transfer.be.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import transfer.be.model.Club;
import transfer.be.model.Journalist;
import transfer.be.model.League;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;

import java.util.List;

public interface TransferNewsService {

    TransferNews findById(Long id);

    List<TransferNews> findByPlayer(Player player);

    List<TransferNews> findByStatus(TransferNews.Status status);

    Page<TransferNews> findByStatusPaged(TransferNews.Status status, Pageable pageable);

    List<TransferNews> findByToClub(Club club);

    List<TransferNews> findByFromClub(Club club);

    List<TransferNews> findByJournalist(Journalist journalist);

    Page<TransferNews> findByLeague(League league, Pageable pageable);

    Page<TransferNews> findFeed(Pageable pageable);

    TransferNews save(TransferNews transferNews);

    void updateStatus(Long newsId, TransferNews.Status status);
}
