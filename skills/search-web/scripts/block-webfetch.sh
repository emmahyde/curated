#!/usr/bin/env bash
# PreToolUse hook for the search-web skill.
# Strictly denies every WebFetch call. The skill builds its corpus via
# WebSearch (Phase 1) + ctx_fetch_and_index / batch_fetch.py (Phase 2);
# raw WebFetch is never part of the pipeline and dumps unindexed page
# content into the context window.
set -euo pipefail

cat >/dev/null   # drain the PreToolUse event JSON on stdin (unused)

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "WebFetch is blocked inside the search-web skill. Discover URLs with WebSearch (Phase 1), then fetch the corpus with ctx_fetch_and_index or scripts/batch_fetch.py (Phase 2). See SKILL.md."
  }
}
JSON
