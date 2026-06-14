# Cheatsheet — 99 Bottles of OOP

## The Whole Method, in One Arc
Shameless Green → wait for change → open the code (Flocking Rules + Horizontal Refactoring) → separate responsibilities (Extract Class) → replace conditionals with polymorphism → add the feature (now trivial) → choose a Factory → reap design benefits in the tests.

## The Flocking Rules (memorize these)
1. Select the things that are **most alike**.
2. Find the **smallest difference** between them.
3. Make the **simplest change** to remove that difference.
- Change one line at a time. Run tests after every change. If red, undo and make a better change.

## Open/Closed Workflow
"Open for extension, closed for modification." When a new requirement arrives:
1. First **refactor existing code to be open** — do NOT add the feature yet.
2. *Then* add the new code (it should be near-trivial).
Never conflate these two operations. (Kent Beck: "Make the change easy, then make the easy change.")

## When to Voluntarily Improve Working Code
1. Code is **closed** to an incoming requirement → open it first.
2. Method description contains **"and"** → suspected SRP violation.
3. Method contains a **blank line** → Blank Line smell, likely multiple responsibilities.
4. An instance method **names a concrete class** → inject the abstraction instead.
5. A method's **only use of a param is converting it** → move conversion upstream.
6. A **Demeter chain** is present → a missing abstraction; find the deeper concept.
7. Works and none of the above fire → **walk away**. Opportunity cost is real.

## Judging Code (facts over opinion)
Good code = highest value for lowest cost. Ask: (1) hard to write? (2) hard to understand? (3) expensive to change? — #2 always applies. Metrics for facts: SLOC (volume), Cyclomatic Complexity (paths + min tests), ABC via Flog (cognitive size).

## DRY Decision (when to remove duplication)
- Does removing it make code **harder to understand**? What's the **future cost of waiting**? **How soon** will more information arrive?
- Tolerate duplication when only ~2 examples exist and the abstraction is unclear. Duplication is cheaper than the wrong abstraction.

## Naming Rule
Name methods after **what they mean** (domain concept), never after what they do now. The right name sits one level of abstraction above the instances — the "column header" of a Number→Value table (`beverage`, not `milk`).

## Factory Continuum (least → most open)
| # | Style | Open? | Use when |
|---|-------|-------|----------|
| 1 | `case` statement | closed | variants stable and rare; simplest to read |
| 2 | Metaprogrammed convention (`const_get`) | open | a naming convention can be enforced |
| 3 | Key/value hash | closed, externalizable | class names arbitrary; data may live outside code |
| 4 | Dispersed `handles?` list | closed list, candidate-owned logic | choosing logic is complex / co-varies with class |
| 5 | Self-registering registry | open | arbitrary names + openness needed |
| 6 | `inherited` auto-registration | most open | all role-players use inheritance |

## Testing (reap the design benefits)
- A **hard-to-write test is a design smell** → fix the code, not the test.
- Test **behavior, not implementation**. Never assert one method equals another (Echo-Chamber).
- Default: every class gets a unit test. **Omit only if** small + simple + invisible + single-context (all four).
- **Visible** (injected) dependency → test with a fake. **Invisible** (internal) dependency → test through the enclosing unit.
- The **factory always gets its own test** — test the mapping, not the objects it makes.
- 100% coverage = all code exercised, not all methods personally tested.

## Refactoring Discipline (always)
Never refactor under red. Keep tests green after every single line. Pause only at Stable Landing Points. Copy before wiring; wire before deleting.
