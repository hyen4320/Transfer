package transfer.be.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import transfer.be.dto.response.FixtureItem;
import transfer.be.dto.response.MatchEventItem;
import transfer.be.dto.response.MatchStatItem;
import transfer.be.model.Fixture;
import transfer.be.model.MatchEvent;
import transfer.be.model.MatchStat;
import transfer.be.repository.FixtureRepository;
import transfer.be.repository.MatchEventRepository;
import transfer.be.repository.MatchStatRepository;
import transfer.be.service.impl.FixtureStorageServiceImpl;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class FixtureStorageServiceTest {

    @Mock FixtureRepository    fixtureRepository;
    @Mock MatchEventRepository matchEventRepository;
    @Mock MatchStatRepository  matchStatRepository;
    @Mock FixturesService      fixturesService;

    @InjectMocks FixtureStorageServiceImpl service;

    private FixtureItem finished;
    private FixtureItem scheduled;

    @BeforeEach
    void setUp() {
        finished = FixtureItem.builder()
                .id(999L).leagueId("pl").date("2026-05-10").kickoff("20:00")
                .state("finished").minute(90)
                .homeTeam("Arsenal").awayTeam("Liverpool")
                .homeScore(2).awayScore(1)
                .matchday(36).venue("Emirates Stadium").referee("Anthony Taylor")
                .build();

        scheduled = FixtureItem.builder()
                .id(1000L).leagueId("pl").date("2026-05-17").kickoff("15:00")
                .state("scheduled").minute(0)
                .homeTeam("Man City").awayTeam("Chelsea")
                .homeScore(null).awayScore(null)
                .matchday(37).venue("Etihad Stadium").referee("")
                .build();
    }

    // ─── storeIfFinished ─────────────────────────────────────────────────────

    @Nested
    @DisplayName("storeIfFinished")
    class StoreIfFinished {

        @Test
        @DisplayName("종료된 경기 → Fixture 저장")
        void 종료경기_fixture_저장() {
            when(fixtureRepository.existsById(999L)).thenReturn(false);
            when(fixtureRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(fixturesService.getMatchEvents(999L)).thenReturn(List.of());
            when(fixturesService.getMatchStats(999L)).thenReturn(null);

            service.storeIfFinished(finished);

            ArgumentCaptor<Fixture> captor = ArgumentCaptor.forClass(Fixture.class);
            verify(fixtureRepository).save(captor.capture());

            Fixture saved = captor.getValue();
            assertThat(saved.getId()).isEqualTo(999L);
            assertThat(saved.getHomeTeam()).isEqualTo("Arsenal");
            assertThat(saved.getHomeScore()).isEqualTo(2);
            assertThat(saved.getAwayScore()).isEqualTo(1);
        }

        @Test
        @DisplayName("scheduled 경기 → 저장 안 함")
        void scheduled_경기_스킵() {
            service.storeIfFinished(scheduled);
            verify(fixtureRepository, never()).save(any());
        }

        @Test
        @DisplayName("이미 저장된 경기 → 중복 저장 안 함")
        void 중복_스킵() {
            when(fixtureRepository.existsById(999L)).thenReturn(true);
            service.storeIfFinished(finished);
            verify(fixtureRepository, never()).save(any());
        }

        @Test
        @DisplayName("이벤트 포함 → MatchEvent 일괄 저장")
        void 이벤트_저장() {
            when(fixtureRepository.existsById(999L)).thenReturn(false);
            when(fixtureRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            List<MatchEventItem> events = List.of(
                    MatchEventItem.builder().minute(23).type("goal")
                            .teamName("Arsenal").player("Saka").assist("Odegaard").detail("Normal Goal").build(),
                    MatchEventItem.builder().minute(67).type("yellow")
                            .teamName("Liverpool").player("Salah").assist(null).detail("Foul").build()
            );
            when(fixturesService.getMatchEvents(999L)).thenReturn(events);
            when(fixturesService.getMatchStats(999L)).thenReturn(null);

            service.storeIfFinished(finished);

            ArgumentCaptor<List<MatchEvent>> captor = ArgumentCaptor.forClass(List.class);
            verify(matchEventRepository).saveAll(captor.capture());

            List<MatchEvent> saved = captor.getValue();
            assertThat(saved).hasSize(2);
            assertThat(saved.get(0).getPlayerName()).isEqualTo("Saka");
            assertThat(saved.get(0).getType()).isEqualTo("goal");
            assertThat(saved.get(1).getType()).isEqualTo("yellow");
        }

        @Test
        @DisplayName("스탯 포함 → MatchStat 저장")
        void 스탯_저장() {
            when(fixtureRepository.existsById(999L)).thenReturn(false);
            when(fixtureRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(fixturesService.getMatchEvents(999L)).thenReturn(List.of());

            MatchStatItem stat = MatchStatItem.builder()
                    .possession(new int[]{58, 42})
                    .shots(new int[]{14, 7})
                    .shotsOnTarget(new int[]{6, 2})
                    .xG(new double[]{1.9, 0.7})
                    .passes(new int[]{530, 360})
                    .corners(new int[]{6, 3})
                    .build();
            when(fixturesService.getMatchStats(999L)).thenReturn(stat);

            service.storeIfFinished(finished);

            ArgumentCaptor<MatchStat> captor = ArgumentCaptor.forClass(MatchStat.class);
            verify(matchStatRepository).save(captor.capture());

            MatchStat saved = captor.getValue();
            assertThat(saved.getHomePossession()).isEqualTo(58);
            assertThat(saved.getHomeXg()).isEqualTo(1.9);
            assertThat(saved.getAwayShots()).isEqualTo(7);
        }

        @Test
        @DisplayName("이벤트 조회 실패 → Fixture는 저장 유지")
        void 이벤트_실패시_fixture_유지() {
            when(fixtureRepository.existsById(999L)).thenReturn(false);
            when(fixtureRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(fixturesService.getMatchEvents(999L)).thenThrow(new RuntimeException("API error"));
            when(fixturesService.getMatchStats(999L)).thenReturn(null);

            // 예외 미전파 확인
            service.storeIfFinished(finished);

            verify(fixtureRepository).save(any());
            verify(matchEventRepository, never()).saveAll(any());
        }
    }

    // ─── storeDateFixtures ───────────────────────────────────────────────────

    @Nested
    @DisplayName("storeDateFixtures")
    class StoreDateFixtures {

        @Test
        @DisplayName("날짜별 리그 경기 일괄 처리")
        void 날짜별_일괄처리() {
            when(fixturesService.getFixtures("pl", "2026-05-10"))
                    .thenReturn(List.of(finished, scheduled));
            when(fixtureRepository.existsById(999L)).thenReturn(false);
            when(fixtureRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(fixturesService.getMatchEvents(anyLong())).thenReturn(List.of());
            when(fixturesService.getMatchStats(anyLong())).thenReturn(null);

            service.storeDateFixtures("pl", "2026-05-10");

            // finished만 저장, scheduled는 스킵
            verify(fixtureRepository, times(1)).save(any());
        }
    }

    // ─── storeAllLeaguesDate ─────────────────────────────────────────────────

    @Nested
    @DisplayName("storeAllLeaguesDate")
    class StoreAllLeaguesDate {

        @Test
        @DisplayName("5개 리그 전체 호출")
        void 전리그_호출() {
            when(fixturesService.getFixtures(anyString(), eq("2026-05-10")))
                    .thenReturn(List.of());

            service.storeAllLeaguesDate("2026-05-10");

            verify(fixturesService, times(5)).getFixtures(anyString(), eq("2026-05-10"));
        }
    }
}
