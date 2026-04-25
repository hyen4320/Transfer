ALTER TABLE player ADD COLUMN IF NOT EXISTS transfermarkt_id VARCHAR(20);
CREATE UNIQUE INDEX IF NOT EXISTS uq_player_transfermarkt_id ON player (transfermarkt_id) WHERE transfermarkt_id IS NOT NULL;
