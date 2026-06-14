# Chapter 24: Refactoring

## Core Idea
The Cardinal Rule of Software Evolution is that internal quality should improve with each change; refactoring — changing a program's internal structure without changing its observable behavior — is the primary technique for keeping that rule, and recognizing "smells" is the key to knowing when to apply it.

## Frameworks Introduced
- **Cardinal Rule of Software Evolution**: Internal quality must improve (or at minimum not degrade) as software evolves under maintenance and enhancement.
  - When to use: Every time code is touched — during bug fixes, feature additions, or pure cleanup.
  - How: Before committing any change, ask whether the internal structure is better or worse than before; if worse, refactor until it is at least neutral.

- **Refactoring Catalog** (Fowler 1999, summarized): A named inventory of specific source-to-source transformations that improve structure without changing behavior. McConnell presents the most practically useful subset grouped by scope.
  - Data-level: Replace magic number with named constant; rename variable; introduce intermediate variable; convert multiuse variable to single-use variables; convert data primitive to a class.
  - Statement-level: Decompose a boolean expression; move a complex expression into a well-named boolean function; consolidate duplicated fragments.
  - Routine-level: Extract a routine; inline a routine; add or remove a parameter; convert a long routine into a class.
  - Class-level: Extract a subclass or superclass; encapsulate an exposed member variable; remove a middle-man class; collapse a class hierarchy when subclass adds no value.
  - System-level: Move a routine to a more appropriate class; convert one-directional class association to bidirectional (or vice versa); introduce a factory method to replace a constructor.

- **Code Smells** (warning signs that refactoring is needed): Named patterns of code degradation identified by Fowler (1999) that signal structural debt.
  - When to use: As a diagnostic lens whenever reading or modifying existing code.
  - How: Recognize the smell, identify the appropriate refactoring from the catalog, apply it in isolation.

## Key Concepts
- **Refactoring** (Fowler's definition): "A change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior."
- **Software entropy**: The tendency of software to degrade in internal quality over time as changes accumulate without structural discipline; refactoring reverses entropy.
- **Code smell**: A surface indicator — duplicated code, long routines, poor cohesion, large parameter lists — that suggests a deeper structural problem requiring refactoring.
- **DRY principle** (Don't Repeat Yourself, Hunt and Thomas): Duplicated code is a design error; "copy and paste is a design error" (Parnas via McConnell).
- **Refactoring vs. rewriting**: Refactoring is incremental, behavior-preserving restructuring; rewriting discards and replaces; refactoring is preferred unless the code is so degraded that incremental improvement is not cost-effective.
- **Parking lot**: A list of refactoring ideas that occur mid-refactoring but would expand scope; capture them and defer them to stay focused on one change at a time.
- **Regression test safety net**: Running existing tests after each refactoring step to verify behavior is preserved; without tests, refactoring is high-risk.

## Mental Models
- Think of smells as diagnostic signals, not verdicts — a smell indicates where to look, not necessarily what to change; investigate before acting.
- Use the one-refactoring-at-a-time discipline: each refactoring should be independently testable; compound refactorings create compound risk and make failures hard to attribute.
- Think of refactoring as paying down structural debt incrementally rather than accruing it until a painful rewrite is required.
- When visiting code to fix a bug or add a feature, apply the Boy Scout Rule implicitly: leave the structure at least as clean as you found it.

## Anti-patterns
- **Refactoring as cover for code-and-fix**: Using "refactoring" as a label for simultaneous behavioral changes and structural changes — conflates two distinct activities and makes both harder to verify.
- **Refactoring without tests**: Restructuring code without a regression test suite to verify behavior is preserved; confident refactoring requires test coverage.
- **Big-bang refactoring**: Attempting to restructure large sections of code in one session; increases risk, makes failures hard to diagnose, and often gets abandoned midway.
- **Ignoring smells under schedule pressure**: Deferring all structural improvement because there is no time; the debt compounds and the eventual cost exceeds the savings.

## Key Takeaways
1. The Cardinal Rule of Software Evolution: internal quality must improve with each code change, not degrade.
2. Refactoring is behavior-preserving structural improvement — the moment behavior is intentionally changed, it is no longer refactoring.
3. Recognize smells (duplication, long routines, poor cohesion, large parameter lists, feature envy) as the entry points for applying catalog refactorings.
4. Apply refactorings one at a time, test after each, and maintain a parking lot for ideas that would expand the current refactoring's scope.
5. Without regression tests, refactoring is gambling; building test coverage is a prerequisite for safe structural improvement.
6. Program changes are inevitable; the question is only whether quality improves or degrades with each change.

## Connects To
- **Ch22**: Regression tests are the safety net that makes refactoring safe; developer testing and refactoring are mutually enabling.
- **Ch23**: Debugging often reveals structural problems; the fix is an opportunity to refactor the surrounding code.
- **Ch25–26**: Refactoring and code tuning are inverses — refactoring improves internal structure at potential performance cost; tuning degrades internal structure for performance gain; never conflate them.
