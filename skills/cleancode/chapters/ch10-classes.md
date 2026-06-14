# Chapter 10: Classes

## Core Idea
Classes are the next level of organization above functions; clean code at the function level is insufficient if class design is poor. Size is measured by responsibilities, not lines — and every structural decision (naming, cohesion, coupling) is a proxy for whether a class has one clear reason to exist.

## Frameworks Introduced
- **Single Responsibility Principle (SRP)**: A class or module should have one, and only one, reason to change.
  - When to use: Whenever you can describe a class only by using "and" or "but" — that's a signal it has multiple responsibilities and should be split.
- **Open-Closed Principle (OCP)**: Classes should be open for extension but closed for modification.
  - When to use: When adding new behavior requires opening an existing class, restructure so new behavior arrives via subclassing or composition without touching existing code.
- **Dependency Inversion Principle (DIP)**: Classes should depend upon abstractions, not on concrete details.
  - When to use: Whenever a class depends directly on a concrete implementation (especially an external API or volatile service), introduce an interface to isolate it.

## Key Concepts
- **Class Organization**: Variables first (public static constants → private static → private instance), then public functions, with private utilities placed immediately after the public function that calls them (stepdown rule).
- **Encapsulation**: Keep variables and utilities private by default; loosen to protected/package scope only when tests require it, and only as a last resort.
- **Responsibilities**: The unit of class size — not line count. A class that cannot be named concisely, or whose description requires "and/or/but", has too many.
- **Cohesion**: The degree to which a class's methods use its instance variables. High cohesion means methods and variables hang together as a logical whole; a maximally cohesive class uses every variable in every method.
- **Reason to Change**: The SRP's operational test — count how many distinct forces could require modifying this class. More than one is a violation.

## Mental Models

**The 25-word description test**: Write a one-sentence description of the class without using "if", "and", "or", or "but". Failure to do so reveals multiple responsibilities before a single line of code is evaluated.

**Toolbox vs. junk drawer**: A system with many small, focused classes is a toolbox with labeled drawers. A system with a few large classes is a junk drawer — same number of moving parts, but you always have to dig. Navigation cost is not a reason to keep classes large.

**Cohesion as a class detector**: When breaking a large function into smaller ones requires promoting many local variables to instance variables, those variables and the functions that share them are quietly announcing they want to be their own class. Loss of cohesion is the signal; splitting is the response.

**Interfaces as change firebreaks**: Every dependency on a concrete class is a point where change can propagate. An interface between caller and implementation is a firebreak — the caller changes only if the abstraction changes, not when the implementation does.

## Anti-patterns
- **God class / "Super" in the name**: A class with 70 public methods exposes every concern of the system. Names containing "Manager", "Processor", or "Super" signal inappropriate aggregation.
- **Version info buried in a UI class**: `SuperDashboard` tracking both Swing components and version numbers has two unrelated reasons to change — a textbook SRP violation, fixable by extracting a `Version` class.
- **Opening a class to add a feature**: If adding `UPDATE` support requires editing the `Sql` class, the design is wrong. Restructure so new SQL statement types arrive as subclasses; no existing class needs to open.
- **Depending on a volatile concrete class**: A `Portfolio` that calls `TokyoStockExchange` directly cannot be tested in isolation and breaks whenever the exchange API changes. Inject a `StockExchange` interface instead.

## Code Examples
```java
// Before: version data mixed into a UI class
public class SuperDashboard extends JFrame implements MetaDataUser {
    public Component getLastFocusedComponent()
    public void setLastFocused(Component lastFocused)
    public int getMajorVersionNumber()
    public int getMinorVersionNumber()
    public int getBuildNumber()
}

// After: SRP extraction — one class, one responsibility
public class Version {
    public int getMajorVersionNumber()
    public int getMinorVersionNumber()
    public int getBuildNumber()
}
```
- **What it demonstrates**: Extracting the three version methods into `Version` eliminates `SuperDashboard`'s second reason to change and yields a reusable construct.

## Key Takeaways
1. Measure class size in responsibilities, not lines — if you can't name it in one clean noun, it's too big.
2. SRP is the most commonly violated OO principle precisely because "making it work" and "making it clean" are separate activities that require a deliberate context switch.
3. Many small classes do not increase system complexity — they reduce the cognitive surface you must hold at any one time, because each class is understandable in isolation.
4. Cohesion and SRP are two sides of the same coin: when cohesion drops (methods share only a few instance variables), that's a class trying to split itself — let it.
5. Refactoring toward OCP (subclass instead of modifying) and DIP (depend on interfaces) is also a testability improvement — decoupled code is inherently more testable.
6. Structural change does not require a rewrite: the PrintPrimes → PrimePrinter/RowColumnPagePrinter/PrimeGenerator refactor preserved the original algorithm entirely, arriving at three focused classes through small incremental steps verified by tests.

## Connects To
- **Ch 3 (Functions)**: The same "smaller is better" rule applies one level down; small functions and small classes reinforce each other — breaking large functions often reveals the class boundaries.
- **Ch 11 (Systems)**: OCP and DIP scale up to the system level — dependency injection and separation of construction from use apply the same isolation principles across the full application.
- **Ch 14–16 (Successive Refinement / Smells)**: The PrintPrimes refactor is a live demonstration of the incremental, test-backed cleaning process described later; the three-class decomposition is the end state of applying every principle in this chapter.
