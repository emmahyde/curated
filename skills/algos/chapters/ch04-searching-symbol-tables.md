# Searching & Symbol Tables

## Core Idea
A symbol table maps keys to values via `put` (insert/update) and `get` (search). Goal: O(lg N) for both — sequential search is O(N); balanced trees and hashing deliver O(lg N) or better.

## Algorithms & Data Structures

- **Sequential Search (unordered linked list)**: Linear scan on `get`; prepend on `put`. ~N²/2 compares to load N distinct keys. Source: Sedgewick §3.1 (Algorithm 3.1). Avoid unless N is tiny.
- **Binary Search (ordered array)**: `rank()` bisects in ≤ lg N + 1 compares; `put` shifts elements — O(N). Source: Sedgewick §3.1 (Algorithm 3.2). Use for static dictionaries only.
- **BST**: Recursive search/insert. Average ~1.39 lg N (Propositions C & D); worst N on sorted input. Source: Sedgewick §3.2 (Algorithm 3.3). Gives range queries free; shuffle or balance to avoid degenerate case.
- **Red-Black BST (left-leaning)**: BST encoding of a 2-3 tree via colored links. Height ≤ 2 lg N worst case (Proposition G); all ops O(lg N). Source: Sedgewick §3.3. Use when worst-case guarantees matter.
- **Separate Chaining**: Array of M linked-list STs; hash selects list. With M ≈ N/5, expected list length is constant (Proposition K). Source: Sedgewick §3.4 (Algorithm 3.5). Simpler than linear probing; handles high load gracefully.
- **Linear Probing**: Parallel key/value arrays; probe right cyclically. Keep α = N/M < ½; at α ≈ ½: ~3/2 probes hits, ~5/2 misses (Proposition M). Source: Sedgewick §3.4 (Algorithm 3.6). Better cache locality; degrades fast as α → 1.

## Code

```java
// BST recursive search and insert (Sedgewick Algorithm 3.3)
private Value get(Node x, Key key) {
    if (x == null) return null;
    int cmp = key.compareTo(x.key);
    if (cmp < 0) return get(x.left, key);
    else if (cmp > 0) return get(x.right, key);
    else return x.val;
}
private Node put(Node x, Key key, Value val) {
    if (x == null) return new Node(key, val, 1);
    int cmp = key.compareTo(x.key);
    if (cmp < 0) x.left = put(x.left, key, val);
    else if (cmp > 0) x.right = put(x.right, key, val);
    else x.val = val;
    x.N = size(x.left) + size(x.right) + 1;
    return x;
}
```

## Complexity / Reference Table

Sedgewick §3.5 († uniform independent hash; linear probing at α ≈ ½):

| Algorithm | Worst search | Worst insert | Avg search hit | Avg insert | Key interface | Memory |
|---|:---:|:---:|:---:|:---:|---|---|
| Sequential search (unordered list) | N | N | N/2 | N | `equals()` | 48N |
| Binary search (ordered array) | lg N | N | lg N | N/2 | `compareTo()` | 16N |
| BST | N | N | 1.39 lg N | 1.39 lg N | `compareTo()` | 64N |
| Red-black BST | 2 lg N | 2 lg N | 1.00 lg N | 1.00 lg N | `compareTo()` | 64N |
| Separate chaining † | < lg N | < lg N | N/(2M) | N/M | `equals()` `hashCode()` | 48N+64M |
| Linear probing † | c lg N | c lg N | < 1.50 | < 2.50 | `equals()` `hashCode()` | 32N–128N |

## Ordered ST API (Sedgewick §3.1)

```java
void put(Key key, Value val); Value get(Key key); boolean contains(Key key); void delete(Key key); int size(); boolean isEmpty(); Iterable<Key> keys()
Key min(); Key max(); Key floor(Key key); Key ceiling(Key key); int rank(Key key); Key select(int k); Iterable<Key> keys(Key lo, Key hi)
```

## Cross-Book Contrast

**Sedgewick** (§3.1–3.5): exact Java implementations, asymptotic propositions, empirical cost tables; emphasizes when guarantees kick in. **Skiena** (§4.6, §4.9): frames BSTs through the quicksort partition tree analogy (same reason avg quicksort depth is O(log N) gives BST avg height ~1.39 lg N); dictionary lens — use hash table for `get`/`put`/`delete` only; use BST for sorted order, predecessor, or range scans.

## Anti-patterns

- **Sorted insertion into plain BST**: height-N linked list; every op O(N). Use red-black BST or shuffle first.
- **Linear probing at high load**: at α > ½ clusters grow super-linearly; α = 1 deadlocks on miss. Resize to keep α ≤ ½.
- **Binary search for dynamic tables**: O(N) insert per key — use BST or hash table for write-heavy workloads.
- **Broken `hashCode`**: two equal keys must hash identically; violation silently corrupts the table.

## Key Takeaways

1. Sequential search Θ(N)/key; binary search O(N) insert — both are for special cases only.
2. Plain BST: ~1.39 lg N average; O(N) on sorted input — always balance or shuffle.
3. Red-black BST: ≤ 2 lg N height, O(lg N) for all ordered ops including floor/ceiling/rank/select (Proposition G).
4. Separate chaining simpler; linear probing faster cache but needs α < ½.
5. Hash tables beat trees on raw throughput; no ordered ops (floor, ceiling, range).
6. Rule: ordered ops → red-black BST; equality lookup only → hash table.

## Connects To

- **Sorting (ch02)**: BST structure mirrors quicksort partition trees; sorted-insert pathology = quicksort worst case.
- **Tries / String Keys (ch05)**: trie-based structures beat red-black BSTs on long-string keys.
- **Graph algorithms**: symbol tables map vertex names to indices — fast lookup is a prerequisite.
