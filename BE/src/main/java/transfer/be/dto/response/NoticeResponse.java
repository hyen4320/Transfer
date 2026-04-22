package transfer.be.dto.response;

import transfer.be.model.Notice;

import java.time.LocalDate;

public record NoticeResponse(Long id, String tag, String title, String body, LocalDate publishedAt) {
    public static NoticeResponse from(Notice n) {
        return new NoticeResponse(n.getId(), n.getTag().name().toLowerCase(), n.getTitle(), n.getBody(), n.getPublishedAt());
    }
}
