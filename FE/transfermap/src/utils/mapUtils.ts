interface Pos { x: number; y: number; }

/** "€180M" → 180_000_000 / "€500K" → 500_000 / "Free" → 0 */
export function parseFee(fee: string): number {
  if (!fee || fee === 'Free' || fee === 'Loan') return 0;
  const m = fee.match(/([\d.]+)\s*(M|K)?/i);
  if (!m) return 0;
  const val = parseFloat(m[1]);
  if (m[2]?.toUpperCase() === 'M') return val * 1_000_000;
  if (m[2]?.toUpperCase() === 'K') return val * 1_000;
  return val;
}

/**
 * 겹치는 점들을 minDist 이상 벌어지도록 반복 이동.
 * 원본 좌표 배열과 동일한 순서로 결과를 반환한다.
 */
export function resolveOverlaps<T extends Pos>(positions: T[], minDist = 9): T[] {
  const pts = positions.map(p => ({ ...p })) as T[];
  for (let iter = 0; iter < 30; iter++) {
    let moved = false;
    for (let i = 0; i < pts.length; i++) {
      for (let j = i + 1; j < pts.length; j++) {
        const dx = pts[j].x - pts[i].x;
        const dy = pts[j].y - pts[i].y;
        const d  = Math.sqrt(dx * dx + dy * dy);
        if (d < minDist) {
          const push = (minDist - d + 0.5) / 2;
          if (d < 0.1) {
            const angle = (i / pts.length) * Math.PI * 2;
            pts[i].x -= Math.cos(angle) * push;
            pts[i].y -= Math.sin(angle) * push;
            pts[j].x += Math.cos(angle) * push;
            pts[j].y += Math.sin(angle) * push;
          } else {
            const nx = (dx / d) * push;
            const ny = (dy / d) * push;
            pts[i].x -= nx; pts[i].y -= ny;
            pts[j].x += nx; pts[j].y += ny;
          }
          moved = true;
        }
      }
    }
    if (!moved) break;
  }
  return pts;
}
