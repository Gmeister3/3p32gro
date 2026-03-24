-- COSC 3P32 – Introduction to Database Systems
-- Winter 2026 — Group Project, Part 2
-- Trigger Definitions
--
-- Run AFTER schema.sql to create the three constraint-enforcement triggers:
--   1. trg_standard_viewer_limit  – Standard accounts may have at most one viewer.
--   2. trg_non_overlapping_watches – A viewer may not watch two videos simultaneously.
--   3. trg_episode_season_check   – An episode's season number must be between 1 and
--                                   the show's declared number of seasons.

-- ============================================================
-- Trigger 1: Standard account viewer limit
-- A Standard account may have at most one viewer (Shares).
-- A Premium account may have any number of viewers.
-- Fires BEFORE INSERT on ViewerShares.
-- ============================================================
CREATE OR REPLACE FUNCTION fn_check_standard_viewer_limit()
RETURNS TRIGGER AS $$
DECLARE
    v_account_type VARCHAR(10);
    v_viewer_count INTEGER;
BEGIN
    SELECT account_type
      INTO v_account_type
      FROM Account
     WHERE aid = NEW.aid;

    IF v_account_type = 'Standard' THEN
        SELECT COUNT(*)
          INTO v_viewer_count
          FROM ViewerShares
         WHERE aid = NEW.aid;

        IF v_viewer_count >= 1 THEN
            RAISE EXCEPTION
                'Standard accounts may have at most one viewer (account id = %).',
                NEW.aid;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_standard_viewer_limit
BEFORE INSERT ON ViewerShares
FOR EACH ROW EXECUTE FUNCTION fn_check_standard_viewer_limit();


-- ============================================================
-- Trigger 2: Non-overlapping watch intervals
-- A viewer (identified by vname + aid) may not have two watch records
-- whose time intervals overlap.  Two intervals [a,b] and [c,d] overlap
-- when a < d AND c < b.
-- Fires BEFORE INSERT on Watches.
-- ============================================================
CREATE OR REPLACE FUNCTION fn_check_non_overlapping_watches()
RETURNS TRIGGER AS $$
DECLARE
    v_overlap_count INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO v_overlap_count
      FROM Watches
     WHERE vname  = NEW.vname
       AND aid    = NEW.aid
       AND istart < NEW.iend
       AND iend   > NEW.istart;

    IF v_overlap_count > 0 THEN
        RAISE EXCEPTION
            'Viewer % (account id = %) already has an overlapping watch interval.',
            NEW.vname, NEW.aid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_non_overlapping_watches
BEFORE INSERT ON Watches
FOR EACH ROW EXECUTE FUNCTION fn_check_non_overlapping_watches();


-- ============================================================
-- Trigger 3: Episode season number within show's season range
-- An episode's eseason must satisfy 1 <= eseason <= Show.seasons
-- for the show to which it belongs.
-- Fires BEFORE INSERT on EpisodeOf.
-- ============================================================
CREATE OR REPLACE FUNCTION fn_check_episode_season()
RETURNS TRIGGER AS $$
DECLARE
    v_max_seasons INTEGER;
BEGIN
    SELECT seasons
      INTO v_max_seasons
      FROM Show
     WHERE vtitle = NEW.vtitle
       AND year   = NEW.year;

    IF NEW.eseason < 1 THEN
        RAISE EXCEPTION
            'Episode season must be at least 1 (got %).',
            NEW.eseason;
    END IF;

    IF NEW.eseason > v_max_seasons THEN
        RAISE EXCEPTION
            'Episode season % exceeds the total seasons (%) for show "%" (%).',
            NEW.eseason, v_max_seasons, NEW.vtitle, NEW.year;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_episode_season_check
BEFORE INSERT ON EpisodeOf
FOR EACH ROW EXECUTE FUNCTION fn_check_episode_season();
