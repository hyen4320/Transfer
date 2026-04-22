"""
Ligue 1 25/26 이적 데이터 수집

실행:
    cd D:\\Transfer\\DB\\TransferNews\\Ligue1
    python crawl.py

출력:
    transfer_news_ligue1_2526.sql
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_shared"))
from tm_transfers import run_league

run_league(
    league_name = "Ligue 1",
    tm_path     = "/ligue-1/startseite/wettbewerb/FR1",
    out_sql     = os.path.join(os.path.dirname(__file__), "transfer_news_ligue1_2526.sql"),
)
