"""
players.csv → player.current_club_id UPDATE SQL 생성기
실행: python DB/update_current_clubs.py
출력: DB/update_current_clubs.sql
"""

import csv
import os

BASE        = os.path.dirname(__file__)
PLAYERS_CSV = os.path.join(BASE, "players.csv")
OUTPUT_SQL  = os.path.join(BASE, "update_current_clubs.sql")


def esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


def main():
    lines = [
        "-- ============================================================",
        "--  Player current_club_id 동기화 (players.csv 기준)",
        "--  update_current_clubs.py 자동 생성",
        "-- ============================================================",
        "",
    ]

    count = 0
    skipped = 0
    with open(PLAYERS_CSV, encoding="utf-8") as f:
        for row in csv.DictReader(f):
            tm_id       = row.get("player_id", "").strip()
            club_kaggle = row.get("current_club_id", "").strip()
            if not tm_id or not club_kaggle:
                skipped += 1
                continue
            lines.append(
                f"UPDATE player SET current_club_id = "
                f"(SELECT club_id FROM club WHERE kaggle_club_id = {int(club_kaggle)}) "
                f"WHERE transfermarkt_id = {esc(tm_id)} "
                f"AND (SELECT club_id FROM club WHERE kaggle_club_id = {int(club_kaggle)}) IS NOT NULL;"
            )
            count += 1

    with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"완료: {OUTPUT_SQL}  (UPDATE {count:,}건, 스킵 {skipped}건)")


if __name__ == "__main__":
    main()
