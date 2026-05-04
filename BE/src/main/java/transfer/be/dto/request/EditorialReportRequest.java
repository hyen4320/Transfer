package transfer.be.dto.request;

import java.util.List;

public record EditorialReportRequest(
        String title,
        String deck,
        String type,           // "analysis" | "data"
        String format,         // "longform" | "dashboard" | "brief"
        String classification, // "open-source" | "sourced" | "data-room"
        Integer readMinutes,
        String coverTone,
        String coverMotif,
        List<String> tags,
        String blocks,         // JSON 문자열
        String status          // "draft" | "ready" | "published"
) {}
