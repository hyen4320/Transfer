import { useEffect, useRef } from 'react';

declare global {
  interface Window { adsbygoogle: Record<string, unknown>[]; }
}

const CLIENT = 'ca-pub-6322996609513242';

// 실제 슬롯 ID는 AdSense 콘솔에서 발급 후 교체하세요.
export const SLOT = {
  ANCHOR_BOTTOM:    '1111111111',
  FEED_NATIVE:      '2222222222',
  SKYSCRAPER:       '3333333333',
  LEADERBOARD:      '4444444444',
  TABLE_ROW_NATIVE: '5555555555',
  MPU_SIDEBAR_1:    '6666666666',
  MPU_SIDEBAR_2:    '7777777777',
  INTER_SECTION:    '8888888888',
} as const;

interface Props {
  slot: string;
  format?: 'auto' | 'fluid' | 'horizontal' | 'vertical';
  layoutKey?: string;
  style?: React.CSSProperties;
  className?: string;
}

export default function AdSlot({ slot, format = 'auto', layoutKey, style, className = '' }: Props) {
  const wrapRef = useRef<HTMLDivElement>(null);
  const pushed  = useRef(false);

  useEffect(() => {
    const el = wrapRef.current;
    if (!el || pushed.current) return;
    const io = new IntersectionObserver(([entry]) => {
      if (!entry.isIntersecting || pushed.current) return;
      pushed.current = true;
      try {
        (window.adsbygoogle = window.adsbygoogle ?? []).push({});
      } catch { /* noop */ }
      io.disconnect();
    }, { rootMargin: '200px' });
    io.observe(el);
    return () => io.disconnect();
  }, []);

  return (
    <div ref={wrapRef} className={className} style={style}>
      <p className="text-[0.58rem] text-center tracking-[0.25em] uppercase mb-0.5"
         style={{ color: 'rgba(160,185,220,0.3)' }}>광고</p>
      <ins
        className="adsbygoogle"
        style={{ display: 'block' }}
        data-ad-client={CLIENT}
        data-ad-slot={slot}
        data-ad-format={format}
        {...(layoutKey ? ({ 'data-ad-layout-key': layoutKey } as Record<string, string>) : {})}
        data-full-width-responsive="true"
      />
    </div>
  );
}
