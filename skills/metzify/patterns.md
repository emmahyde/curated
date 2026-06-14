# Patterns & Techniques — 99 Bottles of OOP

The book is one long worked refactoring. These are its reusable techniques, in roughly the order you apply them.

## Reach Shameless Green First
**When to use**: starting any new feature or new code.
**How**: write the simplest code that passes the tests; tolerate duplication; name nothing speculatively; use `case` over a tangle of `if/elsif` when branching on one value.
**Trade-offs**: feels embarrassingly duplicative and "not OO"; correct anyway when nothing changes yet — it's cheaper to manage duplication than to recover from a wrong abstraction.

## Green Bar Patterns (getting to green)
**When to use**: driving code to passing tests under Red/Green/Refactor.
**How**: *Fake It* — hard-code the return value, generalize as more tests arrive. *Obvious Implementation* — jump to the answer only when it's small and certain. *Triangulate* — add a second/third concrete example to force the abstraction.
**Trade-offs**: Fake It feels slow but keeps steps tiny and safe; Obvious Implementation risks over-reaching.

## The Flocking Rules (finding abstractions)
**When to use**: turning duplicative concrete code into the right abstraction.
**How**: 1) select the things most alike; 2) find the smallest difference between them; 3) make the simplest change to remove that difference. Change one line at a time; run tests after each; if red, undo and make a better change.
**Trade-offs**: feels glacially incremental, but converges on correct abstractions without big-bang risk.

## Gradual Cutover (changing a method signature safely)
**When to use**: adding a required argument that has many existing senders.
**How**: add the parameter with a sentinel default (`def m(arg = :FIXME)`), wire the new logic, update senders one at a time keeping tests green, then delete the default.
**Trade-offs**: more steps than a single edit, but never leaves the suite red.

## Horizontal Refactoring (collapsing branches)
**When to use**: parallel `case`/`if` branches that differ only in specific values.
**How**: find the smallest difference → name the concept → extract a method → replace the literal with a message send → delete the now-identical branch → repeat. Finish the horizontal sweep before chasing any vertical tangent.
**Trade-offs**: tolerates temporary ugliness across branches in exchange for a clean final collapse.

## Name From Responsibilities / Column-Header Naming
**When to use**: naming an extracted method or concept.
**How**: describe what the method *returns* or *means* (not what it does now); build a Number→Value table and ask "what would the column header be?" — that name sits one level of abstraction above the instances, in domain language (`beverage`, not `milk`).
**Trade-offs**: harder up front; protects the name from implementation changes.

## Extract Class (curing Primitive Obsession)
**When to use**: several methods share the same argument name, shape, and conditional structure around a primitive.
**How**: create the new class; *copy* methods in first, *wire* senders second, *delete* the old code third — keeping tests green after every line. To drop an argument: rename it `delete_me = nil`, update senders, then delete it.
**Trade-offs**: more objects (often hundreds) — almost always fine; treat object creation as free until profiling says otherwise.

## Replace Conditional with Polymorphism
**When to use**: a class dominated by identically-shaped conditionals on the same value (Switch Statement smell).
**How**: 1) create an empty subclass for the special value; 2) copy the method into it; 3) reduce the subclass to the true-branch body; 4) reduce the superclass to the false-branch body; 5) create/update the factory; 6) repeat per method and per value.
**Trade-offs**: more classes; in return, conditionals vanish and the code becomes open to new variants.

## Factory (manufacturing the right object)
**When to use**: selecting among polymorphic role-players.
**How**: choose a point on the Factory Continuum (see cheatsheet) — from a simple `case`, through metaprogrammed `const_get` conventions and key/value hashes, to a `handles?`-dispersed list, to self-registering candidates, to `inherited`-hook auto-registration. Push creation to the edges of the system.
**Trade-offs**: openness vs. simplicity vs. coupling — the continuum is the decision.

## Extract-and-Inject (varying behavior)
**When to use**: a new requirement needs to vary an existing behavior.
**How**: extract the behavior into a new class (a Role) and inject it via a keyword argument with a sensible default. If a method's only use of a parameter is converting it, move the conversion upstream and inject the result.
**Trade-offs**: introduces a seam and an abstraction; pays off when the variation is real.

## Tests-Reveal-Design (testing the result)
**When to use**: throughout, and especially when a test is hard to write.
**How**: a hard test is a design smell — loosen coupling in the code rather than patch the test. Test behavior, not implementation. Choose test scope by *visibility*: injected (visible) dependencies get a fake (`SimpleVerseFake`); internally-created (invisible) ones are tested through their enclosing public unit. Omit a class's own unit test only when it is small + simple + invisible + single-context (all four).
**Trade-offs**: requires judgment over a blanket "test everything" rule, but yields a parsimonious, intention-revealing suite.
