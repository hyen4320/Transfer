import { apiFetch } from './client';
import type { ApiPlayer, ApiNewsItem } from './types';
import { mapNews, mapTransferHistory } from './mappers';
import type { NewsItem, TransferHistory } from '../types';

export async function fetchPlayer(id: number): Promise<ApiPlayer> {
  return apiFetch<ApiPlayer>(`/players/${id}`);
}

export async function fetchPlayerTransfers(id: number): Promise<{
  history: TransferHistory[];
  news: NewsItem[];
}> {
  const data = await apiFetch<ApiNewsItem[]>(`/players/${id}/transfers`);
  return {
    history: data.map(mapTransferHistory),
    news:    data.map(mapNews),
  };
}
