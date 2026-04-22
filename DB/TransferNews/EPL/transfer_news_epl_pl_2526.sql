-- ============================================================
--  Premier League 25/26 이적시장 데이터  (season=51)
--  premierleague.com 크롤링으로 자동 생성
--  전제: league / club 기초 데이터 적재 완료
-- ============================================================

-- ── 시스템 기자 (임포트용 더미) ─────────────────────────────
INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)
SELECT 'pl_import_bot', '0', 'Premier League Import Bot', 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'pl_import_bot');

-- ═══════════════════════════════════════════════════════════
--  SUMMER — 185건
-- ═══════════════════════════════════════════════════════════

-- [1] Kepa Arrizabalaga  Chelsea → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0001', 'Kepa Arrizabalaga: Chelsea → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0001');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0001'),
    (SELECT player_id FROM player WHERE name = 'Kepa Arrizabalaga'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kepa Arrizabalaga') IS NOT NULL;

-- [2] Martin Zubimendi  Real Sociedad → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0002', 'Martin Zubimendi: Real Sociedad → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0002');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0002'),
    (SELECT player_id FROM player WHERE name = 'Martin Zubimendi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Real Sociedad')),(SELECT club_id FROM club WHERE name = 'Real Sociedad')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Martin Zubimendi') IS NOT NULL;

-- [3] Christian Norgaard  Brentford → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0003', 'Christian Norgaard: Brentford → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0003');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0003'),
    (SELECT player_id FROM player WHERE name = 'Christian Norgaard'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Christian Norgaard') IS NOT NULL;

-- [4] Noni Madueke  Chelsea → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0004', 'Noni Madueke: Chelsea → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0004');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0004'),
    (SELECT player_id FROM player WHERE name = 'Noni Madueke'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Noni Madueke') IS NOT NULL;

-- [5] Cristhian Mosquera  Valencia → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0005', 'Cristhian Mosquera: Valencia → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0005');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0005'),
    (SELECT player_id FROM player WHERE name = 'Cristhian Mosquera'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Valencia')),(SELECT club_id FROM club WHERE name = 'Valencia')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Cristhian Mosquera') IS NOT NULL;

-- [6] Viktor Gyokeres  Sporting → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0006', 'Viktor Gyokeres: Sporting → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0006');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0006'),
    (SELECT player_id FROM player WHERE name = 'Viktor Gyokeres'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sporting')),(SELECT club_id FROM club WHERE name = 'Sporting')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Viktor Gyokeres') IS NOT NULL;

-- [7] Eberechi Eze  Crystal Palace → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0007', 'Eberechi Eze: Crystal Palace → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0007');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0007'),
    (SELECT player_id FROM player WHERE name = 'Eberechi Eze'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Eberechi Eze') IS NOT NULL;

-- [8] Piero Hincapie  Bayer Leverkusen → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0008', 'Piero Hincapie: Bayer Leverkusen → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0008');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0008'),
    (SELECT player_id FROM player WHERE name = 'Piero Hincapie'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayer Leverkusen')),(SELECT club_id FROM club WHERE name = 'Bayer Leverkusen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Piero Hincapie') IS NOT NULL;

-- [9] Yasin Ozcan  Kasimpasa → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0009', 'Yasin Ozcan: Kasimpasa → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0009');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0009'),
    (SELECT player_id FROM player WHERE name = 'Yasin Ozcan'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Kasimpasa')),(SELECT club_id FROM club WHERE name = 'Kasimpasa')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Yasin Ozcan') IS NOT NULL;

-- [10] Zepiqueno Redmond  Feyenoord → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0010', 'Zepiqueno Redmond: Feyenoord → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0010');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0010'),
    (SELECT player_id FROM player WHERE name = 'Zepiqueno Redmond'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Feyenoord')),(SELECT club_id FROM club WHERE name = 'Feyenoord')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Zepiqueno Redmond') IS NOT NULL;

-- [11] Marco Bizot  Brest → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0011', 'Marco Bizot: Brest → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0011');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0011'),
    (SELECT player_id FROM player WHERE name = 'Marco Bizot'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brest')),(SELECT club_id FROM club WHERE name = 'Brest')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marco Bizot') IS NOT NULL;

-- [12] Modou Keba Cisse  LASK → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0012', 'Modou Keba Cisse: LASK → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0012');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0012'),
    (SELECT player_id FROM player WHERE name = 'Modou Keba Cisse'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('LASK')),(SELECT club_id FROM club WHERE name = 'LASK')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Modou Keba Cisse') IS NOT NULL;

-- [13] Evann Guessand  Nice → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0013', 'Evann Guessand: Nice → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0013');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0013'),
    (SELECT player_id FROM player WHERE name = 'Evann Guessand'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nice')),(SELECT club_id FROM club WHERE name = 'Nice')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Evann Guessand') IS NOT NULL;

-- [14] Victor Lindelof  - → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0014', 'Victor Lindelof: - → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0014');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0014'),
    (SELECT player_id FROM player WHERE name = 'Victor Lindelof'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('-')),(SELECT club_id FROM club WHERE name = '-')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Victor Lindelof') IS NOT NULL;

-- [15] Jadon Sancho  Manchester United → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0015', 'Jadon Sancho: Manchester United → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0015');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0015'),
    (SELECT player_id FROM player WHERE name = 'Jadon Sancho'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jadon Sancho') IS NOT NULL;

-- [16] Harvey Elliott  Liverpool → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0016', 'Harvey Elliott: Liverpool → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0016');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0016'),
    (SELECT player_id FROM player WHERE name = 'Harvey Elliott'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Harvey Elliott') IS NOT NULL;

-- [17] Eli Junior Kroupi  Lorient → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0017', 'Eli Junior Kroupi: Lorient → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0017');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0017'),
    (SELECT player_id FROM player WHERE name = 'Eli Junior Kroupi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lorient')),(SELECT club_id FROM club WHERE name = 'Lorient')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Eli Junior Kroupi') IS NOT NULL;

-- [18] Adrien Truffert  Rennes → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0018', 'Adrien Truffert: Rennes → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0018');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0018'),
    (SELECT player_id FROM player WHERE name = 'Adrien Truffert'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rennes')),(SELECT club_id FROM club WHERE name = 'Rennes')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Adrien Truffert') IS NOT NULL;

-- [19] Djordje Petrovic  Chelsea → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0019', 'Djordje Petrovic: Chelsea → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0019');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0019'),
    (SELECT player_id FROM player WHERE name = 'Djordje Petrovic'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Djordje Petrovic') IS NOT NULL;

-- [20] Bafode Diakite  Lille → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0020', 'Bafode Diakite: Lille → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0020');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0020'),
    (SELECT player_id FROM player WHERE name = 'Bafode Diakite'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lille')),(SELECT club_id FROM club WHERE name = 'Lille')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Bafode Diakite') IS NOT NULL;

-- [21] Ben Gannon-Doak  Liverpool → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0021', 'Ben Gannon-Doak: Liverpool → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0021');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0021'),
    (SELECT player_id FROM player WHERE name = 'Ben Gannon-Doak'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Ben Gannon-Doak') IS NOT NULL;

-- [22] Amine Adli  Bayer Leverkusen → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0022', 'Amine Adli: Bayer Leverkusen → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0022');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0022'),
    (SELECT player_id FROM player WHERE name = 'Amine Adli'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayer Leverkusen')),(SELECT club_id FROM club WHERE name = 'Bayer Leverkusen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Amine Adli') IS NOT NULL;

-- [23] Veljko Milosavljevic  Red Star Belgrade → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0023', 'Veljko Milosavljevic: Red Star Belgrade → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0023');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0023'),
    (SELECT player_id FROM player WHERE name = 'Veljko Milosavljevic'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Red Star Belgrade')),(SELECT club_id FROM club WHERE name = 'Red Star Belgrade')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Veljko Milosavljevic') IS NOT NULL;

-- [24] Michael Kayode  Fiorentina → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0024', 'Michael Kayode: Fiorentina → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0024');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0024'),
    (SELECT player_id FROM player WHERE name = 'Michael Kayode'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fiorentina')),(SELECT club_id FROM club WHERE name = 'Fiorentina')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Michael Kayode') IS NOT NULL;

-- [25] Romelle Donovan  Birmingham City → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0025', 'Romelle Donovan: Birmingham City → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0025');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0025'),
    (SELECT player_id FROM player WHERE name = 'Romelle Donovan'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Birmingham City')),(SELECT club_id FROM club WHERE name = 'Birmingham City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Romelle Donovan') IS NOT NULL;

-- [26] Caoimhin Kelleher  Liverpool → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0026', 'Caoimhin Kelleher: Liverpool → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0026');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0026'),
    (SELECT player_id FROM player WHERE name = 'Caoimhin Kelleher'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Caoimhin Kelleher') IS NOT NULL;

-- [27] Antoni Milambo  Feyenoord → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0027', 'Antoni Milambo: Feyenoord → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0027');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0027'),
    (SELECT player_id FROM player WHERE name = 'Antoni Milambo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Feyenoord')),(SELECT club_id FROM club WHERE name = 'Feyenoord')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Antoni Milambo') IS NOT NULL;

-- [28] Jordan Henderson  Ajax → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0028', 'Jordan Henderson: Ajax → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0028');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0028'),
    (SELECT player_id FROM player WHERE name = 'Jordan Henderson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jordan Henderson') IS NOT NULL;

-- [29] Kyrie Pierre  Aston Villa → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0029', 'Kyrie Pierre: Aston Villa → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0029');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0029'),
    (SELECT player_id FROM player WHERE name = 'Kyrie Pierre'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kyrie Pierre') IS NOT NULL;

-- [30] Dango Ouattara  AFC Bournemouth → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0030', 'Dango Ouattara: AFC Bournemouth → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0030');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0030'),
    (SELECT player_id FROM player WHERE name = 'Dango Ouattara'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dango Ouattara') IS NOT NULL;

-- [31] Reiss Nelson  Arsenal → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0031', 'Reiss Nelson: Arsenal → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0031');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0031'),
    (SELECT player_id FROM player WHERE name = 'Reiss Nelson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Reiss Nelson') IS NOT NULL;

-- [32] Tommy Watson  Sunderland → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0032', 'Tommy Watson: Sunderland → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0032');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0032'),
    (SELECT player_id FROM player WHERE name = 'Tommy Watson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tommy Watson') IS NOT NULL;

-- [33] Yun Do-young  Daejon Hana Citizen → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0033', 'Yun Do-young: Daejon Hana Citizen → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0033');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0033'),
    (SELECT player_id FROM player WHERE name = 'Yun Do-young'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Daejon Hana Citizen')),(SELECT club_id FROM club WHERE name = 'Daejon Hana Citizen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Yun Do-young') IS NOT NULL;

-- [34] Charalampos Kostoulas  Olympiacos → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0034', 'Charalampos Kostoulas: Olympiacos → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0034');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0034'),
    (SELECT player_id FROM player WHERE name = 'Charalampos Kostoulas'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Olympiacos')),(SELECT club_id FROM club WHERE name = 'Olympiacos')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Charalampos Kostoulas') IS NOT NULL;

-- [35] Diego Coppola  Verona → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0035', 'Diego Coppola: Verona → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0035');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0035'),
    (SELECT player_id FROM player WHERE name = 'Diego Coppola'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Verona')),(SELECT club_id FROM club WHERE name = 'Verona')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Diego Coppola') IS NOT NULL;

-- [36] Nils Ramming  Eintracht Frankfurt → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0036', 'Nils Ramming: Eintracht Frankfurt → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0036');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0036'),
    (SELECT player_id FROM player WHERE name = 'Nils Ramming'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Eintracht Frankfurt')),(SELECT club_id FROM club WHERE name = 'Eintracht Frankfurt')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Nils Ramming') IS NOT NULL;

-- [37] Olivier Boscagli  PSV → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0037', 'Olivier Boscagli: PSV → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0037');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0037'),
    (SELECT player_id FROM player WHERE name = 'Olivier Boscagli'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('PSV')),(SELECT club_id FROM club WHERE name = 'PSV')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Olivier Boscagli') IS NOT NULL;

-- [38] Maxim De Cuyper  Club Brugge → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0038', 'Maxim De Cuyper: Club Brugge → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0038');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0038'),
    (SELECT player_id FROM player WHERE name = 'Maxim De Cuyper'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Club Brugge')),(SELECT club_id FROM club WHERE name = 'Club Brugge')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Maxim De Cuyper') IS NOT NULL;

-- [39] Sean Keogh  Dundalk → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0039', 'Sean Keogh: Dundalk → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0039');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0039'),
    (SELECT player_id FROM player WHERE name = 'Sean Keogh'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Dundalk')),(SELECT club_id FROM club WHERE name = 'Dundalk')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sean Keogh') IS NOT NULL;

-- [40] Kofi Shaw  Bristol Rovers → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0040', 'Kofi Shaw: Bristol Rovers → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0040');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0040'),
    (SELECT player_id FROM player WHERE name = 'Kofi Shaw'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bristol Rovers')),(SELECT club_id FROM club WHERE name = 'Bristol Rovers')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kofi Shaw') IS NOT NULL;

-- [41] Bashir Humphreys  Chelsea → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0041', 'Bashir Humphreys: Chelsea → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0041');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0041'),
    (SELECT player_id FROM player WHERE name = 'Bashir Humphreys'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Bashir Humphreys') IS NOT NULL;

-- [42] Jaidon Anthony  Bournemouth → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0042', 'Jaidon Anthony: Bournemouth → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0042');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0042'),
    (SELECT player_id FROM player WHERE name = 'Jaidon Anthony'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bournemouth')),(SELECT club_id FROM club WHERE name = 'Bournemouth')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jaidon Anthony') IS NOT NULL;

-- [43] Marcus Edwards  Sporting → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0043', 'Marcus Edwards: Sporting → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0043');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0043'),
    (SELECT player_id FROM player WHERE name = 'Marcus Edwards'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sporting')),(SELECT club_id FROM club WHERE name = 'Sporting')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marcus Edwards') IS NOT NULL;

-- [44] Zian Flemming  Millwall → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0044', 'Zian Flemming: Millwall → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0044');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0044'),
    (SELECT player_id FROM player WHERE name = 'Zian Flemming'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Millwall')),(SELECT club_id FROM club WHERE name = 'Millwall')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Zian Flemming') IS NOT NULL;

-- [45] Max Weiss  Karlsruher → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0045', 'Max Weiss: Karlsruher → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0045');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0045'),
    (SELECT player_id FROM player WHERE name = 'Max Weiss'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Karlsruher')),(SELECT club_id FROM club WHERE name = 'Karlsruher')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Max Weiss') IS NOT NULL;

-- [46] Quilindschy Hartman  Feyenoord → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0046', 'Quilindschy Hartman: Feyenoord → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0046');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0046'),
    (SELECT player_id FROM player WHERE name = 'Quilindschy Hartman'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Feyenoord')),(SELECT club_id FROM club WHERE name = 'Feyenoord')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Quilindschy Hartman') IS NOT NULL;

-- [47] Axel Tuanzebe  Ipswich → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0047', 'Axel Tuanzebe: Ipswich → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0047');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0047'),
    (SELECT player_id FROM player WHERE name = 'Axel Tuanzebe'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ipswich')),(SELECT club_id FROM club WHERE name = 'Ipswich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Axel Tuanzebe') IS NOT NULL;

-- [48] Loum Tchaouna  Lazio → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0048', 'Loum Tchaouna: Lazio → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0048');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0048'),
    (SELECT player_id FROM player WHERE name = 'Loum Tchaouna'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lazio')),(SELECT club_id FROM club WHERE name = 'Lazio')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Loum Tchaouna') IS NOT NULL;

-- [49] Kyle Walker  Man City → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0049', 'Kyle Walker: Man City → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0049');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0049'),
    (SELECT player_id FROM player WHERE name = 'Kyle Walker'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Man City')),(SELECT club_id FROM club WHERE name = 'Man City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kyle Walker') IS NOT NULL;

-- [50] Jacob Bruun Larsen  Stuttgart → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0050', 'Jacob Bruun Larsen: Stuttgart → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0050');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0050'),
    (SELECT player_id FROM player WHERE name = 'Jacob Bruun Larsen'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Stuttgart')),(SELECT club_id FROM club WHERE name = 'Stuttgart')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jacob Bruun Larsen') IS NOT NULL;

-- [51] Lesley Ugochukwu  Chelsea → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0051', 'Lesley Ugochukwu: Chelsea → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0051');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0051'),
    (SELECT player_id FROM player WHERE name = 'Lesley Ugochukwu'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lesley Ugochukwu') IS NOT NULL;

-- [52] Martin Dubravka  Newcastle → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0052', 'Martin Dubravka: Newcastle → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0052');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0052'),
    (SELECT player_id FROM player WHERE name = 'Martin Dubravka'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle')),(SELECT club_id FROM club WHERE name = 'Newcastle')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Martin Dubravka') IS NOT NULL;

-- [53] Armando Broja  Chelsea → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0053', 'Armando Broja: Chelsea → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0053');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0053'),
    (SELECT player_id FROM player WHERE name = 'Armando Broja'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Armando Broja') IS NOT NULL;

-- [54] Florentino Luis  Benfica → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0054', 'Florentino Luis: Benfica → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0054');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0054'),
    (SELECT player_id FROM player WHERE name = 'Florentino Luis'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Benfica')),(SELECT club_id FROM club WHERE name = 'Benfica')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Florentino Luis') IS NOT NULL;

-- [55] Dario Essugo  Sporting → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0055', 'Dario Essugo: Sporting → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0055');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0055'),
    (SELECT player_id FROM player WHERE name = 'Dario Essugo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sporting')),(SELECT club_id FROM club WHERE name = 'Sporting')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dario Essugo') IS NOT NULL;

-- [56] Liam Delap  Ipswich → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0056', 'Liam Delap: Ipswich → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0056');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0056'),
    (SELECT player_id FROM player WHERE name = 'Liam Delap'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ipswich')),(SELECT club_id FROM club WHERE name = 'Ipswich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Liam Delap') IS NOT NULL;

-- [57] Mamadou Sarr  Strasbourg → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0057', 'Mamadou Sarr: Strasbourg → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0057');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0057'),
    (SELECT player_id FROM player WHERE name = 'Mamadou Sarr'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Strasbourg')),(SELECT club_id FROM club WHERE name = 'Strasbourg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mamadou Sarr') IS NOT NULL;

-- [58] Joao Pedro  Brighton → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0058', 'Joao Pedro: Brighton → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0058');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0058'),
    (SELECT player_id FROM player WHERE name = 'Joao Pedro'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton')),(SELECT club_id FROM club WHERE name = 'Brighton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Joao Pedro') IS NOT NULL;

-- [59] Jamie Gittens  Borussia Dortmund → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0059', 'Jamie Gittens: Borussia Dortmund → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0059');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0059'),
    (SELECT player_id FROM player WHERE name = 'Jamie Gittens'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Borussia Dortmund')),(SELECT club_id FROM club WHERE name = 'Borussia Dortmund')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jamie Gittens') IS NOT NULL;

-- [60] Jesse Derry  Crystal Palace → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0060', 'Jesse Derry: Crystal Palace → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0060');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0060'),
    (SELECT player_id FROM player WHERE name = 'Jesse Derry'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jesse Derry') IS NOT NULL;

-- [61] Jorrel Hato  Ajax → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0061', 'Jorrel Hato: Ajax → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0061');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0061'),
    (SELECT player_id FROM player WHERE name = 'Jorrel Hato'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jorrel Hato') IS NOT NULL;

-- [62] Estevao  Palmeiras → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0062', 'Estevao: Palmeiras → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0062');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0062'),
    (SELECT player_id FROM player WHERE name = 'Estevao'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Palmeiras')),(SELECT club_id FROM club WHERE name = 'Palmeiras')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Estevao') IS NOT NULL;

-- [63] Alejandro Garnacho  Manchester United → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0063', 'Alejandro Garnacho: Manchester United → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0063');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0063'),
    (SELECT player_id FROM player WHERE name = 'Alejandro Garnacho'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Alejandro Garnacho') IS NOT NULL;

-- [64] Facundo Buonanotte  Brighton → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0064', 'Facundo Buonanotte: Brighton → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0064');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0064'),
    (SELECT player_id FROM player WHERE name = 'Facundo Buonanotte'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton')),(SELECT club_id FROM club WHERE name = 'Brighton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Facundo Buonanotte') IS NOT NULL;

-- [65] Marc Guiu  Sunderland → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0065', 'Marc Guiu: Sunderland → Chelsea [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0065');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0065'),
    (SELECT player_id FROM player WHERE name = 'Marc Guiu'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'LOAN', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marc Guiu') IS NOT NULL;

-- [66] Emanuel Emegha  RC Strasbourg → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0066', 'Emanuel Emegha: RC Strasbourg → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0066');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0066'),
    (SELECT player_id FROM player WHERE name = 'Emanuel Emegha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('RC Strasbourg')),(SELECT club_id FROM club WHERE name = 'RC Strasbourg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Emanuel Emegha') IS NOT NULL;

-- [67] Walter Benitez  PSV Eindhoven → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0067', 'Walter Benitez: PSV Eindhoven → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0067');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0067'),
    (SELECT player_id FROM player WHERE name = 'Walter Benitez'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('PSV Eindhoven')),(SELECT club_id FROM club WHERE name = 'PSV Eindhoven')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Walter Benitez') IS NOT NULL;

-- [68] Borna Sosa  Ajax → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0068', 'Borna Sosa: Ajax → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0068');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0068'),
    (SELECT player_id FROM player WHERE name = 'Borna Sosa'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Borna Sosa') IS NOT NULL;

-- [69] Yeremy Pino  Villarreal → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0069', 'Yeremy Pino: Villarreal → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0069');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0069'),
    (SELECT player_id FROM player WHERE name = 'Yeremy Pino'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Villarreal')),(SELECT club_id FROM club WHERE name = 'Villarreal')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Yeremy Pino') IS NOT NULL;

-- [70] Jaydee Canvot  Toulouse → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0070', 'Jaydee Canvot: Toulouse → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0070');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0070'),
    (SELECT player_id FROM player WHERE name = 'Jaydee Canvot'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Toulouse')),(SELECT club_id FROM club WHERE name = 'Toulouse')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jaydee Canvot') IS NOT NULL;

-- [71] Christantus Uche  Getafe → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0071', 'Christantus Uche: Getafe → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0071');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0071'),
    (SELECT player_id FROM player WHERE name = 'Christantus Uche'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Getafe')),(SELECT club_id FROM club WHERE name = 'Getafe')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Christantus Uche') IS NOT NULL;

-- [72] Charly Alcaraz  Flamengo → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0072', 'Charly Alcaraz: Flamengo → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0072');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0072'),
    (SELECT player_id FROM player WHERE name = 'Charly Alcaraz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Flamengo')),(SELECT club_id FROM club WHERE name = 'Flamengo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Charly Alcaraz') IS NOT NULL;

-- [73] Thierno Barry  Villarreal → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0073', 'Thierno Barry: Villarreal → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0073');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0073'),
    (SELECT player_id FROM player WHERE name = 'Thierno Barry'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Villarreal')),(SELECT club_id FROM club WHERE name = 'Villarreal')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Thierno Barry') IS NOT NULL;

-- [74] Mark Travers  Bournemouth → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0074', 'Mark Travers: Bournemouth → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0074');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0074'),
    (SELECT player_id FROM player WHERE name = 'Mark Travers'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bournemouth')),(SELECT club_id FROM club WHERE name = 'Bournemouth')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mark Travers') IS NOT NULL;

-- [75] Adam Aznou  Bayern Munich → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0075', 'Adam Aznou: Bayern Munich → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0075');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0075'),
    (SELECT player_id FROM player WHERE name = 'Adam Aznou'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayern Munich')),(SELECT club_id FROM club WHERE name = 'Bayern Munich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Adam Aznou') IS NOT NULL;

-- [76] Kiernan Dewsbury-Hall  Chelsea → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0076', 'Kiernan Dewsbury-Hall: Chelsea → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0076');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0076'),
    (SELECT player_id FROM player WHERE name = 'Kiernan Dewsbury-Hall'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kiernan Dewsbury-Hall') IS NOT NULL;

-- [77] Jack Grealish  Man City → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0077', 'Jack Grealish: Man City → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0077');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0077'),
    (SELECT player_id FROM player WHERE name = 'Jack Grealish'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Man City')),(SELECT club_id FROM club WHERE name = 'Man City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jack Grealish') IS NOT NULL;

-- [78] Reuben Gokah  Charlton Athletic → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0078', 'Reuben Gokah: Charlton Athletic → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0078');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0078'),
    (SELECT player_id FROM player WHERE name = 'Reuben Gokah'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Charlton Athletic')),(SELECT club_id FROM club WHERE name = 'Charlton Athletic')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Reuben Gokah') IS NOT NULL;

-- [79] Tom King  Wolves → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0079', 'Tom King: Wolves → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0079');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0079'),
    (SELECT player_id FROM player WHERE name = 'Tom King'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tom King') IS NOT NULL;

-- [80] Tyler Dibling  Southampton → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0080', 'Tyler Dibling: Southampton → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0080');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0080'),
    (SELECT player_id FROM player WHERE name = 'Tyler Dibling'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Southampton')),(SELECT club_id FROM club WHERE name = 'Southampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tyler Dibling') IS NOT NULL;

-- [81] Merlin Rohl  SC Freiburg → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0081', 'Merlin Rohl: SC Freiburg → Everton [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0081');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0081'),
    (SELECT player_id FROM player WHERE name = 'Merlin Rohl'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('SC Freiburg')),(SELECT club_id FROM club WHERE name = 'SC Freiburg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Merlin Rohl') IS NOT NULL;

-- [82] Benjamin Lecomte  Montpellier → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0082', 'Benjamin Lecomte: Montpellier → Fulham [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0082');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0082'),
    (SELECT player_id FROM player WHERE name = 'Benjamin Lecomte'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Montpellier')),(SELECT club_id FROM club WHERE name = 'Montpellier')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Benjamin Lecomte') IS NOT NULL;

-- [83] Samuel Chukwueze  AC Milan → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0083', 'Samuel Chukwueze: AC Milan → Fulham [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0083');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0083'),
    (SELECT player_id FROM player WHERE name = 'Samuel Chukwueze'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AC Milan')),(SELECT club_id FROM club WHERE name = 'AC Milan')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Samuel Chukwueze') IS NOT NULL;

-- [84] Kevin  Shakhtar Donetsk → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0084', 'Kevin: Shakhtar Donetsk → Fulham [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0084');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0084'),
    (SELECT player_id FROM player WHERE name = 'Kevin'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Shakhtar Donetsk')),(SELECT club_id FROM club WHERE name = 'Shakhtar Donetsk')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kevin') IS NOT NULL;

-- [85] Lewis Kondau-Wall  - → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0085', 'Lewis Kondau-Wall: - → Fulham [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0085');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0085'),
    (SELECT player_id FROM player WHERE name = 'Lewis Kondau-Wall'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('-')),(SELECT club_id FROM club WHERE name = '-')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lewis Kondau-Wall') IS NOT NULL;

-- [86] Lukas Nmecha  Wolfsburg → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0086', 'Lukas Nmecha: Wolfsburg → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0086');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0086'),
    (SELECT player_id FROM player WHERE name = 'Lukas Nmecha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolfsburg')),(SELECT club_id FROM club WHERE name = 'Wolfsburg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lukas Nmecha') IS NOT NULL;

-- [87] Sebastiaan Bornauw  Wolfsburg → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0087', 'Sebastiaan Bornauw: Wolfsburg → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0087');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0087'),
    (SELECT player_id FROM player WHERE name = 'Sebastiaan Bornauw'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolfsburg')),(SELECT club_id FROM club WHERE name = 'Wolfsburg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sebastiaan Bornauw') IS NOT NULL;

-- [88] Jaka Bijol  Udinese → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0088', 'Jaka Bijol: Udinese → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0088');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0088'),
    (SELECT player_id FROM player WHERE name = 'Jaka Bijol'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Udinese')),(SELECT club_id FROM club WHERE name = 'Udinese')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jaka Bijol') IS NOT NULL;

-- [89] Gabriel Gudmundsson  Lille → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0089', 'Gabriel Gudmundsson: Lille → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0089');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0089'),
    (SELECT player_id FROM player WHERE name = 'Gabriel Gudmundsson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lille')),(SELECT club_id FROM club WHERE name = 'Lille')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Gabriel Gudmundsson') IS NOT NULL;

-- [90] Louis Enahoro-Marcus  Liverpool → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0090', 'Louis Enahoro-Marcus: Liverpool → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0090');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0090'),
    (SELECT player_id FROM player WHERE name = 'Louis Enahoro-Marcus'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Louis Enahoro-Marcus') IS NOT NULL;

-- [91] Sean Longstaff  Newcastle → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0091', 'Sean Longstaff: Newcastle → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0091');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0091'),
    (SELECT player_id FROM player WHERE name = 'Sean Longstaff'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle')),(SELECT club_id FROM club WHERE name = 'Newcastle')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sean Longstaff') IS NOT NULL;

-- [92] Anton Stach  TSG Hoffenheim → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0092', 'Anton Stach: TSG Hoffenheim → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0092');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0092'),
    (SELECT player_id FROM player WHERE name = 'Anton Stach'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('TSG Hoffenheim')),(SELECT club_id FROM club WHERE name = 'TSG Hoffenheim')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Anton Stach') IS NOT NULL;

-- [93] Lucas Perri  Lyon → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0093', 'Lucas Perri: Lyon → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0093');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0093'),
    (SELECT player_id FROM player WHERE name = 'Lucas Perri'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lyon')),(SELECT club_id FROM club WHERE name = 'Lyon')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lucas Perri') IS NOT NULL;

-- [94] Dominic Calvert-Lewin  Everton → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0094', 'Dominic Calvert-Lewin: Everton → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0094');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0094'),
    (SELECT player_id FROM player WHERE name = 'Dominic Calvert-Lewin'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dominic Calvert-Lewin') IS NOT NULL;

-- [95] Noah Okafor  AC Milan → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0095', 'Noah Okafor: AC Milan → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0095');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0095'),
    (SELECT player_id FROM player WHERE name = 'Noah Okafor'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AC Milan')),(SELECT club_id FROM club WHERE name = 'AC Milan')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Noah Okafor') IS NOT NULL;

-- [96] James Justin  Leicester → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0096', 'James Justin: Leicester → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0096');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0096'),
    (SELECT player_id FROM player WHERE name = 'James Justin'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leicester')),(SELECT club_id FROM club WHERE name = 'Leicester')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James Justin') IS NOT NULL;

-- [97] Giorgi Mamardashvili  Valencia → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0097', 'Giorgi Mamardashvili: Valencia → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0097');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0097'),
    (SELECT player_id FROM player WHERE name = 'Giorgi Mamardashvili'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Valencia')),(SELECT club_id FROM club WHERE name = 'Valencia')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Giorgi Mamardashvili') IS NOT NULL;

-- [98] Jeremie Frimpong  Bayer Leverkusen → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0098', 'Jeremie Frimpong: Bayer Leverkusen → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0098');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0098'),
    (SELECT player_id FROM player WHERE name = 'Jeremie Frimpong'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayer Leverkusen')),(SELECT club_id FROM club WHERE name = 'Bayer Leverkusen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jeremie Frimpong') IS NOT NULL;

-- [99] Armin Pecsi  Puskas Akademia → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0099', 'Armin Pecsi: Puskas Akademia → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0099');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0099'),
    (SELECT player_id FROM player WHERE name = 'Armin Pecsi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Puskas Akademia')),(SELECT club_id FROM club WHERE name = 'Puskas Akademia')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Armin Pecsi') IS NOT NULL;

-- [100] Florian Wirtz  Bayer Leverkusen → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0100', 'Florian Wirtz: Bayer Leverkusen → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0100');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0100'),
    (SELECT player_id FROM player WHERE name = 'Florian Wirtz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayer Leverkusen')),(SELECT club_id FROM club WHERE name = 'Bayer Leverkusen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Florian Wirtz') IS NOT NULL;

-- [101] Milos Kerkez  Bournemouth → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0101', 'Milos Kerkez: Bournemouth → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0101');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0101'),
    (SELECT player_id FROM player WHERE name = 'Milos Kerkez'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bournemouth')),(SELECT club_id FROM club WHERE name = 'Bournemouth')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Milos Kerkez') IS NOT NULL;

-- [102] Freddie Woodman  Preston North → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0102', 'Freddie Woodman: Preston North → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0102');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0102'),
    (SELECT player_id FROM player WHERE name = 'Freddie Woodman'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Preston North')),(SELECT club_id FROM club WHERE name = 'Preston North')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Freddie Woodman') IS NOT NULL;

-- [103] Hugo Ekitike  Eintracht Frankfurt → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0103', 'Hugo Ekitike: Eintracht Frankfurt → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0103');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0103'),
    (SELECT player_id FROM player WHERE name = 'Hugo Ekitike'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Eintracht Frankfurt')),(SELECT club_id FROM club WHERE name = 'Eintracht Frankfurt')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Hugo Ekitike') IS NOT NULL;

-- [104] Will Wright  Salford → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0104', 'Will Wright: Salford → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0104');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0104'),
    (SELECT player_id FROM player WHERE name = 'Will Wright'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Salford')),(SELECT club_id FROM club WHERE name = 'Salford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Will Wright') IS NOT NULL;

-- [105] Giovanni Leoni  Parma → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0105', 'Giovanni Leoni: Parma → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0105');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0105'),
    (SELECT player_id FROM player WHERE name = 'Giovanni Leoni'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Parma')),(SELECT club_id FROM club WHERE name = 'Parma')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Giovanni Leoni') IS NOT NULL;

-- [106] Alexander Isak  Newcastle United → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0106', 'Alexander Isak: Newcastle United → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0106');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0106'),
    (SELECT player_id FROM player WHERE name = 'Alexander Isak'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Alexander Isak') IS NOT NULL;

-- [107] Rayan Ait-Nouri  Wolves → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0107', 'Rayan Ait-Nouri: Wolves → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0107');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0107'),
    (SELECT player_id FROM player WHERE name = 'Rayan Ait-Nouri'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Rayan Ait-Nouri') IS NOT NULL;

-- [108] Marcus Bettinelli  Chelsea → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0108', 'Marcus Bettinelli: Chelsea → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0108');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0108'),
    (SELECT player_id FROM player WHERE name = 'Marcus Bettinelli'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marcus Bettinelli') IS NOT NULL;

-- [109] Rayan Cherki  Lyon → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0109', 'Rayan Cherki: Lyon → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0109');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0109'),
    (SELECT player_id FROM player WHERE name = 'Rayan Cherki'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lyon')),(SELECT club_id FROM club WHERE name = 'Lyon')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Rayan Cherki') IS NOT NULL;

-- [110] Tijjani Reijnders  AC Milan → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0110', 'Tijjani Reijnders: AC Milan → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0110');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0110'),
    (SELECT player_id FROM player WHERE name = 'Tijjani Reijnders'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AC Milan')),(SELECT club_id FROM club WHERE name = 'AC Milan')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tijjani Reijnders') IS NOT NULL;

-- [111] Sverre Nypan  Rosenborg → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0111', 'Sverre Nypan: Rosenborg → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0111');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0111'),
    (SELECT player_id FROM player WHERE name = 'Sverre Nypan'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rosenborg')),(SELECT club_id FROM club WHERE name = 'Rosenborg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sverre Nypan') IS NOT NULL;

-- [112] James Trafford  Burnley → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0112', 'James Trafford: Burnley → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0112');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0112'),
    (SELECT player_id FROM player WHERE name = 'James Trafford'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James Trafford') IS NOT NULL;

-- [113] Gianluigi Donnarumma  Paris Saint-Germain → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0113', 'Gianluigi Donnarumma: Paris Saint-Germain → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0113');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0113'),
    (SELECT player_id FROM player WHERE name = 'Gianluigi Donnarumma'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Paris Saint-Germain')),(SELECT club_id FROM club WHERE name = 'Paris Saint-Germain')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Gianluigi Donnarumma') IS NOT NULL;

-- [114] Matheus Cunha  Wolves → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0114', 'Matheus Cunha: Wolves → Manchester United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0114');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0114'),
    (SELECT player_id FROM player WHERE name = 'Matheus Cunha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Matheus Cunha') IS NOT NULL;

-- [115] Diego Leon  Cerro Porteno → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0115', 'Diego Leon: Cerro Porteno → Manchester United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0115');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0115'),
    (SELECT player_id FROM player WHERE name = 'Diego Leon'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Cerro Porteno')),(SELECT club_id FROM club WHERE name = 'Cerro Porteno')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Diego Leon') IS NOT NULL;

-- [116] Bryan Mbeumo  Brentford → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0116', 'Bryan Mbeumo: Brentford → Manchester United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0116');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0116'),
    (SELECT player_id FROM player WHERE name = 'Bryan Mbeumo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Bryan Mbeumo') IS NOT NULL;

-- [117] Benjamin Sesko  RB Leipzig → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0117', 'Benjamin Sesko: RB Leipzig → Manchester United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0117');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0117'),
    (SELECT player_id FROM player WHERE name = 'Benjamin Sesko'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('RB Leipzig')),(SELECT club_id FROM club WHERE name = 'RB Leipzig')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Benjamin Sesko') IS NOT NULL;

-- [118] Senne Lammens  Royal Antwerp → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0118', 'Senne Lammens: Royal Antwerp → Manchester United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0118');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0118'),
    (SELECT player_id FROM player WHERE name = 'Senne Lammens'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Royal Antwerp')),(SELECT club_id FROM club WHERE name = 'Royal Antwerp')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Senne Lammens') IS NOT NULL;

-- [119] Antonio Cordero  Malaga → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0119', 'Antonio Cordero: Malaga → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0119');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0119'),
    (SELECT player_id FROM player WHERE name = 'Antonio Cordero'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Malaga')),(SELECT club_id FROM club WHERE name = 'Malaga')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Antonio Cordero') IS NOT NULL;

-- [120] Anthony Elanga  Nottingham Forest → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0120', 'Anthony Elanga: Nottingham Forest → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0120');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0120'),
    (SELECT player_id FROM player WHERE name = 'Anthony Elanga'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Anthony Elanga') IS NOT NULL;

-- [121] Seung-soo Park  Suwon Bluewings → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0121', 'Seung-soo Park: Suwon Bluewings → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0121');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0121'),
    (SELECT player_id FROM player WHERE name = 'Seung-soo Park'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Suwon Bluewings')),(SELECT club_id FROM club WHERE name = 'Suwon Bluewings')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Seung-soo Park') IS NOT NULL;

-- [122] Aaron Ramsdale  Southampton → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0122', 'Aaron Ramsdale: Southampton → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0122');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0122'),
    (SELECT player_id FROM player WHERE name = 'Aaron Ramsdale'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Southampton')),(SELECT club_id FROM club WHERE name = 'Southampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Aaron Ramsdale') IS NOT NULL;

-- [123] Malick Thiaw  AC Milan → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0123', 'Malick Thiaw: AC Milan → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0123');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0123'),
    (SELECT player_id FROM player WHERE name = 'Malick Thiaw'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AC Milan')),(SELECT club_id FROM club WHERE name = 'AC Milan')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Malick Thiaw') IS NOT NULL;

-- [124] Jacob Ramsey  Aston Villa → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0124', 'Jacob Ramsey: Aston Villa → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0124');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0124'),
    (SELECT player_id FROM player WHERE name = 'Jacob Ramsey'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jacob Ramsey') IS NOT NULL;

-- [125] Nick Woltemade  Stuttgart → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0125', 'Nick Woltemade: Stuttgart → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0125');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0125'),
    (SELECT player_id FROM player WHERE name = 'Nick Woltemade'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Stuttgart')),(SELECT club_id FROM club WHERE name = 'Stuttgart')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Nick Woltemade') IS NOT NULL;

-- [126] Yoane Wissa  Brentford → Newcastle United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0126', 'Yoane Wissa: Brentford → Newcastle United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0126');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0126'),
    (SELECT player_id FROM player WHERE name = 'Yoane Wissa'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle United')),(SELECT club_id FROM club WHERE name = 'Newcastle United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Yoane Wissa') IS NOT NULL;

-- [127] Igor Jesus  Botafogo → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0127', 'Igor Jesus: Botafogo → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0127');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0127'),
    (SELECT player_id FROM player WHERE name = 'Igor Jesus'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Botafogo')),(SELECT club_id FROM club WHERE name = 'Botafogo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Igor Jesus') IS NOT NULL;

-- [128] Cherif Yaya  Rio Ave → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0128', 'Cherif Yaya: Rio Ave → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0128');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0128'),
    (SELECT player_id FROM player WHERE name = 'Cherif Yaya'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rio Ave')),(SELECT club_id FROM club WHERE name = 'Rio Ave')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Cherif Yaya') IS NOT NULL;

-- [129] Jair Cunha  Botafogo → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0129', 'Jair Cunha: Botafogo → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0129');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0129'),
    (SELECT player_id FROM player WHERE name = 'Jair Cunha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Botafogo')),(SELECT club_id FROM club WHERE name = 'Botafogo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jair Cunha') IS NOT NULL;

-- [130] Dan Ndoye  Bologna → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0130', 'Dan Ndoye: Bologna → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0130');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0130'),
    (SELECT player_id FROM player WHERE name = 'Dan Ndoye'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bologna')),(SELECT club_id FROM club WHERE name = 'Bologna')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dan Ndoye') IS NOT NULL;

-- [131] Angus Gunn  Norwich → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0131', 'Angus Gunn: Norwich → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0131');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0131'),
    (SELECT player_id FROM player WHERE name = 'Angus Gunn'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Norwich')),(SELECT club_id FROM club WHERE name = 'Norwich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Angus Gunn') IS NOT NULL;

-- [132] Omari Hutchinson  Ipswich Town → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0132', 'Omari Hutchinson: Ipswich Town → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0132');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0132'),
    (SELECT player_id FROM player WHERE name = 'Omari Hutchinson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ipswich Town')),(SELECT club_id FROM club WHERE name = 'Ipswich Town')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Omari Hutchinson') IS NOT NULL;

-- [133] James McAtee  Manchester City → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0133', 'James McAtee: Manchester City → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0133');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0133'),
    (SELECT player_id FROM player WHERE name = 'James McAtee'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James McAtee') IS NOT NULL;

-- [134] Arnaud Kalimuendo  Rennes → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0134', 'Arnaud Kalimuendo: Rennes → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0134');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0134'),
    (SELECT player_id FROM player WHERE name = 'Arnaud Kalimuendo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rennes')),(SELECT club_id FROM club WHERE name = 'Rennes')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Arnaud Kalimuendo') IS NOT NULL;

-- [135] Douglas Luiz  Juventus → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0135', 'Douglas Luiz: Juventus → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0135');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0135'),
    (SELECT player_id FROM player WHERE name = 'Douglas Luiz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Juventus')),(SELECT club_id FROM club WHERE name = 'Juventus')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Douglas Luiz') IS NOT NULL;

-- [136] Nicolo Savona  Juventus → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0136', 'Nicolo Savona: Juventus → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0136');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0136'),
    (SELECT player_id FROM player WHERE name = 'Nicolo Savona'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Juventus')),(SELECT club_id FROM club WHERE name = 'Juventus')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Nicolo Savona') IS NOT NULL;

-- [137] John Victor  Botafogo → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0137', 'John Victor: Botafogo → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0137');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0137'),
    (SELECT player_id FROM player WHERE name = 'John Victor'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Botafogo')),(SELECT club_id FROM club WHERE name = 'Botafogo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'John Victor') IS NOT NULL;

-- [138] Donnell McNeilly  Chelsea → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0138', 'Donnell McNeilly: Chelsea → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0138');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0138'),
    (SELECT player_id FROM player WHERE name = 'Donnell McNeilly'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Donnell McNeilly') IS NOT NULL;

-- [139] Matthew Orr  Linfield → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0139', 'Matthew Orr: Linfield → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0139');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0139'),
    (SELECT player_id FROM player WHERE name = 'Matthew Orr'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Linfield')),(SELECT club_id FROM club WHERE name = 'Linfield')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Matthew Orr') IS NOT NULL;

-- [140] Cuiabano  Botafogo → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0140', 'Cuiabano: Botafogo → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0140');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0140'),
    (SELECT player_id FROM player WHERE name = 'Cuiabano'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Botafogo')),(SELECT club_id FROM club WHERE name = 'Botafogo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Cuiabano') IS NOT NULL;

-- [141] Dilane Bakwa  Strasbourg → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0141', 'Dilane Bakwa: Strasbourg → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0141');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0141'),
    (SELECT player_id FROM player WHERE name = 'Dilane Bakwa'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Strasbourg')),(SELECT club_id FROM club WHERE name = 'Strasbourg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dilane Bakwa') IS NOT NULL;

-- [142] Oleksandr Zinchenko  Arsenal → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0142', 'Oleksandr Zinchenko: Arsenal → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0142');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0142'),
    (SELECT player_id FROM player WHERE name = 'Oleksandr Zinchenko'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Oleksandr Zinchenko') IS NOT NULL;

-- [143] Chinaza Nwosu  West Ham United → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0143', 'Chinaza Nwosu: West Ham United → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0143');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0143'),
    (SELECT player_id FROM player WHERE name = 'Chinaza Nwosu'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Chinaza Nwosu') IS NOT NULL;

-- [144] Enzo Le Fee  Roma → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0144', 'Enzo Le Fee: Roma → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0144');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0144'),
    (SELECT player_id FROM player WHERE name = 'Enzo Le Fee'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Roma')),(SELECT club_id FROM club WHERE name = 'Roma')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Enzo Le Fee') IS NOT NULL;

-- [145] Habib Diarra  Strasbourg → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0145', 'Habib Diarra: Strasbourg → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0145');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0145'),
    (SELECT player_id FROM player WHERE name = 'Habib Diarra'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Strasbourg')),(SELECT club_id FROM club WHERE name = 'Strasbourg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Habib Diarra') IS NOT NULL;

-- [146] Noah Sadiki  Union Saint-Gilloise → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0146', 'Noah Sadiki: Union Saint-Gilloise → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0146');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0146'),
    (SELECT player_id FROM player WHERE name = 'Noah Sadiki'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Union Saint-Gilloise')),(SELECT club_id FROM club WHERE name = 'Union Saint-Gilloise')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Noah Sadiki') IS NOT NULL;

-- [147] Reinildo Mandava  Atletico Madrid → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0147', 'Reinildo Mandava: Atletico Madrid → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0147');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0147'),
    (SELECT player_id FROM player WHERE name = 'Reinildo Mandava'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Atletico Madrid')),(SELECT club_id FROM club WHERE name = 'Atletico Madrid')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Reinildo Mandava') IS NOT NULL;

-- [148] Chemsdine Talbi  Club Brugge → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0148', 'Chemsdine Talbi: Club Brugge → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0148');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0148'),
    (SELECT player_id FROM player WHERE name = 'Chemsdine Talbi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Club Brugge')),(SELECT club_id FROM club WHERE name = 'Club Brugge')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Chemsdine Talbi') IS NOT NULL;

-- [149] Simon Adingra  Brighton → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0149', 'Simon Adingra: Brighton → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0149');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0149'),
    (SELECT player_id FROM player WHERE name = 'Simon Adingra'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton')),(SELECT club_id FROM club WHERE name = 'Brighton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Simon Adingra') IS NOT NULL;

-- [150] Granit Xhaka  Bayer Leverkusen → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0150', 'Granit Xhaka: Bayer Leverkusen → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0150');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0150'),
    (SELECT player_id FROM player WHERE name = 'Granit Xhaka'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayer Leverkusen')),(SELECT club_id FROM club WHERE name = 'Bayer Leverkusen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Granit Xhaka') IS NOT NULL;

-- [151] Robin Roefs  NEC Nijmegen → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0151', 'Robin Roefs: NEC Nijmegen → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0151');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0151'),
    (SELECT player_id FROM player WHERE name = 'Robin Roefs'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('NEC Nijmegen')),(SELECT club_id FROM club WHERE name = 'NEC Nijmegen')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Robin Roefs') IS NOT NULL;

-- [152] Marc Guiu  Chelsea → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0152', 'Marc Guiu: Chelsea → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0152');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0152'),
    (SELECT player_id FROM player WHERE name = 'Marc Guiu'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marc Guiu') IS NOT NULL;

-- [153] Arthur Masuaku  Besiktas → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0153', 'Arthur Masuaku: Besiktas → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0153');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0153'),
    (SELECT player_id FROM player WHERE name = 'Arthur Masuaku'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Besiktas')),(SELECT club_id FROM club WHERE name = 'Besiktas')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Arthur Masuaku') IS NOT NULL;

-- [154] Omar Alderete  Getafe → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0154', 'Omar Alderete: Getafe → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0154');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0154'),
    (SELECT player_id FROM player WHERE name = 'Omar Alderete'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Getafe')),(SELECT club_id FROM club WHERE name = 'Getafe')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Omar Alderete') IS NOT NULL;

-- [155] Nordi Mukiele  Paris Saint-Germain → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0155', 'Nordi Mukiele: Paris Saint-Germain → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0155');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0155'),
    (SELECT player_id FROM player WHERE name = 'Nordi Mukiele'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Paris Saint-Germain')),(SELECT club_id FROM club WHERE name = 'Paris Saint-Germain')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Nordi Mukiele') IS NOT NULL;

-- [156] Lutsharel Geertruida  RB Leipzig → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0156', 'Lutsharel Geertruida: RB Leipzig → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0156');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0156'),
    (SELECT player_id FROM player WHERE name = 'Lutsharel Geertruida'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('RB Leipzig')),(SELECT club_id FROM club WHERE name = 'RB Leipzig')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lutsharel Geertruida') IS NOT NULL;

-- [157] Brian Brobbey  Ajax → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0157', 'Brian Brobbey: Ajax → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0157');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0157'),
    (SELECT player_id FROM player WHERE name = 'Brian Brobbey'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Brian Brobbey') IS NOT NULL;

-- [158] Bertrand Traore  Ajax → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0158', 'Bertrand Traore: Ajax → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0158');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0158'),
    (SELECT player_id FROM player WHERE name = 'Bertrand Traore'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Bertrand Traore') IS NOT NULL;

-- [159] Luka Vuskovic  Hajduk Split → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0159', 'Luka Vuskovic: Hajduk Split → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0159');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0159'),
    (SELECT player_id FROM player WHERE name = 'Luka Vuskovic'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Hajduk Split')),(SELECT club_id FROM club WHERE name = 'Hajduk Split')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Luka Vuskovic') IS NOT NULL;

-- [160] Kevin Danso  Lens → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0160', 'Kevin Danso: Lens → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0160');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0160'),
    (SELECT player_id FROM player WHERE name = 'Kevin Danso'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lens')),(SELECT club_id FROM club WHERE name = 'Lens')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kevin Danso') IS NOT NULL;

-- [161] Mathys Tel  Bayern Munich → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0161', 'Mathys Tel: Bayern Munich → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0161');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0161'),
    (SELECT player_id FROM player WHERE name = 'Mathys Tel'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayern Munich')),(SELECT club_id FROM club WHERE name = 'Bayern Munich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mathys Tel') IS NOT NULL;

-- [162] Max McFadden  Leeds → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0162', 'Max McFadden: Leeds → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0162');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0162'),
    (SELECT player_id FROM player WHERE name = 'Max McFadden'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds')),(SELECT club_id FROM club WHERE name = 'Leeds')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Max McFadden') IS NOT NULL;

-- [163] Kota Takai  Kawasaki Frontale → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0163', 'Kota Takai: Kawasaki Frontale → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0163');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0163'),
    (SELECT player_id FROM player WHERE name = 'Kota Takai'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Kawasaki Frontale')),(SELECT club_id FROM club WHERE name = 'Kawasaki Frontale')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kota Takai') IS NOT NULL;

-- [164] Mohammed Kudus  West Ham → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0164', 'Mohammed Kudus: West Ham → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0164');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0164'),
    (SELECT player_id FROM player WHERE name = 'Mohammed Kudus'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham')),(SELECT club_id FROM club WHERE name = 'West Ham')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mohammed Kudus') IS NOT NULL;

-- [165] Joao Palhinha  Bayern Munich → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0165', 'Joao Palhinha: Bayern Munich → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0165');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0165'),
    (SELECT player_id FROM player WHERE name = 'Joao Palhinha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bayern Munich')),(SELECT club_id FROM club WHERE name = 'Bayern Munich')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Joao Palhinha') IS NOT NULL;

-- [166] Xavi Simons  Leipzig → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0166', 'Xavi Simons: Leipzig → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0166');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0166'),
    (SELECT player_id FROM player WHERE name = 'Xavi Simons'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leipzig')),(SELECT club_id FROM club WHERE name = 'Leipzig')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Xavi Simons') IS NOT NULL;

-- [167] Randal Kolo Muani  Paris Saint-Germain → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0167', 'Randal Kolo Muani: Paris Saint-Germain → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0167');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0167'),
    (SELECT player_id FROM player WHERE name = 'Randal Kolo Muani'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Paris Saint-Germain')),(SELECT club_id FROM club WHERE name = 'Paris Saint-Germain')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Randal Kolo Muani') IS NOT NULL;

-- [168] Jean-Clair Todibo  OGC Nice → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0168', 'Jean-Clair Todibo: OGC Nice → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0168');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0168'),
    (SELECT player_id FROM player WHERE name = 'Jean-Clair Todibo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('OGC Nice')),(SELECT club_id FROM club WHERE name = 'OGC Nice')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jean-Clair Todibo') IS NOT NULL;

-- [169] Daniel Cummings  Celtic → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0169', 'Daniel Cummings: Celtic → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0169');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0169'),
    (SELECT player_id FROM player WHERE name = 'Daniel Cummings'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Celtic')),(SELECT club_id FROM club WHERE name = 'Celtic')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Daniel Cummings') IS NOT NULL;

-- [170] El Hadji Malick Diouf  Slavia Prague → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0170', 'El Hadji Malick Diouf: Slavia Prague → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0170');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0170'),
    (SELECT player_id FROM player WHERE name = 'El Hadji Malick Diouf'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Slavia Prague')),(SELECT club_id FROM club WHERE name = 'Slavia Prague')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'El Hadji Malick Diouf') IS NOT NULL;

-- [171] Kyle Walker-Peters  Southampton → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0171', 'Kyle Walker-Peters: Southampton → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0171');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0171'),
    (SELECT player_id FROM player WHERE name = 'Kyle Walker-Peters'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Southampton')),(SELECT club_id FROM club WHERE name = 'Southampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kyle Walker-Peters') IS NOT NULL;

-- [172] Callum Wilson  Newcastle → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0172', 'Callum Wilson: Newcastle → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0172');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0172'),
    (SELECT player_id FROM player WHERE name = 'Callum Wilson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newcastle')),(SELECT club_id FROM club WHERE name = 'Newcastle')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Callum Wilson') IS NOT NULL;

-- [173] Mads Hermansen  Leicester → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0173', 'Mads Hermansen: Leicester → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0173');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0173'),
    (SELECT player_id FROM player WHERE name = 'Mads Hermansen'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leicester')),(SELECT club_id FROM club WHERE name = 'Leicester')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mads Hermansen') IS NOT NULL;

-- [174] Mateus Fernandes  Southampton → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0174', 'Mateus Fernandes: Southampton → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0174');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0174'),
    (SELECT player_id FROM player WHERE name = 'Mateus Fernandes'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Southampton')),(SELECT club_id FROM club WHERE name = 'Southampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mateus Fernandes') IS NOT NULL;

-- [175] Soungoutou Magassa  AS Monaco → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0175', 'Soungoutou Magassa: AS Monaco → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0175');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0175'),
    (SELECT player_id FROM player WHERE name = 'Soungoutou Magassa'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AS Monaco')),(SELECT club_id FROM club WHERE name = 'AS Monaco')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Soungoutou Magassa') IS NOT NULL;

-- [176] Igor Julio  Brighton → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0176', 'Igor Julio: Brighton → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0176');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0176'),
    (SELECT player_id FROM player WHERE name = 'Igor Julio'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton')),(SELECT club_id FROM club WHERE name = 'Brighton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Igor Julio') IS NOT NULL;

-- [177] Lukasz Fabianski  - → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0177', 'Lukasz Fabianski: - → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0177');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0177'),
    (SELECT player_id FROM player WHERE name = 'Lukasz Fabianski'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('-')),(SELECT club_id FROM club WHERE name = '-')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lukasz Fabianski') IS NOT NULL;

-- [178] Hugo Bueno  Feyenoord → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0178', 'Hugo Bueno: Feyenoord → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0178');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0178'),
    (SELECT player_id FROM player WHERE name = 'Hugo Bueno'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Feyenoord')),(SELECT club_id FROM club WHERE name = 'Feyenoord')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Hugo Bueno') IS NOT NULL;

-- [179] Fer Lopez  Celta Vigo → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0179', 'Fer Lopez: Celta Vigo → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0179');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0179'),
    (SELECT player_id FROM player WHERE name = 'Fer Lopez'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Celta Vigo')),(SELECT club_id FROM club WHERE name = 'Celta Vigo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Fer Lopez') IS NOT NULL;

-- [180] Jorgen Strand Larsen  Celta Vigo → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0180', 'Jorgen Strand Larsen: Celta Vigo → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0180');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0180'),
    (SELECT player_id FROM player WHERE name = 'Jorgen Strand Larsen'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Celta Vigo')),(SELECT club_id FROM club WHERE name = 'Celta Vigo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jorgen Strand Larsen') IS NOT NULL;

-- [181] Jhon Arias  Fluminense → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0181', 'Jhon Arias: Fluminense → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0181');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0181'),
    (SELECT player_id FROM player WHERE name = 'Jhon Arias'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fluminense')),(SELECT club_id FROM club WHERE name = 'Fluminense')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jhon Arias') IS NOT NULL;

-- [182] David Moller Wolfe  AZ Alkmaar → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0182', 'David Moller Wolfe: AZ Alkmaar → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0182');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0182'),
    (SELECT player_id FROM player WHERE name = 'David Moller Wolfe'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AZ Alkmaar')),(SELECT club_id FROM club WHERE name = 'AZ Alkmaar')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'David Moller Wolfe') IS NOT NULL;

-- [183] Jackson Tchatchoua  Verona → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0183', 'Jackson Tchatchoua: Verona → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0183');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0183'),
    (SELECT player_id FROM player WHERE name = 'Jackson Tchatchoua'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Verona')),(SELECT club_id FROM club WHERE name = 'Verona')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jackson Tchatchoua') IS NOT NULL;

-- [184] Ladislav Krejci  Girona → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0184', 'Ladislav Krejci: Girona → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0184');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0184'),
    (SELECT player_id FROM player WHERE name = 'Ladislav Krejci'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Girona')),(SELECT club_id FROM club WHERE name = 'Girona')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Ladislav Krejci') IS NOT NULL;

-- [185] Tolu Arokodare  Genk → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_SUMMER_0185', 'Tolu Arokodare: Genk → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0185');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_SUMMER_0185'),
    (SELECT player_id FROM player WHERE name = 'Tolu Arokodare'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Genk')),(SELECT club_id FROM club WHERE name = 'Genk')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'SUMMER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tolu Arokodare') IS NOT NULL;

-- ═══════════════════════════════════════════════════════════
--  WINTER — 79건
-- ═══════════════════════════════════════════════════════════

-- [1] Jaden Dixon  Stoke City → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0001', 'Jaden Dixon: Stoke City → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0001');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0001'),
    (SELECT player_id FROM player WHERE name = 'Jaden Dixon'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Stoke City')),(SELECT club_id FROM club WHERE name = 'Stoke City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jaden Dixon') IS NOT NULL;

-- [2] Evan Mooney  St Mirren → Arsenal
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0002', 'Evan Mooney: St Mirren → Arsenal [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0002');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0002'),
    (SELECT player_id FROM player WHERE name = 'Evan Mooney'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('St Mirren')),(SELECT club_id FROM club WHERE name = 'St Mirren')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Arsenal')),(SELECT club_id FROM club WHERE name = 'Arsenal')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Evan Mooney') IS NOT NULL;

-- [3] Douglas Luiz  Juventus → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0003', 'Douglas Luiz: Juventus → Aston Villa [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0003');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0003'),
    (SELECT player_id FROM player WHERE name = 'Douglas Luiz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Juventus')),(SELECT club_id FROM club WHERE name = 'Juventus')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Douglas Luiz') IS NOT NULL;

-- [4] Tammy Abraham  Besiktas → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0004', 'Tammy Abraham: Besiktas → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0004');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0004'),
    (SELECT player_id FROM player WHERE name = 'Tammy Abraham'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Besiktas')),(SELECT club_id FROM club WHERE name = 'Besiktas')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tammy Abraham') IS NOT NULL;

-- [5] Alysson  Gremio → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0005', 'Alysson: Gremio → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0005');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0005'),
    (SELECT player_id FROM player WHERE name = 'Alysson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Gremio')),(SELECT club_id FROM club WHERE name = 'Gremio')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Alysson') IS NOT NULL;

-- [6] Leon Bailey  Roma → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0006', 'Leon Bailey: Roma → Aston Villa [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0006');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0006'),
    (SELECT player_id FROM player WHERE name = 'Leon Bailey'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Roma')),(SELECT club_id FROM club WHERE name = 'Roma')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Leon Bailey') IS NOT NULL;

-- [7] Brian Madjo  Metz → Aston Villa
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0007', 'Brian Madjo: Metz → Aston Villa [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0007');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0007'),
    (SELECT player_id FROM player WHERE name = 'Brian Madjo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Metz')),(SELECT club_id FROM club WHERE name = 'Metz')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Brian Madjo') IS NOT NULL;

-- [8] Rayan  Vasco → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0008', 'Rayan: Vasco → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0008');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0008'),
    (SELECT player_id FROM player WHERE name = 'Rayan'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Vasco')),(SELECT club_id FROM club WHERE name = 'Vasco')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Rayan') IS NOT NULL;

-- [9] Christos Mandas  Lazio → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0009', 'Christos Mandas: Lazio → AFC Bournemouth [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0009');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0009'),
    (SELECT player_id FROM player WHERE name = 'Christos Mandas'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lazio')),(SELECT club_id FROM club WHERE name = 'Lazio')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Christos Mandas') IS NOT NULL;

-- [10] Alex Toth  Ferencvaros → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0010', 'Alex Toth: Ferencvaros → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0010');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0010'),
    (SELECT player_id FROM player WHERE name = 'Alex Toth'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ferencvaros')),(SELECT club_id FROM club WHERE name = 'Ferencvaros')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Alex Toth') IS NOT NULL;

-- [11] Ade Solanke  Lorient → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0011', 'Ade Solanke: Lorient → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0011');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0011'),
    (SELECT player_id FROM player WHERE name = 'Ade Solanke'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lorient')),(SELECT club_id FROM club WHERE name = 'Lorient')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Ade Solanke') IS NOT NULL;

-- [12] Fraser Forster  FA → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0012', 'Fraser Forster: FA → AFC Bournemouth [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0012');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0012'),
    (SELECT player_id FROM player WHERE name = 'Fraser Forster'),
    NULL,
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Fraser Forster') IS NOT NULL;

-- [13] Noa Boutin  Sutton → AFC Bournemouth
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0013', 'Noa Boutin: Sutton → AFC Bournemouth [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0013');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0013'),
    (SELECT player_id FROM player WHERE name = 'Noa Boutin'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sutton')),(SELECT club_id FROM club WHERE name = 'Sutton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('AFC Bournemouth')),(SELECT club_id FROM club WHERE name = 'AFC Bournemouth')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Noa Boutin') IS NOT NULL;

-- [14] Kaye Furo  Club Brugge → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0014', 'Kaye Furo: Club Brugge → Brentford [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0014');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0014'),
    (SELECT player_id FROM player WHERE name = 'Kaye Furo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Club Brugge')),(SELECT club_id FROM club WHERE name = 'Club Brugge')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kaye Furo') IS NOT NULL;

-- [15] Joseph Wheeler-Henry  Chelsea → Brentford
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0015', 'Joseph Wheeler-Henry: Chelsea → Brentford [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0015');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0015'),
    (SELECT player_id FROM player WHERE name = 'Joseph Wheeler-Henry'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brentford')),(SELECT club_id FROM club WHERE name = 'Brentford')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Joseph Wheeler-Henry') IS NOT NULL;

-- [16] Pascal Gross  Dortmund → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0016', 'Pascal Gross: Dortmund → Brighton & Hove Albion [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0016');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0016'),
    (SELECT player_id FROM player WHERE name = 'Pascal Gross'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Dortmund')),(SELECT club_id FROM club WHERE name = 'Dortmund')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Pascal Gross') IS NOT NULL;

-- [17] Matt O'Riley  Marseille → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0017', 'Matt O''Riley: Marseille → Brighton & Hove Albion [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0017');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0017'),
    (SELECT player_id FROM player WHERE name = 'Matt O''Riley'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Marseille')),(SELECT club_id FROM club WHERE name = 'Marseille')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Matt O''Riley') IS NOT NULL;

-- [18] Igor Julio  West Ham → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0018', 'Igor Julio: West Ham → Brighton & Hove Albion [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0018');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0018'),
    (SELECT player_id FROM player WHERE name = 'Igor Julio'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham')),(SELECT club_id FROM club WHERE name = 'West Ham')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Igor Julio') IS NOT NULL;

-- [19] Caylan Vickers  Barnsley → Brighton & Hove Albion
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0019', 'Caylan Vickers: Barnsley → Brighton & Hove Albion [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0019');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0019'),
    (SELECT player_id FROM player WHERE name = 'Caylan Vickers'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Barnsley')),(SELECT club_id FROM club WHERE name = 'Barnsley')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton & Hove Albion')),(SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Caylan Vickers') IS NOT NULL;

-- [20] James Ward-Prowse  West Ham → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0020', 'James Ward-Prowse: West Ham → Burnley [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0020');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0020'),
    (SELECT player_id FROM player WHERE name = 'James Ward-Prowse'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham')),(SELECT club_id FROM club WHERE name = 'West Ham')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James Ward-Prowse') IS NOT NULL;

-- [21] Sam Waller  Crewe → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0021', 'Sam Waller: Crewe → Burnley [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0021');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0021'),
    (SELECT player_id FROM player WHERE name = 'Sam Waller'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crewe')),(SELECT club_id FROM club WHERE name = 'Crewe')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sam Waller') IS NOT NULL;

-- [22] Charlie Casper  Grimsby → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0022', 'Charlie Casper: Grimsby → Burnley [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0022');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0022'),
    (SELECT player_id FROM player WHERE name = 'Charlie Casper'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Grimsby')),(SELECT club_id FROM club WHERE name = 'Grimsby')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Charlie Casper') IS NOT NULL;

-- [23] Cameron Scott  FA → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0023', 'Cameron Scott: FA → Burnley [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0023');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0023'),
    (SELECT player_id FROM player WHERE name = 'Cameron Scott'),
    NULL,
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Cameron Scott') IS NOT NULL;

-- [24] Joe Bauress  Accrington → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0024', 'Joe Bauress: Accrington → Burnley [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0024');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0024'),
    (SELECT player_id FROM player WHERE name = 'Joe Bauress'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Accrington')),(SELECT club_id FROM club WHERE name = 'Accrington')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Joe Bauress') IS NOT NULL;

-- [25] Logan Pye  Accrington → Burnley
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0025', 'Logan Pye: Accrington → Burnley [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0025');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0025'),
    (SELECT player_id FROM player WHERE name = 'Logan Pye'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Accrington')),(SELECT club_id FROM club WHERE name = 'Accrington')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Burnley')),(SELECT club_id FROM club WHERE name = 'Burnley')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Logan Pye') IS NOT NULL;

-- [26] Mamadou Sarr  Strasbourg → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0026', 'Mamadou Sarr: Strasbourg → Chelsea [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0026');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0026'),
    (SELECT player_id FROM player WHERE name = 'Mamadou Sarr'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Strasbourg')),(SELECT club_id FROM club WHERE name = 'Strasbourg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mamadou Sarr') IS NOT NULL;

-- [27] Yisa Alao  Sheff Wed → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0027', 'Yisa Alao: Sheff Wed → Chelsea [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0027');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0027'),
    (SELECT player_id FROM player WHERE name = 'Yisa Alao'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sheff Wed')),(SELECT club_id FROM club WHERE name = 'Sheff Wed')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Yisa Alao') IS NOT NULL;

-- [28] Caleb Wiley  Watford → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0028', 'Caleb Wiley: Watford → Chelsea [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0028');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0028'),
    (SELECT player_id FROM player WHERE name = 'Caleb Wiley'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Watford')),(SELECT club_id FROM club WHERE name = 'Watford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Caleb Wiley') IS NOT NULL;

-- [29] Kiano Dyer  Volendam → Chelsea
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0029', 'Kiano Dyer: Volendam → Chelsea [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0029');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0029'),
    (SELECT player_id FROM player WHERE name = 'Kiano Dyer'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Volendam')),(SELECT club_id FROM club WHERE name = 'Volendam')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kiano Dyer') IS NOT NULL;

-- [30] Jorgen Strand Larsen  Wolves → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0030', 'Jorgen Strand Larsen: Wolves → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0030');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0030'),
    (SELECT player_id FROM player WHERE name = 'Jorgen Strand Larsen'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jorgen Strand Larsen') IS NOT NULL;

-- [31] Brennan Johnson  Spurs → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0031', 'Brennan Johnson: Spurs → Crystal Palace [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0031');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0031'),
    (SELECT player_id FROM player WHERE name = 'Brennan Johnson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Spurs')),(SELECT club_id FROM club WHERE name = 'Spurs')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Brennan Johnson') IS NOT NULL;

-- [32] Evann Guessand  Aston Villa → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0032', 'Evann Guessand: Aston Villa → Crystal Palace [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0032');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0032'),
    (SELECT player_id FROM player WHERE name = 'Evann Guessand'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Aston Villa')),(SELECT club_id FROM club WHERE name = 'Aston Villa')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Evann Guessand') IS NOT NULL;

-- [33] Hindolo Mustapha  Nurnberg → Crystal Palace
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0033', 'Hindolo Mustapha: Nurnberg → Crystal Palace [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0033');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0033'),
    (SELECT player_id FROM player WHERE name = 'Hindolo Mustapha'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nurnberg')),(SELECT club_id FROM club WHERE name = 'Nurnberg')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Hindolo Mustapha') IS NOT NULL;

-- [34] Tyrique George  Chelsea → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0034', 'Tyrique George: Chelsea → Everton [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0034');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0034'),
    (SELECT player_id FROM player WHERE name = 'Tyrique George'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tyrique George') IS NOT NULL;

-- [35] Martin Sherif  Rotherham → Everton
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0035', 'Martin Sherif: Rotherham → Everton [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0035');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0035'),
    (SELECT player_id FROM player WHERE name = 'Martin Sherif'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rotherham')),(SELECT club_id FROM club WHERE name = 'Rotherham')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Everton')),(SELECT club_id FROM club WHERE name = 'Everton')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Martin Sherif') IS NOT NULL;

-- [36] Oscar Bobb  Man City → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0036', 'Oscar Bobb: Man City → Fulham [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0036');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0036'),
    (SELECT player_id FROM player WHERE name = 'Oscar Bobb'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Man City')),(SELECT club_id FROM club WHERE name = 'Man City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Oscar Bobb') IS NOT NULL;

-- [37] Steven Benda  Millwall → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0037', 'Steven Benda: Millwall → Fulham [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0037');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0037'),
    (SELECT player_id FROM player WHERE name = 'Steven Benda'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Millwall')),(SELECT club_id FROM club WHERE name = 'Millwall')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Steven Benda') IS NOT NULL;

-- [38] Luke Harris  Oxford → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0038', 'Luke Harris: Oxford → Fulham [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0038');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0038'),
    (SELECT player_id FROM player WHERE name = 'Luke Harris'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Oxford')),(SELECT club_id FROM club WHERE name = 'Oxford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Luke Harris') IS NOT NULL;

-- [39] Matt Dibley-Dias  Chesterfield → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0039', 'Matt Dibley-Dias: Chesterfield → Fulham [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0039');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0039'),
    (SELECT player_id FROM player WHERE name = 'Matt Dibley-Dias'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chesterfield')),(SELECT club_id FROM club WHERE name = 'Chesterfield')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Matt Dibley-Dias') IS NOT NULL;

-- [40] Devan Tanton  Chesterfield → Fulham
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0040', 'Devan Tanton: Chesterfield → Fulham [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0040');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0040'),
    (SELECT player_id FROM player WHERE name = 'Devan Tanton'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chesterfield')),(SELECT club_id FROM club WHERE name = 'Chesterfield')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Devan Tanton') IS NOT NULL;

-- [41] Facundo Buonanotte  Brighton → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0041', 'Facundo Buonanotte: Brighton → Leeds United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0041');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0041'),
    (SELECT player_id FROM player WHERE name = 'Facundo Buonanotte'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Brighton')),(SELECT club_id FROM club WHERE name = 'Brighton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Facundo Buonanotte') IS NOT NULL;

-- [42] Edward Ibrovic-Fletcher  Man Utd → Leeds United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0042', 'Edward Ibrovic-Fletcher: Man Utd → Leeds United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0042');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0042'),
    (SELECT player_id FROM player WHERE name = 'Edward Ibrovic-Fletcher'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Man Utd')),(SELECT club_id FROM club WHERE name = 'Man Utd')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leeds United')),(SELECT club_id FROM club WHERE name = 'Leeds United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Edward Ibrovic-Fletcher') IS NOT NULL;

-- [43] Jeremy Jacquet  Rennes → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0043', 'Jeremy Jacquet: Rennes → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0043');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0043'),
    (SELECT player_id FROM player WHERE name = 'Jeremy Jacquet'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Rennes')),(SELECT club_id FROM club WHERE name = 'Rennes')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jeremy Jacquet') IS NOT NULL;

-- [44] Mor Talla Ndiaye  Amitie → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0044', 'Mor Talla Ndiaye: Amitie → Liverpool [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0044');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0044'),
    (SELECT player_id FROM player WHERE name = 'Mor Talla Ndiaye'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Amitie')),(SELECT club_id FROM club WHERE name = 'Amitie')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Mor Talla Ndiaye') IS NOT NULL;

-- [45] Owen Beck  Derby County → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0045', 'Owen Beck: Derby County → Liverpool [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0045');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0045'),
    (SELECT player_id FROM player WHERE name = 'Owen Beck'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Derby County')),(SELECT club_id FROM club WHERE name = 'Derby County')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Owen Beck') IS NOT NULL;

-- [46] Harvey Davies  Crawley Town → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0046', 'Harvey Davies: Crawley Town → Liverpool [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0046');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0046'),
    (SELECT player_id FROM player WHERE name = 'Harvey Davies'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crawley Town')),(SELECT club_id FROM club WHERE name = 'Crawley Town')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Harvey Davies') IS NOT NULL;

-- [47] James McConnell  Ajax → Liverpool
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0047', 'James McConnell: Ajax → Liverpool [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0047');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0047'),
    (SELECT player_id FROM player WHERE name = 'James McConnell'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Ajax')),(SELECT club_id FROM club WHERE name = 'Ajax')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Liverpool')),(SELECT club_id FROM club WHERE name = 'Liverpool')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James McConnell') IS NOT NULL;

-- [48] Marc Guehi  Crystal Palace → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0048', 'Marc Guehi: Crystal Palace → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0048');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0048'),
    (SELECT player_id FROM player WHERE name = 'Marc Guehi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Crystal Palace')),(SELECT club_id FROM club WHERE name = 'Crystal Palace')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Marc Guehi') IS NOT NULL;

-- [49] Antoine Semenyo  Bournemouth → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0049', 'Antoine Semenyo: Bournemouth → Manchester City [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0049');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0049'),
    (SELECT player_id FROM player WHERE name = 'Antoine Semenyo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bournemouth')),(SELECT club_id FROM club WHERE name = 'Bournemouth')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Antoine Semenyo') IS NOT NULL;

-- [50] Sverre Nypan  Middlesborough → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0050', 'Sverre Nypan: Middlesborough → Manchester City [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0050');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0050'),
    (SELECT player_id FROM player WHERE name = 'Sverre Nypan'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Middlesborough')),(SELECT club_id FROM club WHERE name = 'Middlesborough')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sverre Nypan') IS NOT NULL;

-- [51] Max Alleyne  Watford → Manchester City
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0051', 'Max Alleyne: Watford → Manchester City [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0051');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0051'),
    (SELECT player_id FROM player WHERE name = 'Max Alleyne'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Watford')),(SELECT club_id FROM club WHERE name = 'Watford')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester City')),(SELECT club_id FROM club WHERE name = 'Manchester City')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Max Alleyne') IS NOT NULL;

-- [52] Elyh Harrison  Shrewsbury → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0052', 'Elyh Harrison: Shrewsbury → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0052');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0052'),
    (SELECT player_id FROM player WHERE name = 'Elyh Harrison'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Shrewsbury')),(SELECT club_id FROM club WHERE name = 'Shrewsbury')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Elyh Harrison') IS NOT NULL;

-- [53] Habeeb Ogunneye  Newport → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0053', 'Habeeb Ogunneye: Newport → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0053');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0053'),
    (SELECT player_id FROM player WHERE name = 'Habeeb Ogunneye'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Newport')),(SELECT club_id FROM club WHERE name = 'Newport')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Habeeb Ogunneye') IS NOT NULL;

-- [54] Ethan Wheatley  Northampton → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0054', 'Ethan Wheatley: Northampton → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0054');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0054'),
    (SELECT player_id FROM player WHERE name = 'Ethan Wheatley'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Northampton')),(SELECT club_id FROM club WHERE name = 'Northampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Ethan Wheatley') IS NOT NULL;

-- [55] Louis Jackson  Solihull → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0055', 'Louis Jackson: Solihull → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0055');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0055'),
    (SELECT player_id FROM player WHERE name = 'Louis Jackson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Solihull')),(SELECT club_id FROM club WHERE name = 'Solihull')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Louis Jackson') IS NOT NULL;

-- [56] Sonny Aljofree  Notts County → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0056', 'Sonny Aljofree: Notts County → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0056');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0056'),
    (SELECT player_id FROM player WHERE name = 'Sonny Aljofree'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Notts County')),(SELECT club_id FROM club WHERE name = 'Notts County')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Sonny Aljofree') IS NOT NULL;

-- [57] Jack Moorhouse  Leyton Orient → Manchester United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0057', 'Jack Moorhouse: Leyton Orient → Manchester United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0057');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0057'),
    (SELECT player_id FROM player WHERE name = 'Jack Moorhouse'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Leyton Orient')),(SELECT club_id FROM club WHERE name = 'Leyton Orient')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Manchester United')),(SELECT club_id FROM club WHERE name = 'Manchester United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jack Moorhouse') IS NOT NULL;

-- [58] Stefan Ortega  Man City → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0058', 'Stefan Ortega: Man City → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0058');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0058'),
    (SELECT player_id FROM player WHERE name = 'Stefan Ortega'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Man City')),(SELECT club_id FROM club WHERE name = 'Man City')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Stefan Ortega') IS NOT NULL;

-- [59] Lorenzo Lucca  Napoli → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0059', 'Lorenzo Lucca: Napoli → Nottingham Forest [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0059');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0059'),
    (SELECT player_id FROM player WHERE name = 'Lorenzo Lucca'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Napoli')),(SELECT club_id FROM club WHERE name = 'Napoli')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Lorenzo Lucca') IS NOT NULL;

-- [60] Luca Netz  B. M’gladbach → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0060', 'Luca Netz: B. M’gladbach → Nottingham Forest [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0060');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0060'),
    (SELECT player_id FROM player WHERE name = 'Luca Netz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('B. M’gladbach')),(SELECT club_id FROM club WHERE name = 'B. M’gladbach')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Luca Netz') IS NOT NULL;

-- [61] Douglas Luiz  Juventus → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0061', 'Douglas Luiz: Juventus → Nottingham Forest [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0061');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0061'),
    (SELECT player_id FROM player WHERE name = 'Douglas Luiz'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Juventus')),(SELECT club_id FROM club WHERE name = 'Juventus')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Douglas Luiz') IS NOT NULL;

-- [62] Kyle McAdam  Mansfield → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0062', 'Kyle McAdam: Mansfield → Nottingham Forest [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0062');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0062'),
    (SELECT player_id FROM player WHERE name = 'Kyle McAdam'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Mansfield')),(SELECT club_id FROM club WHERE name = 'Mansfield')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Kyle McAdam') IS NOT NULL;

-- [63] Esapa Osong  Motherwell → Nottingham Forest
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0063', 'Esapa Osong: Motherwell → Nottingham Forest [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0063');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0063'),
    (SELECT player_id FROM player WHERE name = 'Esapa Osong'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Motherwell')),(SELECT club_id FROM club WHERE name = 'Motherwell')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Nottingham Forest')),(SELECT club_id FROM club WHERE name = 'Nottingham Forest')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Esapa Osong') IS NOT NULL;

-- [64] Melker Ellborg  Malmo → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0064', 'Melker Ellborg: Malmo → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0064');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0064'),
    (SELECT player_id FROM player WHERE name = 'Melker Ellborg'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Malmo')),(SELECT club_id FROM club WHERE name = 'Malmo')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Melker Ellborg') IS NOT NULL;

-- [65] Nilson Angulo  Anderlecht → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0065', 'Nilson Angulo: Anderlecht → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0065');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0065'),
    (SELECT player_id FROM player WHERE name = 'Nilson Angulo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Anderlecht')),(SELECT club_id FROM club WHERE name = 'Anderlecht')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Nilson Angulo') IS NOT NULL;

-- [66] Jocelin Ta Bi  Maccabi Netanya → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0066', 'Jocelin Ta Bi: Maccabi Netanya → Sunderland [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0066');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0066'),
    (SELECT player_id FROM player WHERE name = 'Jocelin Ta Bi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Maccabi Netanya')),(SELECT club_id FROM club WHERE name = 'Maccabi Netanya')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Jocelin Ta Bi') IS NOT NULL;

-- [67] Tom Lavery  Cliftonville → Sunderland
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0067', 'Tom Lavery: Cliftonville → Sunderland [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0067');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0067'),
    (SELECT player_id FROM player WHERE name = 'Tom Lavery'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Cliftonville')),(SELECT club_id FROM club WHERE name = 'Cliftonville')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Sunderland')),(SELECT club_id FROM club WHERE name = 'Sunderland')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Tom Lavery') IS NOT NULL;

-- [68] Conor Gallagher  A. Madrid → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0068', 'Conor Gallagher: A. Madrid → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0068');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0068'),
    (SELECT player_id FROM player WHERE name = 'Conor Gallagher'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('A. Madrid')),(SELECT club_id FROM club WHERE name = 'A. Madrid')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Conor Gallagher') IS NOT NULL;

-- [69] Souza  Santos → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0069', 'Souza: Santos → Tottenham Hotspur [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0069');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0069'),
    (SELECT player_id FROM player WHERE name = 'Souza'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Santos')),(SELECT club_id FROM club WHERE name = 'Santos')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Souza') IS NOT NULL;

-- [70] James Wilson  Hearts → Tottenham Hotspur
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0070', 'James Wilson: Hearts → Tottenham Hotspur [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0070');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0070'),
    (SELECT player_id FROM player WHERE name = 'James Wilson'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Hearts')),(SELECT club_id FROM club WHERE name = 'Hearts')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Tottenham Hotspur')),(SELECT club_id FROM club WHERE name = 'Tottenham Hotspur')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'James Wilson') IS NOT NULL;

-- [71] Axel Disasi  Chelsea → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0071', 'Axel Disasi: Chelsea → West Ham United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0071');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0071'),
    (SELECT player_id FROM player WHERE name = 'Axel Disasi'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Chelsea')),(SELECT club_id FROM club WHERE name = 'Chelsea')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Axel Disasi') IS NOT NULL;

-- [72] Taty Castellanos  Lazio → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0072', 'Taty Castellanos: Lazio → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0072');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0072'),
    (SELECT player_id FROM player WHERE name = 'Taty Castellanos'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Lazio')),(SELECT club_id FROM club WHERE name = 'Lazio')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Taty Castellanos') IS NOT NULL;

-- [73] Adama Traore  Fulham → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0073', 'Adama Traore: Fulham → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0073');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0073'),
    (SELECT player_id FROM player WHERE name = 'Adama Traore'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Fulham')),(SELECT club_id FROM club WHERE name = 'Fulham')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Adama Traore') IS NOT NULL;

-- [74] Pablo Felipe  Gil Vicente → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0074', 'Pablo Felipe: Gil Vicente → West Ham United [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0074');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0074'),
    (SELECT player_id FROM player WHERE name = 'Pablo Felipe'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Gil Vicente')),(SELECT club_id FROM club WHERE name = 'Gil Vicente')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Pablo Felipe') IS NOT NULL;

-- [75] Keiber Lamadrid  La Guaira → West Ham United
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0075', 'Keiber Lamadrid: La Guaira → West Ham United [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0075');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0075'),
    (SELECT player_id FROM player WHERE name = 'Keiber Lamadrid'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('La Guaira')),(SELECT club_id FROM club WHERE name = 'La Guaira')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('West Ham United')),(SELECT club_id FROM club WHERE name = 'West Ham United')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Keiber Lamadrid') IS NOT NULL;

-- [76] Angel Gomes  Marseille → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0076', 'Angel Gomes: Marseille → Wolves [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0076');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0076'),
    (SELECT player_id FROM player WHERE name = 'Angel Gomes'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Marseille')),(SELECT club_id FROM club WHERE name = 'Marseille')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Angel Gomes') IS NOT NULL;

-- [77] Adam Armstrong  Southampton → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0077', 'Adam Armstrong: Southampton → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0077');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0077'),
    (SELECT player_id FROM player WHERE name = 'Adam Armstrong'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Southampton')),(SELECT club_id FROM club WHERE name = 'Southampton')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Adam Armstrong') IS NOT NULL;

-- [78] Pedro Lima  Porto → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0078', 'Pedro Lima: Porto → Wolves [LOAN] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0078');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0078'),
    (SELECT player_id FROM player WHERE name = 'Pedro Lima'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Porto')),(SELECT club_id FROM club WHERE name = 'Porto')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'LOAN', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Pedro Lima') IS NOT NULL;

-- [79] Dapo Anunlopo  Bromley → Wolves
INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)
SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),
    'PL_EPL_WINTER_0079', 'Dapo Anunlopo: Bromley → Wolves [CONFIRMED] #PremierLeague', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = 'PL_EPL_WINTER_0079');

INSERT INTO transfer_news
    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)
SELECT
    (SELECT post_id FROM post WHERE x_post_id = 'PL_EPL_WINTER_0079'),
    (SELECT player_id FROM player WHERE name = 'Dapo Anunlopo'),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Bromley')),(SELECT club_id FROM club WHERE name = 'Bromley')),
    COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')),
    NULL, 'CONFIRMED', 51, 'WINTER', NOW()
WHERE COALESCE((SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower('Wolves')),(SELECT club_id FROM club WHERE name = 'Wolves')) IS NOT NULL
  AND (SELECT player_id FROM player WHERE name = 'Dapo Anunlopo') IS NOT NULL;
