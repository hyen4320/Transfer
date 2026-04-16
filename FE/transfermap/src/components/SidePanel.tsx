import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useNews } from '../hooks/useNews';
import { fetchClub, fetchClubTransfers } from '../api/clubs';
import { ApiError } from '../api/client';
import type { ApiClub } from '../api/types';
import type { NewsItem } from '../types';
import NewsCard from './NewsCard';

const STATUS_STYLE: Record<string, string> = {
  rumour:    'bg-yellow-500/15 text-yellow-400 border-yellow-500/30',
  confirmed: 'bg-green-500/15  text-green-400  border-green-500/30',
  denied:    'bg-red-500/15    text-red-400    border-red-500/30',
  loan:      'bg-blue-500/15   text-blue-400   border-blue-500/30',
};

interface Props {
  open: boolean;
  onClose: () => void;
  selectedClubId?: number | null;
}

export default function SidePanel({ open, onClose, selectedClubId }: Props) {
  const navigate = useNavigate();

  const [view,    setView]    = useState<'news' | 'club'>('news');
  const [clubTab, setClubTab] = useState<'in' | 'out'>('in');
  const [filters, setFilters] = useState({ rumour: true, confirmed: true, denied: false });

  const [clubDetail,    setClubDetail]    = useState<ApiClub | null>(null);
  const [clubTransfers, setClubTransfers] = useState<{ incoming: NewsItem[]; outgoing: NewsItem[] }>({ incoming: [], outgoing: [] });
  const [clubLoading,   setClubLoading]   = useState(false);

  const { items: allNews, loading: newsLoading } = useNews();

  const toggleFilter = (key: keyof typeof filters) =>
    setFilters(f => ({ ...f, [key]: !f[key] }));

  const filteredNews = allNews.filter(n => filters[n.status as keyof typeof filters] ?? true);

  // 클럽 ID가 바뀌면 API 조회 후 클럽 뷰로 전환
  useEffect(() => {
    if (!selectedClubId) {
      setView('news');
      setClubDetail(null);
      return;
    }
    setView('club');
    setClubTab('in');
    setClubLoading(true);
    Promise.all([fetchClub(selectedClubId), fetchClubTransfers(selectedClubId)])
      .then(([detail, transfers]) => {
        setClubDetail(detail);
        setClubTransfers(transfers);
      })
      .catch(err => {
        if (err instanceof ApiError && err.status >= 500) navigate('/500');
      })
      .finally(() => setClubLoading(false));
  }, [selectedClubId, navigate]);

  const activeTransfers = clubTab === 'in' ? clubTransfers.incoming : clubTransfers.outgoing;

  return (
    <div className={`absolute top-0 right-0 w-[460px] h-screen flex flex-col z-40
                     bg-[rgba(8,14,26,0.96)] backdrop-blur-xl border-l border-[var(--border)]
                     transition-transform duration-[350ms] ease-[cubic-bezier(0.4,0,0.2,1)]
                     ${open ? 'translate-x-0' : 'translate-x-full'}`}>

      {/* ── NEWS VIEW ── */}
      {view === 'news' && (
        <>
          <div className="flex items-center justify-between px-7 py-6 border-b border-[var(--border)] flex-shrink-0">
            <div className="text-[0.92rem] font-bold tracking-widest uppercase">Transfer Feed</div>
            <button onClick={onClose}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] hover:border-white/20 transition-all">✕</button>
          </div>

          <div className="flex gap-3 flex-wrap px-7 py-6 border-b border-[var(--border)] flex-shrink-0">
            {(['rumour', 'confirmed', 'denied'] as const).map(s => (
              <button key={s} onClick={() => toggleFilter(s)}
                className={`px-5 py-2.5 rounded-full text-[0.72rem] font-bold tracking-widest border transition-all
                  ${s === 'rumour'    ? 'bg-yellow-500/15 text-yellow-400 border-yellow-500/30' : ''}
                  ${s === 'confirmed' ? 'bg-green-500/15  text-green-400  border-green-500/30'  : ''}
                  ${s === 'denied'    ? 'bg-red-500/15    text-red-400    border-red-500/30'    : ''}
                  ${filters[s] ? 'opacity-100' : 'opacity-35'}`}>
                {s.toUpperCase()}
              </button>
            ))}
          </div>

          <div className="flex-1 overflow-y-auto py-5">
            {newsLoading
              ? <div className="flex items-center justify-center h-32 text-[0.82rem] text-[var(--text-sub)]">Loading…</div>
              : filteredNews.map((n, i) => <NewsCard key={n.id ?? i} item={n} />)
            }
          </div>
        </>
      )}

      {/* ── CLUB VIEW ── */}
      {view === 'club' && (
        <>
          <div className="flex items-center px-7 py-6 border-b border-[var(--border)] gap-3 flex-shrink-0">
            <button onClick={() => { setView('news'); }}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] transition-all">←</button>
            <div className="text-[0.92rem] font-bold tracking-widest uppercase flex-1">
              {clubDetail?.name ?? '…'}
            </div>
            <button onClick={onClose}
              className="w-9 h-9 rounded-lg border border-[var(--border)] flex items-center justify-center
                         text-[var(--text-sub)] hover:text-[var(--text)] transition-all">✕</button>
          </div>

          {clubLoading ? (
            <div className="flex-1 flex items-center justify-center text-[0.82rem] text-[var(--text-sub)]">
              Loading…
            </div>
          ) : clubDetail && (
            <>
              {/* Club info */}
              <div className="px-7 py-7 border-b border-[var(--border)] flex-shrink-0">
                <div className="flex items-center gap-5 mb-6">
                  <div className="w-14 h-14 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                                  flex items-center justify-center text-2xl flex-shrink-0">🏟️</div>
                  <div>
                    <h2 className="text-[1.05rem] font-extrabold">{clubDetail.name}</h2>
                    <div className="text-[0.76rem] text-[var(--text-sub)] mt-1.5 space-y-0.5">
                      {clubDetail.leagueName && <div>{clubDetail.leagueName}</div>}
                      {clubDetail.city && <div>{clubDetail.city}{clubDetail.countryCode ? ` · ${clubDetail.countryCode}` : ''}</div>}
                      {clubDetail.stadiumName && (
                        <div className="text-[var(--accent)]">{clubDetail.stadiumName}</div>
                      )}
                    </div>
                  </div>
                </div>
                <div className="flex gap-8 text-[0.74rem] text-[var(--text-sub)]">
                  <div>
                    <strong className="block text-[1.4rem] text-[var(--text)] font-extrabold leading-none mb-1.5">
                      {clubTransfers.incoming.length}
                    </strong>Incoming
                  </div>
                  <div>
                    <strong className="block text-[1.4rem] text-[var(--text)] font-extrabold leading-none mb-1.5">
                      {clubTransfers.outgoing.length}
                    </strong>Outgoing
                  </div>
                </div>
              </div>

              {/* Tabs */}
              <div className="flex border-b border-[var(--border)] flex-shrink-0">
                {(['in', 'out'] as const).map(t => (
                  <button key={t} onClick={() => setClubTab(t)}
                    className={`flex-1 py-4 text-[0.76rem] font-bold tracking-wide uppercase border-b-2 transition-all
                      ${clubTab === t
                        ? 'text-[var(--accent)] border-[var(--accent)]'
                        : 'text-[var(--text-sub)] border-transparent'}`}>
                    {t === 'in' ? 'Incoming' : 'Outgoing'}
                  </button>
                ))}
              </div>

              {/* Transfer list */}
              <div className="flex-1 overflow-y-auto py-5">
                {activeTransfers.length === 0
                  ? <div className="py-14 text-center text-[0.82rem] text-[var(--text-sub)]">No transfers</div>
                  : activeTransfers.map((t, i) => (
                      <div key={i} className="mx-5 mb-4 p-6 rounded-xl bg-[var(--surface)] border border-[var(--border)]">
                        <div className="flex items-start justify-between gap-4 mb-3">
                          <div className="text-[0.9rem] font-bold">{t.player}</div>
                          <span className={`px-3 py-1 rounded-full text-[0.64rem] font-bold border flex-shrink-0 ${STATUS_STYLE[t.status] ?? ''}`}>
                            {t.status.toUpperCase()}
                          </span>
                        </div>
                        <div className="text-[0.82rem] text-[rgba(200,220,255,0.6)] mb-2.5">{t.fee}</div>
                        <div className="text-[0.76rem] text-[var(--text-sub)]">
                          {clubTab === 'in' ? `from: ${t.from}` : `to: ${t.to}`}
                        </div>
                      </div>
                    ))
                }
              </div>
            </>
          )}
        </>
      )}
    </div>
  );
}
