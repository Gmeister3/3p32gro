# COSC 3P32 – Introduction to Database Systems
## Winter 2026 — Group Project, Part 1

---

## 1. ER Model

### Entity Sets and Their Attributes

**Actor**
- Attributes: stagename *(key)*, realname, abirthyear, abirthplace, unum
- Note: unum is unique but nullable (some actors may not have a union number).

**Director**
- Attributes: dname *(key)*, dbirthyear, dbirthplace

**Video**
- Attributes: vtitle, year *(composite key: vtitle + year)*, studio, genre

**Movie** (ISA Video)
- Additional attributes: mlength, rating
- Constraint: rating is an integer between 0 and 100 (check constraint, part 2).

**Show** (ISA Video)
- Additional attribute: seasons

**Episode** (weak entity, identified by BelongsTo relationship)
- Partial key: etitle
- Attributes: enum, eseason, elength
- Note: enum and eseason are unique within a show (i.e., no two episodes of the same show share the same (enum, eseason) combination).

**AccountType** *(new entity set for Project 1)*
- Attributes: account_type *(key)*, monthly_cost
- Values for account_type: 'Standard', 'Premium'

**Account**
- Attributes: aid *(key)*, aphone, credit_card
- Note: aphone is unique (one phone per account). credit_card is unique (one credit card per account).
- Relationship to AccountType: each account has exactly one account_type.

**Viewer** (weak entity, identified by Shares relationship)
- Partial key: vname
- Attributes: vpref

### Relationship Sets

**Directs** (Director → Video, 1-many, total participation of Video)
- Attribute: dpay
- Every video must be directed by exactly one director; a director may direct many videos.

**ActsIn** (Actor ↔ Video, many-many)
- Attributes: apay, role
- An actor may act in many videos; a video may have many actors.

**BelongsTo** (Episode → Show, many-one, total participation of Episode)
- Every episode belongs to exactly one show; a show may have many episodes.
- Identifying relationship for the Episode weak entity set.

**Shares** (Viewer → Account, many-one, total participation of Viewer)
- Every viewer is associated with exactly one account; an account may have many viewers (subject to type constraint).
- Identifying relationship for the Viewer weak entity set.

**HasType** (Account → AccountType, many-one, total participation of Account)
- Every account has exactly one account type.

**Watches** (Viewer, Video → Interval, ternary or with inline attributes)
- Attributes: istart, iend (representing the watch interval)
- Note: istart ≤ iend (check constraint, part 2). Viewer cannot watch more than one video simultaneously (trigger required, part 2).

### ISA Constraints

- Movie and Show are subclasses of Video.
- **Overlap constraint**: Movie and Show do not overlap (a video cannot be both a movie and a show).
- **Covering constraint**: Movie and Show do NOT cover Video (there may be videos that are neither movies nor shows — e.g., trailers, short clips).

### Additional Overlap and Covering Constraints

- There are no other ISA hierarchies in this schema.
- The Shares relationship ensures every viewer belongs to exactly one account (total participation of Viewer).
- The BelongsTo relationship ensures every episode belongs to exactly one show (total participation of Episode).
- Standard accounts can only have one viewer; Premium accounts may have any number of viewers. This is an overlap/multiplicity constraint on the Shares relationship, enforced in part 2 via a trigger or check.

---

## 2. Relational Schema

The following relational schema is derived from the ER model above. Combining weak entity sets with their identifying relationships, and 1-many total-participation relationships where appropriate:

```
Actor(stagename, realname, abirthyear, abirthplace, unum)
  PK: stagename
  UNIQUE: unum

Director(dname, dbirthyear, dbirthplace)
  PK: dname

VideoD(vtitle, year, studio, genre, dname, dpay)
  PK: (vtitle, year)
  FK: dname → Director(dname)
  [Combines Video and Directs since Directs is 1-many with total participation of Video]

Movie(vtitle, year, mlength, rating)
  PK: (vtitle, year)
  FK: (vtitle, year) → VideoD(vtitle, year)

Show(vtitle, year, seasons)
  PK: (vtitle, year)
  FK: (vtitle, year) → VideoD(vtitle, year)

ActsIn(stagename, vtitle, year, apay, role)
  PK: (stagename, vtitle, year)
  FK: stagename → Actor(stagename)
  FK: (vtitle, year) → VideoD(vtitle, year)

EpisodeOf(etitle, enum, eseason, elength, vtitle, year)
  PK: (etitle, vtitle, year)
  UNIQUE: (enum, eseason, vtitle, year)
  FK: (vtitle, year) → Show(vtitle, year)
  [Combines Episode and BelongsTo since Episode is a weak entity set]

AccountType(account_type, monthly_cost)
  PK: account_type
  [Extracted from Account to satisfy BCNF — see Section 3]

Account(aid, aphone, account_type, credit_card)
  PK: aid
  UNIQUE: aphone
  UNIQUE: credit_card
  FK: account_type → AccountType(account_type)

ViewerShares(vname, aid, vpref)
  PK: (vname, aid)
  FK: aid → Account(aid)
  [Combines Viewer and Shares since Viewer is a weak entity set]

Watches(vname, aid, vtitle, year, istart, iend)
  PK: (vname, aid, vtitle, year, istart, iend)
  FK: (vname, aid) → ViewerShares(vname, aid)
  FK: (vtitle, year) → VideoD(vtitle, year)
```

---

## 3. Functional Dependencies and Normalization

For each relation, all non-trivial functional dependencies (FDs) are listed, candidate keys are identified, and BCNF/3NF status is determined.

---

### Actor(stagename, realname, abirthyear, abirthplace, unum)

**Functional Dependencies:**
- stagename → realname, abirthyear, abirthplace, unum
- unum → stagename (holds when unum is not null, since unum is UNIQUE)

**Candidate Keys:** {stagename}
(unum is not a candidate key because it is nullable — actors without union numbers have unum = NULL, and NULL does not functionally determine anything)

**Normalization:**
The only fully determining FD is stagename → {all other attributes}. The FD unum → stagename holds only on non-null values; since unum may be NULL, it is not a proper candidate key.

**Result: BCNF** — the only non-trivial FD whose LHS is guaranteed to be a superkey is stagename → {…}.

---

### Director(dname, dbirthyear, dbirthplace)

**Functional Dependencies:**
- dname → dbirthyear, dbirthplace

**Candidate Keys:** {dname}

**Result: BCNF** — the only non-trivial FD has dname (the sole candidate key) as its LHS.

---

### VideoD(vtitle, year, studio, genre, dname, dpay)

**Functional Dependencies:**
- (vtitle, year) → studio, genre, dname, dpay

**Candidate Keys:** {vtitle, year}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### Movie(vtitle, year, mlength, rating)

**Functional Dependencies:**
- (vtitle, year) → mlength, rating

**Candidate Keys:** {vtitle, year}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### Show(vtitle, year, seasons)

**Functional Dependencies:**
- (vtitle, year) → seasons

**Candidate Keys:** {vtitle, year}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### ActsIn(stagename, vtitle, year, apay, role)

**Functional Dependencies:**
- (stagename, vtitle, year) → apay, role

**Candidate Keys:** {stagename, vtitle, year}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### EpisodeOf(etitle, enum, eseason, elength, vtitle, year)

**Functional Dependencies:**
- (etitle, vtitle, year) → enum, eseason, elength
- (enum, eseason, vtitle, year) → etitle, elength

**Candidate Keys:** {etitle, vtitle, year} and {enum, eseason, vtitle, year}

Both FDs have a candidate key as the LHS.

**Result: BCNF** — every non-trivial FD has a superkey on the LHS.

---

### AccountType(account_type, monthly_cost)

**Functional Dependencies:**
- account_type → monthly_cost

**Candidate Keys:** {account_type}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### Account — Original (before normalization)

If we had kept the Account relation as:
`Account(aid, aphone, account_type, monthly_cost, credit_card)`

The functional dependencies would be:
- aid → aphone, account_type, monthly_cost, credit_card
- account_type → monthly_cost  ← **violation of BCNF** (account_type is not a superkey)
- aphone → aid (aphone is UNIQUE, so it functionally determines aid)
- credit_card → aid (credit_card is UNIQUE, so it functionally determines aid)

**Candidate Keys:** {aid}, {aphone}, {credit_card}

The FD `account_type → monthly_cost` violates BCNF because account_type alone is not a superkey.

**BCNF Decomposition:**

We decompose on `account_type → monthly_cost`:

1. **AccountType(account_type, monthly_cost)**
   - Contains the violating FD. PK: account_type.
2. **Account(aid, aphone, account_type, credit_card)**
   - Removes monthly_cost; retains account_type as FK to AccountType.

**Lossless-join check:** The decomposition is lossless because account_type appears in both relations, and account_type is the key of AccountType.

**Dependency-preserving check:**
- `account_type → monthly_cost` is preserved in AccountType. ✓
- `aid → aphone, account_type, credit_card` is preserved in Account. ✓
- `aphone → aid` is preserved in Account. ✓
- `credit_card → aid` is preserved in Account. ✓
- `aid → monthly_cost` can be derived via `aid → account_type` (in Account) and `account_type → monthly_cost` (in AccountType). ✓

**Result: Lossless-join, dependency-preserving BCNF decomposition achieved.**

---

### Account(aid, aphone, account_type, credit_card) — After decomposition

**Functional Dependencies:**
- aid → aphone, account_type, credit_card
- aphone → aid
- credit_card → aid

**Candidate Keys:** {aid}, {aphone}, {credit_card}

**Result: BCNF** — every non-trivial FD has a candidate key as its LHS.

---

### ViewerShares(vname, aid, vpref)

**Functional Dependencies:**
- (vname, aid) → vpref

**Candidate Keys:** {vname, aid}

**Result: BCNF** — the only non-trivial FD has the candidate key as its LHS.

---

### Watches(vname, aid, vtitle, year, istart, iend)

**Functional Dependencies:**
- No non-trivial FDs (the entire tuple is the primary key; all attributes together determine nothing beyond themselves).

**Candidate Keys:** {vname, aid, vtitle, year, istart, iend}

**Result: BCNF** — trivially, since there are no non-trivial FDs.

---

### Final Relational Schema (after normalization)

```
Actor(stagename, realname, abirthyear, abirthplace, unum)
Director(dname, dbirthyear, dbirthplace)
VideoD(vtitle, year, studio, genre, dname, dpay)
Movie(vtitle, year, mlength, rating)
Show(vtitle, year, seasons)
ActsIn(stagename, vtitle, year, apay, role)
EpisodeOf(etitle, enum, eseason, elength, vtitle, year)
AccountType(account_type, monthly_cost)
Account(aid, aphone, account_type, credit_card)
ViewerShares(vname, aid, vpref)
Watches(vname, aid, vtitle, year, istart, iend)
```

---

## 4. SQL CREATE TABLE Statements

See the accompanying file `schema.sql` for the full set of SQL statements.

Key notes:
- `CHECK` constraints are added where expressible at the schema level (year range, rating range, istart ≤ iend).
- Constraints that require cross-row or cross-table logic (e.g., non-overlapping watch intervals for the same viewer, at-least-one-season constraint, season number within show's season count, and Standard account single-viewer limit) are **deferred to Part 2** using triggers or other database mechanisms.
