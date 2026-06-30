#!/usr/bin/env bash
# Restore Jeeves's config from THIS vault onto the box (after a rebuild, or to undo a bad self-edit).
# Backs up the current live files first. Run on the hub from the ~/vault-agents clone.
set -euo pipefail

VAULT="$HOME/vault-agents"
WS="$HOME/.openclaw/workspace"
SRC="$VAULT/agents/jeeves-openclaw/workspace"

git -C "$VAULT" pull --ff-only -q || true
mkdir -p "$WS"
ts=$(date -u +%Y%m%dT%H%M%SZ)

for f in SOUL.md AGENTS.md USER.md IDENTITY.md TOOLS.md; do
  if [ -f "$SRC/$f" ]; then
    [ -f "$WS/$f" ] && cp "$WS/$f" "$WS/$f.bak-restore-$ts"
    cp "$SRC/$f" "$WS/$f"
    echo "restored $f"
  fi
done

echo
echo "Done. Restart the gateway to load: systemctl --user restart openclaw-gateway.service"
echo "Note: openclaw-agent-stanza.json is reference only — re-apply to openclaw.json by hand if rebuilding."
