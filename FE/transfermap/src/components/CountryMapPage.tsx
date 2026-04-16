import { useEffect, useRef, useCallback, useState } from 'react';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import type { Topology, GeometryCollection } from 'topojson-specification';
import type { GeoPermissibleObjects } from 'd3-geo';
import type { League, Club } from '../types';
import { CLUBS, NEWS } from '../data/mock';
import NewsCard from './NewsCard';
import SidePanel from './SidePanel';
import { resolveOverlaps } from '../utils/mapUtils';

const EUROPEAN_IDS = new Set([
  8,20,40,56,70,100,112,191,196,203,208,233,246,250,276,300,348,352,372,380,
  428,438,440,442,470,492,498,499,528,578,616,620,642,674,688,703,705,724,
  752,756,804,807,826,
]);

interface Props {
  league: League;
  onBack: () => void;
  backLabel?: string;
  clubs?: Club[];
}

export default function CountryMapPage({ league, onBack, backLabel = '← Map', clubs: clubsProp }: Props) {
  const sceneRef  = useRef<HTMLDivElement>(null);
  const mapRef    = useRef<SVGSVGElement>(null);
  const routeRef  = useRef<SVGSVGElement>(null);
  const worldRef  = useRef<Topology<{ countries: GeometryCollection }> | null>(null);

  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);

  const allClubs        = clubsProp ?? CLUBS;
  const leagueClubs     = allClubs.filter(c => c.league === league.id);
  const leagueClubNames = leagueClubs.map(c => c.name.split(' ')[0]);
  const countryNews     = NEWS.filter(n =>
    leagueClubNames.some(name => n.from.includes(name) || n.to.includes(name))
  );
  const feedItems = countryNews.length ? countryNews : NEWS.slice(0, 3);

  const draw = useCallback((cW: number, cH: number) => {
    const world = worldRef.current;
    if (!world || !mapRef.current || !routeRef.current) return;

    const mapSvg   = d3.select(mapRef.current);
    const routeSvg = d3.select(routeRef.current);

    mapSvg.attr('width', cW).attr('height', cH);
    routeSvg.attr('width', cW).attr('height', cH);
    mapSvg.selectAll('*').remove();
    routeSvg.selectAll('*').remove();

    // Background glow
    const mdefs = mapSvg.append('defs');
    const rg = mdefs.append('radialGradient')
      .attr('id', 'cMapGlow').attr('cx', '50%').attr('cy', '50%').attr('r', '50%');
    rg.append('stop').attr('offset',  '0%').attr('stop-color', league.accent).attr('stop-opacity', 0.06);
    rg.append('stop').attr('offset', '100%').attr('stop-color', '#000').attr('stop-opacity', 0);
    mapSvg.append('rect').attr('width', cW).attr('height', cH).attr('fill', 'url(#cMapGlow)');

    // Arrow marker
    routeSvg.append('defs').append('marker')
      .attr('id', 'carrow').attr('markerWidth', 6).attr('markerHeight', 4)
      .attr('refX', 6).attr('refY', 2).attr('orient', 'auto')
      .append('polygon').attr('points', '0 0, 6 2, 0 4').attr('fill', league.accent + 'bb');

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
      const [x, y] = proj([c.lon, c.lat]);
      return { id: c.id, x, y };
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

    // Intra-league routes
    NEWS.forEach(n => {
      const fc = leagueClubs.find(c => n.from.includes(c.name.split(' ')[0]) || c.name.includes(n.from));
      const tc = leagueClubs.find(c => n.to.includes(c.name.split(' ')[0]) || c.name.includes(n.to));
      if (!fc || !tc) return;
      const [x1, y1] = proj([fc.lon, fc.lat]);
      const [x2, y2] = proj([tc.lon, tc.lat]);
      const mx = (x1 + x2) / 2 + (y2 - y1) * 0.3;
      const my = (y1 + y2) / 2 - Math.abs(x2 - x1) * 0.3;
      routeSvg.append('path')
        .attr('d', `M${x1},${y1} Q${mx},${my} ${x2},${y2}`)
        .attr('fill', 'none').attr('stroke', league.accent + '88')
        .attr('stroke-width', 1.5).attr('stroke-dasharray', '5 3')
        .attr('marker-end', 'url(#carrow)');
    });
  }, [league, leagueClubs]);

  // Load world data once, then draw
  useEffect(() => {
    fetch('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-50m.json')
      .then(r => r.json())
      .then((world: Topology<{ countries: GeometryCollection }>) => {
        worldRef.current = world;
        const el = sceneRef.current;
        if (el) draw(el.clientWidth, el.clientHeight);
      });
  }, [draw]);

  // ResizeObserver on the map scene only
  useEffect(() => {
    const el = sceneRef.current;
    if (!el) return;
    const ro = new ResizeObserver(entries => {
      const { width, height } = entries[0].contentRect;
      if (worldRef.current) draw(width, height);
    });
    ro.observe(el);
    return () => ro.disconnect();
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
          <svg ref={mapRef}   className="absolute inset-0" />
          <svg ref={routeRef} className="absolute inset-0 pointer-events-none" />
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
