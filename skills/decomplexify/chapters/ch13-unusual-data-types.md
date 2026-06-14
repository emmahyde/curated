# Chapter 13: Unusual Data Types

## Core Idea
Structures, pointers, and global data are each sources of disproportionate complexity and bugs; the unifying prescription is containment — wrap them in routines or classes so that the danger is isolated to one place rather than scattered across the codebase.

## Frameworks Introduced
- **Access Routines as Global Data Replacement**: Replace direct reads/writes of global variables with dedicated accessor and mutator routines that encapsulate the data.
  - When to use: Any time data genuinely needs wide visibility (configuration, shared state, singletons).
  - How: Create `GetX()` / `SetX()` routines; organize them with their data into a class. Benefits: centralized validation, ability to add instrumentation, ability to swap the underlying storage, and a single place to set breakpoints. Access routines give everything global variables give, and more.
- **Pointer Operation Isolation**: Contain all pointer manipulation inside routines or classes so that pointer errors are localized and defensive checks are applied uniformly.
  - When to use: Any use of raw pointers in languages that expose them (C, C++).
  - How: Never manipulate a pointer outside of its owning routine or class; check validity before use; set to null after freeing; assert not-null before deleting; fill freed memory with junk data to expose dangling-pointer use.

## Key Concepts
- **Structure**: A user-defined aggregate type grouping related data fields; in C/C++ a `struct`, in VB a `Structure`; in Java/C++ a class with only public data members acts as a structure.
- **Pseudoglobal Data**: A "monster object" containing a mishmash of unrelated data passed to every routine — satisfies the letter of "no globals" while providing none of the benefits of encapsulation; explicitly identified as an anti-pattern.
- **Dangling Pointer**: A pointer that has been freed/deleted but not set to null, leaving it pointing at memory that may be reallocated; use after free produces unpredictable behavior.
- **Access Routine**: A routine (getter/setter) that mediates all reads and writes to a piece of data, providing a layer of abstraction over the underlying storage.
- **Reserve Parachute**: A block of memory allocated at startup and freed when memory runs out, giving the program enough room to shut down gracefully and report the error rather than crashing.
- **Pointer Validity Check**: An assertion or conditional that verifies a pointer is non-null and (where possible) points to valid memory before it is dereferenced.
- **Linked-List Freeing Order**: Pointers in a linked list must be freed in the correct order (save next before freeing current) to avoid losing the chain.

## Mental Models
- Think of global data as class data for a class that hasn't been designed yet — the right fix is almost always to identify the class and move the data into it.
- Think of pointer operations as radioactive material: safe when handled inside shielded containers (routines/classes), dangerous when carried around loose (inline everywhere).
- Use structures when you find yourself passing three or more related variables as separate parameters to every routine — bundling them into a structure makes the relationship explicit and reduces parameter lists.
- Think of access routines as the interface to a "mini-module": the data is the private state, the routines are the public API, and the global variable is just the implementation detail hidden behind the API.

## Anti-patterns
- **Direct global variable access scattered through code**: Every read/write site is a potential bug location; impossible to add validation or instrumentation without touching every site.
- **Pseudoglobal "monster objects"**: Passing an enormous struct containing everything to every routine defeats encapsulation while adding parameter-passing overhead; it is global data with extra steps.
- **Dangling pointers (use after free)**: Freeing a pointer without nulling it allows subsequent reads to silently succeed and writes to corrupt memory; set pointers to null immediately after freeing.
- **Double-free errors**: Deleting or freeing a pointer that has already been freed; prevented by setting to null after free and asserting non-null before delete.
- **Using global variables to hold intermediate results**: Storing a partially computed value in a global during calculation couples the computation to the global's lifetime and makes re-entrancy impossible.
- **Structures instead of classes when behavior is needed**: A structure is appropriate only for pure data; if any invariant, validation, or operation belongs with the data, use a class.

## Key Takeaways
1. Use structures to bundle related data fields, making relationships explicit and reducing parameter-list length; prefer classes over structures when any behavior or privacy is needed.
2. Replace global variables with access routines organized into classes — access routines provide everything globals provide plus validation, instrumentation, and encapsulation.
3. Never disguise global data by packing everything into a monster object passed everywhere; this is pseudoglobal data and provides none of the benefits of encapsulation.
4. Isolate all pointer operations inside routines or classes; never manipulate raw pointers inline across the codebase.
5. After freeing a pointer: set it to null. Before deleting a pointer: assert it is not null. Use junk-fill on freed memory in debug builds to expose dangling-pointer use early.
6. Allocate a reserve parachute of memory at startup so the program can shut down gracefully if it runs out of memory.
7. Use global data only as a genuine last resort; when you must, document every global variable, use a naming convention that makes globals visible, and wrap all access in routines.

## Connects To
- **Ch10**: Global variables are the extreme case of maximum scope and live time — the access-routine pattern from this chapter is the practical remedy.
- **Ch12**: Arrays (introduced in Ch12) are a special case of structured data; pointer arithmetic on arrays is one of the most common pointer hazards.
- **Ch8**: Defensive programming practices — validity checks, assertions, junk-fill — are directly applied to pointer management here.
- **Ch6**: The prescription to prefer classes over structures and to organize access routines into classes connects directly to the class design principles in Ch6.
