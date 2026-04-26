import { useRef, useState, useEffect, useCallback } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import { useClubs } from './hooks/useClubs';
import { useNews } from './hooks/useNews';
import WorldMap from './components/WorldMap';
import SidePanel from './components/SidePanel';
import LeftPanel, { type LeftPanelHandle } from './components/LeftPanel';
import MobileTabBar from './components/MobileTabBar';
import JournalistPage from './components/JournalistPage';
import JournalistDetailPage from './components/JournalistDetailPage';
import PlayerDetailPage from './components/PlayerDetailPage';
import CountryMapPage from './components/CountryMapPage';
import ErrorPage from './components/ErrorPage';
import SearchPage from './components/SearchPage';
import NoticePage from './components/NoticePage';
import InfoPage from './components/InfoPage';
import AdSlot, { SLOT } from './components/AdSlot';
import type { League, Player, NewsItem } from './types';
import { fetchNews } from './api/news';
import type { NewsFilterParams } from './api/news';
import { LEAGUES } from './data/mock';

const MAP_SEASON_OPTIONS = Array.from({ length: 26 }, (_, i) => {
  const y1 = 25 - i, y2 = 26 - i;
  const fmt = (y: number) => String(y).padStart(2, '0');
  return { label: `${fmt(y1)}/${fmt(y2)}`, value: 51 - i * 2 };
});

function MapView() {
  const navigate      = useNavigate();
  const sceneRef      = useRef<HTMLDivElement>(null);
  const leftPanelRef  = useRef<LeftPanelHandle>(null);
  const [mapSeason, setMapSeason] = useState(51);
  const { clubs } = useClubs(mapSeason);
  const { items: news } = useNews(mapSeason);

  // 입장 애니메이션 (한 번 본 경우 스킵)
  type IntroPhase = 'enter' | 'rise' | 'done';
  const alreadySeen = localStorage.getItem('introSeen') === '1';
  const [introPhase, setIntroPhase] = useState<IntroPhase>(alreadySeen ? 'done' : 'enter');
  const [textVisible, setTextVisible] = useState(alreadySeen);

  useEffect(() => {
    if (alreadySeen) return;
    const t0 = setTimeout(() => setTextVisible(true), 60);
    const t1 = setTimeout(() => setIntroPhase('rise'), 1000);
    const t2 = setTimeout(() => { setIntroPhase('done'); localStorage.setItem('introSeen', '1'); }, 1800);
    return () => { clearTimeout(t0); clearTimeout(t1); clearTimeout(t2); };
  }, []);

  const [filteredNews, setFilteredNews]     = useState<NewsItem[] | null>(null);

  // 시즌 변경 시 적용된 필터 초기화
  useEffect(() => { setFilteredNews(null); }, [mapSeason]);
  const [selectedNewsId, setSelectedNewsId] = useState<number | null>(null);
  const [panelOpen, setPanelOpen]           = useState(false);
  const [hoveredRouteId, setHoveredRouteId] = useState<number | null>(null);
  const [leftPanelOpen, setLeftPanelOpen]   = useState(false);
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null);
  const [showCountryMap, setShowCountryMap] = useState(false);
  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [panelLeague, setPanelLeague]       = useState<League | null>(null);
  const [flyPlayer, setFlyPlayer]           = useState<Player | null>(null);
  const [anchorDismissed, setAnchorDismissed] = useState(false);

  const handleNewsClick = useCallback((item: NewsItem) => {
    const toName = (item.to ?? '').toLowerCase().trim();
    const toClub = clubs.find(c => {
      const n = c.name.toLowerCase().trim();
      return n === toName || n.includes(toName) || toName.includes(n);
    });
    if (!toClub) return;
    const league = LEAGUES.find(l => l.id === toClub.league);
    if (!league) return;

    if (showCountryMap) {
      setSelectedLeague(league);
      return;
    }

    setPanelOpen(false);
    setSelectedClubId(null);
    setPanelLeague(null);

    const scene = sceneRef.current;
    if (!scene) return;
    const cx = window.innerWidth / 2;
    const cy = window.innerHeight / 2;
    scene.style.transformOrigin = `${cx}px ${cy}px`;
    scene.style.transition      = 'transform 0.7s cubic-bezier(0.55,0,0.8,1), opacity 0.28s 0.42s';
    scene.style.transform       = 'scale(10)';
    scene.style.opacity         = '0';
    scene.style.pointerEvents   = 'none';
    setTimeout(() => {
      scene.style.transition      = 'none';
      scene.style.transform       = '';
      scene.style.opacity         = '';
      scene.style.transformOrigin = '';
      scene.style.pointerEvents   = '';
      setSelectedLeague(league);
      setShowCountryMap(true);
    }, 720);
  }, [clubs, showCountryMap]);

  const handleApplyFilter = async (paramsList: NewsFilterParams[], statuses: Set<string>) => {
    try {
      const results = await Promise.all(
        paramsList.flatMap(params =>
          [...statuses].map(status => {
            const beStatus = status === 'rumour' ? 'RUMOR' : status.toUpperCase();
            return fetchNews({ ...params, status: beStatus });
          })
        )
      );
      const merged = results.flat();
      const seen = new Set<number>();
      const deduped = merged.filter(n => {
        if (seen.has(n.id)) return false;
        seen.add(n.id);
        return true;
      });
      setFilteredNews(deduped.length > 0 ? deduped : null);
    } catch {
      // keep current news on error
    }
  };

  const handleFlyTo = (player: Player, league: League) => {
    const scene = sceneRef.current;
    if (!scene) return;

    setFlyPlayer(player);

    const cx = window.innerWidth / 2;
    const cy = window.innerHeight / 2;
    scene.style.transformOrigin  = `${cx}px ${cy}px`;
    scene.style.transition       = 'transform 0.7s cubic-bezier(0.55,0,0.8,1), opacity 0.28s 0.42s';
    scene.style.transform        = 'scale(10)';
    scene.style.opacity          = '0';
    scene.style.pointerEvents    = 'none';

    setTimeout(() => {
      scene.style.transition      = 'none';
      scene.style.transform       = '';
      scene.style.opacity         = '';
      scene.style.transformOrigin = '';
      scene.style.pointerEvents   = '';

      setSelectedLeague(league);
      setShowCountryMap(true);
    }, 720);
  };

  const handleCountryClick = (league: League, centroid: [number, number]) => {
    const scene = sceneRef.current;
    if (!scene) return;

    setLeftPanelOpen(true);

    scene.style.transformOrigin  = `${centroid[0]}px ${centroid[1]}px`;
    scene.style.transition       = 'transform 0.7s cubic-bezier(0.55,0,0.8,1), opacity 0.28s 0.42s';
    scene.style.transform        = 'scale(10)';
    scene.style.opacity          = '0';
    scene.style.pointerEvents    = 'none';

    setTimeout(() => {
      scene.style.transition      = 'none';
      scene.style.transform       = '';
      scene.style.opacity         = '';
      scene.style.transformOrigin = '';
      scene.style.pointerEvents   = '';

      setSelectedLeague(league);
      setShowCountryMap(true);
    }, 720);
  };

  const handleLeaguePanelClick = (league: League) => {
    setPanelLeague(league);
    setSelectedClubId(null);
    setPanelOpen(true);
  };

  const handleClubClick = (clubId: number) => {
    setSelectedClubId(clubId);
    setPanelOpen(true);
  };

  const isNewsFeedOpen = panelOpen && !selectedClubId && !panelLeague;

  const openNewsFeed = () => {
    if (isNewsFeedOpen) {
      setPanelOpen(false);
      setSelectedNewsId(null);
    } else {
      setSelectedClubId(null);
      setPanelLeague(null);
      setPanelOpen(true);
    }
  };

  const closePanel = () => {
    setPanelOpen(false);
    setSelectedClubId(null);
    setPanelLeague(null);
    setSelectedNewsId(null);
  };

  // 키보드 단축키: Esc = 패널 닫기, / = 검색 토글, n = 뉴스피드 토글
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return;
      if (e.key === 'Escape') {
        setPanelOpen(false);
        setSelectedClubId(null);
        setPanelLeague(null);
        setSelectedNewsId(null);
        setLeftPanelOpen(false);
      } else if (e.key === '/') {
        e.preventDefault();
        if (leftPanelOpen) {
          setLeftPanelOpen(false);
        } else {
          setLeftPanelOpen(true);
          leftPanelRef.current?.focusSearch();
        }
      } else if ((e.key === 'n' || e.key === 'N') && !e.ctrlKey && !e.metaKey && !e.altKey) {
        if (isNewsFeedOpen) {
          setPanelOpen(false);
          setSelectedNewsId(null);
        } else {
          setSelectedClubId(null);
          setPanelLeague(null);
          setPanelOpen(true);
        }
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [isNewsFeedOpen, leftPanelOpen]);

  return (
    <div className="w-screen h-screen overflow-hidden bg-[var(--bg)] relative">

      {/* INTRO OVERLAY */}
      {introPhase !== 'done' && (
        <div className="absolute inset-0 flex items-center justify-center"
             style={{ zIndex: 200, background: 'var(--bg)', pointerEvents: 'none' }}>
          <div style={{
            transform: !textVisible        ? 'translateY(50px)'
                     : introPhase === 'enter' ? 'translateY(0)'
                     : 'translateY(-90px)',
            opacity:   !textVisible        ? 0
                     : introPhase === 'enter' ? 1
                     : 0,
            transition: textVisible
              ? 'transform 700ms cubic-bezier(0.22,1,0.36,1), opacity 500ms ease'
              : 'none',
            textAlign: 'center',
          }}>
            <h1 className="font-black uppercase tracking-[0.2em] text-white"
                style={{
                  fontSize: 'clamp(2.5rem,5vw,5.5rem)',
                  textShadow: '0 0 10px rgba(255,255,255,1),0 0 30px rgba(100,160,255,0.9),0 0 70px rgba(50,110,255,0.6)',
                }}>
              Transfer<span style={{ color: 'var(--accent)' }}>Map</span>
            </h1>
            <div className="mt-2" style={{
              color: 'rgba(140,190,255,0.65)',
              fontWeight: 300,
              letterSpacing: '0.45em',
              textTransform: 'uppercase',
              fontSize: 'clamp(0.55rem,1vw,0.9rem)',
            }}>
              European Football Transfer Network
            </div>
          </div>
        </div>
      )}

      {/* MAP SCENE */}
      <div ref={sceneRef} className="absolute inset-0" style={{
        willChange: 'transform, opacity',
        ...(introPhase !== 'done' && {
          zIndex: 210,
          transform: introPhase === 'enter' ? 'translateY(100vh)' : 'translateY(0)',
          transition: introPhase === 'rise'
            ? 'transform 750ms cubic-bezier(0.22,1,0.36,1)'
            : 'none',
        }),
      }}>
        <WorldMap onCountryClick={handleCountryClick} onClubClick={handleClubClick} onLeagueClick={handleLeaguePanelClick} onRouteHover={setHoveredRouteId} clubs={clubs} news={filteredNews ?? news} selectedNewsId={selectedNewsId} />

        {/* Topbar */}
        <div className="absolute top-0 left-0 right-0 h-14 flex items-center px-6 z-30 pointer-events-none"
          style={{ background: 'linear-gradient(to bottom, rgba(6,10,18,0.85) 0%, transparent 100%)' }}>

          {/* 로고 — 왼쪽 */}
          <div className="pointer-events-auto flex-none">
            <div className="text-[1.1rem] font-black tracking-[0.25em] uppercase text-white"
              style={{ textShadow: '0 0 20px rgba(100,160,255,0.8)' }}>
              Transfer<span className="text-[var(--accent)]">Map</span>
            </div>
          </div>

          {/* 버튼 4개 — 데스크톱 중앙 */}
          <div className="hidden sm:flex flex-1 items-center justify-center gap-2 pointer-events-auto">
            <button onClick={openNewsFeed}
              className={`bg-[rgba(13,22,38,0.8)] border text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         ${isNewsFeedOpen
                           ? 'border-[var(--accent)]/60 text-[var(--accent)] bg-[var(--accent)]/10'
                           : 'border-[var(--border)] text-[var(--text-sub)] hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10'}`}>
              ◈ News Feed
            </button>
            <button onClick={() => navigate('/journalists')}
              className="bg-[rgba(13,22,38,0.8)] border border-[var(--border)] text-[var(--text-sub)]
                         text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10">
              ★ Journalists
            </button>
            <button onClick={() => navigate('/notice')}
              className="bg-[rgba(13,22,38,0.8)] border border-[var(--border)] text-[var(--text-sub)]
                         text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10">
              ! Notice
            </button>
            <button onClick={() => setLeftPanelOpen(p => !p)}
              className={`bg-[rgba(13,22,38,0.8)] border text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         ${leftPanelOpen
                           ? 'border-[var(--accent)]/60 text-[var(--accent)] bg-[var(--accent)]/10'
                           : 'border-[var(--border)] text-[var(--text-sub)] hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10'}`}>
              ⌕ Search
            </button>
          </div>

          {/* 우측 균형 여백 — 로고 너비만큼 */}
          <div className="hidden sm:block flex-none" style={{ width: 'calc(1.1rem * 10)' }} />
        </div>

      </div>

      {/* SIDE PANEL */}
      <SidePanel
        open={panelOpen}
        onClose={closePanel}
        selectedClubId={selectedClubId}
        selectedLeague={panelLeague}
        leagueClubs={panelLeague ? clubs.filter(c => c.league === panelLeague.id) : []}
        onNewsClick={item => { closePanel(); handleNewsClick(item); }}
        onNewsSelect={item => setSelectedNewsId(item ? item.id : null)}
        selectedNewsId={selectedNewsId}
        hoveredRouteId={hoveredRouteId}
      />

      {/* LEFT PANEL (search / filter overlay) */}
      <LeftPanel
        ref={leftPanelRef}
        open={leftPanelOpen}
        onClose={() => { setLeftPanelOpen(false); }}
        onFlyTo={handleFlyTo}
        onApplyFilter={handleApplyFilter}
      />

      {/* 시즌 셀렉터 — 좌측하단 플로팅 (LeftPanel 열릴 때 숨김) */}
      {!leftPanelOpen && (
        <div className="hidden sm:flex absolute left-4 z-40 transition-all duration-200"
             style={{ bottom: !panelOpen && !anchorDismissed ? '68px' : '16px' }}>
          <select
            value={mapSeason}
            onChange={e => setMapSeason(Number(e.target.value))}
            className="bg-[rgba(13,22,38,0.85)] border border-[var(--border)] text-[var(--text-sub)]
                       text-[0.72rem] rounded-md px-2.5 py-1.5 focus:outline-none backdrop-blur-sm
                       hover:border-[var(--accent)]/50 hover:text-[var(--text)] transition-all cursor-pointer">
            {MAP_SEASON_OPTIONS.map(s => (
              <option key={s.value} value={s.value}>{s.label}</option>
            ))}
          </select>
        </div>
      )}

      {/* FOOTER */}
      <div className="absolute right-4 flex gap-4 z-40 pointer-events-auto sm:flex hidden transition-all duration-200"
           style={{ bottom: !panelOpen && !anchorDismissed ? '68px' : '12px' }}>
        {[
          { label: 'About',   path: '/info' },
          { label: 'Contact', path: '/info' },
          { label: '개인정보처리방침', path: '/info' },
        ].map(({ label, path }) => (
          <button key={path} onClick={() => navigate(path)}
            className="text-[0.68rem] text-[var(--text-sub)] hover:text-[var(--text)] transition-colors tracking-wide">
            {label}
          </button>
        ))}
      </div>

      {/* 스카이스크래퍼 광고 — 데스크톱 1200px 이상, 패널 바깥 우측 */}
      {!panelOpen && (
        <div className="absolute top-16 right-0 w-[160px] z-30 pointer-events-none hidden 2xl:block">
          <AdSlot
            slot={SLOT.SKYSCRAPER}
            format="vertical"
            className="pointer-events-auto"
            style={{ minHeight: 600, width: 160 }}
          />
        </div>
      )}

      {/* 앵커 배너 — 패널 닫혀있을 때만, 데스크톱 */}
      {!panelOpen && !anchorDismissed && (
        <div className="absolute bottom-0 left-0 right-0 z-35 hidden sm:flex items-center justify-center
                        bg-[rgba(6,10,18,0.9)] border-t border-[var(--border)] backdrop-blur-sm"
             style={{ height: 56 }}>
          <AdSlot
            slot={SLOT.ANCHOR_BOTTOM}
            format="horizontal"
            className="flex-1 max-w-[728px]"
            style={{ minHeight: 48 }}
          />
          <button onClick={() => setAnchorDismissed(true)}
            className="absolute right-3 top-1/2 -translate-y-1/2 w-7 h-7 rounded-full
                       flex items-center justify-center text-[var(--text-sub)] text-xs
                       hover:text-[var(--text)] hover:bg-white/10 transition-all">✕</button>
        </div>
      )}

      {/* 모바일 FAB — 조건검색 */}
      <button onClick={() => setLeftPanelOpen(true)}
        className="sm:hidden fixed bottom-20 right-4 z-50 w-14 h-14 rounded-full
                   bg-[var(--accent)] flex items-center justify-center text-white text-xl
                   shadow-[0_4px_20px_rgba(59,130,246,0.5)] active:scale-95 transition-transform">
        ⚙
      </button>

      {/* 모바일 탭바 */}
      <MobileTabBar
        active={panelOpen ? 'news' : leftPanelOpen ? 'search' : 'map'}
        onNews={openNewsFeed}
        onSearch={() => setLeftPanelOpen(true)}
      />

      {/* COUNTRY MAP (overlay) */}
      {showCountryMap && selectedLeague && (
        <CountryMapPage
          league={selectedLeague}
          backLabel="← Map"
          onBack={() => { setShowCountryMap(false); setFlyPlayer(null); setLeftPanelOpen(false); }}
          clubs={clubs}
          news={filteredNews ?? news}
          flyPlayer={flyPlayer}
          onNewsClick={handleNewsClick}
          leftOffset={leftPanelOpen ? 460 : 0}
          searchOpen={leftPanelOpen}
          onToggleSearch={() => setLeftPanelOpen(p => !p)}
        />
      )}
    </div>
  );
}

export default function App() {
  return (
    <Routes>
      <Route path="/"                  element={<MapView />} />
      <Route path="/journalists"       element={
        <div className="w-screen h-screen overflow-hidden bg-[var(--bg)] relative">
          <JournalistPage onBack={() => window.history.back()} />
        </div>
      } />
      <Route path="/journalists/:id"   element={<JournalistDetailPage />} />
      <Route path="/players/:id"       element={<PlayerDetailPage />} />
      <Route path="/search"             element={<SearchPage />} />
      <Route path="/notice"             element={<NoticePage />} />
      <Route path="/info"               element={<InfoPage />} />
      <Route path="/privacy"           element={<InfoPage />} />
      <Route path="/contact"           element={<InfoPage />} />
      <Route path="/about"             element={<InfoPage />} />
      <Route path="/404"               element={<ErrorPage code={404} />} />
      <Route path="/500"               element={<ErrorPage code={500} />} />
      <Route path="*"                  element={<ErrorPage code={404} />} />
    </Routes>
  );
}
