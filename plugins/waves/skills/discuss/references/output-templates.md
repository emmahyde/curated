# Output Document Templates

Templates for output documents. Used by interactive mode (Step 9). Auto mode uses the CONTEXT template below but has its own DISCUSSION_LOG template inline in auto-mode.md.

## CONTEXT-<SLUG>.md Template

```markdown
# Context: [Work Description]

**Gathered:** [date]
**Status:** Ready for implementation
**Codebase map:** .context/codebase/ (mapped [date of map])

<domain>
## Scope

[Clear statement of what this work delivers — the scope anchor]
</domain>

<decisions>
## Implementation Decisions

### [Category 1 that was discussed]

- **D-01:** [Decision or preference captured]
- **D-02:** [Another decision if applicable]

### [Category 2 that was discussed]

- **D-03:** [Decision or preference captured]

### Claude's Discretion

[Areas where user said "you decide" — note that Claude has flexibility here]
</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before implementing.**

[MANDATORY section. Write the FULL accumulated canonical refs list here.
Sources: codebase map refs + user-referenced docs during discussion + any docs
discovered during codebase scout. Group by topic area.
Every entry needs a full relative path — not just a name.]

### [Topic area 1]

- `path/to/adr-or-spec.md` — [What it decides/defines that's relevant]

### [Topic area 2]

- `path/to/feature-doc.md` — [What this doc defines]

[If no external specs: "No external specs — requirements fully captured in decisions above"]
</canonical_refs>

<code_context>

## Codebase Insights

### Reusable Assets

- [Component/hook/utility]: [How it could be used]

### Established Patterns

- [Pattern]: [How it constrains/enables this work]

### Integration Points

- [Where new code connects to existing system]
  </code_context>

<specifics>
## Specific Ideas

[Any particular references, examples, or "I want it like X" moments from discussion]

[If none: "No specific requirements — open to standard approaches"]
</specifics>

<deferred>
## Deferred Ideas

[Ideas that came up but belong in separate work. Don't lose them.]

[If none: "None — discussion stayed within scope"]
</deferred>

<unresolved>
## Unresolved Disagreements

[Positions that did not converge during discussion. The planner and implementers
should treat these as open questions — make a reasonable choice, document it, and
flag it for human review.]

[If none: omit this section]
</unresolved>

---

_Context for: [work description]_
_Gathered: [date]_
```

## Synthesis-to-CONTEXT Mapping (auto mode)

When writing CONTEXT from a panel discussion synthesis, map the 6 items as follows:

| Synthesis Item               | CONTEXT Section                                                  |
| ---------------------------- | ---------------------------------------------------------------- |
| 1. Agreed approach           | `<domain>` Scope                                                 |
| 2. Agreed task decomposition | `<decisions>` Implementation Decisions (as guidance for planner) |
| 3. Conventions to enforce    | `<decisions>` Implementation Decisions (as constraints)          |
| 4. Concerns to watch         | `<code_context>` Codebase Insights > Integration Points          |
| 5. Reusable code             | `<code_context>` Codebase Insights > Reusable Assets             |
| 6. Unresolved disagreements  | `<unresolved>` Unresolved Disagreements                          |

## DISCUSSION_LOG-<SLUG>.md Template (interactive mode only)

Auto mode (`--auto`) uses a different template — see auto-mode.md Step 5.

```markdown
# Discussion Log: [Work Description]

> **Audit trail only.** Do not use as input to implementation agents.
> Decisions are captured in CONTEXT-<SLUG>.md — this log preserves the alternatives considered.

**Date:** [ISO date]
**Work:** [work description]
**Areas discussed:** [comma-separated list]

---

[For each gray area discussed:]

## [Area Name]

| Option     | Description                        | Selected |
| ---------- | ---------------------------------- | -------- |
| [Option 1] | [Description from AskUserQuestion] |          |
| [Option 2] | [Description]                      | ✓        |
| [Option 3] | [Description]                      |          |

**User's choice:** [Selected option or free-text response]
**Notes:** [Any clarifications, follow-up context, or rationale the user provided]

---

[Repeat for each area]

## Claude's Discretion

[List areas where user said "you decide" or deferred to Claude]

## Deferred Ideas

[Ideas mentioned during discussion that were noted for separate work]
```

## Confirm and Present Template

```
Created:
- .context/CONTEXT-<SLUG>.md
- .context/DISCUSSION_LOG-<SLUG>.md

## Decisions Captured

### [Category]
- [Key decision]

### [Category]
- [Key decision]

[If deferred ideas exist:]
## Noted for Later
- [Deferred idea] — separate work

---

**Next:** /plan-waves <SLUG>

**Also available:**
- Review/edit CONTEXT-<SLUG>.md before planning
- /discuss [another task] to scope more work
```
