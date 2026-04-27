import { apiFetch } from './client';
import type { ApiClub, ApiNewsItem } from './types';
import { mapNews } from './mappers';
import type { Club, NewsItem } from '../types';
import { LEAGUES } from '../data/mock';
import { LEAGUE_NAME_TO_ID } from '../data/constants';

export function mapApiClub(c: ApiClub): Club {
  const leagueId = LEAGUE_NAME_TO_ID[c.leagueName ?? ''] ?? '';
  const league   = LEAGUES.find(l => l.id === leagueId);
  return {
    id:     c.id,
    name:   c.name,
    lon:    c.longitude,
    lat:    c.latitude,
    league: leagueId,
    color:  league?.accent ?? '#4b6cb7',
  };
}

export async function fetchAllClubs(): Promise<Club[]> {
  const data = await apiFetch<ApiClub[]>('/clubs');
  return data
    .filter(c => c.latitude != null && c.longitude != null)
    .map(mapApiClub);
}

export async function fetchClubsBySeason(season: number, leagueId?: number): Promise<Club[]> {
  const q = new URLSearchParams({ season: String(season) });
  if (leagueId != null) q.set('leagueId', String(leagueId));
  const data = await apiFetch<ApiClub[]>(`/clubs?${q}`);
  return data
    .filter(c => c.latitude != null && c.longitude != null)
    .map(mapApiClub);
}

export async function fetchClub(id: number): Promise<ApiClub> {
  return apiFetch<ApiClub>(`/clubs/${id}`);
}

export async function fetchClubTransfers(id: number): Promise<{
  incoming: NewsItem[];
  outgoing: NewsItem[];
}> {
  const data = await apiFetch<{ incoming: ApiNewsItem[]; outgoing: ApiNewsItem[] }>(
    `/clubs/${id}/transfers`
  );
  return {
    incoming: (data.incoming ?? []).map(mapNews),
    outgoing: (data.outgoing ?? []).map(mapNews),
  };
}
