# Chapter 7: Manufacturing Intelligence

## Core Idea
Factories are where conditionals go to die — they isolate the logic that selects which class plays a role into a single tested place, freeing message senders from knowing concrete class names. The chapter traces a continuum of six factory styles, each trading complexity for openness and coupling trade-offs along three dimensions: open/closed, factory-owned vs. candidate-owned choosing logic, and passive vs. self-registering candidates.

## Frameworks Introduced
- **Factory Dimensions Framework**: Every factory varies along three axes — (1) open to new variants or closed, (2) choosing logic owned by factory or by variant, (3) factory locates candidates or candidates volunteer via registry.
  - When to use: When evaluating which factory style fits a situation, map requirements against these three axes before choosing.
  - How: Ask (1) how often new variants appear, (2) whether choosing logic is stable or changes with the chosen class, (3) whether candidates can depend on knowing the factory's name.
- **Factories Are Where Conditionals Go to Die**: Isolating variant-selecting conditionals in a factory loosens coupling between collaborators and lowers the cost of change.
  - When to use: Any time polymorphic role-players exist and something must choose among them.
  - How: Extract the selecting conditional from the message sender; put it in a `self.for` class method; message senders depend only on the role API.

## Key Concepts
- **Factory**: An object (typically a class method) whose sole responsibility is to manufacture the correct role-player for a given situation — it knows how to choose, not what to do.
- **Registry**: A class-level array that records which candidates are eligible to be manufactured; populated at load time, either explicitly or via hooks.
- **`handles?(number)`**: A class-side predicate that each candidate implements to declare whether it should be chosen for a given input; disperses choosing logic into the chosen class.
- **Self-registration**: A pattern where each candidate calls `FactoryClass.register(self)` at class definition time, removing the hard-coded list from the factory.
- **`inherited` hook**: A Ruby callback sent to a parent class whenever a subclass is defined; used to auto-register subclasses without any explicit `register` call in the subclass body.
- **Open factory**: A factory that accommodates new variants without code changes — either via naming convention + metaprogramming, a self-populated registry, or `inherited`.
- **Closed factory**: A factory with a hard-coded list of candidates (case statement or explicit array); simple, but must be updated for every new variant.
- **Procedural vs. OO conditional**: A procedural conditional both selects behavior and supplies it; an OO factory conditional selects a class — separating the choosing from the chosen.
- **Data/algorithm separation**: The key/value hash factory groups `number => Class` data together, separating it from the lookup algorithm; enables externalizing the data (DB, config file) without changing the algorithm.
- **`const_get` metaprogramming**: Ruby method that resolves a string to a constant/class; enables convention-based open factories (`"BottleNumber" + number.to_s`).

## Mental Models
- **Factories vs. Shameless Green conditionals**: Both use `case number`, but Shameless Green produces behavior inline; the factory produces a class name. One is a procedure combining selection and behavior; the other is OO separating them.
- **Betting on stability**: Every dependency choice (explicit class name vs. inherited method, factory-owned list vs. registry) is a bet on which dependency is more stable. Make deliberate bets; track outcomes to improve.
- **Syntax color groupings as OO signal**: In the case-statement factory, colors alternate (topic changes constantly — procedural). In the key/value factory, like colors cluster (data and algorithm separated — more OO).
- **Conditional can-kicking**: Polymorphism eliminates conditionals inside role-player classes but pushes one conditional up the stack — into the factory. Factories don't eliminate conditionals; they consolidate them.

## Anti-patterns
- **Exception-driven flow control**: Using `rescue NameError` to handle missing class lookups (`const_get` factory) is condemned for readability and debuggability — only justified when openness benefit clearly outweighs it.
- **Unreferenced class names**: Metaprogrammed factories construct class names dynamically, making those class names unsearchable in source; risks accidental deletion of "unused" classes.
- **Default class mid-list**: When using a `find` + `handles?` factory, the default (catch-all) class must be last; placing it earlier silently suppresses all subsequent candidates.
- **Ignoring naming-convention violations**: Convention-based factories fail silently when a class uses an unexpected name (e.g., `BottleNumberSix` instead of `BottleNumber6`).

## Code Examples
```ruby
# Auto-registering factory using inherited hook (most evolved style)
class BottleNumber
  def self.for(number)
    registry.find { |candidate| candidate.handles?(number) }.new(number)
  end

  def self.registry
    @registry ||= [BottleNumber]
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  def self.inherited(candidate)
    register(candidate)
  end

  def self.handles?(number)
    true  # default catch-all
  end
end

class BottleNumber0 < BottleNumber
  def self.handles?(number)
    number == 0
  end
  # ...no registration call needed — inherited hook fires automatically
end
```
- **What it demonstrates**: Factory owns registry + registration; subclasses auto-enroll via `inherited`; choosing logic dispersed into `handles?`; factory manufactures instances of classes whose names it never mentions.

## Reference Tables

### Factory Styles Continuum

| Style | How It Selects | Open? | Choosing Logic Owner | Candidate Discovery | Trade-offs |
|---|---|---|---|---|---|
| **Case statement** (Listing 7.1/7.3) | `case number when 0 then BottleNumber0 ...` | Closed | Factory | Hard-coded in factory | Simplest to read; must update on every new variant |
| **Metaprogrammed convention** (Listing 7.4) | `const_get("BottleNumber#{number})` with `rescue NameError` | Open | Factory (via convention) | Convention-based dynamic lookup | Open without changes; class names unsearchable; exception for flow control; silent failures on non-conforming names |
| **Key/value hash** (Listing 7.5/7.7) | `Hash.new(BottleNumber).merge(0=>BN0, 1=>BN1)[number]` | Closed (but data-externalizable) | Factory | Hard-coded in hash | Like case but data separated from algorithm; hash externalizable to DB/config; slightly harder to read |
| **Dispersed choosing logic** (Listing 7.8) | `[BN6,BN1,BN0,BN].find { |c| c.handles?(number) }` | Closed (list still hard-coded) | Candidate (`handles?`) | Hard-coded array in factory | Choosing logic co-located with chosen class; still need to update list; default must be last |
| **Self-registering candidates** (Listing 7.12) | `registry.find { |c| c.handles?(number) }` | Open | Candidate (`handles?`) | Candidates call `BottleNumber.register(self)` at definition | Factory knows nothing about class names; candidates depend on knowing factory name; must remember to add registration call |
| **Auto-registering via `inherited`** (Listing 7.15) | `registry.find { |c| c.handles?(number) }` | Open | Candidate (`handles?`) | `inherited` hook auto-registers all subclasses | Most open; zero manual registration; requires inheritance; factory name stable as a bet; candidates can use any name |

## Key Takeaways
1. Factories isolate the single necessary conditional (selecting a class) so message senders can depend on a role's API rather than concrete class names.
2. Assess factory openness needs realistically — if new variants are rare, a closed case statement is cheaper than an open metaprogrammed one.
3. Move choosing logic into the candidate class (`handles?`) when that logic is complex or changes in lockstep with the candidate's own implementation.
4. Use a registry + self-registration when you need an open factory with arbitrary class names and candidates can tolerate knowing the factory's name.
5. Use the `inherited` hook for the most automatic open factory — zero manual registration, but bets that all role-players will always use inheritance.
6. Every dependency choice is a bet on stability; make bets deliberately and track outcomes to improve future guesses.
7. `Hash.new(default).merge(...)` places the default value prominently at the front — use it when you control the whole hash and the default is semantically important.

## Connects To
- **Ch 6**: Produced the BottleNumber hierarchy this chapter's factories select among; introduced polymorphism as the motivation for needing a factory at all.
- **Ch 8**: Continues from the fully-open auto-registering factory as the stable foundation for the next round of design work.
- **Ch 3 (Shameless Green)**: The procedural conditional that the factory replaces — the contrast between behavior-supplying conditionals and class-selecting conditionals is made explicit here.
