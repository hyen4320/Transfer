/** BE TransferNewsResponse */
export interface ApiNewsItem {
  id: number;
  journalistId: number;
  playerName: string;
  fromClubName: string | null;
  toClubName: string;
  feeEur: number | null;
  status: string;          // RUMOR | CONFIRMED | DENIED | LOAN
  reliability: number | null;
  publishedAt: string;     // ISO-8601
  journalistXHandle: string;
  journalistName: string;
  journalistCredibility: number;
  postContent: string;
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
}

/** BE PlayerResponse */
export interface ApiPlayer {
  id: number;
  name: string;
  nationality: string;
  position: string | null;
  currentClubName: string | null;
  contractUntil: string | null;
  profileImageUrl: string | null;
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
