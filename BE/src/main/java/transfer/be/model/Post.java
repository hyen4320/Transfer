package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "post")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "journalist_id", nullable = false)
    private Journalist journalist;

    /** 원본 X 게시물 ID */
    @Column(name = "x_post_id", unique = true, nullable = false)
    private String xPostId;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(name = "like_count")
    private Integer likeCount;

    @Column(name = "retweet_count")
    private Integer retweetCount;

    @Column(name = "reply_count")
    private Integer replyCount;

    @Column(name = "view_count")
    private Integer viewCount;

    @Column(name = "posted_at")
    private LocalDateTime postedAt;

    @Column(name = "collected_at")
    private LocalDateTime collectedAt;

    @PrePersist
    private void prePersist() {
        this.collectedAt = LocalDateTime.now();
    }
}