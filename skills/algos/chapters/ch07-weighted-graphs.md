# Weighted Graphs — MST, Shortest Paths, Flow

## Core Idea
Add edge weights and you get three canonical problems: cheapest spanning tree (MST), cheapest paths (shortest paths), and maximum throughput (flow). Each admits multiple algorithms with complexity trade-offs depending on graph density.

## Algorithms & Complexity Table

| Algorithm | Time | Space | Constraint | API (Sedgewick) |
|---|---|---|---|---|
| Prim simple | `O(V²)` | `O(V)` | undirected | — |
| Prim lazy (`LazyPrimMST`) | `~E log E` | `~E` | undirected | `LazyPrimMST(EdgeWeightedGraph G)` |
| Prim eager (`PrimMST`) | `~E log V` | `~V` | undirected | `PrimMST(EdgeWeightedGraph G)` |
| Kruskal (`KruskalMST`) | `~E log E` | `~E` | undirected | `KruskalMST(EdgeWeightedGraph G)` — `.edges()`, `.weight()` |
| Dijkstra simple | `O(V²)` | `O(V)` | no neg edges | — |
| Dijkstra heap (`DijkstraSP`) | `O(E log V)` | `O(V)` | no neg edges | `DijkstraSP(EdgeWeightedDigraph G, int s)` — `.distTo(v)`, `.pathTo(v)` |
| DAG SP (`AcyclicSP`) | `O(E+V)` | `O(V)` | DAG only; handles neg edges | `AcyclicSP(EdgeWeightedDigraph G, int s)` — Prop S |
| Bellman-Ford | `O(VE)` | `O(V)` | no neg cycles; detects them | `BellmanFordSP(EdgeWeightedDigraph G, int s)` |
| Floyd-Warshall | `O(V³)` | `O(V²)` | no neg cycles; all-pairs | — |
| Edmonds-Karp | `O(n³)` augs | `O(E)` | — | — |

**Sedgewick graph types:** `EdgeWeightedGraph`/`EdgeWeightedDigraph` — `addEdge(e)`, `adj(v)`; `Edge(v,w,weight)` — `.either()`, `.other(v)`, `.weight()`; `DirectedEdge(v,w,weight)` — `.from()`, `.to()`, `.weight()`.

## Key Concepts

- **MST Cut Property**: For any cut, the minimum-weight crossing edge belongs to some MST.
- **Relaxation**: `distTo[w] = distTo[v] + weight(v→w)` if cheaper than known best.
- **Union-Find height bound**: `O(log n)` — merging two trees of height h requires doubling node count, so at most `lg n` doublings. (Skiena §6.1)
- **Residual Graph / Augmenting Path**: Track remaining capacity per edge; any source-to-sink residual path increases total flow.
- **Negative Cycle**: Weight-sum-negative cycle makes shortest paths undefined (−∞); Bellman-Ford detects via Vth relaxation pass.

## Code / Pseudocode

**Kruskal (Skiena, exact):**
```c
kruskal(graph *g) {
    set_union s; edge_pair e[MAXV+1];
    set_union_init(&s, g->nvertices);
    to_edge_array(g, e);
    qsort(&e, g->nedges, sizeof(edge_pair), weight_compare);
    for (i = 0; i < g->nedges; i++)
        if (!same_component(s, e[i].x, e[i].y)) {
            printf("edge (%d,%d) in MST\n", e[i].x, e[i].y);
            union_sets(&s, e[i].x, e[i].y);
        }
}
```

**DAG shortest paths (Sedgewick, Prop S):**
```java
for (int v : top.order())   // EdgeWeightedTopological
    for (DirectedEdge e : G.adj(v))
        relax(e);            // O(E+V); handles negative edges
```

## Cross-Book Contrast
Sedgewick separates Prim into `LazyPrimMST`/`PrimMST` to expose the lazy-vs-eager trade-off and gives exact Java APIs with tilde-notation costs. Skiena treats these as solved ingredients and teaches *when* to reach for weighted graphs: §6.5–6.7 models scheduling, matching, routing, and covering as flow or MST — the reduction insight Sedgewick omits. For API: Sedgewick. For problem recognition and flow reductions: Skiena.

## Anti-patterns

- **Dijkstra on negative-edge graphs**: Distances finalized too early; wrong answers silently. Use Bellman-Ford or DAG SP.
- **Floyd-Warshall for single-source**: `O(V³)` vs `O(E log V)` — run Dijkstra instead.
- **Lazy Prim on dense graphs**: Stale PQ entries waste space vs `O(V²)` scan.
- **Bipartite matching by hand**: Reduces to max-flow in `O(n³)` — model as flow graph.

## Key Takeaways

1. MST and Dijkstra are structurally identical — only the extension condition differs (`min edge weight` vs `min cumulative distance`).
2. Prefer eager `PrimMST` (`~E log V`) over lazy on sparse graphs; Kruskal needs union-find with `O(log n)` per operation.
3. Dijkstra fails on negative edges — use Bellman-Ford `O(VE)` or topological relaxation `O(E+V)` for DAGs.
4. Floyd-Warshall all-pairs `O(V³)` only viable for small dense graphs; network flow subsumes bipartite matching.

## Connects To

- **ch02-data-structures**: Union-find (weighted quick-union) inside Kruskal.
- **ch05-priority-queues-heaps**: Indexed min-PQ bottleneck in eager Prim and heap-Dijkstra.
- **ch09-dp**: Floyd-Warshall is DP over intermediate vertices.
- **ch10-greedy**: MST and Dijkstra are canonical greedy algorithms — cut/optimality conditions are greedy exchange arguments.
- **ch11-np**: TSP, Steiner tree resist the polynomial algorithms here.
