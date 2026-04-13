package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "player")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Player {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "player_id")
    private Long id;

    @Column(nullable = false)
    private String name;

    private String nationality;

    /** GK | DF | MF | FW */
    @Enumerated(EnumType.STRING)
    private Position position;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "current_club_id")
    private Club currentClub;

    @Column(name = "contract_until")
    private LocalDate contractUntil;

    @Column(name = "profile_image_url")
    private String profileImageUrl;

    public enum Position {
        GK, DF, MF, FW
    }
}