import { useEffect, useRef, useState, useCallback } from 'react';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { Topology, GeometryCollection } from 'topojson-specification';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club } from '../types';
import { LEAGUES, CLUBS } from '../data/mock';
import { resolveOverlaps } from '../utils/mapUtils';

const EUROPEAN_IDS = new Set([
  8,20,40,56,70,100,112,191,196,203,208,233,246,250,276,300,348,352,372,380,
  428,438,440,442,470,492,498,499,528,578,616,620,642,674,688,703,705,724,
  752,756,804,807,826,
]);

const ROUTES = [
  { from: 'PSG',          to: 'Real Madrid' },
  { from: 'Bayern Munich',to: 'Man City'    },
  { from: 'Dortmund',     to: 'Arsenal'     },
];

interface OverlayPos { id: string | number; x: number; y: number; }

interface Props {
  onCountryClick: (league: League, centroid: [number, number]) => void;
  onClubClick: (clubId: number) => void;
  clubs?: Club[];
}

export default function WorldMap({ onCountryClick, onClubClick, clubs: clubsProp }: Props) {
  const clubs = clubsProp ?? CLUBS;
  const containerRef = useRef<HTMLDivElement>(null);
  const svgRef       = useRef<SVGSVGElement>(null);
  const routeRef     = useRef<SVGSVGElement>(null);
  const worldRef     = useRef<Topology<{ countries: GeometryCollection }> | null>(null);
  const projRef      = useRef<d3.GeoProjection | null>(null);

  // Pixel positions for HTML overlays — updated on every draw
  const [badgePos, setBadgePos] = useState<OverlayPos[]>([]);
  const [clubPos,  setClubPos]  = useState<OverlayPos[]>([]);

  const draw = useCallback((W: number, H: number) => {
    const world = worldRef.current;
    if (!world || !svgRef.current || !routeRef.current) return;

    const svg      = d3.select(svgRef.current);
    const routeSvg = d3.select(routeRef.current);

    svg.attr('width', W).attr('height', H);
    routeSvg.attr('width', W).attr('height', H);
    svg.selectAll('*').remove();
    routeSvg.selectAll('*').remove();

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

    // Arrow marker
    routeSvg.append('defs').append('marker')
      .attr('id', 'arrow').attr('markerWidth', 6).attr('markerHeight', 4)
      .attr('refX', 6).attr('refY', 2).attr('orient', 'auto')
      .append('polygon').attr('points', '0 0, 6 2, 0 4').attr('fill', 'rgba(59,130,246,0.7)');

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

    // Country paths
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

    // Transfer routes
    ROUTES.forEach(r => {
      const fc = clubs.find(c => c.name === r.from || r.from.startsWith(c.name.split(' ')[0]));
      const tc = clubs.find(c => c.name === r.to   || r.to.startsWith(c.name.split(' ')[0]));
      if (!fc || !tc) return;
      const p1 = proj([fc.lon, fc.lat]);
      const p2 = proj([tc.lon, tc.lat]);
      if (!p1 || !p2) return;
      const [x1, y1] = p1;
      const [x2, y2] = p2;
      const mx = (x1 + x2) / 2 + (y2 - y1) * 0.25;
      const my = (y1 + y2) / 2 - Math.abs(x2 - x1) * 0.2;
      routeSvg.append('path')
        .attr('d', `M${x1},${y1} Q${mx},${my} ${x2},${y2}`)
        .attr('fill', 'none').attr('stroke', 'rgba(59,130,246,0.5)')
        .attr('stroke-width', 1.5).attr('stroke-dasharray', '6 4')
        .attr('marker-end', 'url(#arrow)');
    });

    // Update HTML overlay positions via state
    setBadgePos(LEAGUES.map(l => {
      const p = proj([l.lon, l.lat]);
      return { id: l.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    }));
    setClubPos(resolveOverlaps(clubs.map(c => {
      const p = proj([c.lon, c.lat]);
      return { id: c.id, x: p?.[0] ?? 0, y: p?.[1] ?? 0 };
    })));
  }, [onCountryClick, clubs]);

  // Load world data once, then draw
  useEffect(() => {
    fetch('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-50m.json')
      .then(r => r.json())
      .then((world: Topology<{ countries: GeometryCollection }>) => {
        worldRef.current = world;
        const el = containerRef.current;
        if (el) draw(el.clientWidth, el.clientHeight);
      });
  }, [draw]);

  // ResizeObserver — redraws whenever the container size changes
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const ro = new ResizeObserver(entries => {
      const { width, height } = entries[0].contentRect;
      if (worldRef.current) draw(width, height);
    });
    ro.observe(el);
    return () => ro.disconnect();
  }, [draw]);

  const badgeMap = Object.fromEntries(badgePos.map(p => [p.id, p]));
  const clubMap  = Object.fromEntries(clubPos.map(p  => [p.id, p]));

  return (
    <div ref={containerRef} className="absolute inset-0" style={{ willChange: 'transform, opacity' }}>
      <svg ref={svgRef}   className="absolute inset-0" />
      <svg ref={routeRef} className="absolute inset-0 pointer-events-none" style={{ zIndex: 15 }} />

      {/* League badges */}
      {LEAGUES.map(l => {
        const pos = badgeMap[l.id];
        if (!pos) return null;
        return (
          <div key={l.id}
            className="absolute flex flex-col items-center gap-1.5 cursor-pointer z-20
                       -translate-x-1/2 -translate-y-1/2 transition-[transform,filter] duration-200
                       hover:scale-[1.15] hover:brightness-125"
            style={{ left: pos.x, top: pos.y }}>
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
