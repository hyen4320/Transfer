import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet-async';
import {
  fetchLeagueSpending, fetchPositionTrend, fetchClubActivity,
  fetchTransferFlow, fetchTopDeals, fetchFreeAgent,
  type LeagueSpendingItem, type PositionTrendItem, type ClubActivityItem,
  type TransferFlowItem, type TopDealItem, type FreeAgentItem,
} from '../api/report';
import { fetchEditorialReports, type EditorialReportResponse, type Block } from '../api/editorialReport';
import { SEASON_OPTIONS } from '../data/constants';

const MONO = "'JetBrains Mono', 'Courier New', monospace";

// ── helpers ───────────────────────────────────────────────────────────────────

function fmt(eur: number): string {
  if (!eur) return '—';
  if (eur >= 1_000_000_000) return `€${(eur / 1_000_000_000).toFixed(1)}B`;
  if (eur >= 1_000_000)     return `€${(eur / 1_000_000).toFixed(0)}M`;
  return `€${(eur / 1_000).toFixed(0)}K`;
}

function flag(code: string): string {
  if (!code || code.length !== 2) return code ?? '';
  return code.toUpperCase().replace(/./g, c =>
    String.fromCodePoint(0x1F1E6 - 65 + c.charCodeAt(0))
  );
}

// ── cover motif SVG ───────────────────────────────────────────────────────────

const TONES: Record<string, { bg: string; fg: string; edge: string }> = {
  amber:    { bg:'#2a1c08', fg:'#f59e0b', edge:'rgba(245,158,11,0.4)' },
  red:      { bg:'#2a0d0d', fg:'#ef4444', edge:'rgba(239,68,68,0.4)' },
  blue:     { bg:'#0a1a2e', fg:'#3b82f6', edge:'rgba(59,130,246,0.4)' },
  navy:     { bg:'#0a1530', fg:'#60a5fa', edge:'rgba(96,165,250,0.4)' },
  sky:      { bg:'#0a1c2e', fg:'#7dd3fc', edge:'rgba(125,211,252,0.4)' },
  gold:     { bg:'#241a08', fg:'#dba514', edge:'rgba(219,165,20,0.4)' },
  crimson:  { bg:'#2a080d', fg:'#f87171', edge:'rgba(248,113,113,0.4)' },
  graphite: { bg:'#161a22', fg:'#cbd5e1', edge:'rgba(203,213,225,0.4)' },
  purple:   { bg:'#160a2e', fg:'#a855f7', edge:'rgba(168,85,247,0.4)' },
  green:    { bg:'#0a2218', fg:'#22c55e', edge:'rgba(34,197,94,0.4)' },
};

function CoverMotif({ tone = 'blue', motif = 'orbit', label = '', w = 460, h = 260 }: {
  tone?: string; motif?: string; label?: string; w?: number; h?: number;
}) {
  const t = TONES[tone] || TONES.blue;
  const gid = `g-${tone}-${motif}-${w}`;
  const pid = `p-${tone}-${motif}-${w}`;
  return (
    <svg viewBox={`0 0 ${w} ${h}`} width="100%" height="100%"
         preserveAspectRatio="xMidYMid slice" style={{ background: t.bg, display: 'block' }}>
      <defs>
        <radialGradient id={gid} cx="50%" cy="40%" r="60%">
          <stop offset="0%" stopColor={t.fg} stopOpacity="0.18" />
          <stop offset="100%" stopColor={t.bg} stopOpacity="0" />
        </radialGradient>
        <pattern id={pid} width="14" height="14" patternUnits="userSpaceOnUse">
          <path d="M 14 0 L 0 0 0 14" fill="none" stroke={t.fg} strokeOpacity="0.06" strokeWidth="1" />
        </pattern>
      </defs>
      <rect width={w} height={h} fill={`url(#${pid})`} />
      <rect width={w} height={h} fill={`url(#${gid})`} />
      {motif === 'orbit' && (
        <g transform={`translate(${w * 0.5} ${h * 0.55})`}>
          {[40, 80, 120, 160].map((r, i) => (
            <circle key={r} r={r} fill="none" stroke={t.fg}
              strokeOpacity={0.25 - i * 0.04} strokeDasharray={i % 2 ? '2 4' : '0'} />
          ))}
          <circle r="6" fill={t.fg} style={{ filter: `drop-shadow(0 0 12px ${t.fg})` }} />
          <circle cx="120" cy="-30" r="3.5" fill={t.fg} opacity="0.85" />
          <circle cx="-150" cy="40" r="2.5" fill={t.fg} opacity="0.6" />
        </g>
      )}
      {motif === 'bars' && (
        <g transform={`translate(40 ${h - 40})`}>
          {[60, 140, 90, 180, 110, 200, 130, 170, 90, 150].map((bh, i) => (
            <rect key={i} x={i * 38} y={-bh} width="22" height={bh}
              fill={t.fg} fillOpacity={0.18 + (i % 3) * 0.12} />
          ))}
        </g>
      )}
      {motif === 'lines' && (
        <g fill="none" stroke={t.fg} strokeOpacity="0.4">
          <path d={`M 0 ${h * 0.7} Q ${w * 0.3} ${h * 0.3} ${w} ${h * 0.55}`} strokeWidth="1.5" />
          <path d={`M 0 ${h * 0.85} Q ${w * 0.5} ${h * 0.5} ${w} ${h * 0.4}`}
            strokeOpacity="0.25" strokeWidth="1" strokeDasharray="6 4" />
          <path d={`M 0 ${h * 0.4} Q ${w * 0.4} ${h * 0.7} ${w} ${h * 0.65}`}
            strokeOpacity="0.2" strokeWidth="1" />
          <circle cx={w * 0.3} cy={h * 0.42} r="4" fill={t.fg} stroke="none" />
          <circle cx={w * 0.7} cy={h * 0.5}  r="3" fill={t.fg} stroke="none" />
        </g>
      )}
      {motif === 'grid' && (
        <g>
          {Array.from({ length: 8 }).map((_, i) =>
            Array.from({ length: 14 }).map((_, j) => {
              const v = (Math.sin(i * 1.3 + j * 0.7) + 1) / 2;
              return <rect key={`${i}-${j}`} x={20 + j * 30} y={20 + i * 28}
                width="22" height="20" fill={t.fg} fillOpacity={v * 0.35} />;
            })
          )}
        </g>
      )}
      {label && (
        <text x="20" y={h - 18} fontFamily={MONO} fontSize="10"
          fill={t.fg} fillOpacity="0.7" letterSpacing="2">{label}</text>
      )}
    </svg>
  );
}

// ── badge atoms ───────────────────────────────────────────────────────────────

function TypeBadge({ type, sm }: { type: 'data' | 'analysis'; sm?: boolean }) {
  const cfg = type === 'data'
    ? { label: 'DATA',     color: '#22c55e', bg: 'rgba(34,197,94,0.12)',  icon: '▦' }
    : { label: 'ANALYSIS', color: '#3b82f6', bg: 'rgba(59,130,246,0.12)', icon: '✎' };
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: sm ? '3px 7px' : '5px 10px',
      fontSize: sm ? 9 : 10, fontWeight: 800, letterSpacing: '0.18em',
      fontFamily: MONO, color: cfg.color, background: cfg.bg,
      border: `1px solid ${cfg.color}33`, borderRadius: 4,
    }}>
      <span>{cfg.icon}</span>{cfg.label}
    </span>
  );
}

function FormatBadge({ format }: { format: string }) {
  const map: Record<string, { label: string; color: string; icon: string }> = {
    dashboard: { label: 'DASHBOARD', color: '#22c55e', icon: '▦' },
    brief:     { label: 'BRIEF',     color: '#f59e0b', icon: '⚑' },
    longform:  { label: 'LONG',      color: '#7dd3fc', icon: '¶' },
  };
  const c = map[format] || map.longform;
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px',
      fontSize: 9, fontWeight: 800, letterSpacing: '0.18em', fontFamily: MONO,
      color: c.color, background: `${c.color}18`, border: `1px solid ${c.color}40`, borderRadius: 3,
    }}>
      <span>{c.icon}</span>{c.label}
    </span>
  );
}

function ConfidenceBar({ value, compact }: { value: number; compact?: boolean }) {
  const pct = Math.round(value * 100);
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontFamily: MONO, fontSize: compact ? 9 : 10 }}>
      {!compact && <span style={{ color: 'rgba(160,185,220,0.6)', letterSpacing: '0.15em' }}>CONF</span>}
      <div style={{ width: compact ? 50 : 80, height: 4, background: 'rgba(255,255,255,0.08)', borderRadius: 2, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${pct}%`, background: '#3b82f6', boxShadow: '0 0 8px #3b82f6' }} />
      </div>
      <span style={{ color: '#e8edf5', fontWeight: 700 }}>{pct}</span>
    </div>
  );
}

// ── types ─────────────────────────────────────────────────────────────────────

interface ReportCard {
  id:          string;
  title:       string;
  deck:        string;
  type:        'data' | 'analysis';
  format:      string;
  cover:       { tone: string; motif: string };
  readMinutes: number;
  confidence:  number;
  views:       number;
  category:    string;
  season:      number;
  label:       string;
  data:        unknown;
}

function buildCards(season: number, label: string, d: {
  leagueData: LeagueSpendingItem[]; positionData: PositionTrendItem[];
  clubData: ClubActivityItem[];     flowData: TransferFlowItem[];
  dealsData: TopDealItem[];         faData: FreeAgentItem[];
}): ReportCard[] {
  const top = d.leagueData[0];
  const topDeal = d.dealsData[0];
  const topPos  = d.positionData[0];
  const topClub = d.clubData[0];
  const topFlow = d.flowData[0];
  const faTotal = d.faData.reduce((s, x) => s + x.count, 0);
  const posLabel: Record<string, string> = { GK:'Goalkeeper', DF:'Defender', MF:'Midfielder', FW:'Forward' };

  return [
    {
      id: `league-spending-${season}`, season, label,
      title: 'Which League Is Spending the Most?',
      deck: top
        ? `${top.leagueName} leads the ${label} window with ${fmt(top.totalFeeEur)} across ${top.count} confirmed deal${top.count !== 1 ? 's' : ''} — the biggest single-league commitment so far.`
        : `Cross-league spending data for the ${label} transfer window.`,
      type: 'data', format: 'dashboard', readMinutes: 4,
      cover: { tone: 'blue', motif: 'bars' },
      confidence: 0.94, views: 0, category: 'League Spending', data: d.leagueData,
    },
    {
      id: `top-deals-${season}`, season, label,
      title: 'The Biggest Confirmed Deals',
      deck: topDeal
        ? `${topDeal.playerName} tops the ${label} window at ${fmt(topDeal.feeEur)}, moving from ${topDeal.fromClubName ?? 'a free transfer'} to ${topDeal.toClubName}. Five biggest confirmed deals charted.`
        : `The top confirmed transfer deals of the ${label} season, ranked by fee.`,
      type: 'data', format: 'dashboard', readMinutes: 3,
      cover: { tone: 'amber', motif: 'orbit' },
      confidence: 0.97, views: 0, category: 'Top Deals', data: d.dealsData,
    },
    {
      id: `position-trends-${season}`, season, label,
      title: 'What Position Is the Market Chasing?',
      deck: topPos
        ? `${posLabel[topPos.position] ?? topPos.position}s dominate the ${label} transfer market, accounting for ${((topPos.count / d.positionData.reduce((s, x) => s + x.count, 0)) * 100).toFixed(0)}% of all reported activity.`
        : `Positional demand breakdown across all top-five league clubs in ${label}.`,
      type: 'data', format: 'brief', readMinutes: 2,
      cover: { tone: 'graphite', motif: 'grid' },
      confidence: 0.91, views: 0, category: 'Position Trends', data: d.positionData,
    },
    {
      id: `club-activity-${season}`, season, label,
      title: 'Who Is Signing the Most Players?',
      deck: topClub
        ? `${topClub.clubName} leads all clubs with ${topClub.incomingCount} incoming transfers in ${label} — more than any other team in Europe's top five leagues.`
        : `Club-by-club recruitment activity ranked by incoming transfer reports in ${label}.`,
      type: 'data', format: 'brief', readMinutes: 3,
      cover: { tone: 'gold', motif: 'bars' },
      confidence: 0.89, views: 0, category: 'Club Recruitment', data: d.clubData,
    },
    {
      id: `transfer-flow-${season}`, season, label,
      title: 'How Are Players Crossing Borders?',
      deck: topFlow
        ? `The ${topFlow.fromCountryCode.toUpperCase()} → ${topFlow.toCountryCode.toUpperCase()} corridor is the busiest cross-border route of the ${label} window with ${topFlow.count} reported moves.`
        : `Cross-border transfer corridors mapped across European football in ${label}.`,
      type: 'data', format: 'dashboard', readMinutes: 3,
      cover: { tone: 'sky', motif: 'lines' },
      confidence: 0.88, views: 0, category: 'Transfer Flow', data: d.flowData,
    },
    {
      id: `free-agents-${season}`, season, label,
      title: 'How Big Is the Free Agent Market?',
      deck: faTotal > 0
        ? `${faTotal} free agent signings reported across the ${label} window — clubs strengthening without paying transfer fees, a trend rising across all five leagues.`
        : `Free agent transfer activity across Europe's top five leagues in ${label}.`,
      type: 'data', format: 'brief', readMinutes: 2,
      cover: { tone: 'crimson', motif: 'orbit' },
      confidence: 0.93, views: 0, category: 'Free Market', data: d.faData,
    },
  ];
}

// ── detail view ───────────────────────────────────────────────────────────────

function DataTable({ rows }: { rows: { label: string; sub?: string; value: string }[] }) {
  return (
    <div style={{ border: '1px solid rgba(255,255,255,0.07)', borderRadius: 10, overflow: 'hidden' }}>
      {rows.map((row, i) => (
        <div key={i} style={{
          display: 'flex', alignItems: 'center', gap: 12,
          padding: '11px 18px', borderBottom: i < rows.length - 1 ? '1px solid rgba(255,255,255,0.05)' : 'none',
          background: i % 2 === 0 ? 'rgba(255,255,255,0.01)' : 'transparent',
        }}>
          <span style={{ fontFamily: MONO, fontSize: 11, color: 'rgba(160,185,220,0.4)', width: 20, textAlign: 'center' }}>
            {i + 1}
          </span>
          <div style={{ flex: 1 }}>
            <span style={{ fontSize: 13, color: '#e8edf5' }}>{row.label}</span>
            {row.sub && <span style={{ fontSize: 11, color: 'rgba(160,185,220,0.5)', marginLeft: 10 }}>{row.sub}</span>}
          </div>
          <span style={{ fontFamily: MONO, fontSize: 12, fontWeight: 700, color: '#e8edf5' }}>{row.value}</span>
        </div>
      ))}
    </div>
  );
}

function DetailView({ card, onBack }: { card: ReportCard; onBack: () => void }) {
  const t = TONES[card.cover.tone] || TONES.blue;

  const renderData = () => {
    if (card.id.startsWith('league-spending')) {
      const data = card.data as LeagueSpendingItem[];
      return (
        <DataTable rows={data.map(d => ({
          label: d.leagueName,
          sub: `${flag(d.countryCode)} ${d.count} deals`,
          value: fmt(d.totalFeeEur),
        }))} />
      );
    }
    if (card.id.startsWith('top-deals')) {
      const data = card.data as TopDealItem[];
      return (
        <DataTable rows={data.map(d => ({
          label: d.playerName,
          sub: `${d.fromClubName ?? 'Free Agent'} → ${d.toClubName}`,
          value: fmt(d.feeEur),
        }))} />
      );
    }
    if (card.id.startsWith('position-trends')) {
      const data = card.data as PositionTrendItem[];
      const total = data.reduce((s, d) => s + d.count, 0);
      const posLabel: Record<string, string> = { GK:'Goalkeeper', DF:'Defender', MF:'Midfielder', FW:'Forward' };
      return (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {data.map(d => {
            const pct = total > 0 ? ((d.count / total) * 100).toFixed(1) : '0.0';
            return (
              <div key={d.position}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, marginBottom: 6 }}>
                  <span style={{ color: '#e8edf5' }}>{posLabel[d.position] ?? d.position}</span>
                  <span style={{ fontFamily: MONO, fontWeight: 700, color: '#e8edf5' }}>
                    {d.count} <span style={{ color: 'rgba(160,185,220,0.4)', fontWeight: 400 }}>({pct}%)</span>
                  </span>
                </div>
                <div style={{ height: 6, background: 'rgba(255,255,255,0.06)', borderRadius: 3, overflow: 'hidden' }}>
                  <div style={{ height: '100%', width: `${pct}%`, background: t.fg, borderRadius: 3,
                    boxShadow: `0 0 8px ${t.fg}66` }} />
                </div>
              </div>
            );
          })}
        </div>
      );
    }
    if (card.id.startsWith('club-activity')) {
      const data = card.data as ClubActivityItem[];
      return (
        <DataTable rows={data.slice(0, 10).map(d => ({
          label: d.clubName,
          sub: d.leagueName,
          value: `${d.incomingCount} reports`,
        }))} />
      );
    }
    if (card.id.startsWith('transfer-flow')) {
      const data = card.data as TransferFlowItem[];
      return (
        <DataTable rows={data.slice(0, 10).map(d => ({
          label: `${flag(d.fromCountryCode)} ${d.fromCountryCode.toUpperCase()} → ${flag(d.toCountryCode)} ${d.toCountryCode.toUpperCase()}`,
          value: `${d.count} transfers`,
        }))} />
      );
    }
    if (card.id.startsWith('free-agents')) {
      const data = card.data as FreeAgentItem[];
      return (
        <DataTable rows={data.map(d => ({
          label: d.leagueName,
          value: `${d.count} signings`,
        }))} />
      );
    }
    return null;
  };

  return (
    <div style={{ width: '100%', background: '#060a12', color: '#e8edf5', fontFamily: "'Helvetica Neue', Arial, sans-serif" }}>
      {/* Sticky top bar */}
      <div style={{
        display: 'flex', alignItems: 'center', gap: 14, padding: '14px 40px',
        borderBottom: '1px solid rgba(255,255,255,0.08)', position: 'sticky', top: 0,
        background: 'rgba(6,10,18,0.95)', backdropFilter: 'blur(8px)', zIndex: 10,
      }}>
        <button onClick={onBack} style={{
          border: '1px solid rgba(255,255,255,0.08)', color: 'rgba(160,185,220,0.7)',
          fontSize: 12, padding: '6px 14px', borderRadius: 6,
          background: 'transparent', cursor: 'pointer', fontFamily: MONO, letterSpacing: '0.1em',
        }}>← REPORTS</button>
        <TypeBadge type={card.type} sm />
        <FormatBadge format={card.format} />
        <div style={{ flex: 1 }} />
        <span style={{ fontFamily: MONO, fontSize: 10, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.5)' }}>
          {card.label} · {card.category.toUpperCase()}
        </span>
      </div>

      {/* Hero cover */}
      <div style={{ position: 'relative', height: 360 }}>
        <CoverMotif tone={card.cover.tone} motif={card.cover.motif} w={1280} h={360} />
        <div style={{ position: 'absolute', inset: 0,
          background: 'linear-gradient(180deg, rgba(6,10,18,0.15) 0%, rgba(6,10,18,0.92) 100%)' }} />
        <div style={{ position: 'absolute', bottom: 36, left: 40, right: 40, maxWidth: 860 }}>
          <div style={{ fontFamily: MONO, fontSize: 10, letterSpacing: '0.25em', color: '#7dd3fc', marginBottom: 14 }}>
            ◈ {card.category.toUpperCase()} · {card.label} SEASON
          </div>
          <h1 style={{ fontSize: 44, fontWeight: 900, lineHeight: 1.05, letterSpacing: '-0.02em', margin: '0 0 16px',
            textShadow: '0 4px 30px rgba(0,0,0,0.6)' }}>
            {card.title}
          </h1>
          <p style={{ fontSize: 17, lineHeight: 1.55, margin: 0, color: 'rgba(220,235,255,0.85)', maxWidth: 720 }}>
            {card.deck}
          </p>
          <div style={{ display: 'flex', gap: 24, alignItems: 'center', marginTop: 18,
            fontFamily: MONO, fontSize: 11, color: 'rgba(160,185,220,0.7)' }}>
            <span>{card.readMinutes} MIN READ</span>
            <span>·</span>
            <ConfidenceBar value={card.confidence} />
          </div>
        </div>
      </div>

      {/* Content */}
      <div style={{ maxWidth: 860, margin: '0 auto', padding: '48px 40px 80px' }}>
        <div style={{ marginBottom: 32, padding: '20px 24px',
          background: '#0d1626', border: '1px solid rgba(255,255,255,0.07)', borderRadius: 12 }}>
          <div style={{ fontFamily: MONO, fontSize: 9, letterSpacing: '0.25em',
            color: 'rgba(160,185,220,0.4)', marginBottom: 12 }}>// REPORT SUMMARY</div>
          <p style={{ fontSize: 14, lineHeight: 1.7, margin: 0, color: 'rgba(200,220,255,0.75)' }}>
            {card.deck}
          </p>
        </div>
        <div style={{ fontFamily: MONO, fontSize: 9, letterSpacing: '0.28em',
          color: 'rgba(160,185,220,0.4)', marginBottom: 16 }}>// DATA</div>
        {renderData()}
      </div>
    </div>
  );
}

// ── magazine card ─────────────────────────────────────────────────────────────

function MagazineCard({ card, onOpen }: { card: ReportCard; onOpen: (c: ReportCard) => void }) {
  const [hov, setHov] = useState(false);
  return (
    <article onClick={() => onOpen(card)}
      onMouseEnter={() => setHov(true)}
      onMouseLeave={() => setHov(false)}
      style={{
        background: '#0d1626', border: `1px solid ${hov ? 'rgba(59,130,246,0.4)' : 'rgba(255,255,255,0.08)'}`,
        borderRadius: 12, overflow: 'hidden', cursor: 'pointer',
        display: 'flex', flexDirection: 'column',
        transform: hov ? 'translateY(-2px)' : 'none',
        transition: 'transform 0.15s, border-color 0.15s',
      }}>
      <div style={{ position: 'relative', height: 160 }}>
        <CoverMotif tone={card.cover.tone} motif={card.cover.motif} w={400} h={160} />
        <div style={{ position: 'absolute', top: 12, left: 12, display: 'flex', gap: 6, flexWrap: 'wrap' }}>
          <TypeBadge type={card.type} sm />
          <FormatBadge format={card.format} />
        </div>
      </div>
      <div style={{ padding: '18px 20px 20px', display: 'flex', flexDirection: 'column', gap: 10, flex: 1 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8,
          fontFamily: MONO, fontSize: 9, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.5)' }}>
          <span>{card.category.toUpperCase()}</span>
          <span style={{ opacity: 0.5 }}>·</span>
          <span>{card.label}</span>
          <span style={{ opacity: 0.5 }}>·</span>
          <span>{card.readMinutes}MIN</span>
        </div>
        <h3 style={{ fontSize: 17, fontWeight: 800, lineHeight: 1.25, margin: 0, letterSpacing: '-0.005em' }}>
          {card.title}
        </h3>
        <p style={{ fontSize: 13, lineHeight: 1.5, margin: 0, color: 'rgba(200,220,255,0.6)' }}>
          {card.deck}
        </p>
        <div style={{ flex: 1 }} />
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          paddingTop: 10, borderTop: '1px solid rgba(255,255,255,0.06)' }}>
          <ConfidenceBar value={card.confidence} compact />
          <span style={{ fontFamily: MONO, fontSize: 10, color: 'rgba(160,185,220,0.45)' }}>READ →</span>
        </div>
      </div>
    </article>
  );
}

// ── editorial card ────────────────────────────────────────────────────────────

function EditorialCard({ report, onOpen }: {
  report: EditorialReportResponse;
  onOpen: (r: EditorialReportResponse) => void;
}) {
  const [hov, setHov] = useState(false);
  const type = (report.type === 'data' ? 'data' : 'analysis') as 'data' | 'analysis';
  return (
    <article onClick={() => onOpen(report)}
      onMouseEnter={() => setHov(true)}
      onMouseLeave={() => setHov(false)}
      style={{
        background: '#0d1626',
        border: `1px solid ${hov ? 'rgba(59,130,246,0.4)' : 'rgba(255,255,255,0.08)'}`,
        borderRadius: 12, overflow: 'hidden', cursor: 'pointer',
        display: 'flex', flexDirection: 'column',
        transform: hov ? 'translateY(-2px)' : 'none',
        transition: 'transform 0.15s, border-color 0.15s',
      }}>
      <div style={{ position: 'relative', height: 160 }}>
        <CoverMotif tone={report.coverTone || 'blue'} motif={report.coverMotif || 'orbit'} w={400} h={160} />
        <div style={{ position: 'absolute', top: 12, left: 12, display: 'flex', gap: 6, flexWrap: 'wrap' }}>
          <TypeBadge type={type} sm />
          <FormatBadge format={report.format} />
        </div>
      </div>
      <div style={{ padding: '18px 20px 20px', display: 'flex', flexDirection: 'column', gap: 10, flex: 1 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8,
          fontFamily: MONO, fontSize: 9, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.5)' }}>
          <span>EDITORIAL</span>
          <span style={{ opacity: 0.5 }}>·</span>
          <span>{report.readMinutes}MIN</span>
          {report.tags?.[0] && <><span style={{ opacity: 0.5 }}>·</span>
            <span>{report.tags[0].toUpperCase()}</span></>}
        </div>
        <h3 style={{ fontSize: 17, fontWeight: 800, lineHeight: 1.25, margin: 0, letterSpacing: '-0.005em' }}>
          {report.title}
        </h3>
        <p style={{ fontSize: 13, lineHeight: 1.5, margin: 0, color: 'rgba(200,220,255,0.6)' }}>
          {report.deck}
        </p>
        <div style={{ flex: 1 }} />
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          paddingTop: 10, borderTop: '1px solid rgba(255,255,255,0.06)' }}>
          <ConfidenceBar value={report.confidence} compact />
          <span style={{ fontFamily: MONO, fontSize: 10, color: 'rgba(160,185,220,0.45)' }}>READ →</span>
        </div>
      </div>
    </article>
  );
}

// ── editorial detail view ─────────────────────────────────────────────────────

function EditorialDetailView({ report, onBack }: {
  report: EditorialReportResponse;
  onBack: () => void;
}) {
  const t = TONES[report.coverTone] || TONES.blue;
  const type = (report.type === 'data' ? 'data' : 'analysis') as 'data' | 'analysis';

  let blocks: Block[] = [];
  try { blocks = JSON.parse(report.blocks); } catch { /* empty */ }

  const renderBlock = (block: Block) => {
    switch (block.kind) {
      case 'heading':
        return <h2 key={block.id} style={{ fontSize: 26, fontWeight: 800, lineHeight: 1.2,
          margin: '32px 0 12px', letterSpacing: '-0.01em', color: '#e8edf5' }}>{block.text}</h2>;
      case 'paragraph':
        return <p key={block.id} style={{ fontSize: 15, lineHeight: 1.75, margin: '0 0 20px',
          color: 'rgba(200,220,255,0.82)' }}>{block.text}</p>;
      case 'pullquote':
        return (
          <blockquote key={block.id} style={{
            margin: '32px 0', padding: '20px 28px',
            borderLeft: `4px solid ${t.fg}`,
            background: `${t.fg}10`, borderRadius: '0 8px 8px 0',
            fontSize: 19, fontWeight: 700, lineHeight: 1.45,
            color: '#e8edf5', fontStyle: 'italic',
          }}>{block.text}</blockquote>
        );
      case 'stats':
        return (
          <div key={block.id} style={{
            display: 'grid',
            gridTemplateColumns: `repeat(${Math.min(block.items.length, 3)}, 1fr)`,
            gap: 16, margin: '24px 0',
            background: '#0d1626', border: '1px solid rgba(255,255,255,0.07)',
            borderRadius: 12, padding: '24px',
          }}>
            {block.items.map((item, i) => (
              <div key={i} style={{ textAlign: 'center' }}>
                <div style={{ fontFamily: MONO, fontSize: 32, fontWeight: 800, color: t.fg, lineHeight: 1 }}>
                  {item.value}
                </div>
                <div style={{ fontSize: 12, fontWeight: 700, color: '#e8edf5', marginTop: 8 }}>{item.label}</div>
                {item.sub && <div style={{ fontFamily: MONO, fontSize: 10, letterSpacing: '0.1em',
                  color: 'rgba(160,185,220,0.5)', marginTop: 4 }}>{item.sub}</div>}
              </div>
            ))}
          </div>
        );
      case 'timeline':
        return (
          <div key={block.id} style={{ margin: '24px 0', display: 'flex', flexDirection: 'column', gap: 0 }}>
            {block.items.map((item, i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '80px 1fr', gap: 20,
                paddingBottom: 20, position: 'relative' }}>
                {i < block.items.length - 1 && (
                  <div style={{ position: 'absolute', left: 39, top: 24, bottom: 0, width: 1,
                    background: 'rgba(255,255,255,0.1)' }} />
                )}
                <div style={{ fontFamily: MONO, fontSize: 12, fontWeight: 800, color: t.fg, paddingTop: 2 }}>
                  {item.year}
                </div>
                <div>
                  <div style={{ fontSize: 14, fontWeight: 700, color: '#e8edf5', marginBottom: 4 }}>{item.label}</div>
                  {item.body && <div style={{ fontSize: 13, lineHeight: 1.6,
                    color: 'rgba(160,185,220,0.65)' }}>{item.body}</div>}
                </div>
              </div>
            ))}
          </div>
        );
      case 'kpi':
        return (
          <div key={block.id} style={{
            display: 'grid',
            gridTemplateColumns: `repeat(${Math.min(block.items.length, 4)}, 1fr)`,
            gap: 16, margin: '24px 0',
          }}>
            {block.items.map((item, i) => (
              <div key={i} style={{ background: '#0d1626', border: '1px solid rgba(255,255,255,0.07)',
                borderRadius: 10, padding: '18px 20px' }}>
                <div style={{ fontFamily: MONO, fontSize: 28, fontWeight: 800, color: t.fg, lineHeight: 1 }}>
                  {item.value}
                </div>
                <div style={{ fontSize: 12, color: 'rgba(160,185,220,0.65)', marginTop: 6 }}>{item.label}</div>
                {item.delta && <div style={{ fontFamily: MONO, fontSize: 10, color: '#22c55e',
                  marginTop: 4, letterSpacing: '0.1em' }}>{item.delta}</div>}
              </div>
            ))}
          </div>
        );
      case 'divider':
        return <hr key={block.id} style={{ border: 'none',
          borderTop: '1px solid rgba(255,255,255,0.08)', margin: '36px 0' }} />;
    }
  };

  return (
    <div style={{ width: '100%', background: '#060a12', color: '#e8edf5',
      fontFamily: "'Helvetica Neue', Arial, sans-serif" }}>
      {/* Sticky top bar */}
      <div style={{
        display: 'flex', alignItems: 'center', gap: 14, padding: '14px 40px',
        borderBottom: '1px solid rgba(255,255,255,0.08)', position: 'sticky', top: 0,
        background: 'rgba(6,10,18,0.95)', backdropFilter: 'blur(8px)', zIndex: 10,
      }}>
        <button onClick={onBack} style={{
          border: '1px solid rgba(255,255,255,0.08)', color: 'rgba(160,185,220,0.7)',
          fontSize: 12, padding: '6px 14px', borderRadius: 6,
          background: 'transparent', cursor: 'pointer', fontFamily: MONO, letterSpacing: '0.1em',
        }}>← REPORTS</button>
        <TypeBadge type={type} sm />
        <FormatBadge format={report.format} />
        <div style={{ flex: 1 }} />
        {report.tags.length > 0 && (
          <div style={{ display: 'flex', gap: 8 }}>
            {report.tags.map(tag => (
              <span key={tag} style={{
                fontFamily: MONO, fontSize: 9, padding: '4px 9px', borderRadius: 3,
                background: `${t.fg}14`, color: t.fg, border: `1px solid ${t.fg}40`,
                letterSpacing: '0.15em',
              }}>{tag.toUpperCase()}</span>
            ))}
          </div>
        )}
      </div>

      {/* Hero */}
      <div style={{ position: 'relative', height: 360 }}>
        <CoverMotif tone={report.coverTone || 'blue'} motif={report.coverMotif || 'orbit'} w={1280} h={360} />
        <div style={{ position: 'absolute', inset: 0,
          background: 'linear-gradient(180deg, rgba(6,10,18,0.15) 0%, rgba(6,10,18,0.92) 100%)' }} />
        <div style={{ position: 'absolute', bottom: 36, left: 40, right: 40, maxWidth: 860 }}>
          <div style={{ fontFamily: MONO, fontSize: 10, letterSpacing: '0.25em', color: t.fg, marginBottom: 14 }}>
            ◈ EDITORIAL
          </div>
          <h1 style={{ fontSize: 44, fontWeight: 900, lineHeight: 1.05, letterSpacing: '-0.02em',
            margin: '0 0 16px', textShadow: '0 4px 30px rgba(0,0,0,0.6)' }}>
            {report.title}
          </h1>
          {report.deck && (
            <p style={{ fontSize: 17, lineHeight: 1.55, margin: 0,
              color: 'rgba(220,235,255,0.85)', maxWidth: 720 }}>{report.deck}</p>
          )}
          <div style={{ display: 'flex', gap: 24, alignItems: 'center', marginTop: 18,
            fontFamily: MONO, fontSize: 11, color: 'rgba(160,185,220,0.7)' }}>
            <span>{report.readMinutes} MIN READ</span>
            <span>·</span>
            <ConfidenceBar value={report.confidence} />
          </div>
        </div>
      </div>

      {/* Content */}
      <div style={{ maxWidth: 860, margin: '0 auto', padding: '48px 40px 80px' }}>
        {blocks.map(block => renderBlock(block))}
      </div>
    </div>
  );
}

// ── skeleton ──────────────────────────────────────────────────────────────────

function SkeletonCard() {
  return (
    <div style={{ background: '#0d1626', border: '1px solid rgba(255,255,255,0.08)',
      borderRadius: 12, overflow: 'hidden', minHeight: 320 }}>
      <div style={{ height: 160, background: 'rgba(255,255,255,0.03)',
        animation: 'pulse 1.5s ease-in-out infinite' }} />
      <div style={{ padding: '18px 20px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        <div style={{ height: 8, width: '50%', background: 'rgba(255,255,255,0.06)', borderRadius: 4 }} />
        <div style={{ height: 16, width: '85%', background: 'rgba(255,255,255,0.07)', borderRadius: 4 }} />
        <div style={{ height: 12, width: '100%', background: 'rgba(255,255,255,0.04)', borderRadius: 4 }} />
        <div style={{ height: 12, width: '75%', background: 'rgba(255,255,255,0.04)', borderRadius: 4 }} />
      </div>
    </div>
  );
}

// ── page ──────────────────────────────────────────────────────────────────────

export default function ReportPage() {
  const navigate = useNavigate();
  const [searchParams] = useState(() => typeof window !== 'undefined' ? new URLSearchParams(window.location.search) : new URLSearchParams());

  const [cards, setCards] = useState<ReportCard[] | null>(null);
  const [loading, setLoading] = useState(false);
  const [openCard, setOpenCard] = useState<ReportCard | null>(null);
  const [editorialReports, setEditorialReports] = useState<EditorialReportResponse[]>([]);
  const [openEditorial, setOpenEditorial] = useState<EditorialReportResponse | null>(null);
  const [tab, setTab] = useState<'data' | 'editorial'>(
    searchParams.get('tab') === 'editorial' ? 'editorial' : 'data'
  );

  useEffect(() => {
    fetchEditorialReports().then(setEditorialReports).catch(() => {});
  }, []);

  useEffect(() => {
    const opt = SEASON_OPTIONS[0];
    setLoading(true);
    Promise.all([
      fetchLeagueSpending(opt.value), fetchPositionTrend(opt.value),
      fetchClubActivity(opt.value),  fetchTransferFlow(opt.value),
      fetchTopDeals(opt.value),      fetchFreeAgent(opt.value),
    ]).then(([league, position, club, flow, deals, fa]) => {
      setCards(buildCards(opt.value, opt.label, {
        leagueData: league, positionData: position, clubData: club,
        flowData: flow, dealsData: deals, faData: fa,
      }));
    }).catch(() => setCards([])).finally(() => setLoading(false));
  }, []);

  return (
    <div className="h-screen overflow-y-auto" style={{ background: '#060a12', color: '#e8edf5',
      fontFamily: "'Helvetica Neue', Arial, sans-serif" }}>
      <Helmet>
        <title>Transfer Report — TransferMap</title>
        <meta name="description" content="European football transfer spending analysis, position trends, and club activity reports." />
        <meta property="og:title" content="Transfer Report — TransferMap" />
        <meta property="og:description" content="European football transfer spending analysis, position trends, and club activity reports." />
        <meta name="twitter:title" content="Transfer Report — TransferMap" />
        <meta name="twitter:description" content="European football transfer spending analysis and club activity reports." />
      </Helmet>

      {openEditorial ? (
        <EditorialDetailView report={openEditorial} onBack={() => setOpenEditorial(null)} />
      ) : openCard ? (
        <DetailView card={openCard} onBack={() => setOpenCard(null)} />
      ) : (
        <>
          {/* Header */}
          <div style={{
            display: 'flex', alignItems: 'center', gap: 14, padding: '18px 40px',
            borderBottom: '1px solid rgba(255,255,255,0.08)',
            position: 'sticky', top: 0, zIndex: 30,
            background: 'rgba(6,10,18,0.95)', backdropFilter: 'blur(8px)',
          }}>
            <button onClick={() => navigate('/')} style={{
              border: '1px solid rgba(255,255,255,0.08)', color: 'rgba(160,185,220,0.7)',
              fontSize: 12, padding: '6px 14px', borderRadius: 6,
              background: 'transparent', cursor: 'pointer',
            }}>← Map</button>
            <div style={{ fontSize: 14, fontWeight: 800, letterSpacing: '0.2em', textTransform: 'uppercase' }}>
              The Scout Desk
            </div>
            <div style={{ flex: 1 }} />
            <button onClick={() => navigate('/report/compose')} style={{
              fontFamily: MONO, fontSize: 10, fontWeight: 800, letterSpacing: '0.18em',
              padding: '7px 16px', borderRadius: 4, cursor: 'pointer',
              background: 'rgba(59,130,246,0.15)', color: '#7dd3fc',
              border: '1px solid rgba(59,130,246,0.4)',
            }}>+ WRITE REPORT</button>
          </div>

          {/* Tab bar */}
          <div style={{ display: 'flex', padding: '0 40px',
            borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
            {(['data', 'editorial'] as const).map(t => (
              <button key={t} onClick={() => setTab(t)} style={{
                fontFamily: MONO, fontSize: 11, fontWeight: 800, letterSpacing: '0.2em',
                textTransform: 'uppercase', padding: '14px 20px', cursor: 'pointer',
                background: 'transparent', border: 'none', outline: 'none',
                color: tab === t ? '#e8edf5' : 'rgba(160,185,220,0.4)',
                borderBottom: `2px solid ${tab === t ? '#3b82f6' : 'transparent'}`,
                marginBottom: -1, transition: 'color 0.15s',
              }}>{t}</button>
            ))}
          </div>

          {/* Data tab */}
          {tab === 'data' && (
            <div style={{ padding: '28px 40px 40px',
              display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 20 }}>
              {loading
                ? Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)
                : (cards ?? []).map(card => (
                    <MagazineCard key={card.id} card={card} onOpen={setOpenCard} />
                  ))
              }
            </div>
          )}

          {/* Editorial tab */}
          {tab === 'editorial' && (
            <div style={{ padding: '28px 40px 40px' }}>
              {editorialReports.length === 0 ? (
                <div style={{
                  display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
                  background: '#0d1626', border: '1px solid rgba(255,255,255,0.08)',
                  borderRadius: 16, minHeight: 440, gap: 12,
                }}>
                  <span style={{ fontFamily: MONO, fontSize: 11, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.35)' }}>
                    NO EDITORIAL REPORTS
                  </span>
                  <span style={{ fontSize: 13, color: 'rgba(160,185,220,0.25)' }}>
                    Published reports will appear here
                  </span>
                </div>
              ) : (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 20 }}>
                  {editorialReports.map(r => (
                    <EditorialCard key={r.id} report={r} onOpen={setOpenEditorial} />
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Footer */}
          <div style={{ margin: '0 40px 40px', paddingTop: 24,
            borderTop: '1px solid rgba(255,255,255,0.06)',
            display: 'flex', gap: 16, flexWrap: 'wrap',
            fontFamily: MONO, fontSize: 10, letterSpacing: '0.12em',
            color: 'rgba(160,185,220,0.35)' }}>
            <span>Data sourced from journalist reports on X (Twitter)</span>
            <span>·</span>
            <button onClick={() => navigate('/info#about')}
              style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'inherit', fontFamily: MONO, fontSize: 'inherit', letterSpacing: 'inherit' }}
              onMouseOver={e => (e.currentTarget.style.color = '#e8edf5')}
              onMouseOut={e  => (e.currentTarget.style.color = 'rgba(160,185,220,0.35)')}>
              About
            </button>
            <button onClick={() => navigate('/info#privacy')}
              style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'inherit', fontFamily: MONO, fontSize: 'inherit', letterSpacing: 'inherit' }}
              onMouseOver={e => (e.currentTarget.style.color = '#e8edf5')}
              onMouseOut={e  => (e.currentTarget.style.color = 'rgba(160,185,220,0.35)')}>
              Privacy
            </button>
          </div>
        </>
      )}

      <style>{`@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.5} }`}</style>
    </div>
  );
}
