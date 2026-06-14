# Chapter 29: Integration

## Core Idea
The order and frequency in which software components are combined has a larger effect on debugging effort, error isolation, and schedule predictability than most teams realize — incremental integration is almost always better than phased ("big bang") integration.

## Frameworks Introduced
- **Phased Integration**: All classes are developed independently, then combined at once for system testing. Also called "big bang" integration.
  - When to use: Only on trivially small projects; generally should be avoided.
  - How: Design, code, test, and debug each class; combine into one system; test the whole. Problems: errors can originate anywhere, diagnosis is extremely difficult, morale suffers from long waits before seeing a working system.

- **Incremental Integration**: Classes are integrated one (or a small group) at a time, with the system tested after each addition, so the source of new errors is always the most recently added component.
  - When to use: Almost always — any non-trivial project benefits from incremental integration.
  - How: Integrate one component; test; find and fix errors (which must be in the new component); repeat. Strategies vary in the order of integration (see below).

- **Top-Down Integration**: Begin with the top-level class and integrate progressively downward, replacing stubs with real classes.
  - When to use: When high-level design stability is most important to validate early and when the "top" of the system is well defined.
  - How: Write stubs for all lower classes; integrate and test each level before proceeding to the next. Drawback: requires many stubs; pure form is rarely practical; use vertical-slice variant instead.

- **Bottom-Up Integration**: Begin with the lowest-level utility and device-interface classes and integrate upward.
  - When to use: When low-level system interfaces are risky and need early validation; when high-level design is already complete.
  - How: Integrate leaf classes first; test; build upward. Drawback: high-level design problems aren't discovered until late; requires complete design before starting.

- **Sandwich Integration**: Integrate high-level business-object classes and low-level utility/device classes first, leaving middle-level classes for last.
  - When to use: As a practical hybrid that avoids the worst drawbacks of pure top-down and pure bottom-up.
  - How: Identify top-layer and bottom-layer classes; integrate those first in parallel; fill in middle layer last.

- **Risk-Oriented Integration ("Hard Part First")**: Identify the riskiest classes and integrate them first, regardless of their position in the hierarchy.
  - When to use: When specific classes are known to be technically challenging (novel algorithms, ambitious performance targets, poorly understood interfaces).
  - How: Rank classes by estimated risk; integrate high-risk classes early; defer easy classes. Tends to naturally surface top-level and bottom-level classes first.

- **Feature-Oriented Integration**: Integrate one identifiable system feature at a time, adding complete "feature trees" of classes rather than individual classes.
  - When to use: When features are relatively independent and when minimizing scaffolding is a priority.
  - How: Define features as identifiable system functions; integrate all classes needed for one feature before moving to the next; each feature tree is self-contained and requires minimal scaffolding.

- **Daily Build and Smoke Test**: Every file is compiled, linked, and combined into an executable every day; the result is run through a smoke test that exercises the system end-to-end to verify it is stable enough for further testing.
  - When to use: On any project using incremental integration; treat it as the heartbeat of the project.
  - How: Build daily (not weekly — weekly gaps allow multi-week broken-build periods); run a smoke test that covers the full system end-to-end without being exhaustive; treat a broken build as the top priority to fix; keep the smoke test current as the system grows; automate both build and smoke test; require developers to check in at least every one to two days.

## Key Concepts
- **Scaffolding**: Temporary test code (stubs, drivers) written to support integration before real classes exist; a cost and error risk of top-down integration in particular.
- **Stub**: A dummy implementation of a not-yet-integrated class, used to allow higher-level classes to be tested before their dependencies exist.
- **T-shaped integration**: A hybrid approach that integrates one vertical slice (a full feature path from top to bottom) first, then integrates the remaining classes breadth-first; combines early end-to-end validation with breadth coverage.
- **Vertical-slice integration**: Implementing the system top-down in sections, fleshing out one area of functionality at a time rather than integrating an entire level before proceeding.
- **Smoke test**: A relatively simple check run after each build to verify the product does not "smoke" — i.e., does not fail catastrophically; gates more thorough testing.
- **Broken build**: A build that fails to compile, link, or pass the smoke test; treating a broken build as the highest-priority defect is essential to the daily-build discipline.
- **Continuous integration**: The practice of integrating and building even more frequently than daily, reducing integration drift further.

## Mental Models
- Think of phased integration as "system dis-integration" — combining untested interfaces all at once guarantees a debugging nightmare with no clear error source.
- Use the daily build as the project's heartbeat: if there is no heartbeat, the project is dead.
- Use risk-oriented integration when you can name the scary classes: do the hard parts first so surprises surface early, not at the end.
- Think of the smoke test as a sentry: without it, the daily build is just a time-wasting compile exercise.

## Anti-patterns
- **Big-bang (phased) integration**: All interfaces are untested until system integration; errors can originate anywhere; diagnosis is intractable; morale collapses during the long "system dis-integration" phase.
- **Weekly builds instead of daily**: A broken build can go unrepaired for weeks, eliminating nearly all benefit of frequent integration.
- **Stale smoke test**: A smoke test that only exercises a fraction of the growing system gives false confidence and allows integration problems to accumulate unseen.
- **Pure top-down integration**: Requires an impractical number of stubs; rarely achievable as described; use vertical-slice variant.
- **Pure bottom-up integration**: Defers validation of high-level design until all low-level work is done; design flaws discovered late require discarding low-level work.

## Key Takeaways
1. Incremental integration is almost always better than phased integration — any non-trivial project should use it.
2. A well-chosen integration order reduces testing effort and makes defects easy to locate.
3. The best integration strategy for any specific project is usually a combination of top-down, bottom-up, risk-oriented, and feature-oriented approaches; T-shaped and vertical-slice integration often work well in practice.
4. The daily build and smoke test reduces integration risk, improves morale, and provides accurate project status.
5. Treat a broken build as the top priority; broken builds left unrepaired destroy the discipline.
6. Keep the smoke test current — it must grow as the system grows.

## Connects To
- **Ch27**: Integration effort scales nonlinearly with project size, making integration strategy increasingly critical on large projects.
- **Ch28**: Integration order must be coordinated with the construction schedule; version control is the enabling infrastructure.
- **Ch22**: The smoke test is a form of developer testing; coverage monitors and automated test frameworks support it.
