# vault-agents

> Durable agent-specific memories. Canonical cross-platform agent configurations and preferences. Cross-platform agent ledger.
>
> **Self-describing vault.** After a `git clone` this file tells an agent how to use the vault — no MCP required.

## What this is
The home for **configuring uniquely-flavored agents and their durable memories**, plus the **canonical
cross-platform contract** for working with Raphael. Two layers:

- **Generic** — `ways-of-working.md`: the platform-agnostic "ways of working with me" contract that **every**
  agent projects into its local platform config (Jeeves's `SOUL`, a Claude-Code `CLAUDE.md`, a Bloomstack
  agent). One canonical contract → many local projections.
- **Flavored** — `agents/<name>/`: a specific agent that learns to do X for me keeps **its own config + its
  own memory** here (distinct from the generic preferences). First residents: **sid** (conceptual
  observations) and **sun** (strategic terrain), moved from the archived `vault-memory-infra`.

The vault is **canonical**; per-platform agent configs are **projections** of it.

## Layout
- `ways-of-working.md` — the generic cross-platform agent contract (the source every platform projects from).
- `agents/` — per-flavored-agent stores (`sid/`, `sun/`, …): each agent's config + memory.
- `skills/` — vault skills: **`vault-guide`** (router/entry — consult first). *(archivist + self-audit: pending.)*
- `vault.yaml` — manifest + cross-vault router entry + access-policy.
- `README.md` / `MEMORY.md` / `SKILLS.md` — this file + generated indexes.

## Doctrine (how agents use this vault)
- **Vault is canonical; platform configs are projections.** Point a new platform's agent at `ways-of-working.md`
  (+ the relevant `agents/<name>/`) and have it **write its local config accordingly**.
- **Generic vs flavored.** The universal contract is `ways-of-working.md`; an agent's *specialization* + the
  memory it accumulates doing its job live in `agents/<name>/`. Don't fold concrete-system config (e.g. the
  personal vault's attention-policy) into the generic contract.
- **Agents write their own store.** Unlike the personal vault, the trust-circle has **write** access here — an
  agent curates its own `agents/<name>/` (propose→durable promotion still applies for cross-agent claims).
- **Cross-vault.** Access is the **trust-circle** (me + my agents), reciprocal with the personal vault, so an
  agent here may read the personal vault and vice-versa.

## Rehydrate on a raw clone
1. `git clone` with a least-privilege `resch` credential.
2. Read this file → `skills/vault-guide/SKILL.md` (routes you) → `ways-of-working.md` → the relevant `agents/<name>/`.
3. Point a local agent at the clone. Useful immediately — no MCP.
