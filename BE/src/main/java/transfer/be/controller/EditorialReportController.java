package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import transfer.be.dto.request.EditorialReportRequest;
import transfer.be.dto.response.EditorialReportResponse;
import transfer.be.service.EditorialReportService;

import java.util.List;

@RestController
@RequestMapping("/api/editorial-reports")
@RequiredArgsConstructor
public class EditorialReportController {

    private final EditorialReportService service;

    @GetMapping
    public List<EditorialReportResponse> listPublished() {
        return service.findPublished();
    }

    @GetMapping("/all")
    public List<EditorialReportResponse> listAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public EditorialReportResponse getById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EditorialReportResponse create(@RequestBody EditorialReportRequest req) {
        return service.create(req);
    }

    @PutMapping("/{id}")
    public EditorialReportResponse update(@PathVariable Long id, @RequestBody EditorialReportRequest req) {
        return service.update(id, req);
    }
}
