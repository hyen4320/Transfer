"""
각 리그 공식 사이트 HTML 구조 확인용 진단 스크립트

실행:
    cd D:\\Transfer\\DB\\TransferNews
    python inspect_sites.py

출력:
    inspect_bundesliga.html
    inspect_laliga.html
    inspect_seriea.html
    inspect_ligue1.html
"""
import os, sys, time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

if sys.stdout.encoding and sys.stdout.encoding.lower() in ("cp949", "cp1252", "ascii"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

BASE_DIR = os.path.dirname(__file__)

SITES = [
    ("bundesliga", "https://www.bundesliga.com/en/bundesliga/transfers"),
    ("laliga",     "https://www.laliga.com/en-GB/laliga-ea-sports/transfers"),
    ("seriea",     "https://www.legaseriea.it/en/serie-a/transfers"),
    ("ligue1",     "https://www.ligue1.com/ligue1/page/transfers"),
]

WAIT = 5   # JS 렌더링 대기 시간 (초)


def make_driver():
    opts = Options()
    opts.add_argument("--headless=new")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-dev-shm-usage")
    opts.add_argument("--window-size=1920,1080")
    opts.add_argument(
        "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
    )
    return webdriver.Chrome(options=opts)


def main():
    driver = make_driver()
    try:
        for name, url in SITES:
            print(f"\n[{name}] {url}")
            driver.get(url)
            time.sleep(WAIT)
            html = driver.page_source
            out_path = os.path.join(BASE_DIR, f"inspect_{name}.html")
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(html)
            print(f"  -> {out_path}  ({len(html):,} bytes)")
    finally:
        driver.quit()

    print("\n완료. inspect_*.html 파일을 열어 구조 확인 후 크롤러 작성합니다.")


if __name__ == "__main__":
    main()
