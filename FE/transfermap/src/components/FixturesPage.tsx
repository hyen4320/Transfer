import { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet-async';
import { LEAGUES, CLUBS } from '../data/mock';
import { fetchWeekFixtures, fetchStandings, fetchMatchEvents, fetchMatchStats, fetchMatchLineups } from '../api/fixtures';
import type { FixtureItem, StandingItem, MatchEventItem, MatchStatItem, MatchLineupItem } from '../api/fixtures';
import type { Club } from '../types';
import AdSlot, { SLOT } from './AdSlot';

// ─── Mock fallback (mirrors fixtures-data.js from design) ────────────────────

const MOCK_FIXTURES: FixtureItem[] = [
  { id: 1,  leagueId:'pl', homeTeam:'Arsenal',       awayTeam:'Liverpool',     date:'2026-05-09', kickoff:'12:30', state:'finished', homeScore:2, awayScore:2, minute:90, matchday:36, venue:'Emirates Stadium',  referee:'Anthony Taylor' },
  { id: 2,  leagueId:'pl', homeTeam:'Man City',       awayTeam:'Arsenal',       date:'2026-05-09', kickoff:'17:30', state:'live',     homeScore:1, awayScore:0, minute:67, matchday:36, venue:'Etihad Stadium',   referee:'Michael Oliver' },
  { id: 3,  leagueId:'ll', homeTeam:'Real Madrid',    awayTeam:'Barcelona',     date:'2026-05-09', kickoff:'21:00', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:35,venue:'Santiago Bernabéu',referee:'Carlos del Cerro' },
  { id: 4,  leagueId:'bl', homeTeam:'Bayern Munich',  awayTeam:'Dortmund',      date:'2026-05-09', kickoff:'18:30', state:'finished', homeScore:3, awayScore:1, minute:90, matchday:33, venue:'Allianz Arena',    referee:'Felix Brych' },
  { id: 5,  leagueId:'sa', homeTeam:'Juventus',       awayTeam:'AC Milan',      date:'2026-05-09', kickoff:'20:45', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:36,venue:'Allianz Stadium',  referee:'Daniele Orsato' },
  { id: 6,  leagueId:'l1', homeTeam:'PSG',            awayTeam:'Marseille',     date:'2026-05-09', kickoff:'21:00', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:34,venue:'Parc des Princes',  referee:'' },
  { id: 7,  leagueId:'pl', homeTeam:'Liverpool',      awayTeam:'Man City',      date:'2026-05-10', kickoff:'16:00', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:36,venue:'Anfield',          referee:'' },
  { id: 8,  leagueId:'ll', homeTeam:'Barcelona',      awayTeam:'Real Madrid',   date:'2026-05-10', kickoff:'21:00', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:35,venue:'Spotify Camp Nou', referee:'' },
  { id: 9,  leagueId:'bl', homeTeam:'Dortmund',       awayTeam:'Bayern Munich', date:'2026-05-10', kickoff:'17:30', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:33,venue:'Signal Iduna Park', referee:'' },
  { id: 10, leagueId:'pl', homeTeam:'Arsenal',        awayTeam:'Man City',      date:'2026-05-13', kickoff:'21:00', state:'scheduled',homeScore:null,awayScore:null,minute:0,matchday:37,venue:'Emirates Stadium',  referee:'' },
];

const MOCK_STANDINGS: Record<string, StandingItem[]> = {
  pl: [
    { rank:1, teamName:'Man City',     played:36, won:27, drawn:6,  lost:3,  goalsFor:91, goalsAgainst:32, goalsDiff:59, points:87, form:'WWDWW' },
    { rank:2, teamName:'Arsenal',      played:36, won:25, drawn:7,  lost:4,  goalsFor:84, goalsAgainst:35, goalsDiff:49, points:82, form:'WWWDL' },
    { rank:3, teamName:'Liverpool',    played:36, won:24, drawn:5,  lost:7,  goalsFor:79, goalsAgainst:38, goalsDiff:41, points:77, form:'LWWWD' },
    { rank:4, teamName:'Tottenham',    played:36, won:21, drawn:8,  lost:7,  goalsFor:68, goalsAgainst:40, goalsDiff:28, points:71, form:'WDWLW' },
    { rank:5, teamName:'Chelsea',      played:36, won:20, drawn:7,  lost:9,  goalsFor:72, goalsAgainst:48, goalsDiff:24, points:67, form:'WLWWD' },
    { rank:6, teamName:'Newcastle',    played:36, won:19, drawn:8,  lost:9,  goalsFor:65, goalsAgainst:50, goalsDiff:15, points:65, form:'DWWLW' },
    { rank:7, teamName:'Aston Villa',  played:36, won:17, drawn:9,  lost:10, goalsFor:58, goalsAgainst:48, goalsDiff:10, points:60, form:'LDWWL' },
    { rank:8, teamName:'Brighton',     played:36, won:15, drawn:10, lost:11, goalsFor:54, goalsAgainst:50, goalsDiff:4,  points:55, form:'WLDWD' },
    { rank:17,teamName:'Leicester',    played:36, won:6,  drawn:5,  lost:25, goalsFor:32, goalsAgainst:78, goalsDiff:-46,points:23, form:'LLLLL' },
    { rank:18,teamName:'Ipswich',      played:36, won:5,  drawn:6,  lost:25, goalsFor:28, goalsAgainst:82, goalsDiff:-54,points:21, form:'LLLWL' },
    { rank:19,teamName:'Southampton',  played:36, won:5,  drawn:5,  lost:26, goalsFor:27, goalsAgainst:85, goalsDiff:-58,points:20, form:'LLLLL' },
    { rank:20,teamName:'Wolves',       played:36, won:4,  drawn:6,  lost:26, goalsFor:30, goalsAgainst:88, goalsDiff:-58,points:18, form:'DLLLL' },
  ],
  ll: [
    { rank:1, teamName:'Real Madrid',  played:35, won:26, drawn:6,  lost:3,  goalsFor:84, goalsAgainst:28, goalsDiff:56, points:84, form:'WWWDW' },
    { rank:2, teamName:'Barcelona',    played:35, won:24, drawn:5,  lost:6,  goalsFor:79, goalsAgainst:34, goalsDiff:45, points:77, form:'WLWWW' },
    { rank:3, teamName:'Atlético',     played:35, won:21, drawn:6,  lost:8,  goalsFor:62, goalsAgainst:38, goalsDiff:24, points:69, form:'WDLWW' },
    { rank:4, teamName:'Athletic',     played:35, won:19, drawn:7,  lost:9,  goalsFor:60, goalsAgainst:42, goalsDiff:18, points:64, form:'DWWLW' },
    { rank:16,teamName:'Valladolid',   played:35, won:6,  drawn:5,  lost:24, goalsFor:32, goalsAgainst:70, goalsDiff:-38,points:23, form:'LLLLL' },
    { rank:17,teamName:'Leganés',      played:35, won:5,  drawn:6,  lost:24, goalsFor:28, goalsAgainst:72, goalsDiff:-44,points:21, form:'DLLLL' },
    { rank:18,teamName:'Espanyol',     played:35, won:4,  drawn:6,  lost:25, goalsFor:25, goalsAgainst:76, goalsDiff:-51,points:18, form:'LLLLL' },
  ],
  bl: [
    { rank:1, teamName:'Bayern Munich',played:33, won:24, drawn:5,  lost:4,  goalsFor:88, goalsAgainst:32, goalsDiff:56, points:77, form:'WWDWW' },
    { rank:2, teamName:'Dortmund',     played:33, won:21, drawn:6,  lost:6,  goalsFor:70, goalsAgainst:38, goalsDiff:32, points:69, form:'WLWDW' },
    { rank:3, teamName:'RB Leipzig',   played:33, won:19, drawn:7,  lost:7,  goalsFor:65, goalsAgainst:42, goalsDiff:23, points:64, form:'WDWWL' },
    { rank:16,teamName:'Bochum',       played:33, won:5,  drawn:5,  lost:23, goalsFor:28, goalsAgainst:72, goalsDiff:-44,points:20, form:'LLLLL' },
    { rank:17,teamName:'Heidenheim',   played:33, won:4,  drawn:6,  lost:23, goalsFor:26, goalsAgainst:76, goalsDiff:-50,points:18, form:'DLLLL' },
    { rank:18,teamName:'Kiel',         played:33, won:4,  drawn:5,  lost:24, goalsFor:24, goalsAgainst:82, goalsDiff:-58,points:17, form:'LLLLL' },
  ],
  sa: [
    { rank:1, teamName:'AC Milan',     played:36, won:24, drawn:8,  lost:4,  goalsFor:75, goalsAgainst:30, goalsDiff:45, points:80, form:'WWWDW' },
    { rank:2, teamName:'Juventus',     played:36, won:22, drawn:9,  lost:5,  goalsFor:64, goalsAgainst:32, goalsDiff:32, points:75, form:'WDWWW' },
    { rank:3, teamName:'Inter',        played:36, won:20, drawn:8,  lost:8,  goalsFor:62, goalsAgainst:40, goalsDiff:22, points:68, form:'WLWDW' },
    { rank:18,teamName:'Venezia',      played:36, won:5,  drawn:6,  lost:25, goalsFor:28, goalsAgainst:74, goalsDiff:-46,points:21, form:'LLLLL' },
    { rank:19,teamName:'Monza',        played:36, won:4,  drawn:7,  lost:25, goalsFor:26, goalsAgainst:78, goalsDiff:-52,points:19, form:'DLLLL' },
    { rank:20,teamName:'Lecce',        played:36, won:4,  drawn:6,  lost:26, goalsFor:24, goalsAgainst:82, goalsDiff:-58,points:18, form:'LLLLL' },
  ],
  l1: [
    { rank:1, teamName:'PSG',          played:33, won:26, drawn:5,  lost:2,  goalsFor:88, goalsAgainst:24, goalsDiff:64, points:83, form:'WWWWD' },
    { rank:2, teamName:'Marseille',    played:33, won:20, drawn:6,  lost:7,  goalsFor:62, goalsAgainst:36, goalsDiff:26, points:66, form:'WLWWD' },
    { rank:3, teamName:'Monaco',       played:33, won:18, drawn:7,  lost:8,  goalsFor:55, goalsAgainst:40, goalsDiff:15, points:61, form:'DWWLW' },
    { rank:16,teamName:'Montpellier',  played:33, won:5,  drawn:6,  lost:22, goalsFor:32, goalsAgainst:68, goalsDiff:-36,points:21, form:'LLLLL' },
    { rank:17,teamName:'Metz',         played:33, won:4,  drawn:6,  lost:23, goalsFor:28, goalsAgainst:72, goalsDiff:-44,points:18, form:'DLLL L' },
    { rank:18,teamName:'Lorient',      played:33, won:3,  drawn:6,  lost:24, goalsFor:25, goalsAgainst:78, goalsDiff:-53,points:15, form:'LLLLL' },
  ],
};


// ─── Position band config ─────────────────────────────────────────────────────
const BANDS: Record<string, { ucl:[number,number]; uel:[number,number]; uecl:[number,number]; releg:[number,number] }> = {
  pl: { ucl:[1,4], uel:[5,5], uecl:[6,6], releg:[18,20] },
  ll: { ucl:[1,4], uel:[5,5], uecl:[6,6], releg:[18,20] },
  bl: { ucl:[1,4], uel:[5,5], uecl:[6,6], releg:[16,18] },
  sa: { ucl:[1,4], uel:[5,5], uecl:[6,6], releg:[18,20] },
  l1: { ucl:[1,3], uel:[4,4], uecl:[5,5], releg:[16,18] },
};
function bandColor(rank: number, leagueId: string): string | null {
  const b = BANDS[leagueId];
  if (!b) return null;
  if (rank >= b.ucl[0]  && rank <= b.ucl[1])  return '#3b82f6';
  if (rank >= b.uel[0]  && rank <= b.uel[1])  return '#f59e0b';
  if (rank >= b.uecl[0] && rank <= b.uecl[1]) return '#22c55e';
  if (rank >= b.releg[0]&& rank <= b.releg[1])return '#ef4444';
  return null;
}

// ─── Small helpers ────────────────────────────────────────────────────────────

function clubByName(name: string): Club | undefined {
  return CLUBS.find(c => c.name.toLowerCase() === name.toLowerCase() ||
    name.toLowerCase().includes(c.name.toLowerCase()) ||
    c.name.toLowerCase().includes(name.toLowerCase()));
}

function ClubInitials({ name, color, size = 22 }: { name: string; color?: string; size?: number }) {
  const initials = name.split(' ').map(w => w[0]).slice(0, 2).join('');
  const bg = color || '#2a3245';
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: `linear-gradient(135deg, ${bg}, ${bg}cc)`,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      fontFamily: "'JetBrains Mono', monospace", fontSize: Math.round(size * 0.42),
      fontWeight: 800, color: '#fff', letterSpacing: -0.5, flexShrink: 0,
      boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18), 0 1px 3px rgba(0,0,0,0.4)',
    }}>{initials}</div>
  );
}

function StatePill({ state, minute }: { state: string; minute: number }) {
  if (state === 'live') return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '3px 8px', background: 'rgba(239,68,68,0.18)',
      border: '1px solid rgba(239,68,68,0.5)', borderRadius: 3,
      fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800,
      letterSpacing: '0.18em', color: '#fca5a5',
    }}>
      <span style={{ width: 6, height: 6, borderRadius: '50%', background: '#ef4444', boxShadow: '0 0 8px #ef4444' }} />
      LIVE · {minute}'
    </span>
  );
  if (state === 'finished') return (
    <span style={{
      padding: '3px 8px', background: 'rgba(160,185,220,0.08)',
      border: '1px solid rgba(255,255,255,0.08)', borderRadius: 3,
      fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800,
      letterSpacing: '0.18em', color: 'rgba(160,185,220,0.7)',
    }}>FT</span>
  );
  return (
    <span style={{
      padding: '3px 8px', background: 'rgba(59,130,246,0.10)',
      border: '1px solid rgba(59,130,246,0.35)', borderRadius: 3,
      fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800,
      letterSpacing: '0.18em', color: '#7dd3fc',
    }}>SCHED</span>
  );
}

function LeagueBadge({ leagueId }: { leagueId: string }) {
  const lg = LEAGUES.find(l => l.id === leagueId);
  if (!lg) return null;
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '4px 9px', background: `${lg.accent}18`, color: lg.accent,
      border: `1px solid ${lg.accent}40`, borderRadius: 3,
      fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800, letterSpacing: '0.18em',
    }}>
      <span>{lg.flag}</span>{lg.abbr}
    </span>
  );
}

// ─── Isometric Stadium (SVG) ──────────────────────────────────────────────────
function IsoStadium({ homeTeam, awayTeam, venue }: { homeTeam: string; awayTeam: string; venue: string }) {
  const home = clubByName(homeTeam);
  const away = clubByName(awayTeam);
  const homeC = home?.color || '#3b82f6';
  const awayC = away?.color || '#ef4444';
  const w = 700, h = 380;
  const pitch = { x: w * 0.18, y: h * 0.30, w: w * 0.64, h: h * 0.50 };

  return (
    <svg viewBox={`0 0 ${w} ${h}`} width="100%" style={{ display: 'block', borderRadius: 6 }}>
      <defs>
        <linearGradient id="skyG" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#0a1828" />
          <stop offset="100%" stopColor="#060a12" />
        </linearGradient>
        <linearGradient id="pitchG" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#15573a" />
          <stop offset="100%" stopColor="#0d3a26" />
        </linearGradient>
        <linearGradient id="bowlH" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={homeC} stopOpacity="0.55" />
          <stop offset="100%" stopColor={homeC} stopOpacity="0.18" />
        </linearGradient>
        <linearGradient id="bowlA" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={awayC} stopOpacity="0.55" />
          <stop offset="100%" stopColor={awayC} stopOpacity="0.18" />
        </linearGradient>
        <pattern id="seats" width="6" height="4" patternUnits="userSpaceOnUse">
          <circle cx="3" cy="2" r="0.6" fill="#fff" fillOpacity="0.18" />
        </pattern>
        <pattern id="stripes" width="40" height="20" patternUnits="userSpaceOnUse">
          <rect width="40" height="20" fill="url(#pitchG)" />
          <rect width="20" height="20" fill="#000" fillOpacity="0.07" />
        </pattern>
      </defs>
      <rect width={w} height={h} fill="url(#skyG)" />
      {/* Home stand */}
      <path d={`M ${pitch.x - 60} ${pitch.y + pitch.h + 24}
                L ${pitch.x - 22} ${pitch.y - 16}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y - 30}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y + pitch.h + 38}
                L ${pitch.x - 22} ${pitch.y + pitch.h + 46} Z`}
        fill="url(#bowlH)" stroke={homeC} strokeOpacity="0.4" strokeWidth="1" />
      <path d={`M ${pitch.x - 60} ${pitch.y + pitch.h + 24}
                L ${pitch.x - 22} ${pitch.y - 16}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y - 30}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y + pitch.h + 38}
                L ${pitch.x - 22} ${pitch.y + pitch.h + 46} Z`}
        fill="url(#seats)" opacity="0.7" />
      {/* Away stand */}
      <path d={`M ${pitch.x + pitch.w * 0.5} ${pitch.y - 30}
                L ${pitch.x + pitch.w + 22} ${pitch.y - 16}
                L ${pitch.x + pitch.w + 60} ${pitch.y + pitch.h + 24}
                L ${pitch.x + pitch.w + 22} ${pitch.y + pitch.h + 46}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y + pitch.h + 38} Z`}
        fill="url(#bowlA)" stroke={awayC} strokeOpacity="0.4" strokeWidth="1" />
      <path d={`M ${pitch.x + pitch.w * 0.5} ${pitch.y - 30}
                L ${pitch.x + pitch.w + 22} ${pitch.y - 16}
                L ${pitch.x + pitch.w + 60} ${pitch.y + pitch.h + 24}
                L ${pitch.x + pitch.w + 22} ${pitch.y + pitch.h + 46}
                L ${pitch.x + pitch.w * 0.5} ${pitch.y + pitch.h + 38} Z`}
        fill="url(#seats)" opacity="0.7" />
      {/* Pitch */}
      <rect x={pitch.x} y={pitch.y} width={pitch.w} height={pitch.h}
        fill="url(#stripes)" stroke="rgba(255,255,255,0.6)" strokeWidth="1.5" />
      <line x1={pitch.x + pitch.w * 0.5} y1={pitch.y}
            x2={pitch.x + pitch.w * 0.5} y2={pitch.y + pitch.h}
        stroke="rgba(255,255,255,0.6)" strokeWidth="1" />
      <circle cx={pitch.x + pitch.w * 0.5} cy={pitch.y + pitch.h * 0.5} r={pitch.h * 0.15}
        fill="none" stroke="rgba(255,255,255,0.5)" strokeWidth="1" />
      <rect x={pitch.x} y={pitch.y + pitch.h * 0.22} width={pitch.w * 0.12} height={pitch.h * 0.56}
        fill="none" stroke="rgba(255,255,255,0.5)" strokeWidth="1" />
      <rect x={pitch.x + pitch.w * 0.88} y={pitch.y + pitch.h * 0.22} width={pitch.w * 0.12} height={pitch.h * 0.56}
        fill="none" stroke="rgba(255,255,255,0.5)" strokeWidth="1" />
      {/* Team labels */}
      <text x={pitch.x - 36} y={pitch.y - 38}
        fontFamily="'JetBrains Mono', monospace" fontSize="10" fontWeight="800"
        letterSpacing="2" fill={homeC} fillOpacity="0.9">HOME · {homeTeam.toUpperCase().substring(0, 14)}</text>
      <text x={pitch.x + pitch.w + 36} y={pitch.y - 38}
        fontFamily="'JetBrains Mono', monospace" fontSize="10" fontWeight="800"
        letterSpacing="2" fill={awayC} fillOpacity="0.9" textAnchor="end">AWAY · {awayTeam.toUpperCase().substring(0, 14)}</text>
      {venue && (
        <text x={pitch.x + pitch.w * 0.5} y={h - 10} textAnchor="middle"
          fontFamily="'JetBrains Mono', monospace" fontSize="9" letterSpacing="2.5"
          fill="rgba(160,185,220,0.45)">◈ {venue.toUpperCase()}</text>
      )}
    </svg>
  );
}

// ─── Match card (others grid) ─────────────────────────────────────────────────
function MatchCard({ fix, onClick }: { fix: FixtureItem; onClick: (f: FixtureItem) => void }) {
  const homeClub = clubByName(fix.homeTeam);
  const awayClub = clubByName(fix.awayTeam);
  const lg = LEAGUES.find(l => l.id === fix.leagueId);
  return (
    <div onClick={() => onClick(fix)} style={{
      padding: '12px 14px', background: 'rgba(0,0,0,0.25)',
      border: '1px solid rgba(255,255,255,0.08)',
      borderLeft: `3px solid ${lg?.accent || '#3b82f6'}`,
      borderRadius: 6, cursor: 'pointer',
    }}
      onMouseEnter={e => (e.currentTarget as HTMLDivElement).style.borderColor = 'rgba(59,130,246,0.35)'}
      onMouseLeave={e => (e.currentTarget as HTMLDivElement).style.borderColor = 'rgba(255,255,255,0.08)'}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
        <LeagueBadge leagueId={fix.leagueId} />
        <StatePill state={fix.state} minute={fix.minute} />
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8, marginBottom: 4 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, minWidth: 0, flex: 1 }}>
          <ClubInitials name={fix.homeTeam} color={homeClub?.color} size={18} />
          <span style={{ fontSize: 12, fontWeight: 700, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{fix.homeTeam}</span>
        </div>
        <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 13, fontWeight: 800, color: fix.state === 'scheduled' ? 'rgba(160,185,220,0.45)' : '#e8edf5', minWidth: 14, textAlign: 'right' }}>
          {fix.state === 'scheduled' ? '—' : fix.homeScore}
        </span>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, minWidth: 0, flex: 1 }}>
          <ClubInitials name={fix.awayTeam} color={awayClub?.color} size={18} />
          <span style={{ fontSize: 12, fontWeight: 700, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{fix.awayTeam}</span>
        </div>
        <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 13, fontWeight: 800, color: fix.state === 'scheduled' ? 'rgba(160,185,220,0.45)' : '#e8edf5', minWidth: 14, textAlign: 'right' }}>
          {fix.state === 'scheduled' ? '—' : fix.awayScore}
        </span>
      </div>
      {fix.state === 'scheduled' && (
        <div style={{ marginTop: 6, fontFamily: "'JetBrains Mono', monospace", fontSize: 10, color: '#7dd3fc', fontWeight: 700 }}>
          {fix.kickoff} · {fix.date.slice(5).replace('-', '/')}
        </div>
      )}
    </div>
  );
}

// ─── Week helpers ─────────────────────────────────────────────────────────────
function weekFromDate(offset: number): string {
  const d = new Date();
  d.setDate(d.getDate() + offset * 7);
  return d.toISOString().slice(0, 10);
}

function weekLabel(offset: number): string {
  if (offset === 0) return 'This Week';
  if (offset === -1) return 'Last Week';
  const from = new Date();
  from.setDate(from.getDate() + offset * 7);
  const to = new Date(from);
  to.setDate(to.getDate() + 6);
  const fmt = (d: Date) => `${d.getMonth() + 1}/${d.getDate()}`;
  return `${fmt(from)} – ${fmt(to)}`;
}

// ─── Schedule — S1d Editorial ─────────────────────────────────────────────────
function ScheduleEditorial({ fixtures, onMatchOpen, leagueFilter, onLeagueFilter, weekOffset, onPrev, onNext, onThisWeek }: {
  fixtures: FixtureItem[];
  onMatchOpen: (f: FixtureItem) => void;
  leagueFilter: string;
  onLeagueFilter: (id: string) => void;
  weekOffset: number;
  onPrev: () => void;
  onNext: () => void;
  onThisWeek: () => void;
}) {
  const visible = leagueFilter === 'all' ? fixtures : fixtures.filter(f => f.leagueId === leagueFilter);
  const hero = visible.find(f => f.state === 'live') || visible.find(f => f.state === 'scheduled') || visible[0];
  const others = visible.filter(f => f.id !== hero?.id);
  const homeClub = hero ? clubByName(hero.homeTeam) : null;
  const awayClub = hero ? clubByName(hero.awayTeam) : null;

  const navBtn: React.CSSProperties = {
    padding: '7px 14px', cursor: 'pointer', background: 'transparent',
    color: 'rgba(160,185,220,0.7)', border: '1px solid rgba(255,255,255,0.08)',
    borderRadius: 4, fontFamily: "'JetBrains Mono', monospace", fontSize: 10,
    fontWeight: 700, letterSpacing: '0.15em',
  };

  return (
    <div>
      {/* Sub-header */}
      <div style={{
        padding: '14px 24px', borderBottom: '1px solid rgba(255,255,255,0.08)',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <div>
          <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.25em', color: 'rgba(160,185,220,0.45)', marginBottom: 3 }}>
            ◈ FIXTURES · EDITORIAL
          </div>
          <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>
            Match of the Day <span style={{ color: 'rgba(160,185,220,0.45)', fontWeight: 500, fontSize: 13 }}>· this week</span>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 6 }}>
          <button style={navBtn} onClick={onPrev}>‹ Prev</button>
          <button onClick={onThisWeek} style={{ ...navBtn, background: weekOffset === 0 ? 'rgba(59,130,246,0.18)' : 'transparent', color: weekOffset === 0 ? '#7dd3fc' : 'rgba(160,185,220,0.7)', border: `1px solid ${weekOffset === 0 ? 'rgba(59,130,246,0.5)' : 'rgba(255,255,255,0.08)'}` }}>
            {weekLabel(weekOffset)}
          </button>
          <button style={navBtn} onClick={onNext}>Next ›</button>
        </div>
      </div>

      {/* Top ad — above league filter */}
      <div style={{ padding: '12px 24px 0' }}>
        <AdSlot slot={SLOT.LEADERBOARD} style={{ minHeight: 90 }} />
      </div>

      {/* League filter */}
      <div style={{ padding: '10px 24px', borderBottom: '1px solid rgba(255,255,255,0.08)', display: 'flex', gap: 6, flexWrap: 'wrap' }}>
        {[{ id: 'all', abbr: 'All', flag: '🌍', accent: '#3b82f6' }, ...LEAGUES].map(lg => (
          <button key={lg.id} onClick={() => onLeagueFilter(lg.id)} style={{
            padding: '5px 11px', cursor: 'pointer', borderRadius: 999,
            fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
            background: leagueFilter === lg.id ? `${'accent' in lg ? lg.accent : '#3b82f6'}22` : 'transparent',
            color: leagueFilter === lg.id ? ('accent' in lg ? lg.accent : '#3b82f6') : 'rgba(160,185,220,0.7)',
            border: `1px solid ${leagueFilter === lg.id ? ('accent' in lg ? `${lg.accent}66` : '#3b82f666') : 'rgba(255,255,255,0.08)'}`,
          }}>
            <span style={{ marginRight: 4 }}>{lg.flag}</span>{lg.abbr}
          </button>
        ))}
      </div>

      {/* Hero */}
      {hero ? (
        <div style={{
          position: 'relative', padding: '36px 48px',
          background: `
            radial-gradient(ellipse at 25% 50%, ${homeClub?.color || '#3b82f6'}28 0%, transparent 55%),
            radial-gradient(ellipse at 75% 50%, ${awayClub?.color || '#ef4444'}28 0%, transparent 55%),
            #060a12
          `,
          minHeight: 260, overflow: 'hidden', borderBottom: '1px solid rgba(255,255,255,0.08)',
        }}>
          {/* Watermark initials */}
          <div style={{
            position: 'absolute', left: '4%', top: '50%', transform: 'translateY(-50%)',
            fontFamily: "'JetBrains Mono', monospace", fontSize: 180, fontWeight: 800,
            color: homeClub?.color || '#3b82f6', opacity: 0.12, letterSpacing: -10, lineHeight: 0.85, pointerEvents: 'none',
          }}>{hero.homeTeam.split(' ').map(w => w[0]).slice(0, 2).join('')}</div>
          <div style={{
            position: 'absolute', right: '4%', top: '50%', transform: 'translateY(-50%)',
            fontFamily: "'JetBrains Mono', monospace", fontSize: 180, fontWeight: 800,
            color: awayClub?.color || '#ef4444', opacity: 0.12, letterSpacing: -10, lineHeight: 0.85, pointerEvents: 'none',
          }}>{hero.awayTeam.split(' ').map(w => w[0]).slice(0, 2).join('')}</div>

          <div style={{ position: 'relative', zIndex: 2 }}>
            <div style={{ display: 'flex', gap: 10, alignItems: 'center', marginBottom: 20 }}>
              <LeagueBadge leagueId={hero.leagueId} />
              <StatePill state={hero.state} minute={hero.minute} />
              {hero.venue && (
                <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, color: 'rgba(160,185,220,0.45)', letterSpacing: '0.18em' }}>
                  MD {hero.matchday} · {hero.venue.toUpperCase().substring(0, 24)}
                </span>
              )}
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr auto 1fr', alignItems: 'center', gap: 24 }}>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.22em', color: homeClub?.color || '#3b82f6', marginBottom: 6 }}>HOME</div>
                <div style={{ fontSize: 38, fontWeight: 800, letterSpacing: -1, lineHeight: 1 }}>{hero.homeTeam}</div>
              </div>
              <div style={{ textAlign: 'center', minWidth: 120 }}>
                {hero.state === 'scheduled' ? (
                  <>
                    <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 38, fontWeight: 800, letterSpacing: -1, color: '#7dd3fc' }}>{hero.kickoff}</div>
                    <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, color: 'rgba(160,185,220,0.45)', letterSpacing: '0.22em', marginTop: 4 }}>KICKOFF · {hero.date.slice(5)}</div>
                  </>
                ) : (
                  <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 52, fontWeight: 800, letterSpacing: -2 }}>
                    <span style={{ color: hero.state === 'finished' ? (hero.homeScore! > hero.awayScore! ? '#e8edf5' : 'rgba(160,185,220,0.5)') : '#e8edf5' }}>{hero.homeScore}</span>
                    <span style={{ color: 'rgba(160,185,220,0.35)', margin: '0 8px' }}>–</span>
                    <span style={{ color: hero.state === 'finished' ? (hero.awayScore! > hero.homeScore! ? '#e8edf5' : 'rgba(160,185,220,0.5)') : '#e8edf5' }}>{hero.awayScore}</span>
                    {hero.state === 'live' && (
                      <div style={{ fontSize: 12, color: '#fca5a5', fontWeight: 700, letterSpacing: '0.1em', marginTop: 4 }}>{hero.minute}'</div>
                    )}
                  </div>
                )}
              </div>
              <div style={{ textAlign: 'left' }}>
                <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.22em', color: awayClub?.color || '#ef4444', marginBottom: 6 }}>AWAY</div>
                <div style={{ fontSize: 38, fontWeight: 800, letterSpacing: -1, lineHeight: 1 }}>{hero.awayTeam}</div>
              </div>
            </div>

            <div style={{ marginTop: 24, textAlign: 'center' }}>
              <button onClick={() => onMatchOpen(hero)} style={{
                padding: '9px 20px', cursor: 'pointer',
                background: 'rgba(59,130,246,0.18)', color: '#7dd3fc',
                border: '1px solid rgba(59,130,246,0.5)', borderRadius: 4,
                fontFamily: "'JetBrains Mono', monospace", fontSize: 11, fontWeight: 700, letterSpacing: '0.2em',
              }}>OPEN MATCH CENTER →</button>
            </div>
          </div>
        </div>
      ) : (
        <div style={{ padding: '60px 24px', textAlign: 'center', color: 'rgba(160,185,220,0.45)', fontFamily: "'JetBrains Mono', monospace", letterSpacing: '0.2em' }}>
          NO FIXTURES THIS WEEK
        </div>
      )}

      {/* Elsewhere this week */}
      {others.length > 0 && (
        <div style={{ padding: '20px 24px' }}>
          <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800, letterSpacing: '0.22em', color: 'rgba(160,185,220,0.45)', marginBottom: 14 }}>
            ◈ ELSEWHERE THIS WEEK
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(240px, 1fr))', gap: 10 }}>
            {others.flatMap((f, i) => {
              const card = <MatchCard key={f.id} fix={f} onClick={onMatchOpen} />;
              const adSlot = i === 2 ? SLOT.FEED_NATIVE
                           : i === 6 ? SLOT.FEED_NATIVE_2
                           : i === 10 ? SLOT.FEED_NATIVE_3
                           : null;
              if (adSlot && i < others.length - 1) {
                return [card, (
                  <div key={`ad-${i}`} style={{
                    gridColumn: 'span 2',
                    padding: '12px 14px',
                    background: 'rgba(0,0,0,0.25)',
                    border: '1px solid rgba(255,255,255,0.08)',
                    borderLeft: '3px solid rgba(160,185,220,0.35)',
                    borderRadius: 6,
                    display: 'flex', flexDirection: 'column',
                    overflow: 'hidden', minWidth: 0,
                  }}>
                    <div style={{
                      fontFamily: "'JetBrains Mono', monospace",
                      fontSize: 9, fontWeight: 800, letterSpacing: '0.22em',
                      color: 'rgba(160,185,220,0.45)', marginBottom: 8,
                    }}>◈ SPONSORED</div>
                    <div style={{ display: 'flex', justifyContent: 'center', overflow: 'hidden' }}>
                      <AdSlot slot={adSlot} style={{ minHeight: 100, width: 320, maxWidth: '100%' }} />
                    </div>
                  </div>
                )];
              }
              return [card];
            })}
          </div>
        </div>
      )}
    </div>
  );
}

// ─── Standings ────────────────────────────────────────────────────────────────
function StandingsView({ leagueId, standings, loading }: { leagueId: string; standings: StandingItem[]; loading: boolean }) {
  if (loading) return (
    <div style={{ padding: '60px 24px', textAlign: 'center', fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.45)' }}>
      LOADING STANDINGS...
    </div>
  );

  return (
    <div style={{ padding: '20px 24px' }}>
      <div style={{ overflowX: 'auto' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr>
              {['#', 'Club', 'P', 'W', 'D', 'L', 'GD', 'Pts', 'Form'].map((h, i) => (
                <th key={i} style={{
                  padding: '8px 8px', fontFamily: "'JetBrains Mono', monospace",
                  fontSize: 9, fontWeight: 800, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.45)',
                  textAlign: i <= 1 ? 'left' : 'center', borderBottom: '1px solid rgba(255,255,255,0.08)',
                }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {standings.map((row, i) => {
              const color = bandColor(row.rank, leagueId);
              const club  = CLUBS.find(c => c.name.toLowerCase().includes(row.teamName.toLowerCase()) ||
                row.teamName.toLowerCase().includes(c.name.toLowerCase()));
              return (
                <tr key={i} style={{ background: i % 2 === 0 ? 'transparent' : 'rgba(0,0,0,0.12)' }}>
                  <td style={{ padding: '9px 8px', borderBottom: '1px solid rgba(255,255,255,0.06)', fontFamily: "'JetBrains Mono', monospace', fontWeight: 800" }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                      {color && <span style={{ width: 3, height: 18, background: color, borderRadius: 2, display: 'inline-block' }} />}
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontWeight: 800, background: color ? `${color}12` : 'transparent', color: color || 'inherit', padding: '1px 3px', borderRadius: 2 }}>{row.rank}</span>
                    </div>
                  </td>
                  <td style={{ padding: '9px 8px', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <ClubInitials name={row.teamName} color={club?.color} size={20} />
                      <span style={{ fontWeight: 700 }}>{row.teamName}</span>
                    </div>
                  </td>
                  {[row.played, row.won, row.drawn, row.lost].map((v, j) => (
                    <td key={j} style={{ padding: '9px 8px', textAlign: 'center', borderBottom: '1px solid rgba(255,255,255,0.06)', fontFamily: "'JetBrains Mono', monospace" }}>{v}</td>
                  ))}
                  <td style={{ padding: '9px 8px', textAlign: 'center', borderBottom: '1px solid rgba(255,255,255,0.06)', fontFamily: "'JetBrains Mono', monospace", fontWeight: 700, color: row.goalsDiff >= 0 ? '#86efac' : '#fca5a5' }}>
                    {row.goalsDiff > 0 ? '+' : ''}{row.goalsDiff}
                  </td>
                  <td style={{ padding: '9px 8px', textAlign: 'center', borderBottom: '1px solid rgba(255,255,255,0.06)', fontFamily: "'JetBrains Mono', monospace", fontWeight: 800, fontSize: 14 }}>{row.points}</td>
                  <td style={{ padding: '9px 8px', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
                    <div style={{ display: 'flex', gap: 3 }}>
                      {row.form.split('').map((r, j) => (
                        <span key={j} style={{
                          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                          width: 16, height: 16, borderRadius: 3,
                          background: r === 'W' ? '#22c55e22' : r === 'D' ? '#94a3b822' : '#ef444422',
                          color: r === 'W' ? '#22c55e' : r === 'D' ? '#94a3b8' : '#ef4444',
                          fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800,
                        }}>{r}</span>
                      ))}
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
      {/* Legend */}
      <div style={{ marginTop: 16, display: 'flex', gap: 16, flexWrap: 'wrap', fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 700, letterSpacing: '0.15em', color: 'rgba(160,185,220,0.45)' }}>
        {[['#3b82f6', 'CHAMPIONS LEAGUE'], ['#f59e0b', 'EUROPA LEAGUE'], ['#22c55e', 'CONFERENCE'], ['#ef4444', 'RELEGATION']].map(([c, l]) => (
          <span key={l} style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
            <span style={{ width: 8, height: 8, background: c, borderRadius: 2, display: 'inline-block' }} />{l}
          </span>
        ))}
      </div>
    </div>
  );
}

// ─── Match Detail ─────────────────────────────────────────────────────────────
function MatchDetailView({ fix, onBack }: { fix: FixtureItem; onBack: () => void }) {
  const [tab, setTab] = useState<'events' | 'stats' | 'lineup' | 'info'>('events');
  const homeClub = clubByName(fix.homeTeam);
  const awayClub = clubByName(fix.awayTeam);

  const [events,  setEvents]  = useState<MatchEventItem[]>([]);
  const [stats,   setStats]   = useState<MatchStatItem | null>(null);
  const [lineups, setLineups] = useState<MatchLineupItem[]>([]);

  useEffect(() => {
    if (fix.state === 'scheduled') return;
    fetchMatchEvents(fix.id).then(setEvents).catch(() => {});
    fetchMatchStats(fix.id).then(s => { if (s) setStats(s); }).catch(() => {});
  }, [fix.id, fix.state]);

  useEffect(() => {
    fetchMatchLineups(fix.id).then(setLineups).catch(() => {});
  }, [fix.id]);

  const tabs: { id: typeof tab; label: string }[] = [
    { id: 'events', label: 'EVENTS' },
    { id: 'stats',  label: 'STATS' },
    { id: 'lineup', label: 'LINEUP' },
    { id: 'info',   label: 'INFO' },
  ];

  return (
    <div style={{ minHeight: '100%', background: '#060a12', color: '#e8edf5' }}>
      {/* Top nav */}
      <div style={{ padding: '14px 24px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
        <button onClick={onBack} style={{
          background: 'transparent', color: 'rgba(160,185,220,0.7)', border: '1px solid rgba(255,255,255,0.08)',
          padding: '6px 12px', borderRadius: 4, cursor: 'pointer',
          fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.15em',
        }}>← FIXTURES</button>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          <LeagueBadge leagueId={fix.leagueId} />
          <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, color: 'rgba(160,185,220,0.45)', letterSpacing: '0.18em' }}>
            MD {fix.matchday} · {fix.date}
          </span>
        </div>
      </div>

      {/* Score header */}
      <div style={{ padding: '20px 24px', display: 'grid', gridTemplateColumns: '1fr auto 1fr', alignItems: 'center', gap: 24, borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
        <div style={{ textAlign: 'right', display: 'flex', alignItems: 'center', gap: 14, justifyContent: 'flex-end' }}>
          <div>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.2em', color: homeClub?.color || '#3b82f6', marginBottom: 4 }}>HOME</div>
            <div style={{ fontSize: 26, fontWeight: 800, letterSpacing: -0.6 }}>{fix.homeTeam}</div>
          </div>
          <ClubInitials name={fix.homeTeam} color={homeClub?.color} size={52} />
        </div>
        <div style={{ textAlign: 'center', minWidth: 150 }}>
          {fix.state === 'scheduled' ? (
            <>
              <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 30, fontWeight: 800, color: '#7dd3fc' }}>{fix.kickoff}</div>
              <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, color: 'rgba(160,185,220,0.45)', letterSpacing: '0.2em', marginTop: 4 }}>KICKOFF</div>
            </>
          ) : (
            <>
              <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 44, fontWeight: 800, letterSpacing: -2 }}>
                {fix.homeScore} <span style={{ color: 'rgba(160,185,220,0.3)' }}>–</span> {fix.awayScore}
              </div>
              <StatePill state={fix.state} minute={fix.minute} />
            </>
          )}
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          <ClubInitials name={fix.awayTeam} color={awayClub?.color} size={52} />
          <div>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.2em', color: awayClub?.color || '#ef4444', marginBottom: 4 }}>AWAY</div>
            <div style={{ fontSize: 26, fontWeight: 800, letterSpacing: -0.6 }}>{fix.awayTeam}</div>
          </div>
        </div>
      </div>

      {/* Stadium */}
      <div style={{ padding: '0 24px 0' }}>
        <IsoStadium homeTeam={fix.homeTeam} awayTeam={fix.awayTeam} venue={fix.venue} />
      </div>

      {/* Tabs */}
      <div style={{ display: 'flex', borderBottom: '1px solid rgba(255,255,255,0.08)', padding: '0 24px' }}>
        {tabs.map(t => (
          <button key={t.id} onClick={() => setTab(t.id)} style={{
            padding: '10px 16px', background: 'transparent', cursor: 'pointer',
            color: tab === t.id ? '#7dd3fc' : 'rgba(160,185,220,0.5)',
            border: 'none', borderBottom: `2px solid ${tab === t.id ? '#3b82f6' : 'transparent'}`,
            fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800, letterSpacing: '0.18em',
          }}>{t.label}</button>
        ))}
      </div>

      {/* Tab content */}
      <div style={{ padding: '16px 24px' }}>
        {tab === 'events' && (
          events.length === 0 ? (
            <div style={{ padding: '40px 0', textAlign: 'center', color: 'rgba(160,185,220,0.45)', fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.2em' }}>
              {fix.state === 'scheduled' ? 'KICKOFF PENDING' : 'NO EVENTS'}
            </div>
          ) : (
            <div>
              {events.map((ev, i) => {
                const isHome = ev.teamName === fix.homeTeam ||
                  fix.homeTeam.toLowerCase().includes(ev.teamName.toLowerCase()) ||
                  ev.teamName.toLowerCase().includes(fix.homeTeam.toLowerCase());
                const typeColor: Record<string, string> = { goal: '#22c55e', yellow: '#facc15', red: '#ef4444', sub: '#a78bfa' };
                const c = typeColor[ev.type] || 'rgba(160,185,220,0.45)';
                return (
                  <div key={i} style={{ display: 'grid', gridTemplateColumns: '1fr 56px 1fr', alignItems: 'center', padding: '7px 0', borderBottom: i < events.length - 1 ? '1px solid rgba(255,255,255,0.06)' : 'none' }}>
                    <div style={{ textAlign: 'right', paddingRight: 12 }}>
                      {isHome && (
                        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8 }}>
                          <span style={{ display: 'inline-flex', width: 16, height: 16, borderRadius: 3, background: `${c}22`, border: `1px solid ${c}55`, alignItems: 'center', justifyContent: 'center', fontSize: 9 }}>
                            {ev.type === 'goal' ? '⚽' : ev.type === 'yellow' ? '■' : ev.type === 'red' ? '■' : '⇄'}
                          </span>
                          <div>
                            <div style={{ fontSize: 12, fontWeight: 700 }}>{ev.player}</div>
                            {ev.detail && <div style={{ fontSize: 10, color: 'rgba(160,185,220,0.55)', fontFamily: "'JetBrains Mono', monospace" }}>{ev.detail}</div>}
                          </div>
                        </div>
                      )}
                    </div>
                    <div style={{ textAlign: 'center', fontFamily: "'JetBrains Mono', monospace", fontSize: 11, fontWeight: 800, color: '#7dd3fc' }}>{ev.minute}'</div>
                    <div style={{ paddingLeft: 12 }}>
                      {!isHome && (
                        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8 }}>
                          <span style={{ display: 'inline-flex', width: 16, height: 16, borderRadius: 3, background: `${c}22`, border: `1px solid ${c}55`, alignItems: 'center', justifyContent: 'center', fontSize: 9 }}>
                            {ev.type === 'goal' ? '⚽' : ev.type === 'yellow' ? '■' : ev.type === 'red' ? '■' : '⇄'}
                          </span>
                          <div>
                            <div style={{ fontSize: 12, fontWeight: 700 }}>{ev.player}</div>
                            {ev.detail && <div style={{ fontSize: 10, color: 'rgba(160,185,220,0.55)', fontFamily: "'JetBrains Mono', monospace" }}>{ev.detail}</div>}
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          )
        )}

        {tab === 'stats' && (
          stats ? (
            <div>
              {(([
                ['Possession', stats.possession, true],
                ['Shots', stats.shots, false],
                ['On Target', stats.shotsOnTarget, false],
                ['xG', stats.xG, false],
                ['Passes', stats.passes, false],
                ['Corners', stats.corners, false],
              ]) as [string, [number, number], boolean][]).map(([label, [h, a], isPct], i) => {
                const total = isPct ? 100 : (h as number) + (a as number);
                const hPct  = isPct ? h as number : ((h as number) / total) * 100;
                const aPct  = isPct ? a as number : ((a as number) / total) * 100;
                return (
                  <div key={i} style={{ padding: '10px 0', borderBottom: i < 5 ? '1px solid rgba(255,255,255,0.06)' : 'none' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 5 }}>
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontWeight: 800, fontSize: 14 }}>{h}{isPct ? '%' : ''}</span>
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.45)', textTransform: 'uppercase' }}>{label as string}</span>
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontWeight: 800, fontSize: 14 }}>{a}{isPct ? '%' : ''}</span>
                    </div>
                    <div style={{ display: 'flex', gap: 2, height: 4 }}>
                      <div style={{ flex: hPct, background: homeClub?.color || '#3b82f6', borderRadius: 2 }} />
                      <div style={{ flex: aPct, background: awayClub?.color || '#ef4444', borderRadius: 2 }} />
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div style={{ padding: '40px 0', textAlign: 'center', color: 'rgba(160,185,220,0.45)', fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.2em' }}>
              {fix.state === 'scheduled' ? 'KICKOFF PENDING · NO STATS' : 'STATS UNAVAILABLE'}
            </div>
          )
        )}

        {tab === 'lineup' && (
          lineups.length === 0 ? (
            <div style={{ padding: '40px 0', textAlign: 'center', color: 'rgba(160,185,220,0.45)', fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.2em' }}>
              {fix.state === 'scheduled' ? 'LINEUP NOT CONFIRMED' : 'LINEUP UNAVAILABLE'}
            </div>
          ) : (
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              {lineups.map((team, ti) => (
                <div key={ti}>
                  <div style={{ marginBottom: 10 }}>
                    <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.2em', color: ti === 0 ? homeClub?.color || '#3b82f6' : awayClub?.color || '#ef4444', marginBottom: 2 }}>
                      {ti === 0 ? 'HOME' : 'AWAY'}
                    </div>
                    <div style={{ fontSize: 12, fontWeight: 700, marginBottom: 2 }}>{team.teamName}</div>
                    <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, color: 'rgba(160,185,220,0.45)', letterSpacing: '0.15em' }}>{team.formation}</div>
                  </div>
                  <div style={{ marginBottom: 8, fontFamily: "'JetBrains Mono', monospace", fontSize: 8, fontWeight: 800, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.3)' }}>STARTING XI</div>
                  {team.startXI.map((p, pi) => (
                    <div key={pi} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '5px 0', borderBottom: '1px solid rgba(255,255,255,0.04)' }}>
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800, color: 'rgba(160,185,220,0.4)', width: 22, textAlign: 'right', flexShrink: 0 }}>{p.number}</span>
                      <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 8, fontWeight: 700, color: 'rgba(160,185,220,0.5)', width: 14, flexShrink: 0 }}>{p.pos}</span>
                      <span style={{ fontSize: 12, fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{p.name}</span>
                    </div>
                  ))}
                  {team.substitutes.length > 0 && (
                    <>
                      <div style={{ marginTop: 10, marginBottom: 6, fontFamily: "'JetBrains Mono', monospace", fontSize: 8, fontWeight: 800, letterSpacing: '0.2em', color: 'rgba(160,185,220,0.3)' }}>SUBS</div>
                      {team.substitutes.map((p, pi) => (
                        <div key={pi} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 0', borderBottom: '1px solid rgba(255,255,255,0.04)' }}>
                          <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 800, color: 'rgba(160,185,220,0.25)', width: 22, textAlign: 'right', flexShrink: 0 }}>{p.number}</span>
                          <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 8, fontWeight: 700, color: 'rgba(160,185,220,0.3)', width: 14, flexShrink: 0 }}>{p.pos}</span>
                          <span style={{ fontSize: 11, fontWeight: 500, color: 'rgba(232,237,245,0.6)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{p.name}</span>
                        </div>
                      ))}
                    </>
                  )}
                </div>
              ))}
            </div>
          )
        )}

        {tab === 'info' && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {[
              ['Venue', fix.venue || '—'],
              ['Date', fix.date],
              ['Kickoff', fix.kickoff],
              ['Referee', fix.referee || '—'],
              ['Matchday', String(fix.matchday)],
            ].map(([k, v]) => (
              <div key={k} style={{ display: 'flex', justifyContent: 'space-between', padding: '10px 0', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
                <span style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 700, letterSpacing: '0.18em', color: 'rgba(160,185,220,0.45)', textTransform: 'uppercase' }}>{k}</span>
                <span style={{ fontSize: 13, fontWeight: 600 }}>{v}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// ─── Main FixturesPage ─────────────────────────────────────────────────────────
type ViewType = 'schedule' | 'standings' | 'detail';

export default function FixturesPage() {
  const navigate = useNavigate();
  const [view, setView] = useState<ViewType>('schedule');
  const [leagueFilter, setLeagueFilter] = useState('all');
  const [standingsLeague, setStandingsLeague] = useState('pl');
  const [selectedMatch, setSelectedMatch] = useState<FixtureItem | null>(null);

  const [fixtures, setFixtures] = useState<FixtureItem[]>(MOCK_FIXTURES);
  const [standings, setStandings] = useState<StandingItem[]>([]);
  const [standingsLoading, setStandingsLoading] = useState(false);
  const [weekOffset, setWeekOffset] = useState(0);

  useEffect(() => {
    let alive = true;
    const from = weekOffset !== 0 ? weekFromDate(weekOffset) : undefined;
    fetchWeekFixtures(leagueFilter === 'all' ? 'pl' : leagueFilter, from)
      .then(data => { if (alive && data.length) setFixtures(data); })
      .catch(() => {});
    return () => { alive = false; };
  }, [leagueFilter, weekOffset]);

  useEffect(() => {
    if (view !== 'standings') return;
    setStandingsLoading(true);
    fetchStandings(standingsLeague)
      .then(data => {
        if (data.length) setStandings(data);
        else setStandings(MOCK_STANDINGS[standingsLeague] || []);
      })
      .catch(() => setStandings(MOCK_STANDINGS[standingsLeague] || []))
      .finally(() => setStandingsLoading(false));
  }, [view, standingsLeague]);

  const handleMatchOpen = useCallback((f: FixtureItem) => {
    setSelectedMatch(f);
    setView('detail');
  }, []);

  const handleBack = useCallback(() => {
    setSelectedMatch(null);
    setView('schedule');
  }, []);

  const navBtnBase: React.CSSProperties = {
    padding: '8px 16px', cursor: 'pointer', background: 'transparent',
    border: '1px solid rgba(255,255,255,0.08)', borderRadius: 4,
    fontFamily: "'JetBrains Mono', monospace", fontSize: 10, fontWeight: 700,
    letterSpacing: '0.18em', transition: 'all 120ms',
  };
  const navBtnActive: React.CSSProperties = {
    ...navBtnBase, background: 'rgba(59,130,246,0.18)', color: '#7dd3fc',
    border: '1px solid rgba(59,130,246,0.5)',
  };
  const navBtnInactive: React.CSSProperties = {
    ...navBtnBase, color: 'rgba(160,185,220,0.7)',
  };

  return (
    <div style={{ width: '100vw', height: '100vh', overflow: 'auto', background: '#060a12', color: '#e8edf5', fontFamily: "'Helvetica Neue', Arial, sans-serif" }}>
      <Helmet>
        <title>Fixtures — TransferMap</title>
        <meta name="description" content="European football match fixtures, live scores and standings." />
      </Helmet>

      {/* Global topbar */}
      <div style={{
        position: 'sticky', top: 0, zIndex: 50,
        padding: '0 24px', height: 48, display: 'flex', alignItems: 'center',
        background: 'rgba(6,10,18,0.95)', borderBottom: '1px solid rgba(255,255,255,0.08)',
        backdropFilter: 'blur(12px)', gap: 24,
      }}>
        <button onClick={() => navigate('/')} style={{
          background: 'transparent', border: 'none', cursor: 'pointer', padding: 0,
          fontSize: '1.05rem', fontWeight: 900, letterSpacing: '0.25em', color: '#fff',
          textTransform: 'uppercase', textShadow: '0 0 20px rgba(100,160,255,0.8)',
        }}>
          Transfer<span style={{ color: '#3b82f6' }}>Map</span>
        </button>
        <div style={{ display: 'flex', gap: 6, flex: 1 }}>
          {view !== 'detail' && (
            <>
              <button style={view === 'schedule' ? navBtnActive : navBtnInactive} onClick={() => setView('schedule')}>SCHEDULE</button>
              <button style={view === 'standings' ? navBtnActive : navBtnInactive} onClick={() => setView('standings')}>STANDINGS</button>
            </>
          )}
        </div>
        {view === 'standings' && (
          <div style={{ display: 'flex', gap: 4 }}>
            {LEAGUES.map(lg => (
              <button key={lg.id} onClick={() => setStandingsLeague(lg.id)} style={{
                padding: '5px 10px', cursor: 'pointer', borderRadius: 3,
                fontFamily: "'JetBrains Mono', monospace", fontSize: 9, fontWeight: 800, letterSpacing: '0.15em',
                background: standingsLeague === lg.id ? `${lg.accent}22` : 'transparent',
                color: standingsLeague === lg.id ? lg.accent : 'rgba(160,185,220,0.5)',
                border: `1px solid ${standingsLeague === lg.id ? `${lg.accent}55` : 'rgba(255,255,255,0.08)'}`,
              }}>
                {lg.flag} {lg.abbr}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Content */}
      {view === 'detail' && selectedMatch ? (
        <MatchDetailView fix={selectedMatch} onBack={handleBack} />
      ) : view === 'standings' ? (
        <div>
          <div style={{ padding: '14px 24px', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 10, letterSpacing: '0.25em', color: 'rgba(160,185,220,0.45)', marginBottom: 3 }}>◈ STANDINGS</div>
            <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>
              {LEAGUES.find(l => l.id === standingsLeague)?.flag} {LEAGUES.find(l => l.id === standingsLeague)?.name}
              <span style={{ color: 'rgba(160,185,220,0.45)', fontWeight: 500, fontSize: 14, marginLeft: 10 }}>· 2025/26</span>
            </div>
          </div>
          <StandingsView leagueId={standingsLeague} standings={standings.length ? standings : MOCK_STANDINGS[standingsLeague] || []} loading={standingsLoading} />
        </div>
      ) : (
        <ScheduleEditorial
          fixtures={fixtures}
          onMatchOpen={handleMatchOpen}
          leagueFilter={leagueFilter}
          onLeagueFilter={setLeagueFilter}
          weekOffset={weekOffset}
          onPrev={() => setWeekOffset(o => o - 1)}
          onNext={() => setWeekOffset(o => o + 1)}
          onThisWeek={() => setWeekOffset(0)}
        />
      )}
    </div>
  );
}
