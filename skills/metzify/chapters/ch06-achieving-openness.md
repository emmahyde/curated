# Chapter 6: Achieving Openness

## Core Idea
Make code open to the six-pack requirement by removing conditionals from `BottleNumber` via the Replace Conditional with Polymorphism recipe, introducing a factory to select the right role-playing class, and fixing the Liskov violation in `successor` — so the new requirement is met by adding one small class without touching existing code.

## Frameworks Introduced
- **Replace Conditional with Polymorphism**: Fowler recipe that removes `if/case` branches by dispersing them into subclasses — superclass keeps the false/default branch, each subclass owns its true/special branch; a factory selects the right class at runtime.
  - When to use: methods share an identical conditional shape checking the same value(s); isolated special values clearly need their own class.
  - How: (1) create empty subclass for the special value, (2) copy method into subclass, (3) reduce subclass to true-branch body, (4) reduce superclass to false-branch body, (5) update/create factory, (6) repeat per method and per special value.
- **Factory Method (`BottleNumber.for`)**: A single method whose sole responsibility is to return the correct role-playing object given a number; isolates concrete class names and choosing logic so no other code refers to them.
  - When to use: more than one class plays a common role and some code must choose among them.
  - How: create one method with a `case` on the discriminating value; each `when` branch returns the class; `.new(number)` is sent to the result of the entire `case` block.
- **Data Clump removal via `to_s`**: When two values always appear together in string interpolation, implement `to_s` on the object that owns them so the pair collapses to a single interpolation token.
  - When to use: three or more occurrences of the same data pair in a template.
  - How: define `to_s` returning the paired values; Ruby string interpolation automatically calls `to_s` on `#{}` expressions, so `#{bottle_number}` replaces `#{bottle_number.quantity} #{bottle_number.container}`.
- **Liskov Fix via Transitional Guard Clause**: Changing a polymorphic method's return type across multiple implementors and senders without a big-bang cut-over; temporarily allow the factory to accept both old and new types during migration.
  - When to use: successor (or any polymorphic method) returns the wrong type; multiple implementors and senders make simultaneous changes infeasible.
  - How: (1) add `return arg if arg.kind_of?(TargetType)` guard to factory, (2) update each implementor one at a time, (3) update senders, (4) delete guard.

## Key Concepts
- **Data Clump**: Three or more data fields that routinely appear together, signaling a missing concept; cured by extracting a class or, in small cases, a method.
- **Switch Statement smell**: A class dominated by identically shaped conditionals testing the same value(s); primary curative refactorings are Replace Conditional with Polymorphism or Replace Conditional with State/Strategy.
- **Polymorphism**: Many object types responding to the same message; senders depend on the message, not the receiver's class, enabling substitution without conditional dispatch.
- **Factory**: A method (or class method) whose job is to manufacture the right role-playing object; owns all knowledge of concrete class names and selection logic; no other code may duplicate this.
- **Seam**: The level of indirection introduced by a factory; makes it possible to change which object is created without affecting callers.
- **Liskov Substitution Principle (LSP)**: Objects of a role should be substitutable for one another; violating it (e.g., `successor` returning `Integer` instead of `BottleNumber`) forces callers to know implementation details and breaks as new classes are added.
- **Inline Temp**: Refactoring that removes a temporary variable used in only one place, substituting its assignment expression directly at the use site.
- **Open/Closed Principle**: Code is open to extension (new `BottleNumber6` subclass) without modification of existing code (no edits to `Bottles`, `BottleNumber`, `BottleNumber0`, `BottleNumber1`); the factory is the one acknowledged exception.
- **Trustworthy Object**: An object that always responds to expected messages and returns expected types; enables implicit contracts and eliminates paranoid defensive code.
- **Kent Beck's maxim**: "Make the change easy (warning: this may be hard), then make the easy change." — the refactoring investment yields a trivially small implementation step.

## Mental Models
- **True-branch → subclass, false-branch → superclass**: The conditional shape maps directly onto the inheritance hierarchy; the superclass is the general case, each subclass is a specialization.
- **Factory as the one allowed conditional**: After polymorphism is in place, the only surviving `case` is in the factory; this is intentional — one place, one responsibility, no duplication.
- **Stable landing points**: Each refactoring step (copy method, reduce subclass, reduce superclass, update factory) ends with passing tests; never hold more than one change in flight.
- **Domain fidelity over cleverness**: Overriding `to_s` with `"1 six-pack"` passes tests but corrupts domain meaning; `quantity` and `container` are real domain concepts that must exist independently.

## Anti-patterns
- **Overriding `to_s` to encode domain data**: `def to_s; "1 six-pack"; end` couples `BottleNumber6` to the `verse` template's internals, lying about the object's `quantity` and `container`; misleads future programmers and forecloses reuse.
- **Duplicating the factory conditional**: Inlining `number == 0 ? BottleNumber0 : BottleNumber` at each call site defeats the factory's purpose; creates multiple places to update when a new subclass is added.
- **Cutting over all changes at once**: When changing a polymorphic method's return type, attempting to update all implementors and senders simultaneously causes test failures with no clear rollback point; prefer the one-at-a-time + guard-clause strategy.
- **Including type in factory method names**: `bottle_number_for` inside `BottleNumber` is redundant echo-chamber naming; use the generic `for` so the factory itself becomes polymorphically substitutable.

## Code Examples
```ruby
# Complete final listing — Open/Closed payoff

class Bottles
  def verse(number)
    bottle_number = BottleNumber.for(number)

    "#{bottle_number} of milk on the wall, ".capitalize +
    "#{bottle_number} of milk.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} of milk on the wall.\n"
  end
end

class BottleNumber
  def self.for(number)
    case number
    when 0 then BottleNumber0
    when 1 then BottleNumber1
    when 6 then BottleNumber6
    else        BottleNumber
    end.new(number)
  end

  attr_reader :number
  def initialize(number) = @number = number
  def to_s           = "#{quantity} #{container}"
  def quantity       = number.to_s
  def container      = "bottles"
  def action         = "Take #{pronoun} down and pass it around"
  def pronoun        = "one"
  def successor      = BottleNumber.for(number - 1)
end

class BottleNumber0 < BottleNumber
  def quantity  = "no more"
  def action    = "Go to the store and buy some more"
  def successor = BottleNumber.for(99)
end

class BottleNumber1 < BottleNumber
  def container = "bottle"
  def pronoun   = "it"
end

# New requirement: add ONE class, update factory — nothing else changes
class BottleNumber6 < BottleNumber
  def quantity  = "1"
  def container = "six-pack"
end
```
- **What it demonstrates**: Open/Closed in practice — the six-pack requirement is satisfied by `BottleNumber6` alone; all callers remain untouched.

## Reference Tables

| Special value | Subclass | Overridden methods |
|---|---|---|
| `0` | `BottleNumber0` | `quantity`, `action`, `successor` |
| `1` | `BottleNumber1` | `container`, `pronoun` |
| `6` (new req.) | `BottleNumber6` | `quantity`, `container` |
| all others | `BottleNumber` | (defaults) |

| Recipe step | Action | Tests |
|---|---|---|
| 1. Create subclass | `class BottleNumber0 < BottleNumber; end` | green |
| 2. Copy method | duplicate into subclass | green |
| 3. Reduce subclass | keep true-branch body only | green |
| 4. Reduce superclass | keep false-branch body only | **red** → need factory |
| 5. Create/update factory | add `when 0` branch | green |
| 6. Repeat | next method / next value | green |

## Key Takeaways
1. The refactoring investment (chapters 4–6) pays off as a 9-line class that satisfies the six-pack requirement — Kent Beck's "make the change easy, then make the easy change."
2. Replace Conditional with Polymorphism: copy to subclass → reduce subclass to true branch → reduce superclass to false branch → update factory; run tests at every step.
3. A factory is the one sanctioned home for the `case` statement selecting among role-playing classes; it must be the only place that knows concrete class names.
4. Use `BottleNumber.for` (not `bottle_number_for`) — generic names support polymorphism; type-embedded names couple callers to the receiver's class.
5. Liskov violations compound over time; fix them by adding a transitional guard clause (`return arg if arg.kind_of?(T)`) to tolerate mixed return types while migrating implementors one at a time.
6. Domain concepts (`quantity`, `container`) must remain explicit methods even when a shortcut (`to_s` override) would pass the tests; correctness in the domain outlasts any single template.
7. Blank lines in methods signal multiple responsibilities — a tell that extraction or further simplification is warranted.

## Connects To
- **Ch 2**: Original `case` statement in Shameless Green — the factory's `case` echoes that structure deliberately; the difference is it now selects objects, not strings.
- **Ch 4**: Flocking Rules produced the uniform conditional shape that made Replace Conditional with Polymorphism straightforward.
- **Ch 5**: Extract Class (Primitive Obsession cure) moved conditionals from `Bottles` into `BottleNumber`, setting up the polymorphic refactoring here.
- **Ch 7**: Factory styles — `bottle_number_for` → `BottleNumber.for` is just the beginning; Ch 7 explores richer factory patterns and making the factory itself open.
