#!/usr/bin/env bash
# Classify a source path or URL into a source type for source-to-skill.
# Usage: classify-source.sh <path-or-url>
# Outputs one of: script | repo | api-docs | pdf | long-doc | short-doc | unknown

set -euo pipefail

INPUT="${1:-}"

if [[ -z "$INPUT" ]]; then
  echo "Usage: classify-source.sh <path-or-url>" >&2
  exit 1
fi

classify() {
  local src="$1"

  # --- URL patterns ---
  if [[ "$src" =~ ^https?:// ]]; then
    # GitHub / GitLab repo root
    if [[ "$src" =~ ^https://(github|gitlab)\.com/[^/]+/[^/]+/?$ ]]; then
      echo "repo"; return
    fi
    # arXiv
    if [[ "$src" =~ arxiv\.org/(abs|pdf)/ ]]; then
      echo "pdf"; return
    fi
    # PDF URL
    if [[ "$src" =~ \.pdf(\?.*)?$ ]]; then
      echo "pdf"; return
    fi
    # OpenAPI / Swagger
    if [[ "$src" =~ (swagger|openapi|api-docs|redoc|rapidoc) ]]; then
      echo "api-docs"; return
    fi
    # API path signals
    if [[ "$src" =~ /api/|/v[0-9]+/|/reference/ ]]; then
      echo "api-docs"; return
    fi
    # Default URL → short-doc (fetch and check size separately)
    echo "short-doc"; return
  fi

  # --- Local file patterns ---
  if [[ -f "$src" ]]; then
    local ext="${src##*.}"
    case "$ext" in
      sh|bash|zsh|fish)         echo "script"; return ;;
      py|rb|js|ts|go|rs|java)   echo "script"; return ;;
      pdf)                       echo "pdf"; return ;;
      epub|docx|mobi|azw*)      echo "long-doc"; return ;;
      md|txt|rst|adoc|html|htm) echo "short-doc"; return ;;
    esac

    # Check shebang for scripts without clear extension
    local first_line
    first_line=$(head -1 "$src" 2>/dev/null || true)
    if [[ "$first_line" =~ ^#! ]]; then
      echo "script"; return
    fi

    # Check file size as proxy for long-doc
    local size_kb
    size_kb=$(du -k "$src" 2>/dev/null | cut -f1 || echo 0)
    if [[ "$size_kb" -gt 500 ]]; then
      echo "long-doc"; return
    fi

    echo "short-doc"; return
  fi

  # --- Directory (treat as repo) ---
  if [[ -d "$src" ]]; then
    if [[ -f "$src/README.md" ]] || [[ -f "$src/README.rst" ]] || [[ -f "$src/.git/config" ]]; then
      echo "repo"; return
    fi
    echo "repo"; return
  fi

  echo "unknown"
}

classify "$INPUT"
