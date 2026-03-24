# COSC 3P32 – Group 4 Project

**Course:** COSC 3P32 – Introduction to Database Systems, Winter 2026  
**Group:** 4

## Contents

| File | Description |
|---|---|
| `schema.sql` | `CREATE TABLE` statements (Part 1 design, updated for Part 2: VARCHAR types, semicolons, seasons ≥ 1 check) |
| `triggers.sql` | PostgreSQL trigger functions and triggers for Part 2 constraints |
| `data.sql` | Sample `INSERT` statements — covers all five required queries and Jan/Feb/Mar 2026 watch history |
| `queries.sql` | Five required views (`vw_movie_cast`, `vw_show_episodes`, `vw_account_watch_history`, `vw_actor_genre_impact`, `vw_monthly_top_videos`) with example queries |
| `solution.md` | Part 1 written solution (ER model, relational schema, normalization) |
| `3P32proj2.pdf` | Project Part 2 specification |
| `3P32proj1 (1).pdf` | Project Part 1 specification |
| `3P32assn1SampleSolutions.pdf` | Assignment 1 sample solutions |
| `3P32proj1SampleSolutions.docx` | Project 1 sample solutions |

## Database Setup (PostgreSQL)

Run the four SQL files **in order** against your PostgreSQL group account:

```bash
psql -f schema.sql
psql -f triggers.sql
psql -f data.sql
psql -f queries.sql
```

## Required Queries

All five required queries are implemented as views in `queries.sql`.
Uncomment and run the example `SELECT` statements to test each query.

| Query | View | Description |
|---|---|---|
| 1 | `vw_movie_cast` | Actors, pay, and role for a given movie |
| 2 | `vw_show_episodes` | All episodes for a given show |
| 3 | `vw_account_watch_history` | Viewer watch history for a given account and month |
| 4 | `vw_actor_genre_impact` | Average movie rating per genre for a given actor |
| 5 | `vw_monthly_top_videos` | Top 5 most-watched videos for a given month |

## Enforced Constraints

| Constraint | Mechanism |
|---|---|
| `rating` between 0 and 100 | `CHECK` in `Movie` |
| `year` between 1900 and 2026 | `CHECK` in `VideoD` |
| `iend >= istart` | `CHECK` in `Watches` |
| `seasons >= 1` | `CHECK` in `Show` |
| Standard account ≤ 1 viewer | `trg_standard_viewer_limit` trigger |
| Non-overlapping watch intervals | `trg_non_overlapping_watches` trigger |
| Episode season within show's season range | `trg_episode_season_check` trigger |