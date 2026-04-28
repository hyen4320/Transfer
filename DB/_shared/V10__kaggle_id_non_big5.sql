-- V10: V9에서 추가한 구단들의 kaggle_club_id 매핑
-- kaggle_transfers.sql 내 실제 사용 ID 기준

-- ── 포르투갈 ─────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 294  WHERE name = 'SL Benfica';
UPDATE club SET kaggle_club_id = 720  WHERE name = 'FC Porto';
UPDATE club SET kaggle_club_id = 336  WHERE name = 'Sporting CP';

-- ── 사우디 ───────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 18544 WHERE name = 'Al-Nassr FC';
UPDATE club SET kaggle_club_id = 1114  WHERE name = 'Al-Hilal FC';
UPDATE club SET kaggle_club_id = 8023  WHERE name = 'Al-Ittihad Club';
UPDATE club SET kaggle_club_id = 18487 WHERE name = 'Al-Ahli Saudi FC';

-- ── 네덜란드 ─────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 610  WHERE name = 'AFC Ajax';
UPDATE club SET kaggle_club_id = 383  WHERE name = 'PSV Eindhoven';
UPDATE club SET kaggle_club_id = 234  WHERE name = 'Feyenoord';

-- ── 터키 ─────────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 141  WHERE name = 'Galatasaray SK';
UPDATE club SET kaggle_club_id = 36   WHERE name = 'Fenerbahçe SK';
UPDATE club SET kaggle_club_id = 114  WHERE name = 'Beşiktaş JK';

-- ── 스코틀랜드 ───────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 371  WHERE name = 'Celtic FC';
UPDATE club SET kaggle_club_id = 124  WHERE name = 'Rangers FC';

-- ── 벨기에 ───────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 2282 WHERE name = 'Club Brugge KV';
UPDATE club SET kaggle_club_id = 58   WHERE name = 'RSC Anderlecht';

-- ── 브라질 ───────────────────────────────────────────────────
UPDATE club SET kaggle_club_id = 614  WHERE name = 'Flamengo';
UPDATE club SET kaggle_club_id = 1023 WHERE name = 'Palmeiras';
UPDATE club SET kaggle_club_id = 221  WHERE name = 'Santos FC';
UPDATE club SET kaggle_club_id = 199  WHERE name = 'Corinthians';
UPDATE club SET kaggle_club_id = 585  WHERE name = 'São Paulo FC';
UPDATE club SET kaggle_club_id = 330  WHERE name = 'Atlético Mineiro';
UPDATE club SET kaggle_club_id = 2462 WHERE name = 'Fluminense';
