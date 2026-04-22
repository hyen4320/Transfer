-- ============================================================
--  Bundesliga 25/26 이적시장 데이터  (season=51)
--  Transfermarkt 크롤링으로 자동 생성
--  전제: league / club 기초 데이터 적재 완료
-- ============================================================

-- ── 시스템 기자 (임포트용 더미) ─────────────────────────────
INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)
SELECT 'bl_import_bot', '0', 'Bundesliga Import Bot', 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'bl_import_bot');
