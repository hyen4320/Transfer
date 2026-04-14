"""
Transfermarkt 스크래퍼 공통 클라이언트
인증 불필요, HTML 파싱 방식

각 리그 crawl.py 에서:
    import sys, os
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '_shared'))
    from tm_client import fetch_teams, fetch_squad, normalize_position, esc
"""

import re
import sys
import time
import requests
from bs4 import BeautifulSoup

NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
NOMINATIM_HEADERS = {"User-Agent": "TransferApp/1.0 (football-transfer-tracker)"}

# Windows cp949 콘솔에서 특수문자(ö, ü 등) 깨짐 방지
if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "en-US,en;q=0.9",
}

BASE_URL     = "https://www.transfermarkt.com"
REQUEST_DELAY = 2.0   # 서버 부하 방지


# ── 포지션 정규화 ──────────────────────────────────────────────────────────────
_POSITION_MAP = {
    "GOALKEEPER":         "GK",
    "CENTRE-BACK":        "DF", "LEFT-BACK":   "DF", "RIGHT-BACK":    "DF",
    "SWEEPER":            "DF", "DEFENDER":    "DF",
    "DEFENSIVE MIDFIELD": "MF", "CENTRAL MIDFIELD":   "MF",
    "RIGHT MIDFIELD":     "MF", "LEFT MIDFIELD":      "MF",
    "ATTACKING MIDFIELD": "MF", "MIDFIELDER":         "MF",
    "LEFT WINGER":        "FW", "RIGHT WINGER":       "FW",
    "SECOND STRIKER":     "FW", "CENTRE-FORWARD":     "FW",
    "FORWARD":            "FW", "STRIKER":            "FW",
}

def normalize_position(raw: str | None) -> str | None:
    if not raw:
        return None
    return _POSITION_MAP.get(raw.strip().upper(), raw.strip().upper())


# ── SQL 이스케이프 ─────────────────────────────────────────────────────────────
def esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


# ── HTTP GET ──────────────────────────────────────────────────────────────────
def _get(path: str) -> BeautifulSoup:
    url = BASE_URL + path
    res = requests.get(url, headers=HEADERS, timeout=15)
    res.raise_for_status()
    return BeautifulSoup(res.text, "html.parser")


# ── 리그 팀 목록 ───────────────────────────────────────────────────────────────
def fetch_teams(league_path: str, season: int = 2025) -> list[dict]:
    """
    league_path 예: '/bundesliga/startseite/wettbewerb/L1'
    반환: [{"name": ..., "id": ..., "slug": ...}, ...]
    """
    soup  = _get(f"{league_path}/saison_id/{season}")
    links = soup.select("td.hauptlink a[href*='/startseite/verein/']")

    seen, teams = set(), []
    for a in links:
        m = re.search(r"/verein/(\d+)", a["href"])
        if not m:
            continue
        team_id = m.group(1)
        if team_id in seen:
            continue
        seen.add(team_id)
        slug = a["href"].split("/")[1]
        teams.append({
            "name": a.get_text(strip=True),
            "id":   team_id,
            "slug": slug,
        })

    print(f"  {len(teams)}개 팀 확인")
    return teams


# ── 팀 스쿼드 ─────────────────────────────────────────────────────────────────
def fetch_squad(team: dict, season: int = 2025) -> list[dict]:
    """
    반환: [{"name": ..., "position": ..., "nationality": ...}, ...]
    """
    time.sleep(REQUEST_DELAY)
    path = f"/{team['slug']}/kader/verein/{team['id']}/saison_id/{season}"
    try:
        soup  = _get(path)
        rows  = soup.select("table.items tbody tr.odd, table.items tbody tr.even")
        squad = []
        for row in rows:
            tds   = row.find_all("td")
            if len(tds) < 5:
                continue
            name  = tds[3].get_text(strip=True) if len(tds) > 3 else None
            pos   = tds[4].get_text(strip=True) if len(tds) > 4 else None
            flags = row.select("img.flaggenrahmen")
            nat   = flags[0].get("title") if flags else None

            squad.append({
                "name":        name,
                "position":    normalize_position(pos),
                "nationality": nat,
            })
        print(f"    {team['name']}: {len(squad)}명")
        return squad

    except Exception as e:
        print(f"    [SKIP] {team['name']}: {e}")
        return []


# ── 팀 상세 (구장명 + 위경도) ────────────────────────────────────────────────────
def fetch_team_detail(team: dict) -> dict:
    """
    Transfermarkt 팀 홈페이지 → 구장명 스크랩
    Nominatim(OSM)          → 구장명으로 위경도 + 도시 조회
    반환: {"stadium": ..., "city": ..., "lat": ..., "lon": ...}
    """
    time.sleep(REQUEST_DELAY)
    result = {"stadium": None, "city": None, "lat": None, "lon": None}

    # 1) Transfermarkt 구장명
    try:
        soup = _get(f"/{team['slug']}/startseite/verein/{team['id']}")
        for li in soup.select("li.data-header__label"):
            text = li.get_text(separator="|", strip=True)
            if "Stadium" in text:
                raw = text.split("|")[1] if "|" in text else ""
                result["stadium"] = re.sub(r"\d[\d,.\s]*Seats.*", "", raw).strip() or None
                break
    except Exception as e:
        print(f"    [TM detail SKIP] {team['name']}: {e}")

    # 2) Nominatim 위경도 + 도시
    # 구장명 → 실패 시 클럽명으로 fallback
    queries = []
    if result["stadium"]:
        queries.append(result["stadium"])
    queries.append(team["name"])

    for query in queries:
        try:
            time.sleep(1.1)   # Nominatim 1 req/s 정책
            res = requests.get(
                NOMINATIM_URL,
                params={"q": query, "format": "json", "limit": 1, "addressdetails": 1},
                headers=NOMINATIM_HEADERS,
                timeout=10,
            )
            hits = res.json()
            if hits:
                h = hits[0]
                result["lat"] = float(h["lat"])
                result["lon"] = float(h["lon"])
                addr = h.get("address", {})
                result["city"] = (
                    addr.get("city")
                    or addr.get("town")
                    or addr.get("village")
                    or addr.get("municipality")
                )
                break   # 성공하면 fallback 불필요
        except Exception as e:
            print(f"    [Nominatim SKIP] {team['name']} ({query}): {e}")

    print(f"    {team['name']}: stadium={result['stadium']} city={result['city']}")
    return result


# ── SQL 빌더 ──────────────────────────────────────────────────────────────────
def build_sql(
    league_name: str,
    country_code: str,
    tier: int,
    season: int,
    teams: list[dict],        # fetch_team_detail 결과가 team["detail"] 에 병합돼 있음
    all_players: list[dict],  # 각 항목에 "club_name" 키 포함
) -> str:
    """
    IDENTITY 전략 기준 — ID 컬럼 없이 INSERT 생성.
    club 참조는 서브쿼리로 처리합니다.
    team dict 에 "detail" 키가 있으면 stadium / city / lat / lon 을 채웁니다.
    """
    lines = [
        f"-- =====================================================",
        f"-- {league_name} {season}/{season % 100 + 1} 기초 데이터",
        f"-- Transfermarkt 크롤링으로 자동 생성",
        f"-- =====================================================",
        "",
        "-- ── LEAGUE ──────────────────────────────────────────",
        f"INSERT INTO league (name, country_code, logo_url, tier) VALUES "
        f"({esc(league_name)}, {esc(country_code)}, NULL, {tier});",
        "",
        "-- ── CLUB ────────────────────────────────────────────",
    ]

    for team in teams:
        d = team.get("detail", {})
        lat = f"{d['lat']}" if d.get("lat") is not None else "NULL"
        lon = f"{d['lon']}" if d.get("lon") is not None else "NULL"
        lines.append(
            f"INSERT INTO club "
            f"(league_id, name, short_name, logo_url, city, country_code, latitude, longitude, stadium_name) VALUES "
            f"((SELECT league_id FROM league WHERE name = {esc(league_name)}), "
            f"{esc(team['name'])}, NULL, NULL, "
            f"{esc(d.get('city'))}, {esc(country_code)}, "
            f"{lat}, {lon}, {esc(d.get('stadium'))});"
        )

    lines += ["", "-- ── PLAYER ──────────────────────────────────────────"]
    for p in all_players:
        lines.append(
            f"INSERT INTO player "
            f"(name, nationality, position, current_club_id, contract_until, profile_image_url) VALUES "
            f"({esc(p['name'])}, {esc(p['nationality'])}, {esc(p['position'])}, "
            f"(SELECT club_id FROM club WHERE name = {esc(p['club_name'])}), NULL, NULL);"
        )

    return "\n".join(lines)
