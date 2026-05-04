-- to_club_id NOT NULL 제약 해제 (FA 이적 뉴스 지원)
ALTER TABLE transfer_news ALTER COLUMN to_club_id DROP NOT NULL;
