-- COSC 3P32 – Introduction to Database Systems
-- Winter 2026 — Group Project, Part 1
-- SQL CREATE TABLE Statements

-- ------------------------------------------------------------
-- Actor
-- Note: unum is unique but nullable (some actors have no union number).
-- ------------------------------------------------------------
CREATE TABLE Actor (
    stagename   CHAR(30),
    realname    CHAR(30),
    abirthyear  INTEGER,
    abirthplace CHAR(30),
    unum        INTEGER,
    PRIMARY KEY (stagename),
    UNIQUE (unum)
)

-- ------------------------------------------------------------
-- Director
-- ------------------------------------------------------------
CREATE TABLE Director (
    dname       CHAR(30),
    dbirthyear  INTEGER,
    dbirthplace CHAR(30),
    PRIMARY KEY (dname)
)

-- ------------------------------------------------------------
-- VideoD  (combines Video and Directs)
-- dname is NOT NULL because every video must have exactly one director.
-- year CHECK constraint: must be between 1900 and 2026.
-- ------------------------------------------------------------
CREATE TABLE VideoD (
    vtitle  CHAR(30),
    year    INTEGER CHECK (year BETWEEN 1900 AND 2026),
    studio  CHAR(30),
    genre   CHAR(30),
    dname   CHAR(30) NOT NULL,
    dpay    INTEGER,
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (dname) REFERENCES Director
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- Movie  (ISA subtype of VideoD)
-- rating CHECK constraint: must be an integer between 0 and 100.
-- ------------------------------------------------------------
CREATE TABLE Movie (
    vtitle  CHAR(30),
    year    INTEGER,
    mlength INTEGER,
    rating  INTEGER CHECK (rating BETWEEN 0 AND 100),
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES VideoD
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- Show  (ISA subtype of VideoD)
-- ------------------------------------------------------------
CREATE TABLE Show (
    vtitle  CHAR(30),
    year    INTEGER,
    seasons INTEGER,
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES VideoD
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- ActsIn
-- ------------------------------------------------------------
CREATE TABLE ActsIn (
    stagename   CHAR(30),
    vtitle      CHAR(30),
    year        INTEGER,
    apay        INTEGER,
    role        CHAR(30),
    PRIMARY KEY (stagename, vtitle, year),
    FOREIGN KEY (stagename) REFERENCES Actor
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vtitle, year) REFERENCES VideoD
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- EpisodeOf  (combines Episode and BelongsTo)
-- vtitle and year are NOT NULL (total participation of Episode in BelongsTo).
-- (enum, eseason, vtitle, year) is UNIQUE because no two episodes of the
-- same show may share the same (episode number, season number) combination.
-- Note: the constraint that eseason must be between 1 and the show's seasons
-- count requires a trigger and is deferred to Part 2.
-- ------------------------------------------------------------
CREATE TABLE EpisodeOf (
    etitle  CHAR(30),
    enum    INTEGER,
    eseason INTEGER,
    elength INTEGER,
    vtitle  CHAR(30) NOT NULL,
    year    INTEGER  NOT NULL,
    PRIMARY KEY (etitle, vtitle, year),
    UNIQUE (enum, eseason, vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES Show
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- AccountType  (new table extracted from Account for BCNF)
-- Stores the two possible account types and their monthly costs.
-- Because all accounts of the same type share the same monthly cost,
-- the FD  account_type → monthly_cost  must be captured here.
-- ------------------------------------------------------------
CREATE TABLE AccountType (
    account_type    CHAR(10),
    monthly_cost    DECIMAL(10,2),
    PRIMARY KEY (account_type),
    CHECK (account_type IN ('Standard', 'Premium'))
)

-- ------------------------------------------------------------
-- Account
-- aphone is UNIQUE because a phone number can belong to only one account.
-- credit_card is UNIQUE because a credit card can belong to only one account.
-- account_type is NOT NULL (every account has an account type).
-- Note: The constraint that Standard accounts may have at most one viewer
-- requires a trigger and is deferred to Part 2.
-- ------------------------------------------------------------
CREATE TABLE Account (
    aid             INTEGER,
    aphone          CHAR(10),
    account_type    CHAR(10) NOT NULL,
    credit_card     CHAR(16),
    PRIMARY KEY (aid),
    UNIQUE (aphone),
    UNIQUE (credit_card),
    FOREIGN KEY (account_type) REFERENCES AccountType
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- ViewerShares  (combines Viewer and Shares)
-- aid is NOT NULL (total participation of Viewer in Shares).
-- ------------------------------------------------------------
CREATE TABLE ViewerShares (
    vname   CHAR(30),
    aid     INTEGER NOT NULL,
    vpref   CHAR(30),
    PRIMARY KEY (vname, aid),
    FOREIGN KEY (aid) REFERENCES Account
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

-- ------------------------------------------------------------
-- Watches
-- iend >= istart: enforced with CHECK constraint.
-- Note: The constraint that a viewer cannot watch more than one video
-- at the same time (non-overlapping intervals per viewer) requires a
-- trigger and is deferred to Part 2.
-- ------------------------------------------------------------
CREATE TABLE Watches (
    vname   CHAR(30),
    aid     INTEGER,
    vtitle  CHAR(30),
    year    INTEGER,
    istart  TIMESTAMP,
    iend    TIMESTAMP,
    PRIMARY KEY (vname, aid, vtitle, year, istart, iend),
    CHECK (iend >= istart),
    FOREIGN KEY (vname, aid) REFERENCES ViewerShares
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vtitle, year) REFERENCES VideoD
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
