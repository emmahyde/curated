# Chapter 3: Unearthing Concepts

## Core Idea
New requirements raise the bar on code quality — use them as license to refactor. The Flocking Rules provide a systematic, test-driven method for surfacing hidden abstractions by iteratively reducing difference to sameness.

## Frameworks Introduced
- **Open/Closed Principle (OCP)**: Objects should be open for extension, but closed for modification.
  - When to use: When a new requirement arrives and the existing code cannot accommodate it without editing existing branches/conditionals.
  - How: First refactor existing code until it is "open" (new requirement can be met by adding code only); then add the new code. Never conflate these two operations.

- **The Flocking Rules**: A three-rule iterative algorithm for finding abstractions by reducing difference.
  1. Select the things that are most alike.
  2. Find the smallest difference between them.
  3. Make the simplest change to remove that difference.
  - Sub-steps for rule 3: a. parse the new code; b. parse and execute it; c. parse, execute and use its result; d. delete unused code.
  - Corollaries: change only one line at a time; run tests after every change; if tests go red, undo and make a better change.
  - When to use: When you cannot see the abstraction in advance; trust the rules and it will emerge automatically.

- **Gradual Cutover Refactoring** (Kerievsky): Keep code releasable during a refactoring by switching senders over incrementally, using a defaulted `:FIXME` argument as a temporary shim.
  - When to use: When adding a required argument to a method that has many senders that cannot all be updated at once.
  - How: Add `def method(arg=:FIXME)`, update logic to use `arg`, update senders one at a time, then delete the default.

## Key Concepts
- **Code Smell**: A named flaw in code structure (per Martin Fowler's *Refactoring*) for which a curative refactoring recipe exists. Smells are the compass when you don't know how to achieve openness.
- **Duplicated Code**: Smell — the same or near-identical strings/logic appearing in multiple branches; most tractable starting point.
- **Switch Statements**: Smell — a `case` conditional that must grow a new branch for every new variant; conditionals breed.
- **Refactoring**: "Changing a software system in such a way that it does not alter the external behavior of the code yet improves its internal structure" (Fowler). Not the same as adding features.
- **Abstraction**: An underlying concept common to multiple concrete examples. Found by naming the category that is one level of abstraction higher than its instances.
- **Horizontal vs. Vertical Work**: Horizontal — staying focused on making two specific cases identical (completing the current refactoring path). Vertical — veering into other parts of the code. Finish the horizontal path before going vertical.
- **re-hack-toring**: Making many simultaneous changes without small steps and green tests between each — the failure mode of big-bang refactoring.
- **:FIXME default**: A deliberately wrong sentinel default value that signals a temporary shim must be cleaned up after gradual cutover is complete.
- **Naming rule**: The name of a thing should be one level of abstraction higher than the thing itself. Use domain language, not implementation names (not "bottle", not "unit" — "container").

## Mental Models
- **Difference over sameness**: When examining code, difference is more informative than sameness. Sameness is easier to spot; difference points to the smaller abstraction hiding inside the larger one.
- **Spreadsheet column header test**: List concrete instances as rows. The column header that fits all rows — one level above the instances — is the right name. E.g., "bottle/six-pack/bottles" → column header = "container."
- **Emergent abstraction**: You do not need to know the abstraction in advance. If you follow the Flocking Rules mechanically, the abstraction will appear. Intention-crafted solutions are not the only path.
- **Tests as wall at your back**: Safe refactoring requires green tests throughout. If tests fail during a refactoring: either you broke something (undo) or the tests assert implementation (fix the tests first, then refactor).

## Anti-patterns
- **Compounding conditionals**: Adding a new `when` branch for each new requirement. Conditionals breed — four branches become six, then more. Signals that the code is not open.
- **Inferring unstated requirements**: Implementing "replace all multiples of 6" when the requirement says only "output '1 six-pack' for 6 bottles." Write the minimum necessary code; clarify first.
- **Jumping to the hard problem**: Tackling the most interesting/difficult difference first, bypassing easy problems. Easy solutions sometimes transmute hard problems into easy ones.
- **Big-bang refactoring (re-hack-toring)**: Changing many things simultaneously, running tests only at the end. Results in an ocean of red with no clear cause.

## Code Examples
```ruby
# Step-by-step gradual cutover: adding container method

# Step 1 — parse only (rule 3a)
def container
end

# Step 2 — return usable default value (rule 3b)
def container
  "bottles"
end

# Step 3 — add optional arg with :FIXME sentinel (Gradual Cutover)
def container(number=:FIXME)
  "bottles"
end

# Step 4 — add conditional logic (rule 3c); :FIXME routes to false branch
def container(number=:FIXME)
  if number == 1
    "bottle"
  else
    "bottles"
  end
end

# Step 5 — update else sender to pass argument
"#{number-1} #{container(number-1)} of milk on the wall.\n"

# Step 6 — update when 2 sender; now both branches are identical → delete when 2

# Step 7 — remove :FIXME default; all senders pass the arg
def container(number)
  if number == 1
    "bottle"
  else
    "bottles"
  end
end
```
- **What it demonstrates**: The complete 7-stage gradual cutover refactoring of a single extracted method, one parseable change at a time.

## Reference Tables

| Smell Identified | Curative Action | Result |
|---|---|---|
| Duplicated Code (verse branches) | Apply Flocking Rules, extract differing concept | `container` method |
| Switch Statements (case) | Reduce branches by subsuming identical cases | `when 2` deleted |
| Hard-coded literals in `when 2` | Replace with `#{number}`, `#{number-1}` | Logical identity with `else` |

| Flocking Rule | Action |
|---|---|
| 1. Most alike | Select `when 2` and `else` (only differ in "bottle" vs "bottles") |
| 2. Smallest difference | Scan left-to-right; numbers first (easy), then "bottle/bottles" (interesting) |
| 3. Simplest change | Extract `container` method via gradual cutover, one line at a time |

## Key Takeaways
1. Let new requirements drive refactoring — they reveal exactly how the code should have been arranged.
2. Apply OCP: separate "make code open" (refactoring) from "add the feature" (new code). Never do both at once.
3. When you cannot see the path to openness, follow code smells. Remove them one at a time; openness will appear.
4. The Flocking Rules are: (1) Select most alike, (2) Find smallest difference, (3) Make simplest change to remove it.
5. Change one line at a time; run tests after every change; undo immediately on red.
6. Name extracted concepts one level of abstraction above their instances, in domain language.
7. Solving easy sub-problems first can eliminate hard ones — don't skip to the "interesting" difference.

## Connects To
- **Ch 1**: "Concretely Abstract" section warned against naming methods after their current implementation (e.g., "bottle") — the `container` naming decision applies that lesson directly.
- **Ch 2**: Shameless Green was acceptable when no change was required; this chapter is the moment its cost comes due.
- **Ch 4**: The same Flocking Rules are applied to the remaining `when 1` and `when 0` cases, extracting further abstractions (goes faster now that the pattern is established).
