package transfer.be.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.dto.request.EditorialReportRequest;
import transfer.be.dto.response.EditorialReportResponse;
import transfer.be.model.EditorialReport;
import transfer.be.repository.EditorialReportRepository;
import transfer.be.service.EditorialReportService;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EditorialReportServiceImpl implements EditorialReportService {

    private final EditorialReportRepository repo;

    @Override
    @Transactional
    public EditorialReportResponse create(EditorialReportRequest req) {
        EditorialReport report = EditorialReport.builder()
                .title(req.title())
                .deck(req.deck())
                .type(parseType(req.type()))
                .format(parseFormat(req.format()))
                .classification(parseClassification(req.classification()))
                .readMinutes(req.readMinutes())
                .coverTone(req.coverTone())
                .coverMotif(req.coverMotif())
                .tags(joinTags(req.tags()))
                .blocks(req.blocks())
                .status(parseStatus(req.status()))
                .createdAt(LocalDateTime.now())
                .publishedAt(parseStatus(req.status()) == EditorialReport.ReportStatus.PUBLISHED ? LocalDateTime.now() : null)
                .build();
        return EditorialReportResponse.from(repo.save(report));
    }

    @Override
    @Transactional
    public EditorialReportResponse update(Long id, EditorialReportRequest req) {
        EditorialReport report = repo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Report not found: " + id));
        report.applyUpdate(
                req.title(), req.deck(),
                parseType(req.type()), parseFormat(req.format()), parseClassification(req.classification()),
                req.readMinutes(),
                req.coverTone(), req.coverMotif(),
                joinTags(req.tags()), req.blocks(),
                parseStatus(req.status())
        );
        return EditorialReportResponse.from(report);
    }

    @Override
    @Transactional(readOnly = true)
    public EditorialReportResponse findById(Long id) {
        return repo.findById(id)
                .map(EditorialReportResponse::from)
                .orElseThrow(() -> new IllegalArgumentException("Report not found: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<EditorialReportResponse> findPublished() {
        return repo.findByStatusOrderByCreatedAtDesc(EditorialReport.ReportStatus.PUBLISHED)
                .stream().map(EditorialReportResponse::from).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<EditorialReportResponse> findAll() {
        return repo.findAllByOrderByCreatedAtDesc()
                .stream().map(EditorialReportResponse::from).toList();
    }

    private EditorialReport.ReportType parseType(String v) {
        return switch (v == null ? "analysis" : v.toLowerCase()) {
            case "data" -> EditorialReport.ReportType.DATA;
            default     -> EditorialReport.ReportType.ANALYSIS;
        };
    }

    private EditorialReport.ReportFormat parseFormat(String v) {
        return switch (v == null ? "longform" : v.toLowerCase()) {
            case "dashboard" -> EditorialReport.ReportFormat.DASHBOARD;
            case "brief"     -> EditorialReport.ReportFormat.BRIEF;
            default          -> EditorialReport.ReportFormat.LONGFORM;
        };
    }

    private EditorialReport.Classification parseClassification(String v) {
        return switch (v == null ? "open-source" : v.toLowerCase()) {
            case "sourced"   -> EditorialReport.Classification.SOURCED;
            case "data-room" -> EditorialReport.Classification.DATA_ROOM;
            default          -> EditorialReport.Classification.OPEN_SOURCE;
        };
    }

    private EditorialReport.ReportStatus parseStatus(String v) {
        return switch (v == null ? "draft" : v.toLowerCase()) {
            case "ready"     -> EditorialReport.ReportStatus.READY;
            case "published" -> EditorialReport.ReportStatus.PUBLISHED;
            default          -> EditorialReport.ReportStatus.DRAFT;
        };
    }

    private String joinTags(List<String> tags) {
        if (tags == null || tags.isEmpty()) return null;
        return String.join(",", tags.stream().map(String::trim).filter(t -> !t.isEmpty()).toList());
    }
}
