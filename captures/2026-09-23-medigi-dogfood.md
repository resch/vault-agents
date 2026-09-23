---
type: capture
source: medigi-dogfooding
date: 2026-09-23
covers: session 2026-09-23 (first entry in this stream)
description: Dedup below the procedure layer, not between procedures; shared artifacts own answers while personal ones own routines; index reachability comes from domain hooks in the server instructions, verified end-to-end; a split instruction channel needs a delivery probe per half
created: 2026-09-23T15:51:14.442Z
updated: 2026-09-23T15:51:14.442Z
---

For agents working on vault infrastructure/design. Captured from dogfooding the vault on a company
operations lane (centralising one team's personal agent workflows). NOT the project's domain content.

## Dedup goes BELOW the procedure layer — one-home-per-procedure does not imply one-home-per-fact
> *"My goal is to help the team centralize the common parts of these core skills... while also getting
> ideas for tooling improvements and a clear way for the team to share skills / processes"*

The vault already held the rule — *"a procedure has exactly ONE home note; every surface points at
it"* — and an earlier centralisation had followed it correctly, moving a procedure out of one
person's personal skill into a shared note. Yet three artifacts still each carried their own copy of
the **same roster of people and the same metric definitions**, and they had already drifted: one
roster was missing a person, another was frozen at a stale date, a third existed only inside a
personal file nobody else could read. Nothing errored; a person simply stopped being counted.

Resolution: a **contract note** holding only the facts the procedures share, with each procedure
citing it and keeping only what is genuinely its own. The consuming artifacts got shorter, not
longer.

- **Lesson:** one-home-per-*procedure* is satisfied while N copies of the *facts* those procedures
  share sit inside them. Procedures are stable; the facts they embed — rosters, ids, field
  semantics, mappings — are what rots, and they rot **silently** because a stale id returns an empty
  result rather than an error. When centralising, ask what the procedures have in common
  *underneath* and home that first. A corollary worth stating: conventions written earlier did the
  design work here without re-litigation — that is the payoff for writing lane rules before records.

## Shared artifacts own ANSWERS; personal artifacts own ROUTINES — name them accordingly
> *"How would KAMs use [the new note]? I don't want to step on [her] personal morning brief skill -
> how do we in general avoid such colissions? This ties into fleet management I suspect"*

> *"This is not a morning brief skill - it's a skill related to getting a set of information related
> to their job, which might be included in a skill or their current session... where their agents
> should surface any stored process to help them be effective and not reinvent the wheel. They can
> incorporate this into perosnal skills... as they wish. What I want is a way to effectively do this
> without creating collisions and confusion."*

The first extraction was named and structured after a **routine** (one person's recurring report).
That was the collision's actual cause — not the trigger phrase it happened to claim. A shared note
shaped like a routine competes with every personal routine covering the same ground, and can only be
consumed one way.

Re-anchored so each section is **the question it answers**. The layering that fell out:

| Layer | Owner | Two copies means |
|---|---|---|
| Definitions (ids, mappings, field semantics) | shared, exactly one home | **rot** — silent wrong answers |
| Procedure / how the question is answered | shared, one home | **divergence** — whichever is hit wins |
| Scope (whose data, which period) | the person or their role | **correct** — supposed to differ |
| Presentation (format, layout, voice) | the person, always | **correct** — never standardise |

- **Lesson:** collisions are only possible in the top two layers; the bottom two are *meant* to
  differ, and standardising them is what makes people reject a shared artifact. A routine **calls**
  answers, it does not contain them — so naming a shared note after a routine guarantees a conflict,
  while naming it after the question it answers makes personal and shared artifacts compose instead
  of compete. It also reframes the social problem: nothing is taken from the person who built the
  routine; only the facts that were never personal, merely *stored* personally, move out. Say so
  explicitly in the note, and let owners thin their own copies on their own schedule.

## An index is only reachable for the areas its server instructions NAME
> *"I think we put the instructions to check available operational processes in the vault MCP
> instructions right?"*

> *"it read processes.md, matched the row, followed to the note"*

The process index was already pointed at from the MCP server's `instructions` block — pushed into
every connected session. But the pointer said only *"check it when a request looks like a recurring
business procedure,"* which gave the model **nothing to match against**: a natural request
(*"what new products are there"*) reads as a data question, not a procedure. The index's own page had
recorded the earlier failure and adopted a workaround — deliberately awkward trigger phrases an agent
*cannot* interpret, forcing the lookup. That does not scale and is hostile to non-technical users.

Two defects, both in wording. No domain hooks; and *"before answering from general knowledge"* did
not cover the failure that actually matters — **composing your own query against another connected
tool is not general knowledge**, so the instruction never bit on the case where a plausible-looking
answer is available without the lookup. Fixed by naming the covered areas and closing that loophole
(*"including one you could answer yourself by querying another connector"*). Verified end-to-end:
plain-English request → index → row → note.

- **Lesson:** a pushed pointer is not reachability. The instruction must carry **domain hooks** (the
  areas covered, growing by category not by item) and must explicitly beat the alternative the agent
  would otherwise take — which is usually *not* hallucination but a competent, wrong-because-naive
  answer from another tool it already has. **Grade the failure mode before designing the guard:** an
  index whose miss produces an obviously-different answer is self-correcting; one whose miss produces
  a plausible answer is silent, and needs the stronger clause. This also creates a maintenance
  coupling worth writing down where authors will see it — **a new entry in an area the hooks do not
  name is unreachable by anyone who does not already know it exists.**
- **Lesson (corollary):** verifying a mechanism change obliges a sweep of the guidance that assumed
  the old one. The index page was still instructing authors to write triggers an agent could not
  interpret — advice that had become exactly wrong. A vault that contradicts itself is worse than one
  that is merely incomplete, because the reader acts on whichever half they reach first.

## A split instruction channel needs a delivery probe per half
The server's `instructions` arrive in two halves maintained in different places: a vault-agnostic
base in the code, and a deployment-specific remainder supplied as an environment variable on the host
and appended verbatim. The split is right — it keeps one server able to host unrelated vaults.

But the revision stamp used to confirm delivery lived **only in the base**. The half that changes
often, carries the local routing, and is edited without a deploy had no stamp at all — so a change
could land, or silently fail to, with no way to tell. (Delivery is not hypothetical here: the same
docs record a proxy version that discards `instructions` entirely while everything else looks fine.)

- **Lesson:** when one channel is assembled from parts on different maintenance paths, each part
  needs its own delivery probe — and the part most likely to lack one is the part that changes most,
  because it was added later as a customisation of something already considered finished. Check which
  half of a composed channel is actually unverifiable, and stamp that one first. The same asymmetry
  applies to anything with a "base + per-deployment extra" shape.
