/** BE TransferNewsResponse */
export interface ApiNewsItem {
  id: number;
  playerId: number | null;
  journalistId: number;
  playerName: string;
  fromClubName: string | null;
  toClubName: string | null;
  fromCountryCode: string | null;
  toCountryCode: string | null;
  feeEur: number | null;
  status: string;          // INTEREST | RUMOR | CONFIRMED | DENIED | LOAN
  reliability: number | null;
  publishedAt: string;     // ISO-8601
  journalistXHandle: string;
  journalistName: string;
  journalistCredibility: number;
  postContent: string;
  sourceUrl: string;
}

/** BE JournalistResponse */
export interface ApiJournalist {
  id: number;
  xHandle: string;
  name: string;
  profileImageUrl: string | null;
  followerCount: number;
  credibilityScore: number;
  rank: number;
  speedScore: number | null;
  accuracyScore: number | null;
  impactScore: number | null;
  isBot: boolean;
}

/** BE PlayerResponse */
export interface ApiPlayer {
  id: number;
  name: string;
  nationality: string;
  position: string | null;
  currentClubName: string | null;
  currentLeagueName: string | null;
  contractUntil: string | null;
  contractStatus: string | null;
  profileImageUrl: string | null;
}

/** BE LeagueResponse */
export interface ApiLeague {
  id: number;
  name: string;
  countryCode: string;
  logoUrl: string | null;
  tier: number | null;
}

/** BE ClubResponse */
export interface ApiClub {
  id: number;
  name: string;
  shortName: string | null;
  logoUrl: string | null;
  city: string | null;
  countryCode: string | null;
  latitude: number;
  longitude: number;
  stadiumName: string | null;
  leagueName: string | null;
}

/** Spring Page wrapper */
export interface ApiPage<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  number: number;
  size: number;
}
