# Chapter 26: Code-Tuning Techniques

## Core Idea
Code-tuning techniques are source-level transformations applied to confirmed performance bottlenecks after profiling; they span loops, data structures, expressions, and routines, and every technique must be measured because results vary dramatically across languages, compilers, and platforms — an optimization that saves 50% in one environment can be neutral or harmful in another.

## Frameworks Introduced
- **Loop Tuning Techniques** (highest-leverage category; loops dominate execution time):
  - *Unswitching*: Move an if-test that does not change inside a loop to outside it, duplicating the loop body for each branch. Eliminates redundant predicate evaluation on every iteration.
  - *Jamming (loop fusion)*: Combine two loops that traverse the same range into one, reducing loop overhead and improving cache locality.
  - *Unrolling*: Expand a loop body to process multiple elements per iteration, reducing loop-control overhead; full unrolling replaces the loop entirely with sequential statements.
  - *Minimizing work inside loops*: Hoist loop-invariant computations, array-base calculations, and repeated function calls out of the loop body.
  - *Sentinels*: Place a sentinel value at the end of a search array so the termination test can be eliminated from the inner loop.
  - *Busiest loop on the inside*: In nested loops, put the loop with the most iterations innermost to minimize outer-loop overhead.
  - When to use: After profiling confirms the loop is a bottleneck; apply one technique at a time and measure after each.

- **Data Transformation Techniques**:
  - *Integer instead of floating-point*: Replace floating-point variables with integers where precision allows; integer operations are 2–5× faster on many platforms.
  - *Lookup tables (table-driven substitution)*: Replace complex conditional logic with a precomputed table indexed by input; reduces branching overhead and often improves maintainability.
  - *Lazy evaluation*: Defer computation until the result is actually needed; avoids computing results that are never used.
  - *Precomputing results*: Compute values at initialization or compile time rather than at runtime inside hot loops.
  - *Eliminating common subexpressions*: Assign a repeated expensive computation to a variable and reference the variable; compiler may do this automatically but manual elimination is reliable.
  - When to use: For expressions or data accesses confirmed as hot by profiling.

- **Expression Tuning Techniques**:
  - *Strength reduction*: Replace an expensive operation with a cheaper equivalent (e.g., replace exponentiation inside a loop with repeated multiplication; replace multiplication with addition where an increment suffices).
  - *Short-circuit evaluation ordering*: In boolean expressions, order conditions so the cheapest or most frequently false/true condition is evaluated first, allowing early exit.
  - *Stop testing when the answer is known*: Order case-statement or if-else chains by frequency so the most common case exits earliest.
  - When to use: In confirmed hot expressions; measure before and after each change.

- **Routine and System Techniques**:
  - *Inlining routines*: Eliminate call overhead by expanding a small, frequently called routine in place; weigh against loss of encapsulation.
  - *Translating key routines to a low-level language*: Rewrite the confirmed hottest inner loops in assembly or C from a higher-level language as a last resort.
  - *Compile-time initialization*: Initialize data structures at compile time rather than at runtime startup.

## Key Concepts
- **Measure before and after**: Every code-tuning change must be validated by measurement; the effect of any given technique is unpredictable without it.
- **Results vary by language and platform**: A technique that saves 50% in C++ may save 0% in Java or even degrade performance; benchmarks from one environment do not transfer.
- **Loop overhead**: The cost of incrementing a counter, testing a termination condition, and branching; small per iteration but significant when multiplied by millions of iterations.
- **Strength reduction**: Replacing an expensive arithmetic operation (division, exponentiation, multiplication) with a cheaper one (subtraction, addition) that produces the same result within the loop's mathematical context.
- **Cache locality**: Accessing memory in sequential, contiguous patterns exploits CPU cache lines; row-major vs. column-major array traversal can produce order-of-magnitude differences on large arrays.
- **First optimization is often not the best**: After finding one working optimization, keep searching; the first found is frequently not the most effective; multiple iterations are required.

## Mental Models
- Think of code tuning as trading readability and maintainability for measured performance gains — the tradeoff is only worth making when measurement confirms the gain is real and the requirement demands it.
- Use the checklist as a menu, not a prescription: apply techniques from the checklist to confirmed bottlenecks rather than speculatively to all code.
- Think of loop body as the unit of optimization cost: every instruction executed N-million times has N-million times the cost of the same instruction executed once; this asymmetry justifies disproportionate attention to inner-loop bodies.
- Measure with the same mindset as a scientist: form a hypothesis (this change will save X%), run the experiment, record the result, and be willing to be wrong.

## Anti-patterns
- **Unmeasured tuning**: Applying a technique because it "should" be faster without profiling first or measuring after; the readability cost is certain, the performance benefit is speculative.
- **Applying multiple techniques simultaneously**: Changing more than one thing at once makes it impossible to attribute the result to a specific technique; apply and measure one at a time.
- **Treating benchmark results as portable**: Using performance data from one language/compiler/platform to justify a change in another; results vary dramatically and must be re-measured in the actual target environment.
- **Inlining indiscriminately**: Eliminating all small routines for speed destroys modularity and readability; inline only what profiling confirms is a call-overhead bottleneck.

## Key Takeaways
1. Every tuning technique must be measured in the actual target environment — results vary so widely across languages, compilers, and hardware that no technique can be assumed to help.
2. Loops are the highest-leverage target; unswitching, jamming, unrolling, sentinel, and minimizing inner-loop work are the most broadly applicable techniques.
3. Strength reduction — replacing expensive operations with cheaper mathematical equivalents — is one of the most reliable loop-body optimizations.
4. Data transformation (integer for float, lookup tables, precomputed results, lazy evaluation) addresses data-access and computation overhead outside pure loop structure.
5. The first optimization found is often not the best; iterate through alternatives and measure each before committing.
6. Code tuning invariably trades readability and maintainability for performance; only make that trade when measurement confirms the gain is real and the requirement demands it.
7. Ch25 strategy governs Ch26 techniques: never apply these techniques without the measurement discipline and profiling prerequisite established in Ch25.

## Connects To
- **Ch25**: The strategy chapter; Ch26 techniques are only valid when applied under Ch25's measure-first, profile-confirmed discipline.
- **Ch24**: Refactoring and code tuning move in opposite directions — refactoring sacrifices potential performance for structure; tuning sacrifices structure for performance; they are never the same activity.
- **Ch5**: High-level design (algorithm and data-structure selection) yields larger performance gains than any technique in this chapter; apply Ch26 only after design-level options are exhausted.
