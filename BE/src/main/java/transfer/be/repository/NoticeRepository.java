package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.Notice;

import java.util.List;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    List<Notice> findAllByOrderByPublishedAtDesc();
}
