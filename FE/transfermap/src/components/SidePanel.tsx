import { useState, useEffect, useCallback, useRef, forwardRef, useImperativeHandle } from 'react';
import { useNavigate } from 'react-router-dom';
import { useIsMobile } from '../hooks/useIsMobile';
import { useNewsInfinite } from '../hooks/useNewsInfinite';
import { fetchClub, fetchClubTransfers, fetchClubsBySeason, fetchAllClubs } from '../api/clubs';
import { fetchLeagues } from '../api/leagues';
import { fetchJournalists } from '../api/journalists';
import { fetchPlayersSearch } from '../api/players';
import { fetchNews, fetchNewsPage, fetchTrendingPlayers } from '../api/news';
import type { NewsFilterParams } from '../api/news';
import { ApiError } from '../api/client';
import type { ApiClub, ApiLeague } from '../api/types';
import type { League, Club, NewsItem, Player, Journalist } from '../types';
import NewsCard from './NewsCard';
import AdSlot, { SLOT } from './AdSlot';
import { LEAGUES, CLUBS, PLAYERS, JOURNALISTS, NEWS } from '../data/mock';
import { SEASON_OPTIONS, LEAGUE_NAME_TO_ID } from '../data/constants';


const POSITIONS   = ['ALL', 'GK', 'DF', 'MF', 'FW'];
const TIME_OPTIONS = ['24h', '7d', '30d', 'This window', 'All'];
const TRENDING    = ['Mbappé', 'Bellingham', 'Haaland', 'Saka', 'Yamal'];

const RECENT_KEY = 'search_recent';
const MAX_RECENT = 5;
function loadRecent(): string[] {
  try { return JSON.parse(localStorage.getItem(RECENT_KEY) ?? '[]'); }
  catch { return []; }
}
function saveRecent(q: string): string[] {
  const next = [q, ...loadRecent().filter(s => s !== q)].slice(0, MAX_RECENT);
  localStorage.setItem(RECENT_KEY, JSON.stringify(next));
  return next;
}
function clearRecent(): void {
  localStorage.removeItem(RECENT_KEY);
}


function timeWindowToDates(w: string): { from?: string; to?: string } {
  const now = new Date();
  const fmt = (d: Date) => d.toISOString().slice(0, 10);
  if (w === '24h') return { from: fmt(new Date(now.getTime() - 86_400_000)) };
  if (w === '7d')  return { from: fmt(new Date(now.getTime() - 7  * 86_400_000)) };
  if (w === '30d') return { from: fmt(new Date(now.getTime() - 30 * 86_400_000)) };
  return {};
}

const STATUS_STYLE: Record<string, string> = {
  interest:  'bg-purple-500/15 text-purple-400 border-purple-500/30',
  rumour:    'bg-yellow-500/15 text-yellow-400 border-yellow-500/30',
  confirmed: 'bg-green-500/15  text-green-400  border-green-500/30',
  denied:    'bg-red-500/15    text-red-400    border-red-500/30',
  loan:      'bg-blue-500/15   text-blue-400   border-blue-500/30',
};

interface FilterState {
  leagues:    Set<string>;
  statuses:   Set<string>;
  position:   string;
  timeWindow: string;
  feeMin:     number;
  feeMax:     number;
  season:     number;
}

const defaultFilters = (): FilterState => ({
  leagues:    new Set(['pl', 'll', 'bl']),
  statuses:   new Set(['interest', 'rumour', 'confirmed', 'loan']),
  position:   'ALL',
  timeWindow: '7d',
  feeMin:     0,
  feeMax:     300,
  season:     51,
});

type View = 'news' | 'search' | 'filter' | 'club' | 'league';
type SearchScope = 'player' | 'club' | 'journalist';
type FlyStep    = 'idle' | 'zooming' | 'arrived';

export interface SidePanelHandle {
  focusSearch: () => void;
  openFilter:  () => void;
}

interface Props {
  open: boolean;
  onClose: () => void;
  selectedClubId?: number | null;
  selectedLeague?: League | null;
  leagueClubs?: Club[];
  onNewsClick?: (item: NewsItem) => void;
  onNewsSelect?: (item: NewsItem | null) => void;
  selectedNewsId?: number | null;
  hoveredRouteId?: number | null;
  season?: number;
  onSeasonChange?: (s: number) => void;
  onPlayerClick?: (name: string) => void;
  onFlyTo?: (player: Player, league: League) => void;
  onApplyFilter?: (params: NewsFilterParams[], statuses: Set<string>) => void;
  onClearFilter?: () => void;
  onPlayerPanelOpen?: (id: number) => void;
}

const SidePanel = forwardRef<SidePanelHandle, Props>(function SidePanel({
  open, onClose, selectedClubId, selectedLeague, leagueClubs = [],
  onNewsSelect, selectedNewsId, hoveredRouteId,
  season: seasonProp = 51, onSeasonChange, onPlayerClick,
  onApplyFilter, onClearFilter, onPlayerPanelOpen,
}: Props, ref) {
  const navigate  = useNavigate();
  const isMobile  = useIsMobile();
  const [sheetFull, setSheetFull] = useState(false);

  // ── View routing ──────────────────────────────────────────────────────────
  const [view,    setView]    = useState<View>('news');
  const [clubTab, setClubTab] = useState<'in' | 'out'>('in');

  // ── News feed ─────────────────────────────────────────────────────────────
  const [statusFilters, setStatusFilters] = useState({ interest: true, rumour: true, confirmed: true, denied: false, loan: true });
  const season    = seasonProp;
  const setSeason = (s: number) => onSeasonChange?.(s);

  const { items: allNews, loading: newsLoading, loadingMore, hasMore, loadMore } = useNewsInfinite(season);
  const filteredNews = allNews.filter(n => statusFilters[n.status as keyof typeof statusFilters] ?? true);

  const newsListRef  = useRef<HTMLDivElement>(null);
  const sentinelRef  = useRef<HTMLDivElement>(null);

  // ── Club / League detail ─────────────────────────────────────────────────
  const [clubDetail,          setClubDetail]          = useState<ApiClub | null>(null);
  const [clubTransfers,       setClubTransfers]       = useState<{ incoming: NewsItem[]; outgoing: NewsItem[] }>({ incoming: [], outgoing: [] });
  const [clubLoading,         setClubLoading]         = useState(false);
  const [clubTransfersLoading, setClubTransfersLoading] = useState(false);
  const [clubSeason,          setClubSeason]          = useState<number>(SEASON_OPTIONS[0].value);
  const [viewingClubId,       setViewingClubId]       = useState<number | null>(null);

  const [apiLeagues,         setApiLeagues]         = useState<ApiLeague[]>([]);
  const [seasonClubs,        setSeasonClubs]         = useState<Club[]>(leagueClubs);
  const [seasonClubsLoading, setSeasonClubsLoading] = useState(false);

  // ── Search state ─────────────────────────────────────────────────────────
  const [allClubs,      setAllClubs]      = useState<Club[]>(CLUBS);
  const [allJournalists, setAllJournalists] = useState<Journalist[]>(JOURNALISTS);
  const [query,           setQuery]           = useState('');
  const [scope,           setScope]           = useState<SearchScope>('player');
  const [recentSearches,  setRecentSearches]  = useState<string[]>(() => loadRecent());
  const [searchResults, setSearchResults] = useState<(Player | Club | Journalist)[]>([]);
  const [searchLoading, setSearchLoading] = useState(false);
  const [flyStep,       setFlyStep]       = useState<FlyStep>('idle');
  const [flyPlayer,     setFlyPlayer]     = useState<Player | null>(null);
  const [flyLeague,     setFlyLeague]     = useState<League | null>(null);
  const [progress,      setProgress]      = useState(0);
  const [searchSeason,  setSearchSeason]  = useState(51);
  const [selectedClub,  setSelectedClub]  = useState<Club | null>(null);

  const searchInputRef = useRef<HTMLInputElement>(null);
  const debounceRef    = useRef<ReturnType<typeof setTimeout> | null>(null);

  // ── Trending ──────────────────────────────────────────────────────────────
  const [trendingPlayers, setTrendingPlayers] = useState<string[]>(TRENDING);

  // ── Filter state ─────────────────────────────────────────────────────────
  const [filterState,        setFilterState]        = useState<FilterState>(defaultFilters);
  const [filterCount,        setFilterCount]        = useState<number>(NEWS.length);
  const [filterCountLoading, setFilterCountLoading] = useState(false);
  const [appliedItems,       setAppliedItems]       = useState<NewsItem[] | null>(null);
  const [applyLoading,       setApplyLoading]       = useState(false);

  // ── Imperative handle ─────────────────────────────────────────────────────
  useImperativeHandle(ref, () => ({
    focusSearch: () => {
      setView('search');
      setSheetFull(true);
      setFlyStep('idle');
      setQuery('');
      setTimeout(() => searchInputRef.current?.focus(), 50);
    },
    openFilter: () => setView('filter'),
  }), []);

  // ── Data loading ──────────────────────────────────────────────────────────
  useEffect(() => {
    fetchLeagues().then(setApiLeagues).catch(() => {});
    fetchAllClubs().then(c => { if (c.length) setAllClubs(c); }).catch(() => {});
    fetchJournalists().then(j => { if (j.length) setAllJournalists(j); }).catch(() => {});
    fetchTrendingPlayers().then(p => { if (p.length) setTrendingPlayers(p); }).catch(() => {});
  }, []);

  // Season change → clear applied filter so feed shows fresh news
  useEffect(() => { setAppliedItems(null); }, [season]);

  // League selected → league view
  useEffect(() => {
    if (selectedLeague) { setView('league'); setClubDetail(null); }
  }, [selectedLeague]);

  // League or season change → refetch season clubs
  useEffect(() => {
    if (!selectedLeague) { setSeasonClubs(leagueClubs); return; }
    const beLeagueId = apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === selectedLeague.id)?.id;
    if (!beLeagueId) { setSeasonClubs(leagueClubs); return; }
    setSeasonClubsLoading(true);
    fetchClubsBySeason(season, beLeagueId)
      .then(clubs => setSeasonClubs(clubs.length > 0 ? clubs : leagueClubs))
      .catch(() => setSeasonClubs(leagueClubs))
      .finally(() => setSeasonClubsLoading(false));
  }, [selectedLeague, season, apiLeagues, leagueClubs]);

  // Club ID change → club detail
  useEffect(() => {
    if (!selectedClubId) {
      if (!selectedLeague) setView('news');
      setClubDetail(null);
      setViewingClubId(null);
      return;
    }
    setViewingClubId(selectedClubId);
    setView('club');
    setClubTab('in');
    setClubLoading(true);
    fetchClub(selectedClubId)
      .then(detail => setClubDetail(detail))
      .catch(err => { if (err instanceof ApiError && err.status >= 500) navigate('/500'); })
      .finally(() => setClubLoading(false));
  }, [selectedClubId, navigate, selectedLeague]);

  // Viewing club or season change → transfers
  useEffect(() => {
    if (!viewingClubId) { setClubTransfers({ incoming: [], outgoing: [] }); return; }
    setClubTransfersLoading(true);
    fetchClubTransfers(viewingClubId, clubSeason)
      .then(transfers => setClubTransfers(transfers))
      .catch(err => { if (err instanceof ApiError && err.status >= 500) navigate('/500'); })
      .finally(() => setClubTransfersLoading(false));
  }, [viewingClubId, clubSeason, navigate]);

  // Reset fly state when panel closes
  useEffect(() => {
    if (!open) { setFlyStep('idle'); setFlyPlayer(null); setFlyLeague(null); setProgress(0); setViewingClubId(null); }
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
      if (!query.trim()) setSelectedClub(null);
      return;
    }
    debounceRef.current = setTimeout(() => runSearch(query.trim(), scope), 250);
    return () => { if (debounceRef.current) clearTimeout(debounceRef.current); };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query, scope, flyStep]);

  const runSearch = useCallback(async (q: string, s: SearchScope) => {
    setSearchLoading(true);
    if (s === 'player' && q.trim()) setRecentSearches(saveRecent(q.trim()));
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
          !j.isBot && (
            j.name.toLowerCase().includes(q.toLowerCase()) ||
            j.handle.toLowerCase().includes(q.toLowerCase())
          )
        ).slice(0, 8));
      }
    } catch {
      if (s === 'player') setSearchResults(PLAYERS.filter(p =>
        p.name.toLowerCase().includes(q.toLowerCase())
      ).slice(0, 8));
    } finally {
      setSearchLoading(false);
    }
  }, [allClubs, allJournalists]);

  // Filter result count
  useEffect(() => {
    if (!open || view !== 'filter') return;
    const leagueFEIds = [...filterState.leagues];
    const statuses    = [...filterState.statuses];
    if (statuses.length === 0) { setFilterCount(0); return; }

    const { from, to } = timeWindowToDates(filterState.timeWindow);
    const minFeeEur = filterState.feeMin > 0  ? filterState.feeMin * 1_000_000 : undefined;
    const maxFeeEur = filterState.feeMax < 300 ? filterState.feeMax * 1_000_000 : undefined;
    const position  = filterState.position !== 'ALL' ? filterState.position : undefined;
    const beLeagueIds = leagueFEIds
      .map(feId => apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === feId)?.id)
      .filter((id): id is number => id != null);

    const doFetch = async () => {
      setFilterCountLoading(true);
      try {
        let total = 0;
        const targets = beLeagueIds.length > 0 ? beLeagueIds : [undefined];
        for (const status of statuses) {
          for (const leagueId of targets) {
            const beStatus = status === 'rumour' ? 'RUMOR' : status.toUpperCase();
            const { total: t } = await fetchNewsPage({ status: beStatus, leagueId, position, minFeeEur, maxFeeEur, from, to, season: filterState.season, size: 1 });
            total += t;
          }
        }
        setFilterCount(total);
      } catch {
        setFilterCount(NEWS.filter(n => filterState.statuses.has(n.status)).length);
      } finally {
        setFilterCountLoading(false);
      }
    };
    const timer = setTimeout(doFetch, 400);
    return () => clearTimeout(timer);
  }, [filterState, open, view, apiLeagues]);

  // Past season → disable date-based timeWindow
  useEffect(() => {
    if (filterState.season !== 51 && !['This window', 'All'].includes(filterState.timeWindow))
      setFilterState(f => ({ ...f, timeWindow: 'All' }));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filterState.season]);

  // ── Infinite scroll ───────────────────────────────────────────────────────
  // sentinel은 !newsLoading 조건부 렌더라서 로딩 완료 후 effect 재실행 필요
  useEffect(() => {
    if (newsLoading) return;
    const sentinel  = sentinelRef.current;
    const container = newsListRef.current;
    if (!sentinel || !container) return;
    const obs = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) loadMore(); },
      { root: container, threshold: 0.1 },
    );
    obs.observe(sentinel);
    return () => obs.disconnect();
  }, [loadMore, newsLoading]);

  // Hover → scroll sync
  useEffect(() => {
    if (hoveredRouteId == null || !open || view !== 'news') return;
    const container = newsListRef.current;
    if (!container) return;
    const el = container.querySelector(`[data-news-id="${hoveredRouteId}"]`) as HTMLElement | null;
    if (el) {
      const containerRect = container.getBoundingClientRect();
      const elRect        = el.getBoundingClientRect();
      container.scrollTo({ top: elRect.top - containerRect.top + container.scrollTop - 120, behavior: 'smooth' });
    }
  }, [hoveredRouteId, open, view]);

  // ── Callbacks ─────────────────────────────────────────────────────────────
  const handleClose = useCallback(() => { setSheetFull(false); onClose(); }, [onClose]);

  const toggleStatusFilter = (key: keyof typeof statusFilters) =>
    setStatusFilters(f => ({ ...f, [key]: !f[key] }));

  const toggleFilterSet = (key: 'leagues' | 'statuses', val: string) =>
    setFilterState(prev => {
      const next = new Set(prev[key]);
      next.has(val) ? next.delete(val) : next.add(val);
      return { ...prev, [key]: next };
    });


  const resetFly = () => {
    setFlyStep('idle');
    setFlyPlayer(null);
    setFlyLeague(null);
    setProgress(0);
    setQuery('');
    setSearchResults([]);
    setSelectedClub(null);
  };

  const handleClubSelect = (club: Club) => {
    setSelectedClub(club);
    onApplyFilter?.(
      [{ fromClubId: club.id, season: searchSeason, size: 30 }, { toClubId: club.id, season: searchSeason, size: 30 }],
      new Set(['interest', 'rumour', 'confirmed', 'denied', 'loan'])
    );
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
    ? PLAYERS.filter(p => LEAGUE_NAME_TO_ID[p.currentLeague ?? ''] === flyLeague.id && p.id !== flyPlayer?.id)
    : [];

  const activeTransfers = clubTab === 'in' ? clubTransfers.incoming : clubTransfers.outgoing;
  const isTopLevel      = view === 'news' || view === 'filter' || view === 'search';

  // ── Layout ────────────────────────────────────────────────────────────────
  const mobileTranslate = !open ? 'translate-y-full'
                        : sheetFull ? 'translate-y-0'
                        : 'translate-y-[calc(100%-160px)]';

  return (
    <div className={`flex flex-col z-40 bg-[rgba(8,14,26,0.96)] backdrop-blur-xl border-[var(--border)]
                     transition-[transform] duration-[350ms] ease-[cubic-bezier(0.4,0,0.2,1)]
                     ${isMobile
                       ? `fixed bottom-0 left-0 right-0 h-[92dvh] border-t rounded-t-2xl ${mobileTranslate}`
                       : `absolute top-0 right-0 w-[460px] h-screen border-l ${open ? 'translate-x-0' : 'translate-x-full'}`
                     }`}>

      {/* Mobile drag handle */}
      {isMobile && (
        <button onClick={() => setSheetFull(f => !f)}
          className="flex-shrink-0 flex flex-col items-center pt-3 pb-1 gap-1 w-full">
          <span className="w-10 h-1 rounded-full bg-white/20" />
          <span className="text-[0.58rem] tracking-widest text-[var(--text-sub)] uppercase">
            {sheetFull ? '▼ Collapse' : '▲ Expand'}
          </span>
        </button>
      )}

      {/* ── Tab bar (Feed / Search / Filter) ──────────────────────────────── */}
      {isTopLevel && (
        <div className="flex items-center border-b border-[var(--border)] flex-shrink-0">
          {([['news', '◈ Feed'], ['filter', '⚙ Filter'], ['search', '⌕ Search']] as const).map(([v, label]) => (
            <button key={v} onClick={() => { setView(v); if (isMobile && v === 'search') setSheetFull(true); }}
              className={`flex-1 py-3.5 text-[0.74rem] font-bold tracking-wide uppercase border-b-2 transition-all
                ${view === v
                  ? 'text-[var(--accent)] border-[var(--accent)]'
                  : 'text-[var(--text-sub)] border-transparent hover:text-[var(--text)]'}`}>
              {label}
            </button>
          ))}
          <button onClick={handleClose}
            className="w-12 h-[52px] flex items-center justify-center
                       text-[var(--text-sub)] hover:text-[var(--text)] transition-colors flex-shrink-0">
            ✕
          </button>
        </div>
      )}

      {/* ── NEWS VIEW ─────────────────────────────────────────────────────── */}
      {view === 'news' && (
        <>
          <div className="px-7 pt-4 pb-2 flex-shrink-0">
            <select value={season} onChange={e => setSeason(Number(e.target.value))}
              className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg px-3 py-1.5
                         text-[0.8rem] text-[var(--text)] focus:outline-none focus:border-[var(--accent)]/50
                         transition-colors cursor-pointer">
              {SEASON_OPTIONS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
            </select>
          </div>

          {appliedItems !== null ? (
            <div className="flex items-center gap-2 px-5 py-2.5 border-b border-[var(--border)] bg-[var(--accent)]/8 flex-shrink-0">
              <span className="text-[0.72rem] font-bold text-[var(--accent)] flex-1">
                Filter active · {appliedItems.length} results
              </span>
              <button onClick={() => { setAppliedItems(null); onClearFilter?.(); }}
                className="text-[0.7rem] font-bold text-[var(--text-sub)] hover:text-[var(--text)] border border-[var(--border)]
                           px-2.5 py-1 rounded-md transition-colors">
                Clear ✕
              </button>
            </div>
          ) : (
            <div className="flex gap-3 flex-wrap px-7 py-4 border-b border-[var(--border)] flex-shrink-0">
              {(['interest', 'rumour', 'confirmed', 'denied', 'loan'] as const).map(s => (
                <button key={s} onClick={() => toggleStatusFilter(s)}
                  className={`px-5 py-2.5 rounded-full text-[0.72rem] font-bold tracking-widest border transition-all
                    ${STATUS_STYLE[s] ?? ''}
                    ${statusFilters[s] ? 'opacity-100' : 'opacity-35'}`}>
                  {s.toUpperCase()}
                </button>
              ))}
            </div>
          )}

          <div ref={newsListRef} className="flex-1 overflow-y-auto py-5">
            {appliedItems !== null ? (
              appliedItems.length === 0
                ? <div className="py-16 text-center text-[0.82rem] text-[var(--text-sub)] opacity-50">No results</div>
                : appliedItems.map((n, i) => (
                    <div key={n.id} data-news-id={n.id}>
                      {i > 0 && i % 3 === 0 && (
                        <AdSlot slot={SLOT.FEED_NATIVE} format="fluid" layoutKey="-fb+5w+4e-db+86"
                          className="mx-5 my-2 rounded-xl overflow-hidden border border-[var(--border)]" />
                      )}
                      <NewsCard
                        item={n}
                        highlighted={selectedNewsId === n.id}
                        onClick={() => selectedNewsId === n.id ? onNewsSelect?.(null) : onNewsSelect?.(n)}
                        onPlayerClick={onPlayerClick}
                      />
                    </div>
                  ))
            ) : newsLoading
              ? <div className="flex items-center justify-center h-32 text-[0.82rem] text-[var(--text-sub)]">Loading…</div>
              : filteredNews.map((n, i) => (
                  <div key={n.id ?? i} data-news-id={n.id}
                       className={hoveredRouteId === n.id ? 'ring-1 ring-inset ring-[var(--accent)]/30 rounded-xl mx-1 transition-all' : ''}>
                    {i > 0 && i % 3 === 0 && (
                      <AdSlot slot={SLOT.FEED_NATIVE} format="fluid" layoutKey="-fb+5w+4e-db+86"
                        className="mx-5 my-2 rounded-xl overflow-hidden border border-[var(--border)]" />
                    )}
                    <NewsCard
                      item={n}
                      highlighted={selectedNewsId === n.id}
                      onClick={() => selectedNewsId === n.id ? onNewsSelect?.(null) : onNewsSelect?.(n)}
                      onPlayerClick={onPlayerClick}
                    />
                  </div>
                ))
            }
            {appliedItems === null && !newsLoading && (
              <>
                <div ref={sentinelRef} className="h-1" />
                {loadingMore && (
                  <div className="flex items-center justify-center py-5 text-[0.78rem] text-[var(--text-sub)]">Loading…</div>
                )}
                {!hasMore && filteredNews.length > 0 && (
                  <div className="text-center py-5 text-[0.68rem] text-[var(--text-sub)] tracking-widest uppercase">End</div>
                )}
              </>
            )}
          </div>
        </>
      )}

      {/* ── SEARCH VIEW ───────────────────────────────────────────────────── */}
      {view === 'search' && (
        <div className="flex-1 flex flex-col overflow-hidden">
          <div className="px-6 py-4 flex-shrink-0 border-b border-[var(--border)]">
            {flyStep === 'idle' ? (
              <>
                <div className="relative flex items-center">
                  <span className="absolute left-3 text-[1.1rem] text-[var(--text-sub)] pointer-events-none">⌕</span>
                  <input
                    ref={searchInputRef}
                    value={query}
                    onChange={e => setQuery(e.target.value)}
                    placeholder="Player, club, journalist…"
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
                  <span className="text-[0.7rem] text-[var(--text-sub)] self-center">Scope</span>
                  {(['player', 'club', 'journalist'] as SearchScope[]).map(s => (
                    <button key={s} onClick={() => { setScope(s); setSelectedClub(null); }}
                      className={`px-3 py-1 rounded-full text-[0.7rem] font-bold border transition-all
                        ${scope === s
                          ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                          : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40'}`}>
                      {s === 'player' ? 'Player' : s === 'club' ? 'Club' : 'Journalist'}
                    </button>
                  ))}
                </div>
                {scope === 'club' && (
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-[0.7rem] text-[var(--text-sub)] flex-shrink-0">Season</span>
                    <select value={searchSeason} onChange={e => setSearchSeason(Number(e.target.value))}
                      className="flex-1 bg-[var(--surface2)] border border-[var(--border)] rounded-md px-2 py-1
                                 text-[0.75rem] text-[var(--text)] focus:outline-none focus:border-[var(--accent)]/50
                                 transition-colors cursor-pointer">
                      {SEASON_OPTIONS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
                    </select>
                  </div>
                )}
              </>
            ) : (
              <div className={`flex items-center gap-3 px-4 py-2.5 rounded-lg border
                ${flyStep === 'arrived' ? 'bg-green-500/10 border-green-500/30' : 'bg-[var(--surface2)] border-[var(--border)]'}`}>
                <span className={`text-[0.9rem] ${flyStep === 'arrived' ? 'text-green-400' : 'text-[var(--text-sub)]'}`}>
                  {flyStep === 'arrived' ? '●' : '◌'}
                </span>
                <span className="flex-1 text-[0.9rem] font-bold">{flyPlayer?.name}</span>
                <button onClick={resetFly} className="text-[var(--text-sub)] hover:text-[var(--text)] text-sm">✕</button>
              </div>
            )}
          </div>

          <div className="flex-1 overflow-y-auto">
            {flyStep === 'zooming' && flyPlayer && flyLeague && (
              <div className="px-6 py-6 flex flex-col gap-4">
                <div className="text-center text-[0.88rem] font-bold text-[var(--text-sub)]">Navigating…</div>
                <div className="bg-[var(--surface)] border border-[var(--border)] rounded-xl p-5 flex flex-col gap-3">
                  {[
                    { label: 'Player selected',              done: true,  active: false },
                    { label: `Moving to ${flyLeague.abbr}`,  done: false, active: true  },
                    { label: 'Pinning club',                 done: false, active: false },
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
                  <div className="h-full bg-[var(--accent)] rounded-full transition-none" style={{ width: `${progress}%` }} />
                </div>
                <div className="text-right text-[0.7rem] text-[var(--text-sub)]">{Math.round(progress)}%</div>
              </div>
            )}

            {flyStep === 'arrived' && flyPlayer && flyLeague && (
              <div className="px-6 py-6 flex flex-col gap-4">
                <div className="bg-green-500/10 border border-green-500/30 rounded-xl p-5">
                  <div className="text-[0.7rem] font-bold tracking-widest text-green-400 mb-2">● LOCATED</div>
                  <div className="text-[0.92rem] font-bold mb-1">
                    {flyLeague.flag} {flyLeague.country} → {flyPlayer.currentClub}
                  </div>
                  <div className="text-[0.78rem] text-[var(--text-sub)]">Map moved to the club's location.</div>
                </div>
                <div className="flex flex-col gap-2">
                  <button onClick={() => navigate(`/players/${flyPlayer.id}`)}
                    className="w-full py-2.5 rounded-lg bg-[var(--accent)] hover:bg-blue-400
                               text-white text-[0.8rem] font-bold transition-colors">
                    ★ Player Profile →
                  </button>
                  <div className="flex gap-2">
                    <button className="flex-1 py-2 rounded-lg border border-[var(--border)]
                                       text-[var(--text-sub)] hover:text-[var(--text)] text-[0.76rem] font-bold transition-all">
                      Country Detail
                    </button>
                    <button onClick={resetFly}
                      className="flex-1 py-2 rounded-lg border border-[var(--border)]
                                 text-[var(--text-sub)] hover:text-[var(--text)] text-[0.76rem] font-bold transition-all">
                      ↺ Search Again
                    </button>
                  </div>
                </div>
                {relatedPlayers.length > 0 && (
                  <div>
                    <div className="text-[0.7rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">
                      Same Country · Related Players
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

            {flyStep === 'idle' && selectedClub && scope === 'club' && (
              <div className="mx-6 mt-3 px-3 py-2 rounded-lg bg-[var(--accent)]/10 border border-[var(--accent)]/30
                              flex items-center gap-2 text-[0.75rem]">
                <span className="text-[var(--accent)]">◈</span>
                <span className="text-[var(--text)] font-semibold flex-1 truncate">{selectedClub.name}</span>
                <span className="text-[0.68rem] text-[var(--accent)]/80 flex-shrink-0">
                  {SEASON_OPTIONS.find(s => s.value === searchSeason)?.label} · Showing on map
                </span>
              </div>
            )}

            {flyStep === 'idle' && query.trim() && (
              <div className="px-6 py-3">
                <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">
                  Results {searchLoading && <span className="ml-2 text-[var(--accent)] animate-pulse">…</span>}
                </div>
                {!searchLoading && searchResults.length === 0 ? (
                  <div className="text-[0.82rem] text-[var(--text-sub)] py-4 text-center opacity-60">No results</div>
                ) : (
                  <div className="border-t border-[var(--border)]">
                    {searchResults.map((item, i) => {
                      const p = item as Player;
                      const c = item as Club;
                      const j = item as Journalist;
                      return (
                        <button key={i}
                          onClick={() => {
                            if (scope === 'player') onPlayerPanelOpen?.(p.id);
                            else if (scope === 'club') handleClubSelect(c);
                            else navigate(`/journalists/${j.id}`);
                          }}
                          className="w-full flex items-center gap-3 py-3 border-b border-[var(--border)]
                                     hover:bg-[rgba(255,255,255,0.04)] transition-colors text-left group">
                          <div className="w-9 h-9 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                                          flex items-center justify-center text-base flex-shrink-0">
                            {scope === 'player' ? (p.emoji ?? '⚽') : scope === 'club' ? (c.emoji ?? '🏟️') : '✎'}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="text-[0.88rem] font-bold truncate">
                              {scope === 'player' ? p.name : scope === 'club' ? c.name : j.name}
                            </div>
                            <div className="text-[0.72rem] text-[var(--text-sub)]">
                              {scope === 'player'
                                ? `${p.position} · ${p.currentClub}${p.currentLeague ? ` · ${p.currentLeague}` : ''}`
                                : scope === 'club'
                                ? LEAGUES.find(l => l.id === c.league)?.name ?? ''
                                : `${j.handle}${j.outlet ? ` · ${j.outlet}` : ''}`}
                            </div>
                          </div>
                          <span className="text-[var(--text-sub)] text-sm flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity">
                            →
                          </span>
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            )}

            {flyStep === 'idle' && !query.trim() && (
              <div className="px-6 py-5 flex flex-col gap-6">
                {recentSearches.length > 0 && (
                  <div>
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">Recent</span>
                      <button
                        onClick={() => { clearRecent(); setRecentSearches([]); }}
                        className="text-[0.68rem] text-[var(--text-sub)] hover:text-[var(--text)]">Clear</button>
                    </div>
                    <div className="border-t border-[var(--border)]">
                      {recentSearches.map((s, i) => (
                        <div key={i} className="flex items-center justify-between py-2.5 border-b border-[var(--border)]">
                          <button onClick={() => { setScope('player'); setQuery(s); }}
                            className="flex items-center gap-2.5 text-[0.82rem] text-[var(--text-sub)] hover:text-[var(--text)] transition-colors">
                            <span className="opacity-40">⌕</span>{s}
                          </button>
                          <button
                            onClick={() => {
                              const next = recentSearches.filter((_, j) => j !== i);
                              localStorage.setItem(RECENT_KEY, JSON.stringify(next));
                              setRecentSearches(next);
                            }}
                            className="text-[var(--text-sub)] opacity-40 hover:opacity-100 text-sm transition-opacity">✕</button>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div>
                  <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">Trending</div>
                  <div className="flex flex-wrap gap-2">
                    {trendingPlayers.map((t, i) => (
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

      {/* ── FILTER VIEW ───────────────────────────────────────────────────── */}
      {view === 'filter' && (
        <div className="flex-1 flex flex-col overflow-hidden">
          <div className="flex-1 overflow-y-auto px-6 py-5 flex flex-col gap-5">
            <div className="flex items-center justify-between">
              <span className="text-[0.7rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">FILTERS</span>
              <button onClick={() => setFilterState(defaultFilters())}
                className="text-[0.7rem] text-[var(--text-sub)] hover:text-[var(--text)]">↻ reset</button>
            </div>

            <FilterSection label="Season">
              <select value={filterState.season}
                onChange={e => setFilterState(f => ({ ...f, season: Number(e.target.value) }))}
                className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg px-3 py-1.5
                           text-[0.8rem] text-[var(--text)] focus:outline-none focus:border-[var(--accent)]/50
                           transition-colors cursor-pointer">
                {SEASON_OPTIONS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
            </FilterSection>

            <FilterSection label="League">
              {LEAGUES.map(l => (
                <CheckRow key={l.id} checked={filterState.leagues.has(l.id)} label={l.name}
                  count={leagueNewsCount(l.id)} onChange={() => toggleFilterSet('leagues', l.id)} />
              ))}
            </FilterSection>

            <FilterSection label="Status">
              {(['interest', 'rumour', 'confirmed', 'denied', 'loan'] as const).map(s => (
                <CheckRow key={s} checked={filterState.statuses.has(s)}
                  label={s.charAt(0).toUpperCase() + s.slice(1)}
                  count={NEWS.filter(n => n.status === s).length}
                  onChange={() => toggleFilterSet('statuses', s)} />
              ))}
            </FilterSection>

            <FilterSection label="Position">
              <div className="flex flex-wrap gap-2 pt-1">
                {POSITIONS.map(p => (
                  <button key={p} onClick={() => setFilterState(f => ({ ...f, position: p }))}
                    className={`px-4 py-1.5 rounded-full text-[0.72rem] font-bold border transition-all
                      ${filterState.position === p
                        ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                        : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40 hover:text-[var(--text)]'}`}>
                    {p}
                  </button>
                ))}
              </div>
            </FilterSection>

            <FilterSection label="Transfer Fee">
              <div className="pt-1 flex flex-col gap-2">
                {(['Min', 'Max'] as const).map(label => {
                  const key = label === 'Min' ? 'feeMin' : 'feeMax';
                  const min = label === 'Min' ? 0   : 10;
                  const max = label === 'Min' ? 290 : 300;
                  const onChange = label === 'Min'
                    ? (v: number) => setFilterState(f => ({ ...f, feeMin: Math.min(v, f.feeMax - 10) }))
                    : (v: number) => setFilterState(f => ({ ...f, feeMax: Math.max(v, f.feeMin + 10) }));
                  return (
                    <div key={label} className="flex items-center gap-2">
                      <span className="text-[0.65rem] text-[var(--text-sub)] w-8 flex-shrink-0">{label}</span>
                      <input type="range" min={min} max={max} step={10} value={filterState[key]}
                        onChange={e => onChange(Number(e.target.value))}
                        className="flex-1 accent-[var(--accent)]" />
                      <span className="text-[0.65rem] text-[var(--text-sub)] w-14 text-right flex-shrink-0">
                        €{filterState[key]}M
                      </span>
                    </div>
                  );
                })}
                <div className="text-[0.65rem] text-[var(--text-sub)] text-right">
                  €{filterState.feeMin}M – €{filterState.feeMax}M
                </div>
              </div>
            </FilterSection>

            <FilterSection label="Period">
              <div className="flex flex-wrap gap-2 pt-1">
                {TIME_OPTIONS.map(t => (
                  <button key={t} onClick={() => setFilterState(f => ({ ...f, timeWindow: t }))}
                    className={`px-4 py-1.5 rounded-full text-[0.72rem] font-bold border transition-all
                      ${filterState.timeWindow === t
                        ? 'bg-[var(--accent)]/20 border-[var(--accent)]/60 text-[var(--accent)]'
                        : 'border-[var(--border)] text-[var(--text-sub)] hover:border-[var(--accent)]/40 hover:text-[var(--text)]'}`}>
                    {t}
                  </button>
                ))}
              </div>
            </FilterSection>

          </div>

          <div className="flex-shrink-0 border-t border-[var(--border)] px-6 py-4 flex gap-3">
            <button onClick={async () => {
              const { from, to } = timeWindowToDates(filterState.timeWindow);
              const beLeagueIds = [...filterState.leagues]
                .map(feId => apiLeagues.find(l => LEAGUE_NAME_TO_ID[l.name] === feId)?.id)
                .filter((id): id is number => id != null);
              const position  = filterState.position !== 'ALL' ? filterState.position : undefined;
              const minFeeEur = filterState.feeMin > 0  ? filterState.feeMin * 1_000_000 : undefined;
              const maxFeeEur = filterState.feeMax < 300 ? filterState.feeMax * 1_000_000 : undefined;
              const targets   = beLeagueIds.length > 0 ? beLeagueIds : [undefined as unknown as number];
              const paramsList = targets.map(leagueId => ({ season: filterState.season, leagueId, position, minFeeEur, maxFeeEur, from, to, size: 100 }));

              if (onApplyFilter) onApplyFilter(paramsList, filterState.statuses);
              setSeason(filterState.season);

              setApplyLoading(true);
              try {
                const results = await Promise.all(
                  paramsList.flatMap(params =>
                    [...filterState.statuses].map(status => {
                      const beStatus = status === 'rumour' ? 'RUMOR' : status.toUpperCase();
                      return fetchNews({ ...params, status: beStatus });
                    })
                  )
                );
                const merged = results.flat();
                const seen = new Set<number>();
                const deduped = merged.filter(n => { if (seen.has(n.id)) return false; seen.add(n.id); return true; });
                setAppliedItems(deduped);
              } catch { /* keep current on error */ }
              finally { setApplyLoading(false); }

              setView('news');
            }}
              disabled={filterCountLoading || applyLoading}
              className="flex-1 py-2.5 rounded-lg bg-[var(--accent)] hover:bg-blue-400
                         text-white text-[0.8rem] font-bold tracking-wide transition-colors
                         disabled:opacity-60 disabled:cursor-not-allowed">
              {filterCountLoading || applyLoading ? 'Loading…' : `Show Results · ${filterCount}`}
            </button>
            <button className="px-5 py-2.5 rounded-lg border border-[var(--border)]
                               text-[var(--text-sub)] hover:text-[var(--text)] text-[0.8rem] font-bold
                               hover:border-[var(--accent)]/40 transition-all">
              ★ Save
            </button>
          </div>
        </div>
      )}

      {/* ── LEAGUE VIEW ───────────────────────────────────────────────────── */}
      {view === 'league' && selectedLeague && (
        <>
          <div className="flex items-center px-7 py-6 border-b border-[var(--border)] gap-3 flex-shrink-0">
            <button onClick={handleClose}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] transition-all">✕</button>
            <div className="flex-1">
              <div className="text-[0.78rem] text-[var(--text-sub)] font-semibold tracking-widest uppercase mb-0.5">
                {selectedLeague.flag} {selectedLeague.country}
              </div>
              <div className="text-[0.95rem] font-extrabold tracking-wide">{selectedLeague.name}</div>
            </div>
            <span className="px-3.5 py-1.5 rounded-full text-[0.75rem] font-black tracking-wide flex-shrink-0"
              style={{ background: selectedLeague.color, color: selectedLeague.accent, border: `1px solid ${selectedLeague.accent}44` }}>
              {selectedLeague.abbr}
            </span>
          </div>

          <div className="px-7 pt-4 pb-3 flex-shrink-0">
            <select value={season} onChange={e => setSeason(Number(e.target.value))}
              className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg px-3 py-1.5
                         text-[0.8rem] text-[var(--text)] focus:outline-none focus:border-[var(--accent)]/50
                         transition-colors cursor-pointer">
              {SEASON_OPTIONS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
            </select>
          </div>

          <div className="flex border-b border-[var(--border)] flex-shrink-0">
            {[
              { label: 'Clubs',     value: seasonClubsLoading ? '…' : seasonClubs.length },
              { label: 'Transfers', value: selectedLeague.transfers },
              { label: 'News',      value: selectedLeague.news },
            ].map(s => (
              <div key={s.label} className="flex-1 py-5 text-center border-r border-[var(--border)] last:border-r-0">
                <div className="text-[1.3rem] font-extrabold" style={{ color: selectedLeague.accent }}>{s.value}</div>
                <div className="text-[0.66rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mt-0.5">{s.label}</div>
              </div>
            ))}
          </div>

          <div className="flex-1 overflow-y-auto py-4">
            <div className="px-5 mb-3 text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">Clubs</div>
            {seasonClubsLoading
              ? <div className="flex items-center justify-center h-20 text-[0.82rem] text-[var(--text-sub)]">Loading…</div>
              : seasonClubs.map(club => (
                  <button key={club.id}
                    onClick={() => {
                      setViewingClubId(club.id);
                      setView('club');
                      setClubTab('in');
                      setClubLoading(true);
                      fetchClub(club.id)
                        .then(detail => setClubDetail(detail))
                        .catch(err => { if (err instanceof ApiError && err.status >= 500) navigate('/500'); })
                        .finally(() => setClubLoading(false));
                    }}
                    className="w-full flex items-center gap-4 px-5 py-4 text-left
                               hover:bg-[rgba(255,255,255,0.04)] transition-colors border-b border-[var(--border)] last:border-b-0">
                    <div className="w-9 h-9 rounded-xl flex-shrink-0 flex items-center justify-center text-lg"
                      style={{ background: club.color + '22', border: `1.5px solid ${club.color}88`, boxShadow: `0 0 10px ${club.color}44` }}>
                      {club.emoji ?? '⚽'}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="text-[0.88rem] font-bold truncate">{club.name}</div>
                      <div className="text-[0.7rem] text-[var(--text-sub)] mt-0.5">
                        {club.lon.toFixed(2)}°E · {club.lat.toFixed(2)}°N
                      </div>
                    </div>
                    <div className="w-2 h-2 rounded-full flex-shrink-0"
                      style={{ background: club.color, boxShadow: `0 0 6px ${club.color}` }} />
                  </button>
                ))
            }
          </div>
        </>
      )}

      {/* ── CLUB VIEW ─────────────────────────────────────────────────────── */}
      {view === 'club' && (
        <>
          <div className="flex items-center px-7 py-6 border-b border-[var(--border)] gap-3 flex-shrink-0">
            <button onClick={() => { setViewingClubId(null); setView(selectedLeague ? 'league' : 'news'); }}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] transition-all">←</button>
            <div className="text-[0.92rem] font-bold tracking-widest uppercase flex-1">{clubDetail?.name ?? '…'}</div>
            <button onClick={handleClose}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] transition-all">✕</button>
          </div>

          {clubLoading ? (
            <div className="flex-1 flex items-center justify-center text-[0.82rem] text-[var(--text-sub)]">Loading…</div>
          ) : clubDetail && (
            <>
              <div className="px-7 py-7 border-b border-[var(--border)] flex-shrink-0">
                <div className="flex items-center gap-5 mb-6">
                  <div className="w-14 h-14 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                                  flex items-center justify-center text-2xl flex-shrink-0">🏟️</div>
                  <div>
                    <h2 className="text-[1.05rem] font-extrabold">{clubDetail.name}</h2>
                    <div className="text-[0.76rem] text-[var(--text-sub)] mt-1.5 space-y-0.5">
                      {clubDetail.leagueName && <div>{clubDetail.leagueName}</div>}
                      {clubDetail.city && <div>{clubDetail.city}{clubDetail.countryCode ? ` · ${clubDetail.countryCode}` : ''}</div>}
                      {clubDetail.stadiumName && <div className="text-[var(--accent)]">{clubDetail.stadiumName}</div>}
                    </div>
                  </div>
                </div>
                <div className="flex gap-8 text-[0.74rem] text-[var(--text-sub)]">
                  <div>
                    <strong className="block text-[1.4rem] text-[var(--text)] font-extrabold leading-none mb-1.5">
                      {clubTransfersLoading ? '…' : clubTransfers.incoming.length}
                    </strong>Incoming
                  </div>
                  <div>
                    <strong className="block text-[1.4rem] text-[var(--text)] font-extrabold leading-none mb-1.5">
                      {clubTransfersLoading ? '…' : clubTransfers.outgoing.length}
                    </strong>Outgoing
                  </div>
                </div>
              </div>

              {/* Season selector */}
              <div className="px-7 pt-4 pb-3 flex-shrink-0">
                <select value={clubSeason} onChange={e => setClubSeason(Number(e.target.value))}
                  className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg px-3 py-1.5
                             text-[0.8rem] text-[var(--text)] focus:outline-none focus:border-[var(--accent)]/50
                             transition-colors cursor-pointer">
                  {SEASON_OPTIONS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
                </select>
              </div>

              <div className="flex border-b border-[var(--border)] flex-shrink-0">
                {(['in', 'out'] as const).map(t => (
                  <button key={t} onClick={() => setClubTab(t)}
                    className={`flex-1 py-4 text-[0.76rem] font-bold tracking-wide uppercase border-b-2 transition-all
                      ${clubTab === t ? 'text-[var(--accent)] border-[var(--accent)]' : 'text-[var(--text-sub)] border-transparent'}`}>
                    {t === 'in' ? 'Incoming' : 'Outgoing'}
                  </button>
                ))}
              </div>

              <div className="flex-1 overflow-y-auto py-5">
                {clubTransfersLoading
                  ? <div className="flex items-center justify-center h-32 text-[0.82rem] text-[var(--text-sub)]">Loading…</div>
                  : activeTransfers.length === 0
                    ? <div className="py-14 text-center text-[0.82rem] text-[var(--text-sub)]">No transfers</div>
                    : activeTransfers.map((t, i) => (
                        <div key={i} className="mx-5 mb-4 p-6 rounded-xl bg-[var(--surface)] border border-[var(--border)]">
                          <div className="flex items-start justify-between gap-4 mb-3">
                            <div className="text-[0.9rem] font-bold">{t.player}</div>
                            <span className={`px-3 py-1 rounded-full text-[0.64rem] font-bold border flex-shrink-0 ${STATUS_STYLE[t.status] ?? ''}`}>
                              {t.status.toUpperCase()}
                            </span>
                          </div>
                          <div className="text-[0.82rem] text-[rgba(200,220,255,0.6)] mb-2.5">{t.fee}</div>
                          <div className="text-[0.76rem] text-[var(--text-sub)]">
                            {clubTab === 'in' ? `from: ${t.from}` : `to: ${t.to}`}
                          </div>
                        </div>
                      ))
                }
              </div>
            </>
          )}
        </>
      )}
    </div>
  );
});

export default SidePanel;

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
          ${checked ? 'bg-[var(--accent)] border-[var(--accent)]' : 'border-[var(--border)] group-hover:border-[var(--accent)]/50'}`}>
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
