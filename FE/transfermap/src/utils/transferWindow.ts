export type TransferWindow = 'SUMMER' | 'WINTER';

export interface WindowState {
  season: number;           // 인코딩된 시즌 (25/26 → 51)
  seasonLabel: string;      // "25/26"
  currentWindow: TransferWindow | null;  // 현재 열린 윈도우, 비시즌이면 null
  isOpen: boolean;          // 이적시장이 지금 열려 있는지
  recentWindow: TransferWindow;  // 가장 최근에 닫힌 윈도우
  nextWindow: TransferWindow;    // 다음에 열릴 윈도우
  windowDateRange: { from: string; to: string };  // 현재/최근 윈도우 기간
}

function fmt(d: Date): string {
  return d.toISOString().slice(0, 10);
}

/**
 * 이적시장 시즌 인코딩: y1 % 100 + y2 % 100
 * 25/26 시즌 → 25 + 26 = 51
 * 시즌 기준: 7월 시작 (유럽 축구 시즌 기준)
 */
export function encodeSeason(startYear: number): number {
  const y1 = startYear % 100;
  const y2 = (startYear + 1) % 100;
  return y1 + y2;
}

export function getTransferWindowState(now = new Date()): WindowState {
  const month = now.getMonth() + 1; // 1~12
  const year  = now.getFullYear();

  // 시즌 시작 연도: 6월(여름 윈도우 오픈) 이후면 올해, 이전이면 작년
  const seasonStartYear = month >= 6 ? year : year - 1;
  const season      = encodeSeason(seasonStartYear);
  const y1          = String(seasonStartYear % 100).padStart(2, '0');
  const y2          = String((seasonStartYear + 1) % 100).padStart(2, '0');
  const seasonLabel = `${y1}/${y2}`;

  // 이적시장 윈도우 판단
  // WINTER: 1~2월
  // SUMMER: 6~9월
  // 나머지: 비시즌
  let currentWindow: TransferWindow | null;
  let recentWindow: TransferWindow;
  let nextWindow: TransferWindow;
  let windowDateRange: { from: string; to: string };

  if (month === 1 || month === 2) {
    // 겨울 이적시장 진행 중
    currentWindow = 'WINTER';
    recentWindow  = 'SUMMER';
    nextWindow    = 'SUMMER';
    windowDateRange = {
      from: fmt(new Date(year, 0, 1)),  // 1월 1일
      to:   fmt(now),
    };
  } else if (month >= 3 && month <= 5) {
    // 겨울 이적시장 종료 후 ~ 여름 이적시장 전
    currentWindow = null;
    recentWindow  = 'WINTER';
    nextWindow    = 'SUMMER';
    windowDateRange = {
      from: fmt(new Date(year, 0, 1)),      // 1월 1일
      to:   fmt(new Date(year, 1, 28)),     // 2월 말
    };
  } else if (month >= 6 && month <= 9) {
    // 여름 이적시장 진행 중
    currentWindow = 'SUMMER';
    recentWindow  = 'WINTER';
    nextWindow    = 'WINTER';
    windowDateRange = {
      from: fmt(new Date(year, 5, 1)),  // 6월 1일
      to:   fmt(now),
    };
  } else {
    // 여름 이적시장 종료 후 ~ 겨울 이적시장 전 (10~12월)
    currentWindow = null;
    recentWindow  = 'SUMMER';
    nextWindow    = 'WINTER';
    windowDateRange = {
      from: fmt(new Date(year, 5, 1)),      // 6월 1일
      to:   fmt(new Date(year, 8, 2)),      // 9월 초
    };
  }

  return {
    season,
    seasonLabel,
    currentWindow,
    isOpen: currentWindow !== null,
    recentWindow,
    nextWindow,
    windowDateRange,
  };
}

/**
 * 시즌 선택 옵션 목록 (현재 시즌부터 최대 N개)
 */
export function getSeasonOptions(count = 26): { label: string; value: number }[] {
  const { season, seasonLabel } = getTransferWindowState();
  // season = y1 + y2, 시작 y1 역산: season이 홀수이므로 (y1 + y1+1) = 2*y1+1
  // y1 = (season - 1) / 2  →  정확하진 않으므로 seasonLabel에서 파싱
  const [y1Str] = seasonLabel.split('/');
  const baseY1 = parseInt(y1Str, 10); // e.g. 25

  return Array.from({ length: count }, (_, i) => {
    const y1 = baseY1 - i;
    const y2 = y1 + 1;
    const fmt2 = (y: number) => String(((y % 100) + 100) % 100).padStart(2, '0');
    return {
      label: `${fmt2(y1)}/${fmt2(y2)}`,
      value: season - i * 2,
    };
  });
}

/** "This window" 레이블 (열려있으면 현재, 닫혀있으면 최근) */
export function getWindowLabel(state: WindowState): string {
  const w = state.currentWindow ?? state.recentWindow;
  if (w === 'WINTER') {
    const year = state.windowDateRange.from.slice(0, 4);
    return `Jan ${year}`;
  }
  const year = state.windowDateRange.from.slice(0, 4);
  return `Summer ${year}`;
}
