# Chapter 1: Welcome to Software Construction

## Core Idea
Software construction — the hands-on work of detailed design, coding, debugging, and developer testing — is the central and only universally guaranteed activity in software development; its quality directly determines software quality.

## Frameworks Introduced
- **Software Construction (definition)**: The set of activities at the center of software development, distinct from requirements, architecture, system testing, and maintenance; encompasses detailed design, coding, debugging, unit testing, integration testing, and integration.
  - When to use: As the primary frame for understanding what programmers do day-to-day.
  - How: Draw the boundary — in: detailed design, coding, debugging, unit testing, integration testing, integration. Out: requirements, architecture, UI design, system testing, management.

## Key Concepts
- **Software Construction**: The hands-on process of building software; synonymous with "coding" and "programming" but broader — requires creativity and judgment, not just mechanical translation.
- **Detailed Design**: Low-level design work done during construction, distinct from high-level software architecture done upstream.
- **Integration**: Combining separately built software components into a working whole; part of construction.
- **Developer Testing**: Unit and integration testing performed by the programmer who wrote the code, distinct from independent system testing.
- **Nonconstruction Activities**: Requirements development, software architecture, UI design, system testing, and management — affect project success but outside the construction boundary.
- **Productivity Variation**: Individual programmer productivity varies by a factor of 10–20 during construction (Sackman, Erikson, Grant 1968), making construction skill a critical differentiator.

## Mental Models
- Think of construction as everything inside the "gray circle" — the daily programming zone surrounded by upstream planning and downstream testing.
- Use 30–80% of total project time as an anchor: construction dominates project schedules, so its quality dominates outcomes.
- Think of "coding" as an inadequate synonym — construction involves judgment and creativity, not transcription.

## Anti-patterns
- **Equating construction with all of programming**: Conflating requirements, architecture, and testing with construction obscures where quality problems originate.
- **Treating construction as mechanical**: Assuming coding is just transcription of a pre-existing design; construction always requires design decisions at the keyboard.

## Key Takeaways
1. Construction is the only activity guaranteed on every project — everything else may be skipped or skimped.
2. Construction takes 30–80% of project time; improving it has proportional impact on project success.
3. Main activities: detailed design, coding, debugging, integration, unit testing, integration testing.
4. "Coding" and "programming" are used interchangeably with "construction" throughout this book.
5. Quality of construction substantially determines quality of the final software product.
6. Individual programmer productivity during construction varies by 10–20x — the highest-leverage variable in project staffing.
7. Source code is often the most accurate and up-to-date specification; design docs and requirements go stale.

## Connects To
- **Ch3**: Upstream prerequisites (requirements, architecture) must be satisfied before construction proceeds effectively.
- **Ch4**: Language, conventions, and practice decisions must be made before construction begins.
- **Ch27**: Project size changes the share of time construction consumes and which practices apply.
