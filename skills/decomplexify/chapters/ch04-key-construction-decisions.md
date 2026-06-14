# Chapter 4: Key Construction Decisions

## Core Idea
Before writing the first line of code, individual programmers and tech leads must consciously decide on programming language, coding conventions, and major construction practices — decisions that are nearly impossible to change mid-project and that directly shape code quality and team coherence.

## Frameworks Introduced
- **Programming Into the Language**: The practice of deciding what you want to do first, then using the language to express it — as opposed to programming *in* the language, where the language's limitations constrain your thinking and design.
  - When to use: Whenever a language lacks a direct construct for a needed technique (error handling, assertions, abstraction layers).
  - How: Identify the technique or structure you need; implement it using the language's available primitives even if no direct keyword exists.

- **Technology Wave Position**: A framework for calibrating expectations and practices based on where the technology stack sits in its maturity cycle (early-wave vs. late-wave).
  - When to use: When selecting tools, estimating productivity, or setting quality standards for a project.
  - How: Early-wave → expect buggy tools, poor docs, workarounds, slower progress; adjust estimates and practices accordingly. Late-wave → rich tooling, comprehensive docs, reliable compilers, integrated environments.

- **Major Construction Practices Checklist** (cc2e.com/0496): A pre-construction decision inventory in three categories — Coding (how much design up front vs. at keyboard; naming/commenting/layout conventions; architecture-implied practices like error handling and security; technology wave position and programming-into-the-language plan), Teamwork (integration procedure; pair vs. solo programming), and Quality Assurance (test-first or test-last; unit tests; stepping through code in debugger before check-in).
  - When to use: At project start, before construction begins.
  - How: Walk through all three categories; record explicit choices for each item; revisit if project type or team changes significantly.

## Key Concepts
- **Programming Language Choice**: Affects productivity (3x–15x across language levels), expressiveness, error rates, and team familiarity; high-level languages (C++, Java, Visual Basic) outperform assembly/C on productivity and reliability by 5–15x.
- **Programming Conventions**: Naming, commenting, formatting, and class-interface standards that give a program low-level harmony consistent with its architecture; must be established before construction, nearly impossible to retrofit.
- **Conceptual Integrity (implementation)**: The relationship between architectural guidelines and low-level implementation; conventions are the mechanism that enforces this integrity across a team.
- **Early-Wave Environment**: A technology in early adoption — buggy tools, sparse documentation, programmers spend significant time understanding the language rather than writing features.
- **Late-Wave Environment**: A mature technology — comprehensive tooling, reliable compilers, integrated IDEs, abundant documentation, training, and consultants available.
- **Pair Programming**: A construction practice where two programmers work at one keyboard; may be used for all or part of a project depending on circumstances.
- **Test-First Development**: Writing test cases before writing the code they test; a practice to be consciously chosen or explicitly rejected at project start.

## Mental Models
- Think of conventions as the low-level counterpart to architecture: architecture provides structural balance; conventions provide implementation harmony. A program without conventions is a collage of arbitrary style variations that tax every reader's brain unnecessarily.
- Use the technology wave frame when a project hits unexpected friction: if you're in an early-wave environment, that friction is normal and must be budgeted for, not treated as individual failure.
- Think of "programming into the language" vs. "programming in the language" as the difference between being the language's master vs. its prisoner.

## Anti-patterns
- **Deferring convention decisions until mid-project**: Conventions established after construction begins are applied inconsistently or not at all; the codebase becomes a collage.
- **Being controlled by the language**: Letting the programming language's limitations dictate design decisions rather than implementing needed techniques using available primitives.
- **Assuming early-wave productivity equals late-wave productivity**: Underestimating the overhead of early-wave environments (buggy tools, missing docs, workarounds) leads to blown schedules.
- **Leaving major practice decisions implicit**: Pair programming, test-first, integration procedures — if not explicitly chosen, they default to whatever each developer prefers, destroying team coherence.

## Key Takeaways
1. Every programming language has strengths and weaknesses; know them and account for them explicitly.
2. Establish all coding conventions before construction begins — retrofitting them is nearly impossible.
3. Program *into* the language, not *in* it: don't let language limitations dictate design choices.
4. Your position on the technology wave determines realistic productivity expectations and required workarounds.
5. Consciously choose major construction practices (pair programming, test-first, code review, integration procedure) rather than leaving them to chance.
6. High-level languages improve productivity and reliability by 5–15x over low-level languages — language choice is a major project lever.

## Connects To
- **Ch3**: This chapter follows naturally after prerequisites are satisfied — now individual programmers make their own preparation decisions.
- **Ch5**: Design-in-construction decisions extend the convention and practice framework into detailed design choices.
- **Ch27**: Project size affects which practices are appropriate and how formally conventions must be documented.
- **Ch28**: Managing construction depends on these decisions being made and communicated explicitly.
