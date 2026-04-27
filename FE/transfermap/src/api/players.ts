import { apiFetch } from './client';
import type { ApiPlayer, ApiNewsItem } from './types';
import { mapNews, mapPlayer, mapTransferHistory } from './mappers';
import type { NewsItem, Player, TransferHistory } from '../types';

export async function fetchPlayer(id: number, signal?: AbortSignal): Promise<ApiPlayer> {
  return apiFetch<ApiPlayer>(`/players/${id}`, signal);
}

export async function fetchPlayersSearch(q: string, size = 8): Promise<Player[]> {
  if (!q.trim()) return [];
  const data = await apiFetch<ApiPlayer[]>(`/players/search?q=${encodeURIComponent(q)}&size=${size}`);
  return data.map(mapPlayer);
}

export async function fetchPlayerTransfers(id: number, signal?: AbortSignal): Promise<{
  history: TransferHistory[];
  news: NewsItem[];
}> {
  const data = await apiFetch<ApiNewsItem[]>(`/players/${id}/transfers`, signal);
  return {
    history: data.map(mapTransferHistory),
    news:    data.map(mapNews),
  };
}
