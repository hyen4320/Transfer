"""
Premier League 공식 사이트 기반 EPL 25/26 이적 데이터 수집

출처:
  SUMMER: https://www.premierleague.com/en/transfers/2025-26/summer (정적 HTML)
  WINTER: https://www.premierleague.com/en/transfers/2025-26/january (JS 렌더링, Selenium)

실행:
    cd D:\\Transfer\\DB\\TransferNews\\EPL
    python pl_crawl.py

출력:
    transfer_news_epl_pl_2526.sql
"""

import os, re, sys, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_shared"))

import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

# ── 상수 ──────────────────────────────────────────────────────────────────────
SEASON       = 51   # DB season (25+26)
LEAGUE_NAME  = "Premier League"
OUT_SQL      = os.path.join(os.path.dirname(__file__), "transfer_news_epl_pl_2526.sql")

SUMMER_URL   = "https://www.premierleague.com/en/transfers/2025-26/summer"
WINTER_URL   = "https://www.premierleague.com/en/transfers/2025-26/january"

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
    )
}

# PL 사이트 클럽명 → DB 클럽명 매핑 (차이가 있는 경우만)
CLUB_NAME_MAP = {
    "Bournemouth":               "AFC Bournemouth",
    "Brighton and Hove Albion":  "Brighton & Hove Albion",
    "Wolverhampton Wanderers":   "Wolves",
}

# 이적 타입 → (window_direction, status)
# direction: 'in' = 해당 클럽으로 영입, 'out' = 방출/이적 나감
ICON_MAP = {
    "transfer-in":  ("in",  "CONFIRMED"),
    "loan-in":      ("in",  "LOAN"),
    "loan-recall":  ("in",  "LOAN"),    # 임대 복귀 = EPL 클럽으로 돌아옴
    "transfer-out": ("out", "CONFIRMED"),
    "loan-out":     ("out", "LOAN"),
}


def _normalize_club(name: str) -> str:
    return CLUB_NAME_MAP.get(name, name)


def _esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


# ── SUMMER: 정적 HTML 크롤링 ──────────────────────────────────────────────────
def fetch_summer() -> list[dict]:
    """premierleague.com/en/transfers/2025-26/summer 파싱 (requests + BS4)"""
    print("  [SUMMER] 정적 HTML 크롤링 중...")
    res = requests.get(SUMMER_URL, headers=HEADERS, timeout=15)
    res.raise_for_status()
    soup = BeautifulSoup(res.text, "html.parser")

    results = []
    article = soup.find("div", class_="article__content")
    if not article:
        print("  [WARN] article__content 없음")
        return results

    # h2 태그가 클럽명, 바로 다음 table이 이적 테이블
    for h2 in article.find_all("h2"):
        raw_club = h2.get_text(strip=True)
        if not raw_club:
            continue
        epl_club = _normalize_club(raw_club)

        table = h2.find_next("table")
        if not table:
            continue

        in_n = out_n = 0
        for row in table.select("tbody tr"):
            tds = row.find_all("td")
            if len(tds) < 3:
                continue

            player = tds[0].get_text(strip=True)
            if not player:
                continue

            # 이적 아이콘 src에서 타입 추출
            img = tds[1].select_one("img.transfer-icon-image")
            if not img:
                continue
            icon_type = img["src"].split("/")[-1].replace(".png", "")   # e.g. "transfer-in"

            other_club = tds[2].get_text(strip=True) or None

            direction, status = ICON_MAP.get(icon_type, (None, "CONFIRMED"))
            if direction != "in":   # 아웃/방출은 스킵 (중복 방지)
                out_n += 1
                continue

            # transfer-in: other_club → epl_club
            results.append({
                "player":    player,
                "from_club": other_club,
                "to_club":   epl_club,
                "status":    status,
                "window":    "SUMMER",
            })
            in_n += 1

        print(f"    {epl_club}: IN {in_n} / (OUT {out_n} 스킵)")

    return results


# ── WINTER: Selenium JS 렌더링 ────────────────────────────────────────────────
def _make_driver() -> webdriver.Chrome:
    opts = Options()
    opts.add_argument("--headless")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-dev-shm-usage")
    opts.add_argument("--disable-gpu")
    opts.add_argument("--window-size=1280,800")
    opts.add_argument(f"user-agent={HEADERS['User-Agent']}")
    return webdriver.Chrome(options=opts)


def fetch_winter() -> list[dict]:
    """premierleague.com/en/transfers/2025-26/january 파싱 (Selenium)"""
    print("  [WINTER] Selenium JS 렌더링 중 (Chrome headless)...")
    driver = _make_driver()
    results = []
    try:
        driver.get(WINTER_URL)
        WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, ".transfer-centre__table"))
        )
        time.sleep(2)   # 추가 렌더링 대기

        soup = BeautifulSoup(driver.page_source, "html.parser")
        tc   = soup.find("section", class_="transfer-centre__container")
        if not tc:
            print("  [WARN] transfer-centre__container 없음")
            return results

        articles = tc.find_all("article", class_="transfer-centre__article")
        print(f"  클럽 {len(articles)}개 확인")

        for article in articles:
            name_tag = article.find("h3", class_="transfer-centre__team-name")
            raw_club = name_tag.get_text(strip=True) if name_tag else ""
            epl_club = _normalize_club(raw_club)

            table = article.find("table", class_="transfer-centre__table")
            if not table:
                continue

            in_n = out_n = 0
            for row in table.select("tbody tr"):
                player_th = row.find("th", class_="transfer-centre__table-data")
                player = player_th.get_text(strip=True) if player_th else ""
                if not player:
                    continue

                # SVG 아이콘 클래스에서 타입 추출
                svg = row.find("svg", class_="transfer-centre__transfer-icon")
                icon_type = "unknown"
                if svg:
                    for cls in svg.get("class", []):
                        if cls.startswith("transfer-centre__transfer-icon--"):
                            icon_type = cls.replace("transfer-centre__transfer-icon--", "")

                direction, status = ICON_MAP.get(icon_type, (None, "CONFIRMED"))
                if direction != "in":
                    out_n += 1
                    continue

                # div.transfer-centre__transfer-info: "Transfer In - OtherClub"
                info_div = row.find("div", class_="transfer-centre__transfer-info")
                other_club = None
                if info_div:
                    tag_span = info_div.find("span", class_="transfer-centre__tag-text")
                    if tag_span:
                        tag_span.extract()
                    remaining = info_div.get_text(strip=True).lstrip("- ").strip()
                    other_club = remaining if remaining else None

                results.append({
                    "player":    player,
                    "from_club": other_club,
                    "to_club":   epl_club,
                    "status":    status,
                    "window":    "WINTER",
                })
                in_n += 1

            print(f"    {epl_club}: IN {in_n} / (OUT {out_n} 스킵)")

    finally:
        driver.quit()

    return results


# ── SQL 생성 ──────────────────────────────────────────────────────────────────
def build_sql(all_transfers: list[dict]) -> str:
    summer = [t for t in all_transfers if t["window"] == "SUMMER"]
    winter = [t for t in all_transfers if t["window"] == "WINTER"]
    print(f"  SUMMER {len(summer)}건 / WINTER {len(winter)}건")

    lines = [
        "-- ============================================================",
        f"--  {LEAGUE_NAME} 25/26 이적시장 데이터  (season={SEASON})",
        "--  premierleague.com 크롤링으로 자동 생성",
        "--  전제: league / club 기초 데이터 적재 완료",
        "-- ============================================================",
        "",
        "-- ── 시스템 기자 (임포트용 더미) ─────────────────────────────",
        "INSERT INTO journalist (x_handle, x_user_id, name, credibility_score, created_at)",
        "SELECT 'pl_import_bot', '0', 'Premier League Import Bot', 0, NOW()",
        "WHERE NOT EXISTS (SELECT 1 FROM journalist WHERE x_handle = 'pl_import_bot');",
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
            post_id_str  = f"PL_EPL_{window_label}_{idx:04d}"
            status       = t["status"]
            post_content = (
                f"{t['player']}: {t['from_club'] or 'FA'} → {t['to_club']}"
                f" [{status}] #PremierLeague"
            )
            from_club_sub = (
                f"COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['from_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['from_club'])}))"
                if t["from_club"] else "NULL"
            )

            lines += [
                f"-- [{idx}] {t['player']}  {t['from_club'] or 'FA'} → {t['to_club']}",
                f"INSERT INTO post (journalist_id, x_post_id, content, posted_at, collected_at)",
                f"SELECT (SELECT journalist_id FROM journalist WHERE x_handle = 'pl_import_bot'),",
                f"    {_esc(post_id_str)}, {_esc(post_content)}, NOW(), NOW()",
                f"WHERE NOT EXISTS (SELECT 1 FROM post WHERE x_post_id = {_esc(post_id_str)});",
                "",
                f"INSERT INTO transfer_news",
                f"    (post_id, player_id, from_club_id, to_club_id, fee_eur, status, season, transfer_window, published_at)",
                f"SELECT",
                f"    (SELECT post_id FROM post WHERE x_post_id = {_esc(post_id_str)}),",
                f"    (SELECT player_id FROM player WHERE name = {_esc(t['player'])}),",
                f"    {from_club_sub},",
                f"    COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['to_club'])})),",
                f"    NULL, {_esc(status)}, {SEASON}, {_esc(window_label)}, NOW()",
                f"WHERE COALESCE("
                f"(SELECT ca.club_id FROM club_aliases ca WHERE lower(ca.alias) = lower({_esc(t['to_club'])})),"
                f"(SELECT club_id FROM club WHERE name = {_esc(t['to_club'])})) IS NOT NULL",
                f"  AND (SELECT player_id FROM player WHERE name = {_esc(t['player'])}) IS NOT NULL;",
                "",
            ]

    return "\n".join(lines)


# ── 메인 ──────────────────────────────────────────────────────────────────────
def main():
    print(f"\n=== {LEAGUE_NAME} PL 공식 사이트 크롤링 ===")

    summer_transfers = fetch_summer()
    winter_transfers = fetch_winter()

    all_transfers = summer_transfers + winter_transfers
    print(f"\n  총 {len(all_transfers)}건 수집")

    sql = build_sql(all_transfers)
    os.makedirs(os.path.dirname(OUT_SQL), exist_ok=True)
    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"\n  → {OUT_SQL}")


if __name__ == "__main__":
    main()
