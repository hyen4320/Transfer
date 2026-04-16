import { useNavigate } from 'react-router-dom';
import { useJournalists } from '../hooks/useJournalists';

interface Props {
  onBack: () => void;
}

export default function JournalistPage({ onBack }: Props) {
  const navigate = useNavigate();
  const { items: journalists, loading } = useJournalists();

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button onClick={onBack}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">← Map</button>
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Journalist Ranking</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10">
        {loading ? (
          <div className="flex items-center justify-center h-40 text-[0.84rem] text-[var(--text-sub)]">Loading…</div>
        ) : (
          <table className="w-full border-collapse">
            <thead>
              <tr className="border-b border-[var(--border)]">
                {['#', 'Journalist', 'Followers', 'Credibility', 'Speed · Accuracy · Impact'].map(h => (
                  <th key={h} className="text-left text-[0.68rem] font-bold tracking-widest uppercase
                                         text-[var(--text-sub)] pb-5 px-6">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {journalists.map((j, i) => (
                <tr key={j.id}
                  className="border-b border-[var(--border)] hover:bg-[var(--surface)] cursor-pointer transition-colors group"
                  onClick={() => navigate(`/journalists/${j.id}`)}>
                  <td className="px-6 py-6">
                    <span className={`text-xl font-black ${i < 3 ? 'text-amber-400' : 'text-[var(--text-sub)]'}`}>{i + 1}</span>
                  </td>
                  <td className="px-6 py-6">
                    <div className="font-bold text-[0.92rem] group-hover:text-[var(--accent)] transition-colors">{j.name}</div>
                    <div className="text-[var(--accent)] text-[0.78rem] mt-1">{j.handle}</div>
                  </td>
                  <td className="px-6 py-6 text-[var(--text-sub)] text-[0.86rem]">{j.followers}</td>
                  <td className="px-6 py-6">
                    <span className="text-[0.88rem] font-bold text-[var(--accent)] bg-[var(--accent-glow)] px-3.5 py-2 rounded-full">
                      {j.score?.toFixed(1) ?? '—'}
                    </span>
                  </td>
                  <td className="px-6 py-6">
                    {([
                      ['Speed',  j.speed,    'bg-blue-500'],
                      ['Acc',    j.accuracy, 'bg-green-500'],
                      ['Impact', j.impact,   'bg-amber-500'],
                    ] as const).map(([label, val, cls]) => (
                      <div key={label} className="flex items-center gap-3 mb-2 last:mb-0">
                        <div className="w-12 text-[0.66rem] text-[var(--text-sub)]">{label}</div>
                        <div className="flex-1 h-2 bg-[var(--surface2)] rounded-full overflow-hidden">
                          <div className={`h-full rounded-full ${cls}`} style={{ width: `${val}%` }} />
                        </div>
                        <div className="w-8 text-right text-[0.66rem] text-[var(--text-sub)]">{val?.toFixed(0) ?? '—'}</div>
                      </div>
                    ))}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
