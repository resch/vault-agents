---
created: 2026-06-21T17:22:49Z
updated: 2026-06-21T17:22:49Z
---

# captures — the dogfood / design-session feed

The **exchange channel** for session captures the design fleet consumes. When a session **builds/evolves the vault** (direct design) or **dogfoods it on real work** (e.g. medigi), it drops one capture here. The fleet reads these to inform design.

**This is transport, not canonical knowledge.** Captures are *input* — raw lessons from using/building the vault. Durable conclusions get **distilled and promoted** into vault-design (`principles/`/`research/`) or vault-core by the fleet; they do **not** stay here as the source of truth. Don't treat `captures/` as a knowledge base, and don't let it become a dev-history dump — the relevance gate still applies (capture only what would change how a future agent builds/uses the vault).

## Shape
- **One file per session:** `YYYY-MM-DD-<slug>.md` (slug = the theme). Same-day collision → suffix `-2`.
- **Multiple streams share this flat lane, keyed by `source:`** — never by global date. Each stream advances its own cursor (the newest same-`source` file), so interleaved streams don't skip each other's uncaptured sessions.
  - `source: vault-infra-session` — direct vault/memory-infra design sessions (this `dev/raphael` project).
  - `source: medigi-dogfooding` — dogfooding the vault on medigi work.
  - new platforms add their own `source:` value.
- **Frontmatter:** `type: capture`, `source:`, `date:`, `covers:` (range), `description:`.
- **Not indexed in MEMORY.md** — captures are discovered by listing this dir / `search-vault` (`vault: vault-agents`), not via the index.

## Consume (design fleet)
List `captures/` (or `search-vault` with `vault: vault-agents`), read newest-per-`source`, distill → promote conclusions to the design vaults.
