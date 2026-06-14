---
name: software-engineering-laws
description: "Apply the classic empirical 'laws' of software engineering — Conway, Brooks, Parkinson, Pareto, Peter, and friends — as decision heuristics during planning, estimation, staffing, architecture, and code review. Use when the user is adding people to a late project, reorganizing teams, estimating remaining work, fighting scope creep, reviewing a large PR, debating rewrites vs. reuse, or invokes a law by name (Conway's Law, Brooks's Law, Parkinson's Law, Pareto, Peter Principle, Sturgeon, Eagleson, Greenspun, Iceberg/LGTM)."
---

# Software Engineering Laws

A catalog of well-worn empirical "laws" — folklore that survives because it keeps coming true. Source: Jan Schaumann, *10 Software Engineering Laws Everybody Loves to Ignore* (netmeister.org, 2021). These are heuristics, not theorems: use them to **name a failure mode early and argue against it**, not as proofs. When a decision smells like one of these, cite the law by name and apply the countermeasure.

## How to use this skill

When a planning, staffing, estimation, or review situation matches a law's trigger below, surface it: name the law, state the one-line warning, and propose the countermeasure. Don't lecture — one sentence of diagnosis plus a concrete alternative.

## The laws

### Conway's Law — "you ship your org chart"
> "Any organization that designs a system will produce a design whose structure is a copy of the organization's communication structure."

**Fires when:** designing system/service boundaries, splitting a monolith, or a module map suspiciously mirrors team boundaries.
**Apply:** if you want a particular architecture, shape the teams/communication paths to match it (inverse Conway maneuver). Conflicting team priorities will leak into the design.

### Brooks's Law — adding people to a late project makes it later
> "Adding manpower to a late software project makes it later."

**Fires when:** a project is behind and someone proposes reallocating engineers onto it.
**Apply:** push back. New people need ramp-up and increase communication overhead; the likely result is a later, more brittle, more complex product (compounded by Conway). Prefer cutting scope or moving the date.

### Zawinski's Law — programs expand until they include a web server
> "Every program attempts to expand until it includes a web server. Those programs which cannot so expand are replaced by ones which can."

**Fires when:** a tool keeps accreting features beyond its core purpose.
**Apply:** treat unbounded feature growth as the default tendency, not an accident. Modern variants: web services expand "until they require a user account and collect all users' data"; devices "until they include an insecure default-password wifi AP." Guard scope deliberately.

### Parkinson's Law — work expands to fill the time available
> "Work expands so as to fill the time available for its completion."

**Fires when:** a task or project has no deadline, or estimates keep ballooning to match the calendar.
**Apply:** set rough deadlines for at least conceptual milestones; iterate on an MVP within fixed timelines or it never ships. The corollary also governs resources: "data/CPU/memory usage expands to use up all available storage/bandwidth/cycles/RAM" — budget capacity explicitly.

### Pareto's Fallacy — the last 20% costs 80% of the time
> The misread of the 80/20 rule: people assume the remaining 20% of the work is 20% of the effort.

**Fires when:** someone reports a feature is "80% done" or estimates the tail of a project as trivial.
**Apply:** the overlooked 20% (edge cases, integration, polish, ops) typically eats 80% of the time. Re-estimate the tail honestly. See also the Iceberg Fallacy.

### Sturgeon's Revelation — 90% of everything is crud
> "90% of everything is crud."

**Fires when:** evaluating libraries, dependencies, or your own output with rose-tinted optimism.
**Apply:** assume most code, tooling, and content (including your own) is mediocre by default. Set the quality bar deliberately rather than assuming it.

### The Peter Principle — promotion to incompetence
> "In a hierarchy, every employee tends to rise to their level of incompetence."

**Fires when:** reasoning about why a process, team, or decision is dysfunctional, or about who owns a call.
**Apply:** don't assume authority implies competence at the current role; the best engineer is not automatically a good manager. (Pairs with Dunning–Kruger.)

### Eagleson's Law — your six-month-old code is someone else's
> "Any code of your own that you haven't looked at for six or more months might as well have been written by someone else."

**Fires when:** writing code you'll revisit later, or judging "I'll remember how this works."
**Apply:** write for the stranger you'll become — comments, naming, docs. Six months is optimistic. Beware the "Yo Momma Corollary": authors accept their own criticism but dismiss everyone else's.

### Greenspun's 10th Rule — you'll reimplement the standard, badly
> "Any sufficiently complicated C or Fortran program contains an ad hoc, informally-specified, bug-ridden, slow implementation of half of Common Lisp."

**Fires when:** someone proposes building custom auth, a custom config language, a custom job queue, etc.
**Apply:** the Universal NIH-Rule — "any custom-developed system contains an ad hoc, informally-specified, bug-ridden, slow implementation of half of the industry standard you refused to adopt." Default to the proven standard; justify NIH explicitly.

### The Iceberg Fallacy — development is ~25% of total cost
> "The cost of development of a new software product is only ~25% of the total cost of ownership management sees and budgets for."

**Fires when:** estimating project cost, pitching a build, or planning headcount around ship date.
**Apply:** budget for the submerged 75% — maintenance, ops, on-call, support, migrations. Ops adage: shipping is the beginning, not the end. Pairs with Pareto's Fallacy.

### The LGTM Dilemma — big PRs get rubber-stamped
> "If you want to quickly ship a 10-line code change, hide it in a 1500-line pull request."

**Fires when:** reviewing or authoring a large PR, or when review attention skews to trivial details (the Bikeshedder's Blind Spot).
**Apply:** small PRs get real scrutiny; huge ones get "LGTM." Split changes for genuine review; as a reviewer, be most suspicious of the largest diffs and the smallest bikeshed-able details. (...and off-by-one errors, of course.)

## Bonus
- **LeBlanc's Law:** "Later equals Never." Deferred work rarely happens — schedule it or scope it out.

## When *not* to invoke
These are rhetorical heuristics, not hard rules. Don't cite them to shut down a decision the user has already reasoned through, and don't stack three laws on one comment. One well-placed law beats a lecture.
