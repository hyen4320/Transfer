package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import transfer.be.model.Journalist;
import transfer.be.model.Post;

import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {

    @Query("SELECT COUNT(p) > 0 FROM Post p WHERE p.xPostId = :xPostId")
    boolean existsByXPostId(String xPostId);

    @Query("SELECT p FROM Post p WHERE p.xPostId = :xPostId")
    Optional<Post> findByXPostId(String xPostId);

    /** 기자의 가장 최근 게시물 — since_id 계산에 사용 */
    Optional<Post> findTopByJournalistOrderByPostedAtDesc(Journalist journalist);

    List<Post> findByJournalistOrderByPostedAtDesc(Journalist journalist);
}