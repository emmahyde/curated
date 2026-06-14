# Divide & Conquer and Dynamic Programming

## Core Idea
Divide & conquer breaks a problem into independent subproblems, solves them recursively, and merges. Dynamic programming handles *overlapping* subproblems: store each result and look it up. The overlap is the entire motivation for DP.

## Algorithms & Complexity Table

| Algorithm | Time | Space | Source |
|---|---|---|---|
| Mergesort | O(n log n) | O(n) | Skiena §4, Sedgewick §2 |
| Quicksort (avg) | O(n log n) | O(log n) stack | Skiena §4, Sedgewick §2 |
| Edit Distance | O(mn) | O(mn) / O(m) rolling | Skiena §8.2 |
| LIS (basic DP) | O(n²) | O(n) | Skiena §8.3 |
| Linear Partition | O(kn³) / O(kn²) w/ prefix sums | O(kn) | Skiena §8.5 |
| Master theorem | *(not found in source slice)* — Skiena §4 covers mergesort/quicksort informally but does not state T(n)=aT(n/b)+f(n); consult CLRS §4.5 | — | — |

## Key Concepts

- **Optimal substructure**: Optimal solution contains optimal solutions to subproblems. DP only correct when this holds (Skiena §8.7.1). Fails for longest simple path — can revisit vertices.
- **Overlapping subproblems**: Same (i,j,…) tuple recurs across branches; caching pays off. Absent in D&C — mergesort never revisits the same subarray.
- **Memoization vs bottom-up**: Memoization adds a cache to a correct recursive algorithm (call-stack overhead persists). Bottom-up fills the table in dependency order — no stack, natural for space optimization.
- **Three steps (Skiena §8.3)**: (1) formulate recurrence, (2) bound state space to polynomial, (3) order evaluation so dependencies are ready.

## Code

```c
/* Edit distance — bottom-up DP (Skiena §8.2.2) */
/* D[i][j] = min cost to match P[1..i] against T[1..j] */
for i = 1 to |P|:
    for j = 1 to |T|:
        opt[MATCH]  = D[i-1][j-1] + match(P[i], T[j]);  /* 0 if equal, 1 if not */
        opt[INSERT] = D[i][j-1]   + 1;                   /* extra char in T */
        opt[DELETE] = D[i-1][j]   + 1;                   /* extra char in P */
        D[i][j] = min(opt[MATCH], opt[INSERT], opt[DELETE]);
/* Base: D[i][0] = i, D[0][j] = j */
```

## LIS Recurrence (Skiena §8.3)

`l[i] = 1 + max{ l[j] : j < i and S[j] < S[i] }` (= 1 if no such j). Answer = max(l[1..n]).

| s[i] | 2 | 4 | 3 | 5 | 1 | 7 | 6 | 9 | 8 |
|------|---|---|---|---|---|---|---|---|---|
| l[i] | 1 | 2 | 2 | 3 | 1 | 4 | 4 | 5 | 5 |

Longest = 5 (e.g. {2,3,5,6,8}).

## Cross-Book Contrast
This chapter is almost exclusively Skiena. Skiena §8 is a major standalone DP treatment: motivation, Fibonacci warm-up, edit distance, LIS, linear partition, correctness conditions, and war stories. Sedgewick (§2–3) covers mergesort/quicksort with exact Java implementations and tilde-notation constants but **has no standalone DP chapter**. For recurrence design and correctness pitfalls: Skiena. For production sort implementations: Sedgewick.

## Anti-patterns

- **Greedy for partition problems**: Targeting average partition size "is doomed to fail on certain inputs" (Skiena) — local decisions miss optimal splits. Use DP.
- **DP on graphs without ordering**: Longest simple path has no evaluation order; recurrence loops. DP requires inherent ordering (strings, sequences, trees).
- **Caching before correctness**: Memoizing an incorrect recurrence makes it wrong faster — verify recursively first.
- **Dropping table when reconstruction needed**: Two-column rolling optimization loses alignment recovery. Use Hirschberg's algorithm for O(nm) time and O(m) space with reconstruction.

## Key Takeaways

1. **D&C vs DP**: independent subproblems → D&C; overlapping subproblems → DP. Overlap is the only reason DP exists.
2. **Three-step recipe**: formulate recurrence → bound state space (polynomial) → fix evaluation order. Missing any step produces loops or wrong answers.
3. **Edit distance is universal**: LCS, LIS, approximate matching, and sequence alignment are variants achieved by changing `match()` and `indel()` costs.
4. **Left-to-right order is load-bearing**: DP works on strings, sequences, polygons, trees — fails on general graphs (longest simple path is NP-hard).

## Connects To

- **ch04-sorting**: Mergesort and quicksort are the canonical D&C examples; O(n log n) analysis is the primary payoff of recurrence reasoning.
- **ch07-weighted-graphs**: Bellman-Ford and Floyd-Warshall are shortest-path DPs; longest simple paths lack optimal substructure — NP-hard.
- **ch10-greedy**: Greedy is DP with one choice per step; DP needed when local optimality doesn't imply global.
- **ch11-np**: TSP solvable by DP in O(2^n · n); exponential state space marks the boundary with intractable problems (Skiena §8.7).
