---
name: vault-guide
description: Orientation + routing for vault-agents — what it is (the cross-platform agent contract + flavored-agent config/memory stores), where things live, and how to add agent config/memory. The concierge over this vault's skills; it points, never duplicates.
metadata:
  type: skill
  status: active
---

# vault-guide — using vault-agents well

Orientation/router for **vault-agents** (instance of the vault-core `vault-guide` base). The **consult-before-rebuild gate** is global runtime; this routes *within* this vault.

## What this vault is
The home for **configuring uniquely-flavored agents + their durable memories**, plus the **canonical cross-platform "ways of working with me" contract**. The vault is canonical; per-platform agent configs are projections of it.

## Structure map (lanes)
- `ways-of-working.md` — the **generic** cross-platform agent contract (every platform projects from it).
- `agents/<name>/` — a **flavored** agent's own config + memory (`sid` = conceptual observations; `sun` = strategic terrain; Jeeves/Bloomstack to follow).
- `skills/` — this guide (+ `archivist`, `self-audit` pending).
- `vault.yaml` — manifest + access-policy (trust-circle: me + my agents; **write** granted so agents curate their own store).
- `README.md` / `MEMORY.md` / `SKILLS.md`.

## Skill router
| Skill | What it does | When | Path |
|---|---|---|---|
| `vault-guide` | this — orient + route | start of any vault work | `skills/vault-guide/SKILL.md` |
| `archivist` *(pending)* | admit + place agent config/memory; promote durable cross-agent claims | adding/curating a store | `skills/archivist/SKILL.md` |
| `self-audit` *(pending)* | coherence (links/index) + agent-store checks | after a burst of writes | `skills/self-audit/SKILL.md` |

Reach any skill **by path** — `skills/<name>/SKILL.md` — so routing works even with no skill-runtime.

## How to add agent config / memory
Pull first → place under the right lane (`ways-of-working.md` for **generic** contract changes; `agents/<name>/` for a **flavored** agent's config/memory) → scoped commit (`git add <paths>`) → push (the `resch` helper). Generic-vs-flavored is the key call: a universal preference goes in the contract; an agent's specialization or accumulated memory goes in its own store. Concrete-system config (e.g. attention-policy) belongs to its system, **not** the generic contract.

## Your folder is yours (agent autonomy — the experiment)
Your `agents/<name>/` is **yours**. Pick your own memory format and structure for your specialized purpose; if you want curation discipline, **build your own archivist/guide skill inside your folder** — this vault won't impose one. The vault asks only three things: **stay in your folder** (don't restructure another agent's), **stage your own paths** (`git add <paths>`, never `-A`), and **keep the shared index honest** (`MEMORY.md`/`SKILLS.md`). That floor is coordination, not curation. (This vault is an open experiment in whether agents can keep a vault for themselves; central teaching skills, if any, get distilled from what agents actually do here — not pre-built.)

## Hard-won lessons (universal)
Pull before you work; **`git add <paths>`, never `-A`**; propose-before-write + verify staged==accepted; commit ≠ push; **classify by content, not origin**; **generic contract ≠ concrete-system config**.

## Maintaining this skill
Grounded only; propose-don't-auto-edit; **point, don't duplicate** — especially `ways-of-working.md`.
