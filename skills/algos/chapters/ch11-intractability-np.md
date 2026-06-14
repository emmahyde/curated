# Intractability & NP-Completeness

## Core Idea
Some problems appear to require exponential time in the worst case. NP-completeness is the formal tool for proving this — and for knowing when to stop hunting for a poly-time algorithm and pivot to approximation, heuristics, or average-case-fast exact methods.

## Key Concepts

- **P**: Decision problems solvable in worst-case polynomial time. Sedgewick: "a precise characterization of all the problems that scientists, engineers, and applications programmers *do* solve with programs guaranteed to finish in a feasible time." (Sedgewick §11)
- **NP**: The set of all *search problems* — problems for which a proposed solution can be *verified* in polynomial time. Sedgewick: "NP is the set of all search problems." NP does not mean "non-polynomial." (Sedgewick §11; Skiena §9.9)
- **NP-complete**: In NP, and every NP problem poly-time reduces to it. A poly-time algorithm for any one NP-complete problem implies P = NP. (Skiena §9.9)
- **NP-hard**: At least as hard as any NP-complete problem; need not be in NP itself.
- **Polynomial-time reduction (A ≤_p B)**: A transformation f mapping instances of A to B in poly time such that answer to A(x) equals answer to B(f(x)). If A is NP-complete and A ≤_p B, then B is NP-hard. (Skiena §9.1; Sedgewick §11)
- **Cook-Levin theorem**: SAT is NP-complete. Every NP problem reduces to SAT. A fast SAT algorithm collapses the entire NP-complete class. (Skiena §9.9.3)
- **Complement trick**: S is a vertex cover of G iff V\S is an independent set. One O(V+E) complement connects three NP-complete problems. (Skiena §9.3.2)

## Algorithms

- **SAT / 3-SAT**: Given Boolean clauses, find a satisfying assignment. Cook's theorem makes SAT the root of all hardness reductions. 3-SAT restricts clauses to exactly 3 literals — no easier, but simpler to reduce *from*. Always use 3-SAT as the source for new hardness proofs. (Skiena §9.4)
- **Hamiltonian Cycle → TSP reduction**: Construct complete weighted graph G′; weight 1 if edge exists in G, else 2. Ham. cycle in G iff TSP tour cost ≤ n in G′. Runs O(n²). (Skiena §9.3.1)
- **Vertex Cover 2-approximation**: Pick any uncovered edge (u,v), add both to cover, remove all incident edges. Repeat. Returns cover ≤ 2 × OPT in poly time. (Skiena §9.10)

## The Canonical Reduction Chain

```
SAT  (Cook-Levin; root)
 └─→ 3-SAT
       └─→ Independent Set  ←→  Vertex Cover  ←→  Clique
                                      └─→ Hamiltonian Cycle
                                                └─→ TSP (decision)
```

Source: Skiena §9.3–9.5, Figure 9.2. Independent Set ↔ Vertex Cover is a complement (V\S is one iff S is the other). Clique follows from complementing the graph.

## Complexity / Reference Table

| Problem | Status | Notes |
|---|---|---|
| SAT | NP-complete | Cook-Levin; every NP problem reduces to it |
| 3-SAT | NP-complete | Clause-expansion from SAT; canonical source for reductions |
| Independent Set | NP-complete | Complement of vertex cover |
| Vertex Cover | NP-complete | 3-SAT → VC via variable edges + clause triangles |
| Clique | NP-complete | Independent set in complement graph |
| Hamiltonian Cycle | NP-complete | Reduces from vertex cover |
| TSP (decision) | NP-complete | Reduces from Hamiltonian Cycle in O(n²) |
| Vertex Cover approx | Poly-time, ≤ 2×OPT | Greedy matching; matching lower-bounds OPT |

*(Source: Skiena §9.3–9.10)*

## Cross-Book Contrast
**Skiena (§9.1–9.10)**: Practitioner framing — reduction zoo as recognition toolkit, "Art of Proving Hardness" (§9.6) prescribes which source to pick and how to simplify gadgets; equal time on post-hardness strategy (approximation, backtracking, heuristics). Use when classifying a new problem or picking a practical response. **Sedgewick (§11)**: Formal definitional grounding — P, NP, NP-complete as set memberships before any reduction examples; defines NP as "the set of all search problems." Use for rigorous conceptual hierarchy.

## Anti-patterns

- **Reduction in the wrong direction**: To prove B is hard, reduce *known hard* A *to* B (A ≤_p B). Reducing B to A shows only that B is solvable via A — says nothing about B's hardness. (Skiena §9.5)
- **Starting from SAT instead of 3-SAT**: Full SAT has variable-length clauses making gadgets unwieldy. Always start from 3-SAT. (Skiena §9.6)
- **Treating NP-completeness as the end**: Pivot to approximation (guaranteed ratio), pruned backtracking (fast average case), or heuristics (fast, no guarantee). (Skiena §9.10)
- **Confusing NP with "non-polynomial"**: NP means solutions are *verifiable* in poly time. Every P problem is in NP; P ⊆ NP is the open question.

## Key Takeaways

1. NP-completeness is a stop signal for exact poly-time algorithms — redirect to approximation, heuristics, or pruned backtracking.
2. Direction matters: A ≤_p B means "B is at least as hard as A." To show B is hard, reduce A (known hard) *to* B — always from 3-SAT (structured gadgets).
3. Cook-Levin is the foundation: every NP problem reduces to SAT; any poly algorithm for one NP-complete problem knocks them all down.
4. Slight variations flip tractability: Eulerian cycle ∈ P, Hamiltonian NP-complete; shortest path ∈ P, longest path NP-complete. (Independent Set ↔ Vertex Cover is one complement, two results.)

## Connects To

- **Graph Algorithms** (ch6): Vertex cover, independent set, clique, Hamiltonian cycle are graph problems; bipartite matching gives poly-time vertex cover on bipartite graphs.
- **Divide & Conquer / Dynamic Programming** (ch9): DP handles many NP-looking problems in pseudo-poly time (e.g., bounded-weight subset sum) — check for special structure before accepting hardness.
- **Greedy & Backtracking** (ch10): Greedy matching underlies the vertex cover 2-approximation; backtracking with pruning is the practical exact-solver fallback for NP-complete instances.
