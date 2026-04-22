package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.api.XApiClient;
import transfer.be.api.dto.XUserResponse;
import transfer.be.exception.NotFoundException;
import transfer.be.model.Journalist;
import transfer.be.repository.JournalistRepository;
import transfer.be.service.JournalistService;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class JournalistServiceImpl implements JournalistService {

    private final JournalistRepository journalistRepository;
    private final XApiClient xApiClient;

    @Override
    @Cacheable(cacheNames = "journalist:ranking")
    @Transactional(readOnly = true)
    public List<Journalist> findAllByRank() {
        return journalistRepository.findAllByOrderByRankAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public Journalist findById(Long id) {
        return journalistRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Journalist not found: " + id));
    }

    @Override
    @Transactional
    public Journalist findOrRegisterByXHandle(String xHandle) {
        return journalistRepository.findByXHandle(xHandle)
                .orElseGet(() -> registerFromX(xHandle));
    }

    @Override
    @Transactional
    public Journalist registerFromX(String xHandle) {
        XUserResponse response = xApiClient.getUserByUsername(xHandle);
        XUserResponse.XUser user = response.data();

        Journalist journalist = Journalist.builder()
                .xHandle(user.username())
                .xUserId(user.id())
                .name(user.name())
                .profileImageUrl(user.profileImageUrl())
                .followerCount(user.publicMetrics().followersCount())
                .credibilityScore(0f)
                .lastSyncedAt(LocalDateTime.now())
                .build();

        return journalistRepository.save(journalist);
    }

    @Override
    @CacheEvict(cacheNames = "journalist:ranking", allEntries = true)
    @Transactional
    public void updateCredibilityScore(Long journalistId, float newScore) {
        Journalist journalist = findById(journalistId);

        Journalist updated = Journalist.builder()
                .id(journalist.getId())
                .xHandle(journalist.getXHandle())
                .name(journalist.getName())
                .profileImageUrl(journalist.getProfileImageUrl())
                .followerCount(journalist.getFollowerCount())
                .credibilityScore(newScore)
                .rank(journalist.getRank())
                .lastSyncedAt(journalist.getLastSyncedAt())
                .createdAt(journalist.getCreatedAt())
                .build();

        journalistRepository.save(updated);
        journalistRepository.updateAllRanks();
    }
}
