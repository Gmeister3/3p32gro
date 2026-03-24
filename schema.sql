-- COSC 3P32 – Introduction to Database Systems
-- Winter 2026 — Group Project, Part 2
-- SQL CREATE TABLE Statements
-- (Updated from Part 1: CHAR replaced with VARCHAR for flexibility;
--  semicolons added; seasons >= 1 check added to Show.)

-- ------------------------------------------------------------
-- Actor
-- Note: unum is unique but nullable (some actors have no union number).
-- ------------------------------------------------------------
CREATE TABLE Actor (
    stagename   VARCHAR(60),
    realname    VARCHAR(60),
    abirthyear  INTEGER,
    abirthplace VARCHAR(60),
    unum        INTEGER,
    PRIMARY KEY (stagename),
    UNIQUE (unum)
);

-- ------------------------------------------------------------
-- Director
-- ------------------------------------------------------------
CREATE TABLE Director (
    dname       VARCHAR(60),
    dbirthyear  INTEGER,
    dbirthplace VARCHAR(60),
    PRIMARY KEY (dname)
);

-- ------------------------------------------------------------
-- VideoD  (combines Video and Directs)
-- dname is NOT NULL because every video must have exactly one director.
-- year CHECK constraint: must be between 1900 and 2026.
-- ------------------------------------------------------------
CREATE TABLE VideoD (
    vtitle  VARCHAR(60),
    year    INTEGER CHECK (year BETWEEN 1900 AND 2026),
    studio  VARCHAR(60),
    genre   VARCHAR(30),
    dname   VARCHAR(60) NOT NULL,
    dpay    INTEGER,
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (dname) REFERENCES Director(dname)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Movie  (ISA subtype of VideoD)
-- rating CHECK constraint: must be an integer between 0 and 100.
-- ------------------------------------------------------------
CREATE TABLE Movie (
    vtitle  VARCHAR(60),
    year    INTEGER,
    mlength INTEGER,
    rating  INTEGER CHECK (rating BETWEEN 0 AND 100),
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES VideoD(vtitle, year)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Show  (ISA subtype of VideoD)
-- seasons >= 1: a show must have at least one season.
-- ------------------------------------------------------------
CREATE TABLE Show (
    vtitle  VARCHAR(60),
    year    INTEGER,
    seasons INTEGER CHECK (seasons >= 1),
    PRIMARY KEY (vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES VideoD(vtitle, year)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- ActsIn
-- ------------------------------------------------------------
CREATE TABLE ActsIn (
    stagename   VARCHAR(60),
    vtitle      VARCHAR(60),
    year        INTEGER,
    apay        INTEGER,
    role        VARCHAR(60),
    PRIMARY KEY (stagename, vtitle, year),
    FOREIGN KEY (stagename) REFERENCES Actor(stagename)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vtitle, year) REFERENCES VideoD(vtitle, year)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- EpisodeOf  (combines Episode and BelongsTo)
-- vtitle and year are NOT NULL (total participation of Episode in BelongsTo).
-- (enum, eseason, vtitle, year) is UNIQUE because no two episodes of the
-- same show may share the same (episode number, season number) combination.
-- Note: the constraint that eseason must be between 1 and the show's seasons
-- count is enforced via a trigger in triggers.sql.
-- ------------------------------------------------------------
CREATE TABLE EpisodeOf (
    etitle  VARCHAR(60),
    enum    INTEGER,
    eseason INTEGER,
    elength INTEGER,
    vtitle  VARCHAR(60) NOT NULL,
    year    INTEGER     NOT NULL,
    PRIMARY KEY (etitle, vtitle, year),
    UNIQUE (enum, eseason, vtitle, year),
    FOREIGN KEY (vtitle, year) REFERENCES Show(vtitle, year)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- AccountType  (new table extracted from Account for BCNF)
-- Stores the two possible account types and their monthly costs.
-- Because all accounts of the same type share the same monthly cost,
-- the FD  account_type → monthly_cost  must be captured here.
-- ------------------------------------------------------------
CREATE TABLE AccountType (
    account_type    VARCHAR(10),
    monthly_cost    DECIMAL(10,2),
    PRIMARY KEY (account_type),
    CHECK (account_type IN ('Standard', 'Premium'))
);

-- ------------------------------------------------------------
-- Account
-- aphone is UNIQUE because a phone number can belong to only one account.
-- credit_card is UNIQUE because a credit card can belong to only one account.
-- account_type is NOT NULL (every account has an account type).
-- Note: The constraint that Standard accounts may have at most one viewer
-- is enforced via a trigger in triggers.sql.
-- ------------------------------------------------------------
CREATE TABLE Account (
    aid             INTEGER,
    aphone          VARCHAR(15),
    account_type    VARCHAR(10) NOT NULL,
    credit_card     VARCHAR(19),
    PRIMARY KEY (aid),
    UNIQUE (aphone),
    UNIQUE (credit_card),
    FOREIGN KEY (account_type) REFERENCES AccountType(account_type)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- ViewerShares  (combines Viewer and Shares)
-- aid is NOT NULL (total participation of Viewer in Shares).
-- ------------------------------------------------------------
CREATE TABLE ViewerShares (
    vname   VARCHAR(60),
    aid     INTEGER NOT NULL,
    vpref   VARCHAR(60),
    PRIMARY KEY (vname, aid),
    FOREIGN KEY (aid) REFERENCES Account(aid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Watches
-- iend >= istart: enforced with CHECK constraint.
-- Note: The constraint that a viewer cannot watch more than one video
-- at the same time (non-overlapping intervals per viewer) is enforced
-- via a trigger in triggers.sql.
-- ------------------------------------------------------------
CREATE TABLE Watches (
    vname   VARCHAR(60),
    aid     INTEGER,
    vtitle  VARCHAR(60),
    year    INTEGER,
    istart  TIMESTAMP,
    iend    TIMESTAMP,
    PRIMARY KEY (vname, aid, vtitle, year, istart, iend),
    CHECK (iend >= istart),
    FOREIGN KEY (vname, aid) REFERENCES ViewerShares(vname, aid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vtitle, year) REFERENCES VideoD(vtitle, year)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
