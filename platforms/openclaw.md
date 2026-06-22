---
created: 2026-06-22T09:06:49Z
updated: 2026-06-22T09:06:49Z
---

# OpenClaw — spoke setup notes

Cross-instance operational knowledge for running agents on the **OpenClaw** spoke — useful to anyone wiring OpenClaw as a memory-infra spoke. Instance-specific config (which box, which models, per-agent settings) lives in the owner's vault; this captures the **transferable** gotchas and design takeaways.

## Local-model tool calling needs ollama's NATIVE API, not `/v1`
OpenClaw's ollama provider `baseUrl` must be the native API (`http://host:11434`), **not** the OpenAI-compatible `/v1` endpoint. With `/v1`, tool calling silently breaks — the model emits raw tool-call JSON as plain text and makes no real calls (it narrates intent, or returns empty). Drop the `/v1`. Verified 2026-06-22: qwen2.5 7b/14b tool-call correctly over native `/api/chat`; the `/v1` path was the blocker, **not** model capability.

## Bedrock worker agents need a non-minimal `tools.allow` for MCP tools to attach
On the **Bedrock (converse-stream) provider path**, an isolated worker agent whose `tools.allow` lists **only MCP tool names** (e.g. just `fastmail__search_email` / `read_email`) gets **zero tools passed to the model** — it returns an empty/no-op answer with no tool calls. The **ollama path does not** have this (the same minimal allowlist works there). Fix: the allowlist needs **tools from more than one MCP server** (or a wildcard like `vault__*`) — native tools are **not** required. Verified 2026-06-22: a 3-tool **fastmail-only** allowlist → `[]`/no tools on Bedrock; `fastmail`-read **+ `vault__*`** (two MCP servers, no native tools) → tools attach and Haiku/Sonnet classify correctly. So a least-privilege gate worker (read-fastmail + vault-write, no `exec`/`write`/`subagents`) works fine — just don't scope it to a single MCP server's tools alone.

## Capability vs orchestration (design takeaway)
A weak local model (small qwen) is a reliable **single-shot classifier** but **not** a reliable **agent-loop orchestrator** that also coerces output to a fixed schema. The fix for the classifier — grammar-constrained output via ollama's `format` (JSON schema) — isn't reachable through the agent loop, only through a direct/single-shot call. So spoke **orchestration** wants a capable model; own-account **Bedrock** keeps it private vs a public API (no training on your data, stays in your tenant). Most users won't have a capable local model — **treat cloud orchestration as the baseline; local is an optional optimization for the privacy-sensitive classification step.**

## Which models can drive the worker-agent orchestration loop (measured 2026-06-22)
Task: worker agent fetches inbox via the fastmail MCP → classifies → emits strict JSON. Bedrock models:
- **Works:** Claude **Sonnet 4.5** and **Haiku 4.5** — clean schema, correct classifications. **Haiku 4.5 is the cheap-reliable floor** (~3× cheaper than Sonnet).
- **Too weak:** Amazon **Nova Micro** — apples-to-apples (same prompt that Sonnet/Haiku passed) it confabulates (e.g. claims to "write a file" it never wrote) and returns `[]`. Nova **Lite/Pro** failed the same way (their runs had a prompt confound, but the family pattern + only-marginal savings over Haiku make them not worth chasing for orchestration).
- **Local qwen 7b/14b:** drives the tools but can't hold the output schema in the loop.

**Prompt scaffolding is load-bearing.** An explicit tool *procedure* in the agent prompt — "call `list_folders` once, then `search_email`" — is what made the capable models succeed; a vague "fetch recent emails" produced empty/no-op output **even on Haiku**. Spell out the tool sequence for worker agents.

**Two-tier takeaway:** orchestration floor = Anthropic **Haiku-class**; the cheap single-shot **classification** step (one email → one label, no tool loop) can still run on Nova Micro or local qwen.
