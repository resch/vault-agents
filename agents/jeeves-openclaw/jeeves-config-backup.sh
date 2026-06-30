#!/usr/bin/env bash
# Back up Jeeves's OpenClaw config (workspace files + the openclaw.json agent stanza) into THIS vault.
# Runs on the hub from the ~/vault-agents clone. Idempotent: commits+pushes only on change.
# Jeeves runs this after self-editing its config; a daily cron is the safety net.
set -euo pipefail

VAULT="$HOME/vault-agents"
WS="$HOME/.openclaw/workspace"
DEST="$VAULT/agents/jeeves-openclaw/workspace"
mkdir -p "$DEST"

# Multi-writer repo (also pushed from Raphael's Mac) -> rebase before pushing. autostash for safety.
git -C "$VAULT" pull --rebase --autostash -q || true

# Hand-authored config files only. Skip runtime/personal: HEARTBEAT.md, memory/, BOOTSTRAP.md, .openclaw/.
for f in SOUL.md AGENTS.md USER.md IDENTITY.md TOOLS.md; do
  [ -f "$WS/$f" ] && cp "$WS/$f" "$DEST/$f"
done

# The jeeves agent stanza (model + tools.allow) from the shared openclaw.json — for full rebuild.
python3 - > "$DEST/openclaw-agent-stanza.json" <<'PY'
import json, os
c = json.load(open(os.path.expanduser("~/.openclaw/openclaw.json")))
j = next((a for a in c.get("agents", {}).get("list", []) if a.get("id") == "jeeves"), {})
print(json.dumps(j, indent=2))
PY

git -C "$VAULT" add agents/jeeves-openclaw/workspace
if git -C "$VAULT" diff --cached --quiet; then
  echo "config backup: no changes"
else
  git -C "$VAULT" commit -q -m "jeeves-openclaw: config backup $(date -u +%FT%TZ)

Co-Authored-By: Jeeves (OpenClaw) <jeeves@firk.co>"
  git -C "$VAULT" push -q
  echo "config backup: committed + pushed"
fi
