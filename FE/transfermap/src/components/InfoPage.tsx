import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

export default function InfoPage() {
  const navigate = useNavigate();

  useEffect(() => {
    const hash = window.location.hash.slice(1);
    if (!hash) return;
    const el = document.getElementById(hash);
    if (el) el.scrollIntoView({ behavior: 'smooth' });
  }, []);

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="border-b border-[var(--border)] flex-shrink-0 flex justify-center">
        <div className="w-full max-w-3xl px-4 sm:px-8 lg:px-10 py-7 flex items-center gap-5">
          <button
            onClick={() => navigate('/')}
            className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                       hover:text-[var(--text)] hover:border-white/20 transition-all">
            ← Map
          </button>
          <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Info</div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto flex justify-center">
        <div className="w-full max-w-3xl px-4 sm:px-8 lg:px-10 py-10 space-y-16">

        {/* About */}
        <section id="about">
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">About</h2>
          <div className="flex flex-col gap-8">
            <div>
              <h1 className="text-[1.4rem] font-black tracking-wide mb-3">
                Transfer<span className="text-[var(--accent)]">Map</span>
              </h1>
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
                TransferMap visualises European football transfer market news in real time.
                Posts from credibility-ranked journalists on X (Twitter) are collected and parsed
                to display transfer rumours and confirmed moves on an interactive map.
              </p>
            </div>
            <div>
              <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">Key Features</h3>
              <ul className="text-[0.84rem] text-[var(--text-sub)] space-y-2 list-disc list-inside">
                <li>Interactive map of Europe's top 5 league clubs</li>
                <li>Gemini AI-powered automatic transfer tweet parsing</li>
                <li>Journalist credibility score (speed · accuracy · impact)</li>
                <li>Transfer news filter by season, window, and status</li>
              </ul>
            </div>
          </div>
        </section>

        {/* Contact */}
        <section id="contact">
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">Contact</h2>
          <p className="text-[0.84rem] text-[var(--text-sub)] mb-4 leading-relaxed">
            For bug reports, journalist registration requests, or data error reports, please reach out below.
          </p>
          <div className="flex flex-col gap-3">
            <a href="mailto:hyen43204@gmail.com"
              className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                         hover:border-white/15 transition-colors flex items-center justify-between group">
              <div>
                <div className="text-[0.97rem] font-bold mb-1">Email</div>
                <div className="text-[0.82rem] text-[var(--text-sub)]">hyen43204@gmail.com</div>
              </div>
              <span className="text-[var(--text-sub)] group-hover:text-[var(--text)] transition-colors text-lg">→</span>
            </a>
            <a href="https://instagram.com/transfermap_dot_com" target="_blank" rel="noopener noreferrer"
              className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                         hover:border-white/15 transition-colors flex items-center justify-between group">
              <div>
                <div className="text-[0.97rem] font-bold mb-1">Instagram</div>
                <div className="text-[0.82rem] text-[var(--text-sub)]">@transfermap_dot_com</div>
              </div>
              <span className="text-[var(--text-sub)] group-hover:text-[var(--text)] transition-colors text-lg">→</span>
            </a>
            <a href="https://x.com/TheTransferMap" target="_blank" rel="noopener noreferrer"
              className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                         hover:border-white/15 transition-colors flex items-center justify-between group">
              <div>
                <div className="text-[0.97rem] font-bold mb-1">X (Twitter)</div>
                <div className="text-[0.82rem] text-[var(--text-sub)]">@TheTransferMap</div>
              </div>
              <span className="text-[var(--text-sub)] group-hover:text-[var(--text)] transition-colors text-lg">→</span>
            </a>
          </div>
        </section>

        {/* Privacy */}
        <section id="privacy">
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">Privacy Policy</h2>
          <div className="flex flex-col gap-6 text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
            <p className="text-[var(--text)]">
              TransferMap ("the Service") respects your privacy and complies with applicable data protection laws.
            </p>
            {[
              { title: '1. Data Collected', content: 'The Service does not require account registration and does not collect personal information. Access IP address, browser type, and visit timestamp (server access logs) may be generated automatically during operation.' },
              { title: '2. Purpose', content: 'Service stability and security maintenance; error analysis and improvement.' },
              { title: '3. Retention', content: 'Server access logs are automatically deleted oldest-first once capacity limits are exceeded (10 MB per file, up to 3 files).' },
              { title: '4. Third Parties', content: 'Collected information is not shared with third parties except as required by law.' },
              { title: '5. External Services', content: 'X (Twitter) API — collection of public journalist posts. Google Gemini API — tweet content analysis (no personal data is transmitted).' },
              { title: '6. Your Rights', content: 'For log data deletion requests or other privacy inquiries: hyen43204@gmail.com' },
              { title: '7. Policy Changes', content: 'This policy may be revised due to legal or service changes. Updates will be announced via the Notice page.' },
            ].map(item => (
              <div key={item.title}>
                <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-2">{item.title}</h3>
                <p>{item.content}</p>
              </div>
            ))}
            <p className="pt-4 border-t border-[var(--border)]">Effective date: 1 April 2026</p>
          </div>
        </section>

        </div>
      </div>
    </div>
  );
}
