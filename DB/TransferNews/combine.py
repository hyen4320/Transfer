"""
유럽 5대 리그 25/26 이적 SQL 통합 — combine.py

각 리그 크롤러 실행 후 생성된 SQL 파일을 하나로 합칩니다.

실행 순서:
    1. EPL:        python EPL/pl_crawl.py
    2. Bundesliga: python Bundesliga/bl_crawl.py
    3. La Liga:    python LaLiga/ll_crawl.py
    4. Serie A:    python SerieA/sa_crawl.py
    5. Ligue 1:    python Ligue1/l1_crawl.py
    6. 통합:       python combine.py

출력:
    transfer_news_2526.sql
"""
import os, sys

if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

BASE_DIR = os.path.dirname(__file__)
OUT_SQL  = os.path.join(BASE_DIR, "transfer_news_2526.sql")

SQL_FILES = [
    ("Premier League", os.path.join(BASE_DIR, "EPL",        "transfer_news_epl_pl_2526.sql")),
    ("Bundesliga",     os.path.join(BASE_DIR, "Bundesliga", "transfer_news_bundesliga_bl_2526.sql")),
    ("La Liga",        os.path.join(BASE_DIR, "LaLiga",     "transfer_news_laliga_ll_2526.sql")),
    ("Serie A",        os.path.join(BASE_DIR, "SerieA",     "transfer_news_seriea_sa_2526.sql")),
    ("Ligue 1",        os.path.join(BASE_DIR, "Ligue1",     "transfer_news_ligue1_l1_2526.sql")),
]


def combine():
    parts = [
        "-- ============================================================",
        "--  유럽 5대 리그 25/26 이적시장 통합본",
        "--  combine.py 로 자동 생성",
        "--  실행: psql -U postgres -d transfer -f transfer_news_2526.sql",
        "-- ============================================================",
        "",
    ]

    total_summer = total_winter = 0
    included = []

    for league_name, path in SQL_FILES:
        if not os.path.exists(path):
            print(f"[SKIP] 파일 없음: {path}")
            continue

        with open(path, encoding="utf-8") as f:
            content = f.read().strip()

        if not content:
            print(f"[SKIP] 비어 있음: {path}")
            continue

        summer_n = content.count("'SUMMER'")
        winter_n = content.count("'WINTER'")
        total_summer += summer_n
        total_winter += winter_n
        included.append(league_name)

        parts.append(f"-- ── {league_name} {'─' * (50 - len(league_name))}")
        parts.append(content)
        parts.append("")
        print(f"  {league_name}: SUMMER {summer_n}건 / WINTER {winter_n}건")

    if not included:
        print("\n[ERROR] 포함된 파일 없음. 각 리그 크롤러를 먼저 실행하세요.")
        return

    combined = "\n".join(parts)
    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write(combined)

    print(f"\n-> {OUT_SQL}")
    print(f"   포함 리그: {', '.join(included)}")
    print(f"   총 SUMMER {total_summer}건 / WINTER {total_winter}건")


if __name__ == "__main__":
    combine()
