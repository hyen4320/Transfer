import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { fetchPlayer, fetchPlayerTransfers } from '../api/players';
import { ApiError } from '../api/client';
import type { ApiPlayer } from '../api/types';
import type { NewsItem, TransferHistory } from '../types';
import NewsCard from './NewsCard';
import AdSlot, { SLOT } from './AdSlot';

const STATUS_STYLE: Record<string, string> = {
  rumour:    'bg-yellow-500/15 text-yellow-400 border-yellow-500/30',
  confirmed: 'bg-green-500/15  text-green-400  border-green-500/30',
  denied:    'bg-red-500/15    text-red-400    border-red-500/30',
  loan:      'bg-blue-500/15   text-blue-400   border-blue-500/30',
};

export default function PlayerDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [player,  setPlayer]  = useState<ApiPlayer | null>(null);
  const [history, setHistory] = useState<TransferHistory[]>([]);
  const [news,    setNews]    = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const numId = Number(id);
    if (!id || isNaN(numId)) { navigate('/404', { replace: true }); return; }

    Promise.all([fetchPlayer(numId), fetchPlayerTransfers(numId)])
      .then(([p, { history: h, news: n }]) => {
        setPlayer(p);
        setHistory(h);
        setNews(n);
      })
      .catch(err => {
        if (err instanceof ApiError && err.status >= 500) {
          navigate('/500', { replace: true }); return;
        }
        navigate('/404', { replace: true });
      })
      .finally(() => setLoading(false));
  }, [id, navigate]);

  if (loading) {
    return (
      <div className="absolute inset-0 bg-[var(--bg)] z-50 flex items-center justify-center">
        <div className="text-[0.84rem] text-[var(--text-sub)]">Loading…</div>
      </div>
    );
  }

  if (!player) return null;

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button onClick={() => navigate(-1)}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">← Back</button>
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Player Profile</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-12">
        <div className="flex gap-8 items-start max-w-5xl mx-auto">
        {/* MPU 사이드바 — 스티키, 화면 넓을 때만 */}
        <aside className="hidden xl:flex flex-col gap-6 w-[300px] flex-shrink-0 sticky top-0">
          <AdSlot slot={SLOT.MPU_SIDEBAR_1} style={{ minHeight: 250 }} className="rounded-xl overflow-hidden" />
          <AdSlot slot={SLOT.MPU_SIDEBAR_2} style={{ minHeight: 250 }} className="rounded-xl overflow-hidden" />
        </aside>
        <div className="flex-1 min-w-0 flex flex-col gap-10">

          {/* Profile card */}
          <div className="bg-[var(--surface)] border border-[var(--border)] rounded-2xl p-10">
            <div className="flex items-start gap-7">
              <div className="w-24 h-24 rounded-2xl bg-[var(--surface2)] border border-[var(--border)]
                              flex items-center justify-center text-5xl flex-shrink-0">
                👤
              </div>
              <div className="flex-1 min-w-0">
                <h1 className="text-2xl font-extrabold text-[var(--text)]">{player.name}</h1>
                <div className="flex flex-wrap gap-2.5 mt-4">
                  {[player.nationality, player.position].filter(Boolean).map(tag => (
                    <span key={tag}
                      className="text-[0.76rem] bg-[var(--surface2)] border border-[var(--border)]
                                 px-3.5 py-1.5 rounded-full text-[var(--text-sub)]">
                      {tag}
                    </span>
                  ))}
                </div>
              </div>
            </div>

            <div className="mt-9 pt-9 border-t border-[var(--border)] grid grid-cols-2 gap-8">
              <div>
                <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2.5">Current Club</div>
                <div className="text-[1rem] font-bold text-[var(--text)]">{player.currentClubName ?? '—'}</div>
              </div>
              {player.contractUntil && (
                <div>
                  <div className="text-[0.65rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-2.5">Contract Until</div>
                  <div className="text-[1rem] font-bold text-[var(--text)]">{player.contractUntil}</div>
                </div>
              )}
            </div>
          </div>

          {/* Transfer history */}
          {history.length > 0 && (
            <div>
              <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 px-1">
                Transfer History
              </div>
              <div className="relative">
                <div className="absolute left-[6.5rem] top-3 bottom-8 w-px bg-[var(--border)]" />
                <div className="flex flex-col">
                  {[...history].reverse().map((h, i) => (
                    <div key={i} className="relative flex items-start gap-6 pb-9 last:pb-0">
                      <div className="w-24 text-right text-[0.78rem] font-bold text-[var(--text-sub)] pt-3 flex-shrink-0">
                        {h.year}
                      </div>
                      <div className="relative z-10 mt-3.5 w-3.5 h-3.5 rounded-full bg-[var(--accent)] border-2 border-[var(--bg)]
                                      flex-shrink-0 shadow-[0_0_8px_rgba(59,130,246,0.7)]" />
                      <div className="flex-1 bg-[var(--surface)] border border-[var(--border)] rounded-xl px-6 py-5">
                        <div className="flex items-center justify-between gap-4">
                          <div className="text-[0.9rem] font-bold text-[var(--text)]">
                            {h.from}
                            <span className="text-[var(--accent)] mx-3">→</span>
                            {h.to}
                          </div>
                          <span className={`text-[0.63rem] font-bold px-3 py-1 rounded-full border flex-shrink-0 ${STATUS_STYLE[h.status]}`}>
                            {h.status.toUpperCase()}
                          </span>
                        </div>
                        <div className="text-[0.78rem] text-[rgba(200,220,255,0.6)] mt-2.5">{h.fee}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* 인터섹션 광고 — 타임라인과 관련 뉴스 사이 */}
          <AdSlot
            slot={SLOT.INTER_SECTION}
            format="auto"
            className="rounded-xl overflow-hidden border-t border-b border-[var(--border)] py-1"
            style={{ minHeight: 90 }}
          />

          {/* Related news */}
          <div>
            <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-5 px-1">
              Related News · {news.length}
            </div>
            {news.length === 0
              ? <div className="text-center py-20 text-[0.84rem] text-[var(--text-sub)]">No related news</div>
              : news.map(n => <NewsCard key={n.id} item={n} />)
            }
          </div>
        </div>{/* flex-1 content */}
        </div>{/* flex gap-8 */}
      </div>
    </div>
  );
}
