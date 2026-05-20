import { useCallback, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  type Block, type StatItem, type TimelineItem, type KpiItem,
  type EditorialReportRequest,
  createEditorialReport, updateEditorialReport,
} from '../api/editorialReport';

// ── constants ────────────────────────────────────────────────────────────────

const MONO = "'JetBrains Mono', 'Courier New', monospace";

const TONES: Record<string, { bg: string; fg: string }> = {
  amber:     { bg: '#2a1c08', fg: '#f59e0b' },
  red:       { bg: '#2a0d0d', fg: '#ef4444' },
  blue:      { bg: '#0a1a2e', fg: '#3b82f6' },
  navy:      { bg: '#0a1530', fg: '#60a5fa' },
  sky:       { bg: '#0a1c2e', fg: '#7dd3fc' },
  gold:      { bg: '#241a08', fg: '#dba514' },
  crimson:   { bg: '#2a080d', fg: '#f87171' },
  graphite:  { bg: '#161a22', fg: '#cbd5e1' },
  blaugrana: { bg: '#0a0e2a', fg: '#a3a8ff' },
};
const TONE_KEYS = Object.keys(TONES);
const MOTIF_KEYS = ['orbit', 'bars', 'lines', 'grid'] as const;
type MotifKey = typeof MOTIF_KEYS[number];

const C = {
  bg:          '#060a12',
  panel:       '#0d1626',
  panelAlt:    '#0a1320',
  border:      'rgba(255,255,255,0.08)',
  borderFocus: 'rgba(59,130,246,0.5)',
  text:        '#e8edf5',
  sub:         'rgba(160,185,220,0.7)',
  dim:         'rgba(160,185,220,0.45)',
  accent:      '#3b82f6',
  accentLight: '#7dd3fc',
  green:       '#22c55e',
  amber:       '#f59e0b',
  red:         '#ef4444',
};

const BLOCK_LIBRARY = [
  { kind: 'heading'   as const, icon: '§',  label: 'Heading',   hint: 'Section title' },
  { kind: 'paragraph' as const, icon: '¶',  label: 'Paragraph', hint: 'Body text' },
  { kind: 'pullquote' as const, icon: '❝',  label: 'Pull quote', hint: 'Featured quote' },
  { kind: 'stats'     as const, icon: '▦',  label: 'Stat grid', hint: '2-col label/value grid' },
  { kind: 'timeline'  as const, icon: '⌘',  label: 'Timeline',  hint: 'Chronological events' },
  { kind: 'kpi'       as const, icon: '△',  label: 'KPI strip', hint: 'Dashboard top metrics' },
  { kind: 'divider'   as const, icon: '⎯',  label: 'Divider',   hint: 'Visual break' },
];

function genId() { return 'b-' + Math.random().toString(36).slice(2, 8); }

function newBlock(kind: Block['kind']): Block {
  switch (kind) {
    case 'heading':   return { id: genId(), kind, text: 'Section heading' };
    case 'paragraph': return { id: genId(), kind, text: '' };
    case 'pullquote': return { id: genId(), kind, text: '' };
    case 'stats':     return { id: genId(), kind, items: [{ label: 'Metric', value: '—', sub: '' }, { label: 'Metric', value: '—', sub: '' }] };
    case 'timeline':  return { id: genId(), kind, items: [{ year: 'YYYY', label: 'Event', body: '' }] };
    case 'kpi':       return { id: genId(), kind, items: [{ label: 'Metric', value: '0', delta: '' }, { label: 'Metric', value: '0', delta: '' }, { label: 'Metric', value: '0', delta: '' }] };
    case 'divider':   return { id: genId(), kind };
    default: throw new Error(`Unhandled block kind: ${kind as never}`);
  }
}

// ── meta state ───────────────────────────────────────────────────────────────

interface ReportMeta {
  title:          string;
  deck:           string;
  type:           'analysis' | 'data';
  format:         'longform' | 'dashboard' | 'brief';
  classification: 'open-source' | 'sourced' | 'data-room';
  coverTone:      string;
  coverMotif:     MotifKey;
  tags:           string[];
}

const DEFAULT_META: ReportMeta = {
  title: '', deck: '', type: 'analysis', format: 'longform',
  classification: 'open-source',
  coverTone: 'blue', coverMotif: 'orbit', tags: [],
};

const DEFAULT_BLOCKS: Block[] = [
  { id: 'b-init1', kind: 'heading',   text: 'Thesis' },
  { id: 'b-init2', kind: 'paragraph', text: '' },
];

// ── shared atoms ─────────────────────────────────────────────────────────────

const inputStyle: React.CSSProperties = {
  width: '100%', boxSizing: 'border-box',
  background: 'rgba(0,0,0,0.3)', color: C.text,
  border: `1px solid ${C.border}`, borderRadius: 4,
  padding: '8px 10px', fontFamily: 'inherit', fontSize: 13, outline: 'none',
};
const inputMono: React.CSSProperties = { ...inputStyle, fontFamily: MONO, fontSize: 12 };

function CCField({ label, hint, children }: { label: string; hint?: string; children: React.ReactNode }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', color: C.dim, marginBottom: 6, display: 'flex', justifyContent: 'space-between' }}>
        <span>{label}</span>
        {hint && <span style={{ color: 'rgba(160,185,220,0.3)', fontWeight: 400 }}>{hint}</span>}
      </div>
      {children}
    </div>
  );
}


function CCTextarea({ value, onChange, placeholder, rows = 3 }: { value: string; onChange: (v: string) => void; placeholder?: string; rows?: number }) {
  return (
    <textarea value={value} onChange={e => onChange(e.target.value)} placeholder={placeholder} rows={rows}
      style={{ ...inputStyle, resize: 'vertical', lineHeight: 1.55 }}
      onFocus={e => (e.target.style.borderColor = C.accent)}
      onBlur={e => (e.target.style.borderColor = C.border)} />
  );
}

function CCSegment({ value, onChange, options }: {
  value: string;
  onChange: (v: string) => void;
  options: { value: string; label: string; icon?: string; color?: string }[];
}) {
  return (
    <div style={{ display: 'flex', border: `1px solid ${C.border}`, borderRadius: 4, overflow: 'hidden' }}>
      {options.map((opt, i) => {
        const active = value === opt.value;
        return (
          <button key={opt.value} onClick={() => onChange(opt.value)} style={{
            flex: 1, padding: '8px 6px', cursor: 'pointer',
            fontFamily: MONO, fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
            background: active ? `${opt.color || C.accent}22` : 'transparent',
            color: active ? (opt.color || C.accentLight) : C.sub,
            border: 'none',
            borderRight: i < options.length - 1 ? `1px solid ${C.border}` : 'none',
          }}>
            {opt.icon && <span style={{ marginRight: 4 }}>{opt.icon}</span>}{opt.label}
          </button>
        );
      })}
    </div>
  );
}

// ── cover motif SVG ───────────────────────────────────────────────────────────

function CoverMotif({ tone = 'blue', motif = 'orbit', w = 400, h = 200 }: { tone: string; motif: string; w?: number; h?: number }) {
  const t = TONES[tone] || TONES.blue;
  const gid = `cc-g-${tone}-${motif}-${w}`;
  const pid = `cc-p-${tone}-${motif}-${w}`;
  return (
    <svg viewBox={`0 0 ${w} ${h}`} width="100%" height="100%" preserveAspectRatio="xMidYMid slice" style={{ background: t.bg, display: 'block' }}>
      <defs>
        <radialGradient id={gid} cx="50%" cy="40%" r="60%">
          <stop offset="0%" stopColor={t.fg} stopOpacity="0.18" />
          <stop offset="100%" stopColor={t.bg} stopOpacity="0" />
        </radialGradient>
        <pattern id={pid} width="14" height="14" patternUnits="userSpaceOnUse">
          <path d="M 14 0 L 0 0 0 14" fill="none" stroke={t.fg} strokeOpacity="0.06" strokeWidth="1" />
        </pattern>
      </defs>
      <rect width={w} height={h} fill={`url(#${pid})`} />
      <rect width={w} height={h} fill={`url(#${gid})`} />
      {motif === 'orbit' && (
        <g transform={`translate(${w * 0.5} ${h * 0.55})`}>
          {[40, 80, 120, 160].map((r, i) => (
            <circle key={r} r={r} fill="none" stroke={t.fg} strokeOpacity={0.25 - i * 0.04} strokeDasharray={i % 2 ? '2 4' : '0'} />
          ))}
          <circle r="6" fill={t.fg} style={{ filter: `drop-shadow(0 0 12px ${t.fg})` }} />
        </g>
      )}
      {motif === 'bars' && (
        <g transform={`translate(20 ${h - 20})`}>
          {[60, 140, 90, 180, 110, 200, 130, 170, 90, 150].map((bh, i) => (
            <rect key={i} x={i * 32} y={-Math.min(bh, h - 30)} width="18" height={Math.min(bh, h - 30)}
              fill={t.fg} fillOpacity={0.18 + (i % 3) * 0.12} />
          ))}
        </g>
      )}
      {motif === 'lines' && (
        <g fill="none" stroke={t.fg} strokeOpacity="0.4">
          <path d={`M 0 ${h * 0.7} Q ${w * 0.3} ${h * 0.3} ${w} ${h * 0.55}`} strokeWidth="1.5" />
          <path d={`M 0 ${h * 0.85} Q ${w * 0.5} ${h * 0.5} ${w} ${h * 0.4}`} strokeOpacity="0.25" strokeWidth="1" strokeDasharray="6 4" />
          <circle cx={w * 0.3} cy={h * 0.42} r="4" fill={t.fg} stroke="none" />
        </g>
      )}
      {motif === 'grid' && (
        <g>
          {Array.from({ length: 6 }).map((_, i) =>
            Array.from({ length: 10 }).map((_, j) => {
              const v = (Math.sin(i * 1.3 + j * 0.7) + 1) / 2;
              return <rect key={`${i}-${j}`} x={10 + j * 36} y={10 + i * 30} width="22" height="20" fill={t.fg} fillOpacity={v * 0.35} />;
            })
          )}
        </g>
      )}
    </svg>
  );
}

// ── block chrome & editors ────────────────────────────────────────────────────

function BlockBtn({ children, onClick, disabled, title, danger }: { children: React.ReactNode; onClick?: () => void; disabled?: boolean; title?: string; danger?: boolean }) {
  return (
    <button onClick={onClick} disabled={disabled} title={title} style={{
      width: 24, height: 24, padding: 0, cursor: disabled ? 'not-allowed' : 'pointer',
      background: 'transparent',
      color: disabled ? 'rgba(160,185,220,0.2)' : (danger ? '#f87171' : C.sub),
      border: `1px solid ${C.border}`, borderRadius: 3,
      fontSize: 11, fontFamily: MONO,
    }}>{children}</button>
  );
}

function BlockChrome({ kind, isFirst, isLast, onMoveUp, onMoveDown, onDelete, onDuplicate, children }: {
  kind: Block['kind']; isFirst: boolean; isLast: boolean;
  onMoveUp: () => void; onMoveDown: () => void; onDelete: () => void; onDuplicate: () => void;
  children: React.ReactNode;
}) {
  const [hover, setHover] = useState(false);
  const meta = BLOCK_LIBRARY.find(b => b.kind === kind);
  return (
    <div onMouseEnter={() => setHover(true)} onMouseLeave={() => setHover(false)} style={{
      position: 'relative', marginBottom: 12,
      padding: '12px 14px',
      background: hover ? 'rgba(59,130,246,0.04)' : 'rgba(0,0,0,0.18)',
      border: `1px solid ${hover ? 'rgba(59,130,246,0.25)' : C.border}`,
      borderRadius: 6, transition: 'border-color 120ms, background 120ms',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10 }}>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8, fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', color: C.dim }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', justifyContent: 'center', width: 18, height: 18, fontSize: 11, background: 'rgba(59,130,246,0.12)', color: C.accentLight, borderRadius: 3 }}>{meta?.icon || '◇'}</span>
          {(meta?.label || kind).toUpperCase()}
        </div>
        <div style={{ display: 'flex', gap: 2, opacity: hover ? 1 : 0, transition: 'opacity 120ms' }}>
          <BlockBtn onClick={onMoveUp}    disabled={isFirst} title="Move up">↑</BlockBtn>
          <BlockBtn onClick={onMoveDown}  disabled={isLast}  title="Move down">↓</BlockBtn>
          <BlockBtn onClick={onDuplicate}                    title="Duplicate">⎘</BlockBtn>
          <BlockBtn onClick={onDelete}                       title="Delete" danger>✕</BlockBtn>
        </div>
      </div>
      {children}
    </div>
  );
}

function HeadingEditor({ block, update }: { block: Extract<Block, { kind: 'heading' }>; update: (b: Block) => void }) {
  return (
    <input value={block.text} onChange={e => update({ ...block, text: e.target.value })} placeholder="Section heading"
      style={{ width: '100%', boxSizing: 'border-box', background: 'transparent', color: C.text, border: 'none', outline: 'none', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 22, fontWeight: 800, letterSpacing: -0.3, padding: '4px 0' }} />
  );
}

function ParagraphEditor({ block, update }: { block: Extract<Block, { kind: 'paragraph' }>; update: (b: Block) => void }) {
  return <CCTextarea value={block.text} onChange={t => update({ ...block, text: t })} placeholder="Write the body…" rows={4} />;
}

function PullquoteEditor({ block, update }: { block: Extract<Block, { kind: 'pullquote' }>; update: (b: Block) => void }) {
  return (
    <div style={{ borderLeft: `3px solid ${C.accent}`, padding: '6px 0 6px 14px' }}>
      <textarea value={block.text} onChange={e => update({ ...block, text: e.target.value })}
        placeholder={'"A featured quote." — Source'} rows={2}
        style={{ width: '100%', boxSizing: 'border-box', background: 'transparent', color: C.text, border: 'none', outline: 'none', resize: 'vertical', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 17, fontWeight: 500, fontStyle: 'italic', letterSpacing: -0.2, lineHeight: 1.4 }} />
    </div>
  );
}

function StatsEditor({ block, update }: { block: Extract<Block, { kind: 'stats' }>; update: (b: Block) => void }) {
  const setItem = (i: number, key: keyof StatItem, val: string) =>
    update({ ...block, items: block.items.map((it, idx) => idx === i ? { ...it, [key]: val } : it) });
  const add = () => update({ ...block, items: [...block.items, { label: 'Metric', value: '—', sub: '' }] });
  const remove = (i: number) => update({ ...block, items: block.items.filter((_, idx) => idx !== i) });
  return (
    <div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
        {block.items.map((it, i) => (
          <div key={i} style={{ padding: '10px 12px', background: 'rgba(0,0,0,0.25)', border: `1px solid ${C.border}`, borderRadius: 4, position: 'relative' }}>
            <button onClick={() => remove(i)} style={{ position: 'absolute', top: 4, right: 4, width: 18, height: 18, padding: 0, background: 'transparent', color: C.dim, border: 'none', cursor: 'pointer', fontSize: 11 }}>✕</button>
            <input value={it.label} onChange={e => setItem(i, 'label', e.target.value)} placeholder="Label"
              style={{ width: '90%', background: 'transparent', color: C.dim, border: 'none', outline: 'none', fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', textTransform: 'uppercase', marginBottom: 6 }} />
            <input value={it.value} onChange={e => setItem(i, 'value', e.target.value)} placeholder="Value"
              style={{ width: '100%', background: 'transparent', color: C.text, border: 'none', outline: 'none', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 20, fontWeight: 800, letterSpacing: -0.5, display: 'block' }} />
            <input value={it.sub} onChange={e => setItem(i, 'sub', e.target.value)} placeholder="Sub (optional)"
              style={{ width: '100%', background: 'transparent', color: C.sub, border: 'none', outline: 'none', fontFamily: MONO, fontSize: 10 }} />
          </div>
        ))}
      </div>
      <button onClick={add} style={addBtnStyle}>+ Add stat</button>
    </div>
  );
}

function TimelineEditor({ block, update }: { block: Extract<Block, { kind: 'timeline' }>; update: (b: Block) => void }) {
  const setItem = (i: number, key: keyof TimelineItem, val: string) =>
    update({ ...block, items: block.items.map((it, idx) => idx === i ? { ...it, [key]: val } : it) });
  const add = () => update({ ...block, items: [...block.items, { year: 'YYYY', label: 'Event', body: '' }] });
  const remove = (i: number) => update({ ...block, items: block.items.filter((_, idx) => idx !== i) });
  return (
    <div>
      {block.items.map((it, i) => (
        <div key={i} style={{ display: 'grid', gridTemplateColumns: '80px 1fr auto', gap: 8, padding: '8px 0', borderBottom: i < block.items.length - 1 ? `1px solid ${C.border}` : 'none' }}>
          <input value={it.year} onChange={e => setItem(i, 'year', e.target.value)} placeholder="YYYY"
            style={{ ...inputMono, padding: '6px 8px', fontWeight: 800, color: C.accentLight }} />
          <div>
            <input value={it.label} onChange={e => setItem(i, 'label', e.target.value)} placeholder="Event title"
              style={{ ...inputStyle, padding: '6px 8px', fontWeight: 700, marginBottom: 4 }} />
            <input value={it.body} onChange={e => setItem(i, 'body', e.target.value)} placeholder="Detail (optional)"
              style={{ ...inputStyle, padding: '6px 8px', color: C.sub, fontSize: 12 }} />
          </div>
          <button onClick={() => remove(i)} style={{ alignSelf: 'start', width: 24, height: 24, padding: 0, background: 'transparent', color: C.dim, border: `1px solid ${C.border}`, borderRadius: 3, cursor: 'pointer' }}>✕</button>
        </div>
      ))}
      <button onClick={add} style={addBtnStyle}>+ Add event</button>
    </div>
  );
}

function KpiEditor({ block, update }: { block: Extract<Block, { kind: 'kpi' }>; update: (b: Block) => void }) {
  const setItem = (i: number, key: keyof KpiItem, val: string) =>
    update({ ...block, items: block.items.map((it, idx) => idx === i ? { ...it, [key]: val } : it) });
  const add = () => update({ ...block, items: [...block.items, { label: 'Metric', value: '0', delta: '' }] });
  const remove = (i: number) => update({ ...block, items: block.items.filter((_, idx) => idx !== i) });
  return (
    <div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
        {block.items.map((it, i) => (
          <div key={i} style={{ padding: '10px 12px', background: 'rgba(34,197,94,0.04)', border: '1px solid rgba(34,197,94,0.2)', borderRadius: 4, position: 'relative' }}>
            <button onClick={() => remove(i)} style={{ position: 'absolute', top: 4, right: 4, width: 18, height: 18, padding: 0, background: 'transparent', color: C.dim, border: 'none', cursor: 'pointer', fontSize: 11 }}>✕</button>
            <input value={it.label} onChange={e => setItem(i, 'label', e.target.value)} placeholder="KPI"
              style={{ width: '90%', background: 'transparent', color: '#86efac', border: 'none', outline: 'none', fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', textTransform: 'uppercase', marginBottom: 6 }} />
            <input value={it.value} onChange={e => setItem(i, 'value', e.target.value)} placeholder="Value"
              style={{ width: '100%', background: 'transparent', color: C.text, border: 'none', outline: 'none', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 20, fontWeight: 800, letterSpacing: -0.5, display: 'block' }} />
            <input value={it.delta} onChange={e => setItem(i, 'delta', e.target.value)} placeholder="Δ e.g. +12%"
              style={{ width: '100%', background: 'transparent', color: C.green, border: 'none', outline: 'none', fontFamily: MONO, fontSize: 11, fontWeight: 700 }} />
          </div>
        ))}
      </div>
      <button onClick={add} style={addBtnStyle}>+ Add KPI</button>
    </div>
  );
}

const addBtnStyle: React.CSSProperties = {
  marginTop: 8, padding: '6px 12px', cursor: 'pointer',
  background: 'transparent', color: C.sub,
  border: `1px dashed ${C.border}`, borderRadius: 3,
  fontFamily: MONO, fontSize: 10, letterSpacing: '0.15em',
};

function BlockEditor({ block, update }: { block: Block; update: (b: Block) => void }) {
  switch (block.kind) {
    case 'heading':   return <HeadingEditor   block={block} update={update} />;
    case 'paragraph': return <ParagraphEditor block={block} update={update} />;
    case 'pullquote': return <PullquoteEditor block={block} update={update} />;
    case 'stats':     return <StatsEditor     block={block} update={update} />;
    case 'timeline':  return <TimelineEditor  block={block} update={update} />;
    case 'kpi':       return <KpiEditor       block={block} update={update} />;
    case 'divider':   return <div style={{ height: 1, background: `repeating-linear-gradient(90deg, ${C.border} 0 8px, transparent 8px 14px)` }} />;
    default: return null;
  }
}

// ── insert menu ───────────────────────────────────────────────────────────────

function InsertMenu({ onInsert }: { onInsert: (kind: Block['kind']) => void }) {
  return (
    <div style={{ padding: '10px 12px', background: 'rgba(0,0,0,0.25)', border: `1px dashed ${C.border}`, borderRadius: 6 }}>
      <div style={{ fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', color: C.dim, marginBottom: 8 }}>+ INSERT BLOCK</div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
        {BLOCK_LIBRARY.map(b => (
          <button key={b.kind} onClick={() => onInsert(b.kind)} title={b.hint}
            style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '6px 10px', cursor: 'pointer', background: 'rgba(255,255,255,0.03)', color: C.text, border: `1px solid ${C.border}`, borderRadius: 3, fontFamily: MONO, fontSize: 10, fontWeight: 700, letterSpacing: '0.12em' }}
            onMouseEnter={e => { e.currentTarget.style.borderColor = 'rgba(59,130,246,0.5)'; e.currentTarget.style.background = 'rgba(59,130,246,0.08)'; }}
            onMouseLeave={e => { e.currentTarget.style.borderColor = C.border; e.currentTarget.style.background = 'rgba(255,255,255,0.03)'; }}>
            <span style={{ color: C.accentLight, fontSize: 12 }}>{b.icon}</span>
            {b.label.toUpperCase()}
          </button>
        ))}
      </div>
    </div>
  );
}

// ── live preview ──────────────────────────────────────────────────────────────

function PreviewBlock({ block, fmtColor }: { block: Block; fmtColor: string }) {
  switch (block.kind) {
    case 'heading':
      return <h2 style={{ fontFamily: 'Helvetica Neue, sans-serif', fontSize: 20, fontWeight: 800, letterSpacing: -0.3, lineHeight: 1.15, margin: '20px 0 8px' }}>{block.text || <em style={{ color: C.dim }}>Heading</em>}</h2>;
    case 'paragraph':
      return <p style={{ fontFamily: 'Helvetica Neue, sans-serif', fontSize: 13, lineHeight: 1.7, color: '#cdd5e0', margin: '0 0 10px', whiteSpace: 'pre-wrap' }}>{block.text || <span style={{ color: C.dim, fontStyle: 'italic' }}>(empty)</span>}</p>;
    case 'pullquote':
      return <blockquote style={{ margin: '14px 0', padding: '4px 0 4px 14px', borderLeft: `3px solid ${fmtColor}`, fontFamily: 'Helvetica Neue, sans-serif', fontSize: 16, fontWeight: 500, fontStyle: 'italic', lineHeight: 1.4, letterSpacing: -0.2, color: C.text }}>{block.text}</blockquote>;
    case 'stats':
      return (
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 6, margin: '10px 0' }}>
          {block.items.map((it, i) => (
            <div key={i} style={{ padding: '8px 10px', background: 'rgba(255,255,255,0.03)', border: `1px solid ${C.border}`, borderRadius: 4 }}>
              <div style={{ fontFamily: MONO, fontSize: 8, fontWeight: 700, letterSpacing: '0.22em', color: C.dim, marginBottom: 3 }}>{it.label}</div>
              <div style={{ fontFamily: 'Helvetica Neue, sans-serif', fontSize: 18, fontWeight: 800, letterSpacing: -0.5 }}>{it.value}</div>
              {it.sub && <div style={{ fontFamily: MONO, fontSize: 9, color: C.sub }}>{it.sub}</div>}
            </div>
          ))}
        </div>
      );
    case 'timeline':
      return (
        <div style={{ margin: '10px 0', borderTop: `1px solid ${C.border}` }}>
          {block.items.map((it, i) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '64px 1fr', gap: 8, padding: '8px 0', borderBottom: `1px solid ${C.border}` }}>
              <div style={{ fontFamily: MONO, fontSize: 10, fontWeight: 800, color: fmtColor, letterSpacing: '0.1em' }}>{it.year}</div>
              <div>
                <div style={{ fontWeight: 700, fontSize: 13, marginBottom: 2 }}>{it.label}</div>
                {it.body && <div style={{ fontSize: 11, color: C.sub, lineHeight: 1.5 }}>{it.body}</div>}
              </div>
            </div>
          ))}
        </div>
      );
    case 'kpi':
      return (
        <div style={{ display: 'grid', gridTemplateColumns: `repeat(${block.items.length}, 1fr)`, gap: 6, margin: '10px 0' }}>
          {block.items.map((it, i) => (
            <div key={i} style={{ padding: '10px', background: 'rgba(34,197,94,0.05)', border: '1px solid rgba(34,197,94,0.25)', borderRadius: 4 }}>
              <div style={{ fontFamily: MONO, fontSize: 8, fontWeight: 700, letterSpacing: '0.22em', color: '#86efac', marginBottom: 3 }}>{it.label}</div>
              <div style={{ fontFamily: 'Helvetica Neue, sans-serif', fontSize: 18, fontWeight: 800, letterSpacing: -0.5 }}>{it.value}</div>
              {it.delta && <div style={{ fontFamily: MONO, fontSize: 10, fontWeight: 700, color: C.green }}>{it.delta}</div>}
            </div>
          ))}
        </div>
      );
    case 'divider':
      return <hr style={{ margin: '16px 0', border: 'none', borderTop: `1px dashed ${C.border}` }} />;
    default: return null;
  }
}

function LivePreview({ meta, blocks, readMinutes }: { meta: ReportMeta; blocks: Block[]; readMinutes: number }) {
  const fmtColor = meta.format === 'dashboard' ? C.green : meta.format === 'brief' ? C.amber : C.accentLight;
  const fmtLabel = meta.format === 'dashboard' ? 'DASHBOARD' : meta.format === 'brief' ? 'BRIEF' : 'LONG';
  const typeLabel = meta.type === 'data' ? 'DATA' : 'ANALYSIS';
  const clsLabel  = meta.classification === 'sourced' ? 'SOURCED' : meta.classification === 'data-room' ? 'DATA ROOM' : 'OPEN SOURCE';

  return (
    <div style={{ background: C.bg, color: C.text, height: '100%', overflowY: 'auto', borderRadius: 6, border: `1px solid ${C.border}` }}>
      {/* Cover */}
      <div style={{ position: 'relative', height: 180, overflow: 'hidden' }}>
        <CoverMotif tone={meta.coverTone} motif={meta.coverMotif} w={360} h={180} />
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 30%, rgba(6,10,18,0.95) 100%)' }} />
        <div style={{ position: 'absolute', top: 12, left: 14, display: 'flex', gap: 5 }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '3px 7px', fontSize: 9, fontWeight: 800, letterSpacing: '0.18em', fontFamily: MONO, color: fmtColor, background: `${fmtColor}18`, border: `1px solid ${fmtColor}40`, borderRadius: 3 }}>{fmtLabel}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '3px 7px', fontSize: 9, fontWeight: 800, letterSpacing: '0.18em', fontFamily: MONO, color: meta.type === 'data' ? C.green : C.accent, background: meta.type === 'data' ? 'rgba(34,197,94,0.12)' : 'rgba(59,130,246,0.12)', border: `1px solid ${meta.type === 'data' ? C.green : C.accent}33`, borderRadius: 4 }}>{typeLabel}</span>
        </div>
        <div style={{ position: 'absolute', bottom: 12, left: 14, right: 14 }}>
          <div style={{ fontFamily: 'Helvetica Neue, sans-serif', fontSize: 18, fontWeight: 800, letterSpacing: -0.4, lineHeight: 1.15, marginBottom: 5 }}>{meta.title || <span style={{ color: C.dim, fontStyle: 'italic' }}>Untitled</span>}</div>
          <div style={{ fontSize: 11, color: C.sub, lineHeight: 1.4, overflow: 'hidden', display: '-webkit-box', WebkitBoxOrient: 'vertical', WebkitLineClamp: 2 }}>{meta.deck}</div>
        </div>
      </div>

      {/* Meta strip */}
      <div style={{ display: 'flex', gap: 10, padding: '8px 14px', borderBottom: `1px solid ${C.border}`, fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.18em', color: C.dim }}>
        <span>{readMinutes} MIN</span><span>·</span>
        <span style={{ color: meta.classification === 'sourced' ? C.amber : meta.classification === 'data-room' ? C.green : '#94a3b8' }}>{clsLabel}</span>
      </div>

      {/* Body */}
      <div style={{ padding: '14px 16px' }}>
        {blocks.length === 0 ? (
          <div style={{ padding: '32px 0', textAlign: 'center', color: C.dim, fontFamily: MONO, fontSize: 11, letterSpacing: '0.15em' }}>NO BLOCKS YET</div>
        ) : blocks.map(b => <PreviewBlock key={b.id} block={b} fmtColor={fmtColor} />)}
      </div>
    </div>
  );
}

// ── main composer ─────────────────────────────────────────────────────────────

type PublishStatus = 'draft' | 'ready' | 'published';

export default function ReportComposer() {
  const navigate = useNavigate();
  const [meta, setMeta] = useState<ReportMeta>(DEFAULT_META);
  const [blocks, setBlocks] = useState<Block[]>(DEFAULT_BLOCKS);
  const [status, setStatus] = useState<PublishStatus>('draft');
  const [savedId, setSavedId] = useState<number | null>(null);
  const [saving, setSaving] = useState(false);
  const [tagInput, setTagInput] = useState('');

  const setM = useCallback(<K extends keyof ReportMeta>(k: K, v: ReportMeta[K]) =>
    setMeta(m => ({ ...m, [k]: v })), []);
  const setCover = useCallback((k: 'coverTone' | 'coverMotif', v: string) =>
    setMeta(m => ({ ...m, [k]: v })), []);

  // Block CRUD
  const updateBlock = (id: string, next: Block) => setBlocks(bs => bs.map(b => b.id === id ? next : b));
  const moveBlock = (id: string, dir: -1 | 1) => setBlocks(bs => {
    const i = bs.findIndex(b => b.id === id);
    const j = i + dir;
    if (i < 0 || j < 0 || j >= bs.length) return bs;
    const copy = [...bs];
    [copy[i], copy[j]] = [copy[j], copy[i]];
    return copy;
  });
  const deleteBlock = (id: string) => setBlocks(bs => bs.filter(b => b.id !== id));
  const duplicateBlock = (id: string) => setBlocks(bs => {
    const i = bs.findIndex(b => b.id === id);
    if (i < 0) return bs;
    const copy: Block = JSON.parse(JSON.stringify(bs[i]));
    (copy as { id: string }).id = genId();
    return [...bs.slice(0, i + 1), copy, ...bs.slice(i + 1)];
  });
  const insertBlock = (kind: Block['kind']) => setBlocks(bs => [...bs, newBlock(kind)]);

  // Tags
  const addTag = () => {
    const t = tagInput.trim();
    if (t && !meta.tags.includes(t)) setM('tags', [...meta.tags, t]);
    setTagInput('');
  };
  const removeTag = (t: string) => setM('tags', meta.tags.filter(x => x !== t));

  // Word count
  const wordCount = useMemo(() => {
    let n = 0;
    for (const b of blocks) {
      if (b.kind === 'paragraph' || b.kind === 'pullquote' || b.kind === 'heading') {
        n += (b.text || '').trim().split(/\s+/).filter(Boolean).length;
      }
      if (b.kind === 'timeline') {
        for (const it of b.items) n += (it.body || '').split(/\s+/).filter(Boolean).length;
      }
    }
    return n;
  }, [blocks]);
  const estReadMin = Math.max(1, Math.round(wordCount / 220));

  // Save / publish
  const buildRequest = (s: PublishStatus): EditorialReportRequest => ({
    title: meta.title || 'Untitled',
    deck: meta.deck,
    type: meta.type,
    format: meta.format,
    classification: meta.classification,
    readMinutes: estReadMin,
    coverTone: meta.coverTone,
    coverMotif: meta.coverMotif,
    tags: meta.tags,
    blocks: JSON.stringify(blocks),
    status: s,
  });

  const save = useCallback(async (s: PublishStatus) => {
    setSaving(true);
    try {
      const req = buildRequest(s);
      const res = savedId
        ? await updateEditorialReport(savedId, req)
        : await createEditorialReport(req);
      setSavedId(res.id);
      setStatus(s);
      if (s === 'published') navigate('/report?tab=editorial');
    } catch (e) {
      console.error(e);
    } finally {
      setSaving(false);
    }
  }, [meta, blocks, savedId, estReadMin, navigate]);

  const statusColor = status === 'published' ? C.green : status === 'ready' ? C.amber : C.dim;

  return (
    <div style={{ width: '100vw', height: '100vh', display: 'grid', gridTemplateColumns: '300px 1fr 360px', background: C.bg, color: C.text, fontFamily: 'Helvetica Neue, Arial, sans-serif', overflow: 'hidden' }}>

      {/* ── LEFT: META ── */}
      <div style={{ borderRight: `1px solid ${C.border}`, background: C.panelAlt, overflowY: 'auto' }}>

        {/* Header */}
        <div style={{ padding: '14px 16px', borderBottom: `1px solid ${C.border}`, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <button onClick={() => navigate('/report')} style={{ background: 'transparent', border: `1px solid ${C.border}`, color: C.sub, fontFamily: MONO, fontSize: 10, padding: '4px 10px', borderRadius: 3, cursor: 'pointer', letterSpacing: '0.12em' }}>← BACK</button>
            <span style={{ fontFamily: MONO, fontSize: 10, fontWeight: 800, letterSpacing: '0.25em', color: C.dim }}>◈ COMPOSER</span>
          </div>
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px', borderRadius: 3, background: `${statusColor}18`, border: `1px solid ${statusColor}40` }}>
            <div style={{ width: 6, height: 6, borderRadius: '50%', background: statusColor, boxShadow: `0 0 8px ${statusColor}` }} />
            <span style={{ fontFamily: MONO, fontSize: 9, fontWeight: 800, letterSpacing: '0.2em', color: statusColor, textTransform: 'uppercase' }}>{status}</span>
          </div>
        </div>

        <div style={{ padding: '16px' }}>
          <CCField label="FORMAT" hint="determines detail layout">
            <CCSegment value={meta.format} onChange={v => setM('format', v as ReportMeta['format'])}
              options={[
                { value: 'longform',  label: 'LONG',  icon: '¶', color: '#7dd3fc' },
                { value: 'dashboard', label: 'DASH',  icon: '▦', color: '#22c55e' },
                { value: 'brief',     label: 'BRIEF', icon: '⚑', color: '#f59e0b' },
              ]} />
          </CCField>

          <CCField label="TYPE">
            <CCSegment value={meta.type} onChange={v => setM('type', v as ReportMeta['type'])}
              options={[
                { value: 'analysis', label: 'ANALYSIS', icon: '✎', color: '#3b82f6' },
                { value: 'data',     label: 'DATA',     icon: '▦', color: '#22c55e' },
              ]} />
          </CCField>

          <CCField label="CLASSIFICATION">
            <CCSegment value={meta.classification} onChange={v => setM('classification', v as ReportMeta['classification'])}
              options={[
                { value: 'open-source', label: 'OPEN',    color: '#94a3b8' },
                { value: 'sourced',     label: 'SOURCED', color: '#f59e0b' },
                { value: 'data-room',   label: 'DATA',    color: '#22c55e' },
              ]} />
          </CCField>

          <CCField label="TAGS">
            <div style={{ display: 'flex', gap: 6, marginBottom: 6 }}>
              <input value={tagInput} onChange={e => setTagInput(e.target.value)}
                onKeyDown={e => { if (e.key === 'Enter') { e.preventDefault(); addTag(); } }}
                placeholder="add tag + enter"
                style={{ ...inputMono, flex: 1 }} />
              <button onClick={addTag} style={{ padding: '8px 10px', cursor: 'pointer', background: 'rgba(59,130,246,0.15)', color: C.accentLight, border: `1px solid rgba(59,130,246,0.4)`, borderRadius: 3, fontFamily: MONO, fontSize: 11, fontWeight: 700 }}>+</button>
            </div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
              {meta.tags.map(t => (
                <span key={t} style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '3px 8px', background: 'rgba(255,255,255,0.05)', border: `1px solid ${C.border}`, borderRadius: 3, fontFamily: MONO, fontSize: 10, color: C.sub, letterSpacing: '0.1em' }}>
                  {t}
                  <button onClick={() => removeTag(t)} style={{ background: 'none', border: 'none', color: C.dim, cursor: 'pointer', padding: 0, fontSize: 11 }}>✕</button>
                </span>
              ))}
            </div>
          </CCField>

          <CCField label="COVER · TONE">
            <div style={{ display: 'grid', gridTemplateColumns: `repeat(${TONE_KEYS.length}, 1fr)`, gap: 4 }}>
              {TONE_KEYS.map(t => {
                const tone = TONES[t];
                const sel = meta.coverTone === t;
                return (
                  <button key={t} onClick={() => setCover('coverTone', t)} title={t}
                    style={{ aspectRatio: '1', cursor: 'pointer', background: tone.bg, color: tone.fg, border: `1.5px solid ${sel ? tone.fg : 'transparent'}`, borderRadius: 3, padding: 0, boxShadow: sel ? `0 0 0 2px ${C.bg}, 0 0 0 3.5px ${tone.fg}` : 'none', position: 'relative' }}>
                    <div style={{ position: 'absolute', inset: 3, borderRadius: 2, background: `radial-gradient(circle at 50% 40%, ${tone.fg}33, transparent 70%)` }} />
                  </button>
                );
              })}
            </div>
          </CCField>

          <CCField label="COVER · MOTIF">
            <CCSegment value={meta.coverMotif} onChange={v => setCover('coverMotif', v)}
              options={MOTIF_KEYS.map(m => ({ value: m, label: m.toUpperCase() }))} />
          </CCField>
        </div>
      </div>

      {/* ── CENTER: WRITING CANVAS ── */}
      <div style={{ background: C.bg, overflowY: 'auto', display: 'flex', flexDirection: 'column' }}>

        {/* Title + deck */}
        <div style={{ padding: '24px 28px 14px', borderBottom: `1px solid ${C.border}` }}>
          <div style={{ fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', color: C.dim, marginBottom: 8 }}>TITLE</div>
          <textarea value={meta.title} onChange={e => setM('title', e.target.value)}
            placeholder="A title that earns the homepage." rows={2}
            style={{ width: '100%', boxSizing: 'border-box', background: 'transparent', color: C.text, border: 'none', outline: 'none', resize: 'none', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 28, fontWeight: 800, letterSpacing: -0.6, lineHeight: 1.15, padding: 0, marginBottom: 12 }} />
          <div style={{ fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.22em', color: C.dim, marginBottom: 6 }}>DECK</div>
          <textarea value={meta.deck} onChange={e => setM('deck', e.target.value)}
            placeholder="One or two sentences. The promise of the report." rows={2}
            style={{ width: '100%', boxSizing: 'border-box', background: 'transparent', color: '#cdd5e0', border: 'none', outline: 'none', resize: 'none', fontFamily: 'Helvetica Neue, sans-serif', fontSize: 15, fontWeight: 500, lineHeight: 1.5, letterSpacing: -0.1, padding: 0 }} />
        </div>

        {/* Stats strip */}
        <div style={{ display: 'flex', gap: 14, padding: '9px 28px', borderBottom: `1px solid ${C.border}`, fontFamily: MONO, fontSize: 10, fontWeight: 700, letterSpacing: '0.18em', color: C.dim }}>
          <span>{blocks.length} BLOCKS</span><span>·</span>
          <span>{wordCount} WORDS</span><span>·</span>
          <span>~{estReadMin} MIN READ</span>
          <span style={{ marginLeft: 'auto' }}>AUTO-SAVED <span style={{ color: savedId ? C.green : C.dim }}>●</span></span>
        </div>

        {/* Blocks */}
        <div style={{ padding: '16px 28px 24px' }}>
          {blocks.map((b, i) => (
            <BlockChrome key={b.id} kind={b.kind} isFirst={i === 0} isLast={i === blocks.length - 1}
              onMoveUp={() => moveBlock(b.id, -1)} onMoveDown={() => moveBlock(b.id, 1)}
              onDelete={() => deleteBlock(b.id)} onDuplicate={() => duplicateBlock(b.id)}>
              <BlockEditor block={b} update={next => updateBlock(b.id, next)} />
            </BlockChrome>
          ))}
          <InsertMenu onInsert={insertBlock} />
        </div>
      </div>

      {/* ── RIGHT: LIVE PREVIEW ── */}
      <div style={{ borderLeft: `1px solid ${C.border}`, background: C.panelAlt, display: 'flex', flexDirection: 'column' }}>
        <div style={{ padding: '14px 16px', borderBottom: `1px solid ${C.border}`, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ fontFamily: MONO, fontSize: 10, fontWeight: 800, letterSpacing: '0.25em', color: C.dim }}>◈ LIVE PREVIEW</span>
          <span style={{ fontFamily: MONO, fontSize: 9, fontWeight: 700, letterSpacing: '0.18em', color: C.accentLight }}>{meta.format.toUpperCase()}</span>
        </div>
        <div style={{ flex: 1, padding: 12, overflow: 'hidden', display: 'flex' }}>
          <LivePreview meta={meta} blocks={blocks} readMinutes={estReadMin} />
        </div>

        {/* Action buttons */}
        <div style={{ padding: '12px 12px', borderTop: `1px solid ${C.border}`, display: 'flex', gap: 8 }}>
          <button onClick={() => save('draft')} disabled={saving} style={actionBtnStyle('draft', status)}>SAVE DRAFT</button>
          <button onClick={() => save('ready')} disabled={saving} style={actionBtnStyle('ready', status)}>MARK READY</button>
          <button onClick={() => save('published')} disabled={saving} style={{
            flex: 1, padding: '9px 8px', cursor: saving ? 'not-allowed' : 'pointer',
            background: 'rgba(34,197,94,0.18)', color: '#86efac',
            border: '1px solid rgba(34,197,94,0.5)', borderRadius: 3,
            fontFamily: MONO, fontSize: 10, fontWeight: 800, letterSpacing: '0.18em',
            opacity: saving ? 0.6 : 1,
          }}>{saving ? 'SAVING…' : 'PUBLISH'}</button>
        </div>
      </div>
    </div>
  );
}

function actionBtnStyle(target: PublishStatus, current: PublishStatus): React.CSSProperties {
  const active = current === target;
  return {
    flex: 1, padding: '9px 8px', cursor: 'pointer',
    background: active ? 'rgba(255,255,255,0.06)' : 'transparent',
    color: active ? C.text : C.sub,
    border: `1px solid ${C.border}`, borderRadius: 3,
    fontFamily: MONO, fontSize: 10, fontWeight: 700, letterSpacing: '0.15em',
  };
}
