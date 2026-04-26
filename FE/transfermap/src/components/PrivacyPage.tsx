import { useNavigate } from 'react-router-dom';

export default function PrivacyPage() {
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
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Privacy Policy</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
        <div className="flex flex-col gap-8 text-[0.84rem] text-[var(--text-sub)] leading-relaxed">

          <section>
            <p className="text-[var(--text)]">
              TransferMap ("the Service") respects your privacy and complies with applicable data protection laws.
              This policy explains what information is collected, why, how long it is retained, and your rights.
            </p>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">1. Data Collected</h2>
            <p>The Service does not require account registration and does not collect personal information.</p>
            <p className="mt-2">The following data may be generated automatically during operation:</p>
            <ul className="list-disc list-inside mt-2 space-y-1">
              <li>Access IP address, browser type, and visit timestamp (server access logs)</li>
            </ul>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">2. Purpose</h2>
            <ul className="list-disc list-inside space-y-1">
              <li>Service stability and security maintenance</li>
              <li>Error analysis and improvement</li>
            </ul>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">3. Retention</h2>
            <p>Server access logs are automatically deleted oldest-first once capacity limits are exceeded (10 MB per file, up to 3 files).</p>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">4. Third Parties</h2>
            <p>Collected information is not shared with third parties except as required by law.</p>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">5. External Services</h2>
            <p>The Service uses the following external services:</p>
            <ul className="list-disc list-inside mt-2 space-y-1">
              <li>X (Twitter) API — collection of public journalist posts</li>
              <li>Google Gemini API — tweet content analysis (no personal data is transmitted)</li>
            </ul>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">6. Your Rights</h2>
            <p>For log data deletion requests or other privacy inquiries, please contact us below.</p>
            <p className="mt-2">Email: <span className="text-[var(--text)]">hyen43204@gmail.com</span></p>
          </section>

          <section>
            <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">7. Policy Changes</h2>
            <p>This policy may be revised due to legal or service changes. Updates will be announced via the Notice page.</p>
          </section>

          <p className="pt-4 border-t border-[var(--border)]">Effective date: 1 April 2026</p>
        </div>
      </div>
    </div>
  );
}
