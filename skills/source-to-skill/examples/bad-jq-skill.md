# BAD: jq CLI → common failure modes

Same source as good-jq-skill.md, showing what goes wrong.

---

## Failure 1 — Vague triggers (most common failure)

```markdown
description: "Helps with JSON processing and data manipulation tasks. Use when working with JSON data or command line tools."
```

Why it fails: "JSON processing", "data manipulation", "command line tools" — Claude will trigger this for ANY JSON task, including Python scripts, curl calls, and database queries. The source's own terms (`jq`, `.[]`, `select`, `map`) appear nowhere. Claude can't distinguish this from a generic JSON skill.

Fix: derive triggers from the source's own command names and syntax symbols.

---

## Failure 2 — Wrong freedom level (high for a low-freedom tool)

```markdown
## Working with arrays

When you need to process arrays in jq, you can use various array-processing techniques. Consider the structure of your data and choose the appropriate filter based on what you're trying to accomplish. The select() function is useful for filtering, while map() helps with transformations.
```

Why it fails: jq has exact, non-negotiable syntax. "Various techniques" and "choose appropriate filter" gives Claude no actionable commands. A user asking "how do I filter this array" gets a paragraph, not `jq '.[] | select(.active == true)'`. Low-freedom tools need literal commands.

Fix: every workflow step is a runnable command with the exact syntax.

---

## Failure 3 — Padded workflows (invented, not source-derived)

```markdown
## Workflows

### General JSON workflow
1. Identify your JSON structure
2. Plan your transformation
3. Write your jq filter
4. Test and iterate

### Advanced JSON workflow
1. Consider performance implications
2. Use streaming for large files
3. Combine with other tools
```

Why it fails: "Identify your JSON structure" and "plan your transformation" are not jq — they're generic advice. The source defines three real workflows (extract, filter, transform). These invented steps don't appear in the source and add noise without value.

Fix: only write workflows that exist in the source. If the source has 3, write 3.

---

## Failure 4 — Missing error patterns

A skill with no errors section forces Claude to hallucinate error behavior. jq returns `null` for missing keys (not an error), exits non-zero for parse failures (not a warning), and produces cryptic type messages (`Cannot index string with string "x"`). These are high-frequency support questions that belong in the skill.

Fix: grep the source and GitHub issues for recurring error strings and add them verbatim.

---

## Failure 5 — Time-sensitive content

```markdown
## Installation

Install jq 1.7.1 (latest as of March 2025): `brew install jq`
```

Why it fails: version numbers and "latest" dates rot immediately. The skill becomes wrong without any warning.

Fix: never include version numbers or dates. Just `brew install jq`.
