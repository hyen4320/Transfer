"""
Premier League 2024/25 크롤러 (Transfermarkt + Nominatim)

실행:
    pip install requests beautifulsoup4
    cd D:\\Transfer\\DB\\EPL
    python crawl.py
"""

import json, os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "_shared"))
from tm_client import fetch_teams, fetch_team_detail, fetch_squad, build_sql

LEAGUE_NAME  = "Premier League"
COUNTRY_CODE = "GB"
TIER         = 1
TM_PATH      = "/premier-league/startseite/wettbewerb/GB1"
SEASON       = 2025
OUT_SQL      = "./DB/EPL/epl.sql"
OUT_JSON     = "./DB/EPL/epl_players.json"


def main():
    print(f"=== {LEAGUE_NAME} 크롤링 시작 ===\n")
    teams = fetch_teams(TM_PATH, SEASON)

    print("\n구단 상세 (구장/위경도) 수집 중...")
    for team in teams:
        team["detail"] = fetch_team_detail(team)

    print("\n선수 수집 중...")
    all_players = []
    for team in teams:
        for p in fetch_squad(team, SEASON):
            all_players.append({**p, "club_name": team["name"]})

    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write(build_sql(LEAGUE_NAME, COUNTRY_CODE, TIER, SEASON, teams, all_players))
    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump(all_players, f, ensure_ascii=False, indent=2)

    print(f"\n클럽 {len(teams)}개 / 선수 {len(all_players)}명")
    print(f"→ {OUT_SQL}\n→ {OUT_JSON}")


if __name__ == "__main__":
    main()
