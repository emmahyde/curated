# Focus: Best Practices

**Prerequisite:** Read `.context/codebase/STACK.md` first to determine which languages are in use.

For each language identified in STACK.md, write a `<LANG>-BEST-PRACTICES.md` document to `.context/codebase/`. The language name should be uppercase (e.g., `RUBY-BEST-PRACTICES.md`, `TYPESCRIPT-BEST-PRACTICES.md`).

**Scale to adherence.** This is not a generic best practices guide — it's an assessment of how well THIS codebase follows best practices for each language, grounded in what you actually find.

For each language, explore the codebase and write:

```markdown
# [Language] Best Practices

## Adherence Summary

| Practice   | Status                               | Evidence                 |
| ---------- | ------------------------------------ | ------------------------ |
| [practice] | Established / Inconsistent / Missing | [file paths or patterns] |

## Established Practices

Patterns the codebase follows consistently. Implementers MUST continue these.

- [Practice]: [How it's done, with file path examples]

## Inconsistent Practices

Patterns that appear in some places but not others. Flag for discussion.

- [Practice]: [Where it's followed vs. where it's not, with file paths]

## Missing Practices

Industry best practices for this language that are absent from the codebase. Not necessarily wrong — may be intentional. Flag for awareness.

- [Practice]: [What it would look like, why it matters]

## Anti-Patterns Found

Patterns that actively work against the language's strengths.

- [Anti-pattern]: [Where found, what to do instead, severity: low/med/high]

## Recommendations

Prioritized list of improvements, grounded in what the codebase actually does:

1. [Most impactful change] — [why, where]
2. [Next] — [why, where]
3. [Next] — [why, where]
```

**What to look for per language:**

- **Ruby:** frozen_string_literal, method visibility, memoization patterns, Enumerable usage, exception handling hierarchy, Rubocop compliance, gem version pinning
- **TypeScript/JavaScript:** strict mode, null safety, type narrowing, async/await patterns, import organization, ESLint compliance, bundle size awareness
- **Python:** type hints, virtual env management, import style, docstring conventions, exception hierarchy
- **Go:** error wrapping, context propagation, goroutine lifecycle, interface satisfaction
- **SQL:** index usage, N+1 patterns, migration safety, query complexity

Adapt to whatever languages STACK.md reports. Skip languages with trivial presence (e.g., a single shell script doesn't need BASH-BEST-PRACTICES.md).

Explore thoroughly. Include actual file paths. Return confirmation with file paths and line counts only.
