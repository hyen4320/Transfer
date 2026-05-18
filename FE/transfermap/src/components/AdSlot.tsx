import { useEffect } from 'react';

export const SLOT = {
  LEADERBOARD:      { unit: 'DAN-Y8XDMKFJ0Rmrf2kr', width: 728,  height: 90  },
  SKYSCRAPER:       { unit: 'DAN-8KnuN0REmhMD6v5e', width: 160,  height: 600 },
  // 미생성 단위 — 추후 AdFit 콘솔에서 추가 후 교체
  ANCHOR_BOTTOM:    { unit: 'DAN-zM6UZwHqOlezjsvz', width: 320,  height: 50  },
  FEED_NATIVE:      { unit: 'DAN-qt4YeKfFOECQfMTz', width: 320,  height: 100 },
  FEED_NATIVE_2:    { unit: 'DAN-b20mDCNz5pwEAQwX', width: 320,  height: 100 },
  FEED_NATIVE_3:    { unit: 'DAN-zv5kQPLy28gFi1UB', width: 320,  height: 100 },
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
  format?: string;
  layoutKey?: string;
}

// 동시에 여러 AdSlot이 마운트되어도 스크립트는 한 번만 삽입
let pendingTimer: ReturnType<typeof setTimeout> | null = null;
let activeScript: HTMLScriptElement | null = null;

function triggerAdFit() {
  if (pendingTimer) clearTimeout(pendingTimer);
  pendingTimer = setTimeout(() => {
    if (activeScript && document.head.contains(activeScript)) {
      document.head.removeChild(activeScript);
    }
    activeScript = document.createElement('script');
    activeScript.src = '//t1.kakaocdn.net/kas/static/ba.min.js';
    activeScript.async = true;
    document.head.appendChild(activeScript);
    pendingTimer = null;
  }, 0);
}

export default function AdSlot({ slot, className = '', style }: Props) {
  useEffect(() => {
    if (!slot) return;
    triggerAdFit();
  }, [slot]);

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
