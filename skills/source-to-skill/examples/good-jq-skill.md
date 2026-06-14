# GOOD: jq CLI → source-to-skill output

Source: https://jqlang.org/manual (short doc, ~18 pages equivalent)
Classified as: script/tool doc | Shape: workflow skill | Freedom: LOW

What makes this good:
- triggers pulled verbatim from source language (`jq`, `.[]`, `select`, `map`, `|`)
- low-freedom: literal command syntax, not descriptions of flags
- no invented workflows — only the three patterns real users repeat
- error patterns come from the actual tool output, not invented

---

```markdown
---
name: jq
description: "Filter, transform, and query JSON from the command line using jq. Use when the user mentions jq, asks to parse JSON output, filter with .[], select(), or map(), pipe JSON through transformations, or extract fields from JSON files or command output."
allowed-tools:
  - Bash
---

# jq — JSON processor

## Quick start

```bash
# filter a field
jq '.name' file.json

# from stdin
curl -s api.example.com/users | jq '.[0].email'

# raw string output (no quotes)
jq -r '.name' file.json
```

## Workflows

### Extract fields
```bash
jq '.key'              # single field
jq '.a.b.c'            # nested
jq '{name, email}'     # multiple fields → new object
jq -r '.name'          # raw string (strip quotes)
```

### Filter arrays
```bash
jq '.[]'                          # all items
jq '.[2]'                         # by index
jq '.[] | select(.active == true)' # where clause
jq 'map(select(.score > 5))'      # filter array
jq '[.[] | select(.type == "A")]' # collect filtered
```

### Transform
```bash
jq '.[] | {id: .id, label: .name}'   # reshape each item
jq '[.[] | .score] | add / length'   # average
jq 'group_by(.type)'                 # group
jq 'sort_by(.created_at) | reverse'  # sort desc
```

### Pass variables
```bash
jq --arg name "Alice" '.[] | select(.name == $name)'
jq --argjson min 10 '.[] | select(.count > $min)'
```

## Common errors

- `null` returned → key doesn't exist at that path; use `// "default"` fallback
- `parse error` → input is not valid JSON; pipe through `python3 -m json.tool` first
- `Cannot index string with string "x"` → you're at a string node, not an object; check path with `type`
```
