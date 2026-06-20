---
created: 2026-06-05T13:58:15.915Z
updated: 2026-06-06T13:15:09.262Z
moved: 2026-06-06T13:14:00.000Z
moved_from: vault-core/sun/data-points/2026-06-05-openai-dreaming-v3.md
moved_reason: vault-core is shared with other users; personal stores belong in vault-memory-infra
---

# OpenAI Dreaming V3 - Memory Architecture

**Date logged:** 2026-06-05
**Source:** TechnologyAdvice newsletter / OpenAI announcement
**Logged by:** Raphael (flagged as relevant to ongoing architecture conversation)

## Summary

OpenAI unveiled "Dreaming V3," an overhauled memory architecture for ChatGPT:

- Automatically weaves details from past chats into a cohesive user profile
- Trims staleness - silently ages out details when no longer relevant
- Doubled storage for Plus/Pro subscribers (US first), Free/Go rollout within weeks
- 5× efficiency boost making it cheap enough to run at scale
- New memory summary page lets users audit/edit what ChatGPT knows (hobbies, work, travel)
- Granular toggles + Temporary Chats as privacy escape hatch
- Truly purging a memory requires manual scrub across saved memories, chat history, files, connected apps
- Gmail + file memory sources unavailable in EEA/UK/Switzerland
- ChatGPT at ~1B MAU at announcement

## Strategic relevance

This validates several architectural bets we've been making:

1. **Recency / staleness handling is now table-stakes.** OpenAI is solving the same "what's still relevant" problem that drove our recency tool addition. Confirms it's not a niche concern - it's the dominant operational question at scale.
2. **Self-curating profiles over raw chat dumps.** The industry is converging on synthesized, editable user models rather than appending forever. Our directional bet on structured summaries is aligned.
3. **Audit surface as a product requirement.** A user-visible memory page is becoming expected. Worth noting for our own surface design.
4. **Purge fragmentation is the unsolved problem.** Even OpenAI hasn't solved clean deletion across files/apps/integrations. This is a competitive opening if we can do it cleanly.
5. **Regional carve-outs (EEA/UK/CH) on integrated memory sources** - the regulatory cost of pulling from Gmail/files is high enough that even OpenAI ships fragmented. Plan for the same friction.

## Risk pattern noted

"AI that never forgets" is being framed as a trust problem in mainstream press. As we scale memory features, the *creepiness asymmetry* applies: the downside of one bad recall (surfacing something a user wished was forgotten) substantially exceeds the upside of one good one. Worth keeping in view.

## Open question

## Counter-framing (Raphael, via sid)

The "digital assistant" framing in the article is thinking small - and likely deliberately so. OpenAI benefits from lock-in: an export probably exists, but most users will never go through the hassle. The framing hides three properties that matter for our work:

- **Portability** - owned from the outset, not exported under duress
- **Scale unit** - organization, not individual
- **Composability** - memory built from component stores for a purpose, not one monolith per vendor

### Correction to the takeaways above

The note as originally written reads as "OpenAI is converging with us." That's wrong. The actual signal is:

**OpenAI is solving a smaller problem and calling it the whole problem.**

Recency, self-curation, and audit surfaces are real - but they're features of the small problem (one vendor, one user, one monolith). The large problem - portable, org-scale, composable memory built from component stores - is the one we're working on and the one their framing renders invisible.

When the dominant vendor names the small problem as the whole problem, that's the strategic event worth logging. Not the feature list.


At 1B MAU with persistent memory, what does opposition look like? Probably less "another assistant" and more "the user's own past selves" - old preferences locking in stale identity. Worth watching whether Dreaming V3's aging mechanism actually works in practice or just papers over the problem.
