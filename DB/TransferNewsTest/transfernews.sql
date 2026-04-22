-- ============================================================
--  TransferMap 이적 시뮬레이션 테스트 데이터
--  시즌: 25/26 (season=51), SUMMER 윈도우
--  전제: league / club / journalist / player 기초 데이터 적재 완료
--
--  시나리오
--  A. Musiala  Bayern → Arsenal          INTEREST → RUMOR → CONFIRMED
--  B. Saka     Arsenal → Real Madrid     INTEREST → RUMOR → DENIED
--  C. Cherki   Lyon(FA) → Liverpool      RUMOR → CONFIRMED
--  D. Haaland  Man City → PSG            INTEREST → DENIED (Man City 공식 부인)
-- ============================================================

-- ── status 체크 제약에 INTEREST 추가 ────────────────────────
ALTER TABLE transfer_news DROP CONSTRAINT IF EXISTS transfer_news_status_check;
ALTER TABLE transfer_news ADD CONSTRAINT transfer_news_status_check
    CHECK (status IN ('INTEREST', 'RUMOR', 'CONFIRMED', 'DENIED', 'LOAN'));

-- ── contract_status 세팅 (시뮬레이션 대상 선수) ─────────────
UPDATE player SET contract_status = 'CONTRACTED' WHERE name IN (
    'Jamal Musiala', 'Bukayo Saka', 'Erling Haaland'
);
UPDATE player SET contract_status = 'FREE_AGENT'  WHERE name = 'Rayan Cherki';


-- ═══════════════════════════════════════════════════════════
--  SCENARIO A  Jamal Musiala  (Bayern Munich → Arsenal FC)
--  타임라인: INTEREST(Day-5) → RUMOR(Day-3) → CONFIRMED(Day-1)
-- ═══════════════════════════════════════════════════════════

-- A-1  Plettenberg: Bayern 떠날 의향 포착 (INTEREST)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'Plettigoal'),
    '1900100000000000001',
    '🚨 Jamal Musiala open to leaving Bayern Munich this summer. Contract expires 2026. Several top clubs monitoring — Arsenal FC among them. 🔴⚪ #Musiala #Arsenal',
    62000, 9800, 3100, 5200000,
    NOW() - INTERVAL '5 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900100000000000001'),
    (SELECT player_id FROM player WHERE name = 'Jamal Musiala'),
    (SELECT club_id  FROM club WHERE name = 'Bayern Munich'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    NULL, 'INTEREST', 3, 51, 'SUMMER',
    NOW() - INTERVAL '5 days'
);

-- A-2  Romano: Arsenal 공식 접촉 확인 (RUMOR)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'FabrizioRomano'),
    '1900100000000000002',
    '🚨 Arsenal have made OFFICIAL approach for Jamal Musiala. Negotiations with Bayern Munich opened. Fee expected around €120m. Here we go? 🔴⚪🏴󠁧󠁢󠁥󠁮󠁧󠁿 #AFC',
    198000, 42000, 11000, 18700000,
    NOW() - INTERVAL '3 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900100000000000002'),
    (SELECT player_id FROM player WHERE name = 'Jamal Musiala'),
    (SELECT club_id  FROM club WHERE name = 'Bayern Munich'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    120000000, 'RUMOR', 5, 51, 'SUMMER',
    NOW() - INTERVAL '3 days'
);

-- A-3  Romano: Musiala Arsenal 이적 확정 (CONFIRMED)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'FabrizioRomano'),
    '1900100000000000003',
    'HERE WE GO! 🟢✅ Jamal Musiala to Arsenal FC, CONFIRMED! Fee: €115m + add-ons. Five year deal signed. Medical done in London. 🔴⚪🏴󠁧󠁢󠁥󠁮󠁧󠁿 #Musiala #Arsenal',
    520000, 130000, 38000, 62000000,
    NOW() - INTERVAL '1 day'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900100000000000003'),
    (SELECT player_id FROM player WHERE name = 'Jamal Musiala'),
    (SELECT club_id  FROM club WHERE name = 'Bayern Munich'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    115000000, 'CONFIRMED', 5, 51, 'SUMMER',
    NOW() - INTERVAL '1 day'
);

-- Musiala 소속 클럽 업데이트 (이적 확정 반영)
UPDATE player SET current_club_id = (SELECT club_id FROM club WHERE name = 'Arsenal FC'),
                 contract_status  = 'CONTRACTED'
WHERE name = 'Jamal Musiala';


-- ═══════════════════════════════════════════════════════════
--  SCENARIO B  Bukayo Saka  (Arsenal → Real Madrid)
--  타임라인: INTEREST(Day-4) → RUMOR(Day-2) → DENIED(Day-0)
-- ═══════════════════════════════════════════════════════════

-- B-1  Romano: Real Madrid 관심 (INTEREST)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'FabrizioRomano'),
    '1900200000000000001',
    '🔵⚪ Real Madrid considering move for Bukayo Saka as priority target for summer 2025. Contract talks with Arsenal stalled. Situation to watch. #RealMadrid',
    87000, 15000, 5400, 9100000,
    NOW() - INTERVAL '4 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900200000000000001'),
    (SELECT player_id FROM player WHERE name = 'Bukayo Saka'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    (SELECT club_id  FROM club WHERE name = 'Real Madrid'),
    NULL, 'INTEREST', 3, 51, 'SUMMER',
    NOW() - INTERVAL '4 days'
);

-- B-2  Ornstein: Real Madrid 접촉 보도 (RUMOR)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'David_Ornstein'),
    '1900200000000000002',
    'Real Madrid have made discreet contact over Bukayo Saka. Arsenal have NOT received any formal bid. Club insist he is not for sale this window. @TheAthleticFC exclusive.',
    44000, 7200, 2900, 4300000,
    NOW() - INTERVAL '2 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900200000000000002'),
    (SELECT player_id FROM player WHERE name = 'Bukayo Saka'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    (SELECT club_id  FROM club WHERE name = 'Real Madrid'),
    NULL, 'RUMOR', 4, 51, 'SUMMER',
    NOW() - INTERVAL '2 days'
);

-- B-3  Ornstein: Arsenal 공식 부인 (DENIED)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'David_Ornstein'),
    '1900200000000000003',
    'Arsenal DENY Bukayo Saka transfer. Club statement: "Bukayo is central to our project. He is not for sale." Saka himself reaffirmed his commitment. @TheAthleticFC',
    31000, 4800, 1700, 3200000,
    NOW() - INTERVAL '6 hours'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900200000000000003'),
    (SELECT player_id FROM player WHERE name = 'Bukayo Saka'),
    (SELECT club_id  FROM club WHERE name = 'Arsenal FC'),
    (SELECT club_id  FROM club WHERE name = 'Real Madrid'),
    NULL, 'DENIED', 5, 51, 'SUMMER',
    NOW() - INTERVAL '6 hours'
);


-- ═══════════════════════════════════════════════════════════
--  SCENARIO C  Rayan Cherki  (FA → Liverpool FC)
--  타임라인: RUMOR(Day-6) → CONFIRMED(Day-2)
-- ═══════════════════════════════════════════════════════════

-- C-1  Romano: Cherki FA 관심 보도 (RUMOR)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'FabrizioRomano'),
    '1900300000000000001',
    '🚨 Rayan Cherki leaves Lyon as free agent — confirmed. Liverpool FC lead the race. Personal terms almost agreed. Medical to be scheduled. 🔴 #LFC #Cherki',
    145000, 31000, 9200, 24000000,
    NOW() - INTERVAL '6 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900300000000000001'),
    (SELECT player_id FROM player WHERE name = 'Rayan Cherki'),
    NULL,  -- FA: 출발 클럽 없음
    (SELECT club_id FROM club WHERE name = 'Liverpool FC'),
    0, 'RUMOR', 4, 51, 'SUMMER',
    NOW() - INTERVAL '6 days'
);

-- C-2  Romano: Cherki Liverpool 이적 확정 (CONFIRMED)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'FabrizioRomano'),
    '1900300000000000002',
    'HERE WE GO! 🟢✅ Rayan Cherki to Liverpool FC on free transfer — DONE DEAL! Four year contract signed. Welcome to Anfield, Rayan! 🔴🏴󠁧󠁢󠁥󠁮󠁧󠁿 #LFC',
    380000, 88000, 24000, 47000000,
    NOW() - INTERVAL '2 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900300000000000002'),
    (SELECT player_id FROM player WHERE name = 'Rayan Cherki'),
    NULL,
    (SELECT club_id FROM club WHERE name = 'Liverpool FC'),
    0, 'CONFIRMED', 5, 51, 'SUMMER',
    NOW() - INTERVAL '2 days'
);

UPDATE player SET current_club_id = (SELECT club_id FROM club WHERE name = 'Liverpool FC'),
                 contract_status  = 'CONTRACTED'
WHERE name = 'Rayan Cherki';


-- ═══════════════════════════════════════════════════════════
--  SCENARIO D  Erling Haaland  (Man City → PSG)
--  타임라인: INTEREST(Day-3) → DENIED(Day-1) (Man City 공식 거부)
-- ═══════════════════════════════════════════════════════════

-- D-1  Di Marzio: PSG 관심 포착 (INTEREST)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'DiMarzio'),
    '1900400000000000001',
    '💰 PSG exploring the possibility of signing Erling Haaland this summer. Initial contact made with his entourage. Man City asking price: €250m. @SkySport #PSG #Haaland',
    210000, 55000, 18000, 38000000,
    NOW() - INTERVAL '3 days'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900400000000000001'),
    (SELECT player_id FROM player WHERE name = 'Erling Haaland'),
    (SELECT club_id  FROM club WHERE name = 'Manchester City'),
    (SELECT club_id  FROM club WHERE name = 'Paris Saint-Germain'),
    250000000, 'INTEREST', 3, 51, 'SUMMER',
    NOW() - INTERVAL '3 days'
);

-- D-2  Ornstein: Man City 공식 거부 + Haaland 잔류 의사 확인 (DENIED)
INSERT INTO post (journalist_id, x_post_id, content, like_count, retweet_count, reply_count, view_count, posted_at) VALUES (
    (SELECT journalist_id FROM journalist WHERE x_handle = 'David_Ornstein'),
    '1900400000000000002',
    'Manchester City have REJECTED PSG approach for Erling Haaland. Club made clear he is absolutely not for sale. Haaland himself happy to stay. @TheAthleticFC 🔵',
    95000, 20000, 6700, 14000000,
    NOW() - INTERVAL '1 day'
);

INSERT INTO transfer_news (post_id, player_id, from_club_id, to_club_id, fee_eur, status, reliability, season, transfer_window, published_at)
VALUES (
    (SELECT post_id FROM post WHERE x_post_id = '1900400000000000002'),
    (SELECT player_id FROM player WHERE name = 'Erling Haaland'),
    (SELECT club_id  FROM club WHERE name = 'Manchester City'),
    (SELECT club_id  FROM club WHERE name = 'Paris Saint-Germain'),
    NULL, 'DENIED', 5, 51, 'SUMMER',
    NOW() - INTERVAL '1 day'
);
