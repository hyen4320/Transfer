package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import transfer.be.model.EditorialReport;

import java.util.List;

public interface EditorialReportRepository extends JpaRepository<EditorialReport, Long> {

    List<EditorialReport> findByStatusOrderByCreatedAtDesc(EditorialReport.ReportStatus status);

    List<EditorialReport> findAllByOrderByCreatedAtDesc();

    void deleteByTypeAndTagsContaining(EditorialReport.ReportType type, String tag);

    @Query("select r.id from EditorialReport r where r.status = 'PUBLISHED'")
    List<Long> findAllPublishedIds();
}
