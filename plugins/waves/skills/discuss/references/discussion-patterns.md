# Discussion Patterns & Examples

Read this file when reaching Steps 7-8 (Present Gray Areas / Interactive Discussion) for annotation patterns and domain-specific examples.

## Gray Area Presentation Patterns

### Prior decision annotations

When a gray area was already decided in prior context:

```
☐ Exit shortcuts — How should users quit?
  (You decided "Ctrl+C only, no single-key shortcuts" previously — revisit or keep?)
```

### Code context annotations

When the scout found relevant existing code:

```
☐ Layout style — Cards vs list vs timeline?
  (You already have a Card component with shadow/rounded variants. Reusing it keeps the app consistent.)
```

### Combining both

When both prior decisions and code context apply:

```
☐ Loading behavior — Infinite scroll or pagination?
  (You chose infinite scroll previously. useInfiniteQuery hook already set up.)
```

## Examples by Domain

### Visual Feature ("Post Feed")

```
☐ Layout style — Cards vs list vs timeline? (Card component exists with variants)
☐ Loading behavior — Infinite scroll or pagination? (useInfiniteQuery hook available)
☐ Content ordering — Chronological, algorithmic, or user choice?
☐ Post metadata — What info per post? Timestamps, reactions, author?
```

### Command-Line Tool ("Database backup CLI")

```
☐ Output format — JSON, table, or plain text? Verbosity levels?
☐ Flag design — Short flags, long flags, or both? Required vs optional?
☐ Progress reporting — Silent, progress bar, or verbose logging?
☐ Error recovery — Fail fast, retry, or prompt for action?
```

### Organization Task ("Organize photo library")

```
☐ Grouping criteria — By date, location, faces, or events?
☐ Duplicate handling — Keep best, keep all, or prompt each time?
☐ Naming convention — Original names, dates, or descriptive?
☐ Folder structure — Flat, nested by year, or by category?
```

### API Design ("User authentication")

```
☐ Session handling — Stateful sessions, JWTs, or hybrid?
☐ Error responses — HTTP status codes only, or structured error bodies?
☐ Multi-device policy — Allow unlimited, limit per user, or newest-wins?
☐ Recovery flow — Email link, SMS code, or security questions?
```

### Background Job ("Overdue payment reminders")

```
☐ Queue selection — Which Sidekiq queue? (critical/default/mailers?)
☐ Retry behavior — How many retries on transient failure? Dead-set handling?
☐ Idempotency — What prevents double-processing on retry? (DB flag, Redis key, separate log?)
☐ Scheduling trigger — Cron-style scheduler, event-driven, or ad-hoc?
```

## Discussion Question Patterns

### Research-backed question

When research produced a comparison table for this area, present it before asking:

```
| Approach | Pros | Cons | Fit for this codebase |
|----------|------|------|-----------------------|
| [Option] | [+]  | [-]  | [codebase fit note]   |

Which approach for [area]?
```

### Code-annotated options

```
"How should posts be displayed?"
- Cards (reuses existing Card component — consistent with Messages)
- List (simpler, would be a new pattern)
- Timeline (needs new Timeline component — none exists yet)
```

### Continuation check

```
"More questions about [area], or move on? (Remaining: [other unvisited areas])"
- More questions
- Next area
```
