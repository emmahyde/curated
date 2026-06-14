# Chapter 31: Layout and Style

## Core Idea
Good layout makes the logical structure of code visible to human readers — the Fundamental Theorem of Formatting is the single criterion governing every spacing, indentation, and brace-placement decision.

## Frameworks Introduced

- **Fundamental Theorem of Formatting**: Good visual layout shows the logical structure of a program. Every layout choice should be evaluated against this standard: does it reveal or obscure structure?
  - When to use: Any time you choose indentation depth, brace placement, blank-line frequency, or alignment.
  - How: Ask "does this choice make the code's logical organization more or less apparent?" Prefer the choice that shows structure; break ties with consistency and maintainability.

- **Pure Block**: A layout style native to languages (e.g. Visual Basic) where each control construct has a matching terminator (`If/End If`, `While/Wend`). Beginning and ending keywords align vertically; body is indented between them. This is the ideal all other styles emulate.
  - When to use: Languages with mandatory block terminators; adopt as the target aesthetic everywhere else.
  - How: Align begin and end keyword at the same column; indent body one level inside.

- **Emulated Pure Block**: Approximates pure-block clarity in brace-based languages (C++, Java). Opening brace goes at the end of the control-structure line; closing brace aligns with the control keyword.
  - When to use: Standard/most common style in C++, Java, C#, JavaScript.
  - How: `if (cond) {` on one line; body indented; `}` at same column as `if`.

- **Begin-End Block Boundaries**: Alternative brace style treating `{` and `}` as independent block-boundary statements rather than extensions of the control line. Opening brace on its own line; closing brace on its own line; both aligned with the control keyword.
  - When to use: Valid alternative to emulated pure block; choose one and apply consistently.
  - How: Control keyword on its own line; `{` on the next line at same indent; body indented; `}` at same indent as `{`.

- **Endline Layout**: Placing closing tokens or comments at the end of code lines rather than on their own lines. Generally discouraged — obscures structure and is difficult to maintain.

## Key Concepts

- **Fundamental Theorem of Formatting**: Good layout shows the logical structure of code; it is not decorative but communicative.
- **Psychological Distance**: The visual gap between code elements. Layout should minimize distance between logically related elements and increase it between unrelated ones.
- **Indentation**: The primary tool for showing nesting and hierarchy. 2–4 spaces per level is broadly supported; the one absolute rule is consistency.
- **White Space**: Spaces, blank lines, and line breaks used structurally — like paragraph breaks in prose — to group related statements and separate unrelated ones.
- **Continuation Lines**: A single logical statement broken across multiple physical lines; must be indented relative to the originating statement to avoid being misread as independent statements.
- **Alignment**: Visually lining up tokens (e.g., assignment operators) across adjacent lines. Improves readability only when it does not create a maintenance burden; do not align right-hand sides of assignments.
- **Layout of Routines**: Blank lines before/after each routine; broken parameter lists indented under the opening parenthesis; local variable declarations grouped at the top.
- **Layout of Classes**: Consistent member ordering (constants → instance variables → constructors → public methods → private methods); section separators between logical groups.

## Mental Models

- Use **"show the logical structure"** as the single test for any layout decision — layout is communication, not aesthetics.
- Think of **white space as paragraph breaks**: a blank line signals a new thought; absence of blank lines signals tight logical coupling.
- Use **pure block as the ideal** and ask which available style gets closest when your language doesn't provide it natively.
- When two brace styles are both readable and consistent, **consistency matters more than the specific choice** — pick one and codify it for the team.

## Anti-patterns

- **Unindented begin-end pairs**: Aligning braces with the control keyword while indenting the body creates visual orphans — the braces belong neither to the control structure nor the statements; this violates the Fundamental Theorem.
- **Endline / hanging layout**: Trailing token alignment is brittle, discourages maintenance edits, and adds visual noise without revealing structure.
- **Over-alignment**: Aligning right-hand sides of assignments looks tidy until a variable name changes length; maintainers either fix all alignment or let it drift into misleading asymmetry.
- **Inconsistent style within a file**: Mixed brace styles or inconsistent indentation signals absent ownership and forces readers to re-parse layout conventions on every block.
- **Formatting for the compiler**: Dense, whitespace-free code treats source as machine input rather than human communication — the primary audience for source code is people.

## Key Takeaways

1. The Fundamental Theorem of Formatting is the objective criterion for every layout decision: good layout shows logical structure.
2. Pure-block style is the gold standard; emulated pure block and begin-end block boundaries are both acceptable approximations in brace-based languages — one empirical study found no statistically significant readability difference between them.
3. Choose one brace style and apply it uniformly — the cognitive cost of inconsistency within a file exceeds any benefit of style mixing.
4. White space is structural, not optional decoration: blank lines group related statements and separate unrelated ones just as paragraphs organize prose.
5. Continuation lines and multi-line parameter lists require explicit indentation conventions to prevent them from being misread as independent statements.
6. Deep nesting is a code-quality problem that layout can expose but cannot fix — restructure the code itself.
7. Layout decisions that are hard to maintain will drift; prefer styles that are easy to update mechanically.

## Connects To

- **Ch 32**: Self-documenting code — once layout shows structure, comments should add intent and summary, not restate structure already visible in the layout.
- **Ch 19**: Boolean expressions — multi-line conditional layout guidelines apply directly here.
- **Ch 5**: Design in construction — good layout reflects good design; tangled layout often signals tangled design beneath it.
