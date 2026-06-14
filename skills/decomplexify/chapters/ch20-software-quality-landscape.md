# Chapter 20: The Software-Quality Landscape

## Core Idea
Improving quality reduces development costs — the **General Principle of Software Quality** — because the single biggest drain on productivity is time spent debugging and reworking code, which upstream quality practices eliminate before defects compound.

## Frameworks Introduced
- **General Principle of Software Quality**: "Improving quality reduces development costs." Reducing rework (from debugging, redesign, requirements churn) is the lever; upstream QA has more leverage per hour invested than downstream testing or debugging.
  - When to use: Any time stakeholders claim quality and speed are in tension.
  - How: Redirect time from downstream debugging/rework into upstream reviews, explicit quality objectives, and structured testing.

- **Defect-Detection Rate Comparison** (Table 20-2 — prose summary): No single technique removes more than ~70% of defects. Formal code inspections: 45–70%; formal design inspections: 45–65%; personal desk-checking: 20–60%; unit testing: 15–50%; integration testing: 25–40%; beta testing: 25–40%. Combination of methods required to achieve high removal rates.
  - When to use: Selecting and combining quality techniques for a project.
  - How: Match techniques to defect type; use several in combination; track actual removal rates on your project.

## Key Concepts
- **Correctness**: Degree to which a system is free from faults in its specification, design, and implementation.
- **Reliability**: Ability to perform required functions under stated conditions whenever required; measured as mean time between failures.
- **Robustness**: Degree to which a system continues to function in the presence of invalid inputs or stressful conditions — trades off against correctness.
- **Usability**: Ease with which users can learn and use a system.
- **Efficiency**: Minimal use of system resources including memory and execution time.
- **Maintainability**: Ease of modifying a system to change or add capabilities, correct defects, or improve performance.
- **Flexibility**: Extent to which a system can be modified for uses beyond its original design environment.
- **Testability**: Degree to which a system can be unit-tested and system-tested; verifiability against requirements.
- **External quality characteristics**: What users perceive — correctness, usability, efficiency, reliability, integrity, robustness, adaptability, accuracy, portability.
- **Internal quality characteristics**: What programmers value — maintainability, flexibility, portability, reusability, readability, testability, understandability.

## Mental Models
- Use explicit quality objectives at project start; without named goals, developers optimize for the wrong characteristics by default.
- Think of quality characteristics as a trade-off matrix: some pairs help each other (adaptability + robustness), some hurt each other (correctness ↔ robustness), and some are neutral — know which is which for your project.
- Think of debugging as a cost center: ~50% of traditional project time is consumed by debugging and rework; eliminating defects earlier collapses that cost.
- Use multiple complementary defect-detection methods because each method finds different kinds of defects and no single method approaches 100%.

## Anti-patterns
- **Single-technique QA**: Relying only on testing misses defects that only reviews catch (unclear error messages, hard-coded values, duplicated patterns — things a compiler never flags).
- **Late-stage quality work**: Treating QA as a final phase inverts the leverage ratio — upstream defect prevention yields far greater ROI per hour than downstream debugging.
- **Quality vs. speed false trade-off**: Field data shows that developers who took median time had the *most* defects; fastest and most careful groups tied for fewest. Quality and speed are not inherently opposed.

## Key Takeaways
1. The General Principle of Software Quality: improving quality reduces development costs by eliminating rework, not adding overhead.
2. Debugging and rework consume roughly 50% of project time on naive development cycles; upstream QA reclaims that time.
3. No single defect-detection technique catches more than 70% of defects — combine techniques by design, not accident.
4. Differentiate external quality characteristics (user-visible) from internal ones (maintainability, readability) — each serves a different stakeholder and must be explicitly managed.
5. Set explicit quality objectives at project start; teams without them will optimize for whatever is easiest to measure, not what matters.
6. Cost of quality: the enlightened QA program redistributes resources from rework to prevention; net result is fewer defects, shorter schedule, lower cost.

## Connects To
- **Ch21**: Collaborative construction achieves 45–70% defect detection — the highest rate of any single technique in Table 20-2.
- **Ch22**: Developer testing provides a complementary defect-detection layer after reviews; different methods find different defects.
- **Ch23**: Debugging is the cost center the General Principle of Software Quality targets for elimination.
- **Ch3–4**: Prerequisites quality directly determines how much construction rework accumulates.
