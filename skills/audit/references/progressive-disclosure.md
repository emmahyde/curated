# Progressive Disclosure Criteria

Use this reference when the audit topic is "progressive disclosure" for Claude Code skills.

## Layers

| Layer           | Loads When                     | Should Contain                                                     | Should NOT Contain                                     |
| --------------- | ------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------ |
| **Description** | Always (system-reminder scan)  | What it delivers, prerequisites, `<triggers>`                      | Process detail, agent counts, internal protocols       |
| **Body**        | On invocation                  | Workflow steps, behavioral constraints, bash verification snippets | Templates, examples, prompt formats, pattern libraries |
| **References**  | On explicit `Read` within body | Templates, examples, prompt formats, domain-specific patterns      | Workflow logic, behavioral constraints                 |

## Classification

**Belongs in description:**

- One-line deliverable ("Writes .context/PLAN-{slug}.md")
- Prerequisite ("Requires .context/codebase/")
- `<triggers>` block
- Pipeline position ("Entry point — run before /discuss")

**Belongs in body (inlined):**

- `<philosophy>`, `<scope_guardrail>`, `<role>` blocks
- Step-by-step workflow with numbered steps
- Bash verification snippets (1-2 lines)
- Agent dispatch tables (which agents, which focus areas)
- `$CLAUDE_PLUGIN_ROOT` read instructions
- AskUserQuestion patterns

**Belongs in references (deferred):**

- Output document templates (CONTEXT-{slug}.md format, PLAN format)
- Agent prompt templates (implement mode, review mode)
- Domain-specific examples (gray area patterns, discussion examples)
- Escalation formats
- Cross-review protocols

## Checks

1. Description does not contain process detail
2. Description names the output artifact
3. Description includes prerequisites (if any)
4. Description has `<triggers>` block
5. Body does not inline templates >3 lines that belong in references
6. Body does not inline agent prompt formats
7. Body includes behavioral constraints that must be present at runtime
8. Body references all existing `references/*.md` via `$CLAUDE_PLUGIN_ROOT`
9. Reference files are >10 lines (substantive)
10. Reference files are not orphaned (all referenced by body)
11. No duplication between body and reference files
