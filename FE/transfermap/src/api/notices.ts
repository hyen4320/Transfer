import { apiFetch } from './client';

export interface Notice {
  id: number;
  tag: 'update' | 'notice' | 'maintenance';
  title: string;
  body: string;
  publishedAt: string;
}

export function fetchNotices(): Promise<Notice[]> {
  return apiFetch<Notice[]>('/notices');
}
