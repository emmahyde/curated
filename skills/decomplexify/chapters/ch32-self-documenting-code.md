# Chapter 32: Self-Documenting Code

## Core Idea
The best documentation lives in the code itself through good naming, structure, and style; comments should add only what code cannot express — intent and summary — never repeat what the code already says.

## Frameworks Introduced

- **Self-Documenting Code**: The practice of writing code so clearly that it largely explains itself, minimizing the need for external documentation and relegating comments to information code genuinely cannot convey.
  - When to use: Always — as the default target for every routine, variable, class, and module.
  - How: Choose expressive names, decompose into small focused routines, use named constants, structure code to mirror the problem domain, and add comments only for intent and summary.

- **Comment Styles / Kinds of Comments** (six-category taxonomy): McConnell classifies comments into: (1) Repeat of the Code — restates what the code does, useless; (2) Explanation of the Code — explains confusing code, acceptable but signals the code should be improved instead; (3) Marker in the Code — TODO/TBD notes, acceptable during development but must never ship; (4) Summary Comments — condense several lines into a sentence, genuinely useful; (5) Intent Comments — explain why, not what; the most valuable kind; (6) Information That Cannot Be Expressed in Code — copyright, version numbers, algorithm citations, Javadoc/Doxygen hooks.
  - When to use: Only categories 4, 5, and 6 are appropriate in completed production code.
  - How: Before writing a comment, ask which category it falls into; if it's category 1 or 2, improve the code instead.

- **Intent Comments**: Comments that explain the programmer's purpose — the "why" behind a decision — rather than summarizing the mechanics of what the code does.
  - When to use: Wherever the code's purpose is not self-evident from its structure and names, or where a deliberate non-obvious choice was made.
  - How: Write at the level of the problem domain ("find the next available seat") rather than the solution level ("increment the counter").

- **The Book Paradigm for Program Documentation**: Structuring source files like a book — file header as preface, classes as chapters, routines as sections, blocks as paragraphs — to guide readers through the code at multiple levels of granularity.
  - When to use: When organizing a source file, choosing where to put file-level and class-level comments.
  - How: Provide a file-level comment describing the module's purpose; provide a class-level comment; provide a routine-level comment for each non-trivial routine; use inline comments sparingly for complex blocks.

## Key Concepts

- **Self-Documenting Code**: Code written so clearly it minimizes the documentation burden; names, structure, and decomposition carry most of the explanatory load.
- **Intent Comment**: A comment explaining why code does something, not what it does; IBM research found that understanding original programmer intent is the hardest maintenance problem.
- **Summary Comment**: A comment that condenses several lines of code into a sentence, helping readers skim without reading every line.
- **Psychological Distance**: The conceptual gap between a variable's name and its meaning. Good naming closes psychological distance; cryptic names widen it.
- **Commenting Efficiency**: Good commenting is not time-consuming; if it is, the style is wrong. A comment style that is hard to maintain will be abandoned or will drift out of sync with the code.
- **Endline Comments**: Comments placed at the end of code lines. Generally discouraged for describing the code (they repeat it); acceptable for flagging unusual decisions or required annotations.
- **Commenting Control Structures**: Describe the intent of each block (`// Process the queue until empty`) rather than restating the loop mechanics.
- **Commenting Routines**: Header comments should state what the routine does, its inputs and outputs, and any preconditions/postconditions — not how it does it (that belongs in the code).
- **Commented-Out Code**: Code left in comments is a maintenance hazard; use version control instead and delete dead code.

## Mental Models

- Use **"good code is its own best documentation"** as the primary rule: if code requires extensive comments, fix the code first.
- Think of **comments as expressing intent** (the "why") while code expresses mechanism (the "what" and "how") — they are complementary, not redundant.
- Use **the newspaper test**: can a reader skim headlines (routine names, block comments) and understand the structure without reading every line? If not, add summary comments at the right level.
- Think of **commenting difficulty as a diagnostic**: if you struggle to comment a routine, you probably don't understand it well enough — that's time well spent regardless of whether you comment.

## Anti-patterns

- **Repeat-of-code comments**: `i++; // increment i` adds zero information and doubles the maintenance burden — every change must be made in two places.
- **Explanation-of-code comments**: If the code is so confusing it needs explanation, the right fix is to rewrite the code to be clearer, not to explain the confusion.
- **Stale comments**: A comment that contradicts the code is actively harmful — it is worse than no comment. Comments that are hard to update will become stale.
- **Marker comments shipped to production**: `// NOT DONE — FIX BEFORE RELEASE` reaching customers is both an embarrassment and a quality failure; standardize a marker string and make it part of the release checklist.
- **Comment-heavy compensation for bad code**: Adding comments to work around poor naming, deep nesting, or unclear logic treats symptoms rather than the disease.
- **Fancy comment formatting**: Decorative boxes or complex alignment styles discourage updates and become outdated immediately; prefer plain styles that are trivial to maintain.

## Key Takeaways

1. Good code is its own best documentation — expressive naming, small routines, and clear structure reduce the comment burden more than any commenting convention.
2. Comments should say what code cannot say about itself: intent (why), summary (what a block accomplishes at a high level), and information that is inherently non-code (licenses, algorithm citations).
3. Repeating-the-code comments are worse than no comments — they double the maintenance cost and diverge the moment the code changes.
4. IBM research showed that understanding original programmer intent is the dominant maintenance challenge; intent comments directly address the hardest problem in maintenance.
5. Commenting difficulty is a diagnostic signal: if you can't articulate what a routine does, you don't understand it well enough — fix the understanding, not just the comment.
6. Choose a commenting style that is trivially easy to maintain; a style that discourages updates will produce stale, misleading comments.
7. Use version control for dead code — never leave commented-out code in production sources.

## Connects To

- **Ch 11**: Power of variable names — expressive naming is the single greatest contributor to self-documenting code.
- **Ch 31**: Layout and style — good layout shows structure; comments then add the intent layer on top.
- **Ch 7**: High-quality routines — routine-level commenting is most valuable when routine design is already clean.
