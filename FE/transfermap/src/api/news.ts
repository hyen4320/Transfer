import { apiFetch } from './client';
import type { ApiPage, ApiNewsItem } from './types';
import { mapNews } from './mappers';
import type { NewsItem } from '../types';

export async function fetchNews(params?: {
  status?: string;
  leagueId?: number;
  page?: number;
  size?: number;
}): Promise<NewsItem[]> {
  const q = new URLSearchParams({ sort: 'publishedAt,desc', size: String(params?.size ?? 50) });
  if (params?.status)   q.set('status',   params.status);
  if (params?.leagueId) q.set('leagueId', String(params.leagueId));
  if (params?.page)     q.set('page',     String(params.page));

  const data = await apiFetch<ApiPage<ApiNewsItem>>(`/news?${q}`);
  return data.content.map(mapNews);
}
