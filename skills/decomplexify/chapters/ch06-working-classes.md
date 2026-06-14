# Chapter 6: Working Classes

## Core Idea
A class is the primary tool for managing complexity; every class should implement exactly one Abstract Data Type (ADT), present a consistent abstraction in its interface, and rigorously hide its implementation details.

## Frameworks Introduced
- **Abstract Data Types (ADTs)**: The conceptual foundation for every class — a collection of data together with the operations that work on that data, described at the level of the real-world entity rather than the underlying data structure.
  - When to use: Whenever you reach for a stack, list, queue, or any primitive container — ask "what does this represent?" and treat it as that entity, not as the container
  - How: Name the ADT after the real-world thing it models; expose operations in the vocabulary of that entity; never expose implementation-level details (array size, node pointers) through the interface

- **Good Encapsulation**: The enforcer that prevents access to implementation details even when a programmer wants to look — abstraction without encapsulation collapses.
  - When to use: Every class design decision about access levels
  - How: Minimize accessibility (prefer strictest level that preserves interface integrity); never expose member data in public; don't put private implementation details in header files; avoid friend classes and global data; observe the Law of Demeter (don't reach through one object to manipulate another)

## Key Concepts
- **ADT**: A data type defined by its operations and their semantics, independent of implementation — the conceptual unit every class should correspond to.
- **Class Interface**: The set of public routines that defines what a class does; should present one and only one consistent level of abstraction.
- **Containment ("has a")**: A class contains another object as a member — the workhorse of OO design, preferable to inheritance whenever the relationship is not genuinely "is a."
- **Inheritance ("is a")**: A subclass is a specialized version of its parent; use only when the subclass truly is a more specific version of the base class, and keep hierarchies shallow (max ~6 levels).
- **Cohesion (class level)**: All routines and data in a class should be related to the central purpose of the class; a class that implements a command stack, formats reports, and initializes global data has poor cohesion.
- **Coupling (class level)**: The degree to which a class depends on other classes; tight coupling (leaky abstractions, broken encapsulation) makes classes impossible to reuse or change safely.
- **Law of Demeter**: A routine should only call routines belonging to its own class, objects it creates, objects passed to it, or objects it contains — never reach through an object to call a routine on an object it returns.
- **Glass Box vs. Black Box**: A class with broken encapsulation is a glass box (internals visible); the goal is a black box (interface only visible).

## Mental Models
- Think of every class as implementing exactly one ADT — if you can't name the ADT, the class probably lacks coherent purpose.
- Use "is a" vs. "has a" as the containment/inheritance decision rule: model genuine specialization with inheritance; model composition with containment.
- Think of encapsulation as the enforcer of abstraction: you can have abstraction without encapsulation in theory, but in practice you will always have both or neither.
- Use the "consistent level of abstraction" test on a class interface: if some routines operate at the employee level and others at the linked-list level, the abstraction is broken.

## Anti-patterns
- **Class implementing more than one ADT**: Forces clients to understand multiple unrelated abstractions; split into focused classes.
- **Exposing member data as public**: Clients manipulate internals directly, the class loses control of its own invariants, and any representation change breaks all callers.
- **Deep inheritance hierarchies (>6 levels)**: Adds complexity counter to Software's Primary Technical Imperative; prefer containment.
- **Inheritance for code reuse alone**: "Is a" must be true — inheriting just to reuse routines creates misleading type relationships and fragile base-class problems.
- **Friend classes / violating encapsulation "just this once"**: Every exception erodes the abstraction boundary and spreads coupling.
- **Initializing member data outside the constructor**: Leads to partially constructed objects and subtle invariant violations.

## Key Takeaways
1. Class interfaces should provide a consistent abstraction — most class quality problems trace to violating this single principle.
2. Every class should implement one and only one ADT; if it implements more, split it.
3. Containment ("has a") is the workhorse of OO design; inheritance ("is a") is powerful but adds complexity — prefer containment when unsure.
4. Encapsulation is not optional decoration on top of abstraction — without it, abstraction breaks down in practice.
5. Minimize accessibility: favor the strictest access level that preserves the interface abstraction.
6. A class is the primary tool for managing complexity; give its design the attention needed to accomplish that objective.

## Connects To
- **Ch5**: Design heuristics (information hiding, abstraction, encapsulation) are the principles; Ch6 is their application at the class level
- **Ch7**: High-Quality Routines covers the internal design of each routine within a class
- **Ch14**: Organizing Straight-Line Code covers member data and initialization order
- **Ch3**: Software Architecture — subsystem design decisions constrain which classes communicate with which
