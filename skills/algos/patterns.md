# Algorithmic Design Patterns

## Divide and Conquer
**When**: Input splits into independent same-type subproblems with no shared state (mergesort subarrays, quicksort partitions are disjoint).
**How**: Split (usually in half), solve each part, combine. Mergesort T(n)=2T(n/2)+O(n) → Θ(n lg n). Quicksort: pick pivot, partition in-place, recurse both sides.
**Trade-offs**: Independent subproblems give clean worst-case guarantees but O(n) merge space; quicksort is in-place yet O(n²) on sorted input without randomization. (ch09)

## Dynamic Programming
**When**: Overlapping subproblems (same state recurs across branches) + optimal substructure, with a natural ordering on the state space (strings, sequences, DAGs, polygons — not general graphs).
**How**: (1) Recurrence over a polynomial state space; (2) bound the states (must be polynomial); (3) pick an order — bottom-up (fill smallest-first) or top-down (memoize). Examples: edit distance O(mn), LIS O(n²), linear partition O(kn²), Floyd-Warshall O(V³).
**Trade-offs**: Table can exceed memory before time — use a rolling array (O(m) rows) when only the cost is needed. Recovering the solution needs the full table or Hirschberg reconstruction. (ch09, ch07)

## Greedy
**When**: Greedy-choice property holds — a locally optimal choice is globally optimal, provable by an exchange argument. Examples: interval scheduling (earliest finish), Dijkstra, Prim, Kruskal, Huffman.
**How**: Take the locally best choice each step, no backtracking. Scheduling: accept earliest completion, drop overlaps, repeat. MST: add the min crossing edge (cut property).
**Trade-offs**: O(n log n) for sorting-based greedy. Fails silently when the property doesn't hold — always hunt counterexamples (ties, extremes, forced-bad choices) before trusting it. (ch07, ch10)

## Backtracking
**When**: Need all (or the best) solutions to a combinatorial problem; exponential search is unavoidable but pruning makes it tractable.
**How**: DFS over a search tree — generate next-position candidates, extend, recurse, undo. Prune the moment a partial solution is provably infeasible or non-optimal. Use DFS (O(height) space), never BFS (exponential width).
**Trade-offs**: Worst case exponential (O(n!) for permutations); fast in practice with aggressive pruning, intractable past n≈10–15 without it. Symmetry breaking cuts search by a factor of n. (ch10)

## Reduction
**When**: Prove hardness (map a known NP-complete problem to yours) or solve by mapping to a known-solvable problem.
**How**: To prove B hard — find known-hard A and a poly-time f where A(x)=Y iff B(f(x))=Y; the flow is A ≤ₚ B (A reduces TO B), proving B at least as hard. Canonical chain: SAT → 3-SAT → Independent Set ↔ Vertex Cover ↔ Clique → Hamiltonian Cycle → TSP.
**Trade-offs**: Direction is critical — reducing B to A proves B *solvable* via A, not B's hardness. Always reduce FROM a known-hard problem TO the target. (ch11)

## Randomization
**When**: Deterministic worst-case is bad (quicksort O(n²) on sorted input) but expected case is good; or a Monte Carlo approximation suffices (Rabin-Karp).
**How**: Quicksort — shuffle input to kill adversarial worst-case w.p. 1; random pivots give ~1.39 N lg N expected compares. Rabin-Karp — polynomial rolling hash; false positives possible (Monte Carlo) or verified (Las Vegas).
**Trade-offs**: Expected vs guaranteed O(n lg n): quicksort beats mergesort in practice (less data movement) despite ~39% more compares. Monte Carlo carries a tiny false-positive chance; Las Vegas removes it at backup cost. (ch03, ch08)

## Binary Search
**When**: Sorted random-access data — search, rank, floor, ceiling, select on a static/slow-changing ordered set.
**How**: Compare target to midpoint, drop half each step; O(lg N). Extends to "binary search on the answer space" for optimization with monotone feasibility.
**Trade-offs**: O(N) insert/delete on a sorted array (shifting) — use a red-black BST when those must be O(lg N) too. (ch04)

## BFS / DFS Graph Traversal
**When**: Connectivity, reachability, unweighted shortest path (BFS); topological order, cycle detection, SCC (DFS).
**How**: BFS — queue; discovers in non-decreasing distance from source; O(V+E). DFS — stack/recursion; discovery/finish times; pre/postorder hooks drive topo sort and SCC (Kosaraju/Tarjan).
**Trade-offs**: BFS gives unweighted distances; DFS gives structure (bridges, articulation points, SCC). Adjacency list O(V+E); adjacency matrix O(V²) regardless of edge count. (ch06)

## Union-Find (Disjoint Set Union)
**When**: Dynamic connectivity (online union/find), Kruskal edge filtering, connected components.
**How**: Weighted quick-union — each component a tree rooted at its rep; union merges smaller under larger; find traces to root. Size-doubling bounds height ≤ lg n, so ops are O(lg n). Path compression (flatten during find) → nearly O(1) amortized (inverse Ackermann α(n)).
**Trade-offs**: Weighted alone O(lg n); with path compression nearly O(1) amortized but more complex. No delete — static union only. (ch02, ch07)

## Heap-Based Selection / Priority Processing
**When**: Streaming top-M, min-weight frontier (Prim, Dijkstra), event-driven simulation.
**How**: Binary heap — insert/del-min O(lg N), find-min O(1); indexed PQ adds decrease-key O(lg N) for graph algorithms. Top-M of N: keep a size-M min-heap, discard anything below its min → O(N lg M).
**Trade-offs**: Heap beats sorting for streaming top-M (O(N lg M) vs O(N lg N)). Fibonacci heap gives O(1) amortized decrease-key (better Dijkstra on dense graphs) but is complex; binary heap suffices for nearly all uses. (ch05)

## Two-Pointer / Partition
**When**: In-place rearrangement around a pivot (quicksort partition), Dutch-flag 3-way partition, dedup of sorted arrays.
**How**: lo/hi pointers scan inward, swapping invariant violators. 3-way (Dijkstra): lt/i/gt pointers split into <, =, > pivot. O(N) per pass, O(1) extra space.
**Trade-offs**: In-place, O(1) space; standard 2-way is unstable. 3-way is entropy-optimal and O(N) when all keys equal. Needs random-access (arrays, not lists). (ch03)

## Substring Search
**When**: Find pattern P (len M) in text T (len N); streaming (no backup); multiple patterns; approximate matching.
**How**: KMP — precompute DFA O(M), scan once O(N), no backup. Boyer-Moore — bad-char heuristic skips text; sublinear typical. Rabin-Karp — rolling hash O(M+N) typical. Many queries: suffix array O(n) build + O(m lg n)/query; suffix tree O(n) build + O(m)/query.
**Trade-offs**: Boyer-Moore fastest in practice on long patterns with many mismatches. KMP and Monte Carlo Rabin-Karp are the only no-backup (streaming) options. Suffix structures amortize preprocessing over many queries. (ch08)
