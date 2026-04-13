package transfer.be.service;

import transfer.be.model.CredibilityMetric;
import transfer.be.model.Journalist;

import java.time.LocalDate;
import java.util.List;

public interface CredibilityMetricService {

    List<CredibilityMetric> findByJournalist(Journalist journalist);

    /**
     * 특정 기자의 월별 공신력 지표를 산출하고 저장.
     * credibility_score = speed×0.3 + accuracy×0.5 + impact×0.2
     *
     * @param measuredDate 산출 기준일 (보통 해당 월의 1일)
     */
    CredibilityMetric calculateAndSave(Journalist journalist, LocalDate measuredDate);

    /** 모든 기자의 이번 달 공신력 지표를 일괄 산출 */
    void calculateAllForCurrentMonth();
}