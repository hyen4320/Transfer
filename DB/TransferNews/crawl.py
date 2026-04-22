"""
유럽 5대 리그 25/26 이적 데이터 수집 — 전체 실행 런처

각 리그를 순차 실행하고 결과 SQL을 하나로 합칩니다.

실행:
    cd D:\\Transfer\\DB\\TransferNews
    python crawl.py              # 전체 5개 리그
    python EPL/crawl.py          # EPL만
    python Bundesliga/crawl.py   # 분데스리가만
    ...

출력:
    {League}/transfer_news_{league}_2526.sql  (리그별)
    transfer_news_2526.sql                     (통합본)
"""
import os, sys, subprocess

BASE_DIR = os.path.dirname(__file__)

LEAGUE_SCRIPTS = [
    os.path.join(BASE_DIR, "EPL",        "crawl.py"),
    os.path.join(BASE_DIR, "Bundesliga", "crawl.py"),
    os.path.join(BASE_DIR, "LaLiga",     "crawl.py"),
    os.path.join(BASE_DIR, "SerieA",     "crawl.py"),
    os.path.join(BASE_DIR, "Ligue1",     "crawl.py"),
]

SQL_FILES = [
    os.path.join(BASE_DIR, "EPL",        "transfer_news_epl_2526.sql"),
    os.path.join(BASE_DIR, "Bundesliga", "transfer_news_bundesliga_2526.sql"),
    os.path.join(BASE_DIR, "LaLiga",     "transfer_news_laliga_2526.sql"),
    os.path.join(BASE_DIR, "SerieA",     "transfer_news_seriea_2526.sql"),
    os.path.join(BASE_DIR, "Ligue1",     "transfer_news_ligue1_2526.sql"),
]

OUT_SQL = os.path.join(BASE_DIR, "transfer_news_2526.sql")


def run_all():
    for script in LEAGUE_SCRIPTS:
        print(f"\n{'='*60}")
        print(f"실행: {script}")
        print('='*60)
        result = subprocess.run([sys.executable, script])
        if result.returncode != 0:
            print(f"[WARN] {script} 실패 — 계속 진행")


def combine():
    missing = [f for f in SQL_FILES if not os.path.exists(f)]
    if missing:
        print("\n[WARN] 아직 생성되지 않은 파일:")
        for f in missing:
            print(f"  {f}")

    parts = [
        "-- ============================================================",
        "--  유럽 5대 리그 25/26 이적시장 통합본",
        "--  crawl.py (런처) 로 자동 생성",
        "-- ============================================================",
        "",
    ]
    for path in SQL_FILES:
        if not os.path.exists(path):
            continue
        league = os.path.basename(os.path.dirname(path))
        parts.append(f"-- ── {league} ──────────────────────────────────────────")
        with open(path, encoding="utf-8") as f:
            # 더미 기자 INSERT는 첫 파일에만 포함 (중복 제거)
            content = f.read().strip()
            if parts.count("transfermarkt_bot") > 0:
                content = "\n".join(
                    line for line in content.splitlines()
                    if "transfermarkt_bot" not in line
                )
        parts.append(content)
        parts.append("")

    combined = "\n".join(parts)
    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write(combined)

    summer_n = combined.count("'SUMMER'")
    winter_n = combined.count("'WINTER'")
    print(f"\n→ {OUT_SQL}")
    print(f"  SUMMER {summer_n}건 / WINTER {winter_n}건")


if __name__ == "__main__":
    run_all()
    combine()
