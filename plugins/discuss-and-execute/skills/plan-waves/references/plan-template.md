# Plan Template

Read this file when generating or reviewing PLAN documents.

## PLAN-<SLUG>.md Template

```markdown
# Plan: [Work Description]

**Source:** .context/CONTEXT-<SLUG>.md
**Generated:** [date]
**Status:** Ready for execution

## Overview

[1-2 sentence summary of what this plan delivers]

**Waves:** [N]
**Total tasks:** [M]

---

## Wave 1: [Wave Description]

**Prerequisite:** None (first wave)

### Task 1.1: [Task Summary]

- **Files owned:** `path/to/file.rb`, `path/to/other.rb`
- **Depends on:** None
- **Decisions:** D-01, D-03 from CONTEXT
- **Acceptance criteria:**
  - [ ] [Testable condition]
  - [ ] [Testable condition]

### Task 1.2: [Task Summary]

- **Files owned:** `path/to/different.rb`, `test/path/to/different_test.rb`
- **Depends on:** None
- **Decisions:** D-02 from CONTEXT
- **Acceptance criteria:**
  - [ ] [Testable condition]

**Wave 1 status:** pending

---

## Wave 2: [Wave Description]

**Prerequisite:** Wave 1 complete

### Task 2.1: [Task Summary]

- **Files owned:** `path/to/integration.rb`
- **Depends on:** Task 1.1, Task 1.2
- **Decisions:** D-04 from CONTEXT
- **Acceptance criteria:**
  - [ ] [Testable condition]

**Wave 2 status:** pending

---

[Repeat for each wave]

## File Ownership Map

| File                     | Owner    |
| ------------------------ | -------- |
| `path/to/file.rb`        | Task 1.1 |
| `path/to/other.rb`       | Task 1.1 |
| `path/to/different.rb`   | Task 1.2 |
| `path/to/integration.rb` | Task 2.1 |

## Cross-Wave Ownership Handoffs

Files that are owned by different tasks across waves. The team lead MUST ensure the earlier wave is complete before the later wave's task touches the file.

| File                  | Wave N Owner               | Wave M Owner                 | Handoff Notes                                       |
| --------------------- | -------------------------- | ---------------------------- | --------------------------------------------------- |
| `path/to/file.rb`     | Task 1.1 (initial impl)    | Task 3.2 (add async wrapper) | 3.2 must read 1.1's implementation before modifying |
| `test/test_helper.rb` | Task 1.2 (update override) | Task 4.1 (add async support) | 4.1 builds on 1.2's FatalError changes              |

**If this table is empty:** No cross-wave conflicts — all files are owned by exactly one task across the entire plan.

**Handoff protocol:** When a file appears here, the later task's implementer MUST:

1. Read the file as modified by the earlier task (not the original)
2. Build on those changes, not revert them
3. If the earlier task's changes conflict with the later task's needs, escalate to team lead

## Decision Traceability

| Decision | Tasks    |
| -------- | -------- |
| D-01     | Task 1.1 |
| D-02     | Task 1.2 |
| D-03     | Task 1.1 |
| D-04     | Task 2.1 |
```

## Wave Status Values

- `pending` — not yet started
- `in_progress` — implementers dispatched
- `review` — cross-review in progress
- `fixing` — blockers found, fix cycle running
- `complete` — passed cross-review

## File Ownership Rules

- Every file that will be created or modified MUST appear in at least one task's ownership
- Within a single wave, no two tasks can own the same file
- A file CAN be owned by tasks in different waves — this is a **cross-wave handoff** and MUST appear in the Cross-Wave Ownership Handoffs table
- Test files are owned by the same task as the source file they test
- Shared files (e.g., Gemfile, config) should be in the earliest wave that needs them
- The File Ownership Map lists ALL owners for each file (comma-separated if multiple across waves)
