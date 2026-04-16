import { useNavigate } from 'react-router-dom';

interface Props {
  code?: number;
  message?: string;
}

const CONFIG: Record<number, { color: string; glow: string; sub: string }> = {
  404: {
    color: 'rgba(59,130,246,0.6)',
    glow:  'rgba(59,130,246,0.3), 0 0 80px rgba(59,130,246,0.1)',
    sub:   "The page you're looking for doesn't exist.",
  },
  500: {
    color: 'rgba(239,68,68,0.65)',
    glow:  'rgba(239,68,68,0.3), 0 0 80px rgba(239,68,68,0.1)',
    sub:   'An unexpected error occurred on the server. Please try again later.',
  },
};

const DEFAULT_CONFIG = CONFIG[404];

export default function ErrorPage({ code = 404, message }: Props) {
  const navigate = useNavigate();
  const cfg = CONFIG[code] ?? DEFAULT_CONFIG;

  const defaultMessage = code === 500 ? 'Internal Server Error' : 'Page Not Found';

  return (
    <div className="w-screen h-screen bg-[var(--bg)] flex flex-col items-center justify-center gap-6">
      {/* Glowing number */}
      <div className="text-[8rem] font-black leading-none select-none"
        style={{
          color: 'transparent',
          WebkitTextStroke: `2px ${cfg.color}`,
          textShadow: `0 0 40px ${cfg.glow}`,
          letterSpacing: '0.05em',
        }}>
        {code}
      </div>

      <div className="text-center">
        <div className="text-[var(--text)] text-lg font-bold tracking-wide">
          {message ?? defaultMessage}
        </div>
        <div className="text-[var(--text-sub)] text-[0.78rem] mt-2 max-w-xs leading-relaxed">
          {cfg.sub}
        </div>
      </div>

      <div className="flex gap-3 mt-2">
        <button onClick={() => navigate(-1)}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.8rem] px-4 py-2 rounded-md
                     hover:text-[var(--text)] hover:border-white/20 transition-all">
          ← Go Back
        </button>
        <button onClick={() => navigate('/')}
          className="bg-[var(--accent)] text-white text-[0.8rem] font-bold px-4 py-2 rounded-md
                     hover:bg-blue-400 transition-all">
          ⊕ Back to Map
        </button>
      </div>
    </div>
  );
}
