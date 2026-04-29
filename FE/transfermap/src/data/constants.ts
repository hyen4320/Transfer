const currentYear = new Date().getFullYear() % 100;
export const SEASON_OPTIONS = Array.from({ length: 22 }, (_, i) => {
  const y1 = currentYear - i, y2 = currentYear + 1 - i;
  const fmt = (y: number) => String(y).padStart(2, '0');
  return { label: `${fmt(y1)}/${fmt(y2)}`, value: y1 + y2 };
});

/** BE leagueName → FE league string id */
export const LEAGUE_NAME_TO_ID: Record<string, string> = {
  'Premier League': 'pl',
  'La Liga':        'll',
  'Bundesliga':     'bl',
  'Serie A':        'sa',
  'Ligue 1':        'l1',
};
