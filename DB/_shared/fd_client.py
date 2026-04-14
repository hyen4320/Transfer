"""
football-data.org API 공통 클라이언트
각 리그 crawl.py 에서 import 해서 사용합니다.

사용법:
    import sys, os
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '_shared'))
    from fd_client import api_get, fetch_teams, fetch_squad, normalize_position, esc
"""

import os
import time
import requests

# ── 인증 ──────────────────────────────────────────────────────────────────────
API_KEY  = os.getenv("FD_API_KEY", "591463f343674b17a2b7f4d758ec611b")
BASE_URL = "https://api.football-data.org/v4"
HEADERS  = {"X-Auth-Token": API_KEY}

REQUEST_DELAY = 6.5   # 무료 플랜 10 req/min 제한


# ── 포지션 정규화 ──────────────────────────────────────────────────────────────
_POSITION_MAP = {
    "GOALKEEPER":        "GK",
    "CENTRE-BACK":       "DF", "RIGHT-BACK":  "DF", "LEFT-BACK": "DF",
    "DEFENCE":           "DF", "DEFENDER":    "DF",
    "CENTRAL MIDFIELD":  "MF", "DEFENSIVE MIDFIELD": "MF",
    "ATTACKING MIDFIELD":"MF", "RIGHT MIDFIELD": "MF",
    "LEFT MIDFIELD":     "MF", "MIDFIELD":    "MF", "MIDFIELDER": "MF",
    "CENTRE-FORWARD":    "FW", "LEFT WINGER": "FW", "RIGHT WINGER": "FW",
    "OFFENCE":           "FW", "FORWARD":     "FW", "STRIKER":    "FW",
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


# ── API 호출 ──────────────────────────────────────────────────────────────────
def api_get(path: str) -> dict:
    url = f"{BASE_URL}{path}"
    res = requests.get(url, headers=HEADERS, timeout=15)
    if res.status_code == 429:
        print("  [rate limit] 60초 대기...")
        time.sleep(60)
        res = requests.get(url, headers=HEADERS, timeout=15)
    res.raise_for_status()
    return res.json()


def fetch_teams(fd_code: str, season: int = 2024) -> list[dict]:
    """리그 소속 팀 목록 반환.
    competition teams 엔드포인트에 squad가 포함된 경우 그대로 활용합니다.
    """
    data  = api_get(f"/competitions/{fd_code}/teams?season={season}")
    teams = data.get("teams", [])
    print(f"  [{fd_code}] {len(teams)}개 팀 확인")
    return teams


def fetch_squad(team: dict) -> list[dict]:
    """팀 스쿼드 반환.

    1순위: team 객체에 이미 squad 포함 → 추가 요청 없이 반환
    2순위: /teams/{id} 개별 호출 → 무료 플랜 403 시 빈 리스트로 graceful skip
    """
    # competition/teams 응답에 squad가 내장된 경우 재사용
    if team.get("squad"):
        return team["squad"]

    time.sleep(REQUEST_DELAY)
    try:
        data = api_get(f"/teams/{team['id']}")
        squad = data.get("squad", [])
        if not squad:
            print(f"    [WARN] {team['name']}: 스쿼드 데이터 없음 (빈 squad)")
        return squad
    except Exception as e:
        status = getattr(getattr(e, "response", None), "status_code", None)
        if status == 403:
            print(f"    [403] {team['name']}: 무료 플랜 접근 제한 — 건너뜀")
        else:
            print(f"    [SKIP] {team['name']}: {e}")
        return []
