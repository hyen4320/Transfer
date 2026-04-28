-- V9: 5대리그 외 주요 구단 추가 (포르투갈·사우디·네덜란드·터키·스코틀랜드·벨기에·브라질)

-- ── League 추가 ──────────────────────────────────────────────
INSERT INTO league (name, country_code, tier)
SELECT 'Primeira Liga', 'PT', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Primeira Liga');

INSERT INTO league (name, country_code, tier)
SELECT 'Saudi Pro League', 'SA', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Saudi Pro League');

INSERT INTO league (name, country_code, tier)
SELECT 'Eredivisie', 'NL', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Eredivisie');

INSERT INTO league (name, country_code, tier)
SELECT 'Süper Lig', 'TR', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Süper Lig');

INSERT INTO league (name, country_code, tier)
SELECT 'Scottish Premiership', 'GB', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Scottish Premiership');

INSERT INTO league (name, country_code, tier)
SELECT 'Belgian Pro League', 'BE', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Belgian Pro League');

-- ── Primeira Liga ────────────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Primeira Liga'),
       'SL Benfica', 'Benfica', 'PT', 'Lisbon', 38.752600, -9.184400, 'Estádio da Luz'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('SL Benfica'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Primeira Liga'),
       'FC Porto', 'Porto', 'PT', 'Porto', 41.161300, -8.583600, 'Estádio do Dragão'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('FC Porto'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Primeira Liga'),
       'Sporting CP', 'Sporting', 'PT', 'Lisbon', 38.761300, -9.160400, 'Estádio José Alvalade'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Sporting CP'));

-- ── Saudi Pro League ─────────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Saudi Pro League'),
       'Al-Nassr FC', 'Al-Nassr', 'SA', 'Riyadh', 24.761100, 46.715300, 'Al-Awwal Park'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Al-Nassr FC'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Saudi Pro League'),
       'Al-Hilal FC', 'Al-Hilal', 'SA', 'Riyadh', 24.778300, 46.723100, 'Kingdom Arena'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Al-Hilal FC'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Saudi Pro League'),
       'Al-Ittihad Club', 'Al-Ittihad', 'SA', 'Jeddah', 21.542800, 39.172800, 'King Abdullah Sports City'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Al-Ittihad Club'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Saudi Pro League'),
       'Al-Ahli Saudi FC', 'Al-Ahli', 'SA', 'Jeddah', 21.542800, 39.172800, 'King Abdullah Sports City'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Al-Ahli Saudi FC'));

-- ── Eredivisie ───────────────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Eredivisie'),
       'AFC Ajax', 'Ajax', 'NL', 'Amsterdam', 52.314200, 4.942000, 'Johan Cruyff Arena'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('AFC Ajax'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Eredivisie'),
       'PSV Eindhoven', 'PSV', 'NL', 'Eindhoven', 51.441500, 5.467700, 'Philips Stadion'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('PSV Eindhoven'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Eredivisie'),
       'Feyenoord', 'Feyenoord', 'NL', 'Rotterdam', 51.893700, 4.523200, 'De Kuip'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Feyenoord'));

-- ── Süper Lig ────────────────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Süper Lig'),
       'Galatasaray SK', 'Galatasaray', 'TR', 'Istanbul', 41.074200, 28.781100, 'Rams Park'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Galatasaray SK'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Süper Lig'),
       'Fenerbahçe SK', 'Fenerbahce', 'TR', 'Istanbul', 40.987600, 29.037800, 'Ülker Stadyumu'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Fenerbahçe SK'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Süper Lig'),
       'Beşiktaş JK', 'Besiktas', 'TR', 'Istanbul', 41.044300, 29.012000, 'Tüpraş Stadyumu'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Beşiktaş JK'));

-- ── Scottish Premiership ─────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Scottish Premiership'),
       'Celtic FC', 'Celtic', 'GB', 'Glasgow', 55.849200, -4.205600, 'Celtic Park'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Celtic FC'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Scottish Premiership'),
       'Rangers FC', 'Rangers', 'GB', 'Glasgow', 55.851000, -4.309200, 'Ibrox Stadium'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Rangers FC'));

-- ── Belgian Pro League ───────────────────────────────────────
INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Belgian Pro League'),
       'Club Brugge KV', 'Club Brugge', 'BE', 'Bruges', 51.208800, 3.177000, 'Jan Breydel Stadium'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Club Brugge KV'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Belgian Pro League'),
       'RSC Anderlecht', 'Anderlecht', 'BE', 'Brussels', 50.836000, 4.297500, 'Lotto Park'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('RSC Anderlecht'));

-- ── Club Aliases ─────────────────────────────────────────────
-- SL Benfica
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SL Benfica'), 'Benfica', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'SL Benfica'), 'Sport Lisboa e Benfica', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- FC Porto
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'FC Porto'), 'Porto', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Sporting CP
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sporting CP'), 'Sporting', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sporting CP'), 'Sporting Lisbon', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Sporting CP'), 'Sporting Lisboa', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Al-Nassr FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Nassr FC'), 'Al-Nassr', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Nassr FC'), 'Al Nassr', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Nassr FC'), 'Nassr', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Al-Hilal FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Hilal FC'), 'Al-Hilal', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Hilal FC'), 'Al Hilal', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Al-Ittihad Club
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Ittihad Club'), 'Al-Ittihad', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Ittihad Club'), 'Al Ittihad', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Ittihad Club'), 'Ittihad', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Al-Ahli Saudi FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Ahli Saudi FC'), 'Al-Ahli', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Al-Ahli Saudi FC'), 'Al Ahli', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- AFC Ajax
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AFC Ajax'), 'Ajax', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'AFC Ajax'), 'Ajax Amsterdam', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- PSV Eindhoven
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'PSV Eindhoven'), 'PSV', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Feyenoord
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Feyenoord'), 'Feyenoord Rotterdam', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Galatasaray SK
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Galatasaray SK'), 'Galatasaray', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Galatasaray SK'), 'Galatasaray FC', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Fenerbahçe SK
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Fenerbahçe SK'), 'Fenerbahce', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Fenerbahçe SK'), 'Fenerbahçe', 'tr', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Fenerbahçe SK'), 'Fenerbahce SK', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Beşiktaş JK
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Beşiktaş JK'), 'Besiktas', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Beşiktaş JK'), 'Beşiktaş', 'tr', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Beşiktaş JK'), 'Besiktas JK', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Celtic FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Celtic FC'), 'Celtic', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Celtic FC'), 'Celtic Glasgow', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Rangers FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Rangers FC'), 'Rangers', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Rangers FC'), 'Glasgow Rangers', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Club Brugge KV
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Club Brugge KV'), 'Club Brugge', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Club Brugge KV'), 'Brugge', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- RSC Anderlecht
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'RSC Anderlecht'), 'Anderlecht', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- ── Brasileirão Série A ──────────────────────────────────────
INSERT INTO league (name, country_code, tier)
SELECT 'Brasileirão Série A', 'BR', 1 WHERE NOT EXISTS (SELECT 1 FROM league WHERE name = 'Brasileirão Série A');

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Flamengo', 'Flamengo', 'BR', 'Rio de Janeiro', -22.912100, -43.230200, 'Maracanã'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Flamengo'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Palmeiras', 'Palmeiras', 'BR', 'São Paulo', -23.527800, -46.679900, 'Allianz Parque'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Palmeiras'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Santos FC', 'Santos', 'BR', 'Santos', -23.959700, -46.332800, 'Vila Belmiro'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Santos FC'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Corinthians', 'Corinthians', 'BR', 'São Paulo', -23.545200, -46.474700, 'Neo Química Arena'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Corinthians'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'São Paulo FC', 'São Paulo', 'BR', 'São Paulo', -23.600200, -46.719700, 'MorumBIS'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('São Paulo FC'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Atlético Mineiro', 'Atlético MG', 'BR', 'Belo Horizonte', -19.924100, -43.969100, 'Arena MRV'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Atlético Mineiro'));

INSERT INTO club (league_id, name, short_name, country_code, city, latitude, longitude, stadium_name)
SELECT (SELECT league_id FROM league WHERE name = 'Brasileirão Série A'),
       'Fluminense', 'Fluminense', 'BR', 'Rio de Janeiro', -22.912100, -43.230200, 'Maracanã'
WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower('Fluminense'));

-- Flamengo
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Flamengo'), 'CR Flamengo', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Flamengo'), 'Clube de Regatas do Flamengo', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Palmeiras
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Palmeiras'), 'SE Palmeiras', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Santos FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Santos FC'), 'Santos', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Corinthians
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Corinthians'), 'SC Corinthians', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Corinthians'), 'Sport Club Corinthians Paulista', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- São Paulo FC
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'São Paulo FC'), 'Sao Paulo FC', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'São Paulo FC'), 'Sao Paulo', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'São Paulo FC'), 'São Paulo', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Atlético Mineiro
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético Mineiro'), 'Atletico Mineiro', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético Mineiro'), 'Atlético MG', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Atlético Mineiro'), 'Atletico MG', 'en', 'manual') ON CONFLICT (alias) DO NOTHING;

-- Fluminense
INSERT INTO club_aliases (club_id, alias, lang, source) VALUES ((SELECT club_id FROM club WHERE name = 'Fluminense'), 'Fluminense FC', 'pt', 'manual') ON CONFLICT (alias) DO NOTHING;
