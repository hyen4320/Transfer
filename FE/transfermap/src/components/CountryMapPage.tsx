import { useEffect, useRef, useCallback, useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useIsMobile } from '../hooks/useIsMobile';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club, NewsItem, TransferStatus, Player } from '../types';
import SidePanel from './SidePanel';
import PlayerPanel from './PlayerPanel';
import { resolveOverlaps, parseFee } from '../utils/mapUtils';
import { loadWorldAtlas } from '../utils/worldAtlas';
import { fetchLeagues } from '../api/leagues';
import { fetchNews } from '../api/news';
import { fetchPlayersSearch } from '../api/players';
import { LEAGUE_NAME_TO_ID } from '../data/constants';
import { getTransferWindowState } from '../utils/transferWindow';
import type { ApiLeague } from '../api/types';

// 지난 시즌은 이적료순, 현재 시즌(윈도우 열림)은 시간순 — useNews/useNewsInfinite와 동일 기준
const { season: CURRENT_SEASON, isOpen: WINDOW_IS_OPEN } = getTransferWindowState();
const sortForSeason = (s: number): string =>
  s < CURRENT_SEASON || (s === CURRENT_SEASON && !WINDOW_IS_OPEN)
    ? 'feeEur,desc'
    : 'publishedAt,desc';

const EUROPEAN_IDS = new Set([
  8,20,40,56,70,100,112,191,196,203,208,233,246,250,276,300,348,352,372,380,
  428,438,440,442,470,492,498,499,528,578,616,620,642,674,688,703,705,724,
  752,756,804,807,826,
]);

const STATUS_COLOR: Record<TransferStatus, string> = {
  confirmed: '#22c55e',
  rumour:    '#f59e0b',
  denied:    '#ef4444',
  loan:      '#a78bfa',
};

const STATUS_LABEL: Record<TransferStatus, string> = {
  confirmed: 'CONFIRMED',
  rumour:    'RUMOUR',
  denied:    'DENIED',
  loan:      'LOAN',
};

interface RouteInfo {
  id: number;
  d: string;
  status: TransferStatus;
  sameLeague: boolean;
  player: string;
  fee: string;
  from: string;
  to: string;
  animDur: number;
  animate: boolean;
}

const ANIM_LIMIT = 20;

function nameMatch(a: string, b: string): boolean {
  if (!a || !b) return false;
  a = a.toLowerCase().trim();
  b = b.toLowerCase().trim();
  return a === b || a.includes(b) || b.includes(a);
}

const PAGE_SIZE = 30;

interface Props {
  league: League;
  onBack: () => void;
  backLabel?: string;
  clubs?: Club[];
  news?: NewsItem[];
  flyPlayer?: Player | null;
  onNewsClick?: (item: NewsItem) => void;
  leftOffset?: number;
  searchOpen?: boolean;
  onToggleSearch?: () => void;
  season?: number;
}


export default function CountryMapPage({ league, onBack, backLabel = '← Map', clubs: clubsProp, news: _newsProp = [], flyPlayer, onNewsClick, leftOffset = 0, searchOpen = false, onToggleSearch, season = CURRENT_SEASON }: Props) {
  const navigate = useNavigate();
  const sceneRef  = useRef<HTMLDivElement>(null);
  const bgRef     = useRef<SVGSVGElement>(null);   // z=1: 국가 배경만
  const worldRef  = useRef<Awaited<ReturnType<typeof loadWorldAtlas>> | null>(null);
  const projRef   = useRef<d3.GeoProjection | null>(null);

  const isMobile = useIsMobile();
  const [localSeason,    setLocalSeason]    = useState(season);
  const [statusFilters,  setStatusFilters]  = useState({ rumour: true, confirmed: true, denied: false, loan: true });
  const [sheetFull,      setSheetFull]      = useState(false);
  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [openPlayerId,   setOpenPlayerId]   = useState<number | null>(null);
  const [hoveredClub,    setHoveredClub]    = useState<number | null>(null);
  const [routePaths,     setRoutePaths]     = useState<RouteInfo[]>([]);
  const [hoveredRoute,   setHoveredRoute]   = useState<RouteInfo | null>(null);
  const [tooltipPos,     setTooltipPos]     = useState({ x: 0, y: 0 });
  const [clubPixelPos,   setClubPixelPos]   = useState<Record<number, { x: number; y: number }>>({});

  // Infinite scroll news
  const [beLeagueId,  setBeLeagueId]  = useState<number | undefined>(undefined);
  const [newsItems,   setNewsItems]   = useState<NewsItem[]>([]);
  const [newsLoading, setNewsLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore,     setHasMore]     = useState(true);
  const newsPageRef = useRef(0);

  useEffect(() => {
    fetchLeagues()
      .then((ls: ApiLeague[]) => {
        const id = ls.find(l => LEAGUE_NAME_TO_ID[l.name] === league.id)?.id;
        setBeLeagueId(id);
      })
      .catch(() => setBeLeagueId(undefined));
  }, [league.id]);

  useEffect(() => {
    if (beLeagueId === undefined) return;
    const controller = new AbortController();
    newsPageRef.current = 0;
    setHasMore(true);
    setNewsLoading(true);
    const sort = sortForSeason(localSeason);
    fetchNews({ season: localSeason, leagueId: beLeagueId, size: PAGE_SIZE, page: 0, sort }, controller.signal)
      .then(data => { setNewsItems(data); setHasMore(data.length === PAGE_SIZE); })
      .catch(err  => { if (err?.name !== 'AbortError') setNewsItems([]); })
      .finally(() => setNewsLoading(false));
    return () => controller.abort();
  }, [beLeagueId, localSeason]);

  const loadMore = useCallback(() => {
    if (loadingMore || !hasMore || beLeagueId === undefined) return;
    const next = newsPageRef.current + 1;
    const sort = sortForSeason(localSeason);
    setLoadingMore(true);
    fetchNews({ season: localSeason, leagueId: beLeagueId, size: PAGE_SIZE, page: next, sort })
      .then(data => {
        setNewsItems(prev => [...prev, ...data]);
        setHasMore(data.length === PAGE_SIZE);
        newsPageRef.current = next;
      })
      .catch(() => {})
      .finally(() => setLoadingMore(false));
  }, [loadingMore, hasMore, beLeagueId, localSeason]);

  const allClubs    = clubsProp ?? [];
  const leagueClubs = useMemo(() => allClubs.filter(c => c.league === league.id), [allClubs, league.id]);

  const filteredNewsItems = useMemo(
    () => newsItems.filter(n => statusFilters[n.status as keyof typeof statusFilters] ?? true),
    [newsItems, statusFilters],
  );

  const leagueClubIds = useMemo(() => new Set(leagueClubs.map(c => c.id)), [leagueClubs]);

  // 시즌 + 상태 필터가 적용된 newsItems로 이적선 재계산
  const computeRoutes = useCallback(() => {
    const proj = projRef.current;
    if (!proj || Object.keys(clubPixelPos).length === 0) return;

    const resolvedMap = new Map(
      Object.entries(clubPixelPos).map(([id, pos]) => [Number(id), pos])
    );

    const clubProjMap = new Map(allClubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return [c.id, p ? { x: p[0], y: p[1], club: c } : null] as const;
    }));

    function findClubProj(name: string) {
      if (!name || name === 'Free Agent') return null;
      for (const entry of clubProjMap.values()) {
        if (entry && nameMatch(entry.club.name, name)) {
          const resolved = resolvedMap.get(entry.club.id);
          if (resolved) return { x: resolved.x, y: resolved.y, club: entry.club };
          return entry;
        }
      }
      return null;
    }

    const sortedNews = [...newsItems].sort((a, b) => parseFee(b.fee) - parseFee(a.fee));
    const computed = sortedNews.map((n, rank) => {
      const fp = findClubProj(n.from ?? '');
      const tp = findClubProj(n.to);
      if (!fp || !tp) return null;

      const fromInLeague = leagueClubIds.has(fp.club.id);
      const toInLeague   = leagueClubIds.has(tp.club.id);
      if (!fromInLeague && !toInLeague) return null;

      const [x1, y1] = [fp.x, fp.y];
      const [x2, y2] = [tp.x, tp.y];
      const sameLeague = fromInLeague && toInLeague;
      const dx = x2 - x1, dy = y2 - y1;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const lift = Math.max(dist * (sameLeague ? 0.22 : 0.38), sameLeague ? 22 : 45);
      const perpX = (dy / Math.max(dist, 1)) * lift * 0.35;
      const mx = (x1 + x2) / 2 + perpX;
      const my = (y1 + y2) / 2 - lift;

      return {
        id: n.id,
        d: `M${x1.toFixed(1)},${y1.toFixed(1)} Q${mx.toFixed(1)},${my.toFixed(1)} ${x2.toFixed(1)},${y2.toFixed(1)}`,
        status: n.status,
        sameLeague,
        player: n.player,
        fee: n.fee,
        from: n.from ?? '',
        to: n.to,
        animDur: n.status === 'confirmed' ? 2.2 : n.status === 'rumour' ? 3.5 : 5,
        animate: rank < ANIM_LIMIT && n.status !== 'denied',
      } as RouteInfo;
    }).filter((r): r is RouteInfo => r !== null);

    setRoutePaths(computed);
  }, [newsItems, clubPixelPos, allClubs, leagueClubIds]);

  useEffect(() => { computeRoutes(); }, [computeRoutes]);

  // Route status filter (map overlay)
  const filteredRoutes = useMemo(() =>
    routePaths.filter(r => statusFilters[r.status] ?? true),
  [routePaths, statusFilters]);

  // 뉴스 선수 이름 클릭 → PlayerPanel
  const handlePlayerClick = async (name: string) => {
    const found = filteredNewsItems.find(n => n.player === name);
    if (found?.playerId) { setOpenPlayerId(found.playerId); return; }
    const results = await fetchPlayersSearch(name, 1).catch(() => []);
    if (results[0]) setOpenPlayerId(results[0].id);
  };

  // D3: 국가 배경만 그림 (circles는 React로)
  const draw = useCallback((cW: number, cH: number) => {
    const world = worldRef.current;
    if (!world || !bgRef.current) return;

    const svg = d3.select(bgRef.current);
    svg.attr('width', cW).attr('height', cH);
    svg.selectAll('*').remove();

    // Background glow
    const defs = svg.append('defs');
    const rg = defs.append('radialGradient')
      .attr('id', 'cMapGlow').attr('cx', '50%').attr('cy', '50%').attr('r', '50%');
    rg.append('stop').attr('offset',  '0%').attr('stop-color', league.accent).attr('stop-opacity', 0.06);
    rg.append('stop').attr('offset', '100%').attr('stop-color', '#000').attr('stop-opacity', 0);
    svg.append('rect').attr('width', cW).attr('height', cH).attr('fill', 'url(#cMapGlow)');

    const proj = d3.geoMercator().center(league.center).scale(league.scale).translate([cW / 2, cH / 2]);
    projRef.current = proj;
    const pg   = d3.geoPath().projection(proj);

    const allFeatures    = topojson.feature(world, world.objects.countries).features;
    const countryFeature = allFeatures.find(f => +f.id! === league.numericId);
    const europeFeatures = allFeatures.filter(f => EUROPEAN_IDS.has(+(f.id ?? 0)));

    // 주변국 (dim)
    svg.selectAll<SVGPathElement, typeof europeFeatures[0]>('.nbr')
      .data(europeFeatures).join('path')
      .attr('class', 'nbr').attr('d', pg)
      .attr('fill', '#0a1828').attr('stroke', '#1a4a8a55').attr('stroke-width', 0.6);

    // 해당 국가 강조
    if (countryFeature) {
      svg.append('path').datum(countryFeature as GeoPermissibleObjects).attr('d', pg)
        .attr('fill', league.color + '55')
        .attr('stroke', league.accent)
        .attr('stroke-width', 1.5)
        .attr('filter', `drop-shadow(0 0 8px ${league.accent}66)`);
    }

    // 구단 투영 좌표 계산 (React circle 렌더링용)
    const rawPos = leagueClubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return { id: c.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    });
    const resolvedPos = resolveOverlaps(rawPos, 20);
    setClubPixelPos(Object.fromEntries(resolvedPos.map(p => [p.id, { x: p.x, y: p.y }])));

  }, [league, leagueClubs]);

  useEffect(() => {
    loadWorldAtlas().then(world => {
      worldRef.current = world;
      const el = sceneRef.current;
      if (el) draw(el.clientWidth, el.clientHeight);
    });
  }, [draw]);

  useEffect(() => {
    const el = sceneRef.current;
    if (!el) return;
    let timer: ReturnType<typeof setTimeout>;
    const ro = new ResizeObserver(entries => {
      const { width, height } = entries[0].contentRect;
      clearTimeout(timer);
      timer = setTimeout(() => {
        if (worldRef.current) draw(width, height);
      }, 80);
    });
    ro.observe(el);
    return () => { ro.disconnect(); clearTimeout(timer); };
  }, [draw]);

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col overflow-hidden"
         style={{ left: leftOffset, transition: 'left 350ms cubic-bezier(0.4,0,0.2,1)' }}>
      {/* Header */}
      <div className="flex items-center gap-3 px-6 py-[18px] border-b border-[var(--border)] flex-shrink-0">
        <button onClick={onBack}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.8rem] px-3.5 py-1.5 rounded-md
                     hover:text-[var(--text)] hover:border-white/20 transition-all">{backLabel}</button>
        <div className="text-base font-extrabold tracking-[0.12em] uppercase flex-1">
          {league.flag} {league.country}
        </div>
        <span className="px-3.5 py-1.5 rounded-full text-[0.78rem] font-black tracking-wide"
          style={{ background: league.color, color: league.accent, border: `1px solid ${league.accent}44` }}>
          {league.name}
        </span>
        {onToggleSearch && (
          <button onClick={onToggleSearch}
            className={`border text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md transition-all
              ${searchOpen
                ? 'border-[var(--accent)]/60 text-[var(--accent)] bg-[var(--accent)]/10'
                : 'border-[var(--border)] text-[var(--text-sub)] hover:text-[var(--text)] hover:border-white/20'}`}>
            ⌕ Search
          </button>
        )}
      </div>

      {/* Body */}
      <div className="flex-1 flex overflow-hidden relative">
        {/* Map */}
        <div ref={sceneRef} className="flex-1 relative overflow-hidden">

          {/* Layer 1 — 국가 배경 (D3) */}
          <svg ref={bgRef} className="absolute inset-0" style={{ zIndex: 1 }} />

          {/* Layer 2 — 이적 선 (React, z=5) */}
          <svg className="absolute inset-0" style={{ zIndex: 5, overflow: 'visible', pointerEvents: 'none' }}>
            <defs>
              <filter id="ca-dot-blur" x="-50%" y="-50%" width="200%" height="200%">
                <feGaussianBlur stdDeviation="2" />
              </filter>
              {(Object.entries(STATUS_COLOR) as [TransferStatus, string][]).map(([status, color]) => (
                <marker key={status}
                  id={`ca-arrow-${status}`}
                  markerWidth="7" markerHeight="5"
                  refX="6" refY="2.5" orient="auto">
                  <polygon points="0 0, 7 2.5, 0 5" fill={color} fillOpacity="0.85" />
                </marker>
              ))}
            </defs>

            {filteredRoutes.map(r => {
              const color   = STATUS_COLOR[r.status];
              const opacity = r.status === 'denied' ? 0.25 : r.sameLeague ? 0.6 : 0.8;
              const strokeW = r.sameLeague ? 1.8 : 2.5;
              const dashes  = r.status === 'confirmed' ? undefined
                            : r.status === 'rumour'    ? '7 4'
                            : '3 6';
              return (
                <g key={r.id} style={{ pointerEvents: 'auto' }}
                   onMouseEnter={e => { setHoveredRoute(r); setTooltipPos({ x: e.clientX, y: e.clientY }); }}
                   onMouseLeave={() => setHoveredRoute(null)}
                   onMouseMove={e => setTooltipPos({ x: e.clientX, y: e.clientY })}>

                  {!r.sameLeague && (
                    <path d={r.d} fill="none" stroke={color} strokeWidth={10} strokeOpacity={0.1} />
                  )}

                  <path d={r.d} fill="none"
                    stroke={color} strokeWidth={strokeW} strokeOpacity={opacity}
                    strokeDasharray={dashes}
                    markerEnd={`url(#ca-arrow-${r.status})`}
                    style={{ cursor: 'pointer' }}
                  />

                  <path d={r.d} fill="none" stroke="transparent" strokeWidth={16} style={{ cursor: 'pointer' }} />

                  {r.animate && (
                    <circle r={r.sameLeague ? 3.5 : 5} fill={color}
                      style={{ filter: `drop-shadow(0 0 ${r.sameLeague ? 4 : 8}px ${color})` }}>
                      <animateMotion dur={`${r.animDur}s`} repeatCount="indefinite"
                        {...({ path: r.d } as any)} />
                    </circle>
                  )}

                  {r.animate && r.status === 'confirmed' && (
                    <circle r={r.sameLeague ? 6 : 10} fill={color} fillOpacity={0.15} filter="url(#ca-dot-blur)">
                      <animateMotion dur={`${r.animDur}s`} repeatCount="indefinite" begin="0.15s"
                        {...({ path: r.d } as any)} />
                    </circle>
                  )}
                </g>
              );
            })}
          </svg>

          {/* Layer 3 — 구단 원 (React, z=10) — 선 위에 렌더링 */}
          <svg className="absolute inset-0" style={{ zIndex: 10, overflow: 'visible' }}>
            {leagueClubs.map(c => {
              const pos = clubPixelPos[c.id];
              if (!pos) return null;
              const hovered = hoveredClub === c.id;
              return (
                <g key={c.id} style={{ cursor: 'pointer' }}
                   onMouseEnter={() => setHoveredClub(c.id)}
                   onMouseLeave={() => setHoveredClub(null)}
                   onClick={() => setSelectedClubId(c.id)}>
                  <circle cx={pos.x} cy={pos.y} r={hovered ? 10 : 7}
                    fill={c.color} stroke="#fff" strokeWidth={1.5}
                    style={{ filter: `drop-shadow(0 0 6px ${c.color})` }} />
                  {hovered && (
                    <text x={pos.x} y={pos.y - 14} textAnchor="middle"
                      fill="#fff" fontSize="11" fontWeight="700"
                      fontFamily="Helvetica Neue, Arial, sans-serif"
                      style={{ pointerEvents: 'none' }}>
                      {c.name}
                    </text>
                  )}
                </g>
              );
            })}
          </svg>

          {/* Fly-to player popover */}
          {flyPlayer && (() => {
            const club = leagueClubs.find(c =>
              c.name.toLowerCase().includes(flyPlayer.currentClub?.toLowerCase() ?? '') ||
              flyPlayer.currentClub?.toLowerCase().includes(c.name.toLowerCase())
            );
            const pos = club ? clubPixelPos[club.id] : null;
            if (!pos) return null;
            return (
              <div className="absolute z-[56] pointer-events-auto select-none"
                   style={{ left: pos.x + 18, top: pos.y - 110 }}>
                <svg className="absolute -bottom-6 left-3 overflow-visible pointer-events-none" width="2" height="28">
                  <line x1="1" y1="0" x2="1" y2="28" stroke="rgba(255,255,255,0.3)"
                    strokeWidth="1" strokeDasharray="3 3"/>
                </svg>
                <div className="bg-[rgba(4,8,18,0.96)] border border-white/15 rounded-xl px-4 py-3.5
                                shadow-2xl min-w-[220px] backdrop-blur-xl">
                  <div className="flex items-center gap-3 mb-2.5">
                    <div className="w-10 h-10 rounded-lg bg-[var(--surface2)] border border-[var(--border)]
                                    flex items-center justify-center text-xl flex-shrink-0">
                      {flyPlayer.emoji ?? '⚽'}
                    </div>
                    <div>
                      <div className="text-white font-bold text-[0.9rem] leading-tight">{flyPlayer.name}</div>
                      <div className="text-white/50 text-[0.72rem] mt-0.5">
                        {flyPlayer.position} · {flyPlayer.age} · {flyPlayer.flag ?? flyPlayer.nationality}
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 mb-3">
                    <span className="text-[0.68rem] font-bold px-2.5 py-1 rounded-full
                                     bg-[var(--accent)]/15 border border-[var(--accent)]/30 text-[var(--accent)]">
                      {flyPlayer.currentClub}
                    </span>
                    {flyPlayer.marketValue && (
                      <span className="text-[0.68rem] font-bold text-white/60">{flyPlayer.marketValue}</span>
                    )}
                  </div>
                  <button onClick={() => navigate(`/players/${flyPlayer.id}`)}
                    className="w-full py-1.5 rounded-lg bg-[var(--accent)] hover:bg-blue-400
                               text-white text-[0.72rem] font-bold transition-colors text-center">
                    VIEW PLAYER →
                  </button>
                </div>
              </div>
            );
          })()}

          {/* Route tooltip */}
          {hoveredRoute && (
            <div className="fixed z-[60] pointer-events-none select-none
                            bg-[rgba(4,8,18,0.96)] border border-white/10
                            rounded-xl px-3.5 py-2.5 min-w-[170px] shadow-2xl"
                 style={{ left: tooltipPos.x + 14, top: tooltipPos.y - 50 }}>
              <div className="text-white font-bold text-sm leading-tight">{hoveredRoute.player}</div>
              <div className="text-white/50 text-xs mt-0.5">
                {hoveredRoute.from}
                <span className="text-white/30 mx-1">→</span>
                {hoveredRoute.to}
              </div>
              <div className="flex items-center gap-2 mt-2">
                <span className="text-[0.65rem] font-bold px-1.5 py-0.5 rounded"
                  style={{
                    color: STATUS_COLOR[hoveredRoute.status],
                    background: STATUS_COLOR[hoveredRoute.status] + '20',
                    border: `1px solid ${STATUS_COLOR[hoveredRoute.status]}40`,
                  }}>
                  {STATUS_LABEL[hoveredRoute.status]}
                </span>
                <span className="text-white text-xs font-bold">{hoveredRoute.fee}</span>
              </div>
              <div className="text-white/30 text-[0.6rem] mt-1.5 tracking-wider">
                {hoveredRoute.sameLeague ? '◈ Same League' : '✈ Cross League'}
              </div>
            </div>
          )}
        </div>

        {/* Desktop sidebar */}
        {!isMobile && (
          <div className="w-[460px] flex-shrink-0 border-l border-[var(--border)] flex flex-col overflow-hidden">
            <SidePanel
              variant="inline"
              open={true}
              onClose={() => setSelectedClubId(null)}
              selectedLeague={league}
              leagueClubs={leagueClubs}
              selectedClubId={selectedClubId}
              season={localSeason}
              onSeasonChange={setLocalSeason}
              preloadedNews={{ items: newsItems, loading: newsLoading, loadingMore, hasMore, loadMore }}
              onPlayerClick={handlePlayerClick}
              onPlayerPanelOpen={setOpenPlayerId}
              onStatusFilterChange={setStatusFilters}
              hoveredRouteId={hoveredRoute?.id}
              onNewsClick={onNewsClick}
            />
          </div>
        )}

        {/* Mobile bottom sheet */}
        {isMobile && (
          <div className={`absolute bottom-0 left-0 right-0 z-10 h-[82dvh]
                           bg-[rgba(8,14,26,0.97)] border-t border-[var(--border)] rounded-t-2xl
                           flex flex-col
                           transition-transform duration-[350ms] ease-[cubic-bezier(0.4,0,0.2,1)]
                           ${sheetFull ? 'translate-y-0' : 'translate-y-[calc(100%-72px)]'}`}>
            <button onClick={() => setSheetFull(f => !f)}
              className="flex-shrink-0 flex flex-col items-center pt-3 pb-2 gap-1 w-full">
              <span className="w-10 h-1 rounded-full bg-white/20" />
              <span className="text-[0.58rem] tracking-widest text-[var(--text-sub)] uppercase">
                {sheetFull ? '▼ Collapse' : `▲ News & Clubs · ${newsItems.length}`}
              </span>
            </button>
            <SidePanel
              variant="inline"
              open={true}
              onClose={() => setSelectedClubId(null)}
              selectedLeague={league}
              leagueClubs={leagueClubs}
              selectedClubId={selectedClubId}
              season={localSeason}
              onSeasonChange={setLocalSeason}
              preloadedNews={{ items: newsItems, loading: newsLoading, loadingMore, hasMore, loadMore }}
              onPlayerClick={handlePlayerClick}
              onPlayerPanelOpen={setOpenPlayerId}
              onStatusFilterChange={setStatusFilters}
              hoveredRouteId={hoveredRoute?.id}
              onNewsClick={onNewsClick}
            />
          </div>
        )}
      </div>

      <PlayerPanel
        playerId={openPlayerId}
        onClose={() => setOpenPlayerId(null)}
      />
    </div>
  );
}
