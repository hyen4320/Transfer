import { useState, useEffect } from 'react';

export function useIsMobile(): boolean {
  const [mobile, setMobile] = useState(() => window.innerWidth < 640);
  useEffect(() => {
    const mq = window.matchMedia('(max-width: 639px)');
    const handle = (e: MediaQueryListEvent) => setMobile(e.matches);
    mq.addEventListener('change', handle);
    return () => mq.removeEventListener('change', handle);
  }, []);
  return mobile;
}
