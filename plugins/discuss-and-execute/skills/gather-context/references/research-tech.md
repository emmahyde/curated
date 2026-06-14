# Focus: Tech

Analyze this codebase for technology stack and external integrations.
Write these documents to `.context/codebase/`:

## STACK.md

```markdown
# Technology Stack

## Languages & Runtime

- [Language]: [Version source, e.g., `.ruby-version`, `package.json`]
- [Runtime]: [Details]

## Frameworks

- [Framework]: [Usage context]

## Key Dependencies

| Dependency | Purpose        | Config Location    |
| ---------- | -------------- | ------------------ |
| [name]     | [what it does] | [where configured] |

## Build & Dev

- Build: [command / tool]
- Dev server: [command]
- Package manager: [name]

## Configuration Files

- [file path]: [what it configures]
```

## INTEGRATIONS.md

```markdown
# External Integrations

## APIs & Services

| Service | Purpose    | Config/Credentials | Client Code |
| ------- | ---------- | ------------------ | ----------- |
| [name]  | [what for] | [env var / config] | [file path] |

## Databases

- [Type]: [Connection config location]

## Auth Providers

- [Provider]: [Integration details]

## Webhooks / Events

- [Endpoint/Event]: [Purpose, handler location]
```

Explore thoroughly. Include actual file paths. Return confirmation with file paths and line counts only.
