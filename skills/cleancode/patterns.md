# Clean Code — Patterns & Techniques

## Extract Method / Extract Till You Drop
**When to use**: Any function longer than ~5 lines, or any block that could be given a descriptive name.
**How**: Extract every block that can be named into its own function. Repeat until every function does exactly one thing at one level of abstraction — the "TO paragraph" test: "TO render the page, we check if it's a test page; if so, we include test setup." Keep going until extraction would produce only a single line.
**Trade-offs**: More functions, shallower call stacks. Navigation overhead is offset by readability. Never stop too early.

## Replace Comment with Function/Variable
**When to use**: Before writing any explanatory comment. If the code needs a comment, rename or extract first.
**How**: If a comment explains *what* a block does, extract it into a named function. If it explains *what* a variable holds, rename the variable. Reserve comments only for things code genuinely cannot express (legal notices, regex intent, API contract warnings).
**Trade-offs**: More names to maintain; eliminates stale comment drift.

## Replace Magic Number with Named Constant
**When to use**: Any raw numeric (or string) literal in logic, conditions, or sizing.
**How**: Declare `static final int SECONDS_PER_DAY = 86400;`. Name expresses intent; the literal moves to one place.
**Trade-offs**: Minimal. One declaration vs. scattered literals. Worth doing even for two occurrences.

## Encapsulate Conditional
**When to use**: Any `if` or `while` condition containing more than one clause.
**How**: Extract the boolean expression into a named predicate function: `if (shouldBeDeleted(timer))` instead of `if (timer.hasExpired() && !timer.isRecurrent())`.
**Trade-offs**: One extra function per extracted predicate. Named predicates double as documentation.

## Replace Nested Conditional with Polymorphism
**When to use**: Switch statements or if/else chains that branch on object type and repeat the same shape across methods.
**How**: Create an abstract base type with one method per variant behavior. Bury the single `switch` in an Abstract Factory. Each subclass implements only its variant. Callers never see the switch.
**Trade-offs**: More classes, more files. Each class becomes simpler; adding a new type is open/closed — extend without modifying existing code.

## Introduce Argument Object
**When to use**: Three or more arguments that naturally cluster together and appear together across multiple call sites.
**How**: Group them into a named class (`PageRequest`, `DateRange`). The new type often grows methods that were previously scattered near the call sites.
**Trade-offs**: One new class. Reduces argument count, enables the object to carry behavior, and opens the door for further cohesion.

## Special Case Pattern (Replace Null)
**When to use**: Any method that returns null when nothing is found; any catch block that merely substitutes a default value.
**How**: Return a Special Case object that implements the same interface but represents the "nothing" state with inert/default behavior. For collections, return `Collections.emptyList()`. Push the default behavior into the object so callers need no null check.
**Trade-offs**: One extra class per special case. Eliminates null checks at every call site, eliminates NPEs far from their source.

## Wrap Third-Party Boundary
**When to use**: Any time a third-party interface (e.g., `Map`, a vendor SDK) is used across multiple call sites or exposes more API surface than you need.
**How**: Create a thin wrapper class whose public API exposes only the operations your application requires. The wrapper holds the third-party object privately. If the dependency is undefined, define your ideal interface first and write an Adapter once the real API arrives.
**Trade-offs**: One extra class at each boundary. Insulates the application from vendor API changes; one place to update when the library changes.

## Learning Tests
**When to use**: Whenever adopting a new third-party library.
**How**: Write isolated tests that call the third-party API exactly as you intend to use it. Run these tests against every new library version to catch breaking changes before integration does.
**Trade-offs**: Small up-front investment. Pays for itself on the first major version upgrade.

## Extract Try/Catch
**When to use**: Any function where `try` is mixed with business logic.
**How**: Move the entire body of the `try` block into its own function (e.g., `tryDeletePage()`). Move the `catch`/`finally` bodies into their own functions. The outer function contains only `try { doX(); } catch { handleError(); }` — nothing else.
**Trade-offs**: More functions. Error handling becomes a clearly demarcated concern, and functions are easier to test individually.

## Command Query Separation
**When to use**: Any function that both mutates state and returns a value.
**How**: Split into two functions: a void command (`setAttribute("name", "value")`) and a predicate query (`attributeExists("name")`). Callers compose them explicitly.
**Trade-offs**: Doubles the function count for the operation. Eliminates ambiguity about whether a call is a test or an action; queries become safe to call anywhere.

## BUILD-OPERATE-CHECK Test Structure
**When to use**: Every unit test.
**How**: Structure each test in three distinct phases: (1) Build — set up test data, (2) Operate — exercise the system under test, (3) Check — assert expected results. Each phase is visually separated, ideally using domain-specific helper functions that hide plumbing.
**Trade-offs**: None. Mechanical structure makes test intent immediately legible.

## Build a Domain-Specific Testing Language
**When to use**: When test code accumulates boilerplate that obscures test intent.
**How**: Refactor repeated test setup/assertion idioms into named helper functions and custom assertion methods. Grow these helpers into a specialized API used only by tests. Do not design it up front — let it emerge through refactoring.
**Trade-offs**: Test-only code to maintain. The payoff is tests that read like specifications rather than framework calls.

## Abstract Factory to Defer Construction
**When to use**: When the application must control *when* objects are created at runtime but should not control *how* they are constructed.
**How**: Define an Abstract Factory interface visible to the application. Move the concrete factory implementation to the `main` side of the codebase. The application calls the factory interface; it never calls `new` on domain objects.
**Trade-offs**: More classes at the construction seam. Construction and business logic remain fully decoupled; concrete types are substitutable for testing.

## Dependency Injection
**When to use**: Any class that instantiates its own collaborators with `new`.
**How**: Declare collaborators as constructor parameters (or setters). Remove all `new` calls from the class. A DI container or `main` method wires concrete instances from configuration. The class declares what it needs; it never resolves it.
**Trade-offs**: Construction logic moves to a container or explicit wiring. Classes become trivially testable — inject mocks without subclassing.

## Template Method to Remove Higher-Level Duplication
**When to use**: Two or more subclasses share an algorithm skeleton but differ only in specific steps.
**How**: Move the invariant skeleton into a base-class method. Extract the varying steps into `abstract` hook methods that subclasses implement. The base method calls the hooks in order.
**Trade-offs**: Introduces inheritance coupling. Appropriate when the higher-level structure is stable and only leaf behavior varies.

## Successive Refinement (Make It Work, Then Make It Right)
**When to use**: Always — as the standard professional workflow, not as an optional polish pass.
**How**: Write the simplest code that passes the tests. Once it works, immediately refactor: extract methods, introduce abstractions, eliminate duplication, remove type-based switches via polymorphism. Work in small incremental steps, running tests after each move to preserve behavior. Never let the first-pass mess harden into permanent architecture.
**Trade-offs**: Requires discipline to actually do the second pass. Without it, messy code compounds into an unmaintainable festering pile. The cost of cleaning early is always less than the cost of cleaning late.
