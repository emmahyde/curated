# Chapter 4: Practicing Horizontal Refactoring

## Core Idea
Apply the Flocking Rules iteratively across all remaining special-case verse branches until every branch is identical, then collapse them into a single abstract template. The process systematically surfaces hidden concepts as named methods.

## Frameworks Introduced
- **Horizontal Refactoring**: Eliminate differences between parallel branches by replacing concrete values with message sends to extracted methods, one smallest-difference at a time.
  - When to use: Two or more case/if branches that are nearly identical but differ in specific values or expressions.
  - How: (1) Find the smallest difference. (2) Name the concept behind the difference. (3) Extract a method. (4) Replace the difference in both branches with the message send. (5) Delete the now-identical branch. Repeat until one branch remains, then move it outside the conditional.

- **Meaningful Defaults**: When adding a parameter to an extracted method during refactoring, choose a default value that keeps existing tests green.
  - When to use: Any time you add a parameter to a method mid-refactoring, before all call sites pass arguments.
  - How: If you implement the `else` branch first, `:FIXME` works (it hits the false branch and fails visibly). If you implement the non-`else` branch first, choose a real value that satisfies the true-branch condition (e.g., `0` if the condition is `number == 0`). Remove the default once all senders pass arguments.

- **Liskov Substitution Principle (applied to duck types)**: Every object playing a duck role must fully implement the duck's API; receivers must return trustworthy objects so senders need no knowledge of return-type variation.
  - When to use: Whenever a method has multiple return paths that return values of different types.
  - How: Move type coercion into the receiver, not the sender. If `quantity` sometimes returns Integer and sometimes String, add `.to_s` inside `quantity`, not at every call site.

- **Stable Landing Points**: After each refactoring pass, the codebase should be in a consistent, green, resting state before moving to the next step.
  - When to use: Always — especially after introducing new conditionals or defaults.
  - How: Run tests after every change. If red, undo immediately; do not refactor under red.

- **Taking Bigger Steps (pattern recognition shortcut)**: Once you've practiced the extraction pattern enough times to recognize it, write the extracted method in one step rather than incrementally.
  - When to use: After you've done the same extraction multiple times and fully understand the resulting shape.
  - How: Write the new method directly with its conditional. If tests go red, undo and return to incremental steps.

## Key Concepts
- **Replacing Difference with Sameness**: Substituting a variable (e.g., `#{number}`) for a hard-coded literal (e.g., `"1"`) increases abstraction and enables branch unification — even when the argument is known to equal the literal at runtime.
- **Horizontal Refactoring**: Refactoring that moves across parallel branches of a conditional, making each branch identical, rather than refactoring within a single branch vertically.
- **Abstraction**: A named concept that encapsulates a rule (e.g., `quantity`, `container`, `successor`) — invisible in Shameless Green but revealed by the Flocking Rules.
- **Stable Landing Point**: A state of the codebase where all tests pass and methods have consistent shape — safe to pause, plan, and proceed from.
- **Consistent Method Shape**: All extracted methods in this chapter take a single `number` argument and contain a single two-branch conditional — a direct product of following the same rules.
- **Successor**: The verse number to be sung next; not the arithmetic predecessor. For verse 0, successor is 99; for all others, `number - 1`.
- **Deriving Names from Responsibilities**: Name a concept by describing what the method is responsible for returning; prefer responsibility-oriented names over value-oriented ones (e.g., `quantity` over `remainder`).
- **Depending on Abstractions**: Once an abstraction exists, use it everywhere it applies — even replacing `number - 1` with `successor(number)` to make intent explicit and avoid accidental correctness.
- **Liskov Substitution Principle**: Subtypes must be substitutable for supertypes; duck types must fully implement the duck's API; receivers must return trustworthy objects.

## Mental Models
- **Rock-Hopping**: Refactoring is like hopping rocks in a stream. Dry rocks (stable landing points) let you plan. Wet rocks (inconsistent states) must be traversed quickly. Never rest on a wet rock; undo to green if you slip.
- **Column Header naming**: To name an abstraction, build a table mapping input values to expected outputs, then ask "what would the column header be?" (e.g., Number → `quantity`).
- **Nibbling**: When confused, don't solve the whole problem — find one way to make the lines look more alike, even if not yet identical. Clarity follows from incremental similarity.
- **Accidental vs. Intentional Correctness**: Code can pass tests by accident (e.g., `container(-1)` returning `"bottles"` because -1 hits the false branch). Replacing `number-1` with `successor(number)` makes correctness intentional and explicit.

## Anti-patterns
- **Implementing non-`else` branch first with `:FIXME` default**: `:FIXME` hits the false branch; if you need the true branch to fire for no-argument calls, `:FIXME` will produce wrong output. Use a domain-meaningful default instead.
- **Naming by current value instead of responsibility**: Naming `quantity` as `remainder` because phrase 4 uses `number-1` — this name breaks when verse 0's "No more" opening requires the same concept. Name from responsibility, not from the current call site context.
- **Extending an abstraction to handle an invalid domain value**: Adding `when -1 then "99"` to `quantity` to handle verse 0's restart — `-1` is not a valid bottle count. This signals a missing abstraction (`successor`) rather than an extension of an existing one.
- **Refactoring under red**: Pushing forward with failing tests instead of undoing and returning to green. Bigger steps are only justified when tests remain green.
- **Leaving `number-1` after `successor` exists**: Using `container(number-1)` after `successor` is extracted passes tests accidentally. Replace with `container(successor(number))` to depend on the abstraction.

## Code Examples
```ruby
# Final verse method — single abstract template, no conditionals
def verse(number)
  "#{quantity(number).capitalize} #{container(number)} of milk on the wall, " +
  "#{quantity(number)} #{container(number)} of milk.\n" +
  "#{action(number)}, " +
  "#{quantity(successor(number))} #{container(successor(number))} of milk on the wall.\n"
end

def quantity(number)
  if number == 0
    "no more"
  else
    number.to_s   # .to_s obeys Liskov: always returns a capitalizable String
  end
end

def container(number)
  if number == 1
    "bottle"
  else
    "bottles"
  end
end

def action(number)
  if number == 0
    "Go to the store and buy some more"
  else
    "Take #{pronoun(number)} down and pass it around"
  end
end

def pronoun(number)
  if number == 1
    "it"
  else
    "one"
  end
end

def successor(number)
  if number == 0
    99
  else
    number - 1
  end
end
```
- **What it demonstrates**: Every verse variant is produced by one template composed entirely of named single-responsibility abstractions with consistent shape.

## Reference Tables

| Concept | Extracted Method | Special Case | Default |
|---|---|---|---|
| Singular/plural container | `container(n)` | `n==1` → `"bottle"` | `"bottles"` |
| Pronoun for taking down | `pronoun(n)` | `n==1` → `"it"` | `"one"` |
| Sung representation of number | `quantity(n)` | `n==0` → `"no more"` | `n.to_s` |
| Verse action line | `action(n)` | `n==0` → go to store | take one down |
| Next verse number | `successor(n)` | `n==0` → `99` | `n - 1` |

| Default Strategy | When to Use | Risk |
|---|---|---|
| `:FIXME` | Implementing `else` branch first | Fails visibly if wrong branch needed |
| Real domain value (e.g., `0`) | Implementing non-`else` branch first | Must remember to remove; must reason about correct value |

## Key Takeaways
1. Replacing a concrete literal with a variable reference (`"1"` → `#{number}`) is the core mechanism of horizontal refactoring — even when the runtime value is unchanged, the abstraction level rises.
2. Name concepts from their responsibility, not their current value; look forward enough to ensure the name isn't invalidated by adjacent cases.
3. When the default `:FIXME` causes test failures, it signals you implemented the non-`else` branch first — switch to a meaningful domain default.
4. Receivers must return trustworthy, consistent types (Liskov); coerce inside the method, not at every call site.
5. Consistent method shape (same argument, same two-branch `if`, same comparison style) is not accidental — it's the direct product of the Flocking Rules and enables future refactorings.
6. The `successor` concept emerges only by following the rules mechanically; most programmers miss it when solving ad hoc. Hidden abstractions surface through disciplined horizontal refactoring.
7. Once an abstraction exists, depend on it everywhere it applies — not doing so is accidental correctness and a latent bug.

## Connects To
- **Ch 3**: Introduced the Flocking Rules and applied them to the `2`/`else` case; Chapter 4 completes the same process for `1`/`else` and `0`/`else`.
- **Ch 5**: Returns to the "six-pack" problem, applying the now-stable abstractions (`quantity`, `container`, `successor`, etc.) to a new variant.
- **Ch 1**: Shameless Green's single-method solution contained `container`, `pronoun`, `quantity`, `action`, and `successor` as invisible, unnamed concepts — now all revealed.
