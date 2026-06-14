# Focus: Quality

Analyze this codebase for coding conventions and testing patterns.
Write these documents to `.context/codebase/`:

## CONVENTIONS.md

```markdown
# Code Conventions

## Style

- [Language]: [Style guide / linter, config location]

## Naming

- Classes/Modules: [convention]
- Methods/Functions: [convention]
- Variables: [convention]
- Files: [convention]

## Patterns

- Error handling: [approach, example file]
- Logging: [approach, example file]
- Configuration: [approach]

## Common Idioms

- [Pattern]: [Where used, example]
```

## TESTING.md

```markdown
# Testing

## Framework

- [Framework]: [Config location]
- Runner: [command]

## Structure

| Test Type   | Location | Pattern          |
| ----------- | -------- | ---------------- |
| Unit        | [path]   | [naming pattern] |
| Integration | [path]   | [naming pattern] |
| E2E         | [path]   | [naming pattern] |

## Patterns

- Mocking: [approach, example]
- Fixtures: [location, approach]
- Factories: [if applicable]

## Running Tests

- All: [command]
- Single file: [command]
- Watch mode: [command]
```

Explore thoroughly. Include actual file paths. Return confirmation with file paths and line counts only.
