package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.Club;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.service.TransferNewsService;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TransferNewsServiceImpl implements TransferNewsService {

    private final TransferNewsRepository transferNewsRepository;

    @Override
    @Transactional(readOnly = true)
    public TransferNews findById(Long id) {
        return transferNewsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("TransferNews not found: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByPlayer(Player player) {
        return transferNewsRepository.findByPlayerOrderByPublishedAtDesc(player);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByStatus(TransferNews.Status status) {
        return transferNewsRepository.findByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByToClub(Club club) {
        return transferNewsRepository.findByToClubOrderByPublishedAtDesc(club);
    }

    @Override
    @Transactional
    public TransferNews save(TransferNews transferNews) {
        return transferNewsRepository.save(transferNews);
    }

    @Override
    @Transactional
    public void updateStatus(Long newsId, TransferNews.Status status) {
        TransferNews news = findById(newsId);
        TransferNews updated = TransferNews.builder()
                .post(news.getPost())
                .player(news.getPlayer())
                .fromClub(news.getFromClub())
                .toClub(news.getToClub())
                .feeEur(news.getFeeEur())
                .status(status)
                .reliability(news.getReliability())
                .publishedAt(news.getPublishedAt())
                .build();
        transferNewsRepository.save(updated);
    }
}