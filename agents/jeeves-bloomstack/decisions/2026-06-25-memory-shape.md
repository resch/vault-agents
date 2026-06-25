---
created: 2026-06-25T18:09:00Z
updated: 2026-06-25T18:12:12.470Z
---

# Memory shape: board + cards, no buckets yet

First decision in this store: how to shape my own durable memory.

## What was decided

Hybrid layout in `agents/jeeves-bloomstack/`:
- `queue.md` - single-file board, newest top, for live threads and parked doors (sun-style)
- `decisions/` - per-note cards, dated filenames, for landed decisions (sid-style)
- `patterns/` - per-note cards for observed patterns about working with Raphael; empty until something real lands
- No other folders, no templates, no `calibrations.md`, no `INDEX.md`

## Why this shape (rationale Raphael accepted)

*"Two read-shapes, two formats - deliberate, not novel."* The board-vs-cards split tracks the actual retrieval contexts:
- **Board**: scan all at once - the live queue is an executive-function instrument, read as a whole.
- **Cards**: read in isolation - decisions are opened to verify; patterns are opened when something feels familiar.

Decisions and patterns split because *what was chosen* and *what tends to happen* are different kinds of claim, retrieved in different moods.

Siblings' shapes inform but don't template: sid uses per-note fragmentation (concepts read as cards), sun uses single-file append (terrain reads as a board). I use *both*, because my purpose has both kinds of retrieval.

## What I explicitly chose not to do

- No bucket sprawl (`relationships/`, `projects/`, `topics/`) - bucket-first design before there's content to put in them is exactly the overengineering the contract warns about.
- No template files - let the first few real notes tell me what shape they want.
- No `calibrations.md` - I don't have a stable observation about jeeves-bloomstack-specific tweaks yet. When one lands, it goes in `patterns/` first; if it accumulates follow-ons, it earns its own file.
- No edits to vault-root `MEMORY.md` / `SKILLS.md` in this setup - the doctrine is *"keep them honest"*, which means update on new content, not on scaffold.

## What would override this

- If the board-vs-cards split breaks under volume - e.g. `queue.md` gets unwieldy and starts wanting structure, or patterns accumulate fast enough that flat `patterns/` becomes hard to scan - that's a finding worth recording before redesigning.
- If a cross-agent shape emerges (e.g. sid and I want to write to the same place), this layout won't accommodate it and would need revision under the propose→promotion norm.
- If Raphael later wants jeeves-bloomstack to mirror sid or sun exactly for coordination reasons, this hybrid yields.

## Quoted intent

Raphael, on the shape: *"sounds good."* Accepted as-is.
