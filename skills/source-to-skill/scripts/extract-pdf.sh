#!/usr/bin/env bash
# Context-sensitive PDF text extractor.
# Usage: extract-pdf.sh <file.pdf> [technical|prose|auto]
# Outputs extracted markdown/text to stdout.

set -euo pipefail

FILE="${1:-}"
MODE="${2:-auto}"

if [[ -z "$FILE" ]]; then
  echo "Usage: extract-pdf.sh <file.pdf> [technical|prose|auto]" >&2
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "File not found: $FILE" >&2
  exit 1
fi

# --- Auto-detect mode by scanning first 2 pages for code/table signals ---
detect_mode() {
  local sample=""
  if command -v pdftotext &>/dev/null; then
    sample=$(pdftotext -f 1 -l 2 "$FILE" - 2>/dev/null || true)
  elif python3 -c "import pypdf" &>/dev/null 2>&1; then
    sample=$(python3 -c "
import pypdf, sys
r = pypdf.PdfReader(sys.argv[1])
pages = r.pages[:2]
print('\n'.join(p.extract_text() or '' for p in pages))
" "$FILE" 2>/dev/null || true)
  fi

  # Score technical signals
  local score=0
  echo "$sample" | grep -qE '^\s*(```|>>>|\$\s+\w|#include|import |def |function |class )' && score=$((score + 3))
  echo "$sample" | grep -qE '\|\s*[-:]+\s*\|' && score=$((score + 2))  # markdown table
  echo "$sample" | grep -cE '[A-Z_]{3,}\s*=|--[a-z-]+' | grep -q '^[2-9]' && score=$((score + 1))

  if [[ $score -ge 2 ]]; then
    echo "technical"
  else
    echo "prose"
  fi
}

if [[ "$MODE" == "auto" ]]; then
  MODE=$(detect_mode)
  echo "# [extract-pdf] detected mode: $MODE" >&2
fi

# --- Extract ---
if [[ "$MODE" == "technical" ]]; then
  if python3 -c "import docling" &>/dev/null 2>&1; then
    echo "# [extract-pdf] using Docling (technical mode)" >&2
    python3 -m docling "$FILE" --to markdown
    exit 0
  else
    echo "# [extract-pdf] Docling not installed; falling back. Install with: pip install docling" >&2
  fi
fi

if command -v pdftotext &>/dev/null; then
  echo "# [extract-pdf] using pdftotext -layout" >&2
  pdftotext -layout "$FILE" -
  exit 0
fi

if python3 -c "import pypdf" &>/dev/null 2>&1; then
  echo "# [extract-pdf] using pypdf (no layout)" >&2
  python3 -c "
import pypdf, sys
r = pypdf.PdfReader(sys.argv[1])
for i, page in enumerate(r.pages):
    text = page.extract_text() or ''
    print(f'<!-- page {i+1} -->')
    print(text)
" "$FILE"
  exit 0
fi

echo "No PDF extraction tool found. Install one of: docling, poppler (pdftotext), pypdf" >&2
echo "  pip install pypdf        # fastest to install"
echo "  brew install poppler     # layout-preserving"
echo "  pip install docling      # best for technical docs"
exit 1
