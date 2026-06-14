# Chapter 12: Fundamental Data Types

## Core Idea
Each fundamental data type has a distinct failure mode; knowing the specific hazards of numbers, strings, booleans, enums, constants, and arrays — and applying type-appropriate defensive practices — eliminates an entire class of subtle, hard-to-reproduce bugs.

## Frameworks Introduced
- **Magic Number Elimination**: Replace all literal numeric (and character/string) values with named constants or variables.
  - When to use: Any literal that appears in code and has a non-obvious meaning, or that might need to change.
  - How: Declare a named constant for each meaningful literal; use the constant everywhere the literal would appear. Three advantages: changes are reliable (one place), changes are easy (no hunting), your program is more readable.
- **Type Aliasing (Creating Your Own Types)**: Define application-specific type names that map to underlying primitive types, isolating the codebase from platform differences and clarifying intent.
  - When to use: Portability across platforms, or when the built-in type name doesn't convey the semantic role of the variable.
  - How: Define substitute types (e.g., `INT32`, `LONG64`) and use them throughout; redefine the aliases per platform at a single point. Consider using a class instead of a simple typedef when additional behavior or invariants are needed.
- **Enumerated Types as Policy**: Use enums instead of named integer constants or boolean variables when a variable represents membership in a fixed set of categories.
  - When to use: Any time a variable takes on one of N named discrete values (status codes, colors, directions, countries).
  - How: Define the enum with a category prefix/suffix on each member; reserve the first entry for "invalid" to catch uninitialized use; always test for unexpected values in switch/if chains.

## Key Concepts
- **Magic Number**: A literal numeric value embedded in code without explanation; source of fragility and obscurity.
- **Integer Overflow**: When an integer arithmetic result exceeds the type's maximum value, wrapping silently to a wrong value; must be anticipated explicitly.
- **Integer Division**: Division of two integers truncates rather than rounds; can produce unexpected zero results (e.g., `7/10 == 0`).
- **Floating-Point Comparison**: Direct equality comparison of floating-point numbers is unreliable due to rounding; use an epsilon/tolerance comparison function instead.
- **Rounding Error**: Accumulated imprecision in floating-point arithmetic; mitigate by switching to higher precision, BCD, or integer representation scaled by a factor.
- **Off-by-One Error**: Fencepost errors in string indexing or array bounds; especially common in C-style null-terminated strings.
- **Named Constant**: A symbolic name given to a fixed value; should encode the abstract meaning, not the number (e.g., `MAXIMUM_EMPLOYEES` not `100`).
- **Enumerated Type**: A type whose legal values are a named, finite set; provides readability, type-checking, and modifiability advantages over integer codes.
- **Boolean Variable**: A variable holding only true/false; prefer over integer flags for clarity; can also be used to simplify complex conditionals by naming the condition.
- **Type Aliasing**: Defining a new type name that maps to an existing type; used for portability and semantic clarity.

## Mental Models
- Think of magic numbers as time bombs: they work until a value needs to change, at which point every instance must be found and updated correctly — named constants defuse all of them at once.
- Use enumerated types when you find yourself writing a comment explaining what values an integer variable is allowed to take — that comment belongs in the type declaration, not beside the variable.
- Think of floating-point equality as "approximately equal within a tolerance" — never ask "are these exactly equal?", always ask "are these close enough?".
- Use boolean variables to name conditions: `if (isPastDue && isValidAccount)` is self-documenting; `if (a > 30 && b != 0)` is not.

## Anti-patterns
- **Magic numbers**: Literals scattered through code make changes unreliable, obscure meaning, and invite inconsistency when the same value means different things in different places.
- **Mixed-type comparisons**: Comparing signed and unsigned integers, or integers and floats, produces platform-dependent results due to implicit coercion.
- **Direct floating-point equality**: `if (x == 1.0)` will fail when x is `0.9999999999` due to rounding — always use an epsilon comparison.
- **Unguarded integer overflow**: Adding or multiplying integers without checking bounds silently wraps; in security-sensitive code this is a vulnerability.
- **Using integer codes instead of enums**: Integer status codes require comments to decode, can take any value (including invalid ones), and don't benefit from compiler type-checking.
- **C strings without length guards**: Using `strcpy` instead of `strncpy`, or failing to reserve `CONSTANT+1` characters for the null terminator, leads to buffer overflows.
- **First enum entry not "invalid"**: If 0 is a valid enum value and a variable is accidentally uninitialized (defaults to 0), the error goes undetected.

## Key Takeaways
1. Eliminate magic numbers by replacing every meaningful literal with a named constant declared in one place.
2. Never compare floating-point numbers for exact equality; always use an epsilon/tolerance comparison.
3. Anticipate integer overflow and integer division truncation explicitly — neither produces an error at runtime.
4. Use enumerated types instead of integer codes or boolean variables whenever a variable represents membership in a named set; reserve the first entry for "invalid".
5. Use boolean variables to name and document complex conditions, not just as flags.
6. Use type aliasing to insulate the codebase from platform-specific type sizes and to clarify semantic intent.
7. In C, always use `strncpy`/`strncat`/`strncmp`, declare string arrays as `length CONSTANT+1`, and initialize to NULL to prevent endless strings.

## Connects To
- **Ch11**: Named constants and enumerated type members must follow the naming conventions established in Ch11.
- **Ch10**: Type-specific initialization hazards (uninitialized floats, null pointers, uninitialized enums) are a subset of the general initialization problem.
- **Ch13**: Arrays are introduced here; Ch13 covers pointers and structures — the "unusual" types that extend beyond primitives.
- **Ch6**: Type aliasing can be superseded by creating a class; Ch6 covers when a class is the right abstraction.
