# Chapter 16: Controlling Loops

## Core Idea
Choose the loop type that makes the entry and exit conditions most explicit, initialize loop variables immediately before the loop, keep loop bodies short and focused, and place all exit conditions in one visible location.

## Frameworks Introduced
- **Loop type selection**: Match the loop construct to the situation. When to use a `while` loop: when the number of iterations is unknown and testing at the beginning is correct (most common case). When to use a `do-while` / loop-with-test-at-end: when the loop body must execute at least once. When to use a `for` loop: when the loop counter or iterator is simple and the number of iterations is known or bounded before entry. When to use a `for-each`: when iterating over all elements of a collection without needing an explicit index.
- **loop-with-exit**: A loop structure where the exit condition appears in the middle of the loop body rather than at the top or bottom, implemented with `while(true)` / `break` or language-specific loop-and-a-half constructs. When to use: when testing at either the top or the bottom forces duplication of the loop-setup code (the "loop-and-a-half" problem). How: put all exit tests together in one location inside the loop; comment the intent; avoid using multiple scattered `break` statements as a substitute for clear structure. Research shows this structure scores 25% higher on comprehension tests than top- or bottom-tested loops.
- **Loop housekeeping**: Practices for keeping loop internals clean and correct. How: initialize all loop variables immediately before the loop (not elsewhere in the routine); put loop-initialization code immediately before the loop; avoid using the loop index after the loop terminates; use meaningful index names for all but the simplest loops; limit each loop to one function (entering in the middle via `goto` is forbidden).

## Key Concepts
- **loop-and-a-half**: A loop where the natural exit condition falls in the middle, forcing duplication of setup code when a top- or bottom-tested loop is used instead of a loop-with-exit.
- **loop-with-exit**: A one-entry, one-exit structured control construct where the exit test appears mid-body; the preferred loop structure per Software Productivity Consortium (1989).
- **safety counter**: A secondary counter added to a loop to detect infinite-loop conditions in critical code; triggers an assertion or error when the count exceeds an expected maximum.
- **off-by-one error**: A boundary error where a loop executes one too many or one too few times, typically from incorrect use of `<` vs `<=` or wrong initialization of the loop index.
- **loop index abuse**: Using a `for` loop's index variable after the loop exits, which is undefined or unreliable behavior in many languages and contexts.
- **flexible vs. rigid loop**: A flexible loop (`while`, `do-while`) allows modification of the number of iterations at runtime; a rigid loop (`for-each`, some `for` forms) iterates over a fixed collection.

## Mental Models
- Use the loop type as a contract: `for` says "I know the bounds"; `while` says "I'll check before each iteration"; `do-while` says "execute at least once then check"; loop-with-exit says "the termination condition is complex and lives inside."
- Think of loop initialization as belonging to the loop: variables used only in the loop should be declared and initialized immediately above it, not at the top of the routine.
- Think of a loop body longer than one screen as a decomposition signal: extract it into a well-named routine called from the loop.
- Use the "one exit" heuristic: gather all exit conditions in one place; multiple scattered `break` statements are as hard to follow as multiple `return` statements in a long routine.

## Anti-patterns
- **Entering a loop in the middle via goto**: Using a `goto` to jump into the interior of a loop body to avoid repeating setup code — creates unstructured flow and hides the real entry point.
- **Reading the loop index after exit**: Relying on the value of a `for`-loop index after the loop ends — the value is undefined or implementation-dependent in several languages.
- **Scattered exit conditions**: Multiple `break` or `continue` statements spread throughout a long loop body, making it hard to reason about when and why the loop terminates.
- **Loop initialization far from the loop**: Initializing loop variables at the top of a routine that is much longer than the loop itself, so the initialization and use are separated.
- **Using a `for` loop as a `while` loop**: Stuffing a flexible, condition-based iteration into a `for` construct, bending the syntax and obscuring the intent.

## Key Takeaways
1. Choose the loop type whose syntax matches the intent: `for` for counted iteration, `while` for condition-tested entry, `do-while` for at-least-once, loop-with-exit for mid-body termination.
2. The loop-with-exit structure (while-true/break) is the preferred construct when testing at top or bottom would require duplicating setup code; keep all exit conditions together.
3. Initialize loop variables immediately before the loop, not elsewhere in the routine.
4. Keep loop bodies short — long bodies are a signal to extract a named routine.
5. Never use a loop index variable after the loop exits; never enter a loop in the middle.
6. Add safety counters to critical loops to catch infinite-loop conditions during development.

## Connects To
- **Ch14**: Loop body statements follow the same sequential-dependency and proximity principles as straight-line code.
- **Ch15**: Loop entry/exit conditions are boolean expressions; the same clarity rules from conditionals apply.
- **Ch17**: `break`, `continue`, and `goto` inside loops are the "unusual control structures" that require special care.
- **Ch19**: Deep nesting (Section 19.4) is often caused by nested loops; complexity metrics count loop decision points.
