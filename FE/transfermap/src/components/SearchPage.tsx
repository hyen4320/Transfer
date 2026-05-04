import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet-async';
import { PLAYERS, CLUBS, NEWS, JOURNALISTS } from '../data/mock';
import { getTransferWindowState, getWindowLabel } from '../utils/transferWindow';

const CURRENT_WINDOW = getTransferWindowState();
const WINDOW_LABEL   = getWindowLabel(CURRENT_WINDOW);

const STATUS_STYLE: Record<string, string> = {
  rumour:    'bg-yellow-500/15 text-yellow-400 border-yellow-500/30',
  confirmed: 'bg-green-500/15  text-green-400  border-green-500/30',
  denied:    'bg-red-500/15    text-red-400    border-red-500/30',
  loan:      'bg-blue-500/15   text-blue-400   border-blue-500/30',
};

const LEAGUE_NAMES: Record<string, string> = {
  pl: 'Premier League',
  ll: 'La Liga',
  bl: 'Bundesliga',
  sa: 'Serie A',
  l1: 'Ligue 1',
};

// 이적시장 상태에 따라 퀵필터 자동 결정
const QUICK_FILTERS = CURRENT_WINDOW.isOpen
  ? ['TRENDING', 'CONFIRMED TODAY', '€100M+', 'FREE AGENTS', WINDOW_LABEL.toUpperCase(), 'RUMOURS']
  : ['TRENDING', '€100M+', 'FREE AGENTS', `${WINDOW_LABEL.toUpperCase()} REVIEW`, 'CONFIRMED', 'LOANS'];

const RECENT_SEARCHES = [
  'Mbappé to Liverpool',
  'Premier League · €50M+ · confirmed',
  'Journalists with hit rate > 80%',
  'Ajax outgoing transfers',
];

const SAVED_SEARCHES = [
  '★ my tracked players (5)',
  '★ Tier S journalists · last 24h',
];

type ActiveFilters = {
  types: Set<string>;
  leagues: Set<string>;
  statuses: Set<string>;
  feeMin: number;
  feeMax: number;
};

function parseFeeValue(fee: string): number {
  if (!fee) return 0;
  const m = fee.match(/€([\d.]+)(M|B)?/i);
  if (!m) return 0;
  const n = parseFloat(m[1]);
  return m[2]?.toUpperCase() === 'B' ? n * 1000 : n;
}

export default function SearchPage() {
  const navigate = useNavigate();
  const [query, setQuery]   = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [viewMode, setViewMode]   = useState<'LIST' | 'GRID'>('LIST');
  const [sortBy, setSortBy]       = useState<'relevance' | 'fee' | 'recent'>('relevance');

  const [filters, setFilters] = useState<ActiveFilters>({
    types:    new Set(['players', 'clubs', 'news', 'journalists']),
    leagues:  new Set(['pl', 'll', 'bl']),
    statuses: new Set(['rumour', 'confirmed']),
    feeMin: 0,
    feeMax: 250,
  });

  const hasQuery = query.trim().length > 0;

  const toggleSet = (key: keyof Pick<ActiveFilters, 'types' | 'leagues' | 'statuses'>, val: string) => {
    setFilters(prev => {
      const next = new Set(prev[key]);
      next.has(val) ? next.delete(val) : next.add(val);
      return { ...prev, [key]: next };
    });
  };

  const results = useMemo(() => {
    if (!submitted && !hasQuery) return null;
    const q = query.toLowerCase().trim();

    const players = PLAYERS.filter(p =>
      (!q || p.name.toLowerCase().includes(q) || p.currentClub?.toLowerCase().includes(q) || p.nationality?.toLowerCase().includes(q)) &&
      filters.types.has('players') &&
      filters.leagues.has(p.currentLeague === 'Premier League' ? 'pl'
        : p.currentLeague === 'La Liga' ? 'll'
        : p.currentLeague === 'Bundesliga' ? 'bl'
        : p.currentLeague === 'Serie A' ? 'sa'
        : p.currentLeague === 'Ligue 1' ? 'l1' : '')
    );

    const clubs = CLUBS.filter(c =>
      (!q || c.name.toLowerCase().includes(q)) &&
      filters.types.has('clubs') &&
      filters.leagues.has(c.league)
    );

    const news = NEWS.filter(n => {
      if (!filters.types.has('news')) return false;
      if (!filters.statuses.has(n.status)) return false;
      const fee = parseFeeValue(n.fee);
      if (fee > 0 && (fee < filters.feeMin || fee > filters.feeMax)) return false;
      if (!q) return true;
      return (
        n.player?.toLowerCase().includes(q) ||
        n.from?.toLowerCase().includes(q) ||
        n.to?.toLowerCase().includes(q) ||
        n.journalist?.toLowerCase().includes(q)
      );
    });

    const journalists = JOURNALISTS.filter(j =>
      filters.types.has('journalists') &&
      (!q || j.name.toLowerCase().includes(q) || j.outlet?.toLowerCase().includes(q))
    );

    return { players, clubs, news, journalists };
  }, [submitted, hasQuery, query, filters]);

  const total = results
    ? results.players.length + results.clubs.length + results.news.length + results.journalists.length
    : 0;

  const handleSearch = () => {
    if (hasQuery) setSubmitted(true);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') handleSearch();
  };

  const handleQuickFilter = (label: string) => {
    setQuery(label);
    setSubmitted(true);
  };

  const handleRecent = (s: string) => {
    setQuery(s);
    setSubmitted(true);
  };

  const clearQuery = () => {
    setQuery('');
    setSubmitted(false);
  };

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <Helmet>
        <title>Search — TransferMap</title>
        <meta name="description" content="Search for players, clubs, and transfer news on TransferMap." />
        <meta property="og:title" content="Search — TransferMap" />
        <meta name="twitter:title" content="Search — TransferMap" />
      </Helmet>
      {/* Topbar */}
      <div className="flex items-center gap-4 px-6 h-14 border-b border-[var(--border)] flex-shrink-0"
        style={{ background: 'var(--surface)' }}>
        <button onClick={() => navigate(-1)}
          className="text-[0.84rem] font-bold text-[var(--text-sub)] hover:text-[var(--text)] transition-colors">
          ← TransferMap
        </button>
        <div className="flex-1 relative flex items-center">
          <span className="absolute left-3 text-[1.1rem] text-[var(--text-sub)] pointer-events-none select-none">⌕</span>
          <input
            value={query}
            onChange={e => { setQuery(e.target.value); if (!e.target.value) setSubmitted(false); }}
            onKeyDown={handleKeyDown}
            placeholder="search players, clubs, journalists, transfers…"
            className="w-full bg-[var(--surface2)] border border-[var(--border)] rounded-lg
                       pl-10 pr-4 py-2 text-[0.9rem] text-[var(--text)] placeholder-[var(--text-sub)]
                       focus:outline-none focus:border-[var(--accent)]/50 transition-colors"
          />
          {query && (
            <button onClick={clearQuery}
              className="absolute right-3 text-[var(--text-sub)] hover:text-[var(--text)] text-sm">✕</button>
          )}
        </div>
        <button onClick={handleSearch}
          className="bg-[var(--accent)] hover:bg-blue-400 text-white text-[0.78rem] font-bold tracking-widest
                     uppercase px-4 py-2 rounded-md transition-colors flex-shrink-0">
          SEARCH
        </button>
      </div>

      {results ? (
        /* ── RESULTS STATE ── */
        <div className="flex flex-1 overflow-hidden">
          {/* Left filter rail */}
          <div className="w-64 flex-shrink-0 border-r border-[var(--border)] overflow-y-auto py-5 px-4"
            style={{ background: 'var(--surface)' }}>
            <div className="flex items-center justify-between mb-4">
              <span className="text-[0.7rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">REFINE</span>
              <button onClick={() => setFilters({
                types: new Set(['players', 'clubs', 'news', 'journalists']),
                leagues: new Set(['pl', 'll', 'bl', 'sa', 'l1']),
                statuses: new Set(['rumour', 'confirmed', 'denied', 'loan']),
                feeMin: 0, feeMax: 250,
              })} className="text-[0.7rem] text-[var(--text-sub)] hover:text-[var(--text)]">↻ reset</button>
            </div>

            {/* Type */}
            <FilterSection label="TYPE">
              {([['players', 'Players', results.players.length], ['clubs', 'Clubs', results.clubs.length],
                 ['journalists', 'Journalists', results.journalists.length], ['news', 'News', results.news.length]] as [string, string, number][])
                .map(([val, label, count]) => (
                  <FilterRow key={val} checked={filters.types.has(val)} label={label} count={count}
                    onChange={() => toggleSet('types', val)} />
                ))}
            </FilterSection>

            {/* League */}
            <FilterSection label="LEAGUE">
              {(['pl', 'll', 'bl', 'sa', 'l1'] as const).map(id => (
                <FilterRow key={id} checked={filters.leagues.has(id)} label={LEAGUE_NAMES[id]}
                  count={CLUBS.filter(c => c.league === id).length}
                  onChange={() => toggleSet('leagues', id)} />
              ))}
            </FilterSection>

            {/* Status */}
            <FilterSection label="STATUS">
              {(['rumour', 'confirmed', 'denied', 'loan'] as const).map(s => (
                <FilterRow key={s} checked={filters.statuses.has(s)}
                  label={s.charAt(0).toUpperCase() + s.slice(1)}
                  count={NEWS.filter(n => n.status === s).length}
                  onChange={() => toggleSet('statuses', s)} />
              ))}
            </FilterSection>

            {/* Fee range */}
            <div className="mt-2">
              <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">FEE RANGE</div>
              <div className="flex items-center justify-between text-[0.72rem] text-[var(--text-sub)] mb-1.5">
                <span>€{filters.feeMin}M</span>
                <span>€{filters.feeMax}M</span>
              </div>
              <input type="range" min={0} max={250} step={10}
                value={filters.feeMax}
                onChange={e => setFilters(prev => ({ ...prev, feeMax: Number(e.target.value) }))}
                className="w-full accent-[var(--accent)]" />
            </div>
          </div>

          {/* Main results */}
          <div className="flex-1 overflow-y-auto">
            {/* Results header */}
            <div className="sticky top-0 z-10 flex items-center justify-between px-6 py-3 border-b border-[var(--border)]"
              style={{ background: 'var(--surface)' }}>
              <div className="text-[0.75rem] text-[var(--text-sub)]">
                <span className="font-bold text-[var(--text)]">{total}</span> results
              </div>
              <div className="flex items-center gap-3">
                <div className="flex gap-1">
                  {(['LIST', 'GRID'] as const).map(m => (
                    <button key={m} onClick={() => setViewMode(m)}
                      className={`text-[0.65rem] font-bold tracking-widest px-2.5 py-1 rounded border transition-colors
                        ${viewMode === m
                          ? 'bg-[var(--accent)]/20 border-[var(--accent)]/50 text-[var(--accent)]'
                          : 'border-[var(--border)] text-[var(--text-sub)] hover:text-[var(--text)]'}`}>
                      {m}
                    </button>
                  ))}
                </div>
                <select value={sortBy} onChange={e => setSortBy(e.target.value as typeof sortBy)}
                  className="bg-[var(--surface2)] border border-[var(--border)] text-[0.72rem] text-[var(--text-sub)]
                             rounded px-2 py-1 focus:outline-none">
                  <option value="relevance">sort: relevance</option>
                  <option value="fee">sort: fee ↓</option>
                  <option value="recent">sort: recent</option>
                </select>
              </div>
            </div>

            <div className="px-6 py-4 flex flex-col gap-6">
              {/* Players */}
              {results.players.length > 0 && (
                <ResultGroup label={`PLAYERS · ${results.players.length}`}>
                  {viewMode === 'LIST' ? (
                    results.players.map(p => (
                      <button key={p.id} onClick={() => navigate(`/players/${p.id}`)}
                        className="w-full flex items-center gap-5 p-4 rounded-xl border border-[var(--border)]
                                   bg-[var(--surface)] hover:border-[var(--accent)]/40 hover:bg-[var(--accent)]/5
                                   transition-all text-left group">
                        <div className="w-12 h-12 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                                        flex items-center justify-center text-2xl flex-shrink-0">{p.emoji}</div>
                        <div className="flex-1 min-w-0">
                          <div className="font-bold text-[var(--text)] text-[0.95rem]">{p.name}</div>
                          <div className="text-[0.75rem] text-[var(--text-sub)] mt-0.5">
                            {p.position} · {p.age} · {p.nationality} · {p.currentClub}
                          </div>
                        </div>
                        <div className="text-right flex-shrink-0">
                          <div className="font-black text-[var(--text)] text-[0.95rem]">{p.marketValue}</div>
                          <div className="text-[0.65rem] text-[var(--text-sub)]">market value</div>
                        </div>
                        <span className="text-[var(--accent)] opacity-0 group-hover:opacity-100 transition-opacity ml-2">→</span>
                      </button>
                    ))
                  ) : (
                    <div className="grid grid-cols-2 gap-3">
                      {results.players.map(p => (
                        <button key={p.id} onClick={() => navigate(`/players/${p.id}`)}
                          className="flex flex-col items-center gap-2 p-5 rounded-xl border border-[var(--border)]
                                     bg-[var(--surface)] hover:border-[var(--accent)]/40 transition-all text-center">
                          <div className="text-3xl">{p.emoji}</div>
                          <div className="font-bold text-[var(--text)] text-[0.9rem]">{p.name}</div>
                          <div className="text-[0.72rem] text-[var(--text-sub)]">{p.position} · {p.currentClub}</div>
                          <div className="font-black text-[var(--accent)]">{p.marketValue}</div>
                        </button>
                      ))}
                    </div>
                  )}
                </ResultGroup>
              )}

              {/* Clubs */}
              {results.clubs.length > 0 && (
                <ResultGroup label={`CLUBS · ${results.clubs.length}`}>
                  {results.clubs.map(c => (
                    <div key={c.id}
                      className="flex items-center gap-4 p-4 rounded-xl border border-[var(--border)]
                                 bg-[var(--surface)]">
                      <div className="w-10 h-10 rounded-lg bg-[var(--surface2)] border border-[var(--border)]
                                      flex items-center justify-center text-xl flex-shrink-0">{c.emoji}</div>
                      <div className="flex-1 min-w-0">
                        <div className="font-bold text-[var(--text)] text-[0.9rem]">{c.name}</div>
                        <div className="text-[0.72rem] text-[var(--text-sub)] mt-0.5">
                          {LEAGUE_NAMES[c.league]} · {NEWS.filter(n => n.from === c.name || n.to === c.name).length} news items
                        </div>
                      </div>
                    </div>
                  ))}
                </ResultGroup>
              )}

              {/* Journalists */}
              {results.journalists.length > 0 && (
                <ResultGroup label={`JOURNALISTS · ${results.journalists.length}`}>
                  {results.journalists.map(j => (
                    <button key={j.id} onClick={() => navigate(`/journalists/${j.id}`)}
                      className="w-full flex items-center gap-4 p-4 rounded-xl border border-[var(--border)]
                                 bg-[var(--surface)] hover:border-[var(--accent)]/40 hover:bg-[var(--accent)]/5
                                 transition-all text-left group">
                      <div className="w-10 h-10 rounded-full bg-[var(--surface2)] border border-[var(--border)]
                                      flex items-center justify-center text-lg flex-shrink-0">✎</div>
                      <div className="flex-1 min-w-0">
                        <div className="font-bold text-[var(--text)] text-[0.9rem]">{j.name}</div>
                        <div className="text-[0.72rem] text-[var(--text-sub)] mt-0.5">
                          {j.handle} · {j.outlet}
                        </div>
                      </div>
                      <div className="text-right flex-shrink-0">
                        <div className="font-black text-[var(--accent)] text-[1.1rem]">{j.score?.toFixed(1)}</div>
                        <div className="text-[0.62rem] text-[var(--text-sub)]">credibility</div>
                      </div>
                      <span className="text-[var(--accent)] opacity-0 group-hover:opacity-100 transition-opacity ml-2">→</span>
                    </button>
                  ))}
                </ResultGroup>
              )}

              {/* News */}
              {results.news.length > 0 && (
                <ResultGroup label={`NEWS · ${results.news.length}`}>
                  {results.news.map(n => (
                    <div key={n.id}
                      className="p-4 rounded-xl border border-[var(--border)] bg-[var(--surface)] flex flex-col gap-2">
                      <div className="flex items-center justify-between gap-3">
                        <div className="font-bold text-[var(--text)] text-[0.9rem]">{n.player}</div>
                        <span className={`text-[0.62rem] font-bold px-2.5 py-0.5 rounded-full border flex-shrink-0 ${STATUS_STYLE[n.status] ?? ''}`}>
                          {n.status.toUpperCase()}
                        </span>
                      </div>
                      <div className="text-[0.82rem] text-[var(--text-sub)]">
                        {n.from} <span className="text-[var(--accent)] mx-2">→</span> {n.to}
                        {n.fee && <span className="ml-3 font-bold text-[var(--text)]">{n.fee}</span>}
                      </div>
                      <div className="text-[0.7rem] text-[var(--text-sub)] opacity-60">
                        {n.journalist} · {n.time}
                      </div>
                    </div>
                  ))}
                </ResultGroup>
              )}

              {total === 0 && (
                <div className="text-center py-24">
                  <div className="text-5xl mb-4 opacity-20">⌕</div>
                  <div className="text-[0.9rem] font-bold text-[var(--text-sub)]">No results found</div>
                  <div className="text-[0.78rem] text-[var(--text-sub)] mt-2 opacity-60">Try adjusting your filters or search term</div>
                </div>
              )}
            </div>
          </div>
        </div>
      ) : (
        /* ── EMPTY STATE ── */
        <div className="flex-1 overflow-y-auto flex flex-col items-center pt-16 pb-12 px-6">
          <div className="text-6xl mb-4 opacity-10">⌕</div>
          <h2 className="text-[1.4rem] font-black uppercase tracking-widest text-[var(--text)]">
            What are you looking for?
          </h2>
          <p className="mt-2 text-[0.84rem] text-[var(--text-sub)] italic">
            try free-text or pick a quick filter below
          </p>

          {/* Quick filters */}
          <div className="mt-10 w-full max-w-xl">
            <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3 text-center">
              QUICK FILTERS
            </div>
            <div className="grid grid-cols-3 gap-2">
              {QUICK_FILTERS.map(label => (
                <button key={label} onClick={() => handleQuickFilter(label)}
                  className="py-2.5 px-3 rounded-lg border border-[var(--border)] bg-[var(--surface)]
                             text-[0.78rem] font-bold text-[var(--text-sub)] hover:text-[var(--text)]
                             hover:border-[var(--accent)]/50 hover:bg-[var(--accent)]/5 transition-all">
                  {label}
                </button>
              ))}
            </div>
          </div>

          {/* Recent searches */}
          <div className="mt-10 w-full max-w-xl">
            <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">RECENT</div>
            <div className="border-t border-[var(--border)]">
              {RECENT_SEARCHES.map((s, i) => (
                <div key={i} className="flex items-center justify-between py-3 border-b border-[var(--border)]">
                  <button onClick={() => handleRecent(s)}
                    className="flex items-center gap-3 text-[0.84rem] text-[var(--text-sub)] hover:text-[var(--text)] transition-colors text-left">
                    <span className="opacity-50">⌕</span> {s}
                  </button>
                  <span className="text-[var(--text-sub)] opacity-40 text-sm cursor-default">✕</span>
                </div>
              ))}
            </div>
          </div>

          {/* Saved searches */}
          <div className="mt-8 w-full max-w-xl">
            <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">
              SAVED · {SAVED_SEARCHES.length}
            </div>
            <div className="flex flex-col gap-2">
              {SAVED_SEARCHES.map((s, i) => (
                <button key={i}
                  className="w-full text-left px-4 py-3 rounded-lg border border-[var(--border)] bg-[var(--surface)]
                             text-[0.84rem] text-[var(--text-sub)] hover:text-[var(--text)]
                             hover:border-[var(--accent)]/40 transition-all">
                  {s}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function ResultGroup({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3">{label}</div>
      <div className="flex flex-col gap-2">{children}</div>
    </div>
  );
}

function FilterSection({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="mb-5">
      <div className="text-[0.62rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2">{label}</div>
      <div className="flex flex-col gap-1">{children}</div>
      <div className="mt-3 border-b border-[var(--border)]" />
    </div>
  );
}

function FilterRow({ checked, label, count, onChange }: {
  checked: boolean; label: string; count: number; onChange: () => void;
}) {
  return (
    <label className="flex items-center justify-between cursor-pointer group">
      <div className="flex items-center gap-2">
        <div className={`w-3.5 h-3.5 rounded-sm border flex items-center justify-center flex-shrink-0 transition-colors
          ${checked ? 'bg-[var(--accent)] border-[var(--accent)]' : 'border-[var(--border)] group-hover:border-[var(--accent)]/50'}`}>
          {checked && <span className="text-white text-[0.5rem] leading-none">✓</span>}
        </div>
        <span className={`text-[0.8rem] transition-colors ${checked ? 'text-[var(--text)]' : 'text-[var(--text-sub)]'}`}>
          {label}
        </span>
      </div>
      <span className="text-[0.7rem] text-[var(--text-sub)] opacity-60">{count}</span>
      <input type="checkbox" className="sr-only" checked={checked} onChange={onChange} />
    </label>
  );
}
