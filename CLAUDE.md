# CLAUDE.md — Transfer Project Root

## 중요 규칙

**빌드/실행/서버 시작은 사용자가 직접 한다.**
- `npm run dev`, `npm run build`, `./gradlew bootRun`, `./gradlew build` 등 절대 실행하지 말 것
- 코드 작성/수정만 하고, 실행은 사용자에게 맡긴다

## Project Structure

```
Transfer/
├── BE/          — Spring Boot 4.0.5 백엔드 (Java 17)
├── FE/          — React + TypeScript + Vite 프론트엔드
│   └── transfermap/
├── DB/          — DB 관련 스크립트
└── Infra/       — 인프라 설정
```

## FE Stack

- React 18 + TypeScript
- Vite (빌드)
- Tailwind CSS
- D3.js (지도/시각화)
- React Router v6

## FE 주요 규칙

- API 레이어: `src/api/` — `fetchAllClubs`, `fetchNews` 등
- 타입: `src/types/index.ts`
- Mock 폴백: API 실패 시 `src/data/mock.ts` 사용
- 컴포넌트: `src/components/`

## 공통 규칙

- 코멘트는 꼭 필요한 경우만 (WHY만, WHAT 아님)
- 이모지 사용하지 말 것 (사용자 요청 없으면)
