package transfer.be.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.Club;
import transfer.be.model.League;

import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class ClubRepositoryTest {

    @Autowired ClubRepository clubRepository;
    @Autowired LeagueRepository leagueRepository;

    private League premierLeague;
    private League laLiga;
    private Set<Long> savedClubIds;

    @BeforeEach
    void setUp() {
        premierLeague = leagueRepository.save(League.builder().name("test_PL").countryCode("GB").tier(1).build());
        laLiga        = leagueRepository.save(League.builder().name("test_LL").countryCode("ES").tier(1).build());

        Club arsenal   = clubRepository.save(Club.builder().league(premierLeague).name("test_Arsenal").countryCode("GB").build());
        Club chelsea   = clubRepository.save(Club.builder().league(premierLeague).name("test_Chelsea").countryCode("GB").build());
        Club barcelona = clubRepository.save(Club.builder().league(laLiga).name("test_Barcelona").countryCode("ES").build());
        savedClubIds = Set.of(arsenal.getId(), chelsea.getId(), barcelona.getId());
    }

    @Test
    @DisplayName("리그로 소속 구단을 조회한다")
    void findByLeague_프리미어리그_구단만_반환() {
        List<Club> result = clubRepository.findByLeague(premierLeague).stream()
                .filter(c -> savedClubIds.contains(c.getId()))
                .toList();

        assertThat(result).hasSize(2);
        assertThat(result).extracting(Club::getName)
                .containsExactlyInAnyOrder("test_Arsenal", "test_Chelsea");
    }

    @Test
    @DisplayName("국가 코드로 구단을 조회한다")
    void findByCountryCode_스페인_구단만_반환() {
        List<Club> result = clubRepository.findByCountryCode("ES").stream()
                .filter(c -> savedClubIds.contains(c.getId()))
                .toList();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("test_Barcelona");
    }

    @Test
    @DisplayName("구단명으로 단건 조회한다")
    void findByName_존재_여부() {
        assertThat(clubRepository.findByName("test_Arsenal")).isPresent();
        assertThat(clubRepository.findByName("test_notExistClub_xyz")).isEmpty();
    }
}
