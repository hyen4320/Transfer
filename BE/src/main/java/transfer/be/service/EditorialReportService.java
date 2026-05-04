package transfer.be.service;

import transfer.be.dto.request.EditorialReportRequest;
import transfer.be.dto.response.EditorialReportResponse;

import java.util.List;

public interface EditorialReportService {
    EditorialReportResponse create(EditorialReportRequest req);
    EditorialReportResponse update(Long id, EditorialReportRequest req);
    EditorialReportResponse findById(Long id);
    List<EditorialReportResponse> findPublished();
    List<EditorialReportResponse> findAll();
}
