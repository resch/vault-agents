# 2026-06-30 — Jeeves setup overhaul

Triggered by Jeeves underperforming from the Helm app (a France-happening query): it misread "Austin" (his
city) as a person, complained its memory needed re-indexing, and laid the butler affect on every line. Grounded
in web research on optimal OpenClaw-agent setup (OpenClaw docs + Anthropic/OpenAI agent-design guidance).

## Root causes found (from the live config, not guessed)
- **`USER.md` was the empty template** → Jeeves had zero recorded facts about Raphael → "Austin" = person.
- **`AGENTS.md` was ~80% OpenClaw boilerplate** (group-chat/emoji/voice-storytelling) burying the vault rules,
  with no event-keyed consult trigger → unreliable vault use.
- **Memory index was broken**: embedding provider defaulted to **OpenAI with no API key** → index failed.
- **SOUL.md** preached brevity but the signature-phrase guidance was too soft → "sir" on every line.

## Changes
1. **Memory:** set `agents.defaults.memorySearch = {provider:"none", query:{hybrid:{enabled:false}}}` →
   FTS/BM25-only (no embedding key, no cost — honours Bedrock-cost-routing; the real knowledge is the vault,
   read via MCP, not these embeddings). Reindex now succeeds.
2. **`USER.md`:** filled — identity, Central TZ, **Austin = his city not a person**, comms style mirrored from
   his CLAUDE.md, and a pointer to `self/`. Emerging projects (bzmart) deliberately left to the vault, not config.
3. **`AGENTS.md`:** rewrote (~230→79 lines). Top rule = event-keyed vault-consult ("references a
   person/org/project/happening/place/preference → search vault, `self/` first, BEFORE answering"), repeated at
   the end (primacy+recency). Added fleet position (control-plane vs `mail-gate`/pipeline). Flipped vault access
   from read-only to **write via the archivist gate**. Stripped Discord/emoji/voice boilerplate.
4. **`SOUL.md`:** "light butler" — "sir" ≤ once/conversation, butler register for greetings/framing only, plus
   an explicit **"voice yields to the task"** rule (lead with substance on factual/structured answers).
5. **Vault:** added his address (`6401 Emerald St, Austin TX 78745`) to `self/raphael.md`. (He first typed
   "6410" then confirmed 6401 — matches the Redfin home-report the pipeline had attributed to him.)

## Principles applied (reusable)
- **SOUL = voice, AGENTS = procedures, USER = identity** — keep un-blurred; voice yields to task.
- **Tool/store use must be an event-keyed "when-X-then-Y" rule at the top of the prompt**, not buried prose —
  the documented fix for "has the store, doesn't use it" (same failure as the vault-reflex hooks here).
- **Smaller, sharper prompt triggers tools more reliably** than a big one — delete boilerplate.
