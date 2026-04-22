import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';

type Tab = 'about' | 'contact' | 'privacy';

const STACK = [
  { category: 'Frontend', items: ['React 18', 'TypeScript', 'Vite', 'Tailwind CSS', 'D3.js'] },
  { category: 'Backend',  items: ['Spring Boot 4', 'Java 17', 'PostgreSQL + PostGIS', 'Redis'] },
  { category: 'Infra',    items: ['AWS EC2', 'Docker Compose', 'GitHub Actions', 'Nginx'] },
  { category: 'AI',       items: ['Google Gemini API (트윗 파싱)', 'X API v2 (데이터 수집)'] },
];

function AboutSection() {
  const navigate = useNavigate();
  return (
    <div className="flex flex-col gap-8">
      <section>
        <h1 className="text-[1.4rem] font-black tracking-wide mb-3">
          Transfer<span className="text-[var(--accent)]">Map</span>
        </h1>
        <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
          TransferMap은 유럽 축구 이적시장 정보를 실시간으로 시각화하는 서비스입니다.
          신뢰도 높은 기자들의 X(트위터) 게시물을 수집·분석하여 선수 이동 루머와 확정 소식을
          인터랙티브 지도 위에 표현합니다.
        </p>
      </section>

      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">핵심 기능</h2>
        <ul className="text-[0.84rem] text-[var(--text-sub)] space-y-2 list-disc list-inside">
          <li>유럽 5대 리그 클럽 인터랙티브 지도</li>
          <li>Gemini AI 기반 이적 트윗 자동 파싱</li>
          <li>기자 공신력 점수 (속도·정확도·파급력 기반)</li>
          <li>시즌·윈도우·상태별 이적 뉴스 필터</li>
        </ul>
      </section>

      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">기술 스택</h2>
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
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">데이터 출처</h2>
        <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
          이적 뉴스는 공개된 기자 X 계정에서 수집됩니다. 데이터는 참고용이며 공식 발표가 아닙니다.
          클럽·선수 정보 오류 및 기자 등록 요청은{' '}
          <button onClick={() => navigate('/info?tab=contact')}
            className="text-[var(--accent)] hover:underline">
            Contact
          </button>
          으로 보내주세요.
        </p>
      </section>
    </div>
  );
}

function ContactSection() {
  return (
    <div className="flex flex-col gap-4">
      <p className="text-[0.84rem] text-[var(--text-sub)] mb-4 leading-relaxed">
        버그 제보, 기자 등록 요청, 데이터 오류 신고 등 문의 사항은 아래로 연락해주세요.
      </p>
      <a href="mailto:hyen43204@gmail.com"
        className="bg-[var(--surface)] border border-[var(--border)] rounded-xl px-8 py-6
                   hover:border-white/15 transition-colors flex items-center justify-between group">
        <div>
          <div className="text-[0.97rem] font-bold mb-1">Email</div>
          <div className="text-[0.82rem] text-[var(--text-sub)]">hyen43204@gmail.com</div>
        </div>
        <span className="text-[var(--text-sub)] group-hover:text-[var(--text)] transition-colors text-lg">→</span>
      </a>
    </div>
  );
}

function PrivacySection() {
  return (
    <div className="flex flex-col gap-8 text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
      <section>
        <p className="text-[var(--text)]">
          TransferMap(이하 "서비스")은 이용자의 개인정보를 소중히 여기며, 「개인정보 보호법」 및 관련 법령을 준수합니다.
          본 방침은 서비스가 수집하는 정보, 이용 목적, 보관 기간 및 이용자의 권리를 안내합니다.
        </p>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">1. 수집하는 개인정보</h2>
        <p>본 서비스는 회원가입 없이 이용 가능하며, 별도의 개인정보를 수집하지 않습니다.</p>
        <p className="mt-2">서비스 운영 과정에서 아래 정보가 자동으로 생성될 수 있습니다.</p>
        <ul className="list-disc list-inside mt-2 space-y-1">
          <li>접속 IP 주소, 브라우저 종류, 방문 일시 (서버 액세스 로그)</li>
        </ul>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">2. 수집 목적</h2>
        <ul className="list-disc list-inside space-y-1">
          <li>서비스 안정성 및 보안 유지</li>
          <li>서비스 오류 분석 및 개선</li>
        </ul>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">3. 보관 기간</h2>
        <p>서버 액세스 로그는 일정 용량(파일당 10MB, 최대 3개) 초과 시 오래된 순서로 자동 삭제됩니다.</p>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">4. 제3자 제공</h2>
        <p>수집된 정보는 법령에 의한 경우를 제외하고 제3자에게 제공하지 않습니다.</p>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">5. 외부 서비스</h2>
        <p>본 서비스는 다음 외부 서비스를 활용합니다.</p>
        <ul className="list-disc list-inside mt-2 space-y-1">
          <li>X (Twitter) API — 공개된 기자 게시물 수집</li>
          <li>Google Gemini API — 트윗 내용 분석 (전송 시 개인정보 포함 없음)</li>
        </ul>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">6. 이용자의 권리</h2>
        <p>로그 데이터 삭제 요청 등 개인정보 관련 문의는 아래 연락처로 보내주세요.</p>
        <p className="mt-2">이메일: <span className="text-[var(--text)]">hyen43204@gmail.com</span></p>
      </section>
      <section>
        <h2 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-3">7. 방침 변경</h2>
        <p>본 방침은 법령 변경 또는 서비스 변경에 따라 개정될 수 있으며, 변경 시 공지사항을 통해 안내합니다.</p>
      </section>
      <p className="pt-4 border-t border-[var(--border)]">시행일: 2026년 4월 1일</p>
    </div>
  );
}

const TABS: { id: Tab; label: string }[] = [
  { id: 'about',   label: 'About' },
  { id: 'contact', label: 'Contact' },
  { id: 'privacy', label: '개인정보처리방침' },
];

export default function InfoPage() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const tabParam = searchParams.get('tab') as Tab | null;
  const [activeTab, setActiveTab] = useState<Tab>(tabParam ?? 'about');

  const handleTab = (tab: Tab) => {
    setActiveTab(tab);
    setSearchParams({ tab });
  };

  return (
    <div className="absolute inset-0 bg-[var(--bg)] z-50 flex flex-col">
      <div className="flex items-center gap-5 px-14 py-7 border-b border-[var(--border)] flex-shrink-0">
        <button
          onClick={() => navigate('/')}
          className="border border-[var(--border)] text-[var(--text-sub)] text-[0.84rem] px-5 py-2.5 rounded-lg
                     hover:text-[var(--text)] hover:border-white/20 transition-all">
          ← Map
        </button>
        <div className="flex gap-1">
          {TABS.map(t => (
            <button key={t.id} onClick={() => handleTab(t.id)}
              className={`text-[0.78rem] font-bold tracking-wide px-4 py-2 rounded-lg transition-all
                ${activeTab === t.id
                  ? 'text-[var(--text)] bg-white/8 border border-[var(--border)]'
                  : 'text-[var(--text-sub)] hover:text-[var(--text)]'}`}>
              {t.label}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
        {activeTab === 'about'   && <AboutSection />}
        {activeTab === 'contact' && <ContactSection />}
        {activeTab === 'privacy' && <PrivacySection />}
      </div>
    </div>
  );
}
