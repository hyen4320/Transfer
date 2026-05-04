import { apiFetch } from './client';

export interface LeagueSpendingItem {
  leagueName: string;
  countryCode: string;
  totalFeeEur: number;
  count: number;
}

export interface PositionTrendItem {
  position: string;
  count: number;
}

export interface ClubActivityItem {
  clubName: string;
  leagueName: string;
  incomingCount: number;
  totalFeeEur: number;
}

export interface TransferFlowItem {
  fromCountryCode: string;
  toCountryCode: string;
  count: number;
}

export interface TopDealItem {
  playerName: string;
  fromClubName: string | null;
  toClubName: string;
  toLeagueName: string;
  feeEur: number;
}

export interface FreeAgentItem {
  leagueName: string;
  count: number;
}

export const fetchLeagueSpending = (season: number) =>
  apiFetch<LeagueSpendingItem[]>(`/report/league-spending?season=${season}`);

export const fetchPositionTrend = (season: number) =>
  apiFetch<PositionTrendItem[]>(`/report/position-trend?season=${season}`);

export const fetchClubActivity = (season: number) =>
  apiFetch<ClubActivityItem[]>(`/report/club-activity?season=${season}`);

export const fetchTransferFlow = (season: number) =>
  apiFetch<TransferFlowItem[]>(`/report/transfer-flow?season=${season}`);

export const fetchTopDeals = (season: number) =>
  apiFetch<TopDealItem[]>(`/report/top-deals?season=${season}`);

export const fetchFreeAgent = (season: number) =>
  apiFetch<FreeAgentItem[]>(`/report/free-agent?season=${season}`);
