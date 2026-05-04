import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet-async';

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
      <Helmet>
        <title>Info — TransferMap</title>
        <meta name="description" content="About TransferMap, contact information, and privacy policy for the European football transfer tracking service." />
        <meta property="og:title" content="Info — TransferMap" />
        <meta name="twitter:title" content="Info — TransferMap" />
      </Helmet>
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
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed mb-3">
                TransferMap is an independent football transfer intelligence platform that tracks
                and visualises player movement across Europe's top five leagues in real time.
                We collect posts from verified, credibility-ranked journalists on X (Twitter),
                parse them automatically using Google Gemini AI, and present the data on an
                interactive geographic map — letting you see transfer rumours and confirmed deals
                exactly where they happen.
              </p>
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
                Unlike traditional news aggregators, TransferMap goes beyond headlines. Each transfer
                report is linked to the journalist who broke it, scored by credibility metrics
                (reporting speed, accuracy rate, and audience impact), so you can judge how reliable
                a rumour really is before it becomes official news.
              </p>
            </div>
            <div>
              <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">What We Offer</h3>
              <ul className="text-[0.84rem] text-[var(--text-sub)] space-y-3 list-disc list-inside">
                <li>Interactive map of Europe's top 5 league clubs — Premier League, La Liga, Bundesliga, Serie A, Ligue 1</li>
                <li>Real-time transfer rumours and confirmed moves, sourced directly from journalist posts on X</li>
                <li>Journalist credibility scoring — ranked by speed (first to report), accuracy (rumour-to-confirmation rate), and impact (audience reach)</li>
                <li>Season-by-season transfer market analysis: league spending, positional trends, most active clubs, cross-border flows</li>
                <li>Advanced filters by season, transfer window, status, position, fee range, and league</li>
                <li>Player profiles with complete transfer history and linked journalist reports</li>
              </ul>
            </div>
            <div>
              <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">Data Sources</h3>
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
                All transfer data originates from public posts by football journalists on X (Twitter).
                No proprietary databases or paid data feeds are used. Journalist credibility scores
                are calculated independently using our own algorithm based on historical reporting
                accuracy and speed. Transfer fees are sourced from journalist reports and may differ
                from officially disclosed figures.
              </p>
            </div>
            <div>
              <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">Operator</h3>
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
                TransferMap is independently operated. For inquiries, see the Contact section below.
              </p>
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
              This policy explains what information is collected, how it is used, and your rights regarding that information.
            </p>
            {[
              {
                title: '1. Information We Collect',
                content: 'The Service does not require account registration and does not collect personal information such as your name, email address, or payment details. Server access logs (IP address, browser type, visit timestamp, requested URL) may be generated automatically during normal operation of the service infrastructure.',
              },
              {
                title: '2. Cookies and Tracking Technologies',
                content: 'The Service uses cookies and similar tracking technologies for the following purposes:\n\n• Essential cookies: Required for core site functionality (e.g. remembering user preferences such as recently searched players).\n\n• Analytics: We may use anonymised analytics to understand how the Service is used and improve user experience.\n\n• Advertising (Google AdSense): The Service displays advertisements served by Google AdSense. Google uses cookies to serve ads based on your prior visits to this and other websites. Google\'s use of advertising cookies enables it and its partners to serve ads based on your visit to this site and/or other sites on the internet. You may opt out of personalised advertising by visiting Google\'s Ads Settings at https://www.google.com/settings/ads. Alternatively, you may opt out of a third-party vendor\'s use of cookies for personalised advertising by visiting www.aboutads.info.',
              },
              {
                title: '3. Third-Party Services',
                content: 'The Service integrates with the following third-party services, each of which operates under its own privacy policy:\n\n• Google AdSense — advertising platform (policies.google.com/privacy)\n• Google Gemini API — AI-powered tweet analysis; no personal user data is transmitted\n• X (Twitter) API — collection of public journalist posts only',
              },
              {
                title: '4. How We Use Information',
                content: 'Server log data is used solely for service stability, security monitoring, and error analysis. No personal information is sold or shared with third parties for marketing purposes. Information may be disclosed if required by applicable law or legal process.',
              },
              {
                title: '5. Data Retention',
                content: 'Server access logs are retained only as long as operationally necessary and are automatically deleted once capacity limits are exceeded (10 MB per file, up to 3 files). No other personal data is stored by the Service.',
              },
              {
                title: '6. Your Rights',
                content: 'You have the right to request access to, correction of, or deletion of any personal data held about you. You may also withdraw consent for personalised advertising at any time via Google\'s Ads Settings. For privacy inquiries or data deletion requests, contact: hyen43204@gmail.com',
              },
              {
                title: '7. Changes to This Policy',
                content: 'This policy may be updated to reflect changes in law or service features. Material changes will be announced via the Notice page. Continued use of the Service after changes are posted constitutes acceptance of the revised policy.',
              },
            ].map(item => (
              <div key={item.title}>
                <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-2">{item.title}</h3>
                <p style={{ whiteSpace: 'pre-line' }}>{item.content}</p>
              </div>
            ))}
            <p className="pt-4 border-t border-[var(--border)]">Effective date: 1 April 2026 · Last updated: 3 May 2026</p>
          </div>
        </section>

        </div>
      </div>
    </div>
  );
}
