# Chapter 9: The Pseudocode Programming Process

## Core Idea
The Pseudocode Programming Process (PPP) is a systematic method for constructing classes and routines that reduces design and documentation effort simultaneously by writing intention in plain English first, then converting that pseudocode directly into working code and comments.

## Frameworks Introduced
- **PPP / Pseudocode Programming Process**: A routine-construction procedure in which pseudocode drives both the design and the documentation, so that translating to code produces self-documenting, well-structured results.
  - When to use: Building any non-trivial routine; especially valuable when you feel stuck, keep losing your train of thought, or find yourself hacking toward working code
  - How: (1) Check prerequisites — is the problem well enough defined to name the routine and its parameters? (2) Define the problem the routine solves in terms of inputs, outputs, and preconditions/postconditions. (3) Research standard libraries and algorithms before writing anything. (4) Write pseudocode at a high level of intent — English statements that describe what to do, not how; avoid syntactic constructs from any programming language. (5) Mentally check the pseudocode for correctness and clarity. (6) Translate pseudocode line-by-line into code, keeping each pseudocode line as a comment. (7) Compile and test incrementally. (8) Clean up: remove redundant comments (where the code is self-explanatory), check layout, verify documentation accuracy. (9) Repeat recursively for any sub-problem that needs its own routine.

## Key Concepts
- **Pseudocode**: Plain-English descriptions of what code should do, written at the level of intent rather than implementation; avoids programming-language syntax so the writer focuses on logic, not syntax.
- **Iterative Class Construction**: Class creation is a messy, iterative process — create a general design, enumerate routines, construct each routine with PPP, then review the class as a whole.
- **Redundant Comment**: A comment that restates what the code already clearly says; produced when PPP pseudocode is translated to clean, well-named code; should be removed.
- **Design by Contract**: Each routine specifies preconditions (what callers must guarantee) and postconditions (what the routine guarantees on return); an alternative/complement to PPP.
- **Test-First Development**: Writing test cases before writing code; an alternative to PPP in which tests drive design rather than pseudocode.
- **Prerequisites Check**: Before writing any routine, verify the class design is clear enough to name the routine and its parameters; do not start coding into an unclear design.

## Mental Models
- Think of pseudocode as a first draft that becomes both the design document and the code comments — one artifact, two purposes, zero extra documentation effort.
- Use the PPP recursively: if a pseudocode step is complex enough to need its own explanation, break it out into a sub-routine and apply the PPP to that too.
- Use the "lost train of thought" signal — if you find yourself losing track of what a routine is supposed to do mid-coding, that is a sign the PPP would have prevented the problem.
- Think of the prerequisites check as a gate: if you cannot give the routine a good name and describe its inputs and outputs clearly, the design is not ready and coding will produce confusion.

## Anti-patterns
- **Hacking toward working code**: Writing code without a plan, then patching until it works — leads to routines with no clear structure, poor names, and missing cases; the PPP is the direct antidote.
- **Writing pseudocode in programming-language syntax**: Defeats the purpose — forces syntactic thinking before logical thinking is complete; pseudocode must be language-free.
- **Keeping redundant comments after translation**: A comment that says `// Add 1 to i` above `i++` adds noise, not signal; remove it once the code is self-explanatory.
- **Skipping the prerequisites check**: Starting to code a routine whose purpose or interface is unclear leads to wasted effort and routines that must be rewritten.
- **Single-pass construction**: Treating routine construction as a one-time linear activity rather than an iterative loop — high-quality programming requires willingness to back up to pseudocode and redo.

## Key Takeaways
1. The PPP reduces design effort, documentation effort, and defect rate simultaneously by making pseudocode the common ancestor of both code and comments.
2. Write pseudocode at the level of intent, not implementation — no programming-language syntax; each line states what to accomplish, not how.
3. Check prerequisites before writing any code: if you cannot name the routine and describe its inputs and outputs, the design is not ready.
4. Apply the PPP recursively — any pseudocode step complex enough to need explanation becomes a candidate for its own routine.
5. High-quality routine construction is iterative: if the result is poor, back up to pseudocode and revise; do not patch forward.
6. The PPP is not the only valid approach — test-first development and design by contract are legitimate alternatives; the common thread is that all systematic approaches outperform hacking.

## Connects To
- **Ch5**: Design in Construction provides the design heuristics that inform what the pseudocode should say
- **Ch6**: Working Classes — class construction uses the same iterative prerequisite-check → design → construct → review cycle as the PPP
- **Ch7**: High-Quality Routines defines the quality targets (cohesion, naming, parameters) that PPP-constructed routines should satisfy
- **Ch32**: Self-Documenting Code — the PPP's comment-from-pseudocode technique is a primary self-documentation strategy
