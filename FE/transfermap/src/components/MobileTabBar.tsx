import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const TABS = [
  { key: 'map',    icon: '◇', label: 'MAP'    },
  { key: 'search', icon: '⌕', label: 'SEARCH' },
  { key: 'news',   icon: '◈', label: 'NEWS'   },
  { key: 'stars',  icon: '★', label: 'STARS'  },
  { key: 'more',   icon: '☰', label: 'MORE'   },
] as const;

type TabKey = (typeof TABS)[number]['key'];

const MORE_ITEMS = [
  { icon: '◈', label: 'News Feed',    key: 'newsfeed'   },
  { icon: '★', label: 'Journalists',  key: 'journalists' },
  { icon: '▤', label: 'Report',       key: 'report'     },
  { icon: '!', label: 'Notice',       key: 'notice'     },
  { icon: '👤', label: 'About',       key: 'about'      },
] as const;

type MoreKey = (typeof MORE_ITEMS)[number]['key'];

interface Props {
  active?: TabKey;
  onSearch?: () => void;
  onNews?: () => void;
}

export default function MobileTabBar({ active = 'map', onSearch, onNews }: Props) {
  const navigate = useNavigate();
  const [moreOpen, setMoreOpen] = useState(false);

  const handleMore = (key: MoreKey) => {
    setMoreOpen(false);
    switch (key) {
      case 'newsfeed':    onNews?.();                  break;
      case 'journalists': navigate('/journalists');    break;
      case 'report':      navigate('/report');         break;
      case 'notice':      navigate('/notice');         break;
      case 'about':       navigate('/info');           break;
    }
  };

  const handleTab = (key: TabKey) => {
    if (key === 'more') { setMoreOpen(o => !o); return; }
    setMoreOpen(false);
    switch (key) {
      case 'map':    navigate('/');    break;
      case 'search': onSearch?.();    break;
      case 'news':   onNews?.();      break;
      case 'stars':  navigate('/journalists'); break;
    }
  };

  return (
    <>
      {/* More 드로어 */}
      {moreOpen && (
        <>
          {/* 배경 딤 */}
          <div className="sm:hidden fixed inset-0 z-40" onClick={() => setMoreOpen(false)} />
          {/* 메뉴 패널 */}
          <div className="sm:hidden fixed bottom-16 left-0 right-0 z-50
                          bg-[rgba(8,14,26,0.98)] border-t border-[var(--border)] backdrop-blur-xl
                          animate-[slideUp_150ms_ease-out]">
            {MORE_ITEMS.map(({ icon, label, key }) => (
              <button key={key} onClick={() => handleMore(key)}
                className="w-full flex items-center gap-4 px-6 py-4 text-left
                           border-b border-[var(--border)] last:border-b-0
                           text-[var(--text-sub)] hover:text-[var(--text)] hover:bg-white/5
                           transition-colors">
                <span className="text-lg w-6 text-center">{icon}</span>
                <span className="text-[0.9rem] font-semibold tracking-wide">{label}</span>
              </button>
            ))}
          </div>
        </>
      )}

      {/* 탭바 */}
      <nav className="flex sm:hidden fixed bottom-0 left-0 right-0 h-16 z-50
                      bg-[rgba(6,10,18,0.97)] border-t border-[var(--border)] backdrop-blur-xl"
           style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}>
        {TABS.map(({ key, icon, label }) => {
          const isActive = active === key || (key === 'more' && moreOpen);
          return (
            <button key={key} onClick={() => handleTab(key)}
              className={`relative flex-1 flex flex-col items-center justify-center gap-0.5 transition-colors
                ${isActive ? 'text-[var(--accent)]' : 'text-[var(--text-sub)]'}`}>
              <span className="text-[1.1rem] leading-none">{icon}</span>
              <span className="text-[0.58rem] font-bold tracking-widest">{label}</span>
              {isActive && (
                <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 rounded-full bg-[var(--accent)]" />
              )}
            </button>
          );
        })}
      </nav>
    </>
  );
}
