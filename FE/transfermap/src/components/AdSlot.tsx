export const SLOT = {
  LEADERBOARD:      { unit: 'DAN-Y8XDMKFJ0Rmrf2kr', width: 728,  height: 90  },
  SKYSCRAPER:       { unit: 'DAN-8KnuN0REmhMD6v5e', width: 160,  height: 600 },
  // 미생성 단위 — 추후 AdFit 콘솔에서 추가 후 교체
  ANCHOR_BOTTOM:    { unit: 'DAN-zM6UZwHqOlezjsvz', width: 320,  height: 50  },
  FEED_NATIVE:      { unit: 'DAN-qt4YeKfFOECQfMTz', width: 320,  height: 100 },
  TABLE_ROW_NATIVE: null,
  MPU_SIDEBAR_1:    null,
  MPU_SIDEBAR_2:    null,
  INTER_SECTION:    null,
} as const;

type SlotConfig = { unit: string; width: number; height: number } | null;

interface Props {
  slot: SlotConfig;
  className?: string;
  style?: React.CSSProperties;
  format?: string;    // AdSense 호환용 — 미사용
  layoutKey?: string; // AdSense 호환용 — 미사용
}

export default function AdSlot({ slot, className = '', style }: Props) {
  if (!slot) return null;

  return (
    <div className={className} style={style}>
      <p className="text-[0.58rem] text-center tracking-[0.25em] uppercase mb-0.5"
         style={{ color: 'rgba(160,185,220,0.3)' }}>Ad</p>
      <ins
        className="kakao_ad_area"
        style={{ display: 'none' }}
        data-ad-unit={slot.unit}
        data-ad-width={String(slot.width)}
        data-ad-height={String(slot.height)}
      />
    </div>
  );
}
