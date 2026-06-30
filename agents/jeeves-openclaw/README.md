# jeeves-openclaw

**Jeeves** as run on the **OpenClaw** platform on the hub (EC2 `magic-user.firk.co`) — Raphael's control-plane
general assistant, reached via `openclaw chat` (CLI) and the **Helm** phone app. The durable, cross-platform
record of this flavour; the live config is box-local on the hub at `~/.openclaw/workspace/` + the `jeeves`
stanza in `~/.openclaw/openclaw.json`. Projects from [[ways-of-working]].

## What it is
- **Role:** control-plane general assistant (the agent Raphael talks to). NOT a pipeline worker — email triage
  is the separate isolated `mail-gate` agent on cron; Jeeves coordinates through the vault, not agent-to-agent.
- **Model:** Bedrock Sonnet 4.5 (`us.anthropic.claude-sonnet-4-5`), via the hub's EC2 instance role (IMDS).
- **Tools:** `vault__*` (read+write), `agentvault__*`, `fastmail__{list_folders,search_email,read_email}`
  (read-only, granted 2026-06-30), workspace read/write/edit, memory, web, `exec`, subagents.
- **Workspace files:** `SOUL.md` (voice), `AGENTS.md` (procedures), `USER.md` (who Raphael is) — kept
  un-blurred per the SOUL=voice / AGENTS=procedures / USER=identity split.

## Key decisions
- [2026-06-30 setup overhaul](decisions/2026-06-30-setup-overhaul.md) — fixed the broken memory index, filled
  USER.md, rewrote AGENTS.md (vault-consult as a hard top rule + fleet position + archivist write-gate, ~230→79
  lines), dialled the persona to "light butler", granted read-only mail, gave full vault-write via the archivist.

## Open / follow-on
- Workspace files are box-local (only `mail-gate`'s `AGENTS.md` is git-tracked, in `resch/comms-pipeline`).
  Tracking Jeeves's workspace similarly is a noted durability follow-on.
- If prompt-level vault-consult still proves unreliable, enforce it at the heartbeat/hook layer (the
  vault-reflex pattern, ported to OpenClaw).
