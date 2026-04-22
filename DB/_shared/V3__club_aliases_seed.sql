-- Club Aliases Seed — club name 서브쿼리 기반
-- 실행 전 V2__club_aliases.sql 적용 필요

-- ── Premier League ──────────────────────────────────────────
-- Manchester City
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester City'), 'Man City', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester City'), 'Man. City', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester City'), 'MCFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester City'), 'Manchester City FC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester City'), 'City', 'en', 'manual');

-- Arsenal FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Arsenal FC'), 'Arsenal', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Arsenal FC'), 'The Gunners', 'en', 'manual');

-- Chelsea FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Chelsea FC'), 'Chelsea', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Chelsea FC'), 'CFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Chelsea FC'), 'The Blues', 'en', 'manual');

-- Liverpool FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Liverpool FC'), 'Liverpool', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Liverpool FC'), 'LFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Liverpool FC'), 'The Reds', 'en', 'manual');

-- Tottenham Hotspur
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Tottenham Hotspur'), 'Tottenham', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Tottenham Hotspur'), 'Spurs', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Tottenham Hotspur'), 'THFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Tottenham Hotspur'), 'Tottenham FC', 'en', 'manual');

-- Manchester United
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester United'), 'Man United', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester United'), 'Man Utd', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester United'), 'MUFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Manchester United'), 'Manchester Utd', 'en', 'manual');

-- Newcastle United
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Newcastle United'), 'Newcastle', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Newcastle United'), 'NUFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Newcastle United'), 'The Magpies', 'en', 'manual');

-- Nottingham Forest
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Nottingham Forest'), 'Forest', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Nottingham Forest'), 'Notts Forest', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Nottingham Forest'), 'NFFC', 'en', 'manual');

-- Aston Villa
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Aston Villa'), 'Villa', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Aston Villa'), 'AVFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Aston Villa'), 'Aston Villa FC', 'en', 'manual');

-- Crystal Palace
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Crystal Palace'), 'Palace', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Crystal Palace'), 'CPFC', 'en', 'manual');

-- AFC Bournemouth
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AFC Bournemouth'), 'Bournemouth', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AFC Bournemouth'), 'AFCB', 'en', 'manual');

-- Brighton & Hove Albion
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion'), 'Brighton', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion'), 'BHAFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Brighton & Hove Albion'), 'Brighton and Hove Albion', 'en', 'manual');

-- Brentford FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Brentford FC'), 'Brentford', 'en', 'manual');

-- Everton FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Everton FC'), 'Everton', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Everton FC'), 'EFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Everton FC'), 'The Toffees', 'en', 'manual');

-- Fulham FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Fulham FC'), 'Fulham', 'en', 'manual');

-- Sunderland AFC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sunderland AFC'), 'Sunderland', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sunderland AFC'), 'SAFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sunderland AFC'), 'Black Cats', 'en', 'manual');

-- West Ham United
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'West Ham United'), 'West Ham', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'West Ham United'), 'WHUFC', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'West Ham United'), 'The Hammers', 'en', 'manual');

-- Leeds United
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Leeds United'), 'Leeds', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Leeds United'), 'LUFC', 'en', 'manual');

-- Wolverhampton Wanderers
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Wolverhampton Wanderers'), 'Wolves', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Wolverhampton Wanderers'), 'Wolverhampton', 'en', 'manual');

-- Burnley FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Burnley FC'), 'Burnley', 'en', 'manual');

-- ── Bundesliga ───────────────────────────────────────────────
-- Bayern Munich
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'Bayern', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'FC Bayern', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'FC Bayern Munich', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'Bayern München', 'de', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'Bayern Munchen', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayern Munich'), 'FC Bayern München', 'de', 'manual');

-- Borussia Dortmund
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Dortmund'), 'Dortmund', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Dortmund'), 'BVB', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Dortmund'), 'BVB 09', 'en', 'manual');

-- RB Leipzig
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RB Leipzig'), 'Leipzig', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RB Leipzig'), 'Red Bull Leipzig', 'en', 'manual');

-- Bayer 04 Leverkusen
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayer 04 Leverkusen'), 'Leverkusen', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayer 04 Leverkusen'), 'Bayer Leverkusen', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bayer 04 Leverkusen'), 'Bayer 04', 'en', 'manual');

-- Eintracht Frankfurt
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Eintracht Frankfurt'), 'Frankfurt', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Eintracht Frankfurt'), 'Eintracht', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Eintracht Frankfurt'), 'SGE', 'de', 'manual');

-- VfB Stuttgart
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'VfB Stuttgart'), 'Stuttgart', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'VfB Stuttgart'), 'VfB', 'de', 'manual');

-- TSG 1899 Hoffenheim
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'TSG 1899 Hoffenheim'), 'Hoffenheim', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'TSG 1899 Hoffenheim'), 'TSG Hoffenheim', 'en', 'manual');

-- VfL Wolfsburg
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'VfL Wolfsburg'), 'Wolfsburg', 'en', 'manual');

-- SC Freiburg
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SC Freiburg'), 'Freiburg', 'en', 'manual');

-- SV Werder Bremen
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SV Werder Bremen'), 'Werder Bremen', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SV Werder Bremen'), 'Werder', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SV Werder Bremen'), 'Bremen', 'en', 'manual');

-- Hamburger SV
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Hamburger SV'), 'Hamburg', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Hamburger SV'), 'HSV', 'en', 'manual');

-- FC Augsburg
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Augsburg'), 'Augsburg', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Augsburg'), 'FCA', 'de', 'manual');

-- Borussia Mönchengladbach
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Mönchengladbach'), 'Gladbach', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Mönchengladbach'), 'Monchengladbach', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Mönchengladbach'), 'Borussia Gladbach', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Borussia Mönchengladbach'), 'Mönchengladbach', 'de', 'manual');

-- 1.FSV Mainz 05
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FSV Mainz 05'), 'Mainz', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FSV Mainz 05'), 'Mainz 05', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FSV Mainz 05'), 'FSV Mainz', 'en', 'manual');

-- 1.FC Köln
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Köln'), 'Cologne', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Köln'), 'Koln', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Köln'), 'FC Köln', 'de', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Köln'), 'Köln', 'de', 'manual');

-- 1.FC Union Berlin
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Union Berlin'), 'Union Berlin', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Union Berlin'), 'Union', 'en', 'manual');

-- FC St. Pauli
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC St. Pauli'), 'St. Pauli', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC St. Pauli'), 'St Pauli', 'en', 'manual');

-- 1.FC Heidenheim 1846
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Heidenheim 1846'), 'Heidenheim', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = '1.FC Heidenheim 1846'), 'FC Heidenheim', 'en', 'manual');

-- ── Ligue 1 ─────────────────────────────────────────────────
-- Paris Saint-Germain
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Paris Saint-Germain'), 'PSG', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Paris Saint-Germain'), 'Paris SG', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Paris Saint-Germain'), 'Paris Saint Germain', 'en', 'manual');

-- AS Monaco
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AS Monaco'), 'Monaco', 'en', 'manual');

-- Olympique Marseille
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Marseille'), 'Marseille', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Marseille'), 'OM', 'fr', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Marseille'), 'Olympique de Marseille', 'fr', 'manual');

-- RC Strasbourg Alsace
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RC Strasbourg Alsace'), 'Strasbourg', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RC Strasbourg Alsace'), 'RC Strasbourg', 'en', 'manual');

-- Olympique Lyon
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Lyon'), 'Lyon', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Lyon'), 'OL', 'fr', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Olympique Lyon'), 'Olympique Lyonnais', 'fr', 'manual');

-- LOSC Lille
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'LOSC Lille'), 'Lille', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'LOSC Lille'), 'LOSC', 'fr', 'manual');

-- Stade Rennais FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Stade Rennais FC'), 'Rennes', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Stade Rennais FC'), 'Stade Rennais', 'fr', 'manual');

-- RC Lens
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RC Lens'), 'Lens', 'en', 'manual');

-- OGC Nice
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'OGC Nice'), 'Nice', 'en', 'manual');

-- FC Toulouse
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Toulouse'), 'Toulouse', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Toulouse'), 'TFC', 'fr', 'manual');

-- Paris FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Paris FC'), 'PFC', 'fr', 'manual');

-- FC Nantes
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Nantes'), 'Nantes', 'en', 'manual');

-- FC Lorient
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Lorient'), 'Lorient', 'en', 'manual');

-- Stade Brestois 29
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Stade Brestois 29'), 'Brest', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Stade Brestois 29'), 'Stade Brestois', 'fr', 'manual');

-- AJ Auxerre
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AJ Auxerre'), 'Auxerre', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AJ Auxerre'), 'AJA', 'fr', 'manual');

-- Le Havre AC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Le Havre AC'), 'Le Havre', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Le Havre AC'), 'HAC', 'fr', 'manual');

-- Angers SCO
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Angers SCO'), 'Angers', 'en', 'manual');

-- FC Metz
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Metz'), 'Metz', 'en', 'manual');

-- ── La Liga ──────────────────────────────────────────────────
-- Real Madrid
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Madrid'), 'Madrid', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Madrid'), 'Real Madrid CF', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Madrid'), 'Los Blancos', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Madrid'), 'RMA', 'en', 'manual');

-- FC Barcelona
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Barcelona'), 'Barcelona', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Barcelona'), 'Barca', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Barcelona'), 'Barça', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Barcelona'), 'FCB', 'en', 'manual');

-- Atlético de Madrid
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético de Madrid'), 'Atletico Madrid', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético de Madrid'), 'Atletico', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético de Madrid'), 'Atleti', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético de Madrid'), 'Atletico de Madrid', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético de Madrid'), 'Atlético Madrid', 'es', 'manual');

-- Villarreal CF
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Villarreal CF'), 'Villarreal', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Villarreal CF'), 'Yellow Submarine', 'en', 'manual');

-- Athletic Bilbao
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Athletic Bilbao'), 'Athletic Club', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Athletic Bilbao'), 'Bilbao', 'en', 'manual');

-- Real Sociedad
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Sociedad'), 'Sociedad', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Sociedad'), 'La Real', 'en', 'manual');

-- Real Betis Balompié
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Betis Balompié'), 'Real Betis', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Betis Balompié'), 'Betis', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Betis Balompié'), 'Real Betis Balompie', 'en', 'manual');

-- Celta de Vigo
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Celta de Vigo'), 'Celta Vigo', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Celta de Vigo'), 'Celta', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Celta de Vigo'), 'RC Celta', 'en', 'manual');

-- Valencia CF
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Valencia CF'), 'Valencia', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Valencia CF'), 'VCF', 'en', 'manual');

-- Girona FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Girona FC'), 'Girona', 'en', 'manual');

-- Sevilla FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sevilla FC'), 'Sevilla', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sevilla FC'), 'SFC', 'en', 'manual');

-- RCD Espanyol Barcelona
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RCD Espanyol Barcelona'), 'Espanyol', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RCD Espanyol Barcelona'), 'RCD Espanyol', 'en', 'manual');

-- Rayo Vallecano
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Rayo Vallecano'), 'Rayo', 'en', 'manual');

-- CA Osasuna
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'CA Osasuna'), 'Osasuna', 'en', 'manual');

-- RCD Mallorca
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RCD Mallorca'), 'Mallorca', 'en', 'manual');

-- Levante UD
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Levante UD'), 'Levante', 'en', 'manual');

-- Elche CF
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Elche CF'), 'Elche', 'en', 'manual');

-- Getafe CF
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Getafe CF'), 'Getafe', 'en', 'manual');

-- Deportivo Alavés
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Deportivo Alavés'), 'Alaves', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Deportivo Alavés'), 'Alavés', 'es', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Deportivo Alavés'), 'Deportivo Alaves', 'en', 'manual');

-- Real Oviedo
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Real Oviedo'), 'Oviedo', 'en', 'manual');

-- ── Serie A ──────────────────────────────────────────────────
-- Inter Milan
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Inter Milan'), 'Inter', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Inter Milan'), 'Internazionale', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Inter Milan'), 'FC Internazionale', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Inter Milan'), 'FC Inter', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Inter Milan'), 'Nerazzurri', 'it', 'manual');

-- Juventus FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Juventus FC'), 'Juventus', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Juventus FC'), 'Juve', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Juventus FC'), 'Juventus Turin', 'en', 'manual');

-- AC Milan
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AC Milan'), 'Milan', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AC Milan'), 'Rossoneri', 'it', 'manual');

-- AS Roma
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AS Roma'), 'Roma', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AS Roma'), 'Giallorossi', 'it', 'manual');

-- SSC Napoli
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SSC Napoli'), 'Napoli', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SSC Napoli'), 'Naples', 'en', 'manual');

-- Atalanta BC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atalanta BC'), 'Atalanta', 'en', 'manual');

-- Como 1907
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Como 1907'), 'Como', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Como 1907'), 'FC Como', 'en', 'manual');

-- Bologna FC 1909
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bologna FC 1909'), 'Bologna', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Bologna FC 1909'), 'Bologna FC', 'en', 'manual');

-- ACF Fiorentina
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'ACF Fiorentina'), 'Fiorentina', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'ACF Fiorentina'), 'Viola', 'it', 'manual');

-- SS Lazio
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SS Lazio'), 'Lazio', 'en', 'manual');

-- US Sassuolo
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'US Sassuolo'), 'Sassuolo', 'en', 'manual');

-- Parma Calcio 1913
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Parma Calcio 1913'), 'Parma', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Parma Calcio 1913'), 'Parma Calcio', 'en', 'manual');

-- Udinese Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Udinese Calcio'), 'Udinese', 'en', 'manual');

-- Genoa CFC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Genoa CFC'), 'Genoa', 'en', 'manual');

-- Cagliari Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Cagliari Calcio'), 'Cagliari', 'en', 'manual');

-- Torino FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Torino FC'), 'Torino', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Torino FC'), 'Toro', 'it', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Torino FC'), 'Turin', 'en', 'manual');

-- Pisa Sporting Club
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Pisa Sporting Club'), 'Pisa', 'en', 'manual');

-- Hellas Verona
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Hellas Verona'), 'Verona', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Hellas Verona'), 'Hellas', 'en', 'manual');

-- US Lecce
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'US Lecce'), 'Lecce', 'en', 'manual');

-- US Cremonese
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'US Cremonese'), 'Cremonese', 'en', 'manual');
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'US Cremonese'), 'Cremona', 'en', 'manual');
