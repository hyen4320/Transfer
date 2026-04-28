import { useEffect, useState } from 'react';
import { fetchPlayer, fetchPlayerTransfers } from '../api/players';
import { useIsMobile } from '../hooks/useIsMobile';
import AdSlot, { SLOT } from './AdSlot';
import type { ApiPlayer } from '../api/types';
import type { NewsItem, TransferHistory } from '../types';
import NewsCard from './NewsCard';

const STATUS_STYLE: Record<string, string> = {
  rumour:    'bg-yellow-500/15 text-yellow-400 border-yellow-500/30',
  confirmed: 'bg-green-500/15  text-green-400  border-green-500/30',
  denied:    'bg-red-500/15    text-red-400    border-red-500/30',
  loan:      'bg-blue-500/15   text-blue-400   border-blue-500/30',
};

interface Props {
  playerId: number | null;
  onClose: () => void;
  onNewsLoaded?: (news: NewsItem[]) => void;
}

export default function PlayerPanel({ playerId, onClose, onNewsLoaded }: Props) {
  const isMobile = useIsMobile();
  const [player,  setPlayer]  = useState<ApiPlayer | null>(null);
  const [history, setHistory] = useState<TransferHistory[]>([]);
  const [news,    setNews]    = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error,   setError]   = useState(false);
  const [sheetFull, setSheetFull] = useState(false);

  useEffect(() => {
    if (!playerId) return;
    const controller = new AbortController();
    const { signal } = controller;
    setLoading(true);
    setError(false);
    setPlayer(null);
    setHistory([]);
    setNews([]);
    Promise.all([fetchPlayer(playerId, signal), fetchPlayerTransfers(playerId, signal)])
      .then(([p, { history: h, news: n }]) => {
        setPlayer(p);
        setHistory(h);
        setNews(n);
        setLoading(false);
        onNewsLoaded?.(n);
      })
      .catch(err => {
        if (err.name !== 'AbortError') { setLoading(false); setError(true); }
      });
    return () => controller.abort();
  }, [playerId]);

  const open = playerId != null;

  const mobileTranslate = !open ? 'translate-y-full'
                        : sheetFull ? 'translate-y-0'
                        : 'translate-y-[calc(100%-160px)]';

  return (
    <div className={`flex flex-col z-[60] bg-[rgba(8,14,26,0.96)] backdrop-blur-xl border-[var(--border)]
                     transition-[transform] duration-[350ms] ease-[cubic-bezier(0.4,0,0.2,1)]
                     ${isMobile
                       ? `fixed bottom-0 left-0 right-0 h-[85dvh] border-t rounded-t-2xl ${mobileTranslate}`
                       : `absolute top-0 left-0 w-[460px] h-screen border-r ${open ? 'translate-x-0' : '-translate-x-full'}`
                     }`}>

      {/* Mobile drag handle */}
      {isMobile && (
        <button onClick={() => setSheetFull(f => !f)}
          className="flex-shrink-0 flex flex-col items-center pt-3 pb-1 gap-1 w-full">
          <span className="w-10 h-1 rounded-full bg-white/20" />
          <span className="text-[0.58rem] tracking-widest text-[var(--text-sub)] uppercase">
            {sheetFull ? '▼ Collapse' : '▲ Expand'}
          </span>
        </button>
      )}

      {/* Header */}
      <div className="flex items-center gap-4 px-6 h-[52px] border-b border-[var(--border)] flex-shrink-0">
        <button onClick={onClose}
          className="text-[0.82rem] font-bold text-[var(--text-sub)] hover:text-[var(--text)] transition-colors">
          ← Back
        </button>
        <div className="flex-1 text-[0.82rem] font-bold tracking-widest uppercase truncate">
          {player?.name ?? 'Player'}
        </div>
        <button onClick={onClose}
          className="w-8 h-8 flex items-center justify-center rounded-lg border border-[var(--border)]
                     text-[var(--text-sub)] hover:text-[var(--text)] hover:border-white/20 transition-all text-sm">
          ✕
        </button>
      </div>

      {loading ? (
        <div className="flex-1 flex items-center justify-center text-[0.84rem] text-[var(--text-sub)]">
          Loading…
        </div>
      ) : error ? (
        <div className="flex-1 flex items-center justify-center text-[0.84rem] text-red-400">
          Failed to load player data
        </div>
      ) : !player ? null : (
        <div className="flex-1 overflow-y-auto">

          {/* Profile */}
          <div className="px-6 py-6 border-b border-[var(--border)]">
            <div className="flex items-start gap-5">
              <div className="w-16 h-16 rounded-xl bg-[var(--surface2)] border border-[var(--border)]
                              flex items-center justify-center text-3xl flex-shrink-0">
                👤
              </div>
              <div className="flex-1 min-w-0">
                <div className="text-[1.05rem] font-extrabold leading-tight">{player.name}</div>
                <div className="flex flex-wrap gap-2 mt-3">
                  {[player.nationality, player.position].filter(Boolean).map(tag => (
                    <span key={tag}
                      className="text-[0.72rem] bg-[var(--surface2)] border border-[var(--border)]
                                 px-3 py-1 rounded-full text-[var(--text-sub)]">
                      {tag}
                    </span>
                  ))}
                </div>
              </div>
            </div>

            <div className="mt-5 pt-5 border-t border-[var(--border)] grid grid-cols-2 gap-4">
              <div>
                <div className="text-[0.62rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-1.5">Current Club</div>
                <div className="text-[0.88rem] font-bold">{player.currentClubName || '—'}</div>
              </div>
              {player.contractUntil && (
                <div>
                  <div className="text-[0.62rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-1.5">Contract Until</div>
                  <div className="text-[0.88rem] font-bold">{player.contractUntil}</div>
                </div>
              )}
              {player.currentLeagueName && (
                <div className="col-span-2">
                  <div className="text-[0.62rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-1.5">League</div>
                  <div className="text-[0.88rem] font-bold">{player.currentLeagueName}</div>
                </div>
              )}
            </div>
          </div>

          {/* Transfer history */}
          {history.length > 0 && (
            <div className="px-6 py-5 border-b border-[var(--border)]">
              <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-4">
                Transfer History
              </div>
              <div className="relative">
                <div className="absolute left-[3.8rem] top-3 bottom-3 w-px bg-[var(--border)]" />
                <div className="flex flex-col">
                  {[...history].reverse().map((h, i) => (
                    <div key={i} className="relative flex items-start gap-4 pb-5 last:pb-0">
                        <div className="w-12 text-right text-[0.7rem] font-bold text-[var(--text-sub)] pt-2.5 flex-shrink-0">
                          {h.year}
                        </div>
                        <div className="relative z-10 mt-3 w-3 h-3 rounded-full bg-[var(--accent)] border-2 border-[var(--bg)]
                                        flex-shrink-0 shadow-[0_0_6px_rgba(59,130,246,0.7)]" />
                        <div className="flex-1 bg-[var(--surface)] border border-[var(--border)] rounded-xl px-4 py-3">
                          <div className="flex items-center justify-between gap-2 flex-wrap">
                            <div className="text-[0.82rem] font-bold">
                              {h.from}
                              <span className="text-[var(--accent)] mx-2">→</span>
                              {h.to}
                            </div>
                            <span className={`text-[0.58rem] font-bold px-2.5 py-0.5 rounded-full border flex-shrink-0 ${STATUS_STYLE[h.status]}`}>
                              {h.status.toUpperCase()}
                            </span>
                          </div>
                          <div className="text-[0.74rem] text-[rgba(200,220,255,0.6)] mt-1.5">{h.fee}</div>
                        </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* Related news */}
          {news.length > 0 && (
            <div className="py-4">
              <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-3 px-6">
                Related News · {news.length}
              </div>
              {news.map(n => <NewsCard key={n.id} item={n} />)}
              <AdSlot
                slot={SLOT.MPU_SIDEBAR_1}
                format="auto"
                className="mx-6 mt-3 rounded-xl overflow-hidden border border-[var(--border)]"
                style={{ minHeight: 100 }}
              />
            </div>
          )}

          {history.length === 0 && news.length === 0 && !loading && (
            <div className="flex-1 flex items-center justify-center py-20 text-[0.82rem] text-[var(--text-sub)]">
              No transfer history found
            </div>
          )}
        </div>
      )}
    </div>
  );
}
