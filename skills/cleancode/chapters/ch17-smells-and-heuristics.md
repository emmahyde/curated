# Chapter 17: Smells and Heuristics

## Core Idea
Martin's master checklist: a numbered, cross-referenced catalog of everything that makes code smell bad, distilled from refactoring sessions across real codebases. Each item names a root violation of a principle developed in Chapters 2–16.

## How to Use
Run this list as a code-review or self-review checklist; each code (C1, G5, N2, etc.) is cross-referenced in Appendix C so you can trace any smell back to the chapter that explains it fully.

---

## Comments (C)
- **C1 Inappropriate Information** — hold change history, author metadata, etc. in version control, not comments
- **C2 Obsolete Comment** — stale or irrelevant comments mislead; delete or update immediately
- **C3 Redundant Comment** — comment that just restates what the code already says; adds no value
- **C4 Poorly Written Comment** — if a comment is worth writing, write it well; no rambling or sloppiness
- **C5 Commented-Out Code** — dead code left in comments rots; delete it, source control has history

## Environment (E)
- **E1 Build Requires More Than One Step** — a project build should be one trivial command, not a multi-step ritual
- **E2 Tests Require More Than One Step** — all unit tests must be runnable with a single command or button click

## Functions (F)
- **F1 Too Many Arguments** — zero is ideal; one or two fine; three marginal; four or more almost always wrong
- **F2 Output Arguments** — readers expect arguments as inputs; if state must change, mutate `this`, not an arg
- **F3 Flag Arguments** — a boolean arg declares the function does two things; split it
- **F4 Dead Function** — methods never called should be deleted; source control preserves history

## General (G)
- **G1 Multiple Languages in One Source File** — one language per file; mixing (SQL, HTML, JS, XML inline) confuses and complicates
- **G2 Obvious Behavior Is Unimplemented** — the Principle of Least Surprise: implement what callers reasonably expect
- **G3 Incorrect Behavior at the Boundaries** — don't rely on intuition; write tests for every boundary condition
- **G4 Overridden Safeties** — turning off compiler warnings, failing tests, or safety mechanisms to make code "work" is catastrophic
- **G5 Duplication** — DRY: every duplicate is a missed abstraction; extract method, template method, or strategy
- **G6 Code at Wrong Level of Abstraction** — higher-level concepts belong in base classes/interfaces; low-level detail in derivatives/implementations
- **G7 Base Classes Depending on Their Derivatives** — base classes must not know about their subclasses; that coupling breaks independent deployment
- **G8 Too Much Information** — well-defined modules expose small interfaces; hide data, utility functions, and implementation details aggressively
- **G9 Dead Code** — code that is never executed (unreachable ifs, unused catches, never-called functions) should be deleted
- **G10 Vertical Separation** — declare variables and define functions close to where they are first used
- **G11 Inconsistency** — if you name or structure something a certain way, do it the same way everywhere; honor the Principle of Least Surprise
- **G12 Clutter** — default no-op constructors, unused variables, never-called functions, meaningless comments: all clutter; delete them
- **G13 Artificial Coupling** — things with no dependency should not be placed together (e.g., general enums inside unrelated classes)
- **G14 Feature Envy** — a method that reaches into another class's data more than its own class's belongs in the other class
- **G15 Selector Arguments** — boolean or enum arguments that select behavior inside a function should be split into separate functions
- **G16 Obscured Intent** — run-on expressions, Hungarian notation, magic numbers all hide intent; prefer maximal expressiveness
- **G17 Misplaced Responsibility** — put code where the reader expects it; PI lives in Math, not in a report formatter
- **G18 Inappropriate Static** — prefer instance methods; make a method static only when it genuinely cannot operate on any single instance
- **G19 Use Explanatory Variables** — break calculations into named intermediate variables to document intent (Kent Beck's pattern)
- **G20 Function Names Should Say What They Do** — if you cannot tell from the name what the function does, rename it; `add(5)` vs `addDaysTo(5)`
- **G21 Understand the Algorithm** — passing tests by trial and error is not enough; you must be able to explain why the algorithm is correct
- **G22 Make Logical Dependencies Physical** — if A relies on B's internal assumption (e.g., page size), make A explicitly ask B for that value
- **G23 Prefer Polymorphism to If/Else or Switch/Case** — switch on type is usually wrong; use polymorphism except where switch is genuinely most expressive
- **G24 Follow Standard Conventions** — team-wide coding standards (brace placement, variable declaration location) must be consistently honored
- **G25 Replace Magic Numbers with Named Constants** — every raw numeric literal in logic should be a named constant; `SECONDS_PER_DAY`, not `86400`
- **G26 Be Precise** — vagueness in decisions (assuming one result, using float for money, ignoring concurrency) is not acceptable; be exact
- **G27 Structure over Convention** — enforce design decisions with structure (e.g., abstract methods) rather than naming conventions alone
- **G28 Encapsulate Conditionals** — extract complex boolean logic into a named function: `if (shouldBeDeleted(timer))` not `if (timer.hasExpired() && !timer.isRecurrent())`
- **G29 Avoid Negative Conditionals** — `if (buffer.shouldCompact())` is easier to read than `if (!buffer.shouldNotCompact())`
- **G30 Functions Should Do One Thing** — functions with multiple sections performing different operations should be decomposed
- **G31 Hidden Temporal Couplings** — when operations must happen in order, structure arguments so the order is enforced, not merely conventional
- **G32 Don't Be Arbitrary** — every structural decision should have a reason; arbitrary structure invites others to change it arbitrarily
- **G33 Encapsulate Boundary Conditions** — boundary arithmetic (`level + 1`, `offset - 1`) should appear in one place, not scattered across the code
- **G34 Functions Should Descend Only One Level of Abstraction** — all statements in a function should be one level of abstraction below the function's stated purpose
- **G35 Keep Configurable Data at High Levels** — constants and defaults known at high levels should not be buried in low-level functions; pass them down
- **G36 Avoid Transitive Navigation** — don't write `a.getB().getC().doSomething()`; modules should know only their immediate collaborators (Law of Demeter)

## Java (J)
- **J1 Avoid Long Import Lists by Using Wildcards** — two or more classes from a package: `import package.*;` keeps the top of files short
- **J2 Don't Inherit Constants** — using `implements` to inherit constants is a hack; use a static import instead
- **J3 Constants versus Enums** — now that Java has `enum`, stop using `public static final int`; enums are more expressive and type-safe

## Names (N)
- **N1 Choose Descriptive Names** — take time to choose meaningful names; revisit them as code evolves
- **N2 Choose Names at the Appropriate Level of Abstraction** — names should reflect abstraction level, not implementation detail
- **N3 Use Standard Nomenclature Where Possible** — use pattern names (DECORATOR, FACTORY), domain terms, and project conventions
- **N4 Unambiguous Names** — a name should make the purpose of a variable or function unambiguous at a glance
- **N5 Use Long Names for Long Scopes** — short names for tiny scopes (loop `i`), long descriptive names for wide scopes
- **N6 Avoid Encodings** — drop `m_` prefixes, type suffixes, and Hungarian notation; modern IDEs make them worthless
- **N7 Names Should Describe Side-Effects** — don't use a simple noun when the function also creates or changes something; name both aspects

## Tests (T)
- **T1 Insufficient Tests** — test everything that could possibly break; "seems like enough" is never the metric
- **T2 Use a Coverage Tool!** — coverage tools surface untested modules and functions; use them and act on the gaps
- **T3 Don't Skip Trivial Tests** — easy to write, high documentary value; no excuse to omit them
- **T4 An Ignored Test Is a Question about an Ambiguity** — an `@Ignore` or `xtest` is a recorded question; resolve the ambiguity or document it
- **T5 Test Boundary Conditions** — we get the middle of algorithms right but misjudge edges; test them explicitly
- **T6 Exhaustively Test Near Bugs** — bugs congregate; when you find one, exhaustively test the surrounding code
- **T7 Patterns of Failure Are Revealing** — how test cases fail in sequence often diagnoses the root cause; read the pattern
- **T8 Test Coverage Patterns Can Be Revealing** — code not exercised by passing tests hints at why failing tests fail
- **T9 Tests Should Be Fast** — a slow test is a test that won't get run under pressure; optimize ruthlessly

---

## Key Takeaways
1. The catalog is a value system, not a rulebook — professionalism comes from internalizing why each smell is wrong, not from memorizing codes.
2. G5 (Duplication) and G34 (One Level of Abstraction) are the two highest-leverage heuristics; most other smells are downstream of violating them.
3. Naming (N1–N7) and structure (G27, G32) are the cheapest and highest-ROI improvements in any codebase.

## Connects To
- **Ch 2 (Names)**: N1–N7 distill that chapter
- **Ch 3 (Functions)**: F1–F4, G30, G34 distill that chapter
- **Ch 4 (Comments)**: C1–C5 distill that chapter
- **Ch 6–11 (Classes, Systems, Emergence, Concurrency)**: G6–G8, G13, G14, G18, G36 distill those chapters
- **Ch 14–16 (Successive Refinement case studies)**: this chapter is the extractable checklist from every refactoring step shown there
