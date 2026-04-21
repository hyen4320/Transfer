import { useRef, useState, useEffect, useCallback } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import { useClubs } from './hooks/useClubs';
import { useNews } from './hooks/useNews';
import WorldMap from './components/WorldMap';
import SidePanel from './components/SidePanel';
import LeftPanel from './components/LeftPanel';
import JournalistPage from './components/JournalistPage';
import JournalistDetailPage from './components/JournalistDetailPage';
import PlayerDetailPage from './components/PlayerDetailPage';
import CountryMapPage from './components/CountryMapPage';
import ErrorPage from './components/ErrorPage';
import SearchPage from './components/SearchPage';
import type { League, Player, NewsItem } from './types';
import { fetchNews } from './api/news';
import type { NewsFilterParams } from './api/news';
import { LEAGUES } from './data/mock';

function MapView() {
  const navigate = useNavigate();
  const sceneRef = useRef<HTMLDivElement>(null);
  const { clubs } = useClubs();
  const { items: news } = useNews();

  // 입장 애니메이션
  type IntroPhase = 'enter' | 'rise' | 'done';
  const [introPhase, setIntroPhase] = useState<IntroPhase>('enter');
  const [textVisible, setTextVisible] = useState(false);

  useEffect(() => {
    const t0 = setTimeout(() => setTextVisible(true), 60);
    const t1 = setTimeout(() => setIntroPhase('rise'), 1000);
    const t2 = setTimeout(() => setIntroPhase('done'), 1800);
    return () => { clearTimeout(t0); clearTimeout(t1); clearTimeout(t2); };
  }, []);

  const [filteredNews, setFilteredNews]     = useState<NewsItem[] | null>(null);
  const [panelOpen, setPanelOpen]           = useState(false);
  const [leftPanelOpen, setLeftPanelOpen]   = useState(false);
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null);
  const [showCountryMap, setShowCountryMap] = useState(false);
  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [panelLeague, setPanelLeague]       = useState<League | null>(null);
  const [flyPlayer, setFlyPlayer]           = useState<Player | null>(null);

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

  const openNewsFeed = () => {
    setSelectedClubId(null);
    setPanelLeague(null);
    setPanelOpen(true);
  };

  const closePanel = () => {
    setPanelOpen(false);
    setSelectedClubId(null);
    setPanelLeague(null);
  };

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
        <WorldMap onCountryClick={handleCountryClick} onClubClick={handleClubClick} onLeagueClick={handleLeaguePanelClick} clubs={clubs} news={filteredNews ?? news} />

        {/* Topbar */}
        <div className="absolute top-0 left-0 right-0 h-14 flex items-center justify-between px-6 z-30 pointer-events-none"
          style={{ background: 'linear-gradient(to bottom, rgba(6,10,18,0.85) 0%, transparent 100%)' }}>
          <div className="text-[1.1rem] font-black tracking-[0.25em] uppercase text-white pointer-events-auto"
            style={{ textShadow: '0 0 20px rgba(100,160,255,0.8)' }}>
            Transfer<span className="text-[var(--accent)]">Map</span>
          </div>
          <div className="flex gap-2 pointer-events-auto">
            <button onClick={openNewsFeed}
              className="bg-[rgba(13,22,38,0.8)] border border-[var(--border)] text-[var(--text-sub)]
                         text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10">
              ◈ News Feed
            </button>
            <button onClick={() => navigate('/journalists')}
              className="bg-[rgba(13,22,38,0.8)] border border-[var(--border)] text-[var(--text-sub)]
                         text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10">
              ★ Journalists
            </button>
            <button onClick={() => { setLeftPanelOpen(true); }}
              className={`bg-[rgba(13,22,38,0.8)] border text-[0.78rem] font-bold tracking-wide uppercase px-3.5 py-1.5 rounded-md
                         backdrop-blur-lg flex items-center gap-1.5 transition-all
                         ${leftPanelOpen
                           ? 'border-[var(--accent)]/60 text-[var(--accent)] bg-[var(--accent)]/10'
                           : 'border-[var(--border)] text-[var(--text-sub)] hover:text-[var(--text)] hover:border-blue-500/50 hover:bg-blue-500/10'}`}>
              ⌕ Search
            </button>
          </div>
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
      />

      {/* LEFT PANEL (search / filter overlay) */}
      <LeftPanel
        open={leftPanelOpen}
        onClose={() => { setLeftPanelOpen(false); }}
        onFlyTo={handleFlyTo}
        onApplyFilter={handleApplyFilter}
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
      <Route path="/404"               element={<ErrorPage code={404} />} />
      <Route path="/500"               element={<ErrorPage code={500} />} />
      <Route path="*"                  element={<ErrorPage code={404} />} />
    </Routes>
  );
}
