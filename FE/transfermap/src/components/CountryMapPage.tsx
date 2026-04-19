import { useEffect, useRef, useCallback, useState, useMemo } from 'react';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club, NewsItem, TransferStatus } from '../types';
import NewsCard from './NewsCard';
import SidePanel from './SidePanel';
import { resolveOverlaps, parseFee } from '../utils/mapUtils';
import { loadWorldAtlas } from '../utils/worldAtlas';

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

interface Props {
  league: League;
  onBack: () => void;
  backLabel?: string;
  clubs?: Club[];
  news?: NewsItem[];
}

export default function CountryMapPage({ league, onBack, backLabel = '← Map', clubs: clubsProp, news: newsProp = [] }: Props) {
  const sceneRef = useRef<HTMLDivElement>(null);
  const mapRef   = useRef<SVGSVGElement>(null);
  const worldRef = useRef<Awaited<ReturnType<typeof loadWorldAtlas>> | null>(null);

  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [routePaths,     setRoutePaths]     = useState<RouteInfo[]>([]);
  const [hoveredRoute,   setHoveredRoute]   = useState<RouteInfo | null>(null);
  const [tooltipPos,     setTooltipPos]     = useState({ x: 0, y: 0 });

  const allClubs    = clubsProp ?? [];
  const leagueClubs = useMemo(() => allClubs.filter(c => c.league === league.id), [allClubs, league.id]);
  const leagueClubIds = useMemo(() => new Set(leagueClubs.map(c => c.id)), [leagueClubs]);

  const countryNews = useMemo(() =>
    newsProp.filter(n =>
      leagueClubs.some(c => nameMatch(c.name, n.from) || nameMatch(c.name, n.to))
    ),
    [leagueClubs, newsProp]
  );
  const feedItems = countryNews.length ? countryNews : newsProp.slice(0, 10);

  const draw = useCallback((cW: number, cH: number) => {
    const world = worldRef.current;
    if (!world || !mapRef.current) return;

    const mapSvg = d3.select(mapRef.current);
    mapSvg.attr('width', cW).attr('height', cH);
    mapSvg.selectAll('*').remove();

    // Background glow
    const mdefs = mapSvg.append('defs');
    const rg = mdefs.append('radialGradient')
      .attr('id', 'cMapGlow').attr('cx', '50%').attr('cy', '50%').attr('r', '50%');
    rg.append('stop').attr('offset',  '0%').attr('stop-color', league.accent).attr('stop-opacity', 0.06);
    rg.append('stop').attr('offset', '100%').attr('stop-color', '#000').attr('stop-opacity', 0);
    mapSvg.append('rect').attr('width', cW).attr('height', cH).attr('fill', 'url(#cMapGlow)');

    const proj = d3.geoMercator().center(league.center).scale(league.scale).translate([cW / 2, cH / 2]);
    const pg   = d3.geoPath().projection(proj);

    const allFeatures    = topojson.feature(world, world.objects.countries).features;
    const countryFeature = allFeatures.find(f => +f.id! === league.numericId);
    const europeFeatures = allFeatures.filter(f => EUROPEAN_IDS.has(+(f.id ?? 0)));

    // Dim neighbours
    mapSvg.selectAll<SVGPathElement, typeof europeFeatures[0]>('.nbr')
      .data(europeFeatures).join('path')
      .attr('class', 'nbr').attr('d', pg)
      .attr('fill', '#0a1828').attr('stroke', '#1a4a8a55').attr('stroke-width', 0.6);

    // Highlighted country
    if (countryFeature) {
      mapSvg.append('path').datum(countryFeature as GeoPermissibleObjects).attr('d', pg)
        .attr('fill', league.color + '55')
        .attr('stroke', league.accent)
        .attr('stroke-width', 1.5)
        .attr('filter', `drop-shadow(0 0 8px ${league.accent}66)`);
    }

    // Club markers (overlap resolved)
    const rawPos = leagueClubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return { id: c.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    });
    const resolvedPos = resolveOverlaps(rawPos, 20);

    leagueClubs.forEach((c, idx) => {
      const { x: cx, y: cy } = resolvedPos[idx];
      mapSvg.append('circle').attr('cx', cx).attr('cy', cy).attr('r', 7)
        .attr('fill', c.color).attr('stroke', '#fff').attr('stroke-width', 1.5)
        .style('cursor', 'pointer')
        .attr('filter', `drop-shadow(0 0 6px ${c.color})`)
        .on('mouseover', function() {
          d3.select(this).attr('r', 10);
          mapSvg.append('text').attr('class', 'club-lbl')
            .attr('x', cx).attr('y', cy - 14)
            .attr('text-anchor', 'middle').attr('fill', '#fff')
            .attr('font-size', '11px').attr('font-weight', '700')
            .attr('font-family', 'Helvetica Neue, Arial, sans-serif')
            .text(c.name);
        })
        .on('mouseout', function() {
          d3.select(this).attr('r', 7);
          mapSvg.selectAll('.club-lbl').remove();
        })
        .on('click', () => setSelectedClubId(c.id));
    });

    // 이름 기반으로 구단 → 투영 좌표 조회 (API 데이터 사용)
    const clubProjMap = new Map(allClubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return [c.id, p ? { x: p[0], y: p[1], club: c } : null] as const;
    }));

    function findClubProj(name: string) {
      if (!name || name === 'Free Agent') return null;
      for (const entry of clubProjMap.values()) {
        if (entry && nameMatch(entry.club.name, name)) return entry;
      }
      return null;
    }

    const sortedNews = [...newsProp].sort((a, b) => parseFee(b.fee) - parseFee(a.fee));

    const computed = sortedNews.map((n, rank) => {
      const fp = findClubProj(n.from);
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
        from: n.from,
        to: n.to,
        animDur: n.status === 'confirmed' ? 2.2 : n.status === 'rumour' ? 3.5 : 5,
        animate: rank < ANIM_LIMIT && n.status !== 'denied',
      } as RouteInfo;
    }).filter((r): r is RouteInfo => r !== null);

    setRoutePaths(computed);
  }, [league, leagueClubs, leagueClubIds, allClubs, newsProp]);

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
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col overflow-hidden">
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
      </div>

      {/* Body */}
      <div className="flex-1 flex overflow-hidden">
        {/* Map */}
        <div ref={sceneRef} className="flex-1 relative overflow-hidden">
          <svg ref={mapRef} className="absolute inset-0" />

          {/* Transfer routes layer — React-managed */}
          <svg className="absolute inset-0" style={{ zIndex: 15, overflow: 'visible', pointerEvents: 'none' }}>
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

            {routePaths.map(r => {
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

                  {/* Outer glow — cross-league only */}
                  {!r.sameLeague && (
                    <path d={r.d} fill="none"
                      stroke={color} strokeWidth={10} strokeOpacity={0.1} />
                  )}

                  {/* Main arc */}
                  <path d={r.d} fill="none"
                    stroke={color}
                    strokeWidth={strokeW}
                    strokeOpacity={opacity}
                    strokeDasharray={dashes}
                    markerEnd={`url(#ca-arrow-${r.status})`}
                    style={{ cursor: 'pointer' }}
                  />

                  {/* Transparent wider hit area */}
                  <path d={r.d} fill="none" stroke="transparent" strokeWidth={16}
                    style={{ cursor: 'pointer' }} />

                  {/* Animated travelling dot — 이적료 상위 ANIM_LIMIT개만 */}
                  {r.animate && (
                    <circle
                      r={r.sameLeague ? 3.5 : 5}
                      fill={color}
                      style={{ filter: `drop-shadow(0 0 ${r.sameLeague ? 4 : 8}px ${color})` }}>
                      <animateMotion
                        dur={`${r.animDur}s`}
                        repeatCount="indefinite"
                        {...({ path: r.d } as any)}
                      />
                    </circle>
                  )}

                  {/* Trailing glow for confirmed */}
                  {r.animate && r.status === 'confirmed' && (
                    <circle r={r.sameLeague ? 6 : 10} fill={color} fillOpacity={0.15}
                      filter="url(#ca-dot-blur)">
                      <animateMotion
                        dur={`${r.animDur}s`}
                        repeatCount="indefinite"
                        begin="0.15s"
                        {...({ path: r.d } as any)}
                      />
                    </circle>
                  )}
                </g>
              );
            })}
          </svg>

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

        {/* Sidebar */}
        <div className="w-[420px] flex-shrink-0 border-l border-[var(--border)] flex flex-col">
          <div className="px-6 py-6 border-b border-[var(--border)] flex-shrink-0">
            <div className="text-[0.67rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-4">Clubs</div>
            <div className="flex flex-wrap gap-2.5">
              {leagueClubs.map(c => (
                <div key={c.id}
                  onClick={() => setSelectedClubId(c.id)}
                  className="flex items-center gap-2 px-3.5 py-2 bg-[var(--surface2)] border border-[var(--border)]
                             rounded-full text-[0.74rem] font-semibold text-[var(--text-sub)] cursor-pointer
                             hover:text-[var(--text)] hover:border-blue-500/40 transition-all">
                  <span className="w-2 h-2 rounded-full flex-shrink-0" style={{ background: c.color }} />
                  {c.name}
                </div>
              ))}
            </div>
          </div>
          <div className="flex-1 overflow-y-auto py-5">
            {feedItems.map((n, i) => <NewsCard key={i} item={n} />)}
          </div>
        </div>
      </div>

      <SidePanel
        open={selectedClubId !== null}
        onClose={() => setSelectedClubId(null)}
        selectedClubId={selectedClubId}
      />
    </div>
  );
}
