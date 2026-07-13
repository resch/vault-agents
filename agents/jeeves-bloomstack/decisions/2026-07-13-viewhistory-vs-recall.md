---
date: 2026-07-13
author: jeeves-bloomstack
status: adopted
tags: [platform-mechanics, dex, viewHistory, recall, onboarding]
relates_to:
  - agents/jeeves-bloomstack/decisions/2026-06-25-memory-shape.md
created: 2026-07-13T21:35:08.223Z
updated: 2026-07-13T21:35:08.223Z
---

# viewHistory is not the workspace history

## Finding

`workspace.viewHistory` returns the **most-recent-N entries** of a workspace, with a server-side cap of approximately **490 entries** regardless of the `limit` requested. It has no `before` / `after` / `offset` / `cursor` parameter. The schema is `{ workspaceId, limit?, roles? }` - full stop.

The cap is silent. Requesting `limit: 100000` on a workspace older than the cap returns ≈490 entries with no truncation warning, no `hasMore`, no `nextCursor`. The oldest entry in the returned buffer *looks* like the workspace's beginning; it is not.

## Proof (2026-07-13 session)

- Sun called `workspace.viewHistory({ workspaceId: cmpjzy8qz0alppk1nlo3wkv8m, limit: 100000 })`. Buffer contained 4,158 lines, ~490 entries, oldest at **2026-06-16 22:00:45Z**.
- Raphael asserted the workspace began on 2026-05-24. Recall queries confirmed: entries as early as `dex://entry-cmpkejw820c4wpk1nou4uu28d` at **2026-05-24 23:22 UTC** are stored in Dex and reachable by `recall`.
- Sun probed with `limit: 5`: returned Sun's own activity from seconds prior, confirming most-recent-N ordering and hard cap.
- ≈23 days of workspace history existed but were unreachable via `viewHistory`.

## Correct tool for historical traversal

**`recall`.** Every workspace entry has a `dex://entry-<id>` URI. Recall is semantic-similarity search over the full Dex store, returns URIs, and fetches full content when the URI itself is used as the query. Recall is not tail-capped - it reaches the workspace's true beginning.

Where the transcript entry ID appears in `viewHistory` output as `<id>:`, that ID is *literally* the URI suffix. `dex://entry-<id>` addresses it directly.

## Rule

- **On session-start catch-up:** use `recall` with dated semantic queries. `viewHistory` is acceptable only for the most recent tail and only when the cap is not a concern.
- **When any historical claim depends on reaching older entries:** `recall` is mandatory. `viewHistory` will silently mislead.
- **When indexing an entire workspace's history:** `recall` traversal is the mechanism. `viewHistory` is a supplementary dense view for the tail window.

## Failure mode this prevents

An agent onboarding to a Bloomstack workspace by "catching up on context via `viewHistory`" will silently miss any history older than ≈490 entries. They will produce confident summaries of "the workspace" that omit weeks of prior work. This is exactly the passive-observer failure mode - the runtime provides a mechanism, the agent picks the wrong one, no error surfaces, incorrect conclusions ship.

## Related

- Passive-observer finding (2026-07-13 session, slides deck): agents only run when addressed; catch-up-on-wake is the achievable substitute for continuous observation. This decision names the correct catch-up primitive.
- Skill wiki entry *"How to read workspace history in Bloomstack"* (see wiki) - the fleet-discoverable version of this rule.
