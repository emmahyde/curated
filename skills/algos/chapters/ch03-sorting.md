# Sorting

## Core Idea
Sorting reduces a vast class of problems to O(N lg N) work. Once sorted, searching, closest-pair, uniqueness, and frequency queries become trivial. The Ω(N lg N) lower bound means no comparison sort can do better; distribution sorts escape it by exploiting key structure.

## Algorithms & Data Structures
- **Selection Sort**: ~N²/2 comparisons, exactly N exchanges. Minimizes data movement; never use for large N. Source: Sedgewick §2.1.
- **Insertion Sort**: ~N²/4 comparisons average; N−1 best (sorted). Use for small N, nearly-sorted, or as cutoff (≤ ~10–15 elements). Source: Sedgewick §2.1.
- **Shellsort**: Insertion sort on h-interleaved subarrays; shrink h to 1. Increment 3x+1 (1,4,13,40…). Exact analysis open; empirically sub-quadratic; in-place, not stable. Source: Sedgewick §2.1.
- **Mergesort (top-down)**: ½–N lg N compares (Proposition F); ≤ 6N lg N accesses (Proposition G). Stable, O(N) auxiliary. **Asymptotically optimal** (Proposition J). Source: Sedgewick §2.2; Skiena §4.5.
- **Mergesort (bottom-up)**: Iterative sz=1,2,4,… pairwise merges. Same bound (Proposition H). No stack. Source: Sedgewick §2.2.
- **Quicksort**: ~1.39 N lg N average (Proposition K); O(N²) worst on sorted+fixed pivot. In-place, not stable. Shuffle first; cutoff M=5–15. Source: Sedgewick §2.3; Skiena §4.6.
- **Quicksort 3-way (Dijkstra)**: lt/eq/gt partition. O(N) all-equal; ~N lg N all-distinct. Entropy-optimal. Java `Arrays.sort()` for primitives. Source: Sedgewick §2.3.
- **Bucketsort**: Partition by key prefix, sort, concatenate. O(N) uniform; clusters → O(N²). Source: Skiena §4.8.

## Key Concepts
- **Stability**: Equal keys preserve relative order. Stable: insertion, mergesort. Unstable: selection, shell, quicksort, heapsort. (Sedgewick §2.1)
- **N lg N lower bound**: ≥ lg(N!) ~ N lg N compares worst case (Proposition I). N! leaves, min height lg(N!).
- **Entropy-optimal**: 3-way quicksort matches information-theoretic bound for duplicate-heavy inputs.
- **In-place**: O(1) extra (selection, insertion, shell, quicksort). Mergesort O(N).

## Code / Pseudocode
```java
// Sedgewick §2.3 — Quicksort partition (exact)
private static int partition(Comparable[] a, int lo, int hi) {
    int i = lo, j = hi + 1;
    Comparable v = a[lo];
    while (true) {
        while (less(a[++i], v)) if (i == hi) break;
        while (less(v, a[--j])) if (j == lo) break;
        if (i >= j) break;
        exch(a, i, j);
    }
    exch(a, lo, j);   // put v into position
    return j;         // a[lo..j-1] <= a[j] <= a[j+1..hi]
}
```
Demonstrates: two-pointer scan; single pivot placed exactly; one exchange to seat it.

## Complexity / Reference Table

| Algorithm | Best | Average | Worst | Space | Stable |
|---|---|---|---|---|---|
| Selection sort | N²/2 | N²/2 | N²/2 | 1 | No |
| Insertion sort | N | N²/4 | N²/2 | 1 | Yes |
| Shellsort | N lg N | *(not tight)* | N^(3/2)? | 1 | No |
| Mergesort | ½ N lg N | N lg N | N lg N | N | Yes |
| Quicksort | N lg N | 1.39 N lg N | N²/2 | lg N | No |
| 3-way Quicksort | N | 1.39 N lg N | N²/2 | lg N | No |

Shellsort exact analysis open; empirically far better than N². Quicksort space = recursion stack: lg N avg, N worst. Sources: Sedgewick props F, G, H, I, K; Skiena §4.6.1.

## Cross-Book Contrast
**Sedgewick** delivers exact propositions (F–K), tilde cost models, runnable Java; proves optimality (Proposition J) and entropy-optimality of 3-way quicksort. `Arrays.sort()`: 3-way quicksort for primitives, timsort for objects. **Skiena** leads with *why to sort*: six applications (searching, closest pair, uniqueness, frequency, selection, convex hull); covers Ω(N log N) extensions. Use Sedgewick for implementation; Skiena for deciding whether to sort.

## Anti-patterns
- **Fixed pivot on sorted input**: Degenerates to O(N²). Shuffle or use median-of-three.
- **Bucketsort on non-uniform data**: Clustered keys (Skiena §4.8 "Shifflett") cause no-progress refinement.
- **Quadratic sort at scale**: Fine for N=1,000; ruinous at N=100,000. Crossover ~N=10,000.
- **Ignoring stability**: Selection, shellsort, quicksort break multi-key sort order.

## Key Takeaways
1. Sort first — searching, closest-pair, uniqueness all reduce to O(N log N) (Skiena).
2. Ω(N lg N) is the comparison lower bound; no sort beats it worst-case (Proposition I).
3. Mergesort: guaranteed N lg N, stable; pay O(N) auxiliary.
4. Quicksort faster in practice; shuffle first, use 3-way for duplicate-heavy data.
5. Insertion sort wins for N < ~15 and nearly-sorted; use as cutoff.

## Connects To
- **ch05 (Heapsort)**: O(N log N) in-place worst-case, not stable; inseparable from heap structure.
- **ch04 (Binary Search)**: Requires sorted input.
- **ch07 (Hash Tables)**: Distribution sort and hashing share the uniformity assumption; both degrade on adversarial keys.
- **ch09 (Lower Bounds)**: Decision-tree Ω(N lg N) argument is the template for most comparison lower bounds.
