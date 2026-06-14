# Chapter 15: JUnit Internals

## Core Idea
Even excellent code written by expert authors (Kent Beck, Eric Gamma) can be improved. The Boy Scout Rule—leave the code a little cleaner than you found it—applies universally; no module is immune from improvement.

## Frameworks Introduced
- **The Boy Scout Rule (applied)**: Walk through real, expert-quality production code and improve it incrementally, commit by commit.
  - When to use: Any time you touch a module, even if the existing code is already good—improvement is a professional responsibility, not a criticism of the original author.
- **Iterative refactoring with reversals**: Refactoring is not a straight line. One improvement may reveal that an earlier decision was wrong; inlining an extraction or flipping a conditional sense partway through is normal and expected.
  - When to use: When a second pass over refactored code suggests a prior step should be undone—follow the evidence, not sunk cost.

## Key Concepts
- **N6 — Encoded scope in names**: Prefixes like `f` on member variables (e.g., `fExpected`) are a legacy habit; modern IDEs make scope encoding redundant and it adds noise without information.
- **G28 — Unencapsulated conditional**: A bare boolean expression at a branch site should be extracted into a named method so the intent is readable at the call site.
- **G29 — Negative conditionals**: `shouldNotCompact()` forces the reader to mentally negate; prefer the positive form `canBeCompacted()` and invert the branch.
- **G31 — Hidden temporal coupling**: When function B silently depends on function A having been called first (e.g., `findCommonSuffix` requires `findCommonPrefix` to have populated `prefixIndex`), that dependency is a latent bug waiting for a future caller. Make the coupling explicit—either pass the result as an argument, or merge into a single `findCommonPrefixAndSuffix()` that enforces the order internally.
- **N1 — Inaccurate variable names**: Names like `suffixIndex` that are actually 1-based lengths mislead every reader; the off-by-one errors that follow (`+1` everywhere in the arithmetic) are a direct symptom.
- **N4 — Ambiguous local vs. member names**: When a local variable shadows a member of the same name but represents something different (e.g., `expected` the compacted form vs. `expected` the field), the confusion compounds silently. Rename one: `compactExpected`.
- **G11 — Inconsistent conventions**: If two functions in a group return values but two others mutate state instead, callers cannot form a reliable mental model. Pick one style for the family.
- **G30 — Function does more than its name says**: A function named `compact` that also formats and guards against a null early-exit violates the single-responsibility principle for naming. Rename to what it actually does: `formatCompactedComparison`.

## Mental Models

**Name = contract**: Every method and variable name is a promise about what it contains and what it does. When the promise is slightly wrong—a "length" stored as an index, a "compactor" that formats—every reader pays an ongoing cognitive tax. The fix is always cheap; the deferral is never free.

**Positive framing**: Negated boolean names (`shouldNotCompact`, `notEqual`) require double negation in the surrounding logic. Prefer the positive capability form and rearrange the branch: `if (canBeCompacted()) { ... } else { return unmodified; }`.

**Make dependencies visible**: Hidden temporal coupling is worse than explicit coupling. If function order matters, encode that order in the structure—merge, pass results as arguments, or rename to `findPrefixThenSuffix`—so the constraint is impossible to miss.

**Refactoring is a conversation, not a transaction**: Partial refactoring often exposes that an earlier step was wrong. Plan to reverse; the final clean state is what matters, not preserving the path taken to reach it.

## Anti-patterns
- **Scope-encoding prefixes (`fExpected`, `m_count`)**: Redundant with IDE navigation; clutters every read without adding correctness. Eliminate them.
- **Raw conditional expressions at branch sites**: `if (expected == null || actual == null || areStringsEqual())` tells the reader *what* but not *why*. Extract and name it.
- **Returning some values while mutating others in the same function family**: Mixed conventions force callers to read each function individually rather than reasoning by analogy.
- **Off-by-one arithmetic as a symptom**: If a region of code is riddled with `+1` and `-1` adjustments, the root cause is usually a badly-named variable (an index masquerading as a length, or vice versa). Fix the name and the arithmetic simplifies.

## Key Takeaways
1. Well-written code by acknowledged experts is still improvable; critique is not disrespect—it is the discipline that makes the craft collective.
2. Remove `f`-prefixes and similar encoding artifacts; trust the IDE and the type system.
3. Always prefer positive conditional names; negative forms multiply cognitive load across every call site.
4. Temporal coupling between functions must be made structural—pass the dependency explicitly or merge the functions.
5. When a name no longer describes what a function does after refactoring, rename immediately; stale names are the fastest path to confusion.
6. Refactoring is iterative: revisit earlier decisions, reverse them if needed, and converge on the simplest form.

## Connects To
- **Ch 2 (Meaningful Names)**: Every renaming in this chapter (N1, N4, N6, N7) is a direct application of the naming rules—accuracy, unambiguity, no encoding, positive framing.
- **Ch 3 (Functions)**: G30 (function does more than name claims) and G11 (inconsistent return conventions) are function-design principles made concrete in real production code.
- **Ch 17 (Smells and Heuristics)**: The refactoring decisions here each correspond to a numbered smell (G28, G29, G31, N1, N4, N6, N7); the chapter is the reference, this one is the worked example.
