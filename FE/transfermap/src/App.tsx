import { useRef, useState } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import { useClubs } from './hooks/useClubs';
import { useNews } from './hooks/useNews';
import WorldMap from './components/WorldMap';
import SidePanel from './components/SidePanel';
import JournalistPage from './components/JournalistPage';
import JournalistDetailPage from './components/JournalistDetailPage';
import PlayerDetailPage from './components/PlayerDetailPage';
import CountryMapPage from './components/CountryMapPage';
import ErrorPage from './components/ErrorPage';
import type { League } from './types';

function MapView() {
  const navigate = useNavigate();
  const sceneRef = useRef<HTMLDivElement>(null);
  const { clubs } = useClubs();
  const { items: news } = useNews();

  const [panelOpen, setPanelOpen]           = useState(false);
  const [titleVisible, setTitleVisible]     = useState(true);
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null);
  const [showCountryMap, setShowCountryMap] = useState(false);
  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [panelLeague, setPanelLeague]       = useState<League | null>(null);

  const handleCountryClick = (league: League, centroid: [number, number]) => {
    const scene = sceneRef.current;
    if (!scene) return;

    setTitleVisible(false);

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
      setTimeout(() => setTitleVisible(true), 50);
    }, 720);
  };

  const handleLeaguePanelClick = (league: League) => {
    setPanelLeague(league);
    setSelectedClubId(null);
    setPanelOpen(true);
    setTitleVisible(false);
  };

  const handleClubClick = (clubId: number) => {
    setSelectedClubId(clubId);
    setPanelOpen(true);
    setTitleVisible(false);
  };

  const openNewsFeed = () => {
    setSelectedClubId(null);
    setPanelLeague(null);
    setPanelOpen(true);
    setTitleVisible(false);
  };

  const closePanel = () => {
    setPanelOpen(false);
    setSelectedClubId(null);
    setPanelLeague(null);
    setTitleVisible(true);
  };

  return (
    <div className="w-screen h-screen overflow-hidden bg-[var(--bg)] relative">

      {/* MAP SCENE */}
      <div ref={sceneRef} className="absolute inset-0" style={{ willChange: 'transform, opacity' }}>
        <WorldMap onCountryClick={handleCountryClick} onClubClick={handleClubClick} onLeagueClick={handleLeaguePanelClick} clubs={clubs} news={news} />

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
          </div>
        </div>

        {/* Title overlay */}
        <div className={`absolute top-[42%] left-1/2 -translate-x-1/2 -translate-y-1/2 text-center pointer-events-none z-10
                         transition-opacity duration-400 ${titleVisible ? 'opacity-100' : 'opacity-0'}`}>
          <h1 className="font-black uppercase tracking-[0.2em] text-white"
            style={{
              fontSize: 'clamp(2.5rem, 5vw, 5.5rem)',
              textShadow: '0 0 10px rgba(255,255,255,1), 0 0 30px rgba(100,160,255,0.9), 0 0 70px rgba(50,110,255,0.6)',
            }}>TransferMap</h1>
          <div className="mt-2 text-[rgba(140,190,255,0.65)] font-light tracking-[0.45em] uppercase"
            style={{ fontSize: 'clamp(0.55rem, 1vw, 0.9rem)' }}>
            European Football Transfer Network
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
      />

      {/* COUNTRY MAP (overlay) */}
      {showCountryMap && selectedLeague && (
        <CountryMapPage
          league={selectedLeague}
          backLabel="← Map"
          onBack={() => setShowCountryMap(false)}
          clubs={clubs}
          news={news}
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
      <Route path="/404"               element={<ErrorPage code={404} />} />
      <Route path="/500"               element={<ErrorPage code={500} />} />
      <Route path="*"                  element={<ErrorPage code={404} />} />
    </Routes>
  );
}
