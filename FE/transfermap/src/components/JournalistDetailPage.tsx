import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet-async';
import { fetchJournalist, fetchJournalistNews } from '../api/journalists';
import { ApiError } from '../api/client';
import type { Journalist, NewsItem } from '../types';
import NewsCard from './NewsCard';

export default function JournalistDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [journalist, setJournalist] = useState<Journalist | null>(null);
  const [news,       setNews]       = useState<NewsItem[]>([]);
  const [loading,    setLoading]    = useState(true);

  useEffect(() => {
    const numId = Number(id);
    if (!id || isNaN(numId)) { navigate('/404', { replace: true }); return; }

    Promise.all([fetchJournalist(numId), fetchJournalistNews(numId)])
      .then(([j, n]) => {
        setJournalist(j);
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

  if (!journalist) return null;

  const title = `${journalist.name} (${journalist.handle}) — TransferMap`;
  const description = `${journalist.name} transfer news reporter${journalist.outlet ? ` at ${journalist.outlet}` : ''}. Credibility score: ${journalist.score?.toFixed(1) ?? '—'}/100.`;

  const bars = [
    { label: 'Speed',    value: journalist.speed,    color: '#3b82f6', weight: '×0.3' },
    { label: 'Accuracy', value: journalist.accuracy, color: '#22c55e', weight: '×0.5' },
    { label: 'Impact',   value: journalist.impact,   color: '#f59e0b', weight: '×0.2' },
  ];

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <Helmet>
        <title>{title}</title>
        <meta name="description" content={description} />
        <meta property="og:title" content={title} />
        <meta property="og:description" content={description} />
        <meta property="og:type" content="profile" />
        <meta name="twitter:title" content={title} />
        <meta name="twitter:description" content={description} />
      </Helmet>
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button onClick={() => navigate('/journalists')}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">← Journalists</button>
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Journalist Profile</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-12">
        <div className="max-w-2xl mx-auto flex flex-col gap-10">

          {/* Profile card */}
          <div className="bg-[var(--surface)] border border-[var(--border)] rounded-2xl p-10">
            <div className="flex items-start gap-8 mb-10">
              <div className="w-24 h-24 rounded-full bg-[var(--surface2)] border border-[var(--border)]
                              flex items-center justify-center text-4xl flex-shrink-0">✎</div>
              <div className="flex-1 min-w-0">
                <h1 className="text-2xl font-extrabold text-[var(--text)]">{journalist.name}</h1>
                <div className="text-[var(--accent)] text-[0.92rem] mt-2">{journalist.handle}</div>
                <div className="flex flex-wrap gap-2.5 mt-3 text-[0.76rem] text-[var(--text-sub)]">
                  {journalist.country && <span>{journalist.country}</span>}
                  {journalist.outlet  && (
                    <span className="border-l border-[var(--border)] pl-2.5">{journalist.outlet}</span>
                  )}
                  <span className={journalist.country || journalist.outlet ? 'border-l border-[var(--border)] pl-2.5' : ''}>
                    {journalist.followers} followers
                  </span>
                </div>
                {journalist.bio && (
                  <p className="mt-5 text-[0.84rem] text-[var(--text-sub)] leading-relaxed">{journalist.bio}</p>
                )}
              </div>
              <div className="flex-shrink-0 text-right">
                <div className="text-[2.5rem] font-black text-[var(--accent)] leading-none">
                  {journalist.score?.toFixed(1) ?? '—'}
                </div>
                <div className="text-[0.65rem] text-[var(--text-sub)] mt-2 uppercase tracking-widest">Credibility</div>
              </div>
            </div>

            <div className="border-t border-[var(--border)] pt-8 flex flex-col gap-5">
              <div className="text-[0.67rem] font-bold tracking-widest uppercase text-[var(--text-sub)]">
                Score Breakdown
              </div>
              {bars.map(b => (
                <div key={b.label} className="flex items-center gap-5">
                  <div className="w-24 flex items-center justify-between text-[0.76rem] text-[var(--text-sub)]">
                    <span>{b.label}</span>
                    <span className="text-[0.63rem] opacity-50">{b.weight}</span>
                  </div>
                  <div className="flex-1 h-3 bg-[var(--surface2)] rounded-full overflow-hidden">
                    <div className="h-full rounded-full transition-all duration-700"
                      style={{ width: `${b.value ?? 0}%`, background: b.color }} />
                  </div>
                  <div className="w-9 text-right text-[0.78rem] font-bold" style={{ color: b.color }}>
                    {b.value?.toFixed(0) ?? '—'}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* News */}
          <div>
            <div className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-5 px-1">
              Recent Reports · {news.length}
            </div>
            {news.length === 0
              ? <div className="text-center py-20 text-[0.84rem] text-[var(--text-sub)]">No reports found</div>
              : news.map(n => <NewsCard key={n.id} item={n} />)
            }
          </div>
        </div>
      </div>
    </div>
  );
}
