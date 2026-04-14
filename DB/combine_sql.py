"""
각 리그 SQL 파일을 하나로 병합합니다.

실행:
    cd D:\\Transfer\\DB
    python combine_sql.py

결과:
    D:\\Transfer\\BE\\src\\main\\resources\\data\\init_data.sql

적용:
    psql -U postgres -d transfer -f D:\\Transfer\\BE\\src\\main\\resources\\data\\init_data.sql
"""

import os

BASE_DIR    = os.path.dirname(__file__)
SPRING_DATA = os.path.join(BASE_DIR, "..", "BE", "src", "main", "resources", "data")
OUT_FILE    = os.path.join(SPRING_DATA, "init_data.sql")

SQL_FILES = [
    os.path.join(BASE_DIR, "EPL",        "epl.sql"),
    os.path.join(BASE_DIR, "Bundesliga", "bundesliga.sql"),
    os.path.join(BASE_DIR, "Ligue1",     "ligue1.sql"),
    os.path.join(BASE_DIR, "LaLiga",     "laliga.sql"),
    os.path.join(BASE_DIR, "SerieA",     "seriea.sql"),
]


def main():
    os.makedirs(SPRING_DATA, exist_ok=True)

    missing = [f for f in SQL_FILES if not os.path.exists(f)]
    if missing:
        print("[WARN] 아직 생성되지 않은 파일:")
        for f in missing:
            print(f"  {f}")
        print("해당 리그 crawl.py 를 먼저 실행하세요.\n")

    combined = [
        "-- =====================================================",
        "-- 5대 리그 초기 데이터",
        "-- combine_sql.py 로 자동 생성",
        "-- =====================================================",
        "",
    ]

    for path in SQL_FILES:
        if not os.path.exists(path):
            continue
        league = os.path.basename(os.path.dirname(path))
        combined.append(f"-- ═══════════════════════════════════════════════════")
        combined.append(f"-- {league}")
        combined.append(f"-- ═══════════════════════════════════════════════════")
        with open(path, encoding="utf-8") as f:
            sql = f.read().strip()
        # 구버전 파일의 id → 실제 PK 컬럼명으로 교정
        sql = sql.replace("SELECT id FROM league", "SELECT league_id FROM league")
        sql = sql.replace("SELECT id FROM club",   "SELECT club_id FROM club")
        combined.append(sql)
        combined.append("")

    content = "\n".join(combined)
    with open(OUT_FILE, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"→ {OUT_FILE}")
    print(f"  리그 {content.count('INSERT INTO league')}개 / "
          f"구단 {content.count('INSERT INTO club')}개 / "
          f"선수 {content.count('INSERT INTO player')}명")


if __name__ == "__main__":
    main()
