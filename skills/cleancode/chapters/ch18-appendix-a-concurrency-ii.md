# Appendix A: Concurrency II

## Core Idea
Concurrent code is not simply "code that runs fast" — it is code where the combinatorial explosion of thread interleavings makes correctness almost impossible to reason about informally. You need structural discipline (where locks live), mathematical awareness (how many paths exist), and JVM-level knowledge (what is actually atomic) to get it right.

## Frameworks Introduced
- **Client-Based Locking**: The caller is responsible for acquiring the lock around every compound operation on a shared object (e.g., `synchronized(iterator) { if (it.hasNext()) it.next(); }`).
  - When to use: Only when you do not own the server code and cannot introduce a wrapper; the cost is repeated locking logic scattered across every client.
- **Server-Based Locking**: The shared object itself contains all synchronization — the lock is inside the class, not outside it.
  - When to use: Default preference. Keeps policy in one place, hides shared variables from callers, removes the burden from every client, and allows single-threaded deployments to swap in a non-synchronized version with no client changes.
- **Adapter-Based Locking**: When you cannot modify server code and client-based locking is unacceptable, wrap the third-party class in a thread-safe adapter that exposes a redesigned, atomic API (e.g., `getNextOrNull()` replaces the racy `hasNext()/next()` pair).
  - When to use: Integrating non-thread-safe library classes into a multithreaded context.

## Key Concepts
- **Possible Paths of Execution**: For N bytecode instructions across T threads with no branching, the number of valid interleavings is `(NT)! / (N!)^T` — a single Java line like `++lastIdUsed` compiles to 8 bytecode instructions, and with two threads that single operation already yields 12,870 possible orderings.
- **Atomicity**: An operation is atomic if it is uninterruptable. Assigning a 32-bit `int` is atomic per the JVM spec; assigning a `long` (64-bit) is not — two 32-bit writes can be separated. `++value` is never atomic: it expands to a load, an increment, and a store, each a separate bytecode instruction.
- **`synchronized`**: Establishes a mutex around a block or method; any thread entering must acquire the monitor, all others block. Synchronize as little as possible — only the critical section, not surrounding I/O or computation.
- **`volatile`**: Guarantees visibility (writes are flushed to main memory, reads always see the latest value) but does not guarantee atomicity of compound operations.
- **Thread Starvation**: One thread repeatedly fails to acquire necessary resources because other threads always get there first; results in low CPU utilization and degraded throughput with no deadlock.
- **Livelock**: Multiple threads cycle through acquiring and releasing the same resources in lockstep, consuming CPU without making progress.

## Mental Models

**The Bytecode Shuffler**: Think of two threads executing the same method as two hands shuffling a deck — one card (one bytecode instruction) from each hand in any order. Even a one-liner expands to 8 cards per hand; the number of valid shuffles is enormous. Any unsafe assumption about ordering is almost certainly wrong.

**The Four Deadlock Conditions**: Deadlock requires *all four simultaneously* — break any one to prevent it:
1. **Mutual Exclusion** — resources are held exclusively; sidestep with `AtomicInteger` or by increasing resource count.
2. **Lock & Wait** — a thread holds one resource while waiting for another; break by requiring all-or-nothing acquisition (check all before seizing any).
3. **No Preemption** — a thread cannot be forced to release a resource; break by using timed `tryLock()` calls that give up and retry.
4. **Circular Wait** — thread A holds what B needs, B holds what A needs; break by enforcing a global consistent acquisition order so cycles cannot form.

**Increasing Throughput via Decomposition**: For mixed I/O-bound and CPU-bound work, keep the synchronized critical section as small as possible (just the iterator's `getNextOrNull()` call), then let each thread do its own I/O independently. Three threads reading pages at 1 second each, parsing in parallel, yields 3× throughput — I/O overlap makes the CPU fully utilized.

**++i is Not What You Think**: The expression `++lastIdUsed` looks atomic in source but is three JVM operations: read the field onto the operand stack, increment it, write it back. Two threads can each read the same value (93), each increment to 94, and each write 94 — producing the same ID twice with no exception thrown.

## Anti-patterns
- **Client-Based Locking**: Distributes synchronization responsibility across every caller; any one programmer forgetting a `synchronized` block breaks the invariant for everyone. "Client-based locking really blows."
- **Synchronizing too broadly**: Wrapping entire methods including slow I/O under a single lock serializes work that could be concurrent; keep locks tightly scoped to the actual shared-state access.
- **Assuming `++` or `long` assignment is atomic**: These look like single operations in source but are multi-step at the JVM level and can be interleaved. Use `AtomicInteger`/`AtomicLong` or `synchronized` explicitly.
- **Fixing deadlock with debug statements**: Adding print/log calls changes scheduling enough to alter when deadlock occurs — problems move in time rather than being solved, often resurfacing weeks later in a different configuration.

## Key Takeaways
1. A single unprotected `++` on a shared field is enough to corrupt state; verify atomicity at the bytecode level, not the source level.
2. Prefer server-based locking: it reduces error surface, enforces a single policy, hides shared variables, and allows non-threaded deployment optimization.
3. Deadlock is not a race condition — it is a structural consequence of acquiring multiple resources in inconsistent order; the fix is a global acquisition order, not more synchronization.
4. The combinatorial explosion of valid thread interleavings makes correctness impossible to verify by inspection or casual testing; tool-assisted stress testing (e.g., IBM ConTest, `yield()`-insertion) is the only practical path to exposing bugs.
5. Throughput gains from threading come from decomposing work so threads spend most of their time doing independent I/O or CPU work, not waiting on a shared lock.

## Connects To
- **Ch 13**: Chapter 13 establishes the *principles* — SRP for thread-related code, keeping concurrency policy out of business logic, using thread-safe collections. Appendix A is the *mechanism* layer: it shows exactly why those principles are necessary by demonstrating the bytecode paths, the JVM atomicity model, the deadlock conditions, and worked examples of client- vs. server-based locking. Together they form a complete practitioner treatment: Ch 13 tells you what to do, Appendix A tells you why it matters at the machine level.
