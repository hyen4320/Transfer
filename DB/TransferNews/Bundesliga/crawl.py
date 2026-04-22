"""
Bundesliga 25/26 이적 데이터 수집

실행:
    cd D:\\Transfer\\DB\\TransferNews\\Bundesliga
    python crawl.py

출력:
    transfer_news_bundesliga_2526.sql
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_shared"))
from tm_transfers import run_league

run_league(
    league_name = "Bundesliga",
    tm_path     = "/bundesliga/startseite/wettbewerb/L1",
    out_sql     = os.path.join(os.path.dirname(__file__), "transfer_news_bundesliga_2526.sql"),
)
