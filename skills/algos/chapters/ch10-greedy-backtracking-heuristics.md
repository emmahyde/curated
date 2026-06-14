# Greedy, Backtracking & Combinatorial Search

## Core Idea
Greedy algorithms are correct only when the greedy-choice property holds — not merely when they "make sense." When optimality cannot be guaranteed, backtracking enumerates the full search space with pruning. When even pruned backtracking is too slow, simulated annealing trades guarantees for practicality.

## Algorithms

- **Nearest-Neighbor Heuristic (TSP)**: From current point, visit closest unvisited. O(n²). **Wrong** — produces arbitrarily bad tours; heuristic only. (Skiena §1.1)
- **OptimalScheduling (EarliestDeadlineFirst)**: Accept job with earliest completion date; delete it and all overlapping jobs; repeat. O(n log n). **Correct** — exchange argument proves optimality. (Skiena §1.2)
- **Backtracking (DFS on partial solutions)**: Extend partial solution vector; prune when dead; recurse. Exponential worst case; pruning can cut orders of magnitude. (Skiena §7.1)
- **Simulated Annealing**: Accept improving moves always; accept worsening with probability e^(-δ/kT), T decreasing on cooling schedule. Escapes local optima. (Skiena §7.5.3)
- **Genetic Algorithms**: Population + crossover + mutation. Skiena's verdict: slower than SA on combinatorial problems; rarely exploits structure. Prefer SA. (Skiena §7.8)

## Key Concepts

- **Greedy-choice property**: A globally optimal solution can always be constructed by making locally optimal choices — the precondition for correctness.
- **Exchange argument**: Any solution not matching the greedy choice can be transformed to one that does without worsening the objective.
- **Candidate set Sₖ**: At depth k, the legal extensions of the current partial solution; restricting this set is the primary pruning lever.
- **Cooling schedule / Local neighborhood**: Rate T decreases in SA; too fast → stuck; too slow → wastes time. Neighborhood design is critical to SA quality.

## Code / Pseudocode

```c
// General backtracking skeleton (Skiena §7.1)
Backtrack-DFS(A, k)
  if A = (a1,...,ak) is a solution, report it.
  else
    k = k + 1; compute Sk
    while Sk ≠ ∅ do
      ak = element in Sk; Sk = Sk − ak
      Backtrack-DFS(A, k)
```

## Complexity Table

| Algorithm | Time | Space | Optimal? |
|---|---|---|---|
| Nearest-Neighbor (TSP) | O(n²) | O(n) | No — arbitrarily bad |
| OptimalScheduling | O(n log n) | O(n) | Yes |
| Backtrack all permutations | O(n · n!) | O(n) | Yes (exact) |
| Backtrack all subsets | O(n · 2ⁿ) | O(n) | Yes (exact) |
| Simulated Annealing | *(not found in source slice — problem-dependent)* | O(n) | No |
| Genetic Algorithm | *(not found in source slice)* | O(pop·n) | No |

## Cross-Book Contrast
Skiena §1.1–1.2 grounds greedy in concrete failure modes and exchange-argument proofs; §7 provides the full backtracking/SA methodology. Sedgewick covers these lightly — use Sedgewick for heap/PQ API, Skiena to decide greedy vs. backtracking vs. annealing.

## Anti-patterns

- **Greedy without proof**: Nearest-neighbor, earliest-start-time, shortest-job-first all fail on counterexamples. Prove greedy-choice property first.
- **Exhaustive search without pruning**: Prune as soon as partial solution is provably nonoptimal; without pruning, backtracking is intractable beyond n ≈ 10–15.
- **GA over SA**: GA crossover/mutation rarely exploits problem structure; SA typically converges faster.
- **BFS backtracking**: DFS uses O(height) space; BFS uses O(width) — exponential. Always DFS for backtracking.

## Key Takeaways

1. Greedy is correct only when provable — exchange argument or find counterexamples (ties, extremes, blocking).
2. `OptimalScheduling` (earliest-deadline-first) is provably correct; `NearestNeighbor` for TSP is provably a heuristic.
3. Backtracking template: model solutions as a vector, define candidate sets, recurse DFS, prune early.
4. Pruning beats all other optimizations — cutting 95% of the search tree matters more than inner-loop speedups.
5. Practical backtracking limit: ~15–50 items; beyond that, switch to heuristics. SA is the default heuristic; neighborhood design is the critical SA decision.

## Connects To

- **Dynamic Programming**: When greedy fails but subproblems overlap — DP computes exact optimum.
- **NP-Completeness**: Backtracking is the canonical exact solver for NP-hard problems; limits motivate approximation/heuristics.
- **Graph Algorithms**: Graph path enumeration is a direct application of the backtracking framework (Skiena §7.1.3).
- **Sorting & Priority Queues**: Greedy algorithms like OptimalScheduling require efficient sorted access; Sedgewick's heap/PQ is the practical substrate.
