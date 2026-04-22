"""
이적 데이터 수집 공통 로직
각 리그 TransferNews/crawl.py 에서 import 해서 사용합니다.

사용법:
    import sys, os
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', '_shared'))
    from tm_transfers import run_league
"""

import os, re, sys, time
from datetime import datetime

from tm_client import _get, fetch_teams, esc, REQUEST_DELAY

# ── 상수 ──────────────────────────────────────────────────────────────────────
SEASON    = 2025   # Transfermarkt saison_id (25/26 시즌)
DB_SEASON = 51     # 25+26=51


# ── 날짜 유틸 ──────────────────────────────────────────────────────────────────
_DATE_FORMATS = [
    "%d.%m.%y",   # 15.06.25
    "%d.%m.%Y",   # 15.06.2025
    "%b %d, %Y",  # Jun 15, 2025
    "%B %d, %Y",  # June 15, 2025
    "%Y-%m-%d",   # 2025-06-15
]


def _parse_date(date_str: str) -> datetime | None:
    for fmt in _DATE_FORMATS:
        try:
            return datetime.strptime(date_str.strip(), fmt)
        except ValueError:
            continue
    return None


def determine_window(date_str: str) -> str | None:
    """날짜 문자열 → 'SUMMER'(6~9월) / 'WINTER'(1~2월) / None"""
    if not date_str:
        return None
    dt = _parse_date(date_str)
    if dt is None:
        return None
    if dt.month in (6, 7, 8, 9):
        return "SUMMER"
    if dt.month in (1, 2):
        return "WINTER"
    return None


def to_iso(date_str: str) -> str:
    """날짜 문자열 → SQL 'YYYY-MM-DD' 리터럴, 실패 시 NOW()"""
    dt = _parse_date(date_str)
    if dt:
        return f"'{dt.strftime('%Y-%m-%d')}'"
    return "NOW()"


# ── 이적료 파싱 ────────────────────────────────────────────────────────────────
def parse_fee(fee_text: str) -> tuple[int | None, str]:
    """
    반환: (fee_eur, status)
      임대  → (None, 'LOAN')
      무료  → (0,    'CONFIRMED')
      금액  → (int,  'CONFIRMED')
      불명  → (None, 'CONFIRMED')
    """
    t = fee_text.strip().lower()
    if not t or t in ("-", "?"):
        return None, "CONFIRMED"
    if any(w in t for w in ("loan", "leihe", "prestito", "prêt")):
        return None, "LOAN"
    if any(w in t for w in ("free", "ablösefrei", "svincolato", "libre")):
        return 0, "CONFIRMED"

    m = re.search(r"[\d.,]+", t)
    if not m:
        return None, "CONFIRMED"

    num = float(m.group(0).replace(",", "."))
    if any(w in t for w in ("bn", "mrd")):
        num *= 1_000_000_000
    elif "m" in t:
        num *= 1_000_000
    elif "k" in t or "tsd" in t:
        num *= 1_000

    return int(num), "CONFIRMED"


# ── 스크래핑 ──────────────────────────────────────────────────────────────────
def fetch_arrivals(team: dict) -> list[dict]:
    """
    전체 이적 페이지에서 Zugänge 섹션 헤딩으로 SUMMER/WINTER 구분.
    헤딩 예: 'Zugänge Sommer 2025', 'Zugänge Winter 2025/26'
    """
    time.sleep(REQUEST_DELAY)
    path = f"/{team['slug']}/transfers/verein/{team['id']}/saison_id/{SEASON}"
    try:
        soup = _get(path)
    except Exception as e:
        print(f"    [SKIP] {team['name']}: {e}")
        return []

    results   = []
    current_window = None  # 현재 섹션 윈도우

    # 페이지 최상위 요소를 순서대로 순회하며 헤딩→테이블 관계 파악
    for el in soup.find_all(["h2", "h3", "table"]):
        if el.name in ("h2", "h3"):
            text = el.get_text(strip=True).lower()
            is_arrival  = "zugänge" in text or "arrivals" in text
            is_summer   = "sommer" in text or "summer" in text
            is_winter   = "winter" in text
            is_departure = "abgänge" in text or "departures" in text

            if is_departure:
                current_window = None   # departures 섹션 → 무시
            elif is_arrival and is_summer:
                current_window = "SUMMER"
            elif is_arrival and is_winter:
                current_window = "WINTER"
            elif is_arrival:
                # 'Zugänge' 만 있고 윈도우 미표기 → 전체(양쪽) 헤딩인 경우
                current_window = "UNKNOWN"

        elif el.name == "table" and "items" in (el.get("class") or []):
            if current_window not in ("SUMMER", "WINTER"):
                continue
            for row in el.select("tbody tr.odd, tbody tr.even"):
                t = _parse_row(row, team["name"])
                if t:
                    results.append({**t, "window": current_window})

    summer_n = sum(1 for r in results if r["window"] == "SUMMER")
    winter_n = sum(1 for r in results if r["window"] == "WINTER")
    print(f"    {team['name']}: SUMMER {summer_n} / WINTER {winter_n}")
    return results


def _parse_row(row, to_club_name: str) -> dict | None:
    player_link = row.select_one("a[href*='/profil/spieler/']")
    if not player_link:
        return None
    player_name = player_link.get_text(strip=True)
    if not player_name:
        return None

    flags = row.select("img.flaggenrahmen, img.flagge")
    nationality = flags[0].get("title") if flags else None

    other_club = None
    for a in row.select("a[href*='/startseite/verein/'], a[href*='/verein/']"):
        name = a.get_text(strip=True)
        if name and name != to_club_name:
            other_club = name
            break

    fee_td = row.select_one("td.rechts.hauptlink") or row.select_one("td.rechts")
    fee_text = fee_td.get_text(strip=True) if fee_td else ""

    return {
        "player":      player_name,
        "nationality": nationality,
        "from_club":   other_club,
        "to_club":     to_club_name,
        "fee_text":    fee_text,
    }


# ── SQL 생성 ──────────────────────────────────────────────────────────────────
def build_sql(league_name: str, all_transfers: list[dict]) -> str:
    summer = [t for t in all_transfers if t.get("window") == "SUMMER"]
    winter = [t for t in all_transfers if t.get("window") == "WINTER"]
    print(f"  SUMMER {len(summer)}건 / WINTER {len(winter)}건")

    lines = [
        f"-- ============================================================",
        f"--  {league_name} 25/26 이적시장 데이터  (season={DB_SEASON})",
        f"--  Transfermarkt 크롤링으로 자동 생성",
        f"--  전제: league / club 기초 데이터 적재 완료",
        f"-- ============================================================",
        "",
        "-- ── 시스템 기자 (임포트용 더미) ─────────────────────────────",
        "INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)",
        "SELECT 'transfermarkt_bot', '0', 'Transfermarkt Import Bot', 0, NOW()",
        "WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'transfermarkt_bot');",
        "",
    ]

    for window_label, transfers in [("SUMMER", summer), ("WINTER", winter)]:
        if not transfers:
            continue
        lines += [
            f"-- ═══════════════════════════════════════════════════════════",
            f"--  {window_label} — {len(transfers)}건",
            f"-- ═══════════════════════════════════════════════════════════",
            "",
        ]
        for idx, t in enumerate(transfers, start=1):
            fee_eur, status = parse_fee(t["fee_text"])
            # 공백 제거한 리그 코드 (La Liga → LALI, Serie A → SERI 등)
            league_code     = re.sub(r"\s+", "", league_name)[:4].upper()
            post_id_str     = f"TM_{league_code}_{window_label}_{idx:04d}"
            published_at    = t.get("date_iso", "NOW()")
            fee_sql         = str(fee_eur) if fee_eur is not None else "NULL"
            # LOANED는 contract_status NULL (임대 중 — 소속 미확정)
            contract_status = "NULL" if status == "LOAN" else "'CONTRACTED'"
            post_content    = (
                f"{t['player']}: {t['from_club'] or 'FA'} → {t['to_club']}"
                f" [{t['fee_text'] or 'fee unknown'}] #Transfermarkt"
            )
            from_club_sub   = (
                f"COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(t['from_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {esc(t['from_club'])}))"
                if t["from_club"] else "NULL"
            )

            lines += [
                f"-- [{idx}] {t['player']}  {t['from_club'] or 'FA'} → {t['to_club']}  {t['fee_text'] or '-'}",
                # player: name NOT NULL, position 없으면 NULL OK
                f"INSERT INTO player (name, nationality, position, contract_status)",
                f"SELECT {esc(t['player'])}, {esc(t['nationality'])}, NULL, {contract_status}",
                f"WHERE NOT EXISTS (SELECT 1 FROM player WHERE name = {esc(t['player'])});",
                "",
                # post: x_post_id UNIQUE NOT NULL, collected_at은 @PrePersist 대신 NOW()
                f"INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at) VALUES (",
                f"    (SELECT journalist_id FROM journalist WHERE x_handle = 'transfermarkt_bot'),",
                f"    {esc(post_id_str)}, {esc(post_content)}, {published_at}, NOW());",
                "",
                f"INSERT INTO transfer_news",
                f"    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)",
                f"SELECT",
                f"    (SELECT post_id FROM post WHERE x_post_id = {esc(post_id_str)}),",
                f"    (SELECT player_id FROM player WHERE name = {esc(t['player'])}),",
                f"    {from_club_sub},",
                f"    COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {esc(t['to_club'])})),",
                f"    {fee_sql}, {esc(status)}, {DB_SEASON}, {esc(window_label)}, {published_at}",
                f"WHERE COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {esc(t['to_club'])})) IS NOT NULL",
                f"  AND (SELECT player_id FROM player WHERE name = {esc(t['player'])}) IS NOT NULL;",
                "",
            ]

    return "\n".join(lines)


# ── 리그 실행 진입점 ───────────────────────────────────────────────────────────
def run_league(league_name: str, tm_path: str, out_sql: str) -> list[dict]:
    """
    한 리그의 이적 데이터를 수집하고 SQL 파일을 생성합니다.
    반환값: 수집된 transfer dict 목록 (combine 용)
    """
    print(f"\n=== {league_name} ===")
    teams = fetch_teams(tm_path, SEASON)

    all_transfers = []
    for team in teams:
        for t in fetch_arrivals(team):
            all_transfers.append({
                **t,
                "league":   league_name,
                "date_iso": "NOW()",
            })

    print(f"  총 {len(all_transfers)}건")
    sql = build_sql(league_name, all_transfers)
    os.makedirs(os.path.dirname(out_sql), exist_ok=True)
    with open(out_sql, "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"  → {out_sql}")
    return all_transfers
