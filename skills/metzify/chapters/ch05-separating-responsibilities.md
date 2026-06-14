# Chapter 5: Separating Responsibilities

## Core Idea
When multiple methods share a common argument, same shape, and same conditional structure, they belong together in a new class. The cure for Primitive Obsession is Extract Class — create a smarter object to hold both the value and its behavior, eliminating conditionals from callers.

## Frameworks Introduced
- **Nine-Question Code Smell Audit**: A structured interrogation of a class to surface hidden groupings and missed abstractions.
  - When to use: Before undertaking a new refactoring; when requirements arrive and code doesn't feel open.
  - How: Answer all nine questions (see Reference Tables); methods that share answers belong together.
- **Squint Test**: Visual shape/color scan to detect inconsistent indentation (conditionals) and mixed abstraction levels.
  - When to use: Quickly judge any code without reading it.
  - How: Zoom out or lean back until text is illegible; look for indentation changes (conditionals) and color changes (abstraction mixing).
- **Extract Class Recipe** (Fowler-derived, 4-step): Safe incremental extraction that keeps tests green at every step.
  - When to use: Primitive Obsession identified — a built-in type is being passed around with behavior supplied externally.
  - How: (1) Create empty class, (2) copy (not move) methods, (3) add `attr_reader`/`initialize`, (4) forward one method at a time; use old tests as integration safety net.
- **Remove Argument via One-Line Changes**: Incrementally make a method argument optional, update all senders, then delete.
  - When to use: After Extract Class wires up; methods in new class still accept redundant arguments they could get from `self`.
  - How: (1) rename arg to `delete_me=nil`, (2) remove param from every sender, (3) delete the `delete_me` arg.

## Key Concepts
- **Primitive Obsession**: Using a built-in type (`Integer`, `String`, etc.) to represent a domain concept, forcing callers to supply behavior for it — the target smell of this chapter.
- **Extract Class**: Refactoring recipe that moves a cohesive group of methods into a new class, replacing the primitive with a smarter object.
- **Bottle Number vs. Verse Number**: The `number` argument means different things in `verse` (verse number) vs. the flocked five (bottle number) — same name, different concept; the root cause of the smell.
- **Insisting Upon Messages**: OO ideal — objects should receive messages, not be examined and have behavior supplied externally. A conditional that supplies behavior for an argument signals a missing object.
- **Immutability**: Objects that do not change are easy to reason about, test, and make thread-safe; prefer immutable object creation over mutation unless performance data demands otherwise.
- **Caching**: Storing a local copy of an expensive result; interacts with mutation — if the cached thing mutates, the cache must be invalidated, adding complexity.
- **Liskov Substitution Principle (generalized)**: A method named `successor` implicitly promises to return an object with the same API as the receiver; returning an `Integer` from a `BottleNumber#successor` breaks this promise.
- **Temporary Variable (code smell)**: A variable that caches a value within a method scope; low-cost, auto-invalidating, acceptable when benefits outweigh complexity costs.
- **Modeling Abstractions**: OO lets you create virtual objects for ideas (numbers, purchases, events), not just physical things; experienced OO practitioners create classes for concepts that live in the interactions between other objects.
- **Stable Landing Points**: Prior consistent refactoring (Flocking Rules) produces code with visible common shape, making it easy to recognize which methods belong together in Extract Class.

## Mental Models
- **Conditional = missing object**: When a method examines an argument to supply behavior, the hairs on your neck should stand up. The correct fix is a smarter object that answers the message itself — `smarter_number.container` rather than `if number == 1 … end`.
- **Classes named after what they are; methods named after what they mean**: The rule "name one level of abstraction higher" applies to methods, not classes. `BottleNumber` (concrete) beats `ContainerNumber` (speculative generality).
- **Object creation is (effectively) free until proven otherwise**: Write code that creates new objects freely; measure performance after; add caching only where profiling shows need. The cost of premature optimization is real; the cost of a missed hot path is speculative.
- **Horizontal before vertical**: Complete the current refactoring sweep before veering off to fix a discovered issue (e.g., Liskov violation in `successor`). Finish the thought, then open a new one.

## Anti-patterns
- **Mutating to avoid object creation**: Reusing a single `BottleNumber` by changing its `number` field saves allocations but adds cache-invalidation complexity and mutation bugs — the cost usually exceeds the benefit.
- **Premature caching**: Adding instance variables or external caches before measuring performance obscures the object model and complicates tests; 900 new objects is often fine.
- **Non-essential variation in conditionals**: Using `<`, `>`, or `!=` when `==` would work disguises the common shape of methods and blocks future refactorings that rely on equality-test patterns.
- **Moving before wiring**: The recipe copies methods first, then wires the new class in, then deletes originals. Skipping the copy-first step risks breaking tests with no safety net.
- **Fixing all senders of one class, missing internal senders**: When removing arguments, `pronoun` in `Bottles` is a red herring — the real sender is `action` inside `BottleNumber` itself.

## Code Examples
```ruby
# Final extracted state — Primitive Obsession cured
class Bottles
  def verse(number)
    bottle_number      = BottleNumber.new(number)
    next_bottle_number = BottleNumber.new(bottle_number.successor)

    "#{bottle_number.quantity.capitalize} #{bottle_number.container} " \
    "of milk on the wall, " \
    "#{bottle_number.quantity} #{bottle_number.container} of milk.\n" \
    "#{bottle_number.action}, " \
    "#{next_bottle_number.quantity} #{next_bottle_number.container} " \
    "of milk on the wall.\n"
  end
end

class BottleNumber
  attr_reader :number
  def initialize(number) = @number = number

  def quantity   = number == 0 ? "no more" : number.to_s
  def container  = number == 1 ? "bottle" : "bottles"
  def pronoun    = number == 1 ? "it" : "one"
  def action     = number == 0 ? "Go to the store and buy some more" : "Take #{pronoun} down and pass it around"
  def successor  = number == 0 ? 99 : number - 1   # Liskov violation: should return BottleNumber
end
```
- **What it demonstrates**: All bottle-number behavior lives in `BottleNumber`; `Bottles#verse` is a pure template that sends messages to objects.

## Reference Tables

| Question | What it reveals |
|---|---|
| 1. Do methods have the same shape? | Candidates for Extract Class |
| 2. Do methods take the same argument name? | Cohesion signal |
| 3. Does same-named argument mean the same thing? | Naming/concept confusion |
| 4. Where would `private` go? | Natural class boundary |
| 5. Where would you split the class? | Same boundary as #4 |
| 6. Do conditionals test the same thing? | Shared branching logic |
| 7. How many branches? | Complexity signal |
| 8. Any code besides the conditional? | Single-responsibility check |
| 9. Depends more on argument or class? | Extract Class candidate confirmation |

| Extract Class Step | Action |
|---|---|
| 1. Parse | Create empty new class |
| 2. Parse + execute | Copy methods; add `attr_reader`/`initialize`; forward one method, discard result |
| 3. Parse + execute + use | Move forward to return position; tests must pass |
| 4. Delete | Remove old implementation; repeat for each method |

| Remove Argument Step | Code change |
|---|---|
| 1. Default the arg | `def quantity(number)` → `def quantity(delete_me=nil)` |
| 2. Update all senders | `BottleNumber.new(n).quantity(n)` → `BottleNumber.new(n).quantity` |
| 3. Delete the arg | `def quantity(delete_me=nil)` → `def quantity` |

## Key Takeaways
1. When multiple methods share the same argument name, same shape, and same conditional structure, that cluster is a candidate for Extract Class — the code is suffering from Primitive Obsession.
2. The Squint Test is a zero-setup heuristic: indentation changes signal conditionals; color changes signal abstraction mixing.
3. OO demands messages to objects, not examination of primitives — a conditional that supplies behavior for an argument is evidence of a missing class.
4. Safe Extract Class copies first, wires second, deletes third — never move before wiring, always keep tests green after every line.
5. Classes are named after what they are; methods after what they mean. `BottleNumber` is correct; `ContainerNumber` is premature abstraction.
6. Treat object creation as free; measure performance before caching; prefer immutable objects — mutation + caching multiply complexity.
7. When a refactoring recipe breaks tests, the recipe is usually right and the code has a wrinkle you haven't noticed yet (e.g., an internal sender you missed).

## Connects To
- **Ch 3**: Flocking Rules created the "flocked five" methods whose common shape this chapter exploits; stable landing points from consistent code make Extract Class straightforward.
- **Ch 4**: Prior refactoring made Bottles internally consistent but not yet open — Ch 5 takes the next step toward openness by isolating bottle-number responsibility.
- **Ch 6**: Liskov violation in `successor` (returns `Integer` instead of `BottleNumber`) is the dangling thread Ch 6 resolves; this chapter deliberately defers it to finish the horizontal refactoring first.
