# curated

My tooling recommendations based on real-world trial & error.

A hand-picked set of [Claude Code](https://claude.com/claude-code) skills and plugins that have actually earned their keep — agentic workflows, knowledge bases, and one full pipeline plugin.

## Layout

```
skills/     drop into ~/.claude/skills/ (or a plugin's skills/)
plugins/    install as a Claude Code plugin (keeps .claude-plugin/, agents/, skills/)
```

## Workflow skills

General-purpose agentic procedures — original, project-agnostic.

| Skill | What it does |
|-------|--------------|
| [diagnose](skills/diagnose) | Disciplined repro → minimise → hypothesise → instrument → fix loop for hard bugs and perf regressions. Builds the feedback loop first. |
| [askme](skills/askme) | Verbalized-Sampling intent exploration before planning — sample weighted intent hypotheses with a falsifier each, then fire the maximum batch of clarifying questions. Three modes (exhaustive / collaborative / adversarial). |
| [duet](skills/duet) | Two-party posture — user directs, agent executes; every genuine fork surfaced as a pick at decision-time via batched questions. Distributes review across the task instead of one giant diff at the end. Builds on `askme`'s VS protocol. |
| [grill-with-docs](skills/grill-with-docs) | Stress-test a plan against your domain model and docs; sharpen terminology and update `CONTEXT.md` / ADRs inline as decisions crystallise. |
| [improve-codebase-architecture](skills/improve-codebase-architecture) | Surface deepening refactors that turn shallow modules into deep ones, guided by `CONTEXT.md` and `docs/adr/`. |
| [audit](skills/audit) | Structured PASS/FAIL audit of any target against any criteria, returning a violations table with fixes. |
| [audit-against](skills/audit-against) | Grade work against a knowledge-base skill's rubric via a parallel mixture-of-experts council with adversarial verification. |
| [triage](skills/triage) | Move issue-tracker items through a triage state machine; produce durable agent briefs. Bundles `AGENT-BRIEF.md` and `OUT-OF-SCOPE.md`. |
| [prototype](skills/prototype) | Build a throwaway prototype — a runnable terminal app for logic/state, or toggleable UI variants — before committing to a design. |
| [impeccable](skills/impeccable) | Opinionated anti-slop frontend design system: UX, visual hierarchy, OKLCH color, motion, tokens, named anti-patterns. |
| [passoff](skills/passoff) | Token-conservative session handoff — symbolic state summary plus literal `TaskCreate` seeds to rehydrate a cleared task list. |
| [prompt-master](skills/prompt-master) | Generate optimized prompts tuned per AI tool and model. |
| [search-web](skills/search-web) | Budget-disciplined web research: index a source corpus in 1–2 searches, batch-fetch, then reason over local files. |
| [source-to-skill](skills/source-to-skill) | Convert any source — repo, script, API docs, paper, or a whole book — into a best-fit SKILL.md. Books route to a knowledge-base pipeline (chapters + glossary + patterns + cheatsheet) via a bundled multi-format extractor (PDF/EPUB/DOCX/MOBI). |

## Knowledge bases

Book-derived reference skills — load on demand while coding.

| Skill | Source |
|-------|--------|
| [algos](skills/algos) | *The Algorithm Design Manual* (Skiena) + *Algorithms 4e* (Sedgewick & Wayne). |
| [cleancode](skills/cleancode) | *Clean Code* — Robert C. Martin. |
| [decomplexify](skills/decomplexify) | *Code Complete, 2e* — Steve McConnell. |
| [metzify](skills/metzify) | *99 Bottles of OOP* — Sandi Metz, Katrina Owen & TJ Stankus. |
| [software-engineering-laws](skills/software-engineering-laws) | Conway, Brooks, Parkinson, Pareto & friends — empirical laws as decision heuristics. |
| [railsguide](skills/railsguide) | Offline Ruby on Rails reference — official Guides + core API docs as on-demand markdown. |

## Plugins

| Plugin | What it does |
|--------|--------------|
| [discuss-and-execute](plugins/discuss-and-execute) | Discuss implementation decisions, then execute with parallel agents in coordinated waves. A context → discuss → plan → execute pipeline with four supporting agents (codebase-mapper, planner, implementer, researcher). |
