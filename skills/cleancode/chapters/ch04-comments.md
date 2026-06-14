# Chapter 4: Comments

## Core Idea
Comments are, at best, a necessary evil — they compensate for our failure to express intent in code. Every comment is a failure of expression; the energy spent writing comments should go toward making the code clear enough not to need them.

## Frameworks Introduced

### Good Comments
- **Legal Comments**: Copyright and authorship statements required by corporate standards.
  - When to use: Start of each source file when legally mandated; reference a standard license rather than embedding full terms.
- **Informative Comments**: Explain what a return value or regex represents when the code alone is ambiguous.
  - When to use: When renaming the method or object is impractical (e.g., a `SimpleDateFormat` pattern showing the expected format string).
- **Explanation of Intent**: Documents the programmer's decision or rationale behind a choice, not just what the code does.
  - When to use: Non-obvious tradeoffs, contest-winning tie-breakers in comparisons, workarounds — where the "why" would otherwise be invisible.
- **Clarification**: Translates an obscure argument or return value into readable form when you cannot change the source.
  - When to use: Standard library calls or third-party APIs with opaque arguments (e.g., `assertTrue(a.compareTo(b) == -1); // a < b`). Carry high risk of inaccuracy — verify carefully.
- **Warning of Consequences**: Flags side effects or conditions other programmers must know before calling something.
  - When to use: A test that takes very long, a non-thread-safe object, irreversible actions.
- **TODO Comments**: `//TODO` notes for known deferred work.
  - When to use: When the programmer intends to act but genuinely cannot now. Not an excuse to leave bad code. Scan and eliminate regularly.
- **Amplification**: Calls out something that looks trivial but is actually critical.
  - When to use: When a `.trim()`, cast, or subtle op is load-bearing and a reader might innocently remove it.
- **Javadocs in Public APIs**: Generated documentation for public-facing library APIs.
  - When to use: Writing a public API that others will consume. Subject to all the lying-comment risks if not maintained.

### Bad Comments
- **Mumbling**: Writing a comment because you feel you should, without thinking it through — leaving the reader more confused than before.
- **Redundant Comments**: Comments that restate exactly what the code already says, more slowly and with no additional value (e.g., `// Returns the day of the month` over `getDayOfMonth()`).
- **Misleading Comments**: Technically inaccurate descriptions that mislead callers about behavior — e.g., "returns when closed" when the code actually polls with a timeout and throws.
- **Mandated Comments**: Policy-enforced comments on every function or variable, producing abomination Javadocs that add nothing and propagate lies.
- **Journal Comments**: Changelog entries in source files, now entirely superseded by source control.
- **Noise Comments**: Restating the obvious; the programmer venting frustration. Trains readers to ignore all comments.
- **Scary Noise**: Copy-paste Javadoc noise on fields — broken by distraction, wrong names silently carried over.
- **Position Markers**: Banner lines like `// Actions ///////////` to section a file. Occasionally valid; overused, they become invisible noise.
- **Closing Brace Comments**: `} //while`, `} //catch` — signals a function too long and nested to read without crutches. Fix: shorten the function.
- **Attributions and Bylines**: `// Added by Jim` — source control does this better and permanently.
- **Commented-Out Code**: Dead code left behind "just in case." Others fear to delete it; it rots. Source control is the safety net — delete it.
- **HTML Comments**: HTML markup in source comments intended for Javadoc tooling makes the comment unreadable in the editor where it matters.
- **Nonlocal Information**: A comment that describes system-level behavior (e.g., a default port) placed next to a function that has no control over it. Guaranteed to go stale.
- **Too Much Information**: RFC numbers, historical RFC debates, protocol internals dumped inline — irrelevant to the reader's actual question.
- **Inobvious Connection**: A comment that requires its own explanation to understand — e.g., a buffer formula where the relationship between comment terms and code terms is unclear.
- **Function Headers**: Short, single-purpose functions don't need a header comment; a good name beats a description every time.

## Key Concepts
- **Comment decay**: Comments drift from the code they describe as code evolves; the older and more distant the comment, the less trustworthy it is.
- **Expression failure**: Writing a comment is an admission that the code does not express its own intent — the correct response is to fix the code, not decorate it.
- **Source control as memory**: Attribution, changelogs, and "safety net" dead code all belong in version history, not in source files.

## Mental Models

1. **Grimace when you comment**: Every comment should prompt a moment of discomfort — "Have I failed to express this in code?" If yes, exhaust code-level options first.
2. **Comments lie, code does not**: Code is the only ground truth about what a system does; comments are documentation of intent that may already be wrong. Weight them accordingly.
3. **If the comment needs explanation, the comment failed**: A comment must connect transparently to the code it annotates. If you must decode the comment itself, it has added complexity rather than removing it.
4. **Noise trains readers to skip**: Every redundant or trivial comment desensitizes readers to all comments. The more noise in a file, the less the important comments will be noticed.

## Anti-patterns
- **Mumbling**: Uninvestigated, thrown-in comments leave intent ambiguous and force readers to cross-reference other files to understand what was meant.
- **Redundant Javadoc**: `@param title The title of the CD` on a method that already says `addCD(String title, ...)` adds zero information, doubles the reading surface, and will lie after the first refactor.
- **Commented-Out Code**: Survives indefinitely because no one knows if it's safe to delete; every line asks the reader to reason about history they don't have access to.
- **Nonlocal Information**: A comment about a default port next to a setter that doesn't control the default will not be updated when the default changes — silent misinformation.
- **Closing Brace Comments**: The presence of `} //while` is a code smell diagnostic, not a fix — it indicates the function is too complex.

## Code Examples

```java
// Before: comment compensating for unexpressive code
// does the module from the global list <mod> depend on the
// subsystem we are part of?
if (smodule.getDependSubsystems().contains(subSysMod.getSubSystem()))

// After: comment eliminated by introducing named variables
ArrayList moduleDependees = smodule.getDependSubsystems();
String ourSubSystem = subSysMod.getSubSystem();
if (moduleDependees.contains(ourSubSystem))
```
- **What it demonstrates**: Extracting a condition's intent into named variables removes the need for the comment entirely.

## Key Takeaways
1. The standard for a good comment is high: it must say something the code cannot say and must remain accurate as the code evolves.
2. Most comments written in practice fail that standard — they are noise, redundancy, apology, or history that belongs in version control.
3. Before writing any comment, exhaust code-level alternatives: rename, extract a function, introduce an explaining variable.
4. Commented-out code is a liability, not a backup — delete it and trust source control.
5. A well-named short function beats a comment header unconditionally; invest in naming, not annotation.

## Connects To
- **Ch 2 (Meaningful Names)**: Most "informative" and "clarifying" comments exist because names were not chosen well enough — better names eliminate them.
- **Ch 3 (Functions)**: Closing-brace comments and function-header comments both signal functions that violate single-responsibility and length guidelines from Chapter 3.
- **Ch 17 (Smells and Heuristics)**: Several comment smells (obsolete, redundant, poorly written, commented-out code) appear directly in the heuristics catalog.
