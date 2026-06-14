# Graphs — Representation & Traversal

## Core Idea
A graph G = (V, E) with n vertices and m edges can be represented as an adjacency matrix or adjacency list; the right choice governs traversal, edge lookup, and memory. BFS and DFS are the two universal traversal strategies from which connected components, topological sort, bipartite detection, articulation vertices, and strong components are all derived in O(V + E).

## Algorithms & Data Structures

- **Adjacency List**: Array of linked lists; space O(n+m). Skiena §5.2 / Sedgewick §4.1. Standard for sparse graphs (m ≪ n²).
- **Adjacency Matrix**: n×n boolean; O(n²) space, O(1) edge test. Skiena §5.2. Use only when dense or O(1) membership is critical.
- **BFS**: FIFO queue; explores distance-k before k+1. O(V+E). Skiena §5.6 / Sedgewick §4.1. Use for unweighted shortest paths, components, bipartite detection.
- **DFS**: Recurse to depth; backtrack. O(V+E). Skiena §5.8 / Sedgewick §4.1–4.2. Use for topo sort, cycle detection, SCCs, articulation vertices; maintains entry/exit times.
- **Connected Components**: Outer loop over unmarked vertices, DFS from each. O(V+E). Sedgewick §4.1 (Alg 4.3).
- **Topological Sort**: DFS reverse postorder on a DAG. O(V+E). Sedgewick §4.2 / Skiena §5.10.1. Cycle invalidates ordering.
- **Bipartite / Two-Coloring**: BFS alternating colors; conflict on non-discovery edge = not bipartite. O(V+E). Skiena §5.7.2 / Sedgewick §4.1.
- **Articulation Vertices**: Single DFS tracking entry times and earliest reachable ancestor. O(V+E). Skiena §5.9.2. Three cases: root ≥2 children; bridge cut-node; parent cut-node.
- **Strong Components (Kosaraju)**: (1) DFS on G^R for reverse postorder; (2) DFS on G in that order — each new tree = one SCC. O(V+E). Sedgewick §4.2 (Alg 4.6).

## Code

```java
// Sedgewick §4.1/4.2 APIs
public class Graph   { Graph(int V); void addEdge(int v, int w); Iterable<Integer> adj(int v); int V(); int E(); }
public class Digraph { Digraph(int V); void addEdge(int v, int w); Iterable<Integer> adj(int v); Digraph reverse(); int V(); int E(); }

// Kosaraju SCC — Algorithm 4.6 (Sedgewick §4.2)
DepthFirstOrder order = new DepthFirstOrder(G.reverse());
for (int s : order.reversePost()) if (!marked[s]) { dfs(G, s); count++; }
// dfs: marked[v]=true; id[v]=count; recurse into unmarked adj
// stronglyConnected(v,w): id[v]==id[w]
```

Skiena §5.8 DFS: `entry[u]=time++` on discovery; `process_edge` hook per neighbor; recurse undiscovered; `exit[u]=time++` on finish (`process_vertex_late`). Time intervals encode ancestry.

## Complexity / Reference Table

All traversal algorithms: O(V+E) time, O(V) space — except Kosaraju O(V+E) space (reverse graph copy). Adjacency list: O(n+m) space, Θ(m+n) traversal. Adjacency matrix: O(n²) space, O(1) edge test, Θ(n²) traversal. Prefer list for all but densest graphs.

## Cross-Book Contrast

**Skiena**: BFS/DFS as a generic toolkit — `process_vertex_early`, `process_vertex_late`, `process_edge` hooks; all applications (two-coloring, articulation, topo sort) are parameterizations of the same framework. Emphasizes modeling and representation choice. **Sedgewick**: API-first — `Graph`/`Digraph` as stable interfaces; each application (CC, Bipartite, Topological, KosarajuSCC) is a separate client class; complexity stated as propositions. Use Skiena to understand *why* and *when*; use Sedgewick to implement correctly.

## Anti-patterns

- **Adjacency matrix for sparse graphs**: O(n²) space and Θ(n²) traversal for m ≪ n².
- **DFS topo sort without cycle detection**: a cycle makes no valid ordering; check for back edges.
- **Single DFS pass for SCCs**: finds reachability, not mutual reachability; Kosaraju needs two passes.
- **Brute-force articulation search**: O(n(m+n)) delete-and-check unnecessary; single O(V+E) DFS suffices.
- **Substituting DFS for BFS**: BFS gives shortest paths (unweighted); DFS gives entry/exit times — not interchangeable.

## Key Takeaways

1. Prefer adjacency lists — O(m+n) beats O(n²) traversal and memory for sparse graphs.
2. BFS and DFS both O(V+E); choice depends on what you compute *during* traversal.
3. DFS entry/exit intervals encode full ancestry — exploit for topo sort, SCCs, cut vertices.
4. Connected components and SCCs both reduce to repeated DFS; SCCs add a second pass on the reversed graph.
5. Topological sort = DFS reverse postorder on a DAG; any cycle invalidates it.
6. Kosaraju is easy to code (two DFS passes) but subtle to prove.

## Connects To

- **ch07 (Weighted Graphs / MST / Shortest Paths)**: adjacency list + edge weights; Dijkstra and Prim extend BFS/DFS with priority queues.
- **ch09 (Dynamic Programming)**: DP on DAGs requires topological ordering — this chapter is the prerequisite.
- **ch02 (Data Structures)**: queue vs. stack selects BFS vs. DFS; union-find is O(α) alternative for connected components (Sedgewick §1.5).
- **ch10 (Backtracking)**: DFS with pruning is backtracking; graph coloring and Hamiltonian path build on DFS.
