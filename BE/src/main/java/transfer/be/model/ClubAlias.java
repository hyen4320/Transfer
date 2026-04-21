package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "club_aliases", uniqueConstraints = @UniqueConstraint(columnNames = "alias"))
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ClubAlias {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "club_id", nullable = false)
    private Club club;

    @Column(nullable = false, length = 100)
    private String alias;

    @Column(length = 10)
    private String lang = "en";

    /** 출처: manual | transfermarkt | wikipedia */
    @Column(length = 50)
    private String source;
}
