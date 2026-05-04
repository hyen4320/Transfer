package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "editorial_report")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class EditorialReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "report_id")
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "text")
    private String deck;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReportType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReportFormat format;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Classification classification;

    @Column(name = "read_minutes")
    private Integer readMinutes;

    @Column(name = "cover_tone")
    private String coverTone;

    @Column(name = "cover_motif")
    private String coverMotif;

    /** 쉼표 구분 태그 문자열 */
    @Column(columnDefinition = "text")
    private String tags;

    /** 블록 배열 JSON 문자열 */
    @Column(columnDefinition = "text")
    private String blocks;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReportStatus status;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    public enum ReportType    { ANALYSIS, DATA }
    public enum ReportFormat  { LONGFORM, DASHBOARD, BRIEF }
    public enum Classification { OPEN_SOURCE, SOURCED, DATA_ROOM }
    public enum ReportStatus  { DRAFT, READY, PUBLISHED }

    public void applyUpdate(String title, String deck, ReportType type, ReportFormat format,
                            Classification classification, Integer readMinutes,
                            String coverTone, String coverMotif, String tags, String blocks,
                            ReportStatus status) {
        this.title = title;
        this.deck = deck;
        this.type = type;
        this.format = format;
        this.classification = classification;
        this.readMinutes = readMinutes;
        this.coverTone = coverTone;
        this.coverMotif = coverMotif;
        this.tags = tags;
        this.blocks = blocks;
        this.status = status;
        if (status == ReportStatus.PUBLISHED && this.publishedAt == null) {
            this.publishedAt = LocalDateTime.now();
        }
    }
}
