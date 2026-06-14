# Chapter 2: Test Driving Shameless Green

## Core Idea
Use the Red/Green/Refactor cycle to incrementally build tests and drive toward Shameless Green — code that is maximally understandable and cheap to write, tolerating duplication when premature abstraction would obscure the domain. Get to green quickly; refactor only once you have all the information.

## Frameworks Introduced
- **Red/Green/Refactor (TDD Mantra)**: Write a failing test (red), write the minimum code to pass it (green), then refactor while keeping tests green. Kent Beck calls this "the TDD mantra" from *Test-Driven Development by Example*.
  - When to use: Every cycle of code production; do not skip steps even when the "right" implementation seems obvious.
  - How: (1) Write failing test, (2) write simplest code to pass, (3) refactor only after green.

- **Green Bar Patterns** (Kent Beck, TDD by Example Ch. 28): Three strategies for making a test pass.
  - **Fake It ('Til You Make It)**: Return a hard-coded value that passes the current test; correct progressively as tests accumulate.
  - **Obvious Implementation**: Jump directly to the final solution when you are *absolutely certain* it is correct. Use sparingly — overconfidence causes downstream pain.
  - **Triangulate**: Write several tests at once (multiple broken tests simultaneously) to force convergence on the correct abstraction in the code.

- **Horizontal vs. Vertical Path**: Complete all verse variants before DRYing anything (horizontal = breadth of examples; vertical = premature abstraction tangent).
  - When to use: Whenever the next piece of information is one test away — stay horizontal until all distinct examples are captured.
  - How: Write tests in the order cases appear; defer DRY refactors until every variant exists as a concrete example.

## Key Concepts
- **Shameless Green**: A solution optimized for maximum understandability and cheapness to write; unconcerned with changeability; tolerates duplication when abstraction is not yet fully visible.
- **Quick Green Excuses All Sins**: Kent Beck's principle — reaching green fast is the primary goal; it provides the safety and information needed for all subsequent decisions.
- **Setup/Do/Verify**: The three-part structure of every test — (1) create the environment, (2) perform the action, (3) assert the result.
- **Test-to-Code Coupling**: The flaw where tests assert implementation details rather than behavior, causing tests to break on refactors that don't change behavior.
- **Echo-Chamber Test**: An anti-pattern where a test asserts `method_a returns same as method_b` instead of asserting against expected concrete output — couples tests to implementation internals.
- **Intention vs. Implementation**: Kent Beck (*Implementation Patterns* p.69) — `song` is the intention (what you want), `verses(99, 0)` is the implementation (how it's done); expose intention in the public API.
- **DRY in Tests vs. Code**: DRY is a strong principle in production code but actively harmful in tests — adding logic to tests mirrors production logic and binds tests to implementation.
- **Tolerating Duplication**: Deliberately keeping duplicate code when you have too few examples to confidently identify the correct abstraction; waiting for more tests to reveal the right concept.
- **Intention-Revealing Code**: Code whose names and structure communicate *what* it does without requiring readers to parse implementation details; accumulated from small, thoughtful decisions.
- **Single Responsibility of `verses`**: The `verses` method is responsible for knowing how to produce a *range* of verses by delegating per-verse content to `verse`; it must not duplicate verse templates.

## Mental Models
- Use `case` over `if/elsif` when all branches check the same variable for equality — `case` signals to readers that conditions are fundamentally the same; `if/elsif` signals they may vary in kind.
- Think of premature abstraction as compressing ignorance into a small space — short code is not the same as abstract code; `'s' unless (number-1) == 1` is shorter but obscures the "bottles" concept.
- When considering a DRY extraction mid-test-cycle, ask: Does this change make the code harder to understand? What is the future cost of doing nothing? How soon will I have more information?
- Think of the `_` (underscore) argument name as a Ruby convention for "unused at this moment" — it signals explicitly that the argument is acknowledged but intentionally ignored for now.

## Anti-patterns
- **Premature DRY (Allergic to Duplication)**: Extracting an abstraction (`pluralize`) before enough examples exist to know whether the abstraction is correct — hides the real domain concept (e.g., "bottle/bottles" as a singular concept) behind a false abstraction.
- **Echo-Chamber Test**: `assert_equal bottles.verses(99, 0), bottles.song` — passes even when `song` is completely broken, and breaks whenever `verses`' signature changes even if `song` is correct.
- **Interpolated Conditional (in verse string)**: `"#{number-1} bottle#{'s' unless (number-1) == 1}"` — achieves shorter code by embedding unnamed logic, but obscures that "bottle/bottles" is a domain concept that needs naming, not inlining.
- **Verses Literal Duplication**: Implementing `verses` by hard-coding verse lyrics rather than delegating to `verse` — usurps `verse`'s responsibility and masks the true job of `verses`.
- **Obvious Implementation Overconfidence**: Skipping Fake It steps because the solution "seems obvious" — risks missing incremental corrections TDD would have provided; save Obvious Implementation for very small leaps.

## Code Examples
```ruby
class Bottles
  def song
    verses(99, 0)
  end

  def verses(upper, lower)
    upper.downto(lower).collect { |i| verse(i) }.join("\n")
  end

  def verse(number)
    case number
    when 0
      "No more bottles of milk on the wall, " +
      "no more bottles of milk.\n" +
      "Go to the store and buy some more, " +
      "99 bottles of milk on the wall.\n"
    when 1
      "1 bottle of milk on the wall, " +
      "1 bottle of milk.\n" +
      "Take it down and pass it around, " +
      "no more bottles of milk on the wall.\n"
    when 2
      "2 bottles of milk on the wall, " +
      "2 bottles of milk.\n" +
      "Take one down and pass it around, " +
      "1 bottle of milk on the wall.\n"
    else
      "#{number} bottles of milk on the wall, " +
      "#{number} bottles of milk.\n" +
      "Take one down and pass it around, " +
      "#{number - 1} bottles of milk on the wall.\n"
    end
  end
end
```
- **What it demonstrates**: The complete Shameless Green solution — four verse variants expressed as explicit `case` branches, `verses` delegating to `verse` via `downto`, and `song` expressing intention over implementation.

## Reference Tables

### Metrics for Code Variants After Tests of Verses 99 and 3
| Solution | SLOC | Cyclomatic Complexity | ABC |
|---|---|---|---|
| Listing 2.4: Conditional | 13 | 2 | 2.2 |
| Listing 2.5: Sparse Conditional | 12 | 2 | 2.8 |
| Listing 2.6: Interpolation | 6 | 1 | 1 |

### Metrics for Code Variants After Test of Verse 2
| Solution | SLOC | Cyclomatic Complexity | ABC |
|---|---|---|---|
| Listing 2.8: Stark Conditional | 13 | 2 | 2 |
| Listing 2.9: Interpolated Conditional | 7 | 2 | 2 |

> Verse 3: metrics clearly favor interpolation (abstraction exists, 97 examples). Verse 2: metrics are tied — shorter code is not more abstract; tolerate duplication and add the branch.

### Song Test Options Decision Matrix
| Approach | Coupled to impl? | Survives refactor? | Forces correct output? |
|---|---|---|---|
| Assert `song == verses(99,0)` | Yes | No | No |
| Assert `song == dynamically generated` | Yes (one level back) | Fragile | Partial |
| Assert `song == hard-coded full string` | No | Yes | Yes |

### Green Bar Pattern Selection
| Pattern | When to use |
|---|---|
| Fake It | Next correct implementation is unclear; more tests needed |
| Obvious Implementation | Correct solution is small and certain |
| Triangulate | Need multiple broken tests to force convergence on abstraction |

## Key Takeaways
1. Write the simplest code that passes each test — wear the "writing code" hat in ignorance of future tests; wear the "writing tests" hat with the full picture in mind.
2. When tests get more specific, code should get more generic — generalize with interpolation when the abstraction is clear from many examples; add a branch when it isn't.
3. Tolerate duplication across verse branches until all variants are written; premature DRY applied to two examples risks hiding the real abstraction.
4. Use `case` when all conditions test the same variable for equality — it signals uniform structure to readers; `if/elsif` implies conditions may differ in kind.
5. Tests should assert concrete expected output, not mirror implementation — any logic in a test that echoes production code creates fragile coupling.
6. DRY belongs in code, not in tests — the song test should hard-code the full expected lyrics string, not compute them from `verse` or `verses`.
7. The `song` method earns its existence by reducing sender knowledge from six facts (method name, arity, argument order, start value, end value, argument meaning) to one (method name) — intention over implementation.

## Connects To
- **Ch 1**: Shameless Green was introduced as the preferred solution; this chapter shows how TDD produces it step-by-step.
- **Ch 3**: Once Shameless Green is complete, a new requirement forces decisions about whether and how to refactor — changeability becomes the concern.
