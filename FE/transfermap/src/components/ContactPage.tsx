import { useNavigate } from 'react-router-dom';

const LINKS = [
  {
    label: 'Email',
    href: 'mailto:hyen43204@gmail.com',
    desc: 'hyen43204@gmail.com',
  },
];

export default function ContactPage() {
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
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">Contact</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
        <p className="text-[0.84rem] text-[var(--text-sub)] mb-8 leading-relaxed">
          버그 제보, 기자 등록 요청, 데이터 오류 신고 등 문의 사항은 아래로 연락해주세요.
        </p>

        <div className="flex flex-col gap-4">
          {LINKS.map(link => (
            <a
              key={link.label}
              href={link.href}
              target="_blank"
              rel="noopener noreferrer"
              className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                         hover:border-white/15 transition-colors flex items-center justify-between group">
              <div>
                <div className="text-[0.97rem] font-bold mb-1">{link.label}</div>
                <div className="text-[0.82rem] text-[var(--text-sub)]">{link.desc}</div>
              </div>
              <span className="text-[var(--text-sub)] group-hover:text-[var(--text)] transition-colors text-lg">→</span>
            </a>
          ))}
        </div>
      </div>
    </div>
  );
}
