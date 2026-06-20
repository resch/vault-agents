---
created: 2026-06-05T14:16:00.581Z
updated: 2026-06-06T13:15:31.078Z
moved: 2026-06-06T13:14:00.000Z
moved_from: vault-core/sun/vault-design/prefill-cost-principle.md
moved_reason: vault-core is shared with other users; personal stores belong in vault-memory-infra
---

# Vault Prefill Cost - Design Principle (Seed)

**Status:** Seed idea, captured early to inform future design. Start small, refine as we go.
**Raised by:** Raphael, 2026-06-05
**Contributors:** Raphael, sid, sun

## The kernel

A vault is not free context. It is **prepaid context** - paid every time an agent boots into work. Building and running a vault incurs cost, time, and complexity before any useful action is taken.

Taken to extremes (assume infinite context): loading everything breaks the system, or at minimum renders it expensive and noisy. There is a real trade-off between *knowing everything upfront* and *knowing just enough to pull more when needed*.

## Why capture this now

If we don't bake measurement and intent into vault design early, we will drift toward over-loading by default. The bias is structural (see asymmetry below), not a matter of discipline.

## Working framing

- **Prefill = prepaid context = commitment cost.** Bigger prefill = bigger bet on a specific theory of the upcoming work, made before the work begins.
- **Eager vs. lazy loading** - borrow the vocabulary from data systems. Same trade-off, applied to agent cognition.
- **Boot cost per useful action** is the metric direction, not vault size alone. Denominator matters.

## The asymmetry to design against

- **Lazy loading fails visibly** - agent stalls, asks for more, takes longer. Cost is legible.
- **Eager loading fails invisibly** - agent has dense low-signal context, makes subtly worse decisions, no per-session comparison available.

Unless we deliberately counter this, the system will accumulate "just in case" content because the cost of missing something is legible and the cost of carrying too much is not.

## Candidate measurements (to refine)

- Tokens loaded at boot
- Time-to-first-useful-action
- Money per session
- Signal-to-noise / cognitive load on the agent (hardest to measure, most important)
- Quality of first N actions vs. a lean baseline (attempt at surfacing the invisible-degradation cost)

## Diagnostic question to keep

> If context were free, what would we still choose not to load?

Things you wouldn't load even at zero cost are noise at any price. Cheapest available tool for fighting eager-loading bias. Worth baking into vault review ritual.

## Open questions

- Does this live as a vault-design principle, an operational metric, or both? (Current answer: both, different weights.)
- How do we surface invisible-degradation cost without running expensive A/B comparisons every session?
- At what scale does this stop being a per-vault concern and become a portfolio concern (composing multiple vaults for a purpose - ties to Raphael's composability framing on the OpenAI note)?

## Related

- `memory/sun/data-points/2026-06-05-openai-dreaming-v3.md` - composability/portability framing; this prefill-cost question is what composability has to *solve for* in practice.
