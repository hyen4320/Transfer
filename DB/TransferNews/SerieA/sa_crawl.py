"""
Serie A 25/26 이적 데이터 수집 — worldfootball.net 기반

실행:
    cd D:\\Transfer\\DB\\TransferNews\\SerieA
    python sa_crawl.py

출력:
    transfer_news_seriea_sa_2526.sql
"""
import os, re, sys, time
import requests
from bs4 import BeautifulSoup

if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

# ── 상수 ──────────────────────────────────────────────────────────────────────
DB_SEASON   = 51
LEAGUE_NAME = "Serie A"
BOT_HANDLE  = "sa_import_bot"
BOT_NAME    = "Serie A Import Bot"
POST_PREFIX = "WF_SA"
OUT_SQL     = os.path.join(os.path.dirname(__file__), "transfer_news_seriea_sa_2526.sql")

WF_BASE       = "https://www.worldfootball.net"
WF_SLUG       = "ita-serie-a-2025-2026"
REQUEST_DELAY = 2.0

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                  "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Referer": "https://www.worldfootball.net/",
}

# worldfootball.net 표시명 → DB 클럽명
CLUB_NAME_MAP: dict[str, str] = {
    "Internazionale":    "Inter Milan",
    "FC Internazionale": "Inter Milan",
    "Inter":             "Inter Milan",
    "AC Milan":          "AC Milan",
    "AS Roma":           "AS Roma",
    "SSC Napoli":        "Napoli",
    "Hellas Verona":     "Hellas Verona FC",
    "Cagliari Calcio":   "Cagliari",
    "US Lecce":          "Lecce",
    "Como 1907":         "Como",
}

_MONTH_TO_WINDOW = {m: "SUMMER" for m in range(6, 10)}
_MONTH_TO_WINDOW.update({m: "WINTER" for m in (1, 2)})


# ── 유틸 ──────────────────────────────────────────────────────────────────────
def _normalize(name: str) -> str:
    return CLUB_NAME_MAP.get(name, name)


def _esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


def _get(url: str) -> BeautifulSoup:
    time.sleep(REQUEST_DELAY)
    r = requests.get(url, headers=HEADERS, timeout=30)
    r.raise_for_status()
    return BeautifulSoup(r.text, "html.parser")


def parse_fee(fee_text: str) -> tuple[int | None, str]:
    t = fee_text.strip().lower()
    if not t or t in ("-", "?", ""):
        return None, "CONFIRMED"
    if any(w in t for w in ("loan", "leihe", "lend", "prestito", "ausleihe")):
        return None, "LOAN"
    if any(w in t for w in ("free", "ablösefrei", "bosman", "svincolato")):
        return 0, "CONFIRMED"
    m = re.search(r"[\d.,]+", t)
    if not m:
        return None, "CONFIRMED"
    num = float(m.group(0).replace(",", "."))
    if "mrd" in t or "bn" in t:
        num *= 1_000_000_000
    elif "mio" in t or ("m" in t and "mrd" not in t):
        num *= 1_000_000
    elif "tsd" in t or "k" in t:
        num *= 1_000
    return int(num), "CONFIRMED"


# ── 스크래핑 ──────────────────────────────────────────────────────────────────
def _parse_date_month(date_str: str) -> int | None:
    m = re.search(r"(\d{2})[./](\d{2})[./](\d{4})", date_str)
    if m:
        return int(m.group(2))
    m = re.search(r"(\d{4})-(\d{2})-(\d{2})", date_str)
    if m:
        return int(m.group(2))
    return None


def _parse_row(cells: list) -> dict | None:
    if len(cells) < 5:
        return None

    player_link = None
    for cell in cells:
        a = cell.select_one("a[href*='/spieler_profil/']")
        if a:
            player_link = a
            break
    if not player_link:
        return None
    player_name = player_link.get_text(strip=True)
    if not player_name:
        return None

    flag_img = None
    for cell in cells:
        img = cell.select_one("img[title]")
        if img and img.get("src", ""):
            flag_img = img
            break
    nationality = flag_img.get("title") if flag_img else None

    club_links = []
    for cell in cells:
        for a in cell.select("a[href*='/teams/']"):
            name = a.get_text(strip=True)
            if name:
                club_links.append(name)

    if len(club_links) < 2:
        return None
    from_club = _normalize(club_links[0])
    to_club   = _normalize(club_links[1])

    fee_text = cells[-1].get_text(strip=True)

    date_month = None
    for cell in cells:
        txt = cell.get_text(strip=True)
        mo = _parse_date_month(txt)
        if mo:
            date_month = mo
            break

    return {
        "player":      player_name,
        "nationality": nationality,
        "from_club":   from_club,
        "to_club":     to_club,
        "fee_text":    fee_text,
        "date_month":  date_month,
    }


def fetch_transfers() -> list[dict]:
    results = []
    page = 1
    while True:
        url = f"{WF_BASE}/transfers/{WF_SLUG}/{page}/"
        print(f"  fetching: {url}")
        try:
            soup = _get(url)
        except requests.HTTPError as e:
            if e.response.status_code == 404:
                break
            raise

        tables = soup.select("table.standard_tabelle")
        if not tables:
            if page == 1:
                print("  [WARN] table.standard_tabelle 미발견 — 페이지 구조 확인 필요")
                for t in soup.find_all("table"):
                    print(f"    table class={t.get('class')}")
            break

        found = 0
        for table in tables:
            for row in table.select("tr.odd, tr.even"):
                cells = row.select("td")
                t = _parse_row(cells)
                if t:
                    results.append(t)
                    found += 1

        print(f"    page {page}: {found}건")
        if found == 0:
            break
        page += 1

    return results


# ── SQL 생성 ──────────────────────────────────────────────────────────────────
def build_sql(all_transfers: list[dict]) -> str:
    def window_of(t: dict) -> str:
        mo = t.get("date_month")
        if mo:
            return _MONTH_TO_WINDOW.get(mo, "SUMMER")
        return "SUMMER"

    summer = [t for t in all_transfers if window_of(t) == "SUMMER"]
    winter = [t for t in all_transfers if window_of(t) == "WINTER"]
    print(f"  SUMMER {len(summer)}건 / WINTER {len(winter)}건")

    lines = [
        "-- ============================================================",
        f"--  {LEAGUE_NAME} 25/26 이적시장 데이터  (season={DB_SEASON})",
        "--  worldfootball.net 크롤링으로 자동 생성",
        "--  전제: league / club 기초 데이터 적재 완료",
        "-- ============================================================",
        "",
        "-- ── 시스템 기자 (임포트용 더미) ─────────────────────────────",
        "INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)",
        f"SELECT {_esc(BOT_HANDLE)}, '0', {_esc(BOT_NAME)}, 0, NOW()",
        f"WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = {_esc(BOT_HANDLE)});",
        "",
    ]

    for window_label, transfers in [("SUMMER", summer), ("WINTER", winter)]:
        if not transfers:
            continue
        lines += [
            "-- ═══════════════════════════════════════════════════════════",
            f"--  {window_label} — {len(transfers)}건",
            "-- ═══════════════════════════════════════════════════════════",
            "",
        ]
        for idx, t in enumerate(transfers, start=1):
            fee_eur, status    = parse_fee(t["fee_text"])
            post_id_str        = f"{POST_PREFIX}_{window_label}_{idx:04d}"
            fee_sql            = str(fee_eur) if fee_eur is not None else "NULL"
            contract_status    = "NULL" if status == "LOAN" else "'CONTRACTED'"
            post_content       = (
                f"{t['player']}: {t['from_club'] or 'FA'} \u2192 {t['to_club']}"
                f" [{t['fee_text'] or 'fee unknown'}] #{LEAGUE_NAME.replace(' ', '')}"
            )
            from_club_sub = (
                f"COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['from_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['from_club'])}))"
                if t["from_club"] else "NULL"
            )

            lines += [
                f"-- [{idx}] {t['player']}  {t['from_club'] or 'FA'} -> {t['to_club']}  {t['fee_text'] or '-'}",
                "INSERT INTO player (name, nationality, position, contract_status)",
                f"SELECT {_esc(t['player'])}, {_esc(t['nationality'])}, NULL, {contract_status}",
                f"WHERE NOT EXISTS (SELECT 1 FROM player WHERE name = {_esc(t['player'])});",
                "",
                "INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)",
                f"SELECT (SELECT journalist_id FROM journalist WHERE x_handle = {_esc(BOT_HANDLE)}),",
                f"    {_esc(post_id_str)}, {_esc(post_content)}, NOW(), NOW()",
                f"WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = {_esc(post_id_str)});",
                "",
                "INSERT INTO transfer_news",
                "    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)",
                "SELECT",
                f"    (SELECT post_id FROM post WHERE x_post_id = {_esc(post_id_str)}),",
                f"    (SELECT player_id FROM player WHERE name = {_esc(t['player'])}),",
                f"    {from_club_sub},",
                f"    COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['to_club'])})),",
                f"    {fee_sql}, {_esc(status)}, {DB_SEASON}, {_esc(window_label)}, NOW()",
                f"WHERE COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['to_club'])})) IS NOT NULL",
                f"  AND (SELECT player_id FROM player WHERE name = {_esc(t['player'])}) IS NOT NULL;",
                "",
            ]

    return "\n".join(lines)


# ── 메인 ──────────────────────────────────────────────────────────────────────
def main():
    print(f"\n=== {LEAGUE_NAME} worldfootball.net 크롤링 ===")
    transfers = fetch_transfers()
    print(f"\n  총 {len(transfers)}건 수집")
    if not transfers:
        print("  [ERROR] 수집 결과 없음. URL/파싱 로직 확인 필요.")
        return
    sql = build_sql(transfers)
    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"\n  -> {OUT_SQL}")


if __name__ == "__main__":
    main()
