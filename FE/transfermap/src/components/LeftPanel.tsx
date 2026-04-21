import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import type { League, Player } from '../types';
import type { ApiLeague } from '../api/types';
import { LEAGUES, CLUBS, PLAYERS, JOURNALISTS, NEWS } from '../data/mock';
import { fetchLeagues } from '../api/leagues';
import { fetchPlayersSearch } from '../api/players';
import { fetchJournalists } from '../api/journalists';
import { fetchAllClubs } from '../api/clubs';
import { fetchNewsPage } from '../api/news';
import type { NewsFilterParams } from '../api/news';
import type { Club, Journalist } from '../types';

// league name → FE id
const LEAGUE_NAME_TO_ID: Record<string, string> = {
  'Premier League': 'pl',
  'La Liga':        'll',
  'Bundesliga':     'bl',
  'Serie A':        'sa',
  'Ligue 1':        'l1',
};

// time window → ISO date range
function timeWindowToDates(w: string): { from?: string; to?: string } {
  const now = new Date();
  const fmt = (d: Date) => d.toISOString().slice(0, 10);
  if (w === '24h')  return { from: fmt(new Date(now.getTime() - 86_400_000)) };
  if (w === '7d')   return { from: fmt(new Date(now.getTime() - 7  * 86_400_000)) };
  if (w === '30d')  return { from: fmt(new Date(now.getTime() - 30 * 86_400_000)) };
  return {};
}

const POSITIONS = ['ALL', 'GK', 'DF', 'MF', 'FW'];
const TIME_OPTIONS = ['24h', '7d', '30d', '이번 창', '전체'];
const TRENDING = ['Mbappé', 'Bellingham', 'Haaland', 'Saka', 'Yamal'];
const RECENT = ['Haaland', 'Jude Bellingham', 'Saka'];

type Tab = 'filter' | 'player';
type Scope = 'player' | 'club' | 'journalist';
type FlyStep = 'idle' | 'zooming' | 'arrived';

// season encoding: 25+26=51 (25/26), 24+25=49 (24/25)
const SEASON_OPTIONS = [
  { label: '25/26 (현재)', value: 51 },
  { label: '24/25',        value: 49 },
];

interface FilterState {
  leagues: Set<string>;
  statuses: Set<string>;
  position: string;
  timeWindow: string;
  feeMin: number;
  feeMax: number;
  season: number;
}

const defaultFilters = (): FilterState => ({
  leagues:    new Set(['pl', 'll', 'bl']),
  statuses:   new Set(['rumour', 'confirmed']),
  position:   'ALL',
  timeWindow: '7d',
  feeMin:     0,
  feeMax:     300,
  season:     51,
});

interface Props {
  open: boolean;
  onClose: () => void;
  onFlyTo: (player: Player, league: League) => void;
  onApplyFilter?: (params: NewsFilterParams[], statuses: Set<string>) => void;
}

export default function LeftPanel({ open, onClose, onFlyTo, onApplyFilter }: Props) {
  const navigate = useNavigate();
  const [tab, setTab] = useState<Tab>('filter');
  const [filters, setFilters] = useState<FilterState>(defaultFilters);

  // API-loaded league id mapping (BE DB id → FE league id)
  const [apiLeagues, setApiLeagues] = useState<ApiLeague[]>([]);

  // All clubs/journalists for client-side club/journalist search
  const [allClubs, setAllClubs] = useState<Club[]>(CLUBS);
  const [allJournalists, setAllJournalists] = useState<Journalist[]>(JOURNALISTS);

  // Filter result count
  const [filterCount, setFilterCount] = useState<number>(NEWS.length);
  const [filterCountLoading, setFilterCountLoading] = useState(false);

  // Player search state
  const [query, setQuery] = useState('');
  const [scope, setScope] = useState<Scope>('player');
  const [searchResults, setSearchResults] = useState<(Player | Club | Journalist)[]>([]);
  const [searchLoading, setSearchLoading] = useState(false);

  // Fly-to state
  const [flyStep, setFlyStep] = useState<FlyStep>('idle');
  const [flyPlayer, setFlyPlayer] = useState<Player | null>(null);
  const [flyLeague, setFlyLeague] = useState<League | null>(null);
  const [progress, setProgress] = useState(0);

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Load leagues and supporting data once on mount
  useEffect(() => {
    fetchLeagues().then(setApiLeagues).catch(() => {});
    fetchAllClubs().then(c => { if (c.length) setAllClubs(c); }).catch(() => {});
    fetchJournalists().then(j => { if (j.length) setAllJournalists(j); }).catch(() => {});
  }, []);

  // Reset fly state when panel closes
  useEffect(() => {
    if (!open) {
      setFlyStep('idle');
      setFlyPlayer(null);
      setFlyLeague(null);
      setProgress(0);
    }
  }, [open]);

  // Progress bar animation during zoom
  useEffect(() => {
    if (flyStep !== 'zooming') return;
    const start = Date.now();
    let raf: number;
    const tick = () => {
      const pct = Math.min(((Date.now() - start) / 720) * 100, 100);
      setProgress(pct);
      if (pct < 100) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [flyStep]);

  // Debounced search
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    if (!query.trim() || flyStep !== 'idle') {
      setSearchResults([]);
      return;
    }
    debounceRef.current = setTimeout(() => {
      runSearch(query.trim(), scope);
    }, 250);
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query, scope, flyStep]);

  const runSearch = useCallback(async (q: string, s: Scope) => {
    setSearchLoading(true);
    try {
      if (s === 'player') {
        const results = await fetchPlayersSearch(q, 8);
        setSearchResults(results.length ? results : PLAYERS.filter(p =>
          p.name.toLowerCase().includes(q.toLowerCase())
        ).slice(0, 8));
      } else if (s === 'club') {
        setSearchResults(allClubs.filter(c =>
          c.name.toLowerCase().includes(q.toLowerCase())
        ).slice(0, 8));
      } else {
        setSearchResults(allJournalists.filter(j =>
          j.name.toLowerCase().includes(q.toLowerCase()) ||
          j.handle.toLowerCase().includes(q.toLowerCase())
        ).slice(0, 8));
      }
    } catch {
      // fallback to mock
      if (s === 'player') {
        setSearchResults(PLAYERS.filter(p =>
          p.name.toLowerCase().includes(q.toLowerCase())
        ).slice(0, 8));
      }
    } finally {
      setSearchLoading(false);
    }
  }, [allClubs, allJournalists]);

  // Fetch filter result count when filters change
  useEffect(() => {
    if (!open || tab !== 'filter') return;
    const leagueFEIds = [...filters.leagues];
    const statuses = [...filters.statuses];
    if (statuses.length === 0) { setFilterCount(0); return; }

    const { from, to } = timeWindowToDates(filters.timeWindow);
    const minFeeEur = filters.feeMin > 0 ? filters.feeMin * 1_000_000 : undefined;
    const maxFeeEur = filters.feeMax < 300 ? filters.feeMax * 1_000_000 : undefined;
    const position = filters.position !== 'ALL' ? filters.position : undefined;

    // Map FE league IDs to BE DB IDs
    const beLeagueIds = leagueFEIds
      .map(feId => apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === feId)?.id)
      .filter((id): id is number => id != null);

    const doFetch = async () => {
      setFilterCountLoading(true);
      try {
        // Make one request per status × league combination, then sum totals
        let total = 0;
        const leagueTargets = beLeagueIds.length > 0 ? beLeagueIds : [undefined];
        for (const status of statuses) {
          for (const leagueId of leagueTargets) {
            const beStatus = status === 'rumour' ? 'RUMOR'
              : status.toUpperCase();
            const { total: t } = await fetchNewsPage({
              status: beStatus,
              leagueId,
              position,
              minFeeEur,
              maxFeeEur,
              from,
              to,
              size: 1,
            });
            total += t;
          }
        }
        setFilterCount(total);
      } catch {
        // fallback: count from mock
        setFilterCount(NEWS.filter(n => filters.statuses.has(n.status)).length);
      } finally {
        setFilterCountLoading(false);
      }
    };

    const timer = setTimeout(doFetch, 400);
    return () => clearTimeout(timer);
  }, [filters, open, tab, apiLeagues]);

  const toggleSet = (key: 'leagues' | 'statuses', val: string) => {
    setFilters(prev => {
      const next = new Set(prev[key]);
      next.has(val) ? next.delete(val) : next.add(val);
      return { ...prev, [key]: next };
    });
  };

  const handlePlayerSelect = (player: Player) => {
    const leagueId = LEAGUE_NAME_TO_ID[player.currentLeague ?? ''];
    const league = LEAGUES.find(l => l.id === leagueId);
    if (!league) return;

    setFlyPlayer(player);
    setFlyLeague(league);
    setFlyStep('zooming');
    setProgress(0);

    onFlyTo(player, league);

    setTimeout(() => setFlyStep('arrived'), 750);
  };

  const resetFly = () => {
    setFlyStep('idle');
    setFlyPlayer(null);
    setFlyLeague(null);
    setProgress(0);
    setQuery('');
    setSearchResults([]);
  };

  const leagueNewsCount = (feId: string) => {
    const beId = apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === feId)?.id;
    if (!beId) return NEWS.filter(n => {
      const c = CLUBS.find(club => club.name === n.from || club.name === n.to);
      return c?.league === feId;
    }).length;
    return '…';
  };

  const relatedPlayers = flyLeague
    ? (PLAYERS.filter(p =>
        LEAGUE_NAME_TO_ID[p.currentLeague ?? ''] === flyLeague.id && p.id !== flyPlayer?.id
      ))
    : [];

  return (
    <div className={`absolute top-0 left-0 w-[460px] h-screen flex flex-col z-[60]
                     bg-[rgba(8,14,26,0.96)] backdrop-blur-xl border-r border-[var(--border)]
                     transition-transform duration-[350ms] ease-[cubic-bezier(0.4,0,0.2,1)]
                     ${open ? 'translate-x-0' : '-translate-x-full'}`}>

      {/* Top bar */}
      <div className="flex items-center justify-between px-6 h-[52px] border-b border-[var(--border)] flex-shrink-0">
        <button onClick={onClose}
          className="text-[0.82rem] font-bold text-[var(--text-sub)] hover:text-[var(--text)] transition-colors">
          ← Map
        </button>
        <button onClick={onClose}
          className="w-8 h-8 flex items-center justify-center rounded-lg border border-[var(--border)]
                     text-[var(--text-sub)] hover:text-[var(--text)] hover:border-white/20 transition-all text-sm">
          ✕
        </button>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-[var(--border)] flex-shrink-0">
        {(['filter', 'player'] as Tab[]).map(t => (
          <button key={t} onClick={() => { setTab(t); resetFly(); }}
            className={`flex-1 py-3 text-[0.78rem] font-bold tracking-wide uppercase border-b-2 transition-all
              ${tab === t
                ? 'text-[var(--accent)] border-[var(--accent)]'
                : 'text-[var(--text-sub)] border-transparent hover:text-[var(--text)]'}`}>
            {t === 'filter' ? '⚙ 조건검색' : '⌕ 선수검색'}
          </button>
        ))}
      </div>

      {/* ── FILTER TAB ── */}
      {tab === 'filter' && (
        <div className="flex-1 flex flex-col overflow-hidden">
          <div className="flex-1 overflow-y-auto px-6 py-5 flex flex-col gap-5">

            <div className="flex items-center justify-between">
              <span className="text-[0.7rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">FILTERS</span>
              <button onClick={() => setFilters(defaultFilters())}
                className="text-[0.7rem] text-[var(--text-sub)] hover:text-[var(--text)]">↻ reset</button>
            </div>

            {/* Season */}
            <FilterSection label="시즌">
              <div className="flex flex-wrap gap-2 pt-1">
                {SEASON_OPTIONS.map(s => (
                  <button key={s.value} onClick={() => setFilters(f => ({ ...f, season: s.value }))}
                    className={`px-4 py-1.5 rounded-full text-[0.72rem] font-bold border transition-all
                      ${filters.season === s.value
                        ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                        : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40 hover:text-[var(--text)]'}`}>
                    {s.label}
                  </button>
                ))}
              </div>
            </FilterSection>

            {/* League */}
            <FilterSection label="리그">
              {LEAGUES.map(l => (
                <CheckRow key={l.id}
                  checked={filters.leagues.has(l.id)}
                  label={l.name}
                  count={leagueNewsCount(l.id)}
                  onChange={() => toggleSet('leagues', l.id)}
                />
              ))}
            </FilterSection>

            {/* Status */}
            <FilterSection label="이적 상태">
              {(['rumour', 'confirmed', 'denied', 'loan'] as const).map(s => (
                <CheckRow key={s}
                  checked={filters.statuses.has(s)}
                  label={s.charAt(0).toUpperCase() + s.slice(1)}
                  count={NEWS.filter(n => n.status === s).length}
                  onChange={() => toggleSet('statuses', s)}
                />
              ))}
            </FilterSection>

            {/* Position */}
            <FilterSection label="포지션">
              <div className="flex flex-wrap gap-2 pt-1">
                {POSITIONS.map(p => (
                  <button key={p} onClick={() => setFilters(f => ({ ...f, position: p }))}
                    className={`px-4 py-1.5 rounded-full text-[0.72rem] font-bold border transition-all
                      ${filters.position === p
                        ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                        : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40 hover:text-[var(--text)]'}`}>
                    {p}
                  </button>
                ))}
              </div>
            </FilterSection>

            {/* Fee range */}
            <FilterSection label="이적료">
              <div className="pt-1 flex flex-col gap-2">
                <div className="flex justify-between text-[0.72rem] text-[var(--text-sub)]">
                  <span>€{filters.feeMin}M</span>
                  <span>최대 €{filters.feeMax}M</span>
                </div>
                <input type="range" min={0} max={300} step={10}
                  value={filters.feeMax}
                  onChange={e => setFilters(f => ({ ...f, feeMax: Number(e.target.value) }))}
                  className="w-full accent-[var(--accent)]" />
                <div className="text-[0.65rem] text-[var(--text-sub)] text-right">€0 – €{filters.feeMax}M</div>
              </div>
            </FilterSection>

            {/* Time window */}
            <FilterSection label="기간">
              <div className="flex flex-wrap gap-2 pt-1">
                {TIME_OPTIONS.map(t => (
                  <button key={t} onClick={() => setFilters(f => ({ ...f, timeWindow: t }))}
                    className={`px-4 py-1.5 rounded-full text-[0.72rem] font-bold border transition-all
                      ${filters.timeWindow === t
                        ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                        : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40 hover:text-[var(--text)]'}`}>
                    {t}
                  </button>
                ))}
              </div>
            </FilterSection>

          </div>

          {/* Footer CTA */}
          <div className="flex-shrink-0 border-t border-[var(--border)] px-6 py-4 flex gap-3">
            <button onClick={() => {
              if (onApplyFilter) {
                const { from, to } = timeWindowToDates(filters.timeWindow);
                const leagueFEIds = [...filters.leagues];
                const beLeagueIds = leagueFEIds
                  .map(feId => apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === feId)?.id)
                  .filter((id): id is number => id != null);
                const position = filters.position !== 'ALL' ? filters.position : undefined;
                const minFeeEur = filters.feeMin > 0 ? filters.feeMin * 1_000_000 : undefined;
                const maxFeeEur = filters.feeMax < 300 ? filters.feeMax * 1_000_000 : undefined;
                const leagueTargets = beLeagueIds.length > 0 ? beLeagueIds : [undefined as unknown as number];
                const paramsList: NewsFilterParams[] = leagueTargets.map(leagueId => ({
                  season: filters.season,
                  leagueId,
                  position,
                  minFeeEur,
                  maxFeeEur,
                  from,
                  to,
                  size: 100,
                }));
                onApplyFilter(paramsList, filters.statuses);
              }
              onClose();
            }}
              className="flex-1 py-2.5 rounded-lg bg-[var(--accent)] hover:bg-blue-400
                         text-white text-[0.8rem] font-bold tracking-wide transition-colors">
              {filterCountLoading
                ? '계산 중…'
                : `결과 보기 · ${filterCount}`}
            </button>
            <button className="px-5 py-2.5 rounded-lg border border-[var(--border)]
                               text-[var(--text-sub)] hover:text-[var(--text)] text-[0.8rem] font-bold
                               hover:border-[var(--accent)]/40 transition-all">
              ★ 저장
            </button>
          </div>
        </div>
      )}

      {/* ── PLAYER SEARCH TAB ── */}
      {tab === 'player' && (
        <div className="flex-1 flex flex-col overflow-hidden">

          {/* Search input */}
          <div className="px-6 py-4 flex-shrink-0 border-b border-[var(--border)]">
            {flyStep === 'idle' ? (
              <>
                <div className="relative flex items-center">
                  <span className="absolute left-3 text-[1.1rem] text-[var(--text-sub)] pointer-events-none">⌕</span>
                  <input
                    value={query}
                    onChange={e => setQuery(e.target.value)}
                    placeholder="선수, 클럽, 기자 검색…"
                    autoComplete="off"
                    className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg
                               pl-10 pr-10 py-2.5 text-[0.9rem] text-[var(--text)] placeholder-[var(--text-sub)]
                               focus:outline-none focus:border-[var(--accent)]/50 transition-colors"
                  />
                  {query && (
                    <button onClick={() => { setQuery(''); setSearchResults([]); }}
                      className="absolute right-3 text-[var(--text-sub)] hover:text-[var(--text)] text-sm">✕</button>
                  )}
                </div>
                <div className="flex gap-2 mt-3">
                  <span className="text-[0.7rem] text-[var(--text-sub)] self-center">범위</span>
                  {(['player', 'club', 'journalist'] as Scope[]).map(s => (
                    <button key={s} onClick={() => setScope(s)}
                      className={`px-3 py-1 rounded-full text-[0.7rem] font-bold border transition-all
                        ${scope === s
                          ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                          : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40'}`}>
                      {s === 'player' ? '선수' : s === 'club' ? '클럽' : '기자'}
                    </button>
                  ))}
                </div>
              </>
            ) : (
              <div className={`flex items-center gap-3 px-4 py-2.5 rounded-lg border
                ${flyStep === 'arrived' ? 'bg-green-500/10 border-green-500/30' : 'bg-[var(--surface2)] border-[var(--border)]'}`}>
                <span className={`text-[0.9rem] ${flyStep === 'arrived' ? 'text-green-400' : 'text-[var(--text-sub)]'}`}>
                  {flyStep === 'arrived' ? '●' : '◌'}
                </span>
                <span className="flex-1 text-[0.9rem] font-bold">{flyPlayer?.name}</span>
                <button onClick={resetFly}
                  className="text-[var(--text-sub)] hover:text-[var(--text)] text-sm">✕</button>
              </div>
            )}
          </div>

          {/* Content */}
          <div className="flex-1 overflow-y-auto">

            {/* Fly: zooming */}
            {flyStep === 'zooming' && flyPlayer && flyLeague && (
              <div className="px-6 py-6 flex flex-col gap-4">
                <div className="text-center text-[0.88rem] font-bold text-[var(--text-sub)]">이동 중…</div>
                <div className="bg-[var(--surface)] border border-[var(--border)] rounded-xl p-5 flex flex-col gap-3">
                  {[
                    { label: '선수 선택',                         done: true,  active: false },
                    { label: `국가 이동 · ${flyLeague.abbr}`,    done: false, active: true  },
                    { label: '클럽 핀 고정',                      done: false, active: false },
                  ].map((step, i) => (
                    <div key={i} className="flex items-center gap-3">
                      <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center flex-shrink-0 text-[0.6rem]
                        ${step.done   ? 'bg-[var(--accent)] border-[var(--accent)] text-white'
                          : step.active ? 'border-[var(--accent)] text-[var(--accent)]'
                          : 'border-[var(--border)] text-[var(--text-sub)]'}`}>
                        {step.done ? '✓' : step.active ? '◌' : ''}
                      </div>
                      <span className={`text-[0.82rem] ${step.active ? 'font-bold text-[var(--text)]' : 'text-[var(--text-sub)]'}`}>
                        {step.label}
                      </span>
                    </div>
                  ))}
                </div>
                <div className="w-full h-1.5 bg-[var(--surface2)] rounded-full overflow-hidden">
                  <div className="h-full bg-[var(--accent)] rounded-full transition-none"
                    style={{ width: `${progress}%` }} />
                </div>
                <div className="text-right text-[0.7rem] text-[var(--text-sub)]">{Math.round(progress)}%</div>
              </div>
            )}

            {/* Fly: arrived */}
            {flyStep === 'arrived' && flyPlayer && flyLeague && (
              <div className="px-6 py-6 flex flex-col gap-4">
                <div className="bg-green-500/10 border border-green-500/30 rounded-xl p-5">
                  <div className="text-[0.7rem] font-bold tracking-widest text-green-400 mb-2">● LOCATED</div>
                  <div className="text-[0.92rem] font-bold mb-1">
                    {flyLeague.flag} {flyLeague.country} → {flyPlayer.currentClub}
                  </div>
                  <div className="text-[0.78rem] text-[var(--text-sub)]">
                    지도에서 해당 클럽으로 이동했습니다.
                  </div>
                </div>
                <div className="flex flex-col gap-2">
                  <button onClick={() => navigate(`/players/${flyPlayer.id}`)}
                    className="w-full py-2.5 rounded-lg bg-[var(--accent)] hover:bg-blue-400
                               text-white text-[0.8rem] font-bold transition-colors">
                    ★ 선수 페이지로 →
                  </button>
                  <div className="flex gap-2">
                    <button className="flex-1 py-2 rounded-lg border border-[var(--border)]
                                       text-[var(--text-sub)] hover:text-[var(--text)] text-[0.76rem] font-bold transition-all">
                      국가 상세
                    </button>
                    <button onClick={resetFly}
                      className="flex-1 py-2 rounded-lg border border-[var(--border)]
                                 text-[var(--text-sub)] hover:text-[var(--text)] text-[0.76rem] font-bold transition-all">
                      ↺ 다시 검색
                    </button>
                  </div>
                </div>
                {relatedPlayers.length > 0 && (
                  <div>
                    <div className="text-[0.7rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">
                      같은 국가 · 관련 선수
                    </div>
                    <div className="border-t border-[var(--border)]">
                      {relatedPlayers.map(p => (
                        <button key={p.id} onClick={() => navigate(`/players/${p.id}`)}
                          className="w-full flex items-center gap-3 py-3 border-b border-[var(--border)]
                                     hover:bg-[rgba(255,255,255,0.03)] transition-colors text-left">
                          <div className="w-8 h-8 rounded-lg bg-[var(--surface2)] border border-[var(--border)]
                                          flex items-center justify-center text-base flex-shrink-0">
                            {p.emoji ?? '⚽'}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="text-[0.84rem] font-bold truncate">{p.name}</div>
                            <div className="text-[0.7rem] text-[var(--text-sub)]">{p.currentClub} · {p.position}</div>
                          </div>
                          <span className="text-[var(--text-sub)] text-sm">→</span>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Idle: search results */}
            {flyStep === 'idle' && query.trim() && (
              <div className="px-6 py-3">
                <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">
                  추천
                  {searchLoading && <span className="ml-2 text-[var(--accent)] animate-pulse">…</span>}
                </div>
                {!searchLoading && searchResults.length === 0 ? (
                  <div className="text-[0.82rem] text-[var(--text-sub)] py-4 text-center opacity-60">결과 없음</div>
                ) : (
                  <div className="border-t border-[var(--border)]">
                    {searchResults.map((item, i) => {
                      const p = item as Player;
                      const c = item as Club;
                      const j = item as Journalist;
                      return (
                        <button key={i}
                          onClick={() => {
                            if (scope === 'player') handlePlayerSelect(p);
                            else if (scope === 'journalist') navigate(`/journalists/${j.id}`);
                          }}
                          className="w-full flex items-center gap-3 py-3 border-b border-[var(--border)]
                                     hover:bg-[rgba(255,255,255,0.04)] transition-colors text-left group">
                          <div className="w-9 h-9 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                                          flex items-center justify-center text-base flex-shrink-0">
                            {scope === 'player' ? (p.emoji ?? '⚽')
                              : scope === 'club' ? (c.emoji ?? '🏟️')
                              : '✎'}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="text-[0.88rem] font-bold truncate">
                              {scope === 'player' ? p.name : scope === 'club' ? c.name : j.name}
                            </div>
                            <div className="text-[0.72rem] text-[var(--text-sub)]">
                              {scope === 'player'
                                ? `${p.position} · ${p.currentClub}${p.currentLeague ? ` · ${p.currentLeague}` : ''}`
                                : scope === 'club'
                                ? LEAGUES.find(l => l.id === (c as Club).league)?.name ?? ''
                                : `${j.handle} · ${j.outlet ?? ''}`}
                            </div>
                          </div>
                          {scope === 'player' && (
                            <span className="text-[0.65rem] text-[var(--accent)] flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity">
                              fly-to →
                            </span>
                          )}
                          {scope !== 'player' && (
                            <span className="text-[var(--text-sub)] text-sm flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity">→</span>
                          )}
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            )}

            {/* Idle: empty state */}
            {flyStep === 'idle' && !query.trim() && (
              <div className="px-6 py-5 flex flex-col gap-6">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">최근 검색</span>
                    <button className="text-[0.68rem] text-[var(--text-sub)] hover:text-[var(--text)]">지우기</button>
                  </div>
                  <div className="border-t border-[var(--border)]">
                    {RECENT.map((s, i) => (
                      <div key={i} className="flex items-center justify-between py-2.5 border-b border-[var(--border)]">
                        <button onClick={() => { setScope('player'); setQuery(s); }}
                          className="flex items-center gap-2.5 text-[0.82rem] text-[var(--text-sub)] hover:text-[var(--text)] transition-colors">
                          <span className="opacity-40">⌕</span>{s}
                        </button>
                        <span className="text-[var(--text-sub)] opacity-30 text-sm">✕</span>
                      </div>
                    ))}
                  </div>
                </div>
                <div>
                  <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">인기 검색</div>
                  <div className="flex flex-wrap gap-2">
                    {TRENDING.map((t, i) => (
                      <button key={i} onClick={() => { setScope('player'); setQuery(t); }}
                        className="px-4 py-1.5 rounded-full text-[0.72rem] font-bold border border-[var(--border)]
                                   bg-[var(--surface)] text-[var(--text-sub)] hover:text-[var(--text)]
                                   hover:border-[var(--accent)]/40 hover:bg-[var(--accent)]/5 transition-all">
                        #{i + 1} {t}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            )}

          </div>
        </div>
      )}
    </div>
  );
}

function FilterSection({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">{label}</div>
      <div className="flex flex-col gap-1">{children}</div>
      <div className="mt-3 border-b border-[var(--border)]" />
    </div>
  );
}

function CheckRow({ checked, label, count, onChange }: {
  checked: boolean; label: string; count: number | string; onChange: () => void;
}) {
  return (
    <label className="flex items-center justify-between cursor-pointer group">
      <div className="flex items-center gap-2.5">
        <div className={`w-3.5 h-3.5 rounded-sm border flex items-center justify-center flex-shrink-0 transition-colors
          ${checked
            ? 'bg-[var(--accent)] border-[var(--accent)]'
            : 'border-[var(--border)] group-hover:border-[var(--accent)]/50'}`}>
          {checked && <span className="text-white text-[0.5rem] leading-none">✓</span>}
        </div>
        <span className={`text-[0.82rem] transition-colors ${checked ? 'text-[var(--text)]' : 'text-[var(--text-sub)]'}`}>
          {label}
        </span>
      </div>
      <span className="text-[0.7rem] text-[var(--text-sub)] opacity-50">{count}</span>
      <input type="checkbox" className="sr-only" checked={checked} onChange={onChange} />
    </label>
  );
}
