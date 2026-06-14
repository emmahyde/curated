# Chapter 8: Defensive Programming

## Core Idea
Defensive programming is the recognition that programs will have problems and modifications, and that a smart programmer develops code accordingly — protecting each routine from bad input, using assertions to document assumptions, and deciding at the architecture level how errors will be handled.

## Frameworks Introduced
- **Assertions**: Boolean expressions placed in code to document conditions that must be true at that point; they catch programming errors (not user errors) during development.
  - When to use: To document and verify preconditions, postconditions, and any assumption that should never be false in correct code
  - How: Use for conditions that represent bugs (not expected error cases); don't put executable statements inside assertion expressions; disable or leave in production based on architecture decision; use assertions inside barricades, error handling outside

- **Barricades**: Designated classes or layers whose job is to sanitize all data before it enters the interior of the system — analogous to an infection-control ward.
  - When to use: At any point where external data (user input, file input, network data) crosses into trusted internal code
  - How: Routines outside the barricade use error handling (data is untrusted); routines inside the barricade use assertions (data is guaranteed clean); validate and convert all input at the barricade; treat bad data that reaches inside the barricade as a programming error, not an input error

- **Error-Handling Techniques**: A spectrum of strategies for responding to anticipated errors in production code.
  - When to use: For all anticipated bad-data conditions outside the barricade
  - How (choose one per architecture): Return a neutral/benign value; substitute the next valid piece of data; return the same answer as last time; substitute the closest legal value; log a warning and continue; return an error code; call an error-handling routine; display an error message; shut down — choose based on whether the system favors correctness (never return wrong result) or robustness (keep running)

## Key Concepts
- **Defensive Programming**: The practice of writing code that protects itself from invalid input, unexpected conditions, and other programmers' mistakes — modeled on defensive driving.
- **Assertion**: A call or macro that verifies a condition is true at runtime; used to catch bugs, not to handle expected errors.
- **Precondition**: A condition that must be true before a routine is called; part of the routine's contract with its callers.
- **Postcondition**: A condition that the routine guarantees to be true when it returns; the other half of the contract.
- **Barricade**: An architectural boundary that validates and sanitizes all external data on entry, so internal code can safely assume clean data.
- **Offensive Programming**: Making errors during development as visible and loud as possible (crashing, alerting) so they are not overlooked — the opposite of silent failure.
- **Robustness vs. Correctness**: Two competing error-handling philosophies — correctness never returns a wrong result (may shut down instead), robustness keeps running even if that means returning a potentially wrong result.
- **Debugging Aids**: Code added during development (scaffolding, stubs, verbose logging, linked-list integrity checks) that can be activated or deactivated without production impact.

## Mental Models
- Think of a barricade as the boundary between "dirty" external data and "clean" internal data — assertions belong inside, error handling belongs outside.
- Use the correctness vs. robustness axis to make error-handling decisions: safety-critical systems favor correctness (wrong answer is worse than no answer); consumer software favors robustness (crash is worse than approximate answer).
- Think of assertions as executable documentation of assumptions — they catch the moment an assumption is violated, not a downstream symptom.
- Don't apply production constraints to the development version: development can be slow, loud, and extravagant with resources in exchange for catching errors early.

## Anti-patterns
- **"Garbage in, garbage out" as a policy**: Accepting that bad input produces bad output is a design abdication; validate and sanitize at the boundary.
- **Assertions with side effects**: `Debug.Assert(PerformAction())` — if assertions are compiled out, the action is never performed; always separate executable statements from assertion expressions.
- **Empty catch blocks**: Silently swallowing exceptions hides bugs; if an empty catch is truly correct, document why.
- **Throwing exceptions in constructors or destructors**: Leads to partially constructed or partially destroyed objects; extremely difficult to reason about and recover from.
- **Error messages that help attackers**: Messages that reveal internal structure (table names, file paths, stack traces) aid SQL injection, buffer overflow, and other attacks.
- **Too much defensive programming in production**: Every defensive check has a cost; architecture should specify what stays in production and what is development-only.

## Key Takeaways
1. Each routine should protect itself from bad input — don't assume callers are correct.
2. Use assertions to document conditions that should never occur; use error handling for conditions that might occur.
3. Decide at the architecture level whether the system favors correctness or robustness — inconsistent per-developer choices produce unpredictable system behavior.
4. Barricades make the assertion/error-handling distinction clean: outside the barricade uses error handling, inside uses assertions.
5. Use offensive programming during development — make errors impossible to overlook so they surface before production.
6. Don't automatically apply production constraints to the development version; use debugging aids freely during development and design them to be removable.

## Connects To
- **Ch5**: Information hiding and design for change are the architectural foundations that make barricade placement possible
- **Ch7**: Interface assumptions documented in Ch7 are the preconditions and postconditions verified by assertions in Ch8
- **Ch3**: Architecture must specify the error-handling strategy before individual routines can implement it consistently
- **Ch23**: Debugging — debugging aids described here are used directly in the debugging process
