# Chapter 5: Design in Construction

## Core Idea
Software design is an irreducibly wicked problem — it can only be fully understood by solving it — and the primary goal of all design activity is managing complexity, which McConnell names Software's Primary Technical Imperative.

## Frameworks Introduced
- **Managing Complexity**: The single most important goal of software design; all other heuristics serve it.
  - When to use: Every design decision — ask "does this reduce or increase complexity?"
  - How: Hide complexity behind clean interfaces; decompose into subsystems, classes, and routines; use abstractions that let you ignore implementation details

- **Design Heuristics**: A ranked toolkit of thinking tools for generating design decisions.
  - When to use: When facing any design question at any level (system → routine)
  - How: Apply in priority order — Find Real-World Objects → Form Consistent Abstractions → Encapsulate Implementation Details → Inherit When Possible → Hide Secrets (Information Hiding) → Identify Areas Likely to Change → Keep Coupling Loose → Look for Common Design Patterns

- **Information Hiding**: Each class hides one design decision ("secret") from all other classes.
  - When to use: Whenever deciding what to put in a class interface or how to partition a system
  - How: Ask "What does this class need to hide?" rather than "What is convenient to expose?" — hide volatile areas, implementation details, and likely-to-change data types

- **Identify Areas Likely to Change**: Anticipate change by compartmentalizing volatile components.
  - When to use: Early design; whenever requirements indicate likelihood of change
  - How: (1) Identify likely-change items; (2) Separate each into its own class or group with other components that change together; (3) Design interfaces that isolate those classes from the rest of the system

## Key Concepts
- **Wicked Problem**: A design problem that can only be clearly defined by solving it or part of it; software design is inherently wicked, not merely complicated.
- **Design Levels**: Five nested levels — (1) entire system, (2) subsystems/packages, (3) classes within subsystems, (4) data and routines within classes, (5) internal routine design.
- **Accidental Difficulty**: Difficulty in software that exists because of the tools and processes chosen, as opposed to essential difficulty inherent in the problem domain.
- **Abstraction**: A model of a concept that ignores irrelevant details while retaining essential ones; the mechanism for managing complexity at a higher level.
- **Encapsulation**: The enforcer of abstraction — prevents access to implementation details even when a programmer wants to look; without encapsulation, abstraction breaks down.
- **Coupling**: The degree to which two classes or routines depend on each other; loose (small, intimate, visible, flexible connections) is better than tight.
- **Cohesion**: How strongly related the operations within a class or routine are; functional cohesion (single purpose) is the ideal.
- **Design Patterns**: Ready-made cores of solutions to recurring software problems — Adapter, Facade, Factory Method, Observer, Singleton, Strategy, Template Method, and others.

## Mental Models
- Use the "wicked problem" model when design attempts fail — it is expected; the first attempt's purpose is to clarify the problem, not to produce the final solution.
- Think of information hiding as asking "What must this class keep secret?" to generate better interfaces than asking "What is convenient to expose?"
- Think of subsystem boundaries as hoses on a machine: the fewer hoses and the easier they are to reconnect, the better the architecture.
- Use top-down design when the problem is well understood; use bottom-up when you need to build confidence with concrete pieces first; combine both freely within the same design session.

## Anti-patterns
- **Jumping directly to class design**: Skipping the subsystem/package level leads to unmapped communication paths and tight coupling between unrelated components.
- **Exposing implementation details**: Breaks encapsulation, distributes knowledge of internals throughout the codebase, and makes change expensive system-wide.
- **Circular dependencies**: Class A calls class B which calls class A — violates information hiding and makes subsystems impossible to reuse independently.
- **Hard-coding literal values throughout a system**: Distributes knowledge of a constant (like array sizes) rather than hiding it in one named place (e.g., MAX_EMPLOYEES).
- **Premature commitment to first design**: Settling on the first attempt prevents discovering a better structure; the second attempt is nearly always better.

## Key Takeaways
1. Managing complexity is Software's Primary Technical Imperative — every other design decision is in service of this goal.
2. Design is a wicked problem; expect to "solve it once to define it" before solving it correctly — iteration is not failure.
3. Information hiding is the most powerful single heuristic: ask "What should this hide?" to generate better designs than object-oriented thinking alone.
4. Identify areas likely to change and compartmentalize them — great designers anticipate change as a distinguishing attribute.
5. Design at all five levels: system, subsystem, class, routine, and statement — skipping levels creates architectural debt.
6. Design patterns reduce first-principles effort; know Adapter, Facade, Factory Method, Observer, Singleton, Strategy, and Template Method.
7. Classes and routines are intellectual tools for reducing complexity — if they are not making the job simpler, they are not doing their jobs.

## Connects To
- **Ch6**: Working Classes applies the abstraction, encapsulation, and information-hiding heuristics at the class level
- **Ch7**: High-Quality Routines applies cohesion and coupling heuristics at the routine level
- **Ch3**: Software Architecture establishes subsystem-level design decisions that Ch5 elaborates
- **Ch24**: Refactoring is the safe mechanism for iterative design improvement once code exists
