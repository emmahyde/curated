# Chapter 9: Reaping the Benefits of Design

## Core Idea
Good design pays off in tests: well-designed code is easy to test, and hard-to-test code signals a design problem. This chapter retrofits proper unit tests onto the refactored "99 Bottles" app, demonstrating that improved design makes tests simpler, cheaper, and more honest — completing the book's full cycle from tests → design → better tests.

## Frameworks Introduced

- **Tests-Reveal-Design**: Updating tests exposes coupling. If writing a simple, intention-revealing test is hard, the primary problem is too much coupling — loosen the coupling instead of writing complicated tests.
  - When to use: Any time tests feel awkward or require elaborate setup.
  - How: Treat test difficulty as a design smell. Refactor the code until the test becomes simple; do not patch the test to work around tight coupling.

- **Unit-Test Omission Decision Tree**: Every class deserves a unit test unless omitting saves money. The bar for skipping is high and requires explicit justification. Criteria for omission: (1) class is small, (2) class is simple, (3) class is invisible from outside its enclosing unit, (4) class is used in no other context.
  - When to use: Deciding whether to write isolated unit tests for small private-ish collaborators (e.g., `BottleNumber` subclasses).
  - How: Evaluate all four criteria. If all hold, test the class through its enclosing unit and call that unit test.

- **Visibility-Driven Test Strategy**: The tipping point for how to test is visibility. Dependencies not visible to outside observers (internal factories, private collaborators) may be tested through the enclosing class. Dependencies visible from outside (injected via constructor/keyword arg) must be tested independently with a fake.
  - When to use: Choosing isolation level for each class.
  - How: Ask "Is this dependency visible to outside callers?" If yes → inject a fake in tests. If no → test through the public unit.

## Key Concepts

- **Faux Unit Test**: An integration test masquerading as a unit test — reaches across object boundaries to cover collaborators. Legacy `Bottles` tests after the Ch7-8 refactors became faux unit tests: still passing, but no longer telling an honest story about any single class.
- **Intention-Revealing Test**: A test that demonstrates and confirms only the class's direct responsibilities, using the fewest assertions and the least code, with names and expectations that communicate purpose to future readers.
- **Confirmable Behavior**: Behavior that is meaningfully testable — produces a distinct, observable output for each valid input. Some private methods (e.g., `BottleNumber1#pronoun`) have no confirmable behavior from outside and may not justify their own test.
- **Leaf Node (on object dependency graph)**: A class with no outgoing dependencies on other domain objects — minimally entangled. Leaf nodes are candidates for omission from explicit unit tests when the other omission criteria also hold.
- **Visibility**: The degree to which a dependency is knowable by outside callers. An injected dependency is visible; an internally-created dependency is invisible. Visibility determines whether a fake/double is needed in tests.
- **Parsimonious Test**: A test that expresses a responsibility in the fewest possible assertions, even if it means breaking the "one assertion per test" rule. The factory test for `BottleNumber.for` is an example where multiple assertions in one test are justified.
- **Test Story**: The narrative a test suite tells about the domain. Tests that misrepresent (or lie about) the domain have negative value beyond regression detection.
- **100% Coverage Reinterpreted**: "100% of code exercised during unit tests" rather than "100% of public methods have personal unit tests." Some behavior is correctly covered via another class's unit test.

## Mental Models

- **Tests as Domain Documentation**: Tests are not just safety nets. They explain the domain to future readers, expose design problems, and confirm expected behavior. A test suite that only catches breakage but doesn't tell an honest story is leaving value on the table.
- **Design ↔ Test Bidirectional Feedback**: Design shapes tests (good design → simple tests). Tests shape design (hard tests → design improvement). The loop closes: test difficulty is a refactoring trigger, not a test-writing challenge.
- **The Wrapping Problem**: When `BottleVerse` internally creates `BottleNumber` objects, the dependency is hidden. From the outside, `BottleNumber` is invisible — it may as well not exist. This invisibility is what justifies testing bottle-number behavior through `BottleVerse` rather than independently.
- **Cost as the Deciding Metric**: Every test decision reduces to money. Tests exist to save money. Any test (or omission) that increases costs over time is wrong, regardless of coverage ideology.

## Anti-patterns

- **Overcoming Coupling in Tests**: Writing complicated test setup to work around tight coupling. The fix is not a smarter test — it's loosening the coupling in the code itself.
- **Faux Unit Tests at Scale**: Letting a high-level test (e.g., `BottlesTest`) silently absorb responsibility for all collaborators. When new classes are extracted and not given their own tests, the top-level test becomes a misleading integration test.
- **Ideology Over Economics**: Insisting on 100% per-method coverage regardless of cost. When a class is small, simple, invisible, and used nowhere else, forcing a unit test raises costs and can lock the implementation.
- **Testing Implementation Details**: Tests for `BottleNumber1#pronoun` know the word "it" and will break on any wording change. Tests bound to implementation constrain refactoring rather than enabling it.

## Code Examples

```ruby
# Factory unit test: parsimonious multi-assertion form
class BottleNumberTest < Minitest::Test
  def test_returns_correct_class_for_given_number
    # 0, 1, 6 are special
    assert_equal BottleNumber0, BottleNumber.for(0).class
    assert_equal BottleNumber1, BottleNumber.for(1).class
    assert_equal BottleNumber6, BottleNumber.for(6).class
    # Other numbers get the default
    assert_equal BottleNumber,  BottleNumber.for(3).class
    assert_equal BottleNumber,  BottleNumber.for(43).class
  end
end
```
- **What it demonstrates**: Testing a factory's responsibility (mapping number → correct class) is properly a single multi-assertion test; breaking it into five tests would obscure the unified responsibility and add noise.

```ruby
# Bottles with injected verse template (visible dependency)
class Bottles
  attr_reader :verse_template

  def initialize(verse_template: BottleVerse)
    @verse_template = verse_template
  end

  def verse(number)
    verse_template.lyrics(number)
  end
end

# In tests: inject a fake to isolate Bottles from BottleVerse
class SimpleVerseFake
  def self.lyrics(number)
    "This is verse #{number}.\n"
  end
end

class BottlesTest < Minitest::Test
  def test_plays_verse_role
    assert_equal "This is verse 7.\n",
      Bottles.new(verse_template: SimpleVerseFake).verse(7)
  end
end
```
- **What it demonstrates**: An injected (visible) dependency enables isolation — inject a `SimpleVerseFake` to test `Bottles` without depending on `BottleVerse`'s correctness. The design decision (keyword-arg injection) is what makes this test simple.

## Reference Tables

| Class | Visibility | Size/Complexity | Test Strategy |
|---|---|---|---|
| `BottleNumber` subclasses | Invisible (wrapped by `BottleVerse`) | Small, simple | Test through `BottleVerse` (omit own unit test) |
| `BottleNumber` factory | Internal but critical | Moderate | Unit test the factory's class-mapping responsibility |
| `BottleVerse` | Injected into `Bottles` (visible) | Moderate | Own unit test; uses faux bottle number or real |
| `Bottles` | Public entry point | Simple delegator | Unit test with `SimpleVerseFake` injected |

## Key Takeaways

1. If a test is hard to write, the code's design is the problem — loosen coupling before writing complicated tests.
2. Every class deserves a unit test unless omitting saves money; the omission bar is high and requires explicit justification.
3. The criteria for omitting a unit test: the class is small, simple, invisible from outside, and used in no other context — all four must hold.
4. Tests that tell an honest story about the domain are more valuable than tests that merely detect breakage; musty faux-unit tests should be replaced as design improves.
5. Visibility of a dependency determines test strategy: invisible dependencies test through the enclosing unit; visible (injected) dependencies test with a fake.
6. The factory is always worth testing explicitly, even when its manufactured objects are not — the factory's responsibility (number → correct class) is distinct from the objects' behavior.
7. Good design and good tests reinforce each other bidirectionally: design improvements enable better tests, and test difficulty drives design improvement.

## Connects To

- **Ch 2**: Original `BottlesTest` suite introduced here becomes the "musty" faux unit tests Ch9 replaces; the cycle completes.
- **Ch 5**: Separation of responsibilities (extracting `BottleNumber`, `BottleVerse`) created the multi-class design that now requires per-class test decisions.
- **Ch 6**: Open/Closed design via injection (keyword-arg `verse_template`) is precisely what enables `SimpleVerseFake` isolation in tests.
- **Ch 7**: `BottleNumber.for` factory (manufactured intelligence) gets its own targeted unit test here — test the factory's mapping, not the objects it creates.
