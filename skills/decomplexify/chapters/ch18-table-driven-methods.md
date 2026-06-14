# Chapter 18: Table-Driven Methods

## Core Idea
Table-driven methods replace complicated logic and inheritance structures by encoding knowledge in data rather than in code — making the program easier to modify because changing behavior means changing data, not rewriting logic.

## Frameworks Introduced
- **Direct access**: Accessing a lookup table using the data value directly as an index (or with a simple transformation).
  - When to use: When the key has a small, dense, integer-like range (e.g., month 1–12, day-of-week 0–6, character type 0–127).
  - How: Create an array indexed by the key value; a single array lookup replaces an if-then-else chain or switch. If the raw key needs minor transformation (e.g., month-1 to get 0-based index), apply the transformation in a single access-key routine.
- **Indexed access**: Accessing a main lookup table through an intermediate index array.
  - When to use: When the key range is sparse (large number of possible values, few actual entries) and direct access would waste too much space (e.g., part numbers ranging 0–9999 with only 100 distinct parts).
  - How: Create a small dense index array whose values are indexes into the main table; look up the index first, then use it to access the main table. Encapsulate the two-step lookup in a single routine to avoid spreading index arithmetic throughout the codebase.
- **Stair-step access**: Accessing a table by finding the "step" whose upper bound first exceeds the input value.
  - When to use: When entries in the table are valid for ranges of data rather than discrete points (e.g., grade boundaries: 0–50=F, 51–65=D, …).
  - How: Store the upper limit of each range in one array and the corresponding result in a parallel array; iterate until the input falls below a range limit. Handle boundary endpoints carefully (especially whether the range is inclusive or exclusive at each end).

## Key Concepts
- **Table-driven method**: A design approach that replaces procedural logic (if-then-else chains, switch statements, inheritance hierarchies) with a data structure (array, hash, file) that maps inputs to outputs.
- **Direct access**: A table lookup where the key indexes directly into the table with at most a simple mathematical transformation.
- **Indexed access**: A two-level lookup where a sparse key is first resolved through an index array to produce a compact table key.
- **Stair-step access**: A range-based lookup that steps through upper-bound limits to categorize a continuous input value.
- **Knowledge in data vs. logic**: The architectural principle that encoding decisions in tables externalizes the knowledge from the program's control flow, making it easier to change without code modifications.
- **Access-key routine**: A routine that encapsulates the index calculation for a table, so the calculation logic is not duplicated throughout the codebase.

## Mental Models
- Use table-driven methods when you find yourself writing long if-then-else-if chains or switch statements that dispatch on a single variable — the chain is likely a table in disguise.
- Think of a table as "data instead of logic": logic embedded in if-tests is hard to modify; data in an array can be read from a file, changed at run time, or updated without touching code.
- Use direct access when the key fits in a small integer array; indexed access when the key space is huge but sparse; stair-step when inputs are continuous and results change at thresholds.
- When a table stores actions rather than data (references to routines), it becomes a dispatch table — an alternative to deep inheritance hierarchies.

## Anti-patterns
- **Duplicate access-key calculation**: Computing the index transformation in multiple places rather than in a single access-key routine — when the transformation changes, every site must be updated.
- **Complicated inheritance for simple dispatch**: Using a deep class hierarchy to dispatch on a small set of cases when a table with function references would be simpler and more maintainable.
- **Ignoring the access-method decision**: Defaulting to direct access even when the key space is huge and sparse, wasting memory on a mostly-empty array.
- **Hard-coded table data**: Embedding table values in source code when the values could be read from an external file, preventing data changes without recompilation.

## Key Takeaways
1. Table-driven methods are an alternative to complicated logic and complicated inheritance structures; when logic is confusing, ask whether a lookup table could replace it.
2. The two key design questions are: (a) how to access the table (direct, indexed, or stair-step) and (b) what to store in the table (data values or action references/routine pointers).
3. Direct access is simplest; use indexed access when the key space is too large to allocate directly; use stair-step for range-based categorization.
4. Encapsulate access-key calculations in a single routine to prevent duplication and ease future changes to the access scheme.
5. Storing table data externally (file, database) maximizes flexibility: behavior can change without recompiling.

## Connects To
- **Ch15**: Table-driven methods replace complicated if-then-else-if chains and case statements.
- **Ch19**: Decision tables are recommended for replacing complicated boolean expressions (Section 19.1).
- **Ch16**: Inside-out loop construction is demonstrated using insurance rate table lookups.
- **Ch26**: Precomputed lookup tables are a performance optimization technique (Section 26.4).
