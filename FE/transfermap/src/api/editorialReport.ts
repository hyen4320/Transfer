import { apiFetch, apiMutate } from './client';

export type BlockKind = 'heading' | 'paragraph' | 'pullquote' | 'stats' | 'timeline' | 'kpi' | 'divider' | 'data-raw';

export interface StatItem     { label: string; value: string; sub: string }
export interface TimelineItem { year: string; label: string; body: string }
export interface KpiItem      { label: string; value: string; delta: string }

export type Block =
  | { id: string; kind: 'heading';   text: string }
  | { id: string; kind: 'paragraph'; text: string }
  | { id: string; kind: 'pullquote'; text: string }
  | { id: string; kind: 'stats';     items: StatItem[] }
  | { id: string; kind: 'timeline';  items: TimelineItem[] }
  | { id: string; kind: 'kpi';       items: KpiItem[] }
  | { id: string; kind: 'divider' }
  | { id: string; kind: 'data-raw';  category: string; items: unknown[] }

export interface EditorialReportRequest {
  title:          string;
  deck:           string;
  type:           'analysis' | 'data';
  format:         'longform' | 'dashboard' | 'brief';
  classification: 'open-source' | 'sourced' | 'data-room';
  readMinutes:    number;
  coverTone:      string;
  coverMotif:     string;
  tags:           string[];
  blocks:         string; // JSON.stringify(Block[])
  status:         'draft' | 'ready' | 'published';
}

export interface EditorialReportResponse {
  id:             number;
  title:          string;
  deck:           string;
  type:           string;
  format:         string;
  classification: string;
  readMinutes:    number;
  coverTone:      string;
  coverMotif:     string;
  tags:           string[];
  blocks:         string;
  status:         string;
  createdAt:      string;
  publishedAt:    string | null;
}

const adminHeaders = (): Record<string, string> => {
  const token = localStorage.getItem('adminToken');
  return token ? { 'X-Admin-Token': token } : {};
};

export const verifyAdminToken = async (token: string): Promise<boolean> => {
  try {
    const res = await fetch('/api/admin/verify', { headers: { 'X-Admin-Token': token } });
    return res.ok;
  } catch {
    return false;
  }
};

export const createEditorialReport = (req: EditorialReportRequest) =>
  apiMutate<EditorialReportResponse>('/editorial-reports', 'POST', req, adminHeaders());

export const updateEditorialReport = (id: number, req: EditorialReportRequest) =>
  apiMutate<EditorialReportResponse>(`/editorial-reports/${id}`, 'PUT', req, adminHeaders());

export const fetchEditorialReports = () =>
  apiFetch<EditorialReportResponse[]>('/editorial-reports');

export const fetchEditorialReportById = (id: number) =>
  apiFetch<EditorialReportResponse>(`/editorial-reports/${id}`);

export const fetchAllEditorialReports = () =>
  apiFetch<EditorialReportResponse[]>('/editorial-reports/all');
