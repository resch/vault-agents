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

## Self-backup (built 2026-06-30)
Jeeves owns its own config lifecycle — it can self-edit and self-back-up, so it can be the primary interface
without this coding agent in the loop. **Backup-copy model** (workspace = live source; this vault = durable backup):
- **`workspace/`** — the backed-up config: `SOUL.md`, `AGENTS.md`, `USER.md`, `IDENTITY.md`, `TOOLS.md`, plus
  `openclaw-agent-stanza.json` (the `jeeves` model + `tools.allow` from `openclaw.json`, for a full rebuild).
- **`jeeves-config-backup.sh`** — copies the live workspace config here, commits + pushes (only on change).
  Jeeves runs it via `exec` after self-editing (procedure in its `AGENTS.md`); a **daily cron (13:30 UTC)** on
  the hub is the safety net. Verified 2026-06-30: Jeeves invoked it itself.
- **`jeeves-config-restore.sh`** — copies the config back onto the box (backs up the live files first); restart
  the gateway after. The recovery path for a box rebuild or a bad self-edit.
- **Audit/undo:** every change is a git commit here. To revert a self-edit, `git revert`/checkout the file and
  run restore. Self-edits are guard-railed in `AGENTS.md` (don't remove core safety rules; flag big changes).

## Open / follow-on
- The hand-authored workspace is backed up; `openclaw.json`'s shared structure (other agents, MCP servers) is
  not — only the `jeeves` stanza. Full box rebuild still leans on `provisioning-runbook`.
- If prompt-level vault-consult still proves unreliable, enforce it at the heartbeat/hook layer (the
  vault-reflex pattern, ported to OpenClaw).
