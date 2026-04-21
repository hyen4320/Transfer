export interface League {
  id: string;
  name: string;
  lon: number;
  lat: number;
  color: string;
  accent: string;
  abbr: string;
  country: string;
  flag: string;
  numericId: number;
  center: [number, number];
  scale: number;
  clubs: number;
  transfers: number;
  news: number;
}

export interface Club {
  id: number;
  name: string;
  lon: number;
  lat: number;
  league: string;
  color: string;
  emoji?: string;
}

export type TransferStatus = 'rumour' | 'confirmed' | 'denied' | 'loan';

export interface NewsItem {
  id: number;
  player: string;
  playerId?: number;
  fromClubId?: number;
  toClubId?: number;
  from: string;
  to: string;
  fee: string;
  status: TransferStatus;
  journalist: string;
  journalistId: number;
  handle: string;
  credibility: number;
  time: string;
  sourceUrl?: string;
}

export interface Journalist {
  id: number;
  name: string;
  handle: string;
  followers: string;
  score: number;
  speed: number;
  accuracy: number;
  impact: number;
  bio?: string;
  country?: string;
  outlet?: string;
}

export interface Player {
  id: number;
  name: string;
  nationality: string;
  flag?: string;
  position: string;
  currentClub: string;
  currentLeague?: string;
  contractUntil: string;
  age?: number;
  marketValue?: string;
  emoji?: string;
}

export interface TransferHistory {
  year: string;
  from: string;
  to: string;
  fee: string;
  status: TransferStatus;
}

export interface ClubTransfer {
  player: string;
  from?: string;
  to?: string;
  fee: string;
  status: TransferStatus;
}

export interface ClubTransfers {
  in: ClubTransfer[];
  out: ClubTransfer[];
}
