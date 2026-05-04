package transfer.be.dto.response;

import transfer.be.model.EditorialReport;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

public record EditorialReportResponse(
        Long id,
        String title,
        String deck,
        String type,
        String format,
        String classification,
        Integer readMinutes,
        String coverTone,
        String coverMotif,
        List<String> tags,
        String blocks,
        String status,
        LocalDateTime createdAt,
        LocalDateTime publishedAt
) {
    public static EditorialReportResponse from(EditorialReport r) {
        List<String> tagList = (r.getTags() != null && !r.getTags().isBlank())
                ? Arrays.asList(r.getTags().split(","))
                : List.of();

        return new EditorialReportResponse(
                r.getId(),
                r.getTitle(),
                r.getDeck(),
                r.getType().name().toLowerCase(),
                r.getFormat().name().toLowerCase(),
                r.getClassification().name().toLowerCase().replace('_', '-'),
                r.getReadMinutes(),
                r.getCoverTone(),
                r.getCoverMotif(),
                tagList,
                r.getBlocks(),
                r.getStatus().name().toLowerCase(),
                r.getCreatedAt(),
                r.getPublishedAt()
        );
    }
}
