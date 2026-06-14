# Chapter 3: Functions

## Core Idea
Functions are the first line of organization in any program; the craft of writing them well is the craft of making them small, focused, and honest about what they do. Every rule in this chapter serves a single goal: functions should read like well-named paragraphs in a top-down narrative.

## Frameworks Introduced

- **Small!**: Functions should be very small — hardly ever more than 20 lines, ideally 2–5. Blocks inside `if`, `else`, and `while` should be one line long (a function call with a descriptive name). Indentation should not exceed two levels.
  - When to use: always; this is the overriding constraint that makes all other rules tractable.
  - How: if you can extract a sub-function with a name that is not merely a restatement of the code, the original function was doing more than one thing.

- **Do One Thing**: FUNCTIONS SHOULD DO ONE THING. THEY SHOULD DO IT WELL. THEY SHOULD DO IT ONLY. A function does one thing if every step inside it is exactly one level of abstraction below the function's stated name. The practical test: if you can extract another function with a non-restatement name, the original was doing more than one thing.
  - When to use: as the primary design constraint during extraction.
  - How: describe the function as a TO paragraph — "TO RenderPageWithSetupsAndTeardowns, we check whether the page is a test page and if so include setups and teardowns."

- **One Level of Abstraction per Function**: Every statement in a function must sit at the same level of abstraction. Mixing `getHtml()` (high), `PathParser.render(pagePath)` (intermediate), and `.append("\n")` (low) in one body is always confusing and invites further accretion of detail.
  - When to use: when reviewing a function for coherence.
  - How: scan each statement; if some are essential concepts and others are implementation minutiae, split.

- **The Stepdown Rule**: Code should read like a top-down narrative. Each function is followed by the functions at the next level of abstraction so the reader descends naturally. The program reads as a set of TO paragraphs, each referencing the next level down.
  - When to use: when ordering functions in a file or module.
  - How: put public/high-level functions first; each calls helpers that appear immediately below.

- **Use Descriptive Names**: A long descriptive name is better than a short enigmatic one, and better than a long descriptive comment. Don't be afraid to spend time choosing a name. Be consistent — use the same phrases, nouns, and verbs across function names in a module (`includeSetupPage`, `includeTeardownPage`, not a mix of styles).
  - When to use: every function, without exception.
  - How: the name should state exactly what the function does at its level of abstraction; if you can't, the function is probably doing too much.

- **Flag Arguments**: Passing a boolean into a function is a truly terrible practice. It loudly proclaims the function does two things — one when true, another when false. Split into two functions.
  - When to use: whenever you see `render(true)` or any boolean parameter at a call site.
  - How: `renderForSuite()` and `renderForSingleTest()` instead of `render(boolean isSuite)`.

- **Argument Objects**: When a function takes 2–3 arguments that naturally cluster, wrap them in a named object. `makeCircle(double x, double y, double radius)` becomes `makeCircle(Point center, double radius)` — the grouping itself names a concept.
  - When to use: when two or more arguments always travel together.
  - How: extract a class or record that captures the cohesion.

- **Verbs and Keywords**: For monadic functions use verb/noun pairs: `write(name)`, `writeField(name)`. For dyadic functions, encode the argument order in the name: `assertExpectedEqualsActual(expected, actual)` eliminates the ordering confusion of `assertEquals`.
  - When to use: naming any function that takes arguments.
  - How: the function name should describe both the verb and the argument's role.

- **Have No Side Effects**: A function that promises to do one thing but secretly changes other state (password buffer, system globals, class state unrelated to its declared purpose) is lying. Side effects create temporal coupling and order dependencies that are invisible from the call site.
  - When to use: auditing any function that touches state beyond its return value.
  - How: if a function must change state, name it so it admits it — or restructure so the side effect is the declared purpose.

- **Output Arguments**: Arguments are read as inputs; output arguments cause a double-take and a mandatory signature lookup. In OO code, `report.appendFooter()` is always cleaner than `appendFooter(report)`. If your function must change something, have it change the state of its owning object.
  - When to use: whenever you see a void function whose argument gets mutated.
  - How: make the output argument `this` by promoting the function to a method on the relevant class.

- **Command Query Separation**: Functions should either change state (commands) or return information (queries), never both. `if (set("username", "unclebob"))` conflates verb and adjective, leaving the reader unable to tell whether `set` is testing or performing. Separate: `if (attributeExists("username")) { setAttribute("username", "unclebob"); }`.
  - When to use: any function that returns a value AND mutates state.
  - How: split into a predicate and a void mutator.

- **Prefer Exceptions to Returning Error Codes**: Returning error codes from command functions forces callers to deal with errors immediately, producing deeply nested if-trees. Exceptions let the happy path stay uncluttered and error handling live in a dedicated catch block.
  - When to use: any command function that can fail.
  - How: throw typed exceptions; let the caller catch at the appropriate level.

- **Extract Try/Catch Blocks**: The body of a try block and the bodies of its catch/finally blocks should each be one function call. Error handling is one thing; a function that handles errors should do nothing else. If `try` exists in a function, it should be the very first word, and nothing should follow the catch/finally.
  - When to use: any time try/catch is mixed with business logic.
  - How: extract the try body into `tryDeletePage()`, the catch body into `logDeletionError()`.

- **DRY — Don't Repeat Yourself**: Duplication is the root of most software evil. Every time you see the same block of logic appearing in multiple functions, it is a target for extraction. Structured programming, OOP, AOP, and component frameworks are all, at their core, strategies for eliminating duplication.
  - When to use: whenever you see copy-pasted logic.
  - How: name the extracted function after the concept, not the implementation.

- **Structured Programming**: Dijkstra's single-entry/single-exit rule (one `return`, no `break`/`continue`, never `goto`) provides real benefit only in large functions. When functions are small, multiple returns, breaks, and continues are harmless and often more expressive. `goto` has no place in small functions.
  - When to use: as a guideline for large functions only; relax freely in small ones.

## Key Concepts

- **Niladic / Monadic / Dyadic / Triadic**: The four argument-count tiers. Niladic (0 args) is ideal; monadic (1) is fine; dyadic (2) carries cost; triadic (3) should be avoided; polyadic (3+) requires exceptional justification.
- **TO paragraph**: A mental model borrowed from LOGO's `TO` keyword — read each function as "TO do X, we do A, then B, then C." If the steps are all one level below X, the function does one thing.
- **Temporal coupling**: Hidden ordering dependency created when a function has side effects that only make sense if called in a specific sequence.

## Mental Models

1. **The extraction test**: Can you give an extracted sub-function a name that is not a mere restatement of the code? If yes, extract. If the only name is a restatement, you've hit the bottom of the abstraction level.
2. **The TO paragraph**: Before writing a function, write its TO sentence. Every line of the body should be exactly one level below that sentence — no higher, no lower.
3. **The newspaper metaphor** (echoed here from Ch. 2): Functions in a file read top to bottom, high to low abstraction, like a newspaper article — headline first, detail last.
4. **Argument count as complexity signal**: Each additional argument multiplies test-case combinations and cognitive load. Zero args = trivial to test; three args = combinatorial explosion.

## Anti-patterns

- **Flag arguments** (`render(true)`): announces the function does two things; split unconditionally.
- **Output arguments** (`appendFooter(s)`): forces a signature lookup; convert to method on owning object.
- **Mixed abstraction levels**: `getHtml()` next to `.append("\n")` in the same body; detail accretes around the lowest-level statement.
- **Error codes as return values**: produces nested if-trees; forces immediate error handling at every call site; creates a dependency magnet (the `Error.java` enum that every caller must import and recompile when changed).
- **Switch without polymorphism**: switch statements by nature do N things; bury them in a factory behind an abstract interface, never let them propagate.

## Code Examples

```java
// Before: error code return, nested handling
if (deletePage(page) == E_OK) {
    if (registry.deleteReference(page.name) == E_OK) {
        if (configKeys.deleteKey(page.name.makeKey()) == E_OK) {
            logger.log("page deleted");
        } else { logger.log("configKey not deleted"); }
    } else { logger.log("deleteReference from registry failed"); }
} else { logger.log("delete failed"); return E_ERROR; }

// After: exceptions, extracted try/catch, happy path readable
try {
    deletePage(page);
    registry.deleteReference(page.name);
    configKeys.deleteKey(page.name.makeKey());
} catch (Exception e) {
    logger.log(e.getMessage());
}
```

- **What it demonstrates**: Exceptions separate the happy path from error handling, eliminate nesting, and let each command function stay a command.

## Key Takeaways

1. The first rule of functions is that they should be small; the second rule is that they should be smaller than that — hardly ever 20 lines, ideally 2–5.
2. The ideal argument count is zero; each additional argument extracts a cognitive tax and multiplies test combinations.
3. "Do one thing" is operationalized by the TO paragraph and the extraction test — not by intuition.
4. Functions should either change state or return information, never both (Command Query Separation).
5. Prefer exceptions to error codes; extract try/catch bodies into their own functions; treat error handling as one thing.
6. DRY is not a style preference — duplication is the root cause of nearly every maintenance problem.
7. You don't write clean functions first; you write rough drafts and refactor until they meet these rules, backed by tests that prove behavior is preserved.

## Connects To

- **Ch 2 (Meaningful Names)**: Every rule here assumes functions have descriptive names; the Stepdown Rule and Verbs-and-Keywords pattern depend directly on naming discipline.
- **Ch 4 (Comments)**: Well-named small functions eliminate most of the reasons to write comments; a function named `includeSetupsAndTeardownsIfTestPage` is its own documentation.
- **Ch 7 (Error Handling)**: Prefer Exceptions and Extract Try/Catch are expanded into a full treatment of error-handling strategy.
- **Ch 10 (Classes)**: The Single Responsibility Principle for functions scales up directly to classes; Do One Thing at function level is the micro-level expression of SRP.
