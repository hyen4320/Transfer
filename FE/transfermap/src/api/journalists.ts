import { apiFetch } from './client';
import type { ApiJournalist, ApiNewsItem } from './types';
import { mapJournalist, mapNews } from './mappers';
import type { Journalist, NewsItem } from '../types';

export async function fetchJournalists(): Promise<Journalist[]> {
  const data = await apiFetch<ApiJournalist[]>('/journalists');
  return data.map(mapJournalist);
}

export async function fetchJournalist(id: number): Promise<Journalist> {
  const data = await apiFetch<ApiJournalist>(`/journalists/${id}`);
  return mapJournalist(data);
}

export async function fetchJournalistNews(id: number): Promise<NewsItem[]> {
  const data = await apiFetch<ApiNewsItem[]>(`/journalists/${id}/news`);
  return data.map(mapNews);
}
