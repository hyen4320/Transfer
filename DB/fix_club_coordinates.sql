-- Club 좌표 수정 스크립트
-- club.json 기준으로 잘못된 geocoding 수정 (35개 구단)
-- HeidiSQL에서 실행: File > Run SQL file... 또는 직접 붙여넣기

-- ── Serie A ──────────────────────────────────────────────────────────────────
UPDATE club SET city = 'Salerno',  latitude = 40.676000, longitude = 14.769000 WHERE club_id = 410; -- US Salernitana 1919 (벨라루스 → 살레르노)
UPDATE club SET city = 'Ferrara',  latitude = 44.839000, longitude = 11.614000 WHERE club_id = 405; -- SPAL (브라질 → 페라라)
UPDATE club SET city = 'Ferrara',  latitude = 44.839000, longitude = 11.614000 WHERE club_id = 403; -- SPAL 2013 (브라질 → 페라라)
UPDATE club SET city = 'Palermo',  latitude = 38.131000, longitude = 13.355000 WHERE club_id = 387; -- US Palermo (뉴욕주 → 시칠리아)
UPDATE club SET city = 'Genova',   latitude = 44.415000, longitude =  8.912000 WHERE club_id = 395; -- Genoa CFC (우디네 → 제노바)
UPDATE club SET city = 'Genova',   latitude = 44.415000, longitude =  8.912000 WHERE club_id = 382; -- UC Sampdoria (우디네 → 제노바)
UPDATE club SET city = 'La Spezia',latitude = 44.103000, longitude =  9.826000 WHERE club_id = 408; -- Spezia Calcio (돌로미티 → 라스페치아)
UPDATE club SET city = 'Napoli',   latitude = 40.828000, longitude = 14.193000 WHERE club_id = 373; -- SSC Napoli (아르헨티나 → 나폴리)
UPDATE club SET city = 'Vicenza',  latitude = 45.541000, longitude = 11.546000 WHERE club_id = 372; -- Vicenza Calcio (헝가리 → 비첸차)
UPDATE club SET city = 'Milano',   latitude = 45.478000, longitude =  9.124000 WHERE club_id = 370; -- AC Milan (바실리카타 → 밀라노)
UPDATE club SET city = 'Milano',   latitude = 45.478000, longitude =  9.124000 WHERE club_id = 369; -- Inter Milan (바실리카타 → 밀라노)
UPDATE club SET city = 'Perugia',  latitude = 43.120000, longitude = 12.390000 WHERE club_id = 360; -- AC Perugia (알바니아 → 페루자)
UPDATE club SET city = 'Torino',   latitude = 45.110000, longitude =  7.641000 WHERE club_id = 362; -- Juventus FC (런던 → 토리노)
UPDATE club SET city = 'Bari',     latitude = 41.108000, longitude = 16.872000 WHERE club_id = 374; -- AS Bari (빌라프란카피에몬테 → 바리)
UPDATE club SET city = 'Empoli',   latitude = 43.721000, longitude = 10.946000 WHERE club_id = 380; -- FC Empoli (파엔차 → 엠폴리)
UPDATE club SET city = 'Siena',    latitude = 43.321000, longitude = 11.330000 WHERE club_id = 383; -- AC Siena (피렌체 좌표 → 시에나)
UPDATE club SET city = 'Pescara',  latitude = 42.446000, longitude = 14.213000 WHERE club_id = 398; -- Delfino Pescara 1936
UPDATE club SET city = 'Treviso',  latitude = 45.643000, longitude = 12.196000 WHERE club_id = 392; -- Treviso FBC 1993 (레조에밀리아 → 트레비소)
UPDATE club SET city = 'Modena',   latitude = 44.654000, longitude = 10.924000 WHERE club_id = 381; -- Modena FC (코파로 → 모데나)

-- ── La Liga ──────────────────────────────────────────────────────────────────
UPDATE club SET city = 'Córdoba',  latitude = 37.884000, longitude =  -4.773000 WHERE club_id = 352; -- Córdoba CF (멕시코 → 코르도바)
UPDATE club SET city = 'Alicante', latitude = 38.349000, longitude =  -0.473000 WHERE club_id = 349; -- Hércules CF (푸에르토리코 → 알리칸테)
UPDATE club SET city = 'Albacete', latitude = 38.989000, longitude =  -1.856000 WHERE club_id = 340; -- Albacete Balompié (브라질 → 알바세테)
UPDATE club SET city = 'Sevilla',  latitude = 37.356000, longitude =  -5.981000 WHERE club_id = 337; -- Real Betis (멕시코 → 세비야)
UPDATE club SET city = 'Valladolid',latitude = 41.643000, longitude = -4.729000 WHERE club_id = 331; -- Real Valladolid (우루과이 → 바야돌리드)
UPDATE club SET city = 'Villarreal',latitude = 39.946000, longitude = -0.099000 WHERE club_id = 320; -- Villarreal CF (아르헨티나 → 비야레알)
UPDATE club SET city = 'Soria',    latitude = 41.767000, longitude =  -2.479000 WHERE club_id = 317; -- CD Numancia (칠레 → 소리아)

-- ── Premier League ───────────────────────────────────────────────────────────
UPDATE club SET city = 'Wigan',      latitude = 53.551000, longitude =  -2.637000 WHERE club_id = 259; -- Wigan Athletic (중앙아프리카 → 위건)
UPDATE club SET city = 'Birmingham', latitude = 52.480000, longitude =  -1.778000 WHERE club_id = 254; -- Birmingham City (미국 앨라배마 → 버밍엄 UK)
UPDATE club SET city = 'London',     latitude = 51.487000, longitude =   0.036000 WHERE club_id = 242; -- Charlton Athletic (카리브해 → 런던)
UPDATE club SET city = 'Blackpool',  latitude = 53.805000, longitude =  -3.047000 WHERE club_id = 266; -- Blackpool FC (런던 좌표 → 블랙풀)
UPDATE club SET city = 'Ipswich',    latitude = 52.055000, longitude =   1.145000 WHERE club_id = 236; -- Ipswich Town (런던 좌표 → 입스위치)
UPDATE club SET city = 'Leeds',      latitude = 53.778000, longitude =  -1.572000 WHERE club_id = 230; -- Leeds United (런던 좌표 → 리즈)
UPDATE club SET city = 'Luton',      latitude = 51.883000, longitude =  -0.432000 WHERE club_id = 275; -- Luton Town (워릭 → 루턴)
UPDATE club SET city = 'Watford',    latitude = 51.650000, longitude =  -0.401000 WHERE club_id = 261; -- Watford FC (런던 좌표 → 왓퍼드)

-- ── Bundesliga ───────────────────────────────────────────────────────────────
UPDATE club SET city = 'Aachen',  latitude = 50.769000, longitude =  6.069000 WHERE club_id = 301; -- Alemannia Aachen (이탈리아 티볼리 → 아헨)

-- ── Ligue 1 ──────────────────────────────────────────────────────────────────
UPDATE club SET city = 'Bordeaux', latitude = 44.828000, longitude = -0.568000 WHERE club_id = 424; -- FC Girondins Bordeaux (낭트 좌표 → 보르도)

-- ── DB 좌표 불일치 (club.json은 정상이나 DB 값이 다름) ─────────────────────────
UPDATE club SET city = 'Firenze',  latitude = 43.780884, longitude = 11.282819 WHERE club_id = 385; -- ACF Fiorentina
UPDATE club SET city = 'Istanbul', latitude = 40.987600, longitude = 29.037800 WHERE club_id = 468; -- Fenerbahçe SK
UPDATE club SET city = 'Sevilla',  latitude = 37.356000, longitude = -5.981000 WHERE club_id = 337; -- Real Betis Balompié
