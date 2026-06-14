# Chapter 7: High-Quality Routines

## Core Idea
The most important reason to create a routine is to improve the intellectual manageability of a program; functional cohesion — doing one and only one thing well — is the single most important quality of a well-designed routine.

## Frameworks Introduced
- **Cohesion (routine level)**: How closely the operations inside a routine are related; the goal is functional cohesion.
  - When to use: Every time you design or evaluate a routine
  - How: Rank from strongest to weakest — Functional (one operation, ideal) → Sequential (steps sharing data in order) → Communicational (operations on same data) → Temporal (things done at same time) → Procedural (steps in a fixed order with no shared data) → Logical (related by a control flag) → Coincidental (no relationship, worst); aim for functional and accept sequential/communicational; avoid logical and coincidental

- **Coupling (routine level)**: The tightness of connections between a routine and the routines it calls; loose coupling is the goal.
  - When to use: Evaluating parameter lists and call relationships
  - How: Keep connections small, intimate, visible, and flexible; if you consistently pass more than ~7 parameters, coupling is too tight and the routines need redesign

## Key Concepts
- **Functional Cohesion**: The strongest form — a routine performs one and only one operation (e.g., `sin()`, `GetCustomerName()`).
- **Sequential Cohesion**: Operations must be performed in a specific order and share data step-to-step but don't form a single complete function together.
- **Communicational Cohesion**: Operations use the same data but are otherwise unrelated — weaker than sequential.
- **Logical Cohesion**: A routine does one of several operations selected by a control flag — the interface lies about what the routine actually does.
- **Parameter Order**: Input parameters first, then modified parameters, then output parameters; match order across similar routines; document interface assumptions (units, ranges, values that must never appear, input-only vs. output-only).
- **Seven-Parameter Limit**: People can track roughly seven chunks of information at once; routines with more than ~7 parameters signal excessive coupling.
- **Routine Length**: Determined by function and logic, not by an arbitrary line-count standard; routines can legitimately be longer when they contain complex logic that belongs together.

## Mental Models
- Use "does this routine do one thing and only one thing?" as the primary cohesion test — if the name requires "And" it probably lacks functional cohesion.
- Think of a routine name as a contract: if the name doesn't describe all outputs and side effects, the routine is doing undocumented work.
- Use cohesion/coupling as a paired metric: a study of 450 routines found routines with the highest coupling-to-cohesion ratios had 7× more errors and were 20× more costly to fix.
- Treat the parameter list as an abstraction interface — it should present a consistent, coherent picture of what the routine needs, not expose internal implementation details.

## Anti-patterns
- **Routines named with vague verbs** (HandleData, ProcessInput, DoStuff): Name describes nothing; forces callers to read the body to understand the contract.
- **Using input parameters as working variables**: Corrupts the caller's understanding of what was passed in; use local copies instead.
- **Logical cohesion via control flags**: A routine that takes a boolean or enum to decide which of several operations to perform is really multiple routines in a trench coat — split it.
- **Side effects not reflected in the name**: If ComputeReportTotals() also opens a file, either eliminate the side effect or rename the routine to reflect both actions.
- **More than ~7 parameters**: Almost always signals that the routine is doing too much or that coupling between routines is too tight.
- **Functions that don't return a valid value under all circumstances**: Partial return coverage is a latent defect.

## Key Takeaways
1. The most important reason to create a routine is intellectual manageability — not code reuse, not saving space.
2. Functional cohesion (one routine, one operation) is the goal; 50% of highly cohesive routines in one study were fault-free vs. only 18% of low-cohesion routines.
3. A routine's name must describe everything it does, including all outputs and side effects — if the name is too long, eliminate the side effects.
4. Limit parameters to ~7; consistently exceeding this signals that coupling is too tight and the design needs revision.
5. Document interface assumptions (units, ranges, input/output-only status) at both the call site and the routine definition.
6. Routine length should be determined by the logic, not by an arbitrary standard — let the function dictate the length.

## Connects To
- **Ch5**: Cohesion and coupling are design heuristics introduced in Ch5 and applied here at the routine level
- **Ch6**: Routines are the internal building blocks of classes; good class abstraction requires good routine abstraction
- **Ch9**: The Pseudocode Programming Process is the step-by-step construction method for building routines
- **Ch11**: Variable naming conventions complement routine naming conventions
