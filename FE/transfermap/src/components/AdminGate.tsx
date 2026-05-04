import { useState, useEffect } from 'react';
import { verifyAdminToken } from '../api/editorialReport';

const MONO = "'JetBrains Mono', 'Courier New', monospace";
const STORAGE_KEY = 'adminToken';

interface Props {
  children: React.ReactNode;
}

export default function AdminGate({ children }: Props) {
  const [authed, setAuthed]   = useState(false);
  const [checking, setChecking] = useState(true);
  const [input, setInput]     = useState('');
  const [error, setError]     = useState('');
  const [loading, setLoading] = useState(false);

  // 이미 저장된 토큰이 있으면 검증
  useEffect(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (!saved) { setChecking(false); return; }
    verifyAdminToken(saved).then(ok => {
      if (ok) setAuthed(true);
      else localStorage.removeItem(STORAGE_KEY);
      setChecking(false);
    });
  }, []);

  const submit = async () => {
    if (!input.trim()) return;
    setLoading(true);
    setError('');
    const ok = await verifyAdminToken(input.trim());
    if (ok) {
      localStorage.setItem(STORAGE_KEY, input.trim());
      setAuthed(true);
    } else {
      setError('Invalid password.');
    }
    setLoading(false);
  };

  if (checking) return null;
  if (authed) return <>{children}</>;

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 9999,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: '#060a12',
    }}>
      <div style={{
        width: 360, padding: '36px 32px',
        background: '#0d1626',
        border: '1px solid rgba(255,255,255,0.1)',
        borderRadius: 12,
      }}>
        <div style={{ fontFamily: MONO, fontSize: 10, fontWeight: 800, letterSpacing: '0.3em', color: 'rgba(160,185,220,0.5)', marginBottom: 20 }}>
          ◈ ADMIN ACCESS
        </div>
        <div style={{ fontSize: 20, fontWeight: 800, color: '#e8edf5', marginBottom: 8 }}>
          Write a Report
        </div>
        <div style={{ fontSize: 13, color: 'rgba(160,185,220,0.6)', marginBottom: 28, lineHeight: 1.5 }}>
          This area is restricted. Enter the admin password to continue.
        </div>

        <div style={{ marginBottom: 12 }}>
          <input
            type="password"
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && submit()}
            placeholder="Password"
            autoFocus
            style={{
              width: '100%', boxSizing: 'border-box',
              background: 'rgba(0,0,0,0.4)', color: '#e8edf5',
              border: `1px solid ${error ? 'rgba(239,68,68,0.6)' : 'rgba(255,255,255,0.1)'}`,
              borderRadius: 6, padding: '11px 14px',
              fontFamily: MONO, fontSize: 13, outline: 'none',
              letterSpacing: '0.12em',
            }}
            onFocus={e => (e.target.style.borderColor = 'rgba(59,130,246,0.6)')}
            onBlur={e => (e.target.style.borderColor = error ? 'rgba(239,68,68,0.6)' : 'rgba(255,255,255,0.1)')}
          />
          {error && (
            <div style={{ marginTop: 6, fontFamily: MONO, fontSize: 10, color: '#f87171', letterSpacing: '0.12em' }}>
              {error}
            </div>
          )}
        </div>

        <button
          onClick={submit}
          disabled={loading || !input.trim()}
          style={{
            width: '100%', padding: '11px', borderRadius: 6, cursor: loading ? 'not-allowed' : 'pointer',
            background: 'rgba(59,130,246,0.2)', color: '#7dd3fc',
            border: '1px solid rgba(59,130,246,0.45)',
            fontFamily: MONO, fontSize: 11, fontWeight: 800, letterSpacing: '0.2em',
            opacity: loading || !input.trim() ? 0.5 : 1,
            transition: 'opacity 0.15s',
          }}>
          {loading ? 'VERIFYING…' : 'ENTER'}
        </button>
      </div>
    </div>
  );
}
