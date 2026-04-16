import { apiFetch } from './client';
import type { ApiClub, ApiNewsItem } from './types';
import { mapNews } from './mappers';
import type { Club, NewsItem } from '../types';
import { LEAGUES } from '../data/mock';

/** BE leagueName → FE league string id */
const LEAGUE_NAME_TO_ID: Record<string, string> = {
  'Premier League': 'pl',
  'La Liga':        'll',
  'Bundesliga':     'bl',
  'Serie A':        'sa',
  'Ligue 1':        'l1',
};

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
