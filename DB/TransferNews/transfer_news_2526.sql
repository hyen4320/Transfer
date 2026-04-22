-- ============================================================
--  유럽 5대 리그 25/26 이적시장 데이터
--  season=51 (25/26), SUMMER(6~9월) / WINTER(1~2월)
--  crawl.py 로 자동 생성 (Transfermarkt)
--
--  전제: league / club 기초 데이터 적재 완료
--  실행: psql -U postgres -d transfer -f transfer_news_2526.sql
-- ============================================================

-- ── 시스템 기자 (임포트용 더미) ────────────────────────────
INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)
SELECT 'transfermarkt_bot', '0', 'Transfermarkt Import Bot', 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'transfermarkt_bot');
