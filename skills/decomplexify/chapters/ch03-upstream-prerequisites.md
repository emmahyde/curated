# Chapter 3: Measure Twice, Cut Once: Upstream Prerequisites

## Core Idea
The overarching goal of upstream preparation is risk reduction: fixing a defect in requirements costs 1x; fixing the same defect post-release costs 10–100x; therefore completing problem definition, requirements, and architecture before construction is the highest-leverage quality investment a team can make.

## Frameworks Introduced
- **Defect Cost Escalation Table**: Empirical data showing that defect fix cost multiplies by 10–100x from requirements-time to post-release.
  - When to use: When justifying investment in prerequisites to management or skeptical teammates.
  - How: Requirements defect found at requirements time = 1x; at architecture = 3x; at construction = 5–10x; at system test = 10x; post-release = 10–100x.

- **Three-Project-Type Framework (Table 3-2)**: Classifies projects as Business Systems, Mission-Critical Systems, or Embedded/Life-Critical Systems to determine the right balance of sequential vs. iterative prerequisites.
  - When to use: At project start, to calibrate how much up-front planning is appropriate.
  - How: Business systems → highly iterative, prerequisites interleaved with construction; Life-critical → more sequential, requirements stability is mandatory.

- **Upstream Prerequisites Checklist**: A sanity check before construction begins — "where are you on the requirements Richter scale?" covering specific functional requirements (inputs, outputs, interfaces, tasks), nonfunctional quality requirements (response time, security, reliability), and architecture completeness.
  - When to use: As a go/no-go gate before writing the first line of production code.
  - How: Walk through checklist categories — specific functional requirements, nonfunctional requirements, requirements quality (testable? complete? agreed upon?), and architecture topics. If any critical item fails, push back or plan explicitly for rework costs.

## Key Concepts
- **Problem Definition**: A 1–2 page statement of what problem the system must solve, with no reference to solutions; must "sound like a problem," not a solution.
- **Requirements Prerequisite**: Detailed, stable specification of what the system must do; instability forces construction rework that can account for up to 65% of total project cost.
- **Architecture Prerequisite**: High-level structural design that defines major building blocks, their responsibilities, inter-block communication, and key technical decisions; determines the system's conceptual integrity.
- **Conceptual Integrity (architecture)**: The quality of an architecture that reflects one coherent vision top-to-bottom; good architecture makes construction easy, bad architecture makes it nearly impossible.
- **Risk Reduction**: The overarching goal of all upstream preparation — clear the biggest unknowns before the most expensive (construction) phase begins.
- **Sequential vs. Iterative Prerequisites**: Sequential approaches defer construction until prerequisites are complete; iterative approaches interleave them — but neither approach eliminates the need for prerequisites entirely.
- **Prewrecked**: McConnell's term for prerequisites that were nominally performed but are actually inadequate to support construction.

## Mental Models
- Think of requirements as the foundation: you can build a beautiful structure on top of a shaky foundation, but it will crack; the later you discover the crack, the more expensive the repair.
- Use the defect cost table as a forcing function: a $1,000 requirements fix becomes a $100,000 post-release fix; that math justifies almost any up-front investment.
- Think of architecture as the structural frame: it determines what's possible in construction; changing the frame mid-build is orders of magnitude more expensive than changing it on paper.
- Use the project-type framework to avoid both under- and over-preparation: too little exposes construction to destabilizing changes; too much produces plans that downstream discoveries will invalidate.

## Anti-patterns
- **Jumping into construction without a problem definition**: Risks solving the wrong problem entirely; no amount of excellent coding fixes a wrong problem statement.
- **Treating iterative development as prerequisite-free**: Iterative approaches reduce the impact of inadequate upstream work but do not eliminate it; rework costs still accumulate.
- **Over-engineering prerequisites for a simple project**: A four-hour shack doesn't need a blueprint; matching prerequisite rigor to project scale is required.
- **Problem definition that sounds like a solution**: "We need to optimize our data-entry system" is a solution statement, not a problem definition.

## Key Takeaways
1. The overarching goal of preparation is risk reduction — clear major risks before construction begins.
2. Defect fix costs escalate by 10–100x from requirements-time to post-release; this is the core economic argument for prerequisites.
3. A problem definition must describe the problem without referencing solutions; it should sound like a problem.
4. Requirements instability is the most common cause of project failure and construction rework.
5. Architecture determines conceptual integrity; architectural changes during construction are nearly as expensive as requirements changes.
6. Project type (business systems vs. mission-critical vs. life-critical) determines the appropriate sequential/iterative balance.
7. Both under-preparation and over-preparation are failure modes — calibrate to your actual project.

## Connects To
- **Ch1**: Construction is the central activity; this chapter explains what must happen before it can proceed soundly.
- **Ch4**: After prerequisites are satisfied, key construction-specific decisions remain (language, conventions, practices).
- **Ch20**: Quality assurance strategy — inspections at requirements and architecture time are the highest-ROI quality techniques.
- **Ch27**: Project size amplifies the cost of inadequate prerequisites.
