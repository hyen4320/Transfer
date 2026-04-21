import type { NewsItem, Journalist, Player, TransferStatus, TransferHistory } from '../types';
import type { ApiNewsItem, ApiJournalist, ApiPlayer } from './types';

const STATUS_MAP: Record<string, TransferStatus> = {
  RUMOR: 'rumour', CONFIRMED: 'confirmed', DENIED: 'denied', LOAN: 'loan',
};

export function mapStatus(beStatus: string): TransferStatus {
  return STATUS_MAP[beStatus.toUpperCase()] ?? 'rumour';
}

export function formatFee(feeEur: number | null): string {
  if (feeEur === null) return 'Unknown';
  if (feeEur === 0)    return 'Free';
  if (feeEur >= 1_000_000) return `€${(feeEur / 1_000_000).toFixed(0)}M`;
  if (feeEur >= 1_000)     return `€${(feeEur / 1_000).toFixed(0)}K`;
  return `€${feeEur}`;
}

export function relativeTime(isoStr: string): string {
  const diff  = Date.now() - new Date(isoStr).getTime();
  const mins  = Math.floor(diff / 60_000);
  if (mins  < 60)   return `${mins}m ago`;
  const hours = Math.floor(mins  / 60);
  if (hours < 24)   return `${hours}h ago`;
  const days  = Math.floor(hours / 24);
  return `${days}d ago`;
}

export function formatFollowers(count: number): string {
  if (count >= 1_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
  if (count >= 1_000)     return `${Math.round(count / 1_000)}K`;
  return `${count}`;
}

export function mapNews(n: ApiNewsItem): NewsItem {
  return {
    id:           n.id,
    player:       n.playerName,
    from:         n.fromClubName ?? 'Free Agent',
    to:           n.toClubName,
    fee:          formatFee(n.feeEur),
    status:       mapStatus(n.status),
    journalist:   n.journalistName,
    journalistId: n.journalistId,
    handle:       n.journalistXHandle.startsWith('@')
                    ? n.journalistXHandle
                    : `@${n.journalistXHandle}`,
    credibility:  n.journalistCredibility,
    time:         relativeTime(n.publishedAt),
    sourceUrl:    n.sourceUrl,
  };
}

export function mapJournalist(j: ApiJournalist): Journalist {
  return {
    id:        j.id,
    name:      j.name,
    handle:    j.xHandle.startsWith('@') ? j.xHandle : `@${j.xHandle}`,
    followers: formatFollowers(j.followerCount),
    score:     j.credibilityScore ?? 0,
    speed:     j.speedScore    ?? 0,
    accuracy:  j.accuracyScore ?? 0,
    impact:    j.impactScore   ?? 0,
  };
}

export function mapPlayer(p: ApiPlayer): Player {
  return {
    id:            p.id,
    name:          p.name,
    nationality:   p.nationality,
    position:      p.position ?? 'FW',
    currentClub:   p.currentClubName ?? 'Free Agent',
    currentLeague: p.currentLeagueName ?? undefined,
    contractUntil: p.contractUntil ?? '',
  };
}

export function mapTransferHistory(n: ApiNewsItem): TransferHistory {
  return {
    year:   new Date(n.publishedAt).getFullYear().toString(),
    from:   n.fromClubName ?? 'Free Agent',
    to:     n.toClubName,
    fee:    formatFee(n.feeEur),
    status: mapStatus(n.status),
  };
}
