# Chapter 16: Refactoring SerialDate

## Core Idea
A complete live refactoring of a real open-source class (JFreeChart's `SerialDate`) demonstrates that even competent, published code benefits from systematic critique — and that the professional obligation is not to accept "good enough" but to leave every module cleaner than you found it.

## Frameworks Introduced
- **First Make It Work**: Before refactoring, run existing tests, measure coverage, write missing tests (including tests for behavior you believe the class *should* have but doesn't yet), and get every test green — including the ones that expose latent bugs.
  - When to use: Any time you inherit code you intend to change. Never refactor against a partial or absent test suite; you won't know what you've broken.
- **Then Make It Right**: Only after all tests pass do you restructure — working top-to-bottom through the file, applying named smells from Ch17, running the full test suite after every single change.
  - When to use: Immediately after the "Make It Work" phase. The two phases are sequential and non-overlapping by design.

## Key Concepts
- **Coverage as precondition**: Clover showed 50% line coverage on the original `SerialDate`; Martin wrote an independent test suite reaching 92% before touching a single production line — coverage is the safety net, not an afterthought.
- **Abstract class naming at the right abstraction level**: `SerialDate` names an implementation detail (serial-number encoding); the correct name for an abstract class is `DayDate` — names must reflect intent, not mechanism [N2].
- **int-constants replaced by enums**: Month, Day, WeekInMonth, and DateInterval were encoded as `int` constants mixed into the class; extracting them to proper Java enums eliminates invalid-value bugs, enables compiler checking, and makes `toString()` and iteration free [G26].
- **Abstract Factory over createInstance**: Static `createInstance` methods on an abstract class hard-code the concrete implementation; a `DayDateFactory` (Abstract Factory + Singleton + Decorator) decouples construction from the abstraction.
- **Explaining temporary variables**: Intermediate variables named for what they mean (`offsetToFutureTarget`, `offsetToPreviousTarget`) replace opaque arithmetic, making an algorithm self-documenting without comments [G19].
- **Feature Envy corrected to instance methods**: Methods that take a `DayDate` argument when they could be called on `this` are wrong-level; converting them to instance methods removes the envy and the redundant argument [G14, G18].
- **Boy Scout Rule**: Check code in a bit cleaner than you checked it out — the goal is incremental professional improvement, not perfection in one pass.

## Mental Models
1. **Two-phase discipline (Work / Right)**: Separating correctness from cleanliness prevents the refactoring from introducing regressions you can't detect. Never do both at once.
2. **Named smell references as audit trail**: Every change is tagged inline with a heuristic code (N1, G5, T2, C1, J1…) from Ch17. This makes the rationale explicit and teaches the reader to see the same smells in their own code.
3. **Delete what only tests use**: A utility method that exists solely to satisfy test assertions is not serving the production domain — delete the method and rewrite the tests to use the underlying language (enum names, standard exceptions). Elegant refactoring chains can end in the trash can if that's the honest outcome.
4. **Professional critique is not arrogance**: Medicine, aviation, and law all build peer review into professional practice. Programmers must too. Critiquing published code is how the discipline improves — the author's courage in publishing deserves reciprocal honesty, not politeness-silence.

## Anti-patterns
- **Refactoring without a test suite**: You cannot know what you've broken. The original `SerialDate` had a latent algorithm bug in `getNearestDayOfWeek` (`adjust` was always negative, making one branch unreachable) that only emerged when coverage was measured — it would have survived a careless refactor.
- **Names that leak implementation into abstractions**: `SerialDate` tells callers how dates are stored; abstract types must name the concept they model, not how a concrete subclass implements it.
- **int constants as type stand-ins**: Using `int` for month, day-of-week, and interval conflates unrelated domains into a single type, allows nonsense values at compile time, and forces switch/if chains that enums eliminate.
- **Change-history comments in source**: Version control systems own change history. Inline changelog comments are stale the moment the next commit lands; delete them [C1].
- **Mixed-language Javadoc**: A comment block containing Java, English, Javadoc markup, and raw HTML is four languages in one place — none of them properly maintainable [G1].

## Key Takeaways
1. Test coverage is a precondition for safe refactoring, not a metric to optimize afterward — write the tests you wish existed before you change anything.
2. Every refactoring move should be atomic and followed immediately by a full test run; small safe steps are how you refactor a 185-statement class without introducing regressions.
3. Smells and heuristics from Ch17 are not abstract rules — they are a named vocabulary for the decisions you will make line-by-line on every real class you touch.
4. Renaming an abstract class away from its implementation detail (`SerialDate` → `DayDate`) is one of the highest-leverage single changes in a refactoring: it corrects the mental model for every future reader.
5. The Boy Scout Rule is a professional obligation, not an aspiration — leave the code measurably better (more tests, fewer smells, smaller footprint) every time you touch it.

## Connects To
- **Ch17**: The smells catalog (N1–N5, G1–G34, T1–T9, J1–J2, C1–C5) is the concrete vocabulary applied throughout this entire chapter — Ch16 is Ch17 in action.
- **Ch9 (Unit Tests)**: The "First Make It Work" phase is an application of Ch9's F.I.R.S.T. principles — independent, repeatable tests written before (not after) the production change.
- **Ch2 (Names)**: `SerialDate` → `DayDate`, `createInstance` → `makeDate`, `addDays` → `plusDays` — every rename in this chapter is a direct application of Ch2 rules about intention-revealing, abstraction-level-appropriate names.
- **Ch10 (Classes)**: Extracting enums from `MonthConstants`, splitting construction into `DayDateFactory`, converting static methods to instance methods — all reflect Ch10's single-responsibility and cohesion guidance applied to an inherited design.
