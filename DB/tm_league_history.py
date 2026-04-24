"""
Transfermarkt 시즌별 1부리그 소속 구단 크롤러
→ club / club_season INSERT SQL 생성

위치 정보 수집 전략:
  1순위: clubs.csv (stadium_name) + Nominatim (좌표)  — 빠름
  2순위: Transfermarkt 팀 페이지 + Nominatim          — clubs.csv에 없을 때만

실행: python DB/tm_league_history.py
출력: DB/league_history.sql
"""

import sys
import os
import re
import csv
import time
import requests
from bs4 import BeautifulSoup

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "_shared"))

# ── 설정 ──────────────────────────────────────────────────────────────────────
START_SEASON   = 2000
END_SEASON     = 2025
REQUEST_DELAY  = 3.0    # Transfermarkt 딜레이 (초)
NOMINATIM_DELAY = 1.1   # Nominatim 1 req/s 정책
OUTPUT_SQL     = os.path.join(os.path.dirname(__file__), "league_history.sql")
CLUBS_CSV      = os.path.join(os.path.dirname(__file__), "clubs.csv")

LEAGUES = {
    "GB1": ("Premier League", "GB", "premier-league"),
    "L1":  ("Bundesliga",     "DE", "1-bundesliga"),
    "ES1": ("La Liga",        "ES", "primera-division"),
    "IT1": ("Serie A",        "IT", "serie-a"),
    "FR1": ("Ligue 1",        "FR", "ligue-1"),
}

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "en-US,en;q=0.9",
}
NOMINATIM_HEADERS = {"User-Agent": "TransferApp/1.0 (football-transfer-tracker)"}
BASE_URL          = "https://www.transfermarkt.com"
NOMINATIM_URL     = "https://nominatim.openstreetmap.org/search"

if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")


# ── 시즌 인코딩 ────────────────────────────────────────────────────────────────
def encode_season(year: int) -> int:
    y = year % 100
    return y + (y + 1) % 100


# ── SQL 이스케이프 ─────────────────────────────────────────────────────────────
def esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


# ── clubs.csv 로드 → {lower(name): {stadium_name}} ──────────────────────────
def load_clubs_csv() -> dict[str, dict]:
    lookup: dict[str, dict] = {}
    try:
        with open(CLUBS_CSV, encoding="utf-8") as f:
            for row in csv.DictReader(f):
                key = row["name"].strip().lower()
                lookup[key] = {
                    "stadium": row.get("stadium_name") or None,
                }
    except FileNotFoundError:
        print(f"  [WARN] clubs.csv 없음: {CLUBS_CSV}")
    print(f"  clubs.csv 구단 수: {len(lookup)}")
    return lookup


# ── Nominatim 좌표 조회 ────────────────────────────────────────────────────────
def nominatim_lookup(query: str) -> dict:
    """반환: {"lat": float|None, "lon": float|None, "city": str|None}"""
    time.sleep(NOMINATIM_DELAY)
    try:
        res = requests.get(
            NOMINATIM_URL,
            params={"q": query, "format": "json", "limit": 1, "addressdetails": 1},
            headers=NOMINATIM_HEADERS,
            timeout=10,
        )
        hits = res.json()
        if not hits:
            return {"lat": None, "lon": None, "city": None}
        h    = hits[0]
        addr = h.get("address", {})
        city = (
            addr.get("city") or addr.get("town")
            or addr.get("village") or addr.get("municipality")
        )
        return {"lat": float(h["lat"]), "lon": float(h["lon"]), "city": city}
    except Exception as e:
        print(f"    [Nominatim SKIP] {query}: {e}")
        return {"lat": None, "lon": None, "city": None}


# ── Transfermarkt 팀 상세 → stadium_name ──────────────────────────────────────
def fetch_stadium_from_tm(tm_slug: str, tm_id: str) -> str | None:
    time.sleep(REQUEST_DELAY)
    try:
        url  = f"{BASE_URL}/{tm_slug}/startseite/verein/{tm_id}"
        res  = requests.get(url, headers=HEADERS, timeout=30)
        soup = BeautifulSoup(res.text, "html.parser")
        for li in soup.select("li.data-header__label"):
            text = li.get_text(separator="|", strip=True)
            if "Stadium" in text or "Stadion" in text:
                raw = text.split("|")[1] if "|" in text else ""
                stadium = re.sub(r"\d[\d,.\s]*Seats.*", "", raw).strip()
                return stadium or None
    except Exception as e:
        print(f"    [TM detail SKIP] {tm_slug}: {e}")
    return None


# ── 구단 상세 정보 수집 ───────────────────────────────────────────────────────
def resolve_club_detail(name: str, tm_slug: str, tm_id: str, csv_lookup: dict) -> dict:
    """
    반환: {"stadium": str|None, "lat": float|None, "lon": float|None, "city": str|None}
    """
    key     = name.lower()
    stadium = None

    # 1순위: clubs.csv
    if key in csv_lookup:
        stadium = csv_lookup[key]["stadium"]
        print(f"    [CSV] {name}: stadium={stadium}")
    else:
        # 2순위: Transfermarkt 팀 페이지
        stadium = fetch_stadium_from_tm(tm_slug, tm_id)
        print(f"    [TM] {name}: stadium={stadium}")

    # Nominatim 좌표 (stadium명 → 실패 시 club명으로 fallback)
    geo = {"lat": None, "lon": None, "city": None}
    for query in filter(None, [stadium, name]):
        geo = nominatim_lookup(query)
        if geo["lat"] is not None:
            break

    return {"stadium": stadium, **geo}


# ── 순위표에서 구단 목록 추출 ──────────────────────────────────────────────────
def fetch_clubs_in_season(comp_id: str, slug: str, year: int) -> list[dict]:
    path = f"/{slug}/startseite/wettbewerb/{comp_id}/saison_id/{year}"
    try:
        res = requests.get(BASE_URL + path, headers=HEADERS, timeout=30)
        if res.status_code == 404:
            return []
        res.raise_for_status()
    except Exception as e:
        print(f"    [SKIP] {comp_id} {year}: {e}")
        return []

    soup  = BeautifulSoup(res.text, "html.parser")
    clubs = []
    seen  = set()

    for a in soup.select("td.hauptlink a[href*='/startseite/verein/']"):
        m = re.search(r"/verein/(\d+)", a["href"])
        if not m:
            continue
        tm_id = m.group(1)
        if tm_id in seen:
            continue
        seen.add(tm_id)
        name = a.get_text(strip=True)
        if name:
            clubs.append({
                "name":    name,
                "tm_id":  tm_id,
                "tm_slug": a["href"].split("/")[1],
            })

    return clubs


# ── 메인 ──────────────────────────────────────────────────────────────────────
def main():
    csv_lookup = load_clubs_csv()

    seen_clubs: set[str]         = set()
    seen_club_seasons: set[tuple] = set()
    sql_clubs        = []
    sql_club_seasons = []

    for comp_id, (league_name, country_code, slug) in LEAGUES.items():
        print(f"\n=== {league_name} ({START_SEASON}~{END_SEASON}) ===")

        for year in range(START_SEASON, END_SEASON + 1):
            season_code  = encode_season(year)
            season_label = f"{year % 100:02d}/{(year + 1) % 100:02d}"
            time.sleep(REQUEST_DELAY)

            clubs = fetch_clubs_in_season(comp_id, slug, year)
            if not clubs:
                print(f"  {season_label}: 데이터 없음")
                continue

            print(f"  {season_label}: {len(clubs)}개 구단")

            for c in clubs:
                name = c["name"]

                # club INSERT — 처음 등장한 구단만 상세 정보 수집
                if name not in seen_clubs:
                    seen_clubs.add(name)
                    d = resolve_club_detail(name, c["tm_slug"], c["tm_id"], csv_lookup)

                    lat_sql = str(d["lat"]) if d["lat"] is not None else "NULL"
                    lon_sql = str(d["lon"]) if d["lon"] is not None else "NULL"

                    sql_clubs.append(
                        f"INSERT INTO club "
                        f"(league_id, name, country_code, city, latitude, longitude, stadium_name) "
                        f"SELECT "
                        f"(SELECT league_id FROM league WHERE name = {esc(league_name)}), "
                        f"{esc(name)}, {esc(country_code)}, "
                        f"{esc(d['city'])}, {lat_sql}, {lon_sql}, {esc(d['stadium'])} "
                        f"WHERE NOT EXISTS (SELECT 1 FROM club WHERE lower(name) = lower({esc(name)}));"
                    )

                # club_season INSERT
                key = (name, season_code)
                if key not in seen_club_seasons:
                    seen_club_seasons.add(key)
                    sql_club_seasons.append(
                        f"INSERT INTO club_season (club_id, season, league_id) "
                        f"SELECT "
                        f"COALESCE("
                        f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(name)})), "
                        f"(SELECT club_id FROM club WHERE lower(name) = lower({esc(name)}))), "
                        f"{season_code}, "
                        f"(SELECT league_id FROM league WHERE name = {esc(league_name)}) "
                        f"WHERE COALESCE("
                        f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(name)})), "
                        f"(SELECT club_id FROM club WHERE lower(name) = lower({esc(name)}))) IS NOT NULL "
                        f"ON CONFLICT (club_id, season) DO NOTHING;"
                    )

    lines = [
        "-- ============================================================",
        f"--  Transfermarkt 시즌별 1부리그 구단 이력 ({START_SEASON}~{END_SEASON})",
        "--  tm_league_history.py 자동 생성",
        "-- ============================================================",
        "",
        f"-- ── CLUB ({len(sql_clubs)}개) ──────────────────────────────────────",
        "",
    ] + sql_clubs + [
        "",
        f"-- ── CLUB_SEASON ({len(sql_club_seasons)}건) ────────────────────────",
        "",
    ] + sql_club_seasons

    with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"\n완료: {OUTPUT_SQL}")
    print(f"  신규 구단: {len(sql_clubs)}개  /  club_season: {len(sql_club_seasons)}건")


if __name__ == "__main__":
    main()
