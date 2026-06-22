---
created: 2026-06-22T09:06:49Z
updated: 2026-06-22T09:06:49Z
---

# OpenClaw — spoke setup notes

Cross-instance operational knowledge for running agents on the **OpenClaw** spoke — useful to anyone wiring OpenClaw as a memory-infra spoke. Instance-specific config (which box, which models, per-agent settings) lives in the owner's vault; this captures the **transferable** gotchas and design takeaways.

## Local-model tool calling needs ollama's NATIVE API, not `/v1`
OpenClaw's ollama provider `baseUrl` must be the native API (`http://host:11434`), **not** the OpenAI-compatible `/v1` endpoint. With `/v1`, tool calling silently breaks — the model emits raw tool-call JSON as plain text and makes no real calls (it narrates intent, or returns empty). Drop the `/v1`. Verified 2026-06-22: qwen2.5 7b/14b tool-call correctly over native `/api/chat`; the `/v1` path was the blocker, **not** model capability.

## Bedrock worker agents need a non-minimal `tools.allow` for MCP tools to attach
On the **Bedrock (converse-stream) provider path**, an isolated worker agent whose `tools.allow` lists **only MCP tool names** (e.g. just `fastmail__search_email` / `read_email`) gets **zero tools passed to the model** — it returns an empty/no-op answer with no tool calls. The **ollama path does not** have this (the same minimal allowlist works there). Fix: include native/plugin tools in the allowlist (the default agent's broader set works), or reference the MCP bundle (`bundle-mcp` / `group:plugins`) so the MCP plugin tools resolve. Verified 2026-06-22: Bedrock Sonnet returned `[]` with a 3-MCP-tool allowlist; broadening it attached the fastmail tools and produced correct output.

## Capability vs orchestration (design takeaway)
A weak local model (small qwen) is a reliable **single-shot classifier** but **not** a reliable **agent-loop orchestrator** that also coerces output to a fixed schema. The fix for the classifier — grammar-constrained output via ollama's `format` (JSON schema) — isn't reachable through the agent loop, only through a direct/single-shot call. So spoke **orchestration** wants a capable model; own-account **Bedrock** keeps it private vs a public API (no training on your data, stays in your tenant). Most users won't have a capable local model — **treat cloud orchestration as the baseline; local is an optional optimization for the privacy-sensitive classification step.**
