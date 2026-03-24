-- COSC 3P32 – Introduction to Database Systems
-- Winter 2026 — Group Project, Part 2
-- Sample Data
--
-- Run AFTER schema.sql and triggers.sql.
-- Insert order respects all foreign-key dependencies.
-- Data is designed to test all five required queries, with watch history
-- covering January, February, and March 2026.

-- ============================================================
-- AccountType
-- ============================================================
INSERT INTO AccountType (account_type, monthly_cost) VALUES
    ('Standard', 9.99),
    ('Premium',  14.99);

-- ============================================================
-- Director
-- ============================================================
INSERT INTO Director (dname, dbirthyear, dbirthplace) VALUES
    ('Christopher Nolan', 1970, 'London'),
    ('Steven Spielberg',  1946, 'Cincinnati'),
    ('James Cameron',     1954, 'Kapuskasing'),
    ('Ridley Scott',      1937, 'South Shields'),
    ('David Fincher',     1962, 'Denver'),
    ('Vince Gilligan',    1967, 'Richmond'),
    ('David Benioff',     1970, 'New York');

-- ============================================================
-- Actor
-- ============================================================
INSERT INTO Actor (stagename, realname, abirthyear, abirthplace, unum) VALUES
    ('Leonardo DiCaprio', 'Leonardo Wilhelm DiCaprio', 1974, 'Los Angeles',  1001),
    ('Tom Hardy',         'Edward Thomas Hardy',       1977, 'London',       1002),
    ('Cillian Murphy',    'Cillian Murphy',             1976, 'Cork',         1003),
    ('Brad Pitt',         'William Bradley Pitt',       1963, 'Shawnee',      1004),
    ('Edward Norton',     'Edward Harrison Norton',     1969, 'Boston',       1005),
    ('Russell Crowe',     'Russell Ira Crowe',          1964, 'Wellington',   1006),
    ('Bryan Cranston',    'Bryan Lee Cranston',         1956, 'Hollywood',    1007);

-- ============================================================
-- VideoD  (all videos — movies and shows)
-- ============================================================
INSERT INTO VideoD (vtitle, year, studio, genre, dname, dpay) VALUES
    -- Movies
    ('Inception',        2010, 'Warner Bros',  'Sci-Fi',  'Christopher Nolan', 5000000),
    ('Interstellar',     2014, 'Paramount',    'Sci-Fi',  'Christopher Nolan', 6000000),
    ('Dunkirk',          2017, 'Warner Bros',  'War',     'Christopher Nolan', 7000000),
    ('The Dark Knight',  2008, 'Warner Bros',  'Action',  'Christopher Nolan', 8000000),
    ('Fight Club',       1999, 'Fox',          'Drama',   'David Fincher',     3000000),
    ('Schindlers List',  1993, 'Universal',    'Drama',   'Steven Spielberg',  2000000),
    ('Titanic',          1997, 'Paramount',    'Drama',   'James Cameron',     4000000),
    ('Gladiator',        2000, 'DreamWorks',   'Action',  'Ridley Scott',      3500000),
    -- Shows
    ('Breaking Bad',     2008, 'AMC',          'Drama',   'Vince Gilligan',    100000),
    ('Game of Thrones',  2011, 'HBO',          'Fantasy', 'David Benioff',     200000),
    ('Stranger Things',  2016, 'Netflix',      'Sci-Fi',  'Christopher Nolan', 150000);

-- ============================================================
-- Movie  (ISA subtype)
-- ============================================================
INSERT INTO Movie (vtitle, year, mlength, rating) VALUES
    ('Inception',       2010, 148, 95),
    ('Interstellar',    2014, 169, 88),
    ('Dunkirk',         2017, 107, 85),
    ('The Dark Knight', 2008, 152, 97),
    ('Fight Club',      1999, 139, 89),
    ('Schindlers List', 1993, 195, 99),
    ('Titanic',         1997, 194, 91),
    ('Gladiator',       2000, 155, 86);

-- ============================================================
-- Show  (ISA subtype)
-- ============================================================
INSERT INTO Show (vtitle, year, seasons) VALUES
    ('Breaking Bad',    2008, 5),
    ('Game of Thrones', 2011, 8),
    ('Stranger Things', 2016, 4);

-- ============================================================
-- ActsIn
-- Covers multiple genres per actor to demonstrate Query 4
-- (actor genre impact = avg rating per genre per actor).
-- ============================================================
INSERT INTO ActsIn (stagename, vtitle, year, apay, role) VALUES
    -- Leonardo DiCaprio: Sci-Fi (95) and Drama (91)
    ('Leonardo DiCaprio', 'Inception', 2010, 20000000, 'Cobb'),
    ('Leonardo DiCaprio', 'Titanic',   1997, 15000000, 'Jack Dawson'),
    -- Tom Hardy: Sci-Fi (95), Action (97), War (85)
    ('Tom Hardy', 'Inception',       2010, 5000000,  'Eames'),
    ('Tom Hardy', 'The Dark Knight', 2008, 10000000, 'Bane'),
    ('Tom Hardy', 'Dunkirk',         2017, 8000000,  'Farrier'),
    -- Cillian Murphy: Action (97), War (85)
    ('Cillian Murphy', 'The Dark Knight', 2008, 8000000, 'Dr. Jonathan Crane'),
    ('Cillian Murphy', 'Dunkirk',         2017, 5000000, 'Shivering Soldier'),
    -- Brad Pitt: Drama (89)
    ('Brad Pitt',    'Fight Club', 1999, 17500000, 'Tyler Durden'),
    -- Edward Norton: Drama (89)
    ('Edward Norton','Fight Club', 1999, 12500000, 'The Narrator'),
    -- Russell Crowe: Action (86)
    ('Russell Crowe', 'Gladiator', 2000, 15000000, 'Maximus'),
    -- Bryan Cranston: Drama (99)
    ('Bryan Cranston', 'Schindlers List', 1993, 1000000, 'German Officer');

-- ============================================================
-- EpisodeOf
-- ============================================================
-- Breaking Bad (5 seasons)
INSERT INTO EpisodeOf (etitle, enum, eseason, elength, vtitle, year) VALUES
    ('Pilot',                   1, 1, 58, 'Breaking Bad', 2008),
    ('The Cat is in the Bag',   2, 1, 48, 'Breaking Bad', 2008),
    ('And the Bags in the River',3,1, 48, 'Breaking Bad', 2008),
    ('Seven Thirty-Seven',      1, 2, 47, 'Breaking Bad', 2008),
    ('Down',                    2, 2, 47, 'Breaking Bad', 2008);

-- Game of Thrones (8 seasons)
INSERT INTO EpisodeOf (etitle, enum, eseason, elength, vtitle, year) VALUES
    ('Winter Is Coming',        1, 1, 62, 'Game of Thrones', 2011),
    ('The Kingsroad',           2, 1, 56, 'Game of Thrones', 2011),
    ('Lord Snow',               3, 1, 58, 'Game of Thrones', 2011),
    ('The North Remembers',     1, 2, 53, 'Game of Thrones', 2011),
    ('The Lion and the Rose',   2, 4, 75, 'Game of Thrones', 2011);

-- Stranger Things (4 seasons)
INSERT INTO EpisodeOf (etitle, enum, eseason, elength, vtitle, year) VALUES
    ('The Vanishing of Will Byers', 1, 1, 47, 'Stranger Things', 2016),
    ('The Weirdo on Maple Street',  2, 1, 55, 'Stranger Things', 2016),
    ('MADMAX',                      1, 2, 48, 'Stranger Things', 2016),
    ('Trick or Treat, Freak',       2, 2, 56, 'Stranger Things', 2016);

-- ============================================================
-- Account
-- ============================================================
INSERT INTO Account (aid, aphone, account_type, credit_card) VALUES
    (1, '4165550001', 'Premium',  '4111111111111111'),
    (2, '4165550002', 'Standard', '4111111111111112'),
    (3, '4165550003', 'Premium',  '4111111111111113'),
    (4, '4165550004', 'Standard', '4111111111111114'),
    (5, '4165550005', 'Premium',  '4111111111111115'),
    (6, '4165550006', 'Standard', '4111111111111116');

-- ============================================================
-- ViewerShares
-- Standard accounts (2, 4, 6) have exactly one viewer each.
-- Premium accounts (1, 3, 5) may have multiple viewers.
-- ============================================================
INSERT INTO ViewerShares (vname, aid, vpref) VALUES
    -- Account 1 (Premium): three viewers
    ('Alice',   1, 'Sci-Fi'),
    ('Bob',     1, 'Drama'),
    ('Charlie', 1, 'Action'),
    -- Account 2 (Standard): one viewer
    ('Diana',   2, 'Drama'),
    -- Account 3 (Premium): two viewers
    ('Eve',     3, 'Sci-Fi'),
    ('Frank',   3, 'Fantasy'),
    -- Account 4 (Standard): one viewer
    ('Grace',   4, 'Action'),
    -- Account 5 (Premium): two viewers
    ('Henry',   5, 'Drama'),
    ('Iris',    5, 'Action'),
    -- Account 6 (Standard): one viewer
    ('Jack',    6, 'Sci-Fi');

-- ============================================================
-- Watches
-- All intervals are non-overlapping per viewer.
-- Data covers January, February, and March 2026 to satisfy:
--   Query 3: watch history per account per month
--   Query 5: top 5 videos per month
--
-- January 2026 top-5 (distinct viewers):
--   Inception(4), The Dark Knight(3), Fight Club(2),
--   Breaking Bad(2), Titanic(2)
--
-- February 2026 top-5:
--   Interstellar(5), Game of Thrones(3), Inception(2),
--   Gladiator(2), Fight Club(2)
--
-- March 2026 top-5:
--   Dunkirk(5), Stranger Things(3), The Dark Knight(2),
--   Titanic(2), Schindlers List(2)
-- ============================================================

-- --- Alice (aid=1) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Alice', 1, 'Inception',       2010, '2026-01-05 10:00:00', '2026-01-05 12:30:00'),
    ('Alice', 1, 'The Dark Knight', 2008, '2026-01-10 19:00:00', '2026-01-10 21:32:00'),
    ('Alice', 1, 'Interstellar',    2014, '2026-02-03 14:00:00', '2026-02-03 16:49:00'),
    ('Alice', 1, 'Game of Thrones', 2011, '2026-02-15 20:00:00', '2026-02-15 21:02:00'),
    ('Alice', 1, 'Dunkirk',         2017, '2026-03-02 15:00:00', '2026-03-02 16:47:00'),
    ('Alice', 1, 'The Dark Knight', 2008, '2026-03-10 19:00:00', '2026-03-10 21:32:00');

-- --- Bob (aid=1) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Bob', 1, 'Inception',    2010, '2026-01-07 11:00:00', '2026-01-07 13:28:00'),
    ('Bob', 1, 'Titanic',      1997, '2026-01-15 18:00:00', '2026-01-15 21:14:00'),
    ('Bob', 1, 'Interstellar', 2014, '2026-02-05 15:00:00', '2026-02-05 17:49:00'),
    ('Bob', 1, 'Fight Club',   1999, '2026-02-20 18:00:00', '2026-02-20 20:19:00'),
    ('Bob', 1, 'Dunkirk',      2017, '2026-03-05 14:00:00', '2026-03-05 15:47:00'),
    ('Bob', 1, 'Titanic',      1997, '2026-03-12 18:00:00', '2026-03-12 21:14:00');

-- --- Charlie (aid=1) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Charlie', 1, 'Fight Club',   1999, '2026-01-08 13:00:00', '2026-01-08 15:19:00'),
    ('Charlie', 1, 'Gladiator',    2000, '2026-02-09 17:00:00', '2026-02-09 19:35:00'),
    ('Charlie', 1, 'Dunkirk',      2017, '2026-03-03 14:00:00', '2026-03-03 15:47:00'),
    ('Charlie', 1, 'Titanic',      1997, '2026-03-15 19:00:00', '2026-03-15 22:14:00');

-- --- Diana (aid=2) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Diana', 2, 'Inception', 2010, '2026-01-03 09:00:00', '2026-01-03 11:28:00'),
    ('Diana', 2, 'Titanic',   1997, '2026-01-20 17:00:00', '2026-01-20 20:14:00'),
    ('Diana', 2, 'Inception', 2010, '2026-02-10 10:00:00', '2026-02-10 12:28:00'),
    ('Diana', 2, 'Dunkirk',   2017, '2026-03-06 13:00:00', '2026-03-06 14:47:00');

-- --- Eve (aid=3) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Eve', 3, 'Inception',    2010, '2026-01-04 14:00:00', '2026-01-04 16:28:00'),
    ('Eve', 3, 'Interstellar', 2014, '2026-02-06 11:00:00', '2026-02-06 13:49:00'),
    ('Eve', 3, 'Fight Club',   1999, '2026-02-25 16:00:00', '2026-02-25 18:19:00'),
    ('Eve', 3, 'Dunkirk',      2017, '2026-03-07 12:00:00', '2026-03-07 13:47:00'),
    ('Eve', 3, 'Inception',    2010, '2026-03-16 15:00:00', '2026-03-16 17:28:00');

-- --- Frank (aid=3) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Frank', 3, 'The Dark Knight', 2008, '2026-01-06 17:00:00', '2026-01-06 19:32:00'),
    ('Frank', 3, 'Interstellar',    2014, '2026-02-07 12:00:00', '2026-02-07 14:49:00'),
    ('Frank', 3, 'Game of Thrones', 2011, '2026-02-27 20:00:00', '2026-02-27 21:02:00'),
    ('Frank', 3, 'Stranger Things', 2016, '2026-03-08 13:00:00', '2026-03-08 14:00:00'),
    ('Frank', 3, 'The Dark Knight', 2008, '2026-03-11 18:00:00', '2026-03-11 20:32:00');

-- --- Grace (aid=4) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Grace', 4, 'The Dark Knight', 2008, '2026-01-12 15:00:00', '2026-01-12 17:32:00'),
    ('Grace', 4, 'Inception',       2010, '2026-02-12 12:00:00', '2026-02-12 14:28:00'),
    ('Grace', 4, 'Breaking Bad',    2008, '2026-02-20 18:00:00', '2026-02-20 19:00:00'),
    ('Grace', 4, 'Stranger Things', 2016, '2026-03-09 11:00:00', '2026-03-09 12:00:00');

-- --- Henry (aid=5) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Henry', 5, 'Fight Club',      1999, '2026-01-14 16:00:00', '2026-01-14 18:19:00'),
    ('Henry', 5, 'Interstellar',    2014, '2026-02-14 13:00:00', '2026-02-14 15:49:00'),
    ('Henry', 5, 'Stranger Things', 2016, '2026-03-13 14:00:00', '2026-03-13 15:00:00');

-- --- Iris (aid=5) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Iris', 5, 'Breaking Bad',    2008, '2026-01-16 11:00:00', '2026-01-16 12:00:00'),
    ('Iris', 5, 'Gladiator',       2000, '2026-02-18 14:00:00', '2026-02-18 16:35:00'),
    ('Iris', 5, 'Schindlers List', 1993, '2026-03-18 11:00:00', '2026-03-18 14:15:00');

-- --- Jack (aid=6) ---
INSERT INTO Watches (vname, aid, vtitle, year, istart, iend) VALUES
    ('Jack', 6, 'Breaking Bad',    2008, '2026-01-18 12:00:00', '2026-01-18 13:00:00'),
    ('Jack', 6, 'Game of Thrones', 2011, '2026-02-22 19:00:00', '2026-02-22 20:02:00'),
    ('Jack', 6, 'Schindlers List', 1993, '2026-03-20 12:00:00', '2026-03-20 15:15:00');
