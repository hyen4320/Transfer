import { apiFetch } from './client';

export interface FixtureItem {
  id: number;
  leagueId: string;
  date: string;
  kickoff: string;
  state: 'scheduled' | 'live' | 'finished';
  minute: number;
  homeTeam: string;
  awayTeam: string;
  homeScore: number | null;
  awayScore: number | null;
  matchday: number;
  venue: string;
  referee: string;
}

export interface StandingItem {
  rank: number;
  teamName: string;
  played: number;
  won: number;
  drawn: number;
  lost: number;
  goalsFor: number;
  goalsAgainst: number;
  goalsDiff: number;
  points: number;
  form: string;
}

export async function fetchFixtures(leagueId: string, date?: string): Promise<FixtureItem[]> {
  const q = new URLSearchParams({ leagueId });
  if (date) q.set('date', date);
  return apiFetch<FixtureItem[]>(`/fixtures?${q}`);
}

export async function fetchWeekFixtures(leagueId: string, from?: string): Promise<FixtureItem[]> {
  const q = new URLSearchParams({ leagueId });
  if (from) q.set('from', from);
  return apiFetch<FixtureItem[]>(`/fixtures/week?${q}`);
}

export async function fetchStandings(leagueId: string, season?: number): Promise<StandingItem[]> {
  const q = season ? `?season=${season}` : '';
  return apiFetch<StandingItem[]>(`/standings/${leagueId}${q}`);
}

export interface MatchEventItem {
  minute: number;
  type: 'goal' | 'yellow' | 'red' | 'sub' | 'event';
  teamName: string;
  player: string;
  assist: string | null;
  detail: string;
}

export interface MatchStatItem {
  possession: [number, number];
  shots: [number, number];
  shotsOnTarget: [number, number];
  xG: [number, number];
  passes: [number, number];
  corners: [number, number];
}

export interface LineupPlayerItem {
  name: string;
  number: number;
  pos: string;
  grid: string | null;
}

export interface MatchLineupItem {
  teamName: string;
  formation: string;
  startXI: LineupPlayerItem[];
  substitutes: LineupPlayerItem[];
}

export async function fetchMatchEvents(fixtureId: number): Promise<MatchEventItem[]> {
  return apiFetch<MatchEventItem[]>(`/fixtures/${fixtureId}/events`);
}

export async function fetchMatchStats(fixtureId: number): Promise<MatchStatItem | null> {
  try { return await apiFetch<MatchStatItem>(`/fixtures/${fixtureId}/stats`); }
  catch { return null; }
}

export async function fetchMatchLineups(fixtureId: number): Promise<MatchLineupItem[]> {
  return apiFetch<MatchLineupItem[]>(`/fixtures/${fixtureId}/lineups`);
}
