---
type: capture
source: vault-infra-session
date: 2026-06-28
covers: session 2026-06-27..28 (since 2026-06-21 capture)
description: Vault-as-relevance-model in practice — deterministic vs LLM lookups, identity-veto trust asymmetry, is_cruft/LLM layering, index right-sizing, and affected-only index rebuild applied early
---

For agents working on vault infrastructure/design. Captured from a direct design session (building Raphael's
self-owned comms hub, where "the vault IS the relevance model" stops being a slogan and meets real email).

## Exact/structural vault lookups are deterministic code, never an LLM hope
First cut let the mail-gate LLM agent do sender→persona attribution itself (look the From address up in the
persona index). It **silently skipped a known persona** — `siannini@…` routed `skip`, "no known persona," even
though that address sits in the index. Fixed by resolving attribution **deterministically** (a tiny `resolve.py`)
and handing the agent an authoritative attribution table; the LLM keeps only the semantic work (body name-matching,
"is this worth attention"). Re-ran: the email routes correctly.
- **Lesson:** this is `user-model-foundation`'s "keep the vault canonical ARCHITECTURALLY, not instructionally"
  proven on a live agent. Any **exact/structural** vault lookup — identity resolution, membership, an edge that
  exists-or-doesn't — is deterministic code; the LLM layers semantics on top. An LLM left to do the lookup will
  miss silently and no prompt guard fixes it reliably. Feed the agent the resolved facts; don't ask it to resolve.

## "The registry IS the whitelist" → a whole-message identity sweep, with header/body trust asymmetry
> *"Are you matching just against persona emails? I feel like this would be better if it matched against names
> (fuzzily if possible) and contact methods... And might it make sense to flip this - extract any names / phone
> numbers / emails from the full message, and match those agains the vault contacts?"*

Collapsed a From-only sender-veto + a brittle provider-phrase regex into ONE deterministic **whole-message
identifier sweep**: extract every address from From+subject+text+stripped-HTML, intersect with the registry, any
hit ⇒ relevant. (Forced by a real miss: a Google-Drive share is *sent by* a no-reply address and names the actual
person only in the HTML body — so From-matching alone can't see it.) Crucial refinement: **header-identity and
body-identity are not equally trusted** — a From match is a strong signal; an address found in the *body* is soft
(a spammer can embed a known contact's address), so it may only *downgrade aggression*, never hard-trust.
- **Lesson:** identity resolution should sweep the *whole* artifact (the entity is often not in the obvious field),
  but weight by where it was found — which is exactly the vault doctrine's "structural/header facts trusted,
  body-asserted facts proposed-not-canonical." Fuzzy *name* matching stays the LLM's job + confidence-banded
  (a false merge is worse than a miss); deterministic identifiers (email/phone) are the join keys.

## Cheap deterministic pre-filter + LLM-as-net: which layer is allowed to be wrong
> *"it's better for is_cruft to not match something spammy - the LLM layer will do a better analysis... LLM pass
> should not just evalute for data to be added to vault, it shoudl also catch things is_cruft missed (like a
> spammer embedding a persona's email) - so better to err that way than potentially drop something important."*

Settled the layering: the cheap deterministic stage (`is_cruft`) is a **precision pre-filter** to cut LLM cost,
NOT the accuracy gate — it should only drop the *obviously* worthless and otherwise err toward passing through.
The LLM is the safety net that catches what the deterministic layer waved through (incl. adversarial cases the
registry-whitelist would otherwise wrongly keep).
- **Lesson:** in a deterministic-cheap → LLM-expensive pipeline, decide explicitly *which layer is permitted to be
  wrong and in which direction*. The cheap layer errs toward inclusion (a false drop is unrecoverable); the
  expensive layer is the net. "Keep" at the cheap layer must mean *don't-discard*, never *trust* — so a poisoned
  match lands in view but not in the canonical store.

## Right-size the index: inline-context vs retrieval
99 persona records is an **inline-context** problem, not a retrieval one — the whole compact digest fits in an
agent prompt. Explicitly declined to stand up a vector index; flagged the `llm-native-vaults` retrieval machinery
as for a *far bigger* corpus, not adopted here.
- **Lesson:** match the index mechanism to corpus size. Vector/graph retrieval is premature when the regenerable
  projection fits in context. Name the threshold; don't reflexively reach for the heavy retrieval stack.

## Affected-only index rebuild — apply the write-time-index thesis early
> *"Build index - can that check if there have been any commits to teh vault that affect the personas folder and
> otherwise not trigger the reindex"*
> *"I believe in tidiness and elegance of solutions, and applying those principles early. Cost of reindex is low
> now, but a future company vault might have many more personas"*

Consulted `vault-design/research/llm-native-vaults/10-research/write-time-index.md` **before building** (the
consult-before-rebuild gate working) — it already settles this: "full rebuilds are pure waste," adRAP-style
*affected-only* update is the template, explicitly extrapolated to the company-archive case. Built it: the index
always FULLY reassembles (pure projection, no cache-invalidation drift) but **re-derives only personas whose
content-hash changed**, reusing the rest; a `_builder` logic-fingerprint auto-invalidates the memo when the
derivation code changes. Trivial saving for today's regex parse — the value is the **seam**.
- **Lesson:** the affected-only principle is worth applying at the parse seam *before* it pays for itself, because
  the seam is where it later becomes load-bearing: when per-item derivation becomes an **LLM call** (Layer-2
  interests/relations per persona), "re-derive only what changed" is the difference between affected-only and an
  LLM re-run over the whole corpus per edit (the "$33K GraphRAG rebuild" failure). Keep it **full-reassembly +
  memoized derivation** (drift-free) rather than in-place index mutation (reintroduces cache-invalidation). Build
  the seam at the cheap stage so the expensive stage inherits it for free.

## Working mode — "apply elegance/principles early," answered with rigor not compliance
When the user pushed back on a dismissive "this optimization is basically free, skip it," the right move was not to
either capitulate-and-gold-plate or dig in — it was to (a) check whether the project's own research backed the
instinct (it did, strongly), (b) supply the missing rigor on *where* the principle actually bites (flat regex
index vs LLM-derived index — different thresholds), and (c) build the proportionate elegant form, naming the
honest tradeoff (seam now, payoff at L2).
- **Lesson:** "apply principles early" is a real design value, not over-engineering — but it earns its keep only
  when tied to a concrete future seam + grounded in prior research, with the ahead-of-need cost stated plainly.
  The synthesist wants the domain-depth on *when/why* the principle bites, not blind agreement or blind refusal.
