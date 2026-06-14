# Glossary — 99 Bottles of OOP

**ABC metric** — Assignments, Branches (message sends/calls), and Conditions; a proxy for the cognitive size and complexity of code. Ruby tool: Flog (Ch 1).
**Abstraction** — an underlying concept common to multiple concrete examples; reach for it only once examples reveal it (Ch 1, Ch 3).
**Accidental Correctness** — code that passes tests for the wrong reason, e.g. `number-1` working only because a branch falls through (Ch 4).
**"And" Suspicion** — the word "and" in a method's description implies it does more than one thing (SRP violation) (Ch 8).
**Blank Line Smell** — a blank line inside a method signals a change of topic and a probable Single Responsibility violation (Ch 8).
**Bottle Number vs. Verse Number** — the same argument name (`number`) meaning two different domain things; root cause of the Ch 5 smell.
**Code Smell** — a named flaw in code that has a known curative refactoring recipe (Fowler) (Ch 3, Ch 5).
**Confirmable Behavior** — behavior that produces a distinct observable output per valid input; justifies the existence of a test (Ch 9).
**Cyclomatic Complexity** — counts unique execution paths through code; also yields the minimum number of tests for full coverage (Ch 1).
**Data Clump** — three or more data fields that always travel together, signaling a missing concept/object (Ch 6).
**Depending on Abstractions** — using an extracted concept everywhere it applies, not just where convenient (Ch 4).
**DRY (Don't Repeat Yourself)** — extract duplication to one place; true, but adds indirection — worth it only when it lowers cost of change more than it raises cost of understanding (Ch 1).
**Echo-Chamber Test** — a test that asserts one method equals another, coupling the test to implementation internals (Ch 2).
**Extract Class** — refactoring recipe that moves a cohesive group of methods into a new class, replacing a primitive (Ch 5).
**Factory** — a single method that owns all the logic for selecting and manufacturing the right class/role-player (Ch 6, Ch 7).
**Faux Unit Test** — an integration test masquerading as a unit test; covers collaborators it shouldn't own (Ch 9).
**Flocking Rules** — 1. Select things most alike; 2. Find the smallest difference; 3. Make the simplest change to remove it (Ch 3).
**Flog** — Ryan Davis's Ruby tool for generating ABC-style complexity scores (Ch 1).
**Gradual Cutover** — adding a required argument via a `:FIXME` default, wiring logic, migrating senders one at a time, then deleting the default (Ch 3).
**Green Bar Patterns** — Fake It, Obvious Implementation, Triangulate — Kent Beck's tactics for getting to green (Ch 2).
**Horizontal Refactoring** — removing differences across the parallel branches of a conditional until they are identical, then collapsing to one template (Ch 4).
**Horizontal vs. Vertical Path** — finish one refactoring sweep (horizontal) before veering to another part of the code (vertical) (Ch 2, Ch 3, Ch 5).
**Immutability** — objects that never change after creation; easy to reason about, test, and share across threads (Ch 5).
**Inline Temp** — removing a temporary variable used exactly once by inlining its expression (Ch 6).
**`inherited` hook** — Ruby callback fired when a subclass is created; used for factory auto-registration (Ch 7).
**Intention vs. Implementation** — `song` (what you want) vs. `verses(99, 0)` (how it's done); name methods by intention (Ch 1, Ch 2).
**Law of Demeter** — only talk to your direct collaborators; a chain signals a missing abstraction (Ch 8).
**Liskov Substitution Principle (LSP)** — subtypes must be substitutable for their supertype; role-players must keep their type/API promises (Ch 4, Ch 5, Ch 6).
**Meaningful Defaults** — when adding a parameter mid-refactor, default to `:FIXME` (fails visibly) or a real domain value, then remove when done (Ch 4).
**Metric** — a research-backed, crowd-sourced measure of a code quality; produces facts for comparing code (Ch 1).
**Open/Closed Principle (OCP)** — objects should be open for extension but closed for modification; first refactor to be open, *then* add the feature (Ch 3, Ch 6, Ch 8).
**Opportunity Cost** — the cost of improving working code is everything else on the backlog you aren't doing instead (Ch 8).
**Polymorphism** — many types responding to the same message, with the sender ignorant of the receiver's class (Ch 6).
**Primitive Obsession** — using a built-in type to represent a domain concept, forcing callers to supply its behavior (Ch 5).
**Programming Aesthetic** — internalized heuristics that guide decisions when no recipe applies (Ch 8).
**Push Creation to the Edges** — separate object creation from object use; keep factories at the boundary (Ch 8).
**Red/Green/Refactor** — the TDD cycle: failing test → passing code → cleanup; never skip a step (Ch 2).
**Registry** — a class-level collection of eligible factory candidates (Ch 7).
**Role** — the abstract interface a collaborator must satisfy, e.g. anything responding to `lyrics(number)` (Ch 8).
**Self-registration** — candidates announce themselves to the factory (`register(self)`) so it stays open (Ch 7).
**Shameless Green** — the solution that reaches green fastest while prioritizing understandability over changeability; tolerates duplication until abstractions are visible (Ch 1, Ch 2).
**SLOC** — Source Lines of Code; measures volume, not quality (Ch 1).
**Squint Test** — zoom out until the code is illegible and look for shape changes (indentation = conditionals) and color changes (mixed abstraction levels) (Ch 5).
**Stable Landing Point** — a green, consistently-shaped state of the code that is safe to pause at (Ch 4, Ch 5).
**Successor** — the domain concept of the next verse number to sing (0 → 99, n → n-1) (Ch 4).
**Tolerating Duplication** — deliberately keeping duplicate code until enough examples exist to reveal the correct abstraction (Ch 1, Ch 2).
**Triangulate** — accumulate multiple concrete examples before extracting the abstraction they point toward (Ch 2).
**Visibility** — whether a dependency is knowable by outside callers: injected = visible, internally-created = invisible; drives test strategy (Ch 9).
