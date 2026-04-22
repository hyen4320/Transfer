import { useNavigate } from 'react-router-dom';

export default function InfoPage() {
  const navigate = useNavigate();

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
        <section>
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">About</h2>
          <div className="flex flex-col gap-8">
            <div>
              <h1 className="text-[1.4rem] font-black tracking-wide mb-3">
                Transfer<span className="text-[var(--accent)]">Map</span>
              </h1>
              <p className="text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
                TransferMap은 유럽 축구 이적시장 정보를 실시간으로 시각화하는 서비스입니다.
                신뢰도 높은 기자들의 X(트위터) 게시물을 수집·분석하여 선수 이동 루머와 확정 소식을
                인터랙티브 지도 위에 표현합니다.
              </p>
            </div>
            <div>
              <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-4">핵심 기능</h3>
              <ul className="text-[0.84rem] text-[var(--text-sub)] space-y-2 list-disc list-inside">
                <li>유럽 5대 리그 클럽 인터랙티브 지도</li>
                <li>Gemini AI 기반 이적 트윗 자동 파싱</li>
                <li>기자 공신력 점수 (속도·정확도·파급력 기반)</li>
                <li>시즌·윈도우·상태별 이적 뉴스 필터</li>
              </ul>
            </div>
          </div>
        </section>

        {/* Contact */}
        <section>
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">Contact</h2>
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
        </section>

        {/* Privacy */}
        <section>
          <h2 className="text-[0.68rem] font-bold tracking-widest uppercase text-[var(--text-sub)] mb-6 pb-3 border-b border-[var(--border)]">개인정보처리방침</h2>
          <div className="flex flex-col gap-6 text-[0.84rem] text-[var(--text-sub)] leading-relaxed">
            <p className="text-[var(--text)]">
              TransferMap(이하 "서비스")은 이용자의 개인정보를 소중히 여기며, 「개인정보 보호법」 및 관련 법령을 준수합니다.
            </p>
            {[
              { title: '1. 수집하는 개인정보', content: '본 서비스는 회원가입 없이 이용 가능하며, 별도의 개인정보를 수집하지 않습니다. 서비스 운영 과정에서 접속 IP 주소, 브라우저 종류, 방문 일시(서버 액세스 로그)가 자동 생성될 수 있습니다.' },
              { title: '2. 수집 목적', content: '서비스 안정성 및 보안 유지, 서비스 오류 분석 및 개선.' },
              { title: '3. 보관 기간', content: '서버 액세스 로그는 일정 용량(파일당 10MB, 최대 3개) 초과 시 오래된 순서로 자동 삭제됩니다.' },
              { title: '4. 제3자 제공', content: '수집된 정보는 법령에 의한 경우를 제외하고 제3자에게 제공하지 않습니다.' },
              { title: '5. 외부 서비스', content: 'X (Twitter) API — 공개된 기자 게시물 수집. Google Gemini API — 트윗 내용 분석 (전송 시 개인정보 포함 없음).' },
              { title: '6. 이용자의 권리', content: '로그 데이터 삭제 요청 등 개인정보 관련 문의: hyen43204@gmail.com' },
              { title: '7. 방침 변경', content: '본 방침은 법령 변경 또는 서비스 변경에 따라 개정될 수 있으며, 변경 시 공지사항을 통해 안내합니다.' },
            ].map(item => (
              <div key={item.title}>
                <h3 className="text-[0.78rem] font-bold tracking-widest uppercase text-[var(--text)] mb-2">{item.title}</h3>
                <p>{item.content}</p>
              </div>
            ))}
            <p className="pt-4 border-t border-[var(--border)]">시행일: 2026년 4월 1일</p>
          </div>
        </section>

        </div>
      </div>
    </div>
  );
}
