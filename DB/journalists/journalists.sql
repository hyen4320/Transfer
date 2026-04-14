-- ============================================================
--  JOURNALIST 초기 데이터
--  기준: 5대 리그 주요 이적 담당 기자
--  profile_image_url / follower_count / credibility_score / rank
--  → 실제 수집 전 NULL 또는 기본값 처리
-- ============================================================

INSERT INTO journalist (x_handle, name, profile_image_url, follower_count, credibility_score, rank, last_synced_at, created_at) VALUES

-- ── 전 리그 공통 ────────────────────────────────────────────
('FabrizioRomano',     'Fabrizio Romano',      NULL, NULL, NULL, NULL, NULL, NOW()),
('Plettigoal',         'Florian Plettenberg',  NULL, NULL, NULL, NULL, NULL, NOW()),
('DiMarzio',           'Gianluca Di Marzio',   NULL, NULL, NULL, NULL, NULL, NOW()),

-- ── 프리미어리그 ────────────────────────────────────────────
('David_Ornstein',     'David Ornstein',        NULL, NULL, NULL, NULL, NULL, NOW()),
('JacobsBen',          'Ben Jacobs',            NULL, NULL, NULL, NULL, NULL, NOW()),
('Matt_LawTelegraph',  'Matt Law',              NULL, NULL, NULL, NULL, NULL, NOW()),
('SamiMokbel81_DM',    'Sami Mokbel',           NULL, NULL, NULL, NULL, NULL, NOW()),
('_pauljoyce',         'Paul Joyce',            NULL, NULL, NULL, NULL, NULL, NOW()),
('sistoney67',         'Simon Stone',           NULL, NULL, NULL, NULL, NULL, NOW()),
('SkyKaveh',           'Kaveh Solhekol',        NULL, NULL, NULL, NULL, NULL, NOW()),
('SkyDharmesh',        'Dharmesh Sheth',        NULL, NULL, NULL, NULL, NULL, NOW()),

-- ── 라리가 ──────────────────────────────────────────────────
('gerardromero',       'Gerard Romero',         NULL, NULL, NULL, NULL, NULL, NOW()),
('MatteMoretto',       'Matteo Moretto',        NULL, NULL, NULL, NULL, NULL, NOW()),
('miguelangel_AS',     'Miguel Angel Diaz',     NULL, NULL, NULL, NULL, NULL, NOW()),
('EduPoloPR',          'Edu Polo',              NULL, NULL, NULL, NULL, NULL, NOW()),
('toni_juanmarti',     'Toni Juanmarti',        NULL, NULL, NULL, NULL, NULL, NOW()),
('JanAageFjortoft',    'Jan Aage Fjortoft',     NULL, NULL, NULL, NULL, NULL, NOW()),

-- ── 분데스리가 ──────────────────────────────────────────────
('cfbayern',           'Christian Falk',        NULL, NULL, NULL, NULL, NULL, NOW()),
('berger_pj',          'Patrick Berger',        NULL, NULL, NULL, NULL, NULL, NOW()),
('honigstein',         'Raphael Honigstein',    NULL, NULL, NULL, NULL, NULL, NOW()),

-- ── 세리에 A ────────────────────────────────────────────────
('NicoloSchira',       'Nicolo Schira',         NULL, NULL, NULL, NULL, NULL, NOW()),
('LucaMarchetti7',     'Luca Marchetti',        NULL, NULL, NULL, NULL, NULL, NOW()),
('marcoconterio',      'Marco Conterio',        NULL, NULL, NULL, NULL, NULL, NOW()),
('AlfredoPedulla',     'Alfredo Pedulla',       NULL, NULL, NULL, NULL, NULL, NOW()),
('RudyGaletti',        'Rudy Galetti',          NULL, NULL, NULL, NULL, NULL, NOW()),

-- ── 리그 1 ──────────────────────────────────────────────────
('mohamedbouhafsi',    'Mohamed Bouhafsi',      NULL, NULL, NULL, NULL, NULL, NOW()),
('SaberDesfa',         'Saber Desfarges',       NULL, NULL, NULL, NULL, NULL, NOW()),
('Jon_LeGossip',       'Jonathan Johnson',      NULL, NULL, NULL, NULL, NULL, NOW()),
('Tanziloic',          'Loïc Tanzi',            NULL, NULL, NULL, NULL, NULL, NOW()),
('LaurensJulien',      'Julien Laurens',        NULL, NULL, NULL, NULL, NULL, NOW());
