package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.api.XApiClient;
import transfer.be.api.dto.XTweetResponse;
import transfer.be.model.Journalist;
import transfer.be.model.Post;
import transfer.be.model.TransferNews.Status;
import transfer.be.repository.PostRepository;
import transfer.be.service.PostService;
import transfer.be.service.TransferNewsFilter;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostServiceImpl implements PostService {

    private final PostRepository postRepository;
    private final XApiClient xApiClient;
    private final TransferNewsFilter transferNewsFilter;

    @Override
    @Transactional(readOnly = true)
    public List<Post> findByJournalist(Journalist journalist) {
        return postRepository.findByJournalistOrderByPostedAtDesc(journalist);
    }

    @Override
    @Transactional
    public List<Post> collectAndSave(Journalist journalist) {
        String sinceId = postRepository
                .findTopByJournalistOrderByPostedAtDesc(journalist)
                .map(Post::getXPostId)
                .orElse(null);

        String userId = journalist.getXUserId();
        if (userId == null) {
            log.warn("xUserId 없음 — @{} 수집 스킵 (registerFromX로 재등록 필요)", journalist.getXHandle());
            return List.of();
        }

        XTweetResponse response = xApiClient.getUserTweets(userId, sinceId);

        if (response == null || response.data() == null) {
            log.info("No new posts for @{}", journalist.getXHandle());
            return List.of();
        }

        List<Post> saved = new ArrayList<>();
        int skippedNonTransfer = 0;
        for (XTweetResponse.XTweet tweet : response.data()) {
            if (postRepository.existsByXPostId(tweet.id())) {
                continue;
            }

            Status status = transferNewsFilter.detectStatus(tweet.text());
            if (status == null) {
                skippedNonTransfer++;
                continue;
            }

            Post post = Post.builder()
                    .journalist(journalist)
                    .xPostId(tweet.id())
                    .content(tweet.text())
                    .likeCount(tweet.publicMetrics().likeCount())
                    .retweetCount(tweet.publicMetrics().retweetCount())
                    .replyCount(tweet.publicMetrics().replyCount())
                    .viewCount(tweet.publicMetrics().impressionCount())
                    .postedAt(parsePostedAt(tweet.createdAt()))
                    .build();

            saved.add(postRepository.save(post));
            log.info("[TRANSFER] @{} status={} | {}", journalist.getXHandle(), status, tweet.text());
        }

        log.info("Collected {} transfer posts from @{} (skipped {} non-transfer)",
                saved.size(), journalist.getXHandle(), skippedNonTransfer);
        return saved;
    }

    private LocalDateTime parsePostedAt(String createdAt) {
        if (createdAt == null) return LocalDateTime.now();
        return OffsetDateTime.parse(createdAt).toLocalDateTime();
    }
}