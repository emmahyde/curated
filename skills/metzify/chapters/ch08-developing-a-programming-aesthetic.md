# Chapter 8: Developing a Programming Aesthetic

## Core Idea
A programming aesthetic is the personal set of heuristics that guides your decisions when no refactoring recipe covers the situation; this chapter introduces five OO precepts that should be part of every practitioner's aesthetic, then demonstrates them by extracting `BottleVerse` to satisfy a new requirement to vary the lyrics.

## Frameworks Introduced
- **Programming Aesthetic**: The internalized set of heuristics that guides you in times of uncertainty — code smells and recipes cover a lot, but not everything; vague feelings about rightness become aesthetic once you can articulate them with words.
  - When to use: any time the code "feels" wrong but no smell or recipe fires
  - How: develop explicit precepts; apply them to working code when the cost is justified
- **Open-Closed Flowchart** (from Ch 3, re-applied): Before writing code for a new requirement, ask whether the existing code is open or closed to that change.
  - When to use: on every new requirement — consult before touching anything
  - How: if closed → refactor to open first; if already open → write new code directly
- **Extract-and-Inject Pattern**: When a new requirement needs to vary a behavior, isolate that behavior into a new class, then inject it as a dependency.
  - When to use: when existing class has mixed responsibilities OR when a future variant is needed
  - How: extract class → define role interface → inject via keyword argument with default

## Key Concepts
- **Programming Aesthetic**: Set of personal heuristics that guide behavior when no recipe exists; vague discomfort becomes aesthetic only when you can articulate it persuasively.
- **Open / Closed**: Code is "open" to a change if you can add the new behavior without modifying existing code; "closed" if it must be modified before the new code can be written.
- **Opportunity Cost**: Voluntarily improving working code has a cost — everything else on the backlog you are *not* doing; improvements must be worth that cost.
- **Blank Line Smell**: A blank line inside a method indicates a change of topic, implying multiple responsibilities and probable SRP violation.
- **"And" Suspicion**: Presence of the word "and" when describing a method's behavior signals it does more than one thing.
- **Single Responsibility Principle (SRP)**: A method or class should do one thing; symptoms of violation include blank lines, "and" in descriptions, and object-conversion as a side-effect.
- **Dependency Injection**: Passing collaborators in rather than hard-coding them; loosens coupling and enables polymorphism.
- **Role / Verse Template Role**: An abstract interface a collaborator must satisfy; `Bottles` expects its `verse_template` to respond to `lyrics(number)` — any object playing that role is acceptable.
- **Law of Demeter**: Only talk to direct collaborators; chains like `best_friend.pet.preferred_toy.durability` tightly couple the sender to a graph of objects it should not know.
- **Push Creation to the Edges**: Object creation and object use should be separated; factories and constructors belong at the boundary, not inside business logic methods.

## Mental Models
- **Uncertainty about the future is not a license to guess; it's a directive to decouple.** You cannot predict where change will arrive, so loosen coupling everywhere rather than speculatively adding one specific feature.
- **One fix, multiple symptoms**: When three concerns about a method (blank line, class name reference, single-use conversion) all point at the same underlying design issue, one refactoring fixes all three.
- **Concretion → Role**: The progression from `BottleNumber.for(number)` hard-coded in `#lyrics` → `bottle_number` injected at initialization → `verse_template` injected into `Bottles` is a single continuous movement away from concretions toward abstract roles.
- **Working code is still improvable**: The precepts apply to already-working code. Adherence adds indirection in the short term but the decoupling dividend compounds as applications change.

## Anti-patterns
- **Instance methods knowing constant names**: `#lyrics` containing `BottleNumber.for(...)` couples the method to a specific class; resist giving instance methods knowledge of concrete class names.
- **Object conversion inside a method that also uses the result**: If a method's only reference to a parameter is to convert it to something else, someone upstream should have done the conversion — inject the already-converted object.
- **Demeter chains**: `a.b.c.d` introduces N layers of coupling; the pain of describing the dependency in words mirrors the fragility of the code.
- **Premature separation of creation and use**: The `BottleVerse.for` / `BottleVerse.lyrics` split (Listing 8.40) is more indirection than current aesthetics require; defer until a change actually demands direct access to the object.

## Code Examples
```ruby
# Before: verse hard-codes lyrics and BottleNumber conversion
class Bottles
  def verse(number)
    bottle_number = BottleNumber.for(number)  # creation mixed with use

    "#{bottle_number} of milk on the wall, ".capitalize +
    "#{bottle_number} of milk.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} of milk on the wall.\n"
  end
end

# After: Bottles delegates to an injected verse_template
class Bottles
  attr_reader :verse_template

  def initialize(verse_template: BottleVerse)
    @verse_template = verse_template
  end

  def verse(number)
    verse_template.lyrics(number)  # knows only the role, not the class
  end
end

# BottleVerse owns the lyrics algorithm; accepts BottleNumber at init
class BottleVerse
  def self.lyrics(number)
    new(BottleNumber.for(number)).lyrics  # creation at class boundary
  end

  attr_reader :bottle_number

  def initialize(bottle_number)
    @bottle_number = bottle_number        # uses the abstraction, not number
  end

  def lyrics
    "#{bottle_number} of milk on the wall, ".capitalize +
    "#{bottle_number} of milk.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} of milk on the wall.\n"
  end
end
```
- **What it demonstrates**: Extract-and-inject separates verse-template creation from use, loosening `Bottles` from the `BottleVerse` concretion so any object responding to `lyrics(number)` can substitute.

## Reference Tables

### When to voluntarily improve working code

| Signal | Action |
|---|---|
| Code is closed to an incoming requirement | Refactor to open it *before* adding the feature |
| Method description contains "and" | Suspect SRP violation; consider extracting |
| Method contains a blank line | Blank Line smell — likely multiple responsibilities |
| Instance method names a concrete class | Seek to inject the abstraction instead |
| Method's only use of a param is to convert it | Move conversion upstream; inject the result |
| Demeter chain present | Missing abstraction — search for the deeper concept |
| Code works and none of the above fire | Walk away; opportunity cost is real |

### Open vs. Closed Decision

| Is the code open to the new requirement? | Next step |
|---|---|
| Yes | Write the new code directly |
| No | Refactor to open it (under green), *then* write new code |

### Five Precepts of a Programming Aesthetic

| # | Precept |
|---|---|
| 1 | Put domain behavior on instances. |
| 2 | Be averse to allowing instance methods to know the names of constants. |
| 3 | Seek to depend on injected abstractions rather than hard-coded concretions. |
| 4 | Push object creation to the edges; expect objects to be created in one place and used in another. |
| 5 | Avoid Demeter violations; use the temptation to create them as a spur to search for deeper abstractions. |

## Key Takeaways
1. Consult the Open-Closed Flowchart before every new requirement — refactor to open first, then add the feature.
2. When a new requirement needs to *vary* a behavior, extract that behavior into its own class and inject it as a dependency.
3. A vague feeling that code is wrong only becomes part of your aesthetic once you can articulate *why* in words.
4. Voluntarily improving working code has opportunity cost — apply the five precepts, but do so judiciously; the precepts are guidelines, not hard rules.
5. Uncertainty about the future is not a license to speculate; it is a directive to decouple everything so you can adapt to whatever arrives.
6. Multiple symptoms (blank line, class-name reference, parameter-only-converted) often trace to one design issue; one refactoring fixes all.
7. The practical effect of the five precepts is looser coupling — short-term indirection, long-term adaptability.

## Connects To
- **Ch 3**: Open-Closed Flowchart first introduced — Ch 8 applies it to a real incoming requirement.
- **Ch 7**: Factory pattern (`BottleNumber.for`) established — Ch 8 observes that even a factory reference inside `#lyrics` is a concretion worth removing.
- **Ch 5–6**: Dependency injection and polymorphism via `BottleNumber` hierarchy — Ch 8 extends the same pattern to `BottleVerse` and the verse-template role.
- **Ch 9**: Tests are reorganized to reflect the new class boundaries established here; `BottleVerseTest` and role tests follow directly from the extract-and-inject of `BottleVerse`.
