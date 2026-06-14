# Chapter 9: Unit Tests

## Core Idea
Test code is as important as production code — dirty tests are equivalent to no tests. Unit tests are what preserve your ability to change, refactor, and extend production code without fear; they enable all the -ilities (flexibility, maintainability, reusability).

## Frameworks Introduced

- **The Three Laws of TDD**: A tight 30-second red-green cycle enforced by three constraints:
  - *First Law*: You may not write production code until you have written a failing unit test.
  - *Second Law*: You may not write more of a unit test than is sufficient to fail, and not compiling is failing.
  - *Third Law*: You may not write more production code than is sufficient to pass the currently failing test.
  - When to use: All production code, always — this is the baseline discipline.
  - How: Write test first, watch it fail, write minimal code to pass, repeat.

- **BUILD-OPERATE-CHECK**: A structural pattern for organizing test bodies into three explicit phases.
  - When to use: Any test that needs setup before it can exercise behavior.
  - How: First part builds test data, second part operates on it, third part checks that the operation yielded expected results. All extraneous detail is hidden behind helper methods so the three parts are immediately visible.

- **F.I.R.S.T.**: Five properties every clean test must satisfy:
  - **Fast** — Tests must run quickly or developers won't run them frequently; infrequent runs mean late discovery of problems and reluctance to refactor.
  - **Independent** — Tests must not depend on each other or share setup state; dependent tests cascade failures and obscure root causes.
  - **Repeatable** — Tests must pass in production, QA, and a laptop with no network; environment-dependent tests always have an alibi for failure.
  - **Self-Validating** — Tests must have a boolean outcome (pass/fail); requiring a human to read logs or diff files to determine success makes failure subjective.
  - **Timely** — Tests must be written just before the production code they exercise; writing tests after the fact often surfaces production code that is untestable by design.

## Key Concepts

- **Keeping Tests Clean**: The discipline of maintaining test code to the same quality standard as production code — well-named variables, short descriptive functions, thoughtful structure — because tests that are messy become impossible to change as production code evolves.
- **Tests Enable the -ilities**: Unit tests are the mechanism by which architecture stays clean; without tests every change is a possible undetected bug, so developers stop refactoring and code rots.
- **Clean Tests**: Test quality is defined entirely by readability — clarity, simplicity, and density of expression; a clean test says a lot with as few expressions as possible.
- **Domain-Specific Testing Language**: A set of test helper functions and utilities that wrap the production API so tests read at the level of the problem domain rather than the level of implementation mechanics; this API is not designed up front but evolves through refactoring.
- **A Dual Standard**: Test code has different engineering standards than production code — it need not be as memory- or CPU-efficient (it runs in test, not production) but it must still be simple, succinct, and expressive. Performance shortcuts acceptable in tests would not be acceptable in production.
- **One Assert per Test**: A guideline (not an absolute rule) that each test function should reach a single conclusion; the more important formulation is that the number of asserts per concept should be minimized.
- **Single Concept per Test**: The stricter rule — each test function should exercise exactly one concept; multiple independent behaviors in one function force readers to mentally separate what is being verified.

## Mental Models

1. **Test rot propagates to production rot**: Dirty tests become hard to maintain; developers stop changing them; the test suite gets discarded; without tests, production code changes introduce undetected bugs; defect rate rises; developers fear changing anything; production code rots. The causal chain is deterministic.
2. **Tests as change insurance**: Coverage percentage maps directly to freedom to refactor. High coverage means near-impunity to restructure even tangled code; low coverage means every change is a gamble.
3. **given-when-then as test grammar**: Naming test phases (givenPages / whenRequestIsIssued / thenResponseShouldContain) makes the scenario explicit and reduces cognitive load to near zero for readers.
4. **API refactoring as test vocabulary building**: Every time test code becomes cluttered with implementation detail, the refactoring response is to extract a helper method with a domain-level name — over time this produces a testing language that reads like specifications.

## Anti-patterns

- **Quick and dirty test code**: Granting tests a license to be messy on the grounds that "they're just tests" — the exact decision that kills codebases; dirty tests can't survive the production code they cover.
- **Miscellaneous-concept tests**: Bundling multiple independent behavioral concepts in one test function, forcing readers to disentangle what is under test; each concept should live in its own function.
- **Environment-coupled tests**: Tests that only pass in certain network/OS environments give teams an alibi for ignoring red runs and erode the discipline of the test suite.
- **Post-hoc test writing**: Writing tests after the production code is complete makes untestable designs invisible; TDD's third law forces testability into the design by construction.
- **Exposing implementation detail in tests**: Tests that use raw production APIs directly rather than a testing language become brittle to refactors and noisy to read.

## Code Examples

```java
// Listing 9-4: EnvironmentControllerTest.java (refactored — A Dual Standard)
@Test
public void turnOnLoTempAlarmAtThreshold() throws Exception {
    wayTooCold();
    assertEquals("HBchL", hw.getState());
}
```
- **What it demonstrates**: Domain-specific test language in action — `wayTooCold()` hides the `tic()` detail; the encoded string `"HBchL"` (upper=on, lower=off, order: heater/blower/cooler/hi-alarm/lo-alarm) compresses five boolean assertions into one readable line, acceptable in tests despite being a mental-mapping convention that would be unacceptable in production code.

## Key Takeaways

1. Test code that is allowed to be messy will eventually be discarded, and discarding your test suite is the first step toward a rotting codebase.
2. The Three Laws of TDD enforce a 30-second red-green cycle that produces tests as a natural byproduct of writing production code, not as an afterthought.
3. The BUILD-OPERATE-CHECK pattern and a domain-specific testing language together ensure that test intent is immediately legible to any reader.
4. F.I.R.S.T. is a complete checklist: a test that fails any of the five properties will eventually be ignored, worked around, or deleted.
5. The real unit of clean test design is one concept per function, not one assert per function — minimize asserts per concept, then enforce one concept per test.
6. Tests are not a quality gate; they are the mechanism by which all software quality attributes (-ilities) remain achievable at all.

## Connects To

- **Ch 1 (Clean Code)**: Tests are the enforcement mechanism for every "keep it clean" principle in the book — without them, no clean-code standard survives contact with evolving requirements.
- **Ch 2 (Meaningful Names)**: given/when/then naming conventions for test functions directly apply the chapter's principles to make test intent self-documenting.
- **Ch 3 (Functions)**: Single-concept-per-function applies symmetrically to test functions — same reasoning, same discipline.
- **Ch 10 (Classes)**: Test class structure mirrors the single-responsibility principle; one test class per concept under test, with @Before for shared setup and @Test for individual assertions.
