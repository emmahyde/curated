# Chapter 6: Objects and Data Structures

## Core Idea
Objects hide data and expose behavior; data structures expose data and have no behavior. These are not just two implementation styles — they are complementary opposites, each making easy exactly what the other makes hard. Choose deliberately between them; mixing the two produces the worst of both worlds.

## Frameworks Introduced
- **Data Abstraction**: Don't expose implementation details through public variables or naive getters/setters. Expose *abstract interfaces* that let callers manipulate the essence of the data without knowing its representation. A `getPercentFuelRemaining()` tells you nothing about internal storage; `getFuelTankCapacityInGallons()` + `getGallonsOfGasoline()` clearly leaks rectangular-coordinate internals.
  - When to use: Always, when designing objects. Ask what the *concept* is, not what the fields are.

- **Data/Object Anti-Symmetry**: Procedural code with data structures makes it easy to add new functions (just add to `Geometry`) but hard to add new types (all existing functions must branch). OO code with polymorphism makes it easy to add new types (no `Geometry` needed) but hard to add new functions (every existing class must be changed).
  - When to use: Prefer objects when the system grows by adding new *types*; prefer data structures and procedures when the system grows by adding new *behaviors*.

- **Law of Demeter**: A method `f` of class `C` should only call methods on: `C` itself, objects created by `f`, objects passed as arguments to `f`, or instance variables of `C`. It should never call methods on objects returned by those allowed calls. "Talk to friends, not to strangers."
  - When to use: Any time you're navigating through an object graph via chained calls. Stop and ask whether you're supposed to know that much about the structure.

## Key Concepts
- **Train Wrecks**: Chained method calls like `ctxt.getOptions().getScratchDir().getAbsolutePath()` that traverse multiple object internals in one line — sloppy, coupling-heavy, and usually a Demeter violation.
- **Hybrids**: Structures that are half object, half data structure — they have significant behavior *and* public variables or accessors that expose internals. Hard to extend with new functions *and* hard to extend with new types. The worst of both worlds.
- **Hiding Structure**: When working with real objects, don't ask them for their internals and then compute — tell them to *do* something. Instead of navigating to a scratch path and building a stream yourself, call `ctxt.createScratchFileStream(className)`. The object hides the path, hides the directory logic, and you never need to violate Demeter.
- **Data Transfer Objects (DTO)**: A class with public variables and no functions. The quintessential data structure. Useful for database communication, socket parsing, translation stages from raw data to domain objects. Bean-style DTOs (private fields + getters/setters) provide quasi-encapsulation that satisfies OO purists but offers no practical benefit.
- **Active Record**: A special DTO form that adds navigational methods (`save`, `find`) and maps directly to a database table or external data source. The mistake is treating Active Records as objects by adding business rule methods — this creates a hybrid. Keep the Active Record as a pure data structure; business rules belong in separate objects that hold an Active Record internally.

## Mental Models
1. **The symmetry test**: If you add a new type, how many files change? If you add a new function, how many files change? The answer tells you which paradigm you're in — and whether it matches what your system actually needs to grow.
2. **Abstraction vs. accessor**: Getters and setters over private fields do not constitute abstraction. The test is whether callers can reason about the object's behavior without knowing anything about its storage format.
3. **Tell, don't ask**: When you find yourself navigating through an object's returned values to compute something, stop. Wrap the *intent* as a method on the object. This is the correct resolution to apparent Demeter violations.
4. **Mature pragmatism**: "The idea that everything is an object is a myth." Sometimes you genuinely want a dumb data structure with external procedures. The skill is choosing deliberately, not defaulting to one style for all cases.

## Anti-patterns
- **Blithely adding getters/setters**: Exposes implementation, locks down representation, and provides false encapsulation. Worst option when designing an object's interface.
- **Hybrid structures**: Functions that do significant work *and* public variable access that treats the object as a record. These structures are indicative of muddled design — the author doesn't know whether they need protection from functions or types.
- **Train wrecks in object graphs**: Chaining calls through returned objects navigates structure that should be hidden. Even when split into separate local variables, the calling function still knows far too much about the object network.
- **Business logic in Active Records**: Putting domain rules in a class that is also a direct database mapping creates an incoherent hybrid. Business rules belong in objects; persistence shape belongs in data structures.

## Code Examples
```java
// Demeter violation — train wreck
final String outputDir = ctxt.getOptions().getScratchDir().getAbsolutePath();

// Correct resolution — tell the object what to do
BufferedOutputStream bos = ctxt.createScratchFileStream(classFileName);
```
- **What it demonstrates**: The train wreck navigates ctxt's internals three levels deep; the fix tells ctxt to perform the intent directly, hiding all internal structure.

## Key Takeaways
1. Objects hide data and expose behavior; data structures expose data and have no meaningful behavior. These are virtual opposites — not a spectrum.
2. OO makes adding new types easy and adding new functions hard. Procedural makes adding new functions easy and adding new types hard. Match the paradigm to the growth axis of your system.
3. Hiding implementation means exposing abstract interfaces, not wrapping fields in getters. If callers can deduce your internal representation from your API, you haven't abstracted.
4. The Law of Demeter is a direct consequence of object encapsulation: if objects are supposed to hide their structure, you must not navigate that structure through chained accessors.
5. Hybrids — half object, half data structure — combine the drawbacks of both paradigms. They arise from design uncertainty and should be avoided deliberately.
6. DTOs and Active Records are valid data structures; the error is adding business logic to them and calling the result an object.

## Connects To
- **Ch 10 (Classes)**: The single-responsibility and encapsulation principles for classes build directly on the object/data-structure distinction drawn here.
- **Ch 7 (Error Handling)**: Exceptions are behavior exposed through objects; returning error codes from data structures creates the same procedural-vs-OO tradeoff.
- **Ch 17 (Smells and Heuristics)**: G36 (navigation through object structures), G14 (feature envy) and related smells are concrete manifestations of the Law of Demeter and hybrid anti-patterns described here.
