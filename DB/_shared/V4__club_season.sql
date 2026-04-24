CREATE TABLE IF NOT EXISTS club_season (
    club_season_id BIGSERIAL PRIMARY KEY,
    club_id        BIGINT   NOT NULL REFERENCES club(club_id),
    season         SMALLINT NOT NULL,
    league_id      BIGINT   NOT NULL REFERENCES league(league_id),
    CONSTRAINT uq_club_season UNIQUE (club_id, season)
);

CREATE INDEX IF NOT EXISTS idx_club_season_club   ON club_season (club_id);
CREATE INDEX IF NOT EXISTS idx_club_season_season ON club_season (season);
