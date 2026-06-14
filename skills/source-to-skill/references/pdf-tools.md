# PDF Extraction Tools Reference

Loaded when Step 1 encounters a PDF source. Covers tool selection, installation, and fallback chain.

## Tool selection by content type

| Tool | Best for | Preserves | Install |
|------|---------|-----------|---------|
| **Docling** | technical PDFs (code, tables, formulas, diagrams) | markdown structure, tables as GFM, code blocks | `pip install docling` |
| **pdftotext** | prose-heavy docs, reports, articles | paragraph flow, basic layout | `brew install poppler` / `apt install poppler-utils` |
| **pypdf** | fallback; any PDF | raw text, no layout | `pip install pypdf` |
| **pdfplumber** | PDFs with complex tables | table cell boundaries | `pip install pdfplumber` |

## Detection heuristic (first 2 pages)

Scan the first 2 pages for signals:
- Code fences, monospace blocks, `>>>`, `$` prompts → **Docling**
- Tables with >3 columns or merged cells → **Docling** or **pdfplumber**
- Dense prose, few tables, no code → **pdftotext -layout**
- Scanned/image PDF (no selectable text) → OCR required; warn user, suggest `tesseract` + `pdf2image`

## Fallback chain

```
Docling available AND technical? → use Docling
pdftotext available AND prose? → use pdftotext -layout
pypdf available? → use pypdf (no layout, acceptable for short docs)
none available → ask user to paste text, or offer: pip install pypdf
```

## Commands

```bash
# Docling (outputs markdown to stdout)
python3 -m docling <file.pdf> --to markdown

# pdftotext (layout-preserving)
pdftotext -layout <file.pdf> -

# pypdf (raw, no layout)
python3 -c "import pypdf; r=pypdf.PdfReader('$f'); print('\n'.join(p.extract_text() for p in r.pages))"

# pdfplumber (tables as CSV)
python3 -c "import pdfplumber; f=pdfplumber.open('$f'); [print(t.extract()) for p in f.pages for t in p.extract_tables()]"
```

## Post-extraction: structure map

After extraction, grep for section headings before reading the full output. For docs over 20k tokens, read only the sections relevant to the domain:

```bash
grep -n "^#\|^##\|^[A-Z][A-Z ]\{4,\}$" extracted.txt | head -40
```

Use `Read(offset=<line>, limit=<lines>)` to pull only the relevant section rather than loading the full extracted text.

## URL PDFs

For PDF URLs, first try `WebFetch` — Claude Code can often extract text directly from PDF URLs. If WebFetch returns garbled binary or truncated content, download with `curl -L -o /tmp/source.pdf <url>` and run the local extraction chain above.
