# Knowledge & Memory — Skill Integration Guide

How to wire Claude's memory system, context-mode, and knowledge base directly into a generated SKILL.md so the skill persists state, recalls prior findings, and stays efficient across invocations.

## The four layers a skill can reach

| Layer | Mechanism | Persists across sessions? | Raw bytes in context? |
|-------|-----------|--------------------------|----------------------|
| **Memory** | Read/write files in `~/.claude/projects/<project>/memory/` | Yes | Only what you explicitly read |
| **Knowledge base** | `ctx_search(queries)` over indexed content + auto-captured session memory | Yes (session memory); no (indexed content resets) | No — snippets only |
| **Context-mode index** | `ctx_fetch_and_index` / `ctx_batch_execute` + `ctx_search` | No — current session only | No — query results only |
| **Codemode web/research** | `mcp__codemode__web_search` / `mcp__codemode__research` | No — returns results inline | Yes — pipe into ctx_index to avoid |

## Pattern 1 — Read memory on invocation

Add to the skill's **Quick start** or first workflow step: check memory before doing any research or fetch. Avoids re-deriving what's already known.

```markdown
## On invocation
1. Run `ctx_search(queries: ["<domain> prior findings", "<domain> user preference"], sort: "timeline")` to surface any prior session decisions or saved memories relevant to this task.
2. If a relevant memory file exists (check MEMORY.md), read it before proceeding.
```

## Pattern 2 — Write memory after completing work

Add to the skill's **completion step**: decide what's worth persisting. Use the memory type that fits:

| What happened | Memory type | File naming |
|--------------|-------------|-------------|
| Found a non-obvious pattern the user confirmed | `reference` | `ref-<domain>-<slug>.md` |
| User corrected the skill's approach | `feedback` | `feedback-<skill-name>-<slug>.md` |
| Learned domain context relevant to future runs | `project` | `project-<domain>.md` |
| Discovered where canonical info lives | `reference` | `ref-source-<slug>.md` |

Only write when the finding is **non-obvious and reusable** — skip anything re-derivable from the source or obvious from the skill shape.

## Pattern 3 — Use context-mode to keep raw data out

For skills that fetch large sources (docs, APIs, READMEs), route through context-mode instead of loading raw bytes into conversation:

```markdown
## Research step
- Fetch with `ctx_fetch_and_index(url, source: "<label>")` — raw content stays in sandbox.
- Query with `ctx_search(queries: ["<specific question>"], source: "<label>")` — only matching snippets surface.
- Process/aggregate with `ctx_execute(language, code)` — only what you `console.log()` enters context.
```

This is especially important for skills with large reference corpora (API docs, awesome lists, prompt libraries).

## Pattern 4 — Surface prior session context at skill start

For skills that run repeatedly (research, review, lookup), add a session-resume step using timeline sort:

```markdown
ctx_search(queries: ["<domain> decision", "<domain> error", "<domain> approach"], sort: "timeline")
```

This surfaces auto-captured session memory (decisions, blockers, rejected approaches) alongside manually written memories — no manual journaling needed.

## Pattern 5 — Codemode web/research for skill research steps

`mcp__codemode__web_search` and `mcp__codemode__research` are available inside skills for live web lookups, but their results land directly in context. Manage this explicitly:

**web_search** — use for targeted, narrow queries where 2–5 results suffice. Returns snippets inline; keep queries specific to avoid bloat.

**research** — use for shallow domain orientation (equivalent to depth=1). Good for "what does this tool do" before a targeted fetch. Do NOT use for deep crawls — it will flood context. Cap at one call per domain.

**Preferred pattern — pipe codemode results into context-mode:**

```markdown
## Research step
1. `mcp__codemode__web_search("<specific query>")` — get candidate URLs.
2. `ctx_fetch_and_index(url, source: "<label>")` for each promising URL — index content, keep bytes out of context.
3. `ctx_search(queries: ["<what you need"])` — retrieve only relevant snippets.
```

**When to use codemode directly vs. routing through context-mode:**

| Situation | Use |
|-----------|-----|
| Query returns ≤ 3 short results you'll read in full | `web_search` directly |
| Query returns full pages or docs | `web_search` → `ctx_fetch_and_index` → `ctx_search` |
| Shallow "what is this tool" orientation | `mcp__codemode__research` (once, depth=1) |
| Systematic multi-URL research | `ctx_batch_execute` with fetch commands |

## When NOT to use memory in a skill

- **One-shot lookup skills** (e.g. free-for-dev): no state to persist; skip memory entirely.
- **Skills with external ground truth** (APIs, live docs): prefer re-fetching over stale memories.
- **In-session scratchpad work**: use tasks or plans instead — memory is for cross-session durability.

## Skill template snippet

Add this block to any SKILL.md where cross-session memory adds value:

```markdown
## Memory

**On start:** `ctx_search(queries: ["<domain> prior findings"], sort: "timeline")` — surface prior decisions before fetching.
**On finish:** If a non-obvious finding was confirmed, write a `reference` or `feedback` memory file and update `MEMORY.md`.
**Skip writing if:** the finding is re-derivable from the source, already in git, or only relevant to this session.
```
