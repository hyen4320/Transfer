export const SEASON_OPTIONS = Array.from({ length: 26 }, (_, i) => {
  const y1 = 25 - i, y2 = 26 - i;
  const fmt = (y: number) => String(y).padStart(2, '0');
  return { label: `${fmt(y1)}/${fmt(y2)}`, value: 51 - i * 2 };
});
