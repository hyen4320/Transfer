import { useEffect, useRef, useState, useCallback } from 'react';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club, NewsItem, TransferStatus } from '../types';
import { LEAGUES, CLUBS } from '../data/mock';
import { resolveOverlaps, parseFee } from '../utils/mapUtils';
import { loadWorldAtlas } from '../utils/worldAtlas';

const COUNTRY_CENTROIDS: Record<string, [number, number]> = {
  'GB': [-3.44,  55.38],
  'DE': [10.45,  51.17],
  'ES': [-3.75,  40.46],
  'IT': [12.57,  41.87],
  'FR': [ 2.21,  46.23],
  'PT': [-8.22,  39.40],
  'NL': [ 5.29,  52.13],
  'BE': [ 4.47,  50.50],
  'TR': [35.24,  38.96],
  'SA': [45.08,  23.89],
  'BR': [-51.93, -14.24],
  'AR': [-63.62, -38.42],
  'JP': [138.25,  36.20],
  'US': [-95.71,  37.09],
  'CN': [104.19,  35.86],
  'MA': [ -7.09,  31.79],
  'NG': [  8.68,   9.08],
  'SN': [-14.45,  14.50],
  'CI': [ -5.55,   7.54],
  'GH': [ -1.02,   7.95],
};

const EUROPEAN_IDS = new Set([
  8,20,40,56,70,100,112,191,196,203,208,233,246,250,276,300,348,352,372,380,
  428,438,440,442,470,492,498,499,528,578,616,620,642,674,688,703,705,724,
  752,756,792,804,807,826,
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

interface DragState {
  league: import('../types').League;
  centroid: [number, number];
  startX: number;
  startY: number;
  ringX: number;
  ringY: number;
  progress: number; // 0–1
}

function normStr(s: string): string {
  // NFD 분해 후 결합 발음구별 기호 제거 (Atlético → Atletico, München → Munchen 등)
  return s.normalize('NFD').replace(/\p{Mn}/gu, '').toLowerCase().trim();
}

function nameMatch(a: string, b: string): boolean {
  if (!a || !b) return false;
  const na = normStr(a), nb = normStr(b);
  return na === nb || na.includes(nb) || nb.includes(na);
}

function makeProjection(W: number, H: number) {
  return d3.geoMercator()
    .center([15, 53])
    .scale(Math.min(W, H) * 1.1)
    .translate([W / 2, H * 0.45]);
}

const TOP5_COUNTRY_CODES = new Set(['GB', 'DE', 'ES', 'IT', 'FR']);

function computeMapPositions(
  W: number, H: number,
  clubs: Club[],
  newsProp: NewsItem[],
) {
  const proj = makeProjection(W, H);

  const rawClubPos = clubs.map(c => {
    const p = proj([c.lon, c.lat]);
    return { id: c.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
  });
  const resolvedClubPos = resolveOverlaps(rawClubPos);

  const badgePos = LEAGUES.map(l => {
    const p = proj([l.lon, l.lat]);
    return { id: l.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
  });

  const clubById = new Map(clubs.map(c => [c.id, c]));
  const clubProjMap = new Map(
    resolvedClubPos.map(rp => {
      const club = clubById.get(rp.id);
      return [rp.id, club ? { x: rp.x, y: rp.y, club } : null] as const;
    })
  );

  function findClubProj(name: string) {
    if (!name || name === 'Free Agent') return null;
    for (const entry of clubProjMap.values()) {
      if (entry && nameMatch(entry.club.name, name)) return entry;
    }
    return null;
  }

  function countryProj(countryCode: string | undefined): { x: number; y: number; club: null } | null {
    if (!countryCode) return null;
    const coords = COUNTRY_CENTROIDS[countryCode];
    if (!coords) return null;
    const p = proj(coords);
    if (!p) return null;
    return { x: p[0], y: p[1], club: null };
  }

  function resolveEndpoint(name: string, countryCode: string | undefined) {
    const byName = findClubProj(name);
    if (byName) return byName;
    if (!countryCode || TOP5_COUNTRY_CODES.has(countryCode)) return null;
    return countryProj(countryCode);
  }

  const sortedNews = [...newsProp].sort((a, b) => parseFee(b.fee) - parseFee(a.fee));

  const routePaths = sortedNews.map((n, rank) => {
    const fp = resolveEndpoint(n.from, n.fromCountryCode);
    const tp = resolveEndpoint(n.to,   n.toCountryCode);
    if (!fp || !tp) return null;
    const [x1, y1] = [fp.x, fp.y];
    const [x2, y2] = [tp.x, tp.y];
    const sameLeague = fp.club && tp.club
      ? fp.club.league === tp.club.league && fp.club.league !== ''
      : false;
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

  return { badgePos, clubPos: resolvedClubPos, routePaths, proj };
}

interface Props {
  onCountryClick: (league: League, centroid: [number, number]) => void;
  onClubClick: (clubId: number) => void;
  onLeagueClick?: (league: League) => void;
  onRouteHover?: (id: number | null) => void;
  clubs?: Club[];
  news?: NewsItem[];
  selectedNewsId?: number | null;
}

export default function WorldMap({ onCountryClick, onClubClick, onLeagueClick, onRouteHover, clubs: clubsProp, news: newsProp = [], selectedNewsId }: Props) {
  const clubs = clubsProp ?? CLUBS;
  const containerRef = useRef<HTMLDivElement>(null);
  const svgRef       = useRef<SVGSVGElement>(null);
  const projRef      = useRef<d3.GeoProjection | null>(null);

  const [mapData, setMapData] = useState<{
    badgePos:   OverlayPos[];
    clubPos:    OverlayPos[];
    routePaths: RouteInfo[];
  }>({ badgePos: [], clubPos: [], routePaths: [] });
  const [hoveredRoute,  setHoveredRoute]  = useState<RouteInfo | null>(null);
  const tooltipRef = useRef<HTMLDivElement>(null);
  const [dragState,     setDragState]     = useState<DragState | null>(null);

  const dragRef   = useRef<DragState | null>(null);
  const holdTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const mapTransformRef = useRef({ x: 0, y: 0, scale: 1 });
  const [mapTransform,  setMapTransform]  = useState({ x: 0, y: 0, scale: 1 });
  const lastTapRef      = useRef(0);

  const worldRef = useRef<Awaited<ReturnType<typeof loadWorldAtlas>> | null>(null);

  const [containerDims, setContainerDims] = useState<{ W: number; H: number } | null>(null);
  const firstResizeRef = useRef(true);

  // Route/position computation — runs as soon as news + container size are ready, no atlas needed
  useEffect(() => {
    if (!containerDims) return;
    const { badgePos, clubPos, routePaths, proj } = computeMapPositions(containerDims.W, containerDims.H, clubs, newsProp);
    projRef.current = proj;
    setMapData({ badgePos, clubPos, routePaths });
  }, [clubs, newsProp, containerDims]);

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

    const proj = makeProjection(W, H);
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
      .on('click', function(_event, d) {
        // 드래그 후에는 click 무시
        if (dragRef.current?.progress && dragRef.current.progress > 0.1) return;
        const league = LEAGUES.find(l => l.numericId === +(d.id ?? 0));
        if (!league) return;
        onCountryClick(league, pg.centroid(d) as [number, number]);
      })
      .on('pointerdown', function(event, d) {
        const league = LEAGUES.find(l => l.numericId === +(d.id ?? 0));
        if (!league) return;
        event.stopPropagation();

        const centroid = pg.centroid(d) as [number, number];
        const rect  = containerRef.current?.getBoundingClientRect();
        const ringX = (rect ? event.clientX - rect.left : event.clientX);
        const ringY = (rect ? event.clientY - rect.top  : event.clientY);

        const state: DragState = {
          league, centroid,
          startX: event.clientX, startY: event.clientY,
          ringX, ringY, progress: 0,
        };
        dragRef.current = state;
        setDragState({ ...state });

        // 500ms 롱프레스로 진입
        holdTimer.current = setTimeout(() => {
          if (!dragRef.current) return;
          dragRef.current = null;
          setDragState(null);
          onCountryClick(league, centroid);
        }, 500);
      });

    svg.append('path').datum(borders as GeoPermissibleObjects)
      .attr('fill', 'none').attr('stroke', '#0e2d5c').attr('stroke-width', 0.5)
      .attr('d', pg);
  }, [onCountryClick]);

  // 드래그-투-엔터: 전역 pointermove/up 추적
  useEffect(() => {
    const THRESHOLD = 0.4; // 화면 짧은 축 대비 비율

    const onMove = (e: PointerEvent) => {
      const state = dragRef.current;
      if (!state) return;

      const dx   = e.clientX - state.startX;
      const dy   = e.clientY - state.startY;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const axis = Math.min(window.innerWidth, window.innerHeight);
      const prog = Math.min(dist / (axis * THRESHOLD), 1);

      const rect  = containerRef.current?.getBoundingClientRect();
      const ringX = rect ? e.clientX - rect.left : e.clientX;
      const ringY = rect ? e.clientY - rect.top  : e.clientY;

      const next: DragState = { ...state, progress: prog, ringX, ringY };
      dragRef.current = next;
      setDragState({ ...next });

      if (prog >= 1) {
        if (holdTimer.current) clearTimeout(holdTimer.current);
        dragRef.current = null;
        setDragState(null);
        onCountryClick(state.league, state.centroid);
      }
    };

    const onUp = () => {
      if (holdTimer.current) clearTimeout(holdTimer.current);
      if (dragRef.current) {
        dragRef.current = null;
        setDragState(null);
      }
    };

    window.addEventListener('pointermove', onMove);
    window.addEventListener('pointerup',   onUp);
    window.addEventListener('pointercancel', onUp);
    return () => {
      window.removeEventListener('pointermove', onMove);
      window.removeEventListener('pointerup',   onUp);
      window.removeEventListener('pointercancel', onUp);
    };
  }, [onCountryClick]);

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
      if (firstResizeRef.current) {
        firstResizeRef.current = false;
        setContainerDims({ W: width, H: height });
        if (worldRef.current) draw(width, height);
        return;
      }
      clearTimeout(timer);
      timer = setTimeout(() => {
        setContainerDims({ W: width, H: height });
        if (worldRef.current) draw(width, height);
      }, 80);
    });
    ro.observe(el);
    return () => { ro.disconnect(); clearTimeout(timer); };
  }, [draw]);

  // Touch gesture: pinch-zoom + pan
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    let mode: 'none' | 'pan' | 'pinch' = 'none';
    let panLastX = 0, panLastY = 0;
    let pinchStartDist = 0, pinchStartScale = 1;
    let pinchStartMidX = 0, pinchStartMidY = 0;
    let pinchStartTx = 0, pinchStartTy = 0;

    const clampXY = (x: number, y: number, scale: number) => {
      const maxX = (scale - 1) * el.clientWidth  / 2;
      const maxY = (scale - 1) * el.clientHeight / 2;
      return { x: Math.max(-maxX, Math.min(maxX, x)), y: Math.max(-maxY, Math.min(maxY, y)) };
    };

    const commit = (next: { x: number; y: number; scale: number }) => {
      mapTransformRef.current = next;
      setMapTransform({ ...next });
    };

    const onTouchStart = (e: TouchEvent) => {
      if (e.touches.length === 1) {
        const now = Date.now();
        if (now - lastTapRef.current < 300) {
          lastTapRef.current = 0;
          const cur = mapTransformRef.current;
          commit(cur.scale > 1.1 ? { x: 0, y: 0, scale: 1 } : { x: 0, y: 0, scale: 2.5 });
          return;
        }
        lastTapRef.current = now;
        mode = 'pan';
        panLastX = e.touches[0].clientX;
        panLastY = e.touches[0].clientY;
      } else if (e.touches.length === 2) {
        if (holdTimer.current) clearTimeout(holdTimer.current);
        dragRef.current = null;
        setDragState(null);
        const cur = mapTransformRef.current;
        const t0 = e.touches[0], t1 = e.touches[1];
        mode = 'pinch';
        pinchStartDist  = Math.hypot(t1.clientX - t0.clientX, t1.clientY - t0.clientY);
        pinchStartScale = cur.scale;
        pinchStartMidX  = (t0.clientX + t1.clientX) / 2;
        pinchStartMidY  = (t0.clientY + t1.clientY) / 2;
        pinchStartTx    = cur.x;
        pinchStartTy    = cur.y;
      }
    };

    const onTouchMove = (e: TouchEvent) => {
      e.preventDefault();
      const cur = mapTransformRef.current;

      if (mode === 'pan' && e.touches.length === 1) {
        if (cur.scale > 1.05) {
          if (holdTimer.current) clearTimeout(holdTimer.current);
          dragRef.current = null;
          setDragState(null);
        }
        const dx = e.touches[0].clientX - panLastX;
        const dy = e.touches[0].clientY - panLastY;
        panLastX = e.touches[0].clientX;
        panLastY = e.touches[0].clientY;
        commit({ scale: cur.scale, ...clampXY(cur.x + dx, cur.y + dy, cur.scale) });

      } else if (mode === 'pinch' && e.touches.length === 2) {
        const t0 = e.touches[0], t1 = e.touches[1];
        const dist     = Math.hypot(t1.clientX - t0.clientX, t1.clientY - t0.clientY);
        const newScale = Math.max(1, Math.min(5, pinchStartScale * dist / pinchStartDist));
        const midX     = (t0.clientX + t1.clientX) / 2;
        const midY     = (t0.clientY + t1.clientY) / 2;
        const rect     = el.getBoundingClientRect();
        // Anchor zoom at pinch midpoint (in container-center coordinates)
        const fx = pinchStartMidX - rect.left - el.clientWidth  / 2;
        const fy = pinchStartMidY - rect.top  - el.clientHeight / 2;
        const newX = pinchStartTx + fx * (1 - newScale / pinchStartScale) + (midX - pinchStartMidX);
        const newY = pinchStartTy + fy * (1 - newScale / pinchStartScale) + (midY - pinchStartMidY);
        commit({ scale: newScale, ...clampXY(newX, newY, newScale) });
      }
    };

    const onTouchEnd = (e: TouchEvent) => {
      if      (e.touches.length === 0) { mode = 'none'; }
      else if (e.touches.length === 1) {
        mode = 'pan';
        panLastX = e.touches[0].clientX;
        panLastY = e.touches[0].clientY;
      }
    };

    el.addEventListener('touchstart',  onTouchStart,  { passive: false });
    el.addEventListener('touchmove',   onTouchMove,   { passive: false });
    el.addEventListener('touchend',    onTouchEnd);
    el.addEventListener('touchcancel', onTouchEnd);
    return () => {
      el.removeEventListener('touchstart',  onTouchStart);
      el.removeEventListener('touchmove',   onTouchMove);
      el.removeEventListener('touchend',    onTouchEnd);
      el.removeEventListener('touchcancel', onTouchEnd);
    };
  }, []); // stable refs used inside (containerRef, holdTimer, dragRef, setDragState, lastTapRef)

  const { badgePos, clubPos, routePaths } = mapData;
  const badgeMap = Object.fromEntries(badgePos.map(p => [p.id, p]));
  const clubMap  = Object.fromEntries(clubPos.map(p  => [p.id, p]));

  return (
    <div ref={containerRef} className="absolute inset-0"
         style={{ willChange: 'transform, opacity', touchAction: 'none' }}>

      {/* Pinch-zoom / pan layer */}
      <div style={{
        position: 'absolute', inset: 0,
        transform: `translate(${mapTransform.x}px,${mapTransform.y}px) scale(${mapTransform.scale})`,
        transformOrigin: 'center',
      }}>
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
               onMouseEnter={() => { setHoveredRoute(r); onRouteHover?.(r.id); }}
               onMouseLeave={() => { setHoveredRoute(null); onRouteHover?.(null); }}
               onMouseMove={e => {
                 const el = tooltipRef.current;
                 if (el) { el.style.left = `${e.clientX + 14}px`; el.style.top = `${e.clientY - 50}px`; }
               }}>

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
              <div className="w-[26px] h-[26px] sm:w-[52px] sm:h-[52px] rounded-full flex items-center justify-center
                              text-[0.48rem] sm:text-[0.95rem] font-black overflow-hidden"
                style={{
                  background:  l.color,
                  boxShadow:  `0 0 10px ${l.accent}55, 0 0 4px rgba(0,0,0,0.8)`,
                  border:     `1.5px solid ${l.accent}88`,
                  color:       l.accent,
                  textShadow: `0 0 8px ${l.accent}`,
                }}>
                {l.abbr}
              </div>
              <div className="hidden sm:block text-[0.6rem] font-bold tracking-wide uppercase whitespace-nowrap"
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

      {/* Tooltip — DOM position updated directly via ref, no re-render on mousemove */}
      <div ref={tooltipRef}
           className="fixed z-50 pointer-events-none select-none
                      bg-[rgba(4,8,18,0.96)] border border-white/10
                      rounded-xl px-3.5 py-2.5 min-w-[170px] shadow-2xl"
           style={{ left: 0, top: 0, visibility: hoveredRoute ? 'visible' : 'hidden' }}>
        {hoveredRoute && (
          <>
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
          </>
        )}
      </div>

      {/* 드래그-투-엔터 진행 링 — absolute within container, unaffected by map transform */}
      {dragState && (
        <div className="absolute inset-0 pointer-events-none" style={{ zIndex: 60 }}>
          {/* 반투명 배경 */}
          <div className="absolute inset-0 transition-opacity duration-150"
               style={{ background: 'rgba(6,10,18,0.3)', opacity: dragState.progress }} />

          {/* 진행 링 + 국가명 */}
          <div className="absolute -translate-x-1/2 -translate-y-1/2"
               style={{ left: dragState.ringX, top: dragState.ringY }}>
            <svg width="88" height="88" style={{ overflow: 'visible' }}>
              {/* 트랙 */}
              <circle cx="44" cy="44" r="36" fill="none"
                stroke="rgba(255,255,255,0.15)" strokeWidth="3" />
              {/* 진행 호 */}
              <circle cx="44" cy="44" r="36" fill="none"
                stroke="var(--accent)" strokeWidth="3"
                strokeDasharray={`${dragState.progress * 226.2} 226.2`}
                strokeLinecap="round"
                transform="rotate(-90 44 44)" />
              {/* 중심 점 */}
              <circle cx="44" cy="44" r="5" fill="var(--accent)"
                style={{ filter: 'drop-shadow(0 0 6px var(--accent))' }} />
            </svg>
            {/* 국가 이름 */}
            <div className="absolute top-full left-1/2 -translate-x-1/2 mt-2 whitespace-nowrap
                            text-[0.75rem] font-black tracking-widest uppercase text-white
                            transition-opacity duration-100"
                 style={{ opacity: dragState.progress }}>
              {dragState.league.flag} {dragState.league.country}
            </div>
          </div>

          {/* 60% 이상에서 오른쪽 가장자리 ghost 힌트 */}
          {dragState.progress > 0.6 && (
            <div className="absolute top-0 right-0 w-1.5 h-full rounded-l"
                 style={{
                   background: 'linear-gradient(to left, rgba(59,130,246,0.4), transparent)',
                   opacity: (dragState.progress - 0.6) / 0.4,
                 }} />
          )}
        </div>
      )}
    </div>
  );
}
