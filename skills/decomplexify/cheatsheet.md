# Cheatsheet — Code Complete (2nd ed.)

One-page quick reference. For the *why*, open the cited chapter.

## The meta-rule
**Conquer complexity.** Managing complexity is Software's Primary Technical Imperative. When two approaches are otherwise equal, prefer the one that reduces complexity. (Ch 5, Ch 34)

## Defect cost escalation (fix it early)
| Found at | Relative cost to fix a requirements defect |
|---|---|
| Requirements | 1× |
| Architecture | 3× |
| Construction | 5–10× |
| System test | 10× |
| Post-release | 10–100× |
(Ch 3)

## Design
- Ask **"What must this hide?"** — information hiding beats OO instinct alone.
- Identify areas **likely to change**; isolate each behind an interface.
- The **second** design attempt is almost always better — design is a wicked problem, so iterate.
- Every class implements **one ADT**. Containment ("has a") is the workhorse; inheritance ("is a") is the exception. (Ch 5, Ch 6)

## Routines
- **Functional cohesion**: one routine, one operation. If the name needs "and", split it.
- Name must describe **all** outputs and side effects; if that's too long, remove the side effects.
- **>7 parameters** signals excessive coupling. Order: in → modified → out. (Ch 7)

## Defensive programming
- **Assertions for bugs; error handling for expected conditions.**
- **Barricade**: dirty outside, clean inside — validate all external data at the boundary.
- Architecture (not individuals) decides **correctness vs. robustness**.
- Offensive programming: make errors impossible to overlook *during development*. (Ch 8)

## Variables
- Declare and initialize at **point of first use**; keep **live time < 7**.
- Minimize **scope**: smallest region that works.
- **No magic numbers** — name every meaningful literal.
- Never `==` compare floats; use an epsilon. Enum first entry = invalid. (Ch 10, Ch 12)

## Naming
- Names answer "what is this?" without context; **10–16 chars** for non-trivial variables.
- Qualifiers go at the **end**: `revenueTotal`, `customerCount`.
- Booleans in **positive form**: `isDone`, not `notDone`. (Ch 11)

## Control flow
- Normal case in the **`if`** branch; always a final `else`/`default` for the unexpected.
- Match loop type to intent; gather loop exits in one place; never use the index after exit.
- **Goto**: 9/10 cases have a structured alternative. Recursion only for naturally recursive problems.
- **Cyclomatic complexity**: 0–5 fine · 6–10 simplify · 10+ decompose. Max 3 nesting levels. (Ch 15–19)

## Quality & testing
- **General Principle**: improving quality lowers cost (rework is ~50% of a naive project).
- **No single technique removes >70%** of defects — combine inspection + testing + review.
- Inspection finds defects testing can't; meeting is for **detection only**, never fixing.
- Test the **boundaries**: min, min+1, nominal, max−1, max. Coverage monitors expose false coverage. (Ch 20–22)

## Debugging
- Use the **scientific method**: stabilize → hypothesize → experiment → prove → fix one thing → scan for siblings.
- Finding and understanding the defect is ~90% of the work; fix the **cause**, not the symptom.
- Set the compiler to max warnings and fix them all. Rubber-duck the bug. (Ch 23)

## Performance
- **Measure before tuning.** ~20% of code uses ~80% of time, but you can't guess which 20% — profile.
- Make it correct first; enable compiler optimization (free 2×–2.5×) before hand-tuning.
- Loops are the highest-leverage target; benchmarks **don't transfer** across language/compiler/platform. (Ch 25, Ch 26)

## Integration
- **Incremental** beats phased ("big bang"). Add one component at a time.
- **Daily build + smoke test** is the project heartbeat; a broken build is the #1 defect. (Ch 29)

## Formatting & comments
- **Fundamental Theorem of Formatting**: layout must reveal logical structure. Pick one brace style; apply it everywhere.
- Comment **intent (why)**, not a restatement of code. Fix unclear code before commenting. Delete dead code — that's what version control is for. (Ch 31, Ch 32)

## Themes (Ch 34)
Conquer complexity · Program *into* your language, not in it · Write programs for people first · Use conventions to focus attention · Program in problem-domain terms · Watch for the irritation of doubt · Iterate, repeatedly · Separate software from religion (no dogma).
