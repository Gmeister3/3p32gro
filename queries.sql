-- COSC 3P32 – Introduction to Database Systems
-- Winter 2026 — Group Project, Part 2
-- Required Views and Queries
--
-- Run AFTER schema.sql, triggers.sql, and data.sql.
-- Each section defines a view that implements one required query,
-- followed by an example of how to query the view for a specific input.

-- ============================================================
-- Query 1
-- Given the title and year of a movie, output:
--   stage name, pay, and role for each actor in that movie.
-- ============================================================
CREATE OR REPLACE VIEW vw_movie_cast AS
SELECT
    ai.vtitle,
    ai.year,
    ai.stagename,
    ai.apay,
    ai.role
FROM ActsIn   ai
JOIN Movie    m  ON ai.vtitle = m.vtitle AND ai.year = m.year;

-- Example: actors in Inception (2010)
-- SELECT stagename, apay, role
--   FROM vw_movie_cast
--  WHERE vtitle = 'Inception' AND year = 2010;


-- ============================================================
-- Query 2
-- Given the title and year of a show, output all information
-- on all episodes of that show.
-- ============================================================
CREATE OR REPLACE VIEW vw_show_episodes AS
SELECT
    e.vtitle,
    e.year,
    e.etitle,
    e.enum,
    e.eseason,
    e.elength
FROM EpisodeOf e
JOIN Show       s ON e.vtitle = s.vtitle AND e.year = s.year;

-- Example: all episodes of Breaking Bad (2008)
-- SELECT etitle, enum, eseason, elength
--   FROM vw_show_episodes
--  WHERE vtitle = 'Breaking Bad' AND year = 2008
--  ORDER BY eseason, enum;


-- ============================================================
-- Query 3
-- Given an account ID, output the viewer name for all viewers
-- belonging to that account, together with their watch history
-- for a given calendar month: for each watch interval, the
-- start and end of the interval and the title and year of the
-- video watched.
-- ============================================================
CREATE OR REPLACE VIEW vw_account_watch_history AS
SELECT
    vs.aid,
    vs.vname,
    w.vtitle,
    w.year,
    w.istart,
    w.iend,
    EXTRACT(YEAR  FROM w.istart)::INTEGER AS watch_year,
    EXTRACT(MONTH FROM w.istart)::INTEGER AS watch_month
FROM ViewerShares vs
JOIN Watches      w  ON vs.vname = w.vname AND vs.aid = w.aid;

-- Example: account 1, January 2026
-- SELECT vname, vtitle, year, istart, iend
--   FROM vw_account_watch_history
--  WHERE aid = 1 AND watch_year = 2026 AND watch_month = 1
--  ORDER BY vname, istart;

-- Example: account 1, February 2026
-- SELECT vname, vtitle, year, istart, iend
--   FROM vw_account_watch_history
--  WHERE aid = 1 AND watch_year = 2026 AND watch_month = 2
--  ORDER BY vname, istart;

-- Example: account 1, March 2026
-- SELECT vname, vtitle, year, istart, iend
--   FROM vw_account_watch_history
--  WHERE aid = 1 AND watch_year = 2026 AND watch_month = 3
--  ORDER BY vname, istart;


-- ============================================================
-- Query 4
-- Given the stage name of an actor, find their impact on
-- different genres of movies: for each genre of movie in which
-- they have acted, the average rating of all of those movies.
-- ============================================================
CREATE OR REPLACE VIEW vw_actor_genre_impact AS
SELECT
    ai.stagename,
    vd.genre,
    AVG(m.rating) AS avg_rating
FROM ActsIn  ai
JOIN VideoD  vd ON ai.vtitle = vd.vtitle AND ai.year = vd.year
JOIN Movie   m  ON ai.vtitle = m.vtitle  AND ai.year = m.year
GROUP BY ai.stagename, vd.genre;

-- Example: genre impact for Tom Hardy
-- SELECT genre, avg_rating
--   FROM vw_actor_genre_impact
--  WHERE stagename = 'Tom Hardy'
--  ORDER BY avg_rating DESC;

-- Example: genre impact for Leonardo DiCaprio
-- SELECT genre, avg_rating
--   FROM vw_actor_genre_impact
--  WHERE stagename = 'Leonardo DiCaprio'
--  ORDER BY avg_rating DESC;


-- ============================================================
-- Query 5
-- Find the top 5 videos for a given calendar month.
-- Defined as: for each video, the total number of DISTINCT
-- viewers who have watched it in that month (a viewer who
-- watches the same video multiple times counts only once).
-- ============================================================
CREATE OR REPLACE VIEW vw_monthly_top_videos AS
SELECT
    vtitle,
    year,
    EXTRACT(YEAR  FROM istart)::INTEGER AS watch_year,
    EXTRACT(MONTH FROM istart)::INTEGER AS watch_month,
    COUNT(DISTINCT (vname, aid))        AS distinct_viewers
FROM Watches
GROUP BY vtitle, year,
         EXTRACT(YEAR  FROM istart),
         EXTRACT(MONTH FROM istart);

-- Example: top 5 videos for January 2026
-- SELECT vtitle, year, distinct_viewers
--   FROM vw_monthly_top_videos
--  WHERE watch_year = 2026 AND watch_month = 1
--  ORDER BY distinct_viewers DESC
--  LIMIT 5;

-- Example: top 5 videos for February 2026
-- SELECT vtitle, year, distinct_viewers
--   FROM vw_monthly_top_videos
--  WHERE watch_year = 2026 AND watch_month = 2
--  ORDER BY distinct_viewers DESC
--  LIMIT 5;

-- Example: top 5 videos for March 2026
-- SELECT vtitle, year, distinct_viewers
--   FROM vw_monthly_top_videos
--  WHERE watch_year = 2026 AND watch_month = 3
--  ORDER BY distinct_viewers DESC
--  LIMIT 5;
