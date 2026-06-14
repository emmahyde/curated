# Chapter 13: Concurrency

## Core Idea

Concurrency is a decoupling strategy that separates *what* gets done from *when* it gets done, enabling structural clarity and performance gains — but it introduces complexity that demands its own discipline, patterns, and testing rigor.

## Frameworks Introduced
- **Single Responsibility Principle for Concurrency**: Keep concurrency-related code strictly separate from all other production code; it has its own lifecycle, its own failure modes, and its own tuning needs.   - When to use: Always — never embed threading mechanics inside domain or application logic.
- **Limit the Scope of Data**: Encapsulate shared data tightly and minimize the number of places it can be modified. Use `synchronized` to protect critical sections, but restrict how many such sections exist.   - When to use: Any time two or more threads can reach the same mutable field.
- **Use Copies of Data**: Avoid sharing state altogether by passing copies to threads. The overhead of copying is usually less than the cost of synchronization bugs.   - When to use: When shared data is read-heavy and writes can be deferred or merged.
- **Threads Should Be as Independent as Possible**: Design each thread to operate on its own local data, acquired from an unshared source, needing no synchronization with peers.   - When to use: When partitioning work across threads; model each thread as an isolated unit.

## Key Concepts
- **Bound Resources**: Fixed-size shared resources (DB connections, read/write buffers) that constrain concurrent throughput.
- **Mutual Exclusion**: Only one thread may access a shared resource at a time — the basic guarantee `synchronized` provides.
- **Starvation**: A thread is perpetually denied access because higher-priority or faster threads monopolize the resource.
- **Deadlock**: Two or more threads each hold a resource the other needs; neither can proceed.
- **Livelock**: Threads keep yielding to each other in lockstep and make no progress despite constant activity.
- **Producer-Consumer**: Producers enqueue work into a bound buffer; consumers dequeue it. Both sides must signal across the boundary correctly or deadlock/starvation results.
- **Readers-Writers**: A shared resource permits concurrent reads but exclusive writes; the challenge is balancing writer starvation against reader throughput.
- **Dining Philosophers**: N threads compete for N shared resources; careless acquisition order causes deadlock or livelock — the canonical model for resource-contention design.

## Mental Models
1. **What vs. When**: In a single-threaded system the call stack reveals full program state; in a concurrent system that coupling is broken. Think of threads as collaborating mini-programs, not sequential steps.
2. **Critical Sections Are Expensive Real Estate**: A `synchronized` block is a bottleneck. Design to minimize the size and number of critical sections — never extend them beyond what correctness requires.
3. **Spurious Failures Are Data**: A test that fails once in a million runs and then passes is not a fluke — it is a threading bug hiding behind timing luck. Treat every unexplained failure as a threading candidate.
4. **Shutdown Is a Concurrent Problem Too**: Graceful shutdown requires all threads to receive and honor a stop signal. A deadlocked child prevents the parent from ever terminating; design and test shutdown paths explicitly and early.

## Anti-patterns
- **Embedding concurrency logic in domain code**: Mixing threading mechanics with business rules violates SRP and makes both harder to test and reason about.
- **Wide synchronized blocks**: Locking more than the minimal critical section increases contention, degrades throughput, and provides false safety — the section feels "covered" but the overhead is paid everywhere.
- **Multiple synchronized methods on a shared object**: Each method is individually safe but the composite operation is not; `if (hasNext()) return next()` is a race condition even when both methods are synchronized individually.
- **Dismissing one-off failures**: Concurrency bugs manifest rarely and non-reproducibly. Ignoring them lets more code accrete on top of a broken foundation.
- **Late shutdown design**: Bolting on graceful shutdown after the system is built almost always reveals deadlock scenarios that require structural redesign.

## Key Takeaways
1. Concurrency decouples *what* from *when*; that decoupling is powerful but not free — it fundamentally changes system design.
2. The common myths (concurrency always improves performance; containers handle it for you; design doesn't change) are all false and lead to subtle production failures.
3. Keep concurrency code isolated as a first-class concern with its own classes, its own tests, and its own tuning surface.
4. Know the three canonical execution models — Producer-Consumer, Readers-Writers, Dining Philosophers — most real concurrency problems are variations of these.
5. Never call one synchronized method from another on the same shared object without a coordinating lock strategy (client-based, server-based, or adapted-server locking).
6. Instrument code to force failures during testing: hand-inject `Thread.yield()` at suspicious points, or use automated tools (e.g., IBM ConTest) to jiggle thread scheduling across many configurations and platforms.
7. Make threaded code pluggable (configurable thread count, real vs. test doubles, variable timing) so the test harness can exercise corner cases that never appear in default single-threaded runs.

## Connects To
- **Ch 1 (Clean Code)**: The single-responsibility discipline applied here is the same principle Martin establishes for all clean code — separation of concerns scales from method to system.
- **Ch 10 (Classes)**: SRP for classes is the direct foundation for keeping concurrency classes separate from domain classes.
- **Ch 9 (Unit Tests)**: The testing recommendations here (pluggable, tunable, run on many platforms, instrument to force failures) extend TDD's three laws into the concurrent domain where determinism cannot be assumed.
- **Appendix / Concurrency II**: The chapter explicitly defers deeper treatment (possible execution paths, deadlock analysis, throughput proofs) to the companion tutorial, which should be read when production-level concurrent design is required.
