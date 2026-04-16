import type { NewsItem } from '../types';

const STATUS_STYLE: Record<string, string> = {
  rumour:    'bg-yellow-500/15 text-yellow-400 border border-yellow-500/30',
  confirmed: 'bg-green-500/15 text-green-400 border border-green-500/30',
  denied:    'bg-red-500/15 text-red-400 border border-red-500/30',
  loan:      'bg-blue-500/15 text-blue-400 border border-blue-500/30',
};

export default function NewsCard({ item }: { item: NewsItem }) {
  return (
    <div className="mx-5 mb-4 p-6 rounded-xl border cursor-pointer transition-all duration-200
                    bg-[var(--surface)] border-[var(--border)]
                    hover:bg-[var(--surface2)] hover:border-blue-500/30 hover:-translate-x-0.5">

      {/* Player + status */}
      <div className="flex items-start justify-between gap-4 mb-4">
        <div className="flex-1">
          <div className="text-[0.95rem] font-bold text-[var(--text)] leading-snug">{item.player}</div>
          <div className="text-[0.8rem] text-[var(--text-sub)] mt-1.5">
            {item.from}
            <span className="text-[var(--accent)] mx-2">→</span>
            {item.to}
          </div>
        </div>
        <span className={`px-[2.6rem] py-[1.14rem] rounded-full text-[0.48rem] font-bold tracking-widest flex-shrink-0 ${STATUS_STYLE[item.status]}`}>
          {item.status.toUpperCase()}
        </span>
      </div>

      {/* Fee */}
      <div className="text-[0.84rem] text-[rgba(200,220,255,0.6)] mb-5">{item.fee}</div>

      {/* Journalist row */}
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-2.5">
          <div className="w-7 h-7 rounded-full bg-[var(--surface2)] border border-[var(--border)]
                          flex items-center justify-center text-[0.62rem] text-[var(--text-sub)] flex-shrink-0">✎</div>
          <div className="text-[0.76rem] text-[var(--text-sub)] leading-snug">
            {item.journalist}
            <span className="text-[var(--accent)] text-[0.68rem] ml-2">{item.handle}</span>
          </div>
        </div>
        <div className="text-right flex-shrink-0">
          <div className="text-[0.7rem] font-bold text-[var(--accent)] bg-[var(--accent-glow)] px-2.5 py-1 rounded-full">
            {item.credibility}
          </div>
          <div className="text-[0.65rem] text-[rgba(160,185,220,0.4)] mt-1.5">{item.time}</div>
        </div>
      </div>
    </div>
  );
}
