# Chapter 22: Developer Testing

## Core Idea
Exhaustive testing is mathematically impossible, so the art of testing is selecting the minimum set of test cases most likely to find errors; structured basis testing, data-flow testing, boundary analysis, and error guessing together give developers a systematic way to achieve high coverage without combinatorial explosion.

## Frameworks Introduced
- **Structured Basis Testing**: Test each logical path through a routine at least once using the minimum number of test cases. Count 1 (base) + 1 per decision keyword (if, while, for, and, or, case). The result is the minimum number of test cases needed for full path coverage.
  - When to use: Any routine with conditional logic; more efficient than code-coverage testing which can produce redundant cases.
  - How: Start with 1 for the straight path; add 1 for each if, while, repeat-until, for, and/or in compound conditions, and each case in a case statement; design one test case per path.

- **Data-Flow Testing**: Test combinations of variable definition (where a variable is assigned) and variable use (where it is read). Focus on definition-use pairs to catch initialization errors and incorrect assignments.
  - When to use: After structured basis testing, to find errors structured basis testing misses.
  - How: Identify all points where each variable is defined and all points where it is used; create tests that exercise each definition–use pairing.

- **Boundary Analysis (Boundary-Condition Testing)**: Test at the boundaries of input domains — the min, min+1, nominal, max−1, max values — because errors cluster at edges.
  - When to use: Any routine that accepts a range of inputs or array indices.
  - How: For every range or loop, test the values just inside and just outside each boundary; test off-by-one cases explicitly.

- **Equivalence Partitioning**: Divide input space into classes where all values in a class are expected to behave identically; test one representative from each class rather than all values.
  - When to use: When input space is large; reduces redundant tests while maintaining coverage.
  - How: Identify partitions (valid data, invalid data, boundary values); choose one representative test case per partition.

- **Test-First Development (Test-First Programming)**: Write test cases before writing the code being tested, using tests to specify and validate behavior incrementally.
  - When to use: When requirements are well enough understood to express as tests; especially effective in combination with small, incremental development cycles.
  - How: Write a failing test, write the minimum code to pass it, refactor; repeat.

## Key Concepts
- **Exhaustive testing impossibility**: Even a simple program with three input fields can have 10^66 possible test cases — complete testing is computationally intractable for any real program.
- **Error guessing**: Using experience and intuition to identify likely error locations and craft targeted tests; a complement to systematic techniques, not a substitute.
- **Coverage monitor**: A tool that instruments code to report which statements, branches, or paths were exercised during a test run; reveals gaps that feel covered but aren't.
- **Regression testing**: Re-running a prior test suite after changes to verify no previously working behavior was broken; essential for maintenance and refactoring.
- **Unit testing**: Testing an individual routine or class in isolation before integrating it with others; easier to debug than integrated testing because the guilty party is bounded.
- **Integration testing strategy**: The order in which units are combined for testing; incremental integration (adding one unit at a time to a tested base) isolates defects more effectively than big-bang integration.
- **Error taxonomy**: Categorizing defects by type (off-by-one, initialization, operator precedence, boundary) to focus testing effort and improve checklists.

## Mental Models
- Use structured basis testing first to achieve minimum path coverage, then layer data-flow tests, then boundary tests — each layer finds different defects.
- Think of test cases as an investment: a test that tells you the same thing as another test is wasted; maximize information per test case.
- Test-first development converts requirements ambiguity into concrete, executable specifications before any implementation decision is made.
- Use boundary values habitually: errors cluster at the edges of ranges, array indices, and loop limits — test min, min+1, max−1, max for every range.

## Anti-patterns
- **False coverage confidence**: Running hundreds of tests that all exercise the same paths; a coverage monitor will reveal the illusion.
- **Big-bang integration testing**: Combining all untested units at once and then testing — when failures occur, any unit could be guilty, making debugging combinatorially harder.
- **Testing only the happy path**: Writing tests only for expected valid inputs; boundary, invalid, and error-path tests find the defects that ship to production.
- **Skipping unit tests in favor of system tests**: System tests find integration problems but cannot isolate which unit is faulty; unit tests are cheaper to debug.

## Key Takeaways
1. Exhaustive testing is impossible; the skill is choosing the minimal test set with maximum defect-detection coverage.
2. Structured basis testing gives the minimum number of test cases needed for full logical-path coverage: count 1 + each decision keyword.
3. Boundary conditions are where errors cluster — always test min, min+1, max−1, max explicitly.
4. Test-first development turns requirements into executable specifications before code is written, catching misunderstandings early.
5. Use a coverage monitor to verify actual coverage — felt coverage and measured coverage diverge significantly in practice.
6. Integrate incrementally (one unit at a time into a tested base) so that new failures can be attributed to the new unit.
7. Collaborative construction and developer testing are complementary — they find different defect types and neither replaces the other.

## Connects To
- **Ch20**: Testing is one layer in the defect-detection rate table; no testing technique alone exceeds ~50% removal rate.
- **Ch21**: Reviews and testing find different defect types; both are required.
- **Ch23**: Testing reveals that a defect exists; debugging locates and fixes it — two distinct activities requiring different skills.
- **Ch24**: Regression tests make refactoring safe by confirming behavior is preserved after internal restructuring.
