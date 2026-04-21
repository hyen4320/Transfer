import { apiFetch } from './client';
import type { ApiLeague } from './types';

export async function fetchLeagues(): Promise<ApiLeague[]> {
  return apiFetch<ApiLeague[]>('/leagues');
}
