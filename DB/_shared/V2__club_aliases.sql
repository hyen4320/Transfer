CREATE TABLE IF NOT EXISTS club_aliases (
    id       BIGSERIAL PRIMARY KEY,
    club_id  BIGINT       NOT NULL REFERENCES club(club_id) ON DELETE CASCADE,
    alias    VARCHAR(100) NOT NULL,
    lang     VARCHAR(10)  NOT NULL DEFAULT 'en',
    source   VARCHAR(50),
    CONSTRAINT uq_club_alias UNIQUE (alias)
);

CREATE INDEX IF NOT EXISTS idx_club_aliases_alias ON club_aliases (lower(alias));
