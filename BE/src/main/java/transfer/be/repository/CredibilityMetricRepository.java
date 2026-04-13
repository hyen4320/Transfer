package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import transfer.be.model.CredibilityMetric;
import transfer.be.model.Journalist;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface CredibilityMetricRepository extends JpaRepository<CredibilityMetric, Long> {

    Optional<CredibilityMetric> findByJournalistAndMeasuredDate(Journalist journalist, LocalDate measuredDate);

    /** 기자의 월별 지표 이력 (최신순) */
    List<CredibilityMetric> findByJournalistOrderByMeasuredDateDesc(Journalist journalist);
}