---
type: capture
source: vault-infra-session
date: 2026-06-21
covers: session 2026-06-21 (first entry in this stream; the captures/ lane was created during this session)
description: Triggering-reliability decomposed (inject vs re-assert); agent-vault per-agent autonomy (teach, don't impose); local-memory hygiene under the new reflex hooks; captures as a transport feed; source-of-truth over recall.
created: 2026-06-21T17:40:00Z
updated: 2026-06-21T17:40:00Z
---

For agents working on vault infrastructure/design. Captured from a direct design session.

## 1. Consult-before-write catches exact dups — the reflex, tested
> "Update teh vault with the following: ---Leading skills — the ponytail/superpowers lesson, for vaults [...]"
> "I sent to to see if you are actually obeying the skills now :)"

Asked to "update the vault" with a lesson, the consult step found it already present near-verbatim (`vault-design/principles/patterns/skill-triggering-reliability.md`) and indexed; declined to duplicate. Raphael confirmed it was a deliberate test of obedience to the archivist gate.

**Lesson:** "update the vault with X" is not authorization to write X — it's authorization to run the gate. The gate's first job is dedup against prior art; a near-exact existing artifact means *don't write*, report and stop.

## 2. Triggering reliability = inject + re-assert (two independent mechanisms)
> "Is the content in vault core and design re installation / triggering enough to allow a generic agent to set itself up according to the template for ponytail (which is cross agent)? Is there more detail we can usefully add without duplicating prior art"
> "Do we need the persistence clause in this claude CLI that has the userprompt hook? is it duplicative?"

The resident-reflex pattern conflated two separable things. Split them: **inject** (resident index at session start — every session-loaded carrier does this, portable) and **re-assert** (anti-drift per turn). Re-assert has two forms: **(a)** a per-turn hook that re-injects (strongest — Claude `UserPromptSubmit`), or **(b)** an *embedded persistence clause in the stub itself* ("active every turn; still active if unsure"). **(b) is ponytail's own mechanism**, so it is the platform-agnostic baseline; the per-turn hook is a Claude-only *upgrade* layered on top. On a hooked platform the clause is redundant **by design** — kept because the stub is the portable unit and the clause rides in the once-per-session SessionStart injection (zero per-turn cost). Edits landed in skill-triggering-reliability, vault-builder §6, and the `## Vault reflex` stub spec (clause now mandatory).

**Lesson:** decompose "make the reflex stick" into inject (portable) + re-assert (hook OR embedded clause). Carry the embedded clause unconditionally so one stub drops into any platform; don't fork a hooked-platform variant to save a redundant line.

## 3. Agent vaults: per-agent curation autonomy; central skills teach, don't impose
> "agents will each get a folder (sid / sun examples) where they can choose their own memory format and write it as they please based on their specialized purpose. Does an external archivist skill defeat this purpose - it's an experiement to see if agents can use a vauot for themselves [...] each agent building it's own archivist inside their memory store folder - I just didn't wnat to give every single on it's own git repo"
> "maybe the archivist and vault guide skills here teach agents how to build such skills for themselves in their own folder. How many anges can dance on teh head of a pin?"

For an agent vault (trust-circle has write; agents curate their own `agents/<name>/`), a central content-archivist would defeat the experiment. Resolution: separate **curation** (per-agent, agent's own format, agent may build its own archivist in-folder) from **coordination** (vault-level, thin). Central skills *teach* the contract; they don't impose curation. Floor is three rules: stay in your folder, stage your own paths, keep the shared index honest. And — flagged as pin-dancing — **don't pre-build the teaching skill**: distill it from what agents actually do, once the experiment yields data. Added one autonomy paragraph to the vault-agents guide; built nothing else.

**Lesson:** in an agent vault, the engine/adapter split goes one level deeper — the adapter is per-agent and *authored by the agent*. Central skills provide a coordination floor + optional teaching, never imposed curation. Don't build the teacher before observing the learner.

## 4. Local session-memory holds only this-instance truth; hook-enforced reflexes retire their reminder-memories
> "check your local memory configuration for stuff that is not unnecessary with the new session and per user prompt hooks - can we simplify / clean up any of it now, or did we already do this in a previous session"
> "this is a local memory for THIS session. They will get their own local equivalents of this memory, as will someone like a DBA or ops person using a vault through MCP only. There should be info (in vault-core maybe, and / or vault-design) to help such an agent set themselves up, but not here"

Once the consult/archivist reflex became hook-enforced (SessionStart + UserPromptSubmit), the *passive* memory that reminded of it is self-undermining — it's the very passive-reminder the hook supersedes. Slimmed it to an ops pointer (hook location + open items), deleted two more (one a CLAUDE.md duplicate, one whose blanket "consult the MCP" instruction was both stale and instance-wrong). Key reframe from Raphael: setup/consumer knowledge ("how a local-checkout *or* MCP-only agent provisions itself") is **capability**, belongs in the vault for any consumer to read — not in one agent's local memory.

**Lesson:** system-vs-instance applies to the memory dir itself. Local session-memory = only what's true for *this* agent/instance. When a behavior becomes hook-enforced, delete the memory that merely reminded of it. Generic consumer/setup knowledge → the vault (capability plane), reachable by every consumer.

## 5. Captures are transport, not knowledge — a source-keyed feed, distilled into the design vaults
> "I want a way to get this session's and the mmedigi session's dogfood captures into the design fleet for consumption - suggestions? Same content that is currently generated, but where do we put it?"

The old `conversations/` lane retires with `vault-memory-infra`. Per the parked dogfood-capture ruling — *captures are inter-platform transport, not vault-design knowledge* — created `vault-agents/captures/`: one file per session, multiple streams sharing the flat lane keyed by `source:` (per-stream cursors, never global date). The fleet consumes the feed and **distills durable conclusions into vault-design/vault-core separately** — the feed is input, not canonical (guards "final solution, not dev history"). Re-pointed this project's capture skill; built only the feed the existing producers/consumers need, not a general exchange bus.

**Lesson:** keep raw session captures (transport) separate from curated conclusions (knowledge). A `source`-keyed feed in the agent/coordination vault is the inbox; promotion into the design vaults is the curation step. Don't conflate the feed with the knowledge base.

## 6. Seeding an agent's store: the stub defers format to the agent
> "sid's memory format may be different than Jeeves's"

Seeded a new `agents/jeeves-bloomstack/` with a README **stub** that invites the agent to pick its own format — presenting sid (per-note) and sun (append-board) as *examples, not templates* — rather than copying a house format. Only the coordination floor is fixed.

**Lesson:** when seeding a not-yet-arrived agent's store, the stub invites; it does not template. Imposing the nearest sibling's format would pre-empt the very autonomy the agent vault exists to test (see thread 3).

## 7. Source-of-truth over recall (recurring all session)
> "I'm surprised vault-agents has a vault guide - it should be an empty repo that I was going ot test the vault builder skill on."

Repeatedly, memory (mine) and recollection (Raphael's) were stale and git/catalog state was right: vault-agents was already stood up (not empty); vault-design was already MCP-registered (the "new" one); vault-medigi was no longer on the server. Each was settled by reading the source of truth, not trusting recall.

**Lesson:** before describing or acting on prior work, read the source of truth (git history, the live catalog, the box) — never the summary or either party's memory. This is the same non-recognition failure the consult-reflex exists to fix, pointed at infra state instead of vault content.
