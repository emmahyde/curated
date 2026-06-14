# Chapter 14: Organizing Straight-Line Code

## Core Idea
The fundamental challenge in straight-line code is making dependencies between statements explicit and obvious; when no ordering dependency exists, the guiding principle is proximity — keep related statements together.

## Frameworks Introduced
- **Sequential dependencies**: The principle that some statements must execute in a specific order because later statements depend on earlier ones; making these dependencies visible is the primary job of code organization. When to use: whenever one statement's correctness depends on a prior statement having executed. How: use routine names that imply ordering (e.g., `ComputeMonthly` before `ComputeAnnual`), arrange parameters to reflect flow, add comments documenting ordering requirements, and for critical paths use housekeeping variables (e.g., `isExpenseDataInitialized`) with assertions or error-checking.
- **Principle of Proximity**: When statements have no execution-order dependency, order them so related statements are as close together as possible. When to use: any time you are ordering statements or blocks that lack strict ordering requirements. How: group statements that operate on the same data, perform similar tasks, or logically belong together; test grouping by drawing boxes around related statements on a printout — boxes should not overlap.

## Key Concepts
- **Sequential dependency**: A relationship where one statement requires a prior statement to have already executed correctly.
- **Housekeeping variable**: A status variable (e.g., `isInitialized`) used to document and enforce critical ordering dependencies at runtime.
- **Principle of Proximity**: Keep related actions together; the measure is how far a reader's eye must travel between related pieces of code.
- **Top-to-bottom reading order**: Code organized so that execution flow matches the reading direction, reducing the need for a reader to jump around.
- **Localization**: Grouping all references to a variable or object close together, minimizing the "live time" of the variable and making decomposition into routines more apparent.

## Mental Models
- Think of sequential dependencies as a directed graph: draw an arrow from every statement to each statement that depends on it; code order must respect the arrows.
- Use the "box test": print your code and draw boxes around related statement groups — overlapping boxes signal poor grouping.
- Use proximity as a readability proxy: if you cannot understand a statement without scrolling or searching elsewhere, the related code is too far away.
- Think of localization as a decomposition hint: if all references to an object are already close together, that cluster is a candidate for its own routine.

## Anti-patterns
- **Hidden ordering dependencies**: Routines named generically that silently require prior routines to have run — the dependency is invisible until the code breaks.
- **Scattered references**: Declaring multiple objects at the top of a routine then interleaving operations on all of them throughout the routine, forcing the reader to track multiple threads simultaneously.
- **Overusing housekeeping variables**: Adding status flags to document dependencies introduces new variables and new error paths; use only when the dependency is critical and non-obvious.

## Key Takeaways
1. Ordering dependencies are the strongest constraint on straight-line code organization; make them visible in routine names, parameter lists, and comments.
2. When no ordering dependency exists, apply the Principle of Proximity: group related statements together and keep all references to a data structure close to each other.
3. Code that reads top-to-bottom is easier to maintain than code that requires jumping around; reorganize whenever a reader must search for related information.
4. Use housekeeping/status variables to document critical ordering dependencies only when the cost of a missed dependency outweighs the complexity they add.
5. Good grouping is a decomposition indicator: tightly grouped related statements signal a potential routine boundary.

## Connects To
- **Ch15**: Conditionals introduce branching that can scatter related code; the same proximity principle applies within branches.
- **Ch16**: Loop bodies require attention to initialization and statement ordering — sequential dependency principles apply inside loops.
- **Ch10**: Variable scope and live time connect directly to the proximity principle; shorter live time means less code to hold in mind.
- **Ch19**: General control issues including structured programming provide the theoretical foundation for why sequential order matters.
