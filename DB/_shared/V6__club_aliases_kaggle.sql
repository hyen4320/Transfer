-- ============================================================
--  Kaggle transfers.csv 실제 사용 구단명 aliases
--  V3__club_aliases_seed.sql 이후 누락분 보완
--  실행: V3 적용 이후
-- ============================================================

-- helper macro: alias가 이미 존재하면 skip
-- INSERT INTO club_aliases (club_id, alias, lang, source)
-- SELECT (SELECT club_id FROM club WHERE name='X'), 'Y', 'en', 'kaggle'
-- WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias) = lower('Y'));

-- ── Premier League ───────────────────────────────────────────
-- Cardiff City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Cardiff City'), 'Cardiff', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cardiff'));

-- Huddersfield Town
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Huddersfield Town'), 'Huddersfield', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Huddersfield'));

-- Ipswich Town
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Ipswich Town'), 'Ipswich', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Ipswich'));

-- Leicester City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Leicester City'), 'Leicester', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Leicester'));

-- Luton Town
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Luton Town'), 'Luton', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Luton'));

-- Middlesbrough FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Middlesbrough FC'), 'Middlesbrough', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Middlesbrough'));

-- Norwich City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Norwich City'), 'Norwich', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Norwich'));

-- Nottingham Forest (kaggle 축약형)
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Nottingham Forest'), 'Nottm Forest', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Nottm Forest'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Nottingham Forest'), 'Nott''m Forest', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Nott''m Forest'));

-- Queens Park Rangers
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Queens Park Rangers'), 'QPR', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('QPR'));

-- Reading FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Reading FC'), 'Reading', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Reading'));

-- Sheffield United
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Sheffield United'), 'Sheff Utd', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sheff Utd'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Sheffield United'), 'Sheffield Utd', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sheffield Utd'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Sheffield United'), 'Sheffield', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sheffield'));

-- Southampton FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Southampton FC'), 'Southampton', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Southampton'));

-- Swansea City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Swansea City'), 'Swansea', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Swansea'));

-- Watford FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Watford FC'), 'Watford', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Watford'));

-- West Bromwich Albion
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='West Bromwich Albion'), 'West Brom', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('West Brom'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='West Bromwich Albion'), 'WBA', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('WBA'));

-- Wigan Athletic
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Wigan Athletic'), 'Wigan', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Wigan'));

-- Blackburn Rovers
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Blackburn Rovers'), 'Blackburn', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Blackburn'));

-- Bolton Wanderers
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Bolton Wanderers'), 'Bolton', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bolton'));

-- Derby County
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Derby County'), 'Derby', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Derby'));

-- Stoke City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Stoke City'), 'Stoke', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Stoke'));

-- Charlton Athletic
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Charlton Athletic'), 'Charlton', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Charlton'));

-- Blackpool FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Blackpool FC'), 'Blackpool', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Blackpool'));

-- Birmingham City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Birmingham City'), 'Birmingham', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Birmingham'));

-- Portsmouth FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Portsmouth FC'), 'Portsmouth', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Portsmouth'));

-- Hull City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Hull City'), 'Hull', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Hull'));

-- Coventry City
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Coventry City'), 'Coventry', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Coventry'));


-- ── Bundesliga ───────────────────────────────────────────────
-- Arminia Bielefeld
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Arminia Bielefeld'), 'Arm. Bielefeld', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Arm. Bielefeld'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Arminia Bielefeld'), 'Bielefeld', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bielefeld'));

-- Bayer 04 Leverkusen
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Bayer 04 Leverkusen'), 'B. Leverkusen', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('B. Leverkusen'));

-- Borussia Dortmund
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Borussia Dortmund'), 'Bor. Dortmund', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bor. Dortmund'));

-- Borussia Mönchengladbach
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Borussia Mönchengladbach'), 'Bor. M''gladbach', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bor. M''gladbach'));

-- Eintracht Braunschweig
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Eintracht Braunschweig'), 'E. Braunschweig', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('E. Braunschweig'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Eintracht Braunschweig'), 'Braunschweig', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Braunschweig'));

-- Eintracht Frankfurt
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Eintracht Frankfurt'), 'E. Frankfurt', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('E. Frankfurt'));

-- FC Ingolstadt 04
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Ingolstadt 04'), 'FC Ingolstadt', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('FC Ingolstadt'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Ingolstadt 04'), 'Ingolstadt', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Ingolstadt'));

-- Fortuna Düsseldorf
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Fortuna Düsseldorf'), 'F. Düsseldorf', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('F. Düsseldorf'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Fortuna Düsseldorf'), 'Düsseldorf', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Düsseldorf'));

-- SC Paderborn 07
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SC Paderborn 07'), 'SC Paderborn', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('SC Paderborn'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SC Paderborn 07'), 'Paderborn', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Paderborn'));

-- SpVgg Greuther Fürth
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SpVgg Greuther Fürth'), 'Greuther Fürth', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Greuther Fürth'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SpVgg Greuther Fürth'), 'Greuther Furth', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Greuther Furth'));

-- SV Darmstadt 98
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SV Darmstadt 98'), 'Darmstadt 98', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Darmstadt 98'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SV Darmstadt 98'), 'Darmstadt', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Darmstadt'));

-- TSV 1860 Munich
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='TSV 1860 Munich'), '1860 Munich', 'en', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('1860 Munich'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='TSV 1860 Munich'), '1860 München', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('1860 München'));

-- Alemannia Aachen
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Alemannia Aachen'), 'Alem. Aachen', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Alem. Aachen'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Alemannia Aachen'), 'Aachen', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Aachen'));

-- MSV Duisburg
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='MSV Duisburg'), 'Duisburg', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Duisburg'));

-- FC Hansa Rostock
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Hansa Rostock'), 'Hansa Rostock', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Hansa Rostock'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Hansa Rostock'), 'Rostock', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Rostock'));

-- 1.FC Kaiserslautern
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='1.FC Kaiserslautern'), 'Kaiserslautern', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Kaiserslautern'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='1.FC Kaiserslautern'), '1.FC K''lautern', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('1.FC K''lautern'));

-- FC Energie Cottbus
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Energie Cottbus'), 'Cottbus', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cottbus'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Energie Cottbus'), 'En. Cottbus', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('En. Cottbus'));

-- Karlsruher SC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Karlsruher SC'), 'Karlsruhe', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Karlsruhe'));

-- Hannover 96
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Hannover 96'), 'Hannover', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Hannover'));

-- VfL Bochum
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='VfL Bochum'), 'Bochum', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bochum'));

-- Hertha BSC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Hertha BSC'), 'Hertha', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Hertha'));

-- Holstein Kiel
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Holstein Kiel'), 'Kiel', 'de', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Kiel'));


-- ── La Liga ──────────────────────────────────────────────────
-- Athletic Bilbao
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Athletic Bilbao'), 'Athletic', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Athletic'));

-- Deportivo de La Coruña
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Deportivo de La Coruña'), 'Dep. La Coruña', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Dep. La Coruña'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Deportivo de La Coruña'), 'Deportivo', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Deportivo'));

-- Real Valladolid CF
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Real Valladolid CF'), 'Real Valladolid', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Real Valladolid'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Real Valladolid CF'), 'Valladolid', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Valladolid'));

-- UD Las Palmas
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='UD Las Palmas'), 'Las Palmas', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Las Palmas'));

-- Racing Santander
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Racing Santander'), 'Racing', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Racing'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Racing Santander'), 'Santander', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Santander'));

-- Málaga CF
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Málaga CF'), 'Málaga', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Málaga'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Málaga CF'), 'Malaga', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Malaga'));

-- Cádiz CF
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Cádiz CF'), 'Cádiz', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cádiz'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Cádiz CF'), 'Cadiz', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cadiz'));

-- Sporting Gijón
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Sporting Gijón'), 'Sporting Gijón', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sporting Gijón'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Sporting Gijón'), 'Sporting Gijon', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sporting Gijon'));

-- SD Eibar
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SD Eibar'), 'Eibar', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Eibar'));

-- SD Huesca
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SD Huesca'), 'Huesca', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Huesca'));

-- CD Leganés
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='CD Leganés'), 'Leganés', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Leganés'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='CD Leganés'), 'Leganes', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Leganes'));

-- UD Almería
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='UD Almería'), 'Almería', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Almería'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='UD Almería'), 'Almeria', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Almeria'));

-- Granada CF
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Granada CF'), 'Granada', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Granada'));

-- Real Oviedo
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Real Oviedo'), 'Oviedo', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Oviedo'));

-- Real Zaragoza
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Real Zaragoza'), 'Zaragoza', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Zaragoza'));

-- Real Murcia CF
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Real Murcia CF'), 'Murcia', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Murcia'));

-- Albacete Balompié
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Albacete Balompié'), 'Albacete', 'es', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Albacete'));


-- ── Serie A ──────────────────────────────────────────────────
-- Benevento Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Benevento Calcio'), 'Benevento', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Benevento'));

-- Brescia Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Brescia Calcio'), 'Brescia', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Brescia'));

-- Cagliari Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Cagliari Calcio'), 'Cagliari', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cagliari'));

-- Como 1907 (kaggle: Calcio Como / transfers: Como)
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Como 1907'), 'Como', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Como'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Como 1907'), 'Calcio Como', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Calcio Como'));

-- Calcio Catania
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Calcio Catania'), 'Catania', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Catania'));

-- AC Cesena
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Cesena'), 'Cesena', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Cesena'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Cesena'), 'RC Cesena', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('RC Cesena'));

-- Delfino Pescara 1936
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Delfino Pescara 1936'), 'Pescara', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Pescara'));

-- FC Crotone
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Crotone'), 'Crotone', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Crotone'));

-- FC Empoli
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Empoli'), 'Empoli', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Empoli'));

-- Frosinone Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Frosinone Calcio'), 'Frosinone', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Frosinone'));

-- US Palermo
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='US Palermo'), 'Palermo', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Palermo'));

-- AC Siena
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Siena'), 'Siena', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Siena'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Siena'), 'Robur Siena', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Robur Siena'));

-- UC Sampdoria
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='UC Sampdoria'), 'Sampdoria', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sampdoria'));

-- Udinese Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Udinese Calcio'), 'Udinese', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Udinese'));

-- AS Livorno
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Livorno'), 'Livorno', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Livorno'));

-- US Salernitana 1919
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='US Salernitana 1919'), 'Salernitana', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Salernitana'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='US Salernitana 1919'), 'Salerno', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Salerno'));

-- Venezia FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Venezia FC'), 'Venezia', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Venezia'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Venezia FC'), 'Unione Venezia', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Unione Venezia'));

-- AC Monza
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Monza'), 'Monza', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Monza'));

-- ACF Fiorentina (V3에 이미 있을 수 있으나 안전하게 추가)
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='ACF Fiorentina'), 'Fiorentina', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Fiorentina'));

-- AC Parma / Parma FC (kaggle: transfers → 'Parma' → V3에서 Parma Calcio 1913에 이미 매핑됨)
-- Parma Calcio 1913 - V3 already covers 'Parma', 'Parma Calcio'

-- SPAL 2013
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SPAL 2013'), 'SPAL 2013', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('SPAL 2013'));

-- Spezia Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Spezia Calcio'), 'Spezia', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Spezia'));

-- Modena FC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Modena FC'), 'Modena', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Modena'));

-- Novara Calcio 1908
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Novara Calcio 1908'), 'Novara', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Novara'));

-- Ascoli Calcio 1898
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Ascoli Calcio 1898'), 'Ascoli', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Ascoli'));

-- AC Perugia
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Perugia'), 'Perugia', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Perugia'));

-- Reggina Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Reggina Calcio'), 'Reggina', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Reggina'));

-- Vicenza Calcio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Vicenza Calcio'), 'Vicenza', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Vicenza'));

-- AS Bari
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Bari'), 'Bari', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bari'));

-- AC Venezia 1907
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Venezia 1907'), 'Venezia 1907', 'it', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Venezia 1907'));


-- ── Ligue 1 ─────────────────────────────────────────────────
-- AS Nancy-Lorraine
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Nancy-Lorraine'), 'AS Nancy', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('AS Nancy'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Nancy-Lorraine'), 'Nancy', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Nancy'));

-- AS Saint-Étienne
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Saint-Étienne'), 'Saint-Étienne', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Saint-Étienne'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Saint-Étienne'), 'Saint-Etienne', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Saint-Etienne'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AS Saint-Étienne'), 'St-Étienne', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('St-Étienne'));

-- Clermont Foot 63
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Clermont Foot 63'), 'Clermont Foot', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Clermont Foot'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Clermont Foot 63'), 'Clermont', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Clermont'));

-- Dijon FCO
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Dijon FCO'), 'Dijon', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Dijon'));

-- EA Guingamp
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='EA Guingamp'), 'Guingamp', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Guingamp'));

-- ESTAC Troyes
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='ESTAC Troyes'), 'Troyes', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Troyes'));

-- FC Girondins Bordeaux
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Girondins Bordeaux'), 'G. Bordeaux', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('G. Bordeaux'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Girondins Bordeaux'), 'Bordeaux', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bordeaux'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Girondins Bordeaux'), 'Girondins Bordeaux', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Girondins Bordeaux'));

-- FC Sochaux-Montbéliard
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Sochaux-Montbéliard'), 'FC Sochaux', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('FC Sochaux'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Sochaux-Montbéliard'), 'Sochaux', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sochaux'));

-- GFC Ajaccio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='GFC Ajaccio'), 'G. Ajaccio', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('G. Ajaccio'));

-- Montpellier HSC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Montpellier HSC'), 'Montpellier', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Montpellier'));

-- RC Strasbourg Alsace
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='RC Strasbourg Alsace'), 'R. Strasbourg', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('R. Strasbourg'));

-- FC Évian Thonon Gaillard
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Évian Thonon Gaillard'), 'Évian', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Évian'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Évian Thonon Gaillard'), 'Evian', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Evian'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='FC Évian Thonon Gaillard'), 'Thonon Évian', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Thonon Évian'));

-- SM Caen
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SM Caen'), 'Caen', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Caen'));

-- SC Bastia
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='SC Bastia'), 'Bastia', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Bastia'));

-- Amiens SC
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Amiens SC'), 'Amiens', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Amiens'));

-- Nîmes Olympique
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Nîmes Olympique'), 'Nîmes', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Nîmes'));
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Nîmes Olympique'), 'Nimes', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Nimes'));

-- Grenoble Foot 38
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Grenoble Foot 38'), 'Grenoble', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Grenoble'));

-- AC Ajaccio
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='AC Ajaccio'), 'Ajaccio', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Ajaccio'));

-- CS Sedan-Ardennes
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='CS Sedan-Ardennes'), 'Sedan', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Sedan'));

-- Stade Reims
INSERT INTO club_aliases (club_id, alias, lang, source) SELECT (SELECT club_id FROM club WHERE name='Stade Reims'), 'Reims', 'fr', 'kaggle' WHERE NOT EXISTS (SELECT 1 FROM club_aliases WHERE lower(alias)=lower('Reims'));
