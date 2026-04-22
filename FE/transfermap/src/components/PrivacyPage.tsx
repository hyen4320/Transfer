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
        <div className="text-[1.05rem] font-extrabold tracking-[0.12em] uppercase">개인정보처리방침</div>
      </div>

      <div className="flex-1 overflow-y-auto px-14 py-10 max-w-3xl w-full">
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
      </div>
    </div>
  );
}
