package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.dto.request.TransferNewsSearchCondition;
import transfer.be.exception.NotFoundException;
import transfer.be.model.Club;
import transfer.be.model.Journalist;
import transfer.be.model.League;
import transfer.be.model.Player;
import transfer.be.model.TransferNews;
import transfer.be.repository.TransferNewsRepository;
import transfer.be.repository.TransferNewsSpecification;
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
                .orElseThrow(() -> new NotFoundException("TransferNews not found: " + id));
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
    public Page<TransferNews> findByStatusPaged(TransferNews.Status status, Pageable pageable) {
        return transferNewsRepository.findByStatusOrderByPublishedAtDesc(status, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByToClub(Club club) {
        return transferNewsRepository.findByToClubOrderByPublishedAtDesc(club);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByFromClub(Club club) {
        return transferNewsRepository.findByFromClubOrderByPublishedAtDesc(club);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransferNews> findByJournalist(Journalist journalist) {
        return transferNewsRepository.findByPostJournalistIdOrderByPublishedAtDesc(journalist.getId());
    }

    @Override
    @Transactional(readOnly = true)
    public Page<TransferNews> findByLeague(League league, Pageable pageable) {
        return transferNewsRepository.findByLeagueOrderByPublishedAtDesc(league, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<TransferNews> findFeed(Pageable pageable) {
        return transferNewsRepository.findAllByOrderByPublishedAtDesc(pageable);
    }

    @Override
    @Transactional
    public TransferNews save(TransferNews transferNews) {
        return transferNewsRepository.save(transferNews);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<TransferNews> search(TransferNewsSearchCondition condition, Pageable pageable) {
        return transferNewsRepository.findAll(TransferNewsSpecification.from(condition), pageable);
    }

    @Override
    @Transactional
    public void updateStatus(Long newsId, TransferNews.Status status) {
        TransferNews news = findById(newsId);
        TransferNews updated = TransferNews.builder()
                .id(news.getId())
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
