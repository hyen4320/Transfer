import { useEffect, useRef, useState, useCallback } from 'react';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club, NewsItem, TransferStatus } from '../types';
import { LEAGUES, CLUBS } from '../data/mock';
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

const ANIM_LIMIT = 20; // 이적료 상위 N개만 도트 애니메이션

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
  animate: boolean; // 애니메이션 도트 여부
}

interface OverlayPos { id: string | number; x: number; y: number; }

function nameMatch(a: string, b: string): boolean {
  if (!a || !b) return false;
  a = a.toLowerCase().trim();
  b = b.toLowerCase().trim();
  return a === b || a.includes(b) || b.includes(a);
}

interface Props {
  onCountryClick: (league: League, centroid: [number, number]) => void;
  onClubClick: (clubId: number) => void;
  onLeagueClick?: (league: League) => void;
  clubs?: Club[];
  news?: NewsItem[];
  selectedNewsId?: number | null;
}

export default function WorldMap({ onCountryClick, onClubClick, onLeagueClick, clubs: clubsProp, news: newsProp = [], selectedNewsId }: Props) {
  const clubs = clubsProp ?? CLUBS;
  const containerRef = useRef<HTMLDivElement>(null);
  const svgRef       = useRef<SVGSVGElement>(null);
  const projRef      = useRef<d3.GeoProjection | null>(null);

  const [badgePos,      setBadgePos]      = useState<OverlayPos[]>([]);
  const [clubPos,       setClubPos]       = useState<OverlayPos[]>([]);
  const [routePaths,    setRoutePaths]    = useState<RouteInfo[]>([]);
  const [hoveredRoute,  setHoveredRoute]  = useState<RouteInfo | null>(null);
  const [tooltipPos,    setTooltipPos]    = useState({ x: 0, y: 0 });

  const worldRef = useRef<Awaited<ReturnType<typeof loadWorldAtlas>> | null>(null);

  const draw = useCallback((W: number, H: number) => {
    const world = worldRef.current;
    if (!world || !svgRef.current) return;

    const svg = d3.select(svgRef.current);
    svg.attr('width', W).attr('height', H);
    svg.selectAll('*').remove();

    // Background glow
    const defs = svg.append('defs');
    const rg = defs.append('radialGradient')
      .attr('id', 'centerGlow').attr('cx', '50%').attr('cy', '50%').attr('r', '50%');
    rg.append('stop').attr('offset',  '0%').attr('stop-color', '#1040aa').attr('stop-opacity', 0.18);
    rg.append('stop').attr('offset', '100%').attr('stop-color', '#000').attr('stop-opacity', 0);
    svg.append('ellipse')
      .attr('cx', W / 2).attr('cy', H / 2)
      .attr('rx', W * 0.38).attr('ry', H * 0.38)
      .attr('fill', 'url(#centerGlow)');

    const proj = d3.geoMercator()
      .center([15, 54])
      .scale(Math.min(W, H) * 1.1)
      .translate([W / 2, H / 2]);
    const pg = d3.geoPath().projection(proj);
    projRef.current = proj;

    const all     = topojson.feature(world, world.objects.countries);
    const borders = topojson.mesh(world, world.objects.countries,
      (a, b) => a !== b
        && EUROPEAN_IDS.has(+(a as any).id)
        && EUROPEAN_IDS.has(+(b as any).id));
    const europeFeatures = all.features.filter(f => EUROPEAN_IDS.has(+(f.id ?? 0)));

    svg.selectAll<SVGPathElement, typeof europeFeatures[0]>('.country')
      .data(europeFeatures).join('path')
      .attr('class', d => 'country' + (LEAGUES.some(l => l.numericId === +(d.id ?? 0)) ? ' league-country' : ''))
      .attr('d', pg)
      .attr('fill', '#0c1e36')
      .attr('stroke', '#1a4a8a')
      .attr('stroke-width', 0.8)
      .style('transition', 'fill 0.2s, filter 0.2s')
      .style('cursor', d => LEAGUES.some(l => l.numericId === +(d.id ?? 0)) ? 'pointer' : 'default')
      .on('mouseover', function(_, d) {
        const isLeague = LEAGUES.some(l => l.numericId === +(d.id ?? 0));
        d3.select(this).attr('fill', isLeague ? '#1d3d7a' : '#1a3560');
        if (isLeague) d3.select(this).style('filter', 'drop-shadow(0 0 10px rgba(80,140,255,0.5))');
      })
      .on('mouseout', function() {
        d3.select(this).attr('fill', '#0c1e36').style('filter', 'none');
      })
      .on('click', function(_, d) {
        const league = LEAGUES.find(l => l.numericId === +(d.id ?? 0));
        if (!league) return;
        onCountryClick(league, pg.centroid(d) as [number, number]);
      });

    svg.append('path').datum(borders as GeoPermissibleObjects)
      .attr('fill', 'none').attr('stroke', '#0e2d5c').attr('stroke-width', 0.5)
      .attr('d', pg);

    // 1. resolveOverlaps 먼저 계산 → 마커와 루트 끝점을 같은 좌표로 공유
    const rawClubPos = clubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return { id: c.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    });
    const resolvedClubPos = resolveOverlaps(rawClubPos);

    setBadgePos(LEAGUES.map(l => {
      const p = proj([l.lon, l.lat]);
      return { id: l.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    }));
    setClubPos(resolvedClubPos);

    // 2. 이름 기반으로 구단 → 투영 좌표 조회 (API 데이터 사용)
    const clubProjMap = new Map(clubs.map(c => {
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

    // 이적료 내림차순 정렬 → 상위 ANIM_LIMIT개만 도트 애니메이션
    const sortedNews = [...newsProp].sort((a, b) => parseFee(b.fee) - parseFee(a.fee));

    const computed = sortedNews.map((n, rank) => {
      const fp = findClubProj(n.from);
      const tp = findClubProj(n.to);
      if (!fp || !tp) return null;
      const fc = fp.club;
      const tc = tp.club;
      const [x1, y1] = [fp.x, fp.y];
      const [x2, y2] = [tp.x, tp.y];
      const sameLeague = fc.league === tc.league && fc.league !== '';
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
  }, [onCountryClick, clubs, newsProp]);

  useEffect(() => {
    loadWorldAtlas().then(world => {
      worldRef.current = world;
      const el = containerRef.current;
      if (el) draw(el.clientWidth, el.clientHeight);
    });
  }, [draw]);

  useEffect(() => {
    const el = containerRef.current;
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

  const badgeMap = Object.fromEntries(badgePos.map(p => [p.id, p]));
  const clubMap  = Object.fromEntries(clubPos.map(p  => [p.id, p]));

  return (
    <div ref={containerRef} className="absolute inset-0" style={{ willChange: 'transform, opacity' }}>
      <svg ref={svgRef} className="absolute inset-0" />

      {/* Transfer routes layer */}
      <svg
        className="absolute inset-0"
        style={{ zIndex: 15, overflow: 'visible', pointerEvents: 'none' }}
      >
        <defs>
          <filter id="dot-blur" x="-50%" y="-50%" width="200%" height="200%">
            <feGaussianBlur stdDeviation="2" />
          </filter>
          {(Object.entries(STATUS_COLOR) as [TransferStatus, string][]).map(([status, color]) => (
            <marker key={status}
              id={`arrow-${status}`}
              markerWidth="7" markerHeight="5"
              refX="6" refY="2.5" orient="auto">
              <polygon points="0 0, 7 2.5, 0 5" fill={color} fillOpacity="0.85" />
            </marker>
          ))}
        </defs>

        {routePaths.map(r => {
          const isSelected = selectedNewsId != null && r.id === selectedNewsId;
          const isDimmed   = selectedNewsId != null && r.id !== selectedNewsId;
          const color   = STATUS_COLOR[r.status];
          const opacity = isDimmed ? 0.06
                        : r.status === 'denied' ? 0.25
                        : r.sameLeague ? 0.55 : 0.75;
          const strokeW = isSelected ? 3.5 : r.sameLeague ? 1.5 : 2.2;
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
                  stroke={color} strokeWidth={8} strokeOpacity={0.1} />
              )}

              {/* Main arc */}
              <path d={r.d} fill="none"
                stroke={color}
                strokeWidth={strokeW}
                strokeOpacity={opacity}
                strokeDasharray={dashes}
                markerEnd={`url(#arrow-${r.status})`}
                style={{ cursor: 'pointer' }}
              />

              {/* Transparent wider hit area */}
              <path d={r.d} fill="none" stroke="transparent" strokeWidth={16}
                style={{ cursor: 'pointer' }} />

              {/* Animated travelling dot — 이적료 상위 ANIM_LIMIT개만 */}
              {r.animate && (
                <circle
                  r={r.sameLeague ? 3 : 4.5}
                  fill={color}
                  style={{ filter: `drop-shadow(0 0 ${r.sameLeague ? 4 : 7}px ${color})` }}>
                  <animateMotion
                    dur={`${r.animDur}s`}
                    repeatCount="indefinite"
                    {...({ path: r.d } as any)}
                  />
                </circle>
              )}

              {/* Trailing glow dot */}
              {r.animate && r.status === 'confirmed' && (
                <circle r={r.sameLeague ? 5 : 8} fill={color} fillOpacity={0.18}
                  filter="url(#dot-blur)">
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

      {/* Tooltip */}
      {hoveredRoute && (
        <div className="fixed z-50 pointer-events-none select-none
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

      {/* League badges */}
      {LEAGUES.map(l => {
        const pos = badgeMap[l.id];
        if (!pos) return null;
        return (
          <div key={l.id}
            className="absolute flex flex-col items-center gap-1.5 cursor-pointer z-20
                       -translate-x-1/2 -translate-y-1/2 transition-[transform,filter] duration-200
                       hover:scale-[1.15] hover:brightness-125"
            style={{ left: pos.x, top: pos.y }}
            onClick={e => { e.stopPropagation(); onLeagueClick?.(l); }}>
            <div className="w-[52px] h-[52px] rounded-full flex items-center justify-center
                            text-[0.95rem] font-black overflow-hidden"
              style={{
                background:  l.color,
                boxShadow:  `0 0 20px ${l.accent}55, 0 0 6px rgba(0,0,0,0.8)`,
                border:     `2px solid ${l.accent}88`,
                color:       l.accent,
                textShadow: `0 0 8px ${l.accent}`,
              }}>
              {l.abbr}
            </div>
            <div className="text-[0.6rem] font-bold tracking-wide uppercase whitespace-nowrap"
              style={{ color: 'rgba(220,230,255,0.85)', textShadow: '0 1px 4px rgba(0,0,0,0.9)' }}>
              {l.name}
            </div>
          </div>
        );
      })}

      {/* Club markers */}
      {clubs.map(c => {
        const pos = clubMap[c.id];
        if (!pos) return null;
        return (
          <div key={c.id}
            className="absolute w-2.5 h-2.5 rounded-full z-[18] cursor-pointer border-[1.5px] border-white/30
                       -translate-x-1/2 -translate-y-1/2 transition-[transform,box-shadow] duration-200 group
                       hover:scale-[1.6] hover:z-[25]"
            style={{ left: pos.x, top: pos.y, background: c.color, boxShadow: `0 0 8px ${c.color}88` }}
            onClick={() => onClubClick(c.id)}>
            <div className="absolute bottom-3.5 left-1/2 -translate-x-1/2 z-10
                            bg-[rgba(6,10,18,0.92)] border border-[var(--border)] rounded px-2 py-0.5
                            text-[0.65rem] font-semibold whitespace-nowrap text-[var(--text)] pointer-events-none
                            opacity-0 group-hover:opacity-100 transition-opacity duration-150">
              {c.name}
            </div>
          </div>
        );
      })}
    </div>
  );
}
