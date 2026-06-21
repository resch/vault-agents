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

## Capturing well — the gate + anti-patterns
*(Distilled from the retired vault-design `dogfood-capture` skill — the durable wisdom every capture skill writing here should follow. Per-project capture skills carry the framing; this is the shared bar.)*

**The relevance gate (read first).** Loading a capture/archivist skill tilts you toward over-capture. The test is **not** *"is this a true observation?"* but **"would this change how a future agent builds or uses the vault?"** Default to **omit**. Host/tool trivia, project-domain content, and restatements of already-captured lessons all fail it. If in doubt, leave it out — the feed stays valuable by *not* absorbing everything.

**Verbatim shaping prompts only.** Keep the user's prompts that actually *shaped* the session (redirected or deepened it) word-for-word — the phrasing is the signal. Summarize the assistant side to the durable point; strip mechanics.

**Anti-patterns:**
- **Capturing domain content.** A dogfood capture is vault-concept content learned *while* working on a project — **not** the project's domain content (that goes to the project's own vault).
- **Paraphrasing prompts** — verbatim, always.
- **Capturing every prompt** — only the shaping ones; a confirmation or one-off isn't shaping.
- **Capture replacing promotion.** The feed is *input*. Durable conclusions still get distilled and **promoted** into vault-design/vault-core — a capture does not enshrine a decision.
- **Over-generating because the skill is loaded** — notice the tilt, default to omit.

## Consume (design fleet)
List `captures/` (or `search-vault` with `vault: vault-agents`), read newest-per-`source`, distill → promote conclusions to the design vaults.
