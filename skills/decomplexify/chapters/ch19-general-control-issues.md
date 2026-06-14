# Chapter 19: General Control Issues

## Core Idea
Control quality depends on three things: writing boolean expressions clearly, limiting nesting depth, and measuring routine complexity — because complexity directly predicts defect rate and the cognitive burden of understanding code.

## Frameworks Introduced
- **Boolean expression clarity rules**: A set of practices for writing boolean tests that are readable, correct, and resistant to off-by-one errors.
  - When to use: Every boolean expression in every control structure.
  - How: Use `true`/`false` identifiers rather than 0/1; compare boolean variables implicitly (not `== true`); compare numeric values explicitly; encapsulate complex tests in named boolean functions; use decision tables for multi-variable conditions; apply DeMorgan's Theorems to simplify negated compound expressions; write comparisons in number-line order (e.g., `MIN < x && x < MAX`); parenthesize to make evaluation order explicit.
- **Structured programming**: The discipline that all programs can be built from three control structures — sequence, selection (if/case), and iteration (while/for) — each with one entry and one exit.
  - When to use: As the default approach to all control flow; departures require justification.
  - How: Bohm and Jacopini proved that any program can be written using only these three structures. In practice, this means never entering or exiting a control structure at an arbitrary point; the loop-with-exit (while-true/break) is acceptable because it is still one-entry, one-exit.
- **Complexity / decision points (McCabe metric)**: A numeric measure of control-flow complexity calculated by counting decision points in a routine.
  - When to use: As a routine-level quality gate during code review and design.
  - How: Start with 1; add 1 for each `if`, `else if`, `case`, `while`, `for`, `and`, `or`. Result: 0–5 = probably fine; 6–10 = consider simplifying; 10+ = break the routine into smaller pieces. Moving complexity to a called routine does not eliminate it globally but reduces what must be held in mind simultaneously.

## Key Concepts
- **Structured programming**: A programming discipline built on sequence, selection, and iteration — each construct has one entry and one exit, enabling local reasoning about program correctness.
- **Sequence**: Statements executed one after another in order; the simplest control structure.
- **Selection**: An if/case construct that chooses between two or more execution paths.
- **Iteration**: A loop construct that executes a group of statements multiple times.
- **DeMorgan's Theorems**: Logical identities that let you simplify negated compound boolean expressions: `!(A && B)` ≡ `!A || !B`; `!(A || B)` ≡ `!A && !B`.
- **Decision points**: Branching constructs (if, else-if, case, while, for, and, or) that each add one to the McCabe complexity count.
- **Cyclomatic complexity**: Tom McCabe's 1976 metric measuring the number of linearly independent paths through a routine, correlated empirically with defect rate and low reliability.
- **Null statement**: An empty statement body (e.g., a semicolon alone on a line or an empty loop body) that must be made visually obvious to prevent accidental deletion or misreading.
- **Deep nesting**: More than three to four levels of nested control structures; studies show most programmers cannot understand more than three levels of nested ifs simultaneously.
- **Number-line order**: Writing numeric comparisons so the values appear in the same left-to-right order as they would on a number line, e.g., `0 <= i && i < MAX` rather than `i < MAX && i >= 0`.

## Mental Models
- Think of complexity as the number of mental objects to juggle simultaneously: Miller's law says humans handle 5–9 entities; design routines to stay within that limit.
- Use structured programming as a default and treat any departure (goto, multiple returns, break) as requiring explicit justification, not as equivalent alternatives.
- Use the decision-point count as a refactoring trigger: when a routine hits 10+, splitting it reduces per-routine complexity even if total program complexity stays the same.
- Apply DeMorgan's Theorems whenever you see `!(A && B)` or `!(A || B)` in a test — the simplified positive form is almost always clearer.

## Anti-patterns
- **Using 0/1 for boolean tests**: Writing `if (flag == 1)` or `while (done == 0)` instead of `if (flag)` or `while (!done)` — obscures intent and invites type-confusion bugs.
- **Inline complex boolean tests**: Embedding a multi-variable condition directly in an `if` rather than extracting it into a named boolean function — the test's purpose is invisible to a reader.
- **Deep nesting beyond three levels**: Nesting if statements four or more levels deep; studies by Chomsky and Weinberg show most programmers lose track of the logic above three levels.
- **Invisible null statements**: An empty loop body or empty if clause with no explicit comment or formatting signal — indistinguishable from accidentally deleted code.
- **Over-10-decision-point routines without justification**: Leaving a routine with more than 10 decision points unchanged when it could be decomposed — empirically linked to higher defect rates.

## Key Takeaways
1. Write boolean expressions using `true`/`false`, positive forms, number-line order, and named functions for complex tests — clarity here directly reduces bugs.
2. Apply DeMorgan's Theorems to simplify negated compound conditions into equivalent positive forms.
3. Structured programming (sequence, selection, iteration; one entry, one exit) is the theoretical foundation that makes control flow locally understandable and formally provable.
4. Limit nesting to three or four levels; reduce deeper nesting by retesting conditions, converting to if-then-else or case, extracting routines, or redesigning toward objects.
5. Measure routine complexity using McCabe's decision-point count: redesign any routine above 10 decision points; treat 6–10 as a warning zone.
6. Complexity cannot be eliminated by decomposition — only redistributed — but reducing per-routine complexity is still worthwhile because it limits the cognitive load at each reading.

## Connects To
- **Ch14**: Sequential code is the baseline (complexity = 1); every control structure adds decision points.
- **Ch15**: Boolean expression rules (Section 19.1) directly govern how conditionals should be written.
- **Ch16**: Loop decision points contribute to McCabe complexity; loop-with-exit is validated as structured (one entry, one exit).
- **Ch17**: Structured programming (Section 19.5) is the theoretical justification for avoiding gotos and using multiple returns only deliberately.
- **Ch18**: Decision tables (referenced in Section 19.1) replace complicated boolean expressions.
- **Ch5**: Software's Primary Technical Imperative — managing complexity — is the motivation for all of Chapter 19's guidance.
