# Clean Code — Cheatsheet

## Functions at a Glance

| Rule | Guideline |
|---|---|
| Size | < 20 lines; ideally 2–5. Indent max 2 levels. |
| Do one thing | Every step is one abstraction level below the function's name. If you can extract a non-restatement function, it did too much. |
| One abstraction level | Don't mix `getHtml()` (high) with `.append("\n")` (low) in one body. |
| Argument count | 0 > 1 > 2; avoid 3+. Boolean args are always wrong — split into two functions. |
| No side effects | If a function changes state beyond its stated purpose, rename it or restructure. |
| Command-Query Separation | Functions either change state (command) **or** return information (query). Never both. |

## Naming Rules

- **Intention-revealing** — name answers why it exists, what it does, how it is used; if it needs a comment, rename it.
- **No disinformation** — don't name a non-List container `accountList`; avoid `l`/`O` (look like `1`/`0`).
- **Meaningful distinctions** — drop noise words (`Info`, `Data`, `Object`); `ProductData` and `ProductInfo` are the same.
- **Pronounceable** — if you can't say it in a code review, rename it (`generationTimestamp` not `genymdhms`).
- **Searchable** — no bare numeric literals or single-letter variables beyond loop counters in tiny scopes.
- **No encodings** — drop `m_` prefixes and Hungarian notation; IDEs make them redundant.
- **No mental mapping** — don't make readers silently translate `r` → "lowercased URL stripped of host and scheme."
- **One word per concept** — pick `get`, `fetch`, or `retrieve` and use it everywhere; never mix synonyms.

## The Three Laws of TDD

1. You may not write production code until you have written a failing unit test.
2. You may not write more of a unit test than is sufficient to fail (not compiling is failing).
3. You may not write more production code than is sufficient to pass the currently failing test.

## F.I.R.S.T.

| Letter | Property | Consequence if violated |
|---|---|---|
| **F** | Fast | Slow tests don't get run; problems surface late. |
| **I** | Independent | Dependent tests cascade failures and hide root cause. |
| **R** | Repeatable | Environment-coupled tests always have an alibi for failure. |
| **S** | Self-Validating | Boolean pass/fail only — no human log-reading to decide. |
| **T** | Timely | Write tests just before the code they exercise, not after. |

## Kent Beck's Four Rules of Simple Design (priority order)

1. **Runs all the tests** — non-negotiable gate; testability forces better design.
2. **Contains no duplication** — every duplicate is a missed abstraction.
3. **Expresses the intent of the programmer** — names, structure, and tests should be self-documenting.
4. **Minimizes the number of classes and methods** — no gold-plating; eliminate what isn't necessary.

## Comments Decision Rule

**Prefer code over comments.** A well-named function is its own documentation.

| Good comment | Bad comment |
|---|---|
| Legal / copyright header | Redundant restatement of what code already says |
| Explanation of intent or consequence not visible in code | Obsolete or stale (misleads readers) |
| Warning of non-obvious consequence | Commented-out dead code (delete it; VCS has history) |
| TODO (time-boxed, owned) | Change history or author metadata (belongs in VCS) |

## SOLID-ish Principles

- **SRP** — A class has one, and only one, reason to change. If you describe it using "and," split it.
- **OCP** — Open for extension, closed for modification. New behavior arrives via subclassing/composition, not by reopening existing code.
- **DIP** — Depend on abstractions, not concretions. Introduce an interface wherever a class touches a volatile external dependency.

## Smell Categories Quick Map (Ch. 17)

| Prefix | Category | Covers |
|---|---|---|
| **C** | Comments | Inappropriate info, obsolete, redundant, poorly written, commented-out code |
| **E** | Environment | Build or test suite requires more than one step to run |
| **F** | Functions | Too many args, output args, flag args, dead functions |
| **G** | General | Duplication, wrong abstraction levels, dead code, feature envy, magic numbers, and ~30 more cross-cutting heuristics |
| **J** | Java | Wildcard imports, constants-as-interfaces, enums over int constants |
| **N** | Names | Non-descriptive, wrong-scope length, encodings, unambiguous names |
| **T** | Tests | Insufficient coverage, trivial/skipped tests, slow tests, irrelevant assertions |

## Pre-Commit Checklist

- [ ] Does every function do exactly one thing at one level of abstraction?
- [ ] Do all names reveal intent without requiring a comment to explain them?
- [ ] Is there any duplication I can extract into a named abstraction?
- [ ] Does every test pass, and is there a test for each boundary condition I touched?
- [ ] Are there any side effects or command-query violations I introduced?
- [ ] Did I leave commented-out code, dead functions, or stale comments behind?
- [ ] Does the code express its intent so clearly a stranger could read it top-down?
- [ ] Is every class / module changed for exactly one reason (SRP)?
