import { useNavigate } from 'react-router-dom';

const STACK = [
  { category: 'Frontend', items: ['React 18', 'TypeScript', 'Vite', 'Tailwind CSS', 'D3.js'] },
  { category: 'Backend',  items: ['Spring Boot 4', 'Java 17', 'PostgreSQL + PostGIS', 'Redis'] },
  { category: 'Infra',    items: ['AWS EC2', 'Docker Compose', 'GitHub Actions', 'Nginx'] },
  { category: 'AI',       items: ['Google Gemini API (tweet parsing)', 'X API v2 (data collection)'] },
];

export default function AboutPage() {
  const navigate = useNavigate();

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button
          onClick={() => navigate('/')}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">
          ← Map
        </button>
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">About</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
        <div className="flex flex-col gap-8">

          <section>
            <h1 className="text-[1.4rem] font-black tracking-wide mb-3">
              Transfer<span className="text-[var(--accent)]">Map</span>
            </h1>
            <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
              TransferMap visualises European football transfer market news in real time.
              Posts from credibility-ranked journalists on X (Twitter) are collected and parsed
              to display transfer rumours and confirmed moves on an interactive map.
            </p>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">Key Features</h2>
            <ul className="text-[0.84rem] text-[var(--text-sub)] space-y-2 list-disc list-inside">
              <li>Interactive map of Europe's top 5 league clubs</li>
              <li>Gemini AI-powered automatic transfer tweet parsing</li>
              <li>Journalist credibility score (speed · accuracy · impact)</li>
              <li>Transfer news filter by season, window, and status</li>
            </ul>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">Tech Stack</h2>
            <div className="flex flex-col gap-3">
              {STACK.map(s => (
                <div key={s.category}
                  className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-6 py-4 flex items-start gap-6">
                  <span className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] w-20 shrink-0 pt-0.5">
                    {s.category}
                  </span>
                  <div className="flex flex-wrap gap-2">
                    {s.items.map(item => (
                      <span key={item}
                        className="text-[0.75rem] bg-white/5 border border-[var(--border)] px-2.5 py-1 rounded-md text-[var(--text)]">
                        {item}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">Data Sources</h2>
            <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
              Transfer news is collected from public journalist X accounts. Data is for reference only and does not constitute official announcements.
              For club/player data errors or journalist registration requests, please use the{' '}
              <a href="/contact"
                onClick={e => { e.preventDefault(); navigate('/contact'); }}
                className="text-[var(--accent)] hover:underline">
                Contact
              </a>
              {' '}page.
            </p>
          </section>

        </div>
      </div>
    </div>
  );
}
