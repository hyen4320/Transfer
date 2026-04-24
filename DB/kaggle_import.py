"""
Kaggle Transfermarkt 데이터 → transfer_news SQL 생성기
대상: 유럽 5대 리그 (EPL, Bundesliga, La Liga, Serie A, Ligue 1)
실행: python DB/kaggle_import.py
출력: DB/kaggle_transfers.sql
"""

import csv
import os
import re
from datetime import datetime

# ── 경로 ──────────────────────────────────────────────────────────────────────
BASE        = os.path.dirname(__file__)
CLUBS_CSV   = os.path.join(BASE, "clubs.csv")
PLAYERS_CSV = os.path.join(BASE, "players.csv")
TRANS_CSV   = os.path.join(BASE, "transfers.csv")
OUTPUT_SQL  = os.path.join(BASE, "kaggle_transfers.sql")

# ── 시즌 필터 (tm_league_history.py 와 동일 범위) ─────────────────────────────
START_YEAR = 2000   # 2000/01 시즌부터
END_YEAR   = 2025   # 2025/26 시즌까지

# ── 포지션 정규화 ────────────────────────────────────────────────────────────
_POS_MAP = {
    "goalkeeper":       "GK",
    "centre-back":      "DF", "left-back":  "DF", "right-back":     "DF", "defender": "DF",
    "defensive midfield": "MF", "central midfield": "MF", "attacking midfield": "MF",
    "right midfield":   "MF", "left midfield": "MF", "midfielder": "MF",
    "left winger":      "FW", "right winger": "FW", "centre-forward": "FW",
    "second striker":   "FW", "forward": "FW", "striker": "FW",
    "attack":           "FW", "midfield": "MF", "defence": "DF",
}

def normalize_position(sub_pos: str, broad_pos: str) -> str | None:
    key = (sub_pos or "").strip().lower()
    if key in _POS_MAP:
        return _POS_MAP[key]
    key = (broad_pos or "").strip().lower()
    return _POS_MAP.get(key)


# ── 5대 리그 Transfermarkt competition ID ────────────────────────────────────
MAJOR_LEAGUES = {
    "GB1": "Premier League",
    "L1":  "Bundesliga",
    "ES1": "La Liga",
    "IT1": "Serie A",
    "FR1": "Ligue 1",
}

# ── 시즌 인코딩: "25/26" → 51 ─────────────────────────────────────────────────
def encode_season(season_str: str) -> int | None:
    m = re.match(r"(\d{2})/(\d{2})", season_str or "")
    if not m:
        return None
    return int(m.group(1)) + int(m.group(2))


# ── 이적 윈도우: 날짜 → SUMMER/WINTER ─────────────────────────────────────────
def transfer_window(date_str: str) -> str | None:
    try:
        month = datetime.strptime(date_str, "%Y-%m-%d").month
    except (ValueError, TypeError):
        return None
    if month in (6, 7, 8, 9):
        return "SUMMER"
    if month in (1, 2):
        return "WINTER"
    return None


# ── 이적료 → (fee_eur int | None, status) ─────────────────────────────────────
def parse_fee(val: str) -> tuple[int | None, str]:
    try:
        f = float(val)
    except (ValueError, TypeError):
        return None, "CONFIRMED"
    if f == 0.0:
        return 0, "CONFIRMED"
    return int(f), "CONFIRMED"


# ── SQL 이스케이프 ─────────────────────────────────────────────────────────────
def esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


def club_sub(name: str | None) -> str:
    if not name:
        return "NULL"
    return (
        f"COALESCE("
        f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(name)})),"
        f"(SELECT club_id FROM club WHERE lower(name) = lower({esc(name)})))"
    )


# ── 메인 ──────────────────────────────────────────────────────────────────────
def main():
    # 1) players.csv → player_id 기준 룩업 테이블
    print("players.csv 로드 중...")
    players: dict[str, dict] = {}
    with open(PLAYERS_CSV, encoding="utf-8") as f:
        for row in csv.DictReader(f):
            players[row["player_id"]] = {
                "nationality":   row.get("country_of_citizenship") or None,
                "position":      normalize_position(row.get("sub_position"), row.get("position")),
                "contract_until": (row.get("contract_expiration_date") or "")[:10] or None,
                "image_url":     row.get("image_url") or None,
            }
    print(f"  선수 수: {len(players):,}")

    # 3) 5대 리그 club_id 수집
    major_club_ids: set[str] = set()

    print("clubs.csv 로드 중...")
    with open(CLUBS_CSV, encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if row["domestic_competition_id"] in MAJOR_LEAGUES:
                major_club_ids.add(row["club_id"])

    print(f"  5대 리그 구단 수: {len(major_club_ids)}")

    # 4) transfers 필터링 (5대 리그 + 시즌 범위)
    print(f"transfers.csv 필터링 중... ({START_YEAR}/01~{END_YEAR}/26)")
    transfers: list[dict] = []
    with open(TRANS_CSV, encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if row["from_club_id"] not in major_club_ids and row["to_club_id"] not in major_club_ids:
                continue
            season = encode_season(row.get("transfer_season", ""))
            if season is None:
                continue
            # 시즌 인코딩 범위: START_YEAR의 encode ~ END_YEAR의 encode
            start_enc = (START_YEAR % 100) + (START_YEAR % 100 + 1) % 100
            end_enc   = (END_YEAR   % 100) + (END_YEAR   % 100 + 1) % 100
            if not (start_enc <= season <= end_enc):
                continue
            transfers.append(row)

    print(f"  필터링 결과: {len(transfers):,}건")

    # 5) SQL 생성
    print("SQL 생성 중...")
    lines = [
        "-- ============================================================",
        "--  Kaggle Transfermarkt 데이터 임포트 (5대 리그)",
        "--  kaggle_import.py 자동 생성",
        "-- ============================================================",
        "",
        "INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)",
        "SELECT 'kaggle_bot', '0', 'Kaggle Import Bot', 0, NOW()",
        "WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'kaggle_bot');",
        "",
    ]

    skipped = 0
    for idx, t in enumerate(transfers, 1):
        season  = encode_season(t.get("transfer_season", ""))
        window  = transfer_window(t.get("transfer_date", ""))
        fee_eur, status = parse_fee(t.get("transfer_fee"))

        player     = t.get("player_name", "").strip()
        from_club  = t.get("from_club_name", "").strip() or None
        to_club    = t.get("to_club_name", "").strip() or None

        if not player or not to_club or season is None:
            skipped += 1
            continue

        p_info   = players.get(t.get("player_id", ""), {})
        post_id  = f"KAGGLE_{idx:06d}"
        fee_sql  = str(fee_eur) if fee_eur is not None else "NULL"
        win_sql  = esc(window)
        date_sql = esc(t.get("transfer_date")) if t.get("transfer_date") else "NOW()"
        content  = f"{player}: {from_club or 'FA'} → {to_club} [{t.get('transfer_fee') or '-'}] #Kaggle"

        nat_sql      = esc(p_info.get("nationality"))
        pos_sql      = esc(p_info.get("position"))
        contract_sql = esc(p_info.get("contract_until"))
        image_sql    = esc(p_info.get("image_url"))

        lines += [
            f"-- [{idx}] {player}  {from_club or 'FA'} → {to_club}",
            "INSERT INTO player (name, nationality, position, contract_until, profile_image_url, contract_status)",
            f"SELECT {esc(player)}, {nat_sql}, {pos_sql}, {contract_sql}, {image_sql}, 'CONTRACTED'",
            f"WHERE NOT EXISTS (SELECT 1 FROM player WHERE name = {esc(player)});",
            "",
            "INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)",
            f"SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'kaggle_bot'),",
            f"    {esc(post_id)}, {esc(content)}, {date_sql}, NOW()",
            f"WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = {esc(post_id)});",
            "",
            "INSERT INTO transfer_news",
            "    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)",
            "SELECT",
            f"    (SELECT post_id FROM post WHERE x_post_id = {esc(post_id)}),",
            f"    (SELECT player_id FROM player WHERE name = {esc(player)}),",
            f"    {club_sub(from_club)},",
            f"    {club_sub(to_club)},",
            f"    {fee_sql}, {esc(status)}, {season}, {win_sql}, {date_sql}",
            f"WHERE (SELECT player_id FROM player WHERE name = {esc(player)}) IS NOT NULL",
            f"  AND {club_sub(to_club)} IS NOT NULL;",
            "",
        ]

    print(f"  스킵 (선수명/구단/시즌 누락): {skipped}건")

    with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"완료: {OUTPUT_SQL}  ({len(transfers) - skipped:,}건 SQL 생성)")


if __name__ == "__main__":
    main()
