# Chapter 1: Rediscovering Simplicity

## Core Idea
Good code maximizes value while minimizing cost; the cheapest first solution to a problem is often the simplest, most duplicative one — resist abstraction until the code "insists" on it.

## Frameworks Introduced
- **The Concrete↔Abstract Continuum**: Every solution sits between "most concrete" (one long procedure of `if`s) and "most abstract" (many one-line classes). The sweet spot is in the middle.
  - When to use: judging where a design sits and whether it has over- or under-abstracted.
  - How: ask whether the code is concrete enough to *understand* yet abstract enough to *change*.
- **The Cost/Benefit Bargain of OOD**: Abstraction (DRY, splitting classes, injecting dependencies) trades increased complexity on one axis for decreased complexity on another. It's never free — only pay when the offsetting benefit is real.
- **Shameless Green**: The solution that reaches green fastest while prioritizing *understandability over changeability*. Tolerates duplication; defers abstraction until insight arrives.
  - When to use: as the first target for any new code or new feature.
  - How: write the simplest passing code, name nothing speculatively, accept concrete duplication.
- **The Three Value/Cost Questions**: (1) How hard was it to write? (2) How hard is it to understand? (3) How expensive will it be to change? Question 2 *always* applies.
- **The Four Domain Questions** (for the 99 Bottles problem): How many verse variants? Which are most alike? Which most different? What's the rule for the next verse? Good code answers these at a glance.

## Key Concepts
- **DRY (Don't Repeat Yourself)**: Extract duplication to one place — true, but adds indirection and a cost of understanding; worth it only when it reduces cost of change more.
- **Wrong abstraction**: A premature abstraction inferred from incomplete information; worse than duplication because it blocks discovering the right one (a catch-22).
- **Metric**: A crowd-sourced, research-backed measure of a code quality; produces *facts* to compare code.
- **SLOC**: Source Lines of Code — measures volume, not quality.
- **Cyclomatic Complexity**: Counts unique execution paths; also gives the minimum number of tests for full coverage.
- **ABC metric**: Assignments, Branches (message sends/calls), Conditions — a proxy for cognitive size/complexity. Ruby tool: **Flog**.

## Mental Models
- Think of code judgment as **value ÷ cost**, not aesthetics. "Elegant"/"clean" are unmeasurable opinions; metrics give facts.
- Treat duplication as *cheaper to manage than the wrong abstraction is to recover from*.
- "**Resist abstractions until they absolutely insist upon being created**" — wait for the code to reveal the right one.

## Anti-patterns
- **Incomprehensibly Concise**: Logic crammed into string interpolation; terse but duplicative and unnamed. Optimizes for brevity, which becomes tedious.
- **Speculatively General**: Levels of indirection (lambdas, wrapper objects) added to guard against imagined future change. Harder to understand without being easier to change.
- **Concretely Abstract**: Many tiny DRY methods named after *what they do now* (`milk`) instead of *what they mean* (`beverage`) — so a small requirement change cascades everywhere.

## Code Examples
The Shameless Green solution — duplicative on purpose, trivially understandable:
```ruby
class Bottles
  def song
    verses(99, 0)
  end

  def verses(upper, lower)
    upper.downto(lower).map {|i| verse(i)}.join("\n")
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
      "#{number-1} bottles of milk on the wall.\n"
    end
  end
end
```
- **What it demonstrates**: Tolerated duplication + zero speculative abstraction = easiest to read and cheapest to change right now.

## Reference Tables
Metrics across the four solutions (Table 1.1):

| Solution | SLOC | Assignments | Branches | Conditionals | ABC |
|----------|------|-------------|----------|--------------|-----|
| Incomprehensibly Concise | 19 | 0 | 0 | 9 | 9 |
| Speculatively General | 63 | 6 | 9-ish | 1 (4 branches) | 11 |
| Concretely Abstract | 87 | 4 | 26-ish | 4 | 27 |
| **Shameless Green** | 34 | 0 | 0 | 1 (4 branches) | **1** |

Shameless Green wins on every count except SLOC.

## Key Takeaways
1. Judge code by value/cost, and lean on metrics (SLOC, cyclomatic, ABC/Flog) for facts when opinions clash.
2. Name methods after *what they mean* (their domain concept), never after their current implementation.
3. Duplication is far cheaper than the wrong abstraction; wait for insight.
4. Reach Shameless Green first: simple, duplicative, understandable, "good enough" if nothing changes.
5. Speculative generality and premature DRYing both raise cost without buying changeability.

## Connects To
- **Ch 2**: How to test-drive your way *to* Shameless Green.
- **Ch 3**: What to do when a change request finally arrives and Shameless Green is no longer good enough.
- **The Flocking Rules (Ch 3)** and **DRY**: the disciplined path from concrete duplication to right abstraction.
