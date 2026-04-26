import { apiFetch } from './client';
import type { ApiPage, ApiNewsItem } from './types';
import { mapNews } from './mappers';
import type { NewsItem } from '../types';

export interface NewsFilterParams {
  status?: string;
  season?: number;
  leagueId?: number;
  position?: string;
  minFeeEur?: number;
  maxFeeEur?: number;
  from?: string;
  to?: string;
  journalistId?: number;
  toClubId?: number;
  fromClubId?: number;
  page?: number;
  size?: number;
  sort?: string;
}

function buildNewsQuery(params: NewsFilterParams): URLSearchParams {
  const q = new URLSearchParams({ sort: params.sort ?? 'publishedAt,desc', size: String(params.size ?? 50) });
  if (params.status)      q.set('status',      params.status.toUpperCase());
  if (params.season != null) q.set('season',   String(params.season));
  if (params.leagueId)    q.set('leagueId',    String(params.leagueId));
  if (params.position)    q.set('position',    params.position.toUpperCase());
  if (params.minFeeEur != null) q.set('minFeeEur',  String(params.minFeeEur));
  if (params.maxFeeEur != null) q.set('maxFeeEur',  String(params.maxFeeEur));
  if (params.from)        q.set('from',        params.from);
  if (params.to)          q.set('to',          params.to);
  if (params.journalistId) q.set('journalistId', String(params.journalistId));
  if (params.toClubId)    q.set('toClubId',    String(params.toClubId));
  if (params.fromClubId)  q.set('fromClubId',  String(params.fromClubId));
  if (params.page)        q.set('page',        String(params.page));
  return q;
}

export async function fetchNews(params?: NewsFilterParams): Promise<NewsItem[]> {
  const q = buildNewsQuery(params ?? {});
  const data = await apiFetch<ApiPage<ApiNewsItem>>(`/news?${q}`);
  return data.content.map(mapNews);
}

export async function fetchNewsPage(params?: NewsFilterParams): Promise<{ items: NewsItem[]; total: number }> {
  const q = buildNewsQuery(params ?? {});
  const data = await apiFetch<ApiPage<ApiNewsItem>>(`/news?${q}`);
  return { items: data.content.map(mapNews), total: data.totalElements };
}
