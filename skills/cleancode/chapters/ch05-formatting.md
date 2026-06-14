# Chapter 5: Formatting

## Core Idea
Formatting is a form of professional communication — the visual structure of code conveys relationships, hierarchy, and intent. Consistent formatting signals craftsmanship and builds reader trust across an entire codebase.

## Frameworks Introduced
- **The Newspaper Metaphor**: Structure a source file like a newspaper article — name at top tells you whether you're in the right place, high-level concepts and algorithms appear first, detail increases as you scroll down, lowest-level functions at the bottom.
  - When to use: Any time you're organizing functions within a file or deciding where to place a new function.

- **Vertical Distance as Relatedness Metric**: The vertical separation between two concepts should be proportional to how unrelated they are. Closely related code belongs close together; unrelated code earns its blank lines.
  - When to use: Deciding whether to blank-line-separate two blocks, whether to keep instance variables scattered or consolidated, whether to split a file.

## Key Concepts
- **Vertical Openness Between Concepts**: Blank lines act as visual separators between package declarations, imports, and function bodies — each blank line signals "new thought begins here."
- **Vertical Density**: Lines that are tightly related (e.g., two instance variables forming a single logical unit) should appear without blank lines between them; gratuitous comments that split them apart hurt comprehension.
- **Vertical Distance**: Concepts closely related to each other belong in the same source file and close together vertically. Forcing readers to hop between functions or scroll to chase a variable declaration is a comprehension tax.
- **Variable Declarations near usage**: Local variables should be declared immediately above their first use. Loop control variables belong inside the loop statement. Instance variables belong at the top of the class (used by most methods).
- **Dependent Functions**: A function that calls another should appear above the called function, creating a top-to-bottom narrative flow from caller to callee.
- **Conceptual Affinity**: Groups of functions that perform variations of the same task (e.g., `assertTrue`/`assertFalse` overloads) belong together regardless of whether they call each other — shared naming scheme and task similarity create affinity.
- **Vertical Ordering**: Callers above callees; high-level concepts near the top, low-level details near the bottom. Readers skim the top of the file for the gist and dive in only when needed.
- **Horizontal Openness and Density**: Space around assignment operators to emphasize the left/right split; no space between function name and opening parenthesis (they are one unit); spaces around lower-precedence operators to reflect arithmetic precedence.
- **Horizontal Alignment**: Aligning variable names or rvalues in columns draws the eye along the aligned column (all the names, all the values) rather than across each line (name → type, variable → value). Martin explicitly argues against it; a long list that "needs" alignment is a sign the list is too long, not that alignment is needed.
- **Indentation**: Indentation exposes the scope hierarchy — file, class, method, block, sub-block. Collapsing it (e.g., a one-liner `if`) hides that structure and misleads.
- **Team Rules**: A team agrees on one style and encodes it in the IDE formatter. Individual preferences yield to the team standard. Consistency across files matters more than any individual's preference.

## Mental Models

1. **Eye-full test**: Can you grasp the class at a glance — its variables and methods — without moving your head? Dense, related code enables this; spurious comments or blank lines destroy it.
2. **Caller-callee gravity**: Functions exert a downward gravitational pull on their dependents. Let called functions sink; calling functions float.
3. **Affinity radius**: The stronger two pieces of code are conceptually related, the shorter the vertical distance allowed between them. Unrelated code earns its blank lines; closely related code does not.
4. **Whitespace as syntax signal**: Horizontal space communicates operator precedence and argument grouping — `b*b - 4*a*c` reads multiplication as tighter than subtraction through spacing alone.

## Anti-patterns
- **Horizontal Alignment of declarations**: Columns of type-aligned variable names train the eye to read down names instead of across type→name pairs; reveals a too-long list rather than fixing it.
- **Gratuitous comments between related fields**: Javadoc noise between two instance variables that belong together breaks visual density with no semantic benefit.
- **Collapsing indented scopes onto one line**: Hiding a loop body on the same line as the loop statement eliminates the visual cue that scope is entered.
- **Declared-far-from-used variables**: Instance-style variable hoisting into local functions forces readers to scroll up to understand context.
- **Files over 500 lines**: Files that grow beyond ~500 lines become harder to navigate and usually signal that the class is doing too much.

## Reference Table

| Guideline | Target | Hard Limit |
|---|---|---|
| File length | ~200 lines typical | 500 lines max (very desirable) |
| Line width | ~80 chars historical; 100–120 acceptable | 120 (Martin's personal limit) |
| Significant systems | Achievable with 200-line avg files | FitNesse: ~50,000 lines this way |

## Key Takeaways
1. Formatting is communication — the layout should tell the reader what belongs together and what is separate before they read a single token.
2. Vertical distance encodes relatedness: keep related concepts close, let unrelated concepts breathe.
3. The Newspaper Metaphor gives a structural default: high-level at the top, low-level at the bottom, caller above callee.
4. Horizontal whitespace should reflect semantic weight — assignment splits, precedence grouping, argument separation — not arbitrary column alignment.
5. File size is a signal: ~200 lines is normal and achievable; over 500 is a warning. Small files are easier to understand.
6. Team rules override individual preference. The formatter is the arbiter. Consistency across files builds reader trust.

## Connects To
- **Ch 2 (Names)**: The Newspaper Metaphor depends on names being self-explanatory — the file name alone should tell you whether you're in the right module.
- **Ch 3 (Functions)**: Short functions make vertical distance rules easy to satisfy; long functions collapse the value of "declared near use."
- **Ch 10 (Classes)**: File-size heuristics connect directly to class-size discipline; a file over 500 lines usually means a class over its mandate.
- **Ch 17 (Smells and Heuristics)**: G10 (Vertical separation) and G35 (Constants at appropriate levels) are cross-referenced directly in this chapter.
