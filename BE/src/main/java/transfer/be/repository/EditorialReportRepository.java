package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.EditorialReport;

import java.util.List;

public interface EditorialReportRepository extends JpaRepository<EditorialReport, Long> {

    List<EditorialReport> findByStatusOrderByCreatedAtDesc(EditorialReport.ReportStatus status);

    List<EditorialReport> findAllByOrderByCreatedAtDesc();

    void deleteByTypeAndTagsContaining(EditorialReport.ReportType type, String tag);
}
