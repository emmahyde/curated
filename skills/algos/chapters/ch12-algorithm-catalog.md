# Skiena's Algorithm Catalog — Problem Lookup

> **Source**: Skiena §12–18. Terse lookup table — one row per catalog problem. Follow the §/line reference for the full treatment.

---

## Data Structures (§12)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Dictionaries | Hash tables for 100–10M keys; balanced BST (red-black, skip list) when ordered traversal needed; sorted array if static | O(1) avg hash; O(lg n) BST | §12.1 |
| Priority Queues | Binary heap for most use; Fibonacci heap when decrease-key dominates (e.g., Dijkstra on dense graphs) | O(lg n) insert/extract; O(1) amortized decrease-key (Fibonacci) | §12.2 |
| Suffix Trees/Arrays | Suffix tree for substring search, LCS, pattern matching; suffix array when space matters; both O(n) build | O(n) build; O(m) query | §12.3 |
| Graph Data Structures | Adjacency lists for sparse; adjacency matrix for dense or O(1) edge lookup; hierarchical for huge graphs | O(V+E) lists; O(V²) matrix | §12.4 |
| Set Data Structures | Union-Find for membership/merge; Bloom filter for probabilistic membership; bit vectors for small universes | O(α(n)) union-find | §12.5 |
| Kd-Trees | kd-tree for point queries in low dimensions; quadtree/octtree for uniform data; BSP-tree for non-axis-aligned cuts | O(√n + k) query (2D) | §12.6 |

---

## Numerical Problems (§13)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Solving Linear Equations | Use LAPACK/LINPACK; Gaussian elimination with partial pivoting for dense; sparse solvers for sparse systems | O(n³) Gaussian | §13.1 |
| Bandwidth Reduction | Cuthill-McKee / BFS-based heuristics; production implementations available | — | §13.2 |
| Matrix Multiplication | Standard O(n³) for practical use; Strassen O(n^2.81) for theoretical interest; chain multiplication via DP | O(n³); O(n^2.81) Strassen | §13.3 |
| Determinants & Permanents | Gaussian elimination for determinants; permanent is #P-complete — use approximation or exact for small n | O(n³) det; exponential perm | §13.4 |
| Constrained/Unconstrained Optimization | Simulated annealing or gradient descent for continuous; LP/ILP for structured; analytic for formulaic | — | §13.5 |
| Linear Programming | Use existing solver (CPLEX, GLPK, lp_solve); simplex in practice; interior-point for large sparse | Poly (interior-pt); exp worst (simplex) | §13.6 |
| Random Number Generation | Use library (Mersenne Twister); never roll your own; seed from low-order clock bits | — | §13.7 |
| Factoring & Primality Testing | Miller-Rabin for probabilistic primality; AKS for deterministic; quadratic sieve / number field sieve for factoring | O(k log² n) Miller-Rabin | §13.8 |
| Arbitrary-Precision Arithmetic | Use GMP or Java BigInteger; FFT-based multiplication for huge numbers | O(n log n log log n) FFT mult | §13.9 |
| Knapsack Problem | DP on capacity for 0/1 knapsack; greedy (sort by value/weight) for fractional; NP-complete in general | O(nC) DP | §13.10 |
| Discrete Fourier Transform | FFT for all practical use; use FFTW library | O(n lg n) FFT | §13.11 |

---

## Combinatorial Problems (§14)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Sorting | Quicksort or mergesort for n > 100; insertion sort for tiny/nearly-sorted; heapsort for worst-case O(n lg n); radix sort for integer keys | O(n lg n) | §14.1 |
| Searching | Hash table for exact key lookup; binary search on sorted array for static data; B-tree for external memory | O(1) avg hash; O(lg n) binary search | §14.2 |
| Median & Selection | Quickselect (randomized) for expected O(n); median-of-medians for guaranteed O(n); full sort if multiple quantiles needed | O(n) expected | §14.3 |
| Generating Permutations | Heap's algorithm or Steinhaus-Johnson-Trotter for all n! permutations; rank/unrank for random access to k-th | O(n · n!) total | §14.4 |
| Generating Subsets | Lexicographic order for all 2^n subsets; Gray code for adjacent subsets differing by one element; rank/unrank for k-subsets | O(2^n) total | §14.5 |
| Generating Partitions | Generate integer partitions in lexicographically decreasing order; Knuth [Knu05b] is the best reference | O(p(n)) total | §14.6 |
| Generating Graphs | Use Prüfer sequences (bijection to labeled trees); match random graph model to application structure | — | §14.7 |
| Calendrical Calculations | Use a library; Zeller's congruence for day-of-week; handle leap years and calendar reform explicitly | O(1) | §14.8 |
| Job Scheduling | Greedy (EDF, shortest-job-first) for single-machine; NP-complete for multi-machine with dependencies | O(n lg n) greedy | §14.9 |
| Satisfiability | 2-SAT in linear time (implication graph + SCC); 3-SAT NP-complete — use DPLL/CDCL solvers (MiniSAT, Glucose) | O(V+E) for 2-SAT | §14.10 |

---

## Graph Problems: Polynomial-Time (§15)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Connected Components | BFS or DFS for undirected; Kosaraju's or Tarjan's SCC for directed; Union-Find for dynamic connectivity | O(V+E) | §15.1 |
| Topological Sorting | DFS with decreasing finish-time ordering; detect cycles in same pass; Kahn's (BFS-based) for iterative variant | O(V+E) | §15.2 |
| Minimum Spanning Tree | Prim's for dense; Kruskal's for sparse; both in Boost/LEDA | O(m lg n) Kruskal; O(n²) Prim dense | §15.3 |
| Shortest Path | Dijkstra for non-negative weights; Bellman-Ford for negative; Floyd-Warshall for all-pairs (small n); BFS for unweighted | O((V+E) lg V) Dijkstra; O(VE) B-F; O(V³) Floyd | §15.4 |
| Transitive Closure & Reduction | Warshall's (Floyd-Warshall with boolean ops) O(n³); repeated squaring for sparse | O(n³) Warshall | §15.5 |
| Matching | Hopcroft-Karp for bipartite max-cardinality; Edmond's blossom for general; Hungarian for weighted bipartite | O(E√V) Hopcroft-Karp | §15.6 |
| Eulerian Cycle / Chinese Postman | Hierholzer's if graph is Eulerian; add min-weight matching on odd-degree vertices for postman | O(E) Hierholzer | §15.7 |
| Edge & Vertex Connectivity | Flow-based: max-flow gives edge connectivity; DFS for bridges/articulation points in O(V+E) | O(V·E) flow-based | §15.8 |
| Network Flow | Use LEMON, GOBLIN, or Boost; max-flow: push-relabel or Dinic's; min-cost flow: successive shortest paths | O(V²E) push-relabel | §15.9 |
| Drawing Graphs Nicely | Force-directed (Fruchterman-Reingold) for general; layered (Sugiyama) for DAGs; use Graphviz/yFiles | NP-hard optimal; heuristics only | §15.10 |
| Drawing Trees | Reingold-Tilford for rooted trees; radial embedding for free trees | O(n) | §15.11 |
| Planarity Detection & Embedding | LR-planarity or Boyer-Myrvold in O(V+E); LEDA has robust implementations | O(V+E) | §15.12 |

---

## Graph Problems: Hard (NP-complete) (§16)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Clique | Branch-and-bound (Cliquer) for exact; greedy or SA for heuristic; reduction to/from independent set | NP-complete; exponential exact | §16.1 |
| Independent Set | Reduce to vertex coloring — largest color class is independent; greedy or backtracking | NP-complete | §16.2 |
| Vertex Cover | 2-approximation via maximal matching (guaranteed); LP rounding; exact only for small instances | NP-complete; 2-approx poly | §16.3 |
| Traveling Salesman Problem | Christofides (1.5-approx for metric TSP); LKH for near-optimal; Concorde for exact | NP-complete; 1.5-approx metric | §16.4 |
| Hamiltonian Cycle | Reduce to TSP (weight 1/2); Held-Karp DP+bitmask for exact small n; longest path in DAG is O(V+E) | NP-complete; O(2^n · n²) Held-Karp | §16.5 |
| Graph Partition | Spectral bisection (Laplacian eigenvector); Kernighan-Lin local search; METIS for large graphs | NP-complete; heuristics | §16.6 |
| Vertex Coloring | Greedy for upper bound; DSATUR heuristic; ILP for small exact; 4-color theorem for planar | NP-complete (≥3 colors) | §16.7 |
| Edge Coloring | Vizing's theorem: ∆ or ∆+1 colors sufficient; O(nm∆) constructive for ∆+1; GOBLIN for exact | O(nm∆) for ∆+1 colors | §16.8 |
| Graph Isomorphism | Nauty/Traces for practical exact; poly for planar and bounded-degree graphs | Not known NP-complete; no poly in general | §16.9 |
| Steiner Tree | Greedy (shortest-path based) gives (2−2/k)-approx; exact via ILP for small terminals | NP-complete; (2−2/k)-approx | §16.10 |
| Feedback Edge/Vertex Set | BFS to find shortest cycle, greedily remove; FES poly for undirected (matching-based); FVS NP-complete | NP-complete (FVS undirected) | §16.11 |

---

## Computational Geometry (§17)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Robust Geometric Primitives | Build on orientation test + in-circle; use exact arithmetic (CGAL, Shewchuk's predicates) | — | §17.1 |
| Convex Hull | Graham scan or Jarvis march for 2D; optimal O(n lg h); use CGAL for 3D+ | O(n lg n) 2D; O(n lg h) optimal | §17.2 |
| Triangulation | Delaunay (maximizes min angle) via Fortune's sweep or Bowyer-Watson; constrained Delaunay for obstacles | O(n lg n) | §17.3 |
| Voronoi Diagrams | Fortune's sweepline (best in practice); dual of Delaunay; CGAL preferred | O(n lg n) | §17.4 |
| Nearest Neighbor Search | kd-tree for low-d (d ≤ ~20); linear scan for tiny n; randomized kd-tree for approximate NN | O(√n + k) query (2D) | §17.5 |
| Range Search | Kd-tree or range tree for orthogonal queries; O(lg n + k) for axis-aligned | O(lg n + k) orthogonal | §17.6 |
| Point Location | Trapezoidal map or persistent data structures; O(lg n) query after O(n lg n) build; use CGAL | O(lg n) query | §17.7 |
| Intersection Detection | Bentley-Ottmann sweep for all-pairs n segment intersections; O(n²) if k small | O(n lg n + k) sweep | §17.8 |
| Bin Packing | First-fit decreasing (FFD) — sort descending, pack greedily; NP-complete for exact | NP-complete; FFD ≤ (11/9)OPT + 6/9 | §17.9 |
| Medial-Axis Transform | Voronoi diagram of boundary samples; pixel-based (morphological thinning) easier to implement | — | §17.10 |
| Polygon Partitioning | Triangulate then merge greedily; DP for min-piece decomposition; Hertel-Mehlhorn (4-approx convex) | O(n²) DP | §17.11 |
| Simplifying Polygons | Douglas-Peucker for polyline simplification; NP-complete in 3D; min-link in O(n lg n) | O(n lg n) 2D | §17.12 |
| Shape Similarity | Hamming for bitmaps; edit distance on skeletons; Hausdorff for point sets; Fourier descriptors for rotation-invariant | — | §17.13 |
| Motion Planning | Configuration space + free-space decomposition; Canny's roadmap for d DOF; PRM for high-d | O(n^d lg n) Canny | §17.14 |
| Maintaining Line Arrangements | Incremental construction O(n²); duality between points and lines useful; prefer CGAL | O(n²) | §17.15 |
| Minkowski Sum | Merge convex hull vertices in angular order for convex polygons; O(mn) for general; use CGAL | O(mn) general | §17.16 |

---

## Set and String Problems (§18)

| Problem | Recommended Approach | Complexity | Skiena § |
|---|---|---|---|
| Set Cover | Greedy (pick set covering most uncovered) gives ln(n)-approximation; ILP for exact; NP-complete | NP-complete; ln(n)-approx | §18.1 |
| Set Packing | Greedy; NP-complete; heuristics analogous to set cover | NP-complete | §18.2 |
| String Matching | KMP or Boyer-Moore for single pattern; Aho-Corasick for multiple; suffix tree/array for many queries on fixed text | O(n+m) KMP; O(n+m·|Σ|) Aho-Corasick | §18.3 |
| Approximate String Matching | Edit distance via DP (Wagner-Fischer); affine gap via separate insert/delete recurrences; Ukkonen's O(kn) for small k | O(nm) basic DP; O(kn) Ukkonen | §18.4 |
| Text Compression | Huffman for entropy coding; LZW/LZ77 (gzip) for general lossless; JPEG/H.264 for lossy; use libraries | — | §18.5 |
| Cryptography | AES for symmetric; RSA/ECC for public-key; use OpenSSL or platform library; never implement primitives yourself | — | §18.6 |
| FSM Minimization | Hopcroft's for DFA minimization; NFA from regex then subset construction to DFA; use standard regex library | O(n lg n) Hopcroft | §18.7 |
| Longest Common Substring/Subsequence | LCS via DP O(nm); suffix tree for LCS of two strings in O(n+m); k-way DP (exponential in k) | O(nm) DP; O(n+m) suffix tree | §18.8 |
| Shortest Common Superstring | Greedy (merge pair with maximum overlap); constant-factor approximation; NP-complete for exact | NP-complete; greedy approx | §18.9 |

---

*Indexed 75 catalog problems (§12.1–18.9), covering all 7 categories. §14.8 (Calendrical Calculations) and §13.2 (Bandwidth Reduction) had sparse recommendation text — approaches reflect source discussion rather than explicit "best" sentences.*
