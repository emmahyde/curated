# Fundamental Data Structures

## Core Idea
Choose your data structure by the operations you perform most. Arrays give O(1) random access and cache locality; linked lists give O(1) insert/delete without knowing capacity upfront. Every higher-level abstraction is a policy layer over one or both representations.

## Algorithms & Data Structures
- **Array**: O(1) index, O(n) unsorted search, O(log n) sorted. Dynamic: double at overflow, halve at quarter; amortized O(1) push. Source: Skiena §3.1; Sedgewick §1.3.
- **Linked List**: O(1) insert at head, O(n) search/delete-singly. Use when size unknown or mid-list splicing frequent. No binary search. Source: Skiena §3.1–3.2.
- **Stack / Queue / Bag**: All O(1) ops. Stack (LIFO): DFS, undo. Queue (FIFO): BFS, scheduling. Bag: add-only iterable multiset. Source: Sedgewick §1.3.
- **Dictionary / Symbol Table**: Seven ops — Search, Insert, Delete, Min, Max, Successor, Predecessor. Bounds vary; see table. Source: Skiena §3.2–3.3.
- **Hash Table**: Expected O(1) search/insert/delete (m ≈ n). Chaining: m lists ~n/m each. Worst O(n); predecessor/successor O(n+m). Source: Skiena §3.7.
- **BST / Balanced BST**: O(h); h = O(log n) balanced (red-black, splay). *Full treatment in BSTs chapter.* Source: Skiena §3.4.
- **Heap / Priority Queue**: O(log n) insert/delete-min, O(1) find-min. *Full treatment in Heaps chapter.* Source: Skiena §3.5.
- **Specialized**: Suffix trees for string matching; kd-trees for spatial. War story (Skiena §3.8): naïve BST → hash table → suffix tree, each swap forced by profiling.

## Key Concepts
- **Contiguous vs. linked**: Contiguous = O(1) index + cache; linked = O(1) insert/delete + no overflow.
- **ADT**: API decoupled from implementation; nail API first, swap stores freely. (Sedgewick §1.3)
- **Amortized O(1)**: Total cost of M ops is O(M); spikes (doubling) average out.
- **Loitering**: `a[N] = null` after pop prevents GC leak. (Sedgewick §1.3)

## Code / Pseudocode
```java
// Sedgewick Algorithm 1.1: ResizingArrayStack<Item>
public class ResizingArrayStack<Item> implements Iterable<Item> {
    private Item[] a = (Item[]) new Object[1];
    private int N = 0;
    private void resize(int max) {
        Item[] temp = (Item[]) new Object[max];
        for (int i = 0; i < N; i++) temp[i] = a[i];
        a = temp;
    }
    public void push(Item item) {
        if (N == a.length) resize(2 * a.length);
        a[N++] = item;
    }
    public Item pop() {
        Item item = a[--N];
        a[N] = null;                        // avoid loitering
        if (N > 0 && N == a.length / 4) resize(a.length / 2);
        return item;
    }
}
```
Demonstrates: doubling/halving resize, loitering fix, generics cast.

## Complexity / Reference Table

| Structure | Search | Insert | Delete | Min/Max | Successor | Notes |
|---|---|---|---|---|---|---|
| Unsorted array | O(n) | O(1) | O(1)* | O(n) | O(n) | *swap-with-last |
| Sorted array | O(log n) | O(n) | O(n) | O(1) | O(1) | binary search |
| Unsorted singly-linked | O(n) | O(1) | O(n) | O(n) | O(n) | delete needs predecessor |
| Unsorted doubly-linked | O(n) | O(1) | O(1) | O(n) | O(n) | O(1) delete w/ pointer |
| Sorted doubly-linked | O(n) | O(n) | O(1) | O(1)† | O(1) | †tail pointer maintained |
| Hash table (chaining) | O(n/m) exp | O(1) exp | O(1) exp | O(n+m) | O(n+m) | m buckets, n items |
| Balanced BST | O(log n) | O(log n) | O(log n) | O(log n) | O(log n) | red-black, splay |

Source: Skiena §3.2, §3.7.

## Cross-Book Contrast
**Skiena (§3.1–3.8)** frames every choice as *contiguous vs. linked*, drives decisions through the seven dictionary ops table, backed by profiling war stories. **Sedgewick (§1.2–1.3)** leads with locked ADT interfaces, two implementations each, empirical scoring; generics + iterator machinery absent from Skiena. Use Sedgewick for exact Java code; Skiena to decide which structure given an access pattern.

## Anti-patterns
- **Fixed-capacity stack**: Always use resizing unless capacity is truly fixed and known.
- **Sorted linked list for search**: Binary search impossible; use BST or hash table.
- **Hash table for ordered traversal**: Predecessor/Successor O(n+m); use balanced BST.
- **Ignoring loitering**: `a[N] = null` after pop not optional — live reference blocks GC.

## Key Takeaways
1. Contiguous → O(1) random access + cache; linked → O(1) insert/delete + no overflow.
2. Resizing arrays give amortized O(1) push: double at full, halve at quarter.
3. Hash tables O(1) expected but degrade to O(n) worst-case; no ordered traversal.
4. Lock ADT API before choosing implementation; swap stores without touching client code.

## Connects To
- **BSTs**: Dictionary upgrade for ordered traversal and worst-case guarantees.
- **Heaps**: Array-backed tree, O(log n) insert/delete-min.
- **Sorting**: Natural mergesort preferred for linked lists (no extra space, linearithmic).
- **Graphs**: BFS/DFS consume Queue/Stack; adjacency lists are linked structures.
