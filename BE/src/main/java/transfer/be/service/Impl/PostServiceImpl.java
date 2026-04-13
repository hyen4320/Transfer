package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.api.XApiClient;
import transfer.be.api.dto.XTweetResponse;
import transfer.be.model.Journalist;
import transfer.be.model.Post;
import transfer.be.repository.PostRepository;
import transfer.be.service.PostService;

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

        XTweetResponse response = xApiClient.getUserTweets(journalist.getXHandle(), sinceId);

        if (response == null || response.data() == null) {
            log.info("No new posts for @{}", journalist.getXHandle());
            return List.of();
        }

        List<Post> saved = new ArrayList<>();
        for (XTweetResponse.XTweet tweet : response.data()) {
            if (postRepository.existsByXPostId(tweet.id())) {
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
        }

        log.info("Collected {} new posts from @{}", saved.size(), journalist.getXHandle());
        return saved;
    }

    private LocalDateTime parsePostedAt(String createdAt) {
        if (createdAt == null) return LocalDateTime.now();
        return OffsetDateTime.parse(createdAt).toLocalDateTime();
    }
}