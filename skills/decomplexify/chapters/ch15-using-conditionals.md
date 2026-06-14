# Chapter 15: Using Conditionals

## Core Idea
Write conditionals so the nominal (expected) path through the code is always the most visible path; order branches, chain tests, and structure case statements to maximize readability and minimize the chance of missed cases.

## Frameworks Introduced
- **Nominal-path-first rule**: Always write the case you normally expect to execute first, placing it in the `if` clause rather than the `else` clause. When to use: any `if-then-else` that distinguishes a common case from error or rare cases. How: put the normal processing path in the `if` branch; put error handling, rare cases, and null cases in the `else` branch; make the normal path obvious by reading straight down the `if` branches.
- **if-then-else-if chain ordering**: When chaining multiple conditions, order tests so the most common cases come first, which improves both readability and average performance. When to use: any chain of three or more mutually exclusive conditions. How: estimate frequency of each case; put the most frequent at the top; encapsulate complex tests in well-named boolean functions; ensure all cases are covered, adding a final `else` to catch unexpected values.
- **case statement guidelines**: Organize `case`/`switch` statements so that the structure itself communicates intent. When to use: dispatching on a single variable with multiple discrete values. How: order cases meaningfully (numerically, alphabetically, by frequency, or by importance); keep the action for each case simple (call a routine if needed); use the `default` clause to detect and report unexpected values; avoid fall-through except when intentional and explicitly commented.

## Key Concepts
- **Nominal path**: The execution path through a routine that represents normal, expected processing — not error handling or edge cases.
- **if-then-else**: A two-branch conditional where one branch is the normal case and the other handles the alternative.
- **if-then-else-if chain**: A sequence of mutually exclusive conditions tested in order; the first true condition executes and the rest are skipped.
- **case/switch statement**: A multi-way branch on a single variable's value; more readable than a long if-then-else-if chain when dispatching on a single variable.
- **fall-through**: The behavior in C/C++/Java `switch` where execution continues into the next case if no `break` is present; almost always a defect except when explicitly intended and commented.
- **Boolean function encapsulation**: Extracting a complex boolean test into a named function so the conditional reads as a self-documenting intent statement.

## Mental Models
- Use the nominal-path rule as a reading test: skim only the `if` branches top-to-bottom — if you cannot follow the normal logic that way, the code is inverted.
- Think of an if-then-else-if chain as a decision table: every row should be covered, and the most common rows should come first.
- Think of a `case` statement's `default` clause as a defensive assertion — it should never execute in correct code but must report loudly when it does.
- Use boolean function encapsulation when a test requires more than a glance to understand: if naming it clarifies intent, it belongs in a function.

## Anti-patterns
- **Error-case-first ordering**: Putting error handling in the `if` branch and normal processing in `else` — the reader must wade through exceptions to find the happy path.
- **Uncovered cases**: An if-then-else-if chain or case statement with no final `else`/`default`, silently dropping inputs that match no branch.
- **Implicit fall-through**: A `switch` case with no `break` and no comment — indistinguishable from a forgotten `break`, a source of latent defects.
- **Testing phony variables**: Using a dummy variable constructed solely to exploit a `case` statement, rather than using the natural controlling variable.
- **Complex inline tests**: Embedding a multi-condition boolean test directly in an `if` rather than extracting it into a named boolean function, obscuring intent.

## Key Takeaways
1. For simple if-else statements, put the nominal case first so the normal execution path reads straight down the `if` branches.
2. For if-then-else-if chains, test the most common cases first and ensure all cases are covered with a final `else`.
3. For case statements, order cases meaningfully, keep each case's action simple, and always use `default` to catch unexpected values.
4. Encapsulate complex boolean tests in well-named functions — a function name that describes the test is better documentation than an inline comment.
5. Avoid fall-through in case statements; when intentional, mark it explicitly with a comment.

## Connects To
- **Ch14**: The nominal-path-first rule is an application of the Principle of Proximity — the normal flow should be readable without jumping over error branches.
- **Ch16**: Loop entry and exit conditions use the same clarity principles as conditionals.
- **Ch18**: Decision tables can replace complicated if-then-else-if chains entirely.
- **Ch19**: Boolean expression clarity (Section 19.1) and deep nesting reduction (Section 19.4) directly govern how conditionals should be written.
