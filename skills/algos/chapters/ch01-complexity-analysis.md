# Complexity & Analysis of Algorithms

## Core Idea
Measure algorithmic efficiency by counting abstract operations on the RAM model, then characterize growth as input scales using asymptotic notation — independent of hardware, language, or constant factors.

## Algorithms & Data Structures
- **Binary Search**: Finds a target in a sorted array by halving the search space each step. O(log n). Source: Skiena §2.6; Sedgewick §1.4. Use when data is sorted and random access is available.
- **ThreeSum (brute force)**: Count triples summing to zero in N numbers. ~N³/6 array accesses, order of growth N³. Source: Sedgewick §1.4. Canonical example for empirical analysis; Proposition B (mathematical) supports empirical Property A (doubling test).

## Key Concepts
- **RAM Model**: Every simple operation and every memory access costs one time step; loops/subroutines composed of single steps. (Skiena §2.1)
- **Worst/Best/Average case**: Worst = max steps over all size-n instances; Best = min (e.g., insertion sort is Ω(n) on sorted input); Average = expected over a distribution (requires assumptions). (Skiena §2.1.1)
- **Big-Oh / Ω / Θ**: O = upper bound (c·g(n) ≥ f(n) for all n > n₀); Ω = lower bound; Θ = tight (both). (Skiena §2.2)
- **Tilde (~)**: g(N) ~ f(N) iff g(N)/f(N) → 1; keeps leading coefficient, enables prediction. More precise than Big-Oh. (Sedgewick §1.4)
- **Order of growth**: Dominant term of a tilde approximation stripped of its constant (N³/6 → N³). (Sedgewick §1.4)
- **Dominance**: g ≫ f when f = O(g) but g ≠ O(f). (Skiena §2.3.1)
- **Cost model**: The specific operation counted (e.g., array accesses for ThreeSum); order of growth of cost equals order of growth of running time. (Sedgewick §1.4)

## Code / Pseudocode
```java
// Sedgewick §1.4 — DoublingRatio: empirical order-of-growth measurement
public static void main(String[] args) {
    double prev = timeTrial(125);
    for (int N = 250; true; N += N) {
        double time = timeTrial(N);
        StdOut.printf("%6d %7.1f %5.1f\n", N, time, time/prev);
        prev = time;
    }
}
```
If doubling ratio converges to ~8, order of growth is N³ (2³=8); ratio 2^b implies N^b.

## Complexity / Reference Table

### Growth-Rate Hierarchy (Skiena §2.3 — time at 1 op/ns)

| Class | f(n) | n=10 | n=100 | n=1,000 | n=1,000,000 |
|-------|------|------|-------|---------|-------------|
| Constant | 1 | 1 ns | 1 ns | 1 ns | 1 ns |
| Logarithmic | lg n | ~3 ns | ~7 ns | ~10 ns | ~20 ns |
| Linear | n | 10 ns | 100 ns | 1 µs | 1 ms |
| Superlinear | n lg n | ~33 ns | ~664 ns | ~10 µs | ~20 ms |
| Quadratic | n² | 100 ns | 10 µs | 1 ms | 16.7 min |
| Cubic | n³ | 1 µs | 1 ms | 1 sec | 31.7 years |
| Exponential | 2ⁿ | ~1 µs | 4×10¹³ yr | *(useless)* | — |
| Factorial | n! | 3.63 ms | *(useless)* | — | — |

Dominance ordering: n! ≫ 2ⁿ ≫ n³ ≫ n² ≫ n lg n ≫ n ≫ lg n ≫ 1

### Tilde Approximations (Sedgewick §1.4)

| Exact function | Tilde | Order of growth |
|----------------|-------|-----------------|
| N³/6 − N²/2 + N/3 | ~N³/6 | N³ |
| N²/2 − N/2 | ~N²/2 | N² |
| lg N + 1 | ~lg N | lg N |
| 3 | ~3 | 1 |

### Java Memory (Sedgewick §1.4 — typical 64-bit JVM)

| Type | Bytes |
|------|-------|
| boolean, byte | 1 |
| char | 2 |
| int, float | 4 |
| long, double | 8 |
| Object overhead | 16 |
| Object reference | 8 |
| Integer object | 24 (16 + 4 + 4 padding) |

## Cross-Book Contrast
**Skiena** treats Big-Oh as the practitioner's primary tool: RAM model, worst-case default, growth-rate table for practical operating ranges. **Sedgewick** prefers tilde for prediction ("O(N²) cannot justify a doubling test"); keeps leading coefficients for concrete hypotheses validated empirically. Use Skiena for classification and design; Sedgewick for empirical validation and cost accounting.

## Anti-patterns
- **Asserting O(n²) is tight**: Big-Oh is an upper bound; use Θ or tilde for tight claims.
- **Skipping cost-model definition**: Wall-clock comparison conflates hardware with algorithm.
- **Trusting average-case without distribution**: Missing the input-distribution assumption makes the bound meaningless.
- **Using Big-Oh to compare algorithms**: f = O(n²) and g = O(n²) doesn't mean f ≈ g; use tilde or doubling tests.

## Key Takeaways
1. RAM model makes analysis machine-independent: count steps, not seconds.
2. Worst-case is the default guarantee; average-case requires a distribution assumption you rarely have.
3. Big-Oh/Ω/Θ classify growth classes; tilde (~) preserves leading coefficients for prediction.
4. Dominance ordering: n! ≫ 2ⁿ ≫ n³ ≫ n² ≫ n lg n ≫ n ≫ lg n ≫ 1.
5. Doubling ratio test: T(2N)/T(N) → r implies order of growth N^(lg r).

## Connects To
- **Sorting**: Establishes why comparison sorts are Ω(n lg n) and O(n²) is impractical for n > 10,000.
- **Divide & Conquer**: Merge sort's T(n)=2T(n/2)+n → Θ(n lg n) via master theorem requires this notation.
- **Graphs (BFS/DFS)**: O(V+E) bounds; dominance distinguishes sparse (E≈V) from dense (E≈V²) cases.
- **Hashing**: Amortized O(1) relies on RAM model's unit-cost memory access assumption.
