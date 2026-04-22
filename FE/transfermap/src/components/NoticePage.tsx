import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchNotices, type Notice } from '../api/notices';

const TAG_LABEL: Record<Notice['tag'], string> = {
  update:      'Update',
  notice:      'Notice',
  maintenance: 'Maintenance',
};

const TAG_COLOR: Record<Notice['tag'], string> = {
  update:      'text-blue-400 bg-blue-500/10 border-blue-500/30',
  notice:      'text-amber-400 bg-amber-500/10 border-amber-500/30',
  maintenance: 'text-red-400 bg-red-500/10 border-red-500/30',
};

const FALLBACK: Notice[] = [
  {
    id: 3,
    tag: 'update',
    title: 'v1.1 — Club alias matching & search',
    publishedAt: '2026-04-21',
    body: 'Club name aliases (e.g. "Man City" → Manchester City) are now resolved automatically when parsing transfer tweets. The search panel also supports filtering by season, window, and transfer status.',
  },
  {
    id: 2,
    tag: 'notice',
    title: 'Transfer data is sourced from verified journalists only',
    publishedAt: '2026-04-10',
    body: 'All transfer news shown on TransferMap is parsed from posts by credibility-ranked journalists. Credibility scores are calculated based on report speed, accuracy, and impact.',
  },
  {
    id: 1,
    tag: 'update',
    title: 'v1.0 — Initial launch',
    publishedAt: '2026-04-01',
    body: 'TransferMap launches with interactive European map, journalist rankings, and real-time transfer news feed powered by X (Twitter) API.',
  },
];

export default function NoticePage() {
  const navigate = useNavigate();
  const [notices, setNotices] = useState<Notice[]>([]);

  useEffect(() => {
    fetchNotices()
      .then(setNotices)
      .catch(() => setNotices(FALLBACK));
  }, []);

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button
          onClick={() => navigate('/')}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">
          ← Map
        </button>
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Notice</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
        <div className="flex flex-col gap-5">
          {notices.map(n => (
            <div key={n.id}
              className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                         hover:border-white/15 transition-colors">
              <div className="flex items-center gap-3 mb-3">
                <span className={`text-[0.68rem] font-bold tracking-widest uppercase border px-2.5 py-1 rounded-full ${TAG_COLOR[n.tag]}`}>
                  {TAG_LABEL[n.tag]}
                </span>
                <span className="text-[0.78rem] text-[var(--text-sub)]">{n.publishedAt}</span>
              </div>
              <div className="text-[0.97rem] font-bold mb-2">{n.title}</div>
              <div className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">{n.body}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
