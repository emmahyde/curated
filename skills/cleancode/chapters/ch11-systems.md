# Chapter 11: Systems

## Core Idea
Software systems must separate the startup process (construction) from runtime logic (use); mixing the two produces systems that are hard to test, hard to evolve, and impossible to reason about in isolation. Clean at the code level is not enough—clean must scale to the system level.

## Frameworks Introduced
- **Separate Constructing a System from Using It**: The construction phase (wiring objects and dependencies together) is a distinct concern from the runtime logic that follows. Interleaving them via lazy-initialization idioms violates SRP, contaminates test paths, and embeds hard-coded dependencies that resist substitution.
  - When to use: Always—treat startup as a first-class architectural seam, not an afterthought.

- **Separation of Main**: Move all construction to `main` (or modules called by `main`). The application receives fully-constructed, wired objects and has zero knowledge of how they were built. Dependency arrows cross the main/app boundary in one direction only—away from `main`.
  - When to use: Default construction strategy for straightforward systems where the app doesn't need runtime control over object creation timing.

- **Abstract Factory (Factories)**: When the application must control *when* objects are created (e.g., `LineItem` instances added to an `Order` at runtime), delegate construction to an Abstract Factory interface. The implementation lives on the `main` side; the application holds the interface. Dependencies still point away from the app toward `main`.
  - When to use: Runtime-timed creation where the app needs control over timing but not over construction details.

- **Dependency Injection (DI) / Inversion of Control (IoC)**: A class declares its dependencies via constructor arguments or setter methods and takes no steps to resolve them. A dedicated DI container (e.g., Spring) instantiates objects, wires dependencies from a configuration file or module, and manages lifecycle. IoC moves secondary responsibilities off the object onto a purpose-built mechanism, reinforcing SRP.
  - When to use: Any non-trivial system; DI containers handle lazy instantiation, proxy creation, and configuration-driven wiring without polluting domain objects.

```java
// True DI: class is passive, declares what it needs
public class BillingService {
    private final CreditCardProcessor processor;
    private final TransactionLog log;

    public BillingService(CreditCardProcessor processor, TransactionLog log) {
        this.processor = processor;
        this.log = log;
    }
}
// Container injects concrete types from XML/annotation config—BillingService never calls 'new'.
```

## Key Concepts
- **Cross-Cutting Concerns**: Behaviors like persistence, security, transactions, and caching that span many objects and cannot be cleanly encapsulated in any single class boundary.
- **Aspect-Oriented Programming (AOP)**: Modular constructs called *aspects* specify, via succinct declarative or programmatic mechanisms, which system points have their behavior modified to support a concern—noninvasively, without touching target code.
- **POJO (Plain-Old Java Object)**: A domain object with no framework dependencies; purely focused on domain logic. The target state when AOP and DI handle all cross-cutting infrastructure.
- **Big Design Up Front (BDUF)**: The harmful practice of designing everything before implementing anything. Inhibits adaptation, anchors premature decisions, and provides false confidence.
- **Domain-Specific Language (DSL)**: A small scripting language or API that reads like structured domain prose, closing the gap between domain expert vocabulary and implementation code.

## Mental Models
1. **City/Town Growth**: Cities grow from settlements. Nobody builds a six-lane highway through a small town that *might* grow. Systems work the same way—implement today's stories, refactor tomorrow. Software, unlike concrete, allows radical architectural change when concerns are properly separated.
2. **Construction vs. Occupancy**: A hotel under construction and a hotel in operation look nothing alike—different people, different tools, different concerns. Software startup and runtime are equally distinct; treating them as the same phase produces the equivalent of welders sharing hallways with guests.
3. **Last Responsible Moment**: Deferring a decision is not laziness—it is waiting for the maximum information before committing. Premature decisions are made with suboptimal knowledge. Modular, POJO-based systems make just-in-time architectural decisions practical.
4. **Optimal Architecture = Modularized Domains + Minimally Invasive Aspects**: Domain logic in POJOs, cross-cutting concerns wired via aspects or DI config. The architecture can be test-driven exactly like code.

## Anti-patterns
- **Lazy-Initialization in Application Code**: `if (service == null) service = new MyServiceImpl(...)` mixes construction into runtime logic, hard-codes a concrete dependency, pollutes test paths, and scatters global setup across the codebase.
- **BDUF / Over-Engineering Early**: EJB1/EJB2 required subclassing container types, implementing lifecycle callbacks, and writing XML deployment descriptors—coupling business logic tightly to infrastructure before requirements were stable. Teams spent cycles on framework mechanics instead of user stories.
- **Standards for Standards' Sake**: Adopting EJB2 because it was *a standard*, not because it demonstrably added value, is the canonical example. Standards should earn adoption; obsessing over them causes teams to lose focus on customer value.
- **Mixing Construction and Use at Any Layer**: Whether via lazy init, service locator calls inside domain objects, or JNDI lookups embedded in business logic—any pattern where a domain object resolves its own dependencies is a construction/use violation.

## Key Takeaways
1. The startup process is a first-class architectural concern; separate it sharply from runtime logic using `main` separation, Abstract Factory, or DI.
2. DI + IoC is the principled implementation of construction/use separation—objects declare dependencies passively; containers resolve them.
3. Systems can and must grow incrementally; BDUF is harmful precisely because clean separation of concerns makes incremental growth feasible without it.
4. Cross-cutting concerns (persistence, security, transactions) belong in aspects or declarative config, not woven into domain objects—keep POJOs pure.
5. Defer architectural decisions to the last responsible moment; modular designs preserve the option to decide late with better information.
6. DSLs raise abstraction to the domain level, reducing translation risk between domain expert intent and implementation.

## Connects To
- **Ch 3 (Functions)**: SRP at the function level is the micro-scale version of construction/use separation at the system level—each function does one thing; each layer has one responsibility.
- **Ch 10 (Classes)**: Class-level SRP and OCP are the immediate prerequisites for system-level separation; a class that mixes concerns cannot be wired cleanly by a DI container.
- **Ch 12 (Emergence)**: The four rules of simple design (especially "no duplication" and "expressive") become achievable at scale only when the system architecture doesn't force cross-cutting logic into domain code.
- **Ch 2 (Meaningful Names)**: DSLs are the system-level application of the same intent—code should read like the domain it models.
