# Strings

## Core Idea
Character-by-character decomposition unlocks linear-time sorts, constant-time prefix search, and guaranteed-linear substring matching — none achievable with comparison-based methods. Choosing the right primitive determines whether you pay O(N) or O(MN).

## Algorithms & Complexity Tables

### String Sorts (Sedgewick §5.1)

| Algorithm | Time (worst) | Time (avg) | Space | Notes |
|---|---|---|---|---|
| Key-Indexed Counting | O(N+R) | O(N+R) | O(N+R) | Zero comparisons; foundation of LSD/MSD |
| LSD (Alg 5.1) | O(WN) | O(WN) | O(N+R) | Fixed-length W only; Prop B: stable |
| MSD (Alg 5.2) | O(WN) | ~N log_R N (Prop C) | O(N+R·W) | Worst ~7wN+3WR (Prop D); cutoff critical |
| 3-Way String Quicksort (Alg 5.3) | O(WN) | ~2N ln N (Prop E) | O(log N) | Best for real variable-length data |

### Substring Search (Sedgewick §5.3 — exact numbers)

| Algorithm | Guarantee | Typical | Backup? | Extra Space |
|---|---|---|---|---|
| Brute force | MN | 1.1N | yes | 1 |
| KMP full DFA (Alg 5.6) | 2N | 1.1N | no | MR |
| KMP mismatch-only | 3N | 1.1N | no | M |
| Boyer-Moore heuristic (Alg 5.7) | MN | N/M | yes | R |
| Boyer-Moore full | 3N | N/M | yes | R |
| Rabin-Karp† Monte Carlo (Alg 5.8) | 7N | 7N | no | 1 |
| Rabin-Karp† Las Vegas | 7N† | 7N | yes | 1 |

†Probabilistic guarantee with uniform and independent hash function.

### Tries / TST (Sedgewick §5.2)

| Structure | Search hit | Search miss (avg) | Space |
|---|---|---|---|
| R-way Trie (`TrieST`) | ≤ 1+\|key\| accesses (Prop G) | ~log_R N nodes (Prop H) | R×nodes |
| TST | ~\|key\| char compares | ~ln N (Prop K); links 3N–3Nw (Prop J) | 3N–3Nw links |

**Other:** NFA/Regex (Alg 5.9): O(M) construction, O(MN) simulation — epsilon-transition digraph, reachable-state BFS avoids exponential backtracking. Huffman: optimal prefix-free code, requires two passes. LZW: adaptive, no pre-scan.

## Code

```java
// KMP: DFA construction + search (Sedgewick Alg 5.6)
// dfa[c][j] = next state after seeing char c at state j
int[][] dfa = new int[R][M];
dfa[pat.charAt(0)][0] = 1;
for (int X = 0, j = 1; j < M; j++) {
    for (int c = 0; c < R; c++) dfa[c][j] = dfa[c][X]; // mismatch: restart from X
    dfa[pat.charAt(j)][j] = j + 1;                      // match: advance
    X = dfa[pat.charAt(j)][X];                          // update restart state
}
for (int i = 0, j = 0; i < N; i++) {
    j = dfa[txt.charAt(i)][j];
    if (j == M) return i - M; // found; i never backs up
}
```

## Cross-Book Contrast
Sedgewick gives exact Java implementations with proven propositions and the full cost table (guarantee/typical/backup/space). Skiena (§18.3–18.5) frames these as catalog decisions: expect misses → Boyer-Moore; worst-case linear or streaming → KMP; simplicity + 2D → Rabin-Karp. Skiena also covers approximate matching (edit distance §18.4) and suffix arrays for bioinformatics — angles Sedgewick omits.

## Anti-patterns

- **MSD with no cutoff**: O(NR) on distinct keys — cutoff to insertion sort for subarrays < 15.
- **R-way trie on Unicode**: 65,536-link nodes prohibitive; use TST.
- **Boyer-Moore heuristic-only on adversarial input**: MN worst-case; add good-suffix table for 3N guarantee.
- **Backtracking regex NFA**: O(2^M) catastrophic — use reachable-state BFS (Sedgewick Alg 5.9).

## Key Takeaways

1. Key-indexed counting beats comparison sort (O(WN) vs O(WN log N)) — characters are indices, not comparators.
2. KMP never backs up (ideal for streams); Boyer-Moore fastest on misses (N/M typical); Rabin-Karp simplest and extends to 2D.
3. "Backup?" is the streaming decision column — only KMP full DFA and Rabin-Karp Monte Carlo eliminate it.
4. TST beats R-way trie: similar hit speed, vastly less space, same ordered-operations support.

## Connects To

- **ch02-sorting**: Key-indexed counting is radix-generalized counting sort; 3-way string quicksort is character-keyed 3-way quicksort.
- **ch03-symbol-tables**: TrieST replaces BST for string keys; TST is BST-inside-trie.
- **ch04-graphs**: KMP DFA is a directed graph; NFA epsilon transitions use DFS/BFS on a Digraph.
- **ch09-dp**: Edit distance (Skiena §18.4) is the canonical string DP.
