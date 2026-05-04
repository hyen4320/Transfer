CREATE TABLE editorial_report (
    report_id    BIGSERIAL    PRIMARY KEY,
    title        TEXT         NOT NULL,
    deck         TEXT,
    type         VARCHAR(20)  NOT NULL DEFAULT 'ANALYSIS',
    format       VARCHAR(20)  NOT NULL DEFAULT 'LONGFORM',
    classification VARCHAR(20) NOT NULL DEFAULT 'OPEN_SOURCE',
    confidence   FLOAT,
    read_minutes INTEGER,
    cover_tone   VARCHAR(30),
    cover_motif  VARCHAR(20),
    tags         TEXT,
    blocks       TEXT,
    status       VARCHAR(20)  NOT NULL DEFAULT 'DRAFT',
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP
);

CREATE INDEX idx_editorial_report_status ON editorial_report (status);
