package transfer.be.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import transfer.be.model.Journalist;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@Transactional
class JournalistRepositoryTest {

    @Autowired JournalistRepository journalistRepository;
    @PersistenceContext EntityManager entityManager;

    @Test
    @DisplayName("xHandle로 기자를 조회한다")
    void findByXHandle_존재하면_반환() {
        journalistRepository.save(Journalist.builder()
                .xHandle("test_findByHandle").name("Fabrizio Romano").credibilityScore(0f).build());

        Optional<Journalist> result = journalistRepository.findByXHandle("test_findByHandle");

        assertThat(result).isPresent();
        assertThat(result.get().getName()).isEqualTo("Fabrizio Romano");
    }

    @Test
    @DisplayName("없는 xHandle은 빈 Optional을 반환한다")
    void findByXHandle_없으면_빈Optional() {
        Optional<Journalist> result = journalistRepository.findByXHandle("unknown");
        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("xHandle 중복 여부를 확인한다")
    void existsByXHandle_중복_확인() {
        journalistRepository.save(Journalist.builder()
                .xHandle("Romano").name("Romano").credibilityScore(0f).build());

        assertThat(journalistRepository.existsByXHandle("Romano")).isTrue();
        assertThat(journalistRepository.existsByXHandle("unknown")).isFalse();
    }

    @Test
    @DisplayName("updateAllRanks는 공신력 점수가 높을수록 낮은 순위(1위)를 부여한다")
    void updateAllRanks_공신력_높을수록_1위() {
        Journalist low  = journalistRepository.save(Journalist.builder().xHandle("low").name("Low").credibilityScore(30f).build());
        Journalist high = journalistRepository.save(Journalist.builder().xHandle("high").name("High").credibilityScore(90f).build());
        Journalist mid  = journalistRepository.save(Journalist.builder().xHandle("mid").name("Mid").credibilityScore(60f).build());
        List<Long> savedIds = List.of(low.getId(), high.getId(), mid.getId());
        entityManager.flush();

        journalistRepository.updateAllRanks();
        entityManager.clear();

        List<Journalist> ranked = journalistRepository.findAllByOrderByRankAsc().stream()
                .filter(j -> savedIds.contains(j.getId()))
                .toList();

        assertThat(ranked).hasSize(3);
        assertThat(ranked.get(0).getXHandle()).isEqualTo("high");  // rank 1
        assertThat(ranked.get(1).getXHandle()).isEqualTo("mid");   // rank 2
        assertThat(ranked.get(2).getXHandle()).isEqualTo("low");   // rank 3
    }

    @Test
    @DisplayName("동일한 공신력 점수는 같은 순위를 갖는다")
    void updateAllRanks_동점이면_같은_순위() {
        Journalist a = journalistRepository.save(Journalist.builder().xHandle("a").name("A").credibilityScore(80f).build());
        Journalist b = journalistRepository.save(Journalist.builder().xHandle("b").name("B").credibilityScore(80f).build());
        List<Long> savedIds = List.of(a.getId(), b.getId());
        entityManager.flush();

        journalistRepository.updateAllRanks();
        entityManager.clear();

        List<Journalist> saved = journalistRepository.findAll().stream()
                .filter(j -> savedIds.contains(j.getId()))
                .toList();
        assertThat(saved).allMatch(j -> j.getRank() == 1);
    }
}
