# Algorithms Cheatsheet

## Growth-Rate Hierarchy (Skiena §2.3 — time at 1 op/ns)

| Class | f(n) | n=10 | n=100 | n=1,000 | n=1,000,000 |
|---|---|---|---|---|---|
| Constant | 1 | 1 ns | 1 ns | 1 ns | 1 ns |
| Logarithmic | lg n | ~3 ns | ~7 ns | ~10 ns | ~20 ns |
| Linear | n | 10 ns | 100 ns | 1 µs | 1 ms |
| Superlinear | n lg n | ~33 ns | ~664 ns | ~10 µs | ~20 ms |
| Quadratic | n² | 100 ns | 10 µs | 1 ms | 16.7 min |
| Cubic | n³ | 1 µs | 1 ms | 1 sec | 31.7 years |
| Exponential | 2ⁿ | ~1 µs | 4×10¹³ yr | useless | — |
| Factorial | n! | 3.63 ms | useless | — | — |

Dominance order: n! ≫ 2ⁿ ≫ n³ ≫ n² ≫ n lg n ≫ n ≫ lg n ≫ 1

## Sorting Algorithms (Sedgewick propositions F–K; Skiena §4)

| Algorithm | Best | Average | Worst | Space | Stable |
|---|---|---|---|---|---|
| Selection sort | N²/2 | N²/2 | N²/2 | 1 | No |
| Insertion sort | N | N²/4 | N²/2 | 1 | Yes |
| Shellsort | N lg N | *(open)* | N^(3/2)? | 1 | No |
| Mergesort | ½ N lg N | N lg N | N lg N | N | Yes |
| Quicksort | N lg N | 1.39 N lg N | N²/2 | lg N | No |
| 3-way Quicksort | N | 1.39 N lg N | N²/2 | lg N | No |
| Heapsort | N lg N | 2N lg N | 2N lg N | 1 | No |
| LSD radix sort | WN | WN | WN | N+R | Yes |
| MSD radix sort | N | N lg N | WN | N+WR | Yes |

*Quicksort space is recursion stack: lg N average, N worst without tail-call optimization. Shuffle before sorting eliminates adversarial worst case. LSD/MSD: W = key width, R = alphabet size.*

## Symbol-Table Implementations (Sedgewick §3.5)

| Data structure | Worst search | Worst insert | Avg search hit | Avg insert | Ordered ops | Memory |
|---|---|---|---|---|---|---|
| Sequential search (unordered list) | N | N | N/2 | N | No | 48N |
| Binary search (ordered array) | lg N | N | lg N | N/2 | Yes | 16N |
| BST | N | N | 1.39 lg N | 1.39 lg N | Yes | 64N |
| Red-black BST | 2 lg N | 2 lg N | 1.00 lg N | 1.00 lg N | Yes | 64N |
| Separate chaining† | < lg N | < lg N | N/(2M) | N/M | No | 48N+64M |
| Linear probing† | c lg N | c lg N | < 1.50 | < 2.50 | No | 32N–128N |

*† Uniform independent hash assumed. Linear probing at load factor α ≈ ½.*

## Priority Queue Operation Costs (Sedgewick §2.4; Skiena §3.5, §12.2)

| Implementation | Insert | Delete-max | Find-max | Decrease-key |
|---|---|---|---|---|
| Unordered array | O(1) | O(N) | O(N) | O(1) |
| Ordered array | O(N) | O(1) | O(1) | O(N) |
| Binary heap | O(lg N) | O(lg N) | O(1) | O(lg N) |
| Indexed binary heap | O(lg N) | O(lg N) | O(1) | O(lg N) |
| Fibonacci heap | O(1) amort. | O(lg N) amort. | O(1) | O(1) amort. |

## Graph Algorithms (Sedgewick §4; Skiena §5–7)

| Algorithm | Time | Space | Constraint | Notes |
|---|---|---|---|---|
| BFS (unweighted SP) | O(V+E) | O(V) | any graph | Shortest path in hops |
| DFS (traversal) | O(V+E) | O(V) | any graph | Topo sort, SCC, cycles |
| Prim lazy (MST) | ~E lg E | ~E | undirected | Simple; stale PQ entries |
| Prim eager (MST) | ~E lg V | ~V | undirected | Indexed PQ required |
| Kruskal (MST) | ~E lg E | ~E | undirected | Sort + union-find |
| Dijkstra (heap) | O(E lg V) | O(V) | no neg edges | Binary heap |
| DAG shortest path | O(E+V) | O(V) | DAG only | Handles negatives |
| Bellman-Ford | O(VE) | O(V) | no neg cycles | Detects neg cycles |
| Floyd-Warshall | O(V³) | O(V²) | no neg cycles | All-pairs DP |
| Edmonds-Karp flow | O(n³) augs | O(E) | — | BFS shortest augmenting path (Skiena §6.5) |

## String Search & Sorts (Sedgewick §5.1, §5.3)

| Algorithm | Guarantee | Typical | Backup? | Stable | Space |
|---|---|---|---|---|---|
| Brute force | MN | 1.1N | Yes | — | — |
| Knuth-Morris-Pratt | 2N | 1.1N | No | — | — |
| Boyer-Moore | MN | N/M | Yes | — | — |
| Rabin-Karp (Las Vegas) | 7N† | 7N | Yes | — | — |
| Rabin-Karp (Monte Carlo) | 7N† | 7N | No | — | — |
| LSD string sort | O(WN) | O(WN) | — | Yes | O(N+R) |
| MSD string sort | O(WN) | O(N lg N) | — | Yes | O(N+WR) |
| 3-way string quicksort | O(WN) | O(N lg N) | — | No | O(lg N+W) |

*† Rabin-Karp guarantee assumes random hash; M = pattern length, N = text length, W = key width, R = alphabet size.*

## Which Algorithm When

- **Sorting**: mergesort by default (stable, guaranteed N lg N); 3-way quicksort for primitives/duplicates; insertion sort for N<15 or nearly-sorted; LSD/MSD for fixed-width string keys, small R.
- **Symbol table**: hash table (chaining) for unordered O(1); red-black BST when you need order — traversal, floor/ceil, rank/select, or worst-case guarantees.
- **Shortest path**: Dijkstra (non-negative); Bellman-Ford (negative edges); DAG relaxation (DAG + negatives); Floyd-Warshall (all-pairs, small dense).
- **MST**: Kruskal (sparse, sort + union-find); eager Prim (denser, indexed PQ, E lg V).
- **NP-complete input**: approximation w/ ratio bound → backtracking + pruning → heuristics (simulated annealing) when no guarantee needed.
- **Substring search**: KMP / Monte-Carlo Rabin-Karp for streaming (no backup); Boyer-Moore for fastest practical w/ backup; suffix array/tree for many queries on one text.
- **DP vs greedy**: greedy when an exchange argument proves the greedy-choice property; DP when subproblems overlap and state space is polynomial; neither for general-graph longest-path (NP-hard).
- **Connectivity**: union-find for online dynamic (≈O(α(n))/op); BFS/DFS for offline or when path recovery needed.
