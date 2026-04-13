package transfer.be.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "league")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class League {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "league_id")
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(name = "country_code", length = 2)
    private String countryCode;

    @Column(name = "logo_url")
    private String logoUrl;

    /** 1부·2부 리그 구분 */
    private Integer tier;
}