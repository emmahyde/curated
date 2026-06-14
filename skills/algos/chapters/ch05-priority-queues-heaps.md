# Priority Queues & Heaps

## Core Idea
A priority queue supports `insert` and `delMax/delMin` in O(log N) time by maintaining a heap-ordered complete binary tree packed into an array. Use one when data arrives at arbitrary intervals and you need repeated access to the current extremum — re-sorting on each arrival is never correct.

## Algorithms & Data Structures

- **Binary Max-Heap (MaxPQ)**: Complete binary tree in array `pq[1..N]`; parent of `k` at `k/2`, children at `2k`/`2k+1`; root = maximum. Insert ≤ 1+lg N compares; delMax ≤ 2 lg N; max O(1). Source: Sedgewick §2.4.
- **Indexed Priority Queue (IndexMinPQ)**: Adds client integer indices; `change(k, item)` and `delete(k)` in O(log N); `min()`, `minIndex()`, `contains(k)` in O(1). Three arrays: `pq[]` (heap of indices), `keys[]` (values), `qp[]` (inverse — `qp[i]` = position of index `i`; -1 if absent). Source: Sedgewick §2.4. Use in Dijkstra/Prim for O(log V) decrease-key.
- **Heapsort**: Bottom-up construction (~2N compares) then sortdown (~2N lg N compares); total < 2N lg N + 2N compares, O(1) extra space. Source: Sedgewick §2.4 (Algorithm 2.7). See ch03 for sorting comparison table.

## Code

```java
// Algorithm 2.6 — swim, sink, insert, delMax (Sedgewick §2.4)
private void swim(int k) {
    while (k > 1 && less(k/2, k)) { exch(k/2, k); k = k/2; }
}
private void sink(int k) {
    while (2*k <= N) {
        int j = 2*k;
        if (j < N && less(j, j+1)) j++;
        if (!less(k, j)) break;
        exch(k, j); k = j;
    }
}
public void insert(Key v) { pq[++N] = v; swim(N); }
public Key delMax() { Key max = pq[1]; exch(1, N--); pq[N+1] = null; sink(1); return max; }

// Algorithm 2.7 — Heapsort (Sedgewick §2.4)
public static void sort(Comparable[] a) {
    int N = a.length;
    for (int k = N/2; k >= 1; k--) sink(a, k, N);
    while (N > 1) { exch(a, 1, N--); sink(a, 1, N); }
}
```

## Complexity / Reference Table

### PQ Operation Costs — Sedgewick §2.4, Proposition Q (worst-case compares)

| Data structure  | insert    | remove-max | find-max |
|-----------------|-----------|------------|----------|
| Ordered array   | N         | 1          | 1        |
| Unordered array | 1         | N          | N        |
| **Binary heap** | ≤ 1+lg N  | ≤ 2 lg N   | 1        |

### Skiena §3.5 — PQ Costs by Structure

| Structure      | Insert | Find-Min | Delete-Min |
|----------------|--------|----------|------------|
| Unsorted array | O(1)   | O(1)*    | O(n)       |
| Sorted array   | O(n)   | O(1)     | O(1)       |
| Balanced BST   | O(lg n)| O(1)     | O(lg n)    |

*\*All three achieve O(1) find-min via a cached pointer updated on insert, recomputed on deletion.*

### IndexMinPQ + Heapsort Costs (Sedgewick §2.4)

| Operation | Cost |
|---|---|
| insert, change, delete, delMin | O(log N) |
| contains, min, minIndex | O(1) |
| Heap construction (Prop R) | < 2N compares |
| Heapsort total (Props R+S) | < 2N lg N + 2N compares |

TopM (M largest in stream of N): elementary = O(NM); heap = O(N log M). Both O(M) space.

## Cross-Book Contrast

**Sedgewick** (§2.4): exact array encoding, swim/sink (Alg 2.6), Proposition Q (insert ≤ 1+lg N, delMax ≤ 2 lg N), indexed PQ with inverse array, heapsort (Alg 2.7). **Skiena** (§3.5): PQ as modeling abstraction — motivates via scheduling, presents three-structure tradeoff table, highlights cached-minimum trick, defers heap impl to §4.3. Key tension: Skiena shows O(1) find-min for all three via pointer; Sedgewick shows structural default (O(N) unordered) and O(1) for heap via `pq[1]`. Both correct; framing differs.

## Anti-patterns

- **Re-sorting on each insert**: O(n log n)/arrival vs. O(log n) with a PQ (Skiena names this explicitly).
- **0-indexed port without adjustment**: Sedgewick's heap is 1-indexed; every `k/2`, `2k`, `2k+1` must shift.
- **Skipping `pq[N+1] = null` in `delMax`**: loitering — GC cannot reclaim the evicted object.
- **Heapsort on cache-sensitive workloads**: non-local access causes far higher miss rate than quicksort; use only when O(1) extra space is a hard constraint.

## Key Takeaways

1. Binary heap: O(log N) insert and delMax; delMax needs 2 compares/level, insert needs 1.
2. Array encoding: children of `k` at `2k`/`2k+1`, parent at `k/2`; 1-indexed.
3. Bottom-up construction O(N) (Proposition R) — not O(N log N).
4. `IndexMinPQ` enables O(log N) decrease-key via inverse array `qp[]`; required for O(E log V) Dijkstra/Prim.
5. Heapsort: only comparison sort that is worst-case O(N log N) with O(1) space; poor cache limits practical use.

## Connects To

- **ch03 (Sorting)**: heapsort in sorting comparison table — cross-reference there; heap mechanics here.
- **Graph Algorithms (Dijkstra, Prim)**: both need `IndexMinPQ` for O(E log V).
- **Multiway Merge**: `IndexMinPQ` merges M sorted streams in O(N log M).
- **Balanced BSTs (Skiena §3.4)**: BSTs add successor/predecessor; heaps trade those for simpler array form.
