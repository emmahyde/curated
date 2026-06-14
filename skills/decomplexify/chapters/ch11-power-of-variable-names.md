# Chapter 11: The Power of Variable Names

## Core Idea
A variable's name is its definition — a good name fully describes the entity the variable represents, making the code self-documenting and eliminating the need to look elsewhere to understand what a variable does.

## Frameworks Introduced
- **Optimal Name Length**: Names should be long enough to be fully descriptive but short enough to be typed and read easily; 10–16 characters is a reasonable average target for non-trivial variables.
  - When to use: Calibrate length by scope — longer names for global/rarely-used variables, shorter for local/loop variables.
  - How: Longer names for global, rarely used, or module-level variables; single letters or very short names only for loop indexes (i, j) or trivial temporaries.
- **Computed-Value Qualifiers**: When a variable holds a computed result (total, average, max, min, count), place the qualifying word at the end of the name.
  - When to use: Any variable whose name combines a base concept with a computation type.
  - How: Use `revenueTotal`, `expenseAverage`, `customerCount` rather than `totalRevenue`, `averageExpense`, `countCustomer`; exception: `Num` prefix for count (numCustomers).
- **Standardized Prefixes (Hungarian-style UDT + semantic prefix)**: Terse, consistent prefixes encode type and semantic role; composed of a User-Defined Type (UDT) abbreviation followed by a semantic prefix.
  - When to use: Large C/C++ codebases or environments where type information is otherwise not visible at point of use.
  - How: Define a UDT abbreviation table (e.g., `wn` = window, `pa` = paragraph) and semantic prefixes (e.g., `i` = index, `c` = count, `p` = pointer); combine as `ipaActiveDocument`.
- **Naming Conventions (language-specific)**: Formalized rules for capitalization, separators, and scope indicators that the whole team follows.
  - When to use: Any project with more than one contributor, or any project expected to live longer than a sprint.
  - How: C — all_lowercase with underscore separators, ALL_CAPS for macros; C++ — mixed case for types, initial lowercase for variables; Java — lowerCamelCase for variables/methods, UpperCamelCase for classes; VB — `m_` prefix for class members, `g_` for globals, ALL_CAPS for constants.

## Key Concepts
- **Self-Documenting Name**: A name that is a full, unambiguous description of the entity — the ideal is that the name makes comments unnecessary.
- **Computed-Value Qualifier**: A suffix or prefix indicating the kind of computation (`Total`, `Average`, `Max`, `Min`, `Count`); should be placed consistently (typically at the end).
- **Loop Variable**: An index used within a small, tightly scoped loop; acceptable to use single letters (`i`, `j`, `k`) only when the scope is very short and the meaning is obvious.
- **Boolean Variable Name**: Should imply `true`/`false` unambiguously; use forms like `isDone`, `isFound`, `isError`, `wasProcessed` — avoid negated names like `notDone`.
- **Enumerated Type Name**: Should include a category prefix or suffix to prevent namespace collisions and clarify membership, e.g., `Color_Red`, `Country_France`.
- **Named Constant**: Should be named for the abstract concept it represents, not the numeric value — `MAXIMUM_EMPLOYEES` not `100`.
- **UDT Abbreviation**: In standardized prefix schemes, a short token encoding the semantic type of the variable (e.g., `wn` = window, `pa` = paragraph).
- **Semantic Prefix**: In standardized prefix schemes, a short token encoding the role of the variable within its type (e.g., `i` = index, `c` = count, `p` = pointer, `a` = array).
- **Abbreviation**: A shortened form of a word used in a name; should be created by a consistent algorithm (e.g., remove vowels, or use first N characters) and documented in a translation table.

## Mental Models
- Think of a variable name as the answer to "what is this?" — if the name forces you to look at context to answer, it is too short or too vague.
- Use the computed-value qualifier position rule as a consistency anchor: all totals end in `Total`, all counts end in `Count` — scanning a list of names then groups related variables visually.
- Think of naming conventions as team contracts, not personal style: the value is uniformity, not aesthetic perfection; any consistent convention beats an inconsistent "better" one.
- For loop variables: single-letter names are acceptable only when the loop body is short enough to fit on screen — the moment you can't see the declaration from the use, the name is too short.

## Anti-patterns
- **Meaningless names** (`x`, `temp`, `data`, `value`): Provide no information about purpose; `temp` is especially pernicious because it signals "this doesn't matter" when it often does.
- **Similar-sounding names** (`clientRecs` vs `clientReps`, `input` vs `inputVal`): Near-homonyms cause misreads and copy-paste errors; never use names that differ by only one or two characters in the same scope.
- **Misspelled names**: A misspelled name that compiles is indistinguishable from a new variable; misspellings also break `grep`-based searches.
- **Names with numerals** (`total1`, `total2`): Almost always a symptom of a missing array or struct; use meaningful differentiators instead.
- **Negated boolean names** (`notDone`, `isNotError`): Forces a double-negative read (`if (!notDone)`) — use positive forms instead.
- **Purely numeric or abbreviated names without a translation table**: Short names that are undocumented force every reader to reverse-engineer the abbreviation logic.

## Key Takeaways
1. The ideal name fully describes the entity in the problem domain — the longer that takes, the more it signals the variable's concept needs clarification.
2. Use computed-value qualifiers (`Total`, `Average`, `Count`, `Max`, `Min`) consistently and at a fixed position (typically the end) in every name.
3. Boolean variable names should be positive and clearly true/false: `isDone`, `isFound`, `wasProcessed`.
4. Enumerated type members should include a category prefix/suffix to prevent collisions and clarify group membership.
5. Named constants should encode the abstract concept, not the number — constants change; their meaning should not.
6. Naming conventions are team contracts; pick one and apply it uniformly rather than debating which is theoretically best.
7. Short names (single letters, cryptic abbreviations) are acceptable only in very limited scopes (a 3-line loop) or when the convention is universally understood (`i` for index).

## Connects To
- **Ch10**: Scope and live time inform name length — wider scope and longer life justify longer, more descriptive names.
- **Ch12**: Named constants are covered in depth; naming rules for enums, booleans, and type aliases extend the frameworks here.
- **Ch31**: Formatting data declarations — how names appear in source layout reinforces or undermines the naming conventions from this chapter.
- **Ch32**: Commenting data declarations — when names are not sufficient, comments pick up the slack; good names reduce comment burden.
