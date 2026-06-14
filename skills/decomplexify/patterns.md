# Patterns & Techniques — Code Complete (2nd ed.)

Concrete, reusable techniques. Each entry: when to reach for it, how to apply, and the trade-off.

## Design & Classes

### Information Hiding
**When:** deciding what goes in a class interface. **How:** ask "what must this hide?" — hide volatile areas and likely-to-change types behind the interface. **Trade-off:** slightly more code, dramatically less ripple from change. (Ch 5)

### Identify Areas Likely to Change
**When:** early design. **How:** list volatile items (hardware deps, I/O, business rules, hard data), compartmentalize each, design an isolating interface around it. **Trade-off:** upfront cost vs. eliminated later rework. (Ch 5)

### ADT as Class
**When:** modeling any entity that has data + operations. **How:** name the class after the real-world entity, expose operations in its vocabulary, hide all structural detail. **Trade-off:** more setup, far better encapsulation and changeability. (Ch 6)

### Containment over Inheritance
**When:** the relationship is "has a", or you're unsure. **How:** hold the instance as a member and delegate; reserve inheritance for genuine "is a" specialization. **Trade-off:** a little delegation code vs. fragile base-class problems. (Ch 6)

### Functional Cohesion
**When:** designing any routine. **How:** ensure it performs one and only one operation; the name should describe exactly that (and all outputs/side effects). **Trade-off:** more routines, each easier to test and reuse. (Ch 7)

### Parameter List as Abstraction
**When:** defining a routine signature. **How:** order inputs → modified → outputs; cap at ~7; document units, ranges, and assumptions. **Trade-off:** discipline for a self-documenting interface. (Ch 7)

## Construction Process

### Pseudocode Programming Process (PPP)
**When:** building any non-trivial routine, especially when stuck. **How:** check prerequisites → write intent-level pseudocode → mentally verify → translate line-by-line, keeping pseudocode as comments → compile/test incrementally → remove redundant comments. **Trade-off:** slight upfront cost vs. hacking dead-ends; produces documentation as a by-product. (Ch 9)

### Barricade
**When:** external data enters trusted internal code. **How:** validate and convert all input at the boundary; use error handling outside, assertions inside. **Trade-off:** one sanitization point instead of checks scattered everywhere. (Ch 8)

### Assertion as Documentation
**When:** any assumption that must always be true. **How:** assert the condition; never put executable statements inside an assertion (they may compile out). **Trade-off:** must separate side effects from assertions. (Ch 8)

## Variables & Statements

### Declare Close to Use
**When:** initializing a variable. **How:** declare and assign immediately before first use, not at the top of a routine; minimize scope to the smallest region that needs it. **Trade-off:** minor restructuring vs. lower span/live-time and less coupling. (Ch 10)

### Named Constant for Literal
**When:** any non-obvious or potentially-changing literal. **How:** declare a symbolic constant and use it everywhere the literal would appear. **Trade-off:** essentially none. (Ch 12)

### Epsilon Comparison
**When:** comparing floating-point numbers. **How:** test `abs(a-b) < epsilon`, never `a == b`. **Trade-off:** must choose epsilon carefully. (Ch 12)

### Nominal-Path-First
**When:** any if/else distinguishing normal from error case. **How:** put the expected case in the `if` clause, errors in `else`. **Trade-off:** may conflict with a positive-boolean preference. (Ch 15)

### Boolean Function Extraction
**When:** an inline test takes more than a glance to read. **How:** extract it into a named boolean function. **Trade-off:** an extra function that documents intent better than a comment. (Ch 15)

### Loop-with-Exit
**When:** the natural exit falls mid-body (loop-and-a-half). **How:** `while(true)` / `break`, gathering all exit conditions in one place. **Trade-off:** requires discipline; ~25% higher comprehension in studies. (Ch 16)

### Table-Driven Dispatch
**When:** a long if-else-if or switch on a single variable. **How:** encode the mapping in an array/hash; store data or routine references; choose direct / indexed / stair-step access; encapsulate the access-key calculation. **Trade-off:** data is harder to debug than code but far easier to change. (Ch 18)

### Guard Clause
**When:** handling degenerate/error inputs. **How:** return early at the top of the routine. **Trade-off:** multiple returns, but reduced nesting. (Ch 17)

## Quality, Testing & Debugging

### Formal Inspection (Fagan)
**When:** high-stakes code, design, or requirements. **How:** assign roles (moderator/author/reviewer/scribe), prepare with a checklist, hold a detection-only meeting, log defects, author reworks, verify. **Trade-off:** overhead vs. 45–70% detection rate and improved upstream quality. (Ch 21)

### Structured Basis Testing
**When:** choosing the minimum tests for path coverage. **How:** count 1 + one per decision keyword (if/while/for/and/or/case); write a test per path; then add boundary and bad-data cases. **Trade-off:** baseline coverage, not exhaustive. (Ch 22)

### Test-First Development
**When:** requirements are expressible as tests. **How:** failing test → minimal code to pass → refactor → repeat. **Trade-off:** needs clear requirements upfront; catches misunderstandings early. (Ch 9, Ch 22)

### Scientific Method of Debugging
**When:** any non-obvious or intermittent defect. **How:** stabilize and reproduce → narrow by binary search/instrumentation → form a falsifiable hypothesis → experiment → prove → fix one thing → test the fix → scan for similar defects. **Trade-off:** discipline vs. ~10:1 advantage over trial-and-error. (Ch 23)

### Incremental Refactoring
**When:** visiting code for a fix or feature. **How:** one refactoring at a time, regression test after each, keep a parking lot for deferred ideas; leave the code cleaner than you found it. **Trade-off:** slower changes vs. cumulative structural debt. (Ch 24)

## Performance & Integration

### Measure Before Tuning
**When:** any performance concern. **How:** make it correct first → measure against requirements → profile → tune only the confirmed bottleneck → measure each change → back out failures → iterate. **Trade-off:** measurement cost vs. wasted effort on the cold 80%. Enable compiler optimization first (free 2×–2.5×). (Ch 25, Ch 26)

### Daily Build and Smoke Test
**When:** any project using incremental integration. **How:** build the full system daily; run an end-to-end smoke test; treat a broken build as the top-priority defect; automate both and keep the smoke test current. **Trade-off:** discipline vs. drift; weekly builds lose most of the benefit. (Ch 29)

### Incremental Integration Order
**When:** combining components. **How:** add one at a time to a tested base; pick an order (top-down / bottom-up / sandwich / risk-first / feature / T-shaped) by risk profile — usually a hybrid. **Trade-off:** more planning vs. far easier failure attribution. (Ch 29)

## Formatting & Documentation

### Emulated Pure Block
**When:** a brace-based language (C++/Java/JS). **How:** opening brace at the end of the control line, closing brace aligned with the keyword; apply one style uniformly. **Trade-off:** none of consequence — pick one and be consistent. (Ch 31)

### Intent over Summary Comments
**When:** a non-obvious design decision. **How:** comment the *why* at problem-domain level; fix unclear code before adding comments; never ship marker comments (TODO/FIXME). **Trade-off:** the most valuable comment type is also the hardest to write. (Ch 32)
