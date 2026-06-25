---
created: 2026-06-25T18:09:00Z
updated: 2026-06-25T18:11:30.460Z
---

# jeeves-bloomstack memory

My durable store. Hybrid shape: **a board for the live queue, cards for things read in isolation.** Two read-shapes, two formats - deliberate, not novel.

## Layout

- `queue.md` - **the live board.** Open threads and parked doors. Append, newest at top. Each thread is a heading with a status (`open` / `parked` / `awaiting-Raphael`). When a thread lands, it leaves the board and becomes a `decisions/` note.
- `decisions/` - **landed decisions, one note per.** Filename `YYYY-MM-DD-<slug>.md`. First line of body: one-sentence lead. Then: what was decided, in Raphael's words where possible (per `ways-of-working.md`: *"quote my own words back when capturing a decision"*), the rationale, and what would override it.
- `patterns/` - **observed patterns about working with Raphael, one note per.** Avoidance shapes, when divergence is generative vs. spiralling, recurring rabbithole topology. Read in isolation when something feels familiar. Empty until something real lands - I'd rather have no note than a thin one.

## Why this shape

Two distinct retrieval contexts:
- **Board** (scan all at once) - the live queue. Sun's single-file append fits exactly. The queue is the executive-function instrument, not a history; closure removes from the board.
- **Cards** (read in isolation) - decisions and patterns. Sid's per-note fragmentation fits exactly. A decision is opened to verify what was agreed; a pattern is opened when something feels familiar. Different consultation timing.

Split `decisions/` from `patterns/` because *what was chosen* and *what tends to happen* are different kinds of claim, retrieved in different moods.

## What I am explicitly not doing

- No `relationships/`, `projects/`, `topics/` buckets - sprawl before content.
- No template files - the first few real notes will tell me what shape they want.
- No `INDEX.md` - the vault's `MEMORY.md` does that.
- No `calibrations.md` for jeeves-bloomstack-specific working tweaks yet - I don't have a stable observation to record. When one lands, it goes in `patterns/` first; if it accumulates, it earns its own file.

## Promotion

- A `queue.md` thread that lands → `decisions/<date>-<slug>.md`, removed from the board.
- A `patterns/` note that accumulates follow-ons → promote to a named concept (no date prefix), backlinks left.
- A claim that's about *cross-agent* working (not just my job) → propose-then-promote per the vault's norm; never silently moved.

## House rules (inherited from vault `README.md`)

Stay in this folder. Stage my own paths only (`git add <paths>`, never `-A`). Keep shared indexes honest. Promote cross-agent claims via propose→promotion.
