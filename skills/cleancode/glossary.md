# Clean Code — Glossary

**Abstract Factory** — a pattern for isolating object construction behind an interface so application code never calls `new` on concrete types; recommended for separating construction from use. (Ch 11)

**Active Record** — a DTO with navigation or save/find methods; treat it as a data structure only and keep domain logic in separate objects. (Ch 6)

**Adapter Pattern** — wrap a third-party or legacy interface in a thin translation layer that exposes only the API your code needs. (Ch 8)

**Amplification** — a comment whose sole value is underscoring something counterintuitive that the code alone cannot convey. (Ch 4)

**Argument Objects** — when a function needs three or more arguments, wrap related ones in a named object to reduce arity. (Ch 3)

**Aspect-Oriented Programming (AOP)** — a technique for implementing cross-cutting concerns (logging, transactions, security) without tangling them into domain objects. (Ch 11)

**Big Design Up Front (BDUF)** — the practice of completing a full upfront architecture before writing code; Martin argues it prevents adapting to what you learn and should be deferred. (Ch 11)

**Boundary Interface** — an internal wrapper that isolates your code from the API surface of a third-party library, so library upgrades require changes in only one place. (Ch 8)

**Boy Scout Rule** — always leave the code a little cleaner than you found it; continuous small improvements prevent rot from accumulating. (Ch 1)

**BUILD-OPERATE-CHECK** — a test structure pattern: create test data (build), exercise the system (operate), then assert the outcome (check). (Ch 9)

**Checked vs. Unchecked Exceptions** — checked exceptions violate the Open-Closed Principle by forcing every caller up the stack to declare or handle them; prefer unchecked. (Ch 7)

**Class Organization** — public static constants → private static variables → private instance variables → public functions → private utilities; no public instance fields. (Ch 10)

**Cohesion** — every instance variable should be used by most methods in a class; low cohesion signals the class should be split. (Ch 10)

**Command Query Separation** — a function either returns a value (query) or changes state (command) but never both, eliminating side-effect confusion. (Ch 3)

**Data Abstraction** — expose behavior through an interface, not getters/setters; clients should work in the vocabulary of the domain, not the storage layout. (Ch 6)

**Data Transfer Object (DTO)** — a class with only public fields and no logic, used to shuttle data between layers; do not add business behavior. (Ch 6)

**Data/Object Anti-Symmetry** — procedural code with open data structures makes adding functions easy but adding types hard; OO code makes adding types easy but adding functions hard; choose accordingly. (Ch 6)

**Deadlock** — four conditions must hold simultaneously: mutual exclusion, lock & wait, no preemption, circular wait; break any one to prevent it. (Ch 13)

**Dependency Injection (DI)** — provide dependencies to an object from the outside (usually the main or IoC container) rather than letting the object construct them. (Ch 11)

**Dependency Inversion Principle (DIP)** — high-level modules must not depend on low-level modules; both should depend on abstractions. (Ch 10)

**Do One Thing** — a function must do exactly one thing at exactly one level of abstraction; if you can extract a named sub-function, it was doing more than one thing. (Ch 3)

**Domain-Specific Language (DSL)** — a higher-level vocabulary expressed as classes and methods that lets domain experts read and validate the code. (Ch 11)

**Domain-Specific Testing Language** — a set of utility functions and abstractions built on top of the raw testing API so tests read as executable specifications. (Ch 9)

**DRY (Don't Repeat Yourself)** — every piece of knowledge must have a single authoritative representation; duplication is the root cause of most software disease. (Ch 3)

**Encapsulate Conditionals** — extract complex boolean expressions into well-named predicate functions so the intent is obvious at the call site. (Ch 17)

**Extract Try/Catch Blocks** — put try/catch in their own functions so error processing and happy-path logic are never mixed. (Ch 7)

**F.I.R.S.T.** — the five properties of clean unit tests: Fast, Independent, Repeatable, Self-Validating, Timely. (Ch 9)

**Feature Envy** — a method that is more interested in the data of another class than its own; move it to where the data lives. (Ch 16)

**Flag Arguments** — passing a boolean to a function that switches behavior declares the function does two things; split it into two functions instead. (Ch 3)

**Four Rules of Simple Design (Kent Beck)** — in priority order: (1) runs all tests, (2) expresses intent, (3) eliminates duplication, (4) minimizes classes and methods. (Ch 12)

**G-Heuristics (Ch 17)** — a numbered vocabulary of 36 general code smells (G1–G36), covering duplication, abstraction levels, dead code, misplaced responsibility, and naming. (Ch 17)

**Hybrid (Data/Object)** — a class that is half-object with functions and half-data-structure with exposed fields; the worst of both worlds, avoid it. (Ch 6)

**Incrementalism** — the strategy of making small, working changes continuously rather than a big-bang rewrite; keep the tests green throughout. (Ch 14)

**Intention-Revealing Names** — a name should answer why the thing exists, what it does, and how it is used without requiring a comment. (Ch 2)

**Kent Beck's Four Rules of Simple Design** — see *Four Rules of Simple Design*. (Ch 12)

**Last Responsible Moment** — defer architecture and design decisions until the last moment when deferring would cause harm, preserving options while knowledge is still growing. (Ch 11)

**Law of Demeter** — a method should only call methods on itself, its parameters, objects it creates, or direct component fields — not on objects returned by those calls. (Ch 6)

**Lazy Initialization** — constructing an object on first use rather than at startup; useful for performance but mixes construction and use, which must be contained. (Ch 11)

**Learning Tests** — tests written against a third-party library for the sole purpose of learning and verifying the library's behavior, not testing your own code. (Ch 8)

**LeBlanc's Law** — "Later equals never"; the decision to clean code up later is the decision to never clean it up. (Ch 1)

**Limit Scope of Data** — make each piece of data visible to as few threads and classes as possible to reduce the surface area for concurrency errors. (Ch 13)

**Newspaper Metaphor** — source files should read like a newspaper: headline (name) at the top, key concepts next, details and trivia toward the bottom. (Ch 5)

**Niladic / Monadic / Dyadic / Triadic** — taxonomy of function arity; niladic (zero args) is ideal, each step up requires stronger justification, triadic should be very rare. (Ch 3)

**No Duplication** — the second rule of simple design; any form of duplication (code, algorithm, pattern) represents an opportunity for missed abstraction. (Ch 12)

**Noise Words** — meaningless differentiators such as `Info`, `Data`, `The`, or sequential numbers appended to names to satisfy the compiler without communicating intent. (Ch 2)

**Null Returns / Null Passing** — returning or passing null forces callers to defend against it; throw exceptions or use Special Case objects instead. (Ch 7)

**One Level of Abstraction per Function** — mixing high-level orchestration with low-level implementation detail in one function creates confusion; stay at a single level throughout. (Ch 3)

**Open-Closed Principle (OCP)** — classes should be open for extension and closed for modification; new behavior is added through new code, not by editing existing code. (Ch 10)

**Output Arguments** — arguments used to write into rather than read from; they violate the intuitive reading of a function call and should be replaced by return values or object mutation. (Ch 3)

**POJO (Plain-Old Java Object)** — a domain class with no framework dependencies, enabling a pure OO model that can be tested and reasoned about independently of infrastructure. (Ch 11)

**Prefer Polymorphism to Switch/Case** — use type hierarchies and virtual dispatch rather than switch statements; the switch must be changed every time a new type is added. (Ch 17)

**Separation of Main** — the construction of the object graph belongs in `main` (or dedicated factories/IoC container); application code should never know how objects are built. (Ch 11)

**Single Concept per Test** — each test method should verify exactly one behavior so failures are self-diagnosing and test names are meaningful. (Ch 9)

**Single Responsibility Principle (SRP)** — a class should have one and only one reason to change; mixing responsibilities creates fragile coupling between unrelated concerns. (Ch 10)

**Special Case Pattern** — create a subclass or object that handles exceptional null/edge behavior so callers never have to check for null or special conditions. (Ch 7)

**Stepdown Rule** — every function is followed by functions at the next level of abstraction, so the file reads as a top-to-bottom narrative from high to low level. (Ch 3)

**Successive Refinement** — the discipline of writing a rough first pass then refactoring continuously, keeping tests green throughout; good code is grown, not written once. (Ch 14)

**Switch without Polymorphism** — a switch on a type code in a general-purpose function that will inevitably be duplicated elsewhere; bury it in the lowest-level factory and hide it behind an interface. (Ch 3)

**Team Rules** — every team should agree on one formatting and naming standard and every member must use it; individual preference yields to collective convention. (Ch 5)

**Tell, Don't Ask** — tell an object what to do rather than querying its state and deciding for it; keeps behavior with the data it operates on. (Ch 6)

**Template Method** — a pattern that captures the skeleton of an algorithm in a base class and defers variable steps to subclasses, eliminating code duplication across variants. (Ch 12)

**Temporal Coupling** — a hidden dependency in which functions must be called in a specific order; make ordering explicit by having each function return the value the next one needs. (Ch 3)

**Three Laws of TDD** — (1) write no production code before a failing test, (2) write only enough test to fail, (3) write only enough production code to pass. (Ch 9)

**TO Paragraph** — a mental heuristic for writing functions: read the function as starting with "TO [do X] we [do A], [do B]…" — if it takes more than one sentence it does too much. (Ch 3)

**TODO Comments** — acceptable short-term notes for work that cannot be done now; must be resolved and removed before they accumulate into noise. (Ch 4)

**Total Cost of Owning a Mess** — the compounding burden of messy code: velocity drops, bugs increase, every change requires understanding and unwinding tangled dependencies. (Ch 1)

**Train Wreck** — a chain of method calls such as `a.getB().getC().getD()` that violates the Law of Demeter and exposes navigation structure to the caller. (Ch 6)

**Unchecked Exceptions** — runtime exceptions that callers are not required to declare or catch; preferred because checked exceptions impose an Open-Closed Principle violation on every call site. (Ch 7)

**Use Copies of Data** — when threads need shared data, copy it and process the copy in a single thread; avoid shared-state locking wherever feasible. (Ch 13)

**Vertical Distance** — related concepts (variable declaration and use, caller and callee, related methods) should be close together in the file to reduce scrolling and cognitive overhead. (Ch 5)

**Vertical Ordering** — functions called by a function should appear below it in the file, so reading top-to-bottom reveals the narrative from high to low abstraction. (Ch 5)

**Wrapper Class (for exceptions)** — wrapping a third-party API's exception types in a single local exception class so callers depend on your abstraction, not the vendor's. (Ch 7)
