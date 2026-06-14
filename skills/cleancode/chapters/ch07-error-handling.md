# Chapter 7: Error Handling

## Core Idea
Error handling is a separate concern from business logic — when error-handling code dominates or obscures the main algorithm, it is wrong. Robust and readable are not conflicting goals: treat error handling as something viewable independently of the main logic and you achieve both.

## Frameworks Introduced

- **Use Exceptions Rather Than Return Codes**: Throw exceptions instead of setting error flags or returning error codes that the caller must check immediately after the call.
  - When to use: Any time a method can encounter an error — exceptions separate the device-shutdown algorithm from device-shutdown error handling so each is readable independently.

- **Write Your Try-Catch-Finally Statement First**: Write the try-catch-finally structure before the interior logic when building code that can throw.
  - When to use: Any I/O, external resource access, or operation that can fail — TDD-drive the exception path first (write a test that expects an exception, make it pass, then refine) so the transaction scope of the try block is established before the happy-path logic is added inside it.

- **Use Unchecked Exceptions**: Prefer unchecked (runtime) exceptions over checked exceptions in general application development.
  - When to use: Almost all application code. Checked exceptions are an Open/Closed Principle violation: adding a checked exception at a low level forces a `throws` clause on every method between the throw site and the catch site, cascading signature changes up the entire call hierarchy and breaking encapsulation because all intermediate methods must now know about the low-level exception detail. C#, Python, Ruby produce robust software without checked exceptions.

- **Provide Context with Exceptions**: Attach an informative message to every thrown exception naming the operation that failed and the type of failure.
  - When to use: Every throw site — a stack trace tells you where, not what the code was trying to accomplish; the message fills that gap and makes log entries self-sufficient.

- **Define Exception Classes in Terms of a Caller's Needs**: Define exception types by how callers will catch and handle them, not by their origin component or failure taxonomy.
  - When to use: When defining error surfaces for a subsystem or wrapping a third-party API — often one exception type per area of code is enough; use separate types only when callers need to catch one and let another pass through.

- **Define the Normal Flow (Special Case Pattern)**: Eliminate exception-as-control-flow by encoding the expected-missing-data behavior inside an object rather than throwing from a DAO and catching in the caller.
  - When to use: When the caller's catch block merely substitutes a default value (e.g., per-diem when no meal expenses exist) — push that default into a Special Case object so the client code reads as a clean unadorned algorithm.

- **Don't Return Null**: Never return null from a method; return a Special Case object, an empty collection, or throw an exception.
  - When to use: Any method that might have nothing to return — null returns transfer null-check burden to every caller; one missed check produces a NullPointerException far from the source. `Collections.emptyList()` is the canonical Java replacement for nullable list returns.

- **Don't Pass Null**: Treat null arguments as forbidden by default unless the API contract explicitly requires them.
  - When to use: All application code — neither runtime null checks nor `assert` statements fully solve the problem because a null in an argument list is always an indication of a programming error; forbidding it by convention produces far fewer careless mistakes.

## Key Concepts

- **Special Case Pattern** (Fowler): A class or configured object that handles an exceptional/missing-data case internally, so client code never needs a null check or a catch block for that case.
- **Checked vs. Unchecked Exceptions**: Checked exceptions are declared in method signatures and verified at compile time; unchecked exceptions propagate freely. Martin's position: checked exceptions break encapsulation via signature coupling across every intermediate layer.
- **Exception Context**: The message and attached data on a thrown exception that reconstruct what the program was attempting when it failed — stack traces supply location; context supplies intent.
- **Wrapper Class**: A thin adapter around a third-party API that absorbs all vendor exception variants and re-throws a single caller-oriented type, decoupling the application from vendor API design choices.

## Mental Models

1. **Separation of concerns**: Business logic and error handling should be independently readable. If you must read past error-handling code to find the algorithm, the separation has failed.
2. **Try block as transaction boundary**: Like a database transaction, a try-catch-finally is a scope contract — the catch must leave the system in a consistent state no matter what aborts inside the try. Establish this contract before filling in the interior.
3. **Classify by handler, not by source**: Ask "how will the caller react to this failure?" not "where did it originate?" Failures handled identically belong in the same exception type.
4. **Null is deferred ambiguity**: Returning or passing null defers a crash to a distant call site and strips intent. An empty object or an explicit exception always communicates more than null.

## Anti-patterns

- **Return codes / error flags**: Force callers to check after every call; easy to forget; mix error logic into business logic; do not compose cleanly.
- **Checked exception cascade**: A low-level throws clause propagates upward, forcing every intermediate method to declare or swallow an exception it neither causes nor can meaningfully handle — encapsulation broken.
- **Returning null**: Transfers null-check burden to all callers; a single missed check produces an NPE at runtime far from the origin; use Special Case objects or empty collections instead.
- **Passing null**: No clean general remedy exists — null-guard every parameter is noise, and convention-free APIs invite accidental null arguments; forbid null by default.
- **Multi-vendor catch duplication**: Separate catch blocks per vendor exception type that all do the same thing (log and report) — collapse via a wrapper class into one catch.

## Code Examples

```java
// Before: caller manages three vendor exception types with identical handling
ACMEPort port = new ACMEPort(12);
try {
    port.open();
} catch (DeviceResponseException e) {
    reportPortError(e); logger.log("Device response exception", e);
} catch (ATM1212UnlockedException e) {
    reportPortError(e); logger.log("Unlock exception", e);
} catch (GMXError e) {
    reportPortError(e); logger.log("Device response exception");
} finally { … }

// After: LocalPort wrapper collapses all vendor types into one
public class LocalPort {
    private ACMEPort innerPort;
    public LocalPort(int portNumber) { innerPort = new ACMEPort(portNumber); }
    public void open() {
        try { innerPort.open(); }
        catch (DeviceResponseException e)  { throw new PortDeviceFailure(e); }
        catch (ATM1212UnlockedException e) { throw new PortDeviceFailure(e); }
        catch (GMXError e)                 { throw new PortDeviceFailure(e); }
    }
}

LocalPort port = new LocalPort(12);
try {
    port.open();
} catch (PortDeviceFailure e) {
    reportError(e);
    logger.log(e.getMessage(), e);
} finally { … }
```
- **What it demonstrates**: Wrapping a third-party API normalizes heterogeneous vendor exceptions into one caller-oriented type, hides vendor design choices, and collapses duplicate catch blocks to a single clean handler.

## Key Takeaways

1. Throw exceptions rather than returning error codes — the calling code is cleaner and the algorithm separates cleanly from error handling.
2. Write try-catch-finally first; the try block is a transaction scope — establish its contract before building the interior, and TDD the exception path to drive the structure out.
3. Checked exceptions violate Open/Closed: a low-level throws change cascades signature changes up the entire call hierarchy; prefer unchecked exceptions in application code.
4. Each exception must carry enough context (operation name + failure type) to make a log entry self-sufficient — stack traces supply location, context supplies intent.
5. Define one exception type per area of code based on how callers will catch it; wrap third-party APIs to normalize their exceptions and decouple vendor API changes from application code.
6. The Special Case Pattern eliminates exception-as-control-flow: encode the default missing-data behavior in an object so client code reads as a clean algorithm.
7. Never return null (use empty collections or Special Case objects) and never pass null (forbid it by convention) — both patterns defer crashes to distant call sites and obscure cause.

## Connects To

- **Ch 2 (Meaningful Names)**: Exception class names and message text must communicate operation and failure domain precisely — vague names defeat caller-centric classification.
- **Ch 3 (Functions)**: Extracting `tryToShutDown()` from `sendShutDown()` is single-responsibility applied to error paths — one function for the happy path, one for cleanup/handling.
- **Ch 8 (Boundaries)**: Wrapping third-party APIs to normalize exceptions (introduced here) is the primary pattern for managing third-party boundaries — Ch 8 extends it to learning tests and interface isolation.
- **Ch 9 (Unit Tests)**: Writing tests that force exceptions is the TDD mechanic that drives try-catch-finally-first; test coverage of error paths is how the transaction contract is maintained over time.
