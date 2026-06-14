# Chapter 27: How Program Size Affects Construction

## Core Idea
Scaling up a software project is nonlinear in every dimension: effort, errors, activity mix, and required formality all grow faster than project size, so practices that work on small projects fail catastrophically on large ones — and vice versa.

## Frameworks Introduced
- **Project-Size Effects on Error Density**: Error density (defects/KLOC) rises with project size — from 0–25 errors/KLOC for projects under 2K LOC to 4–100 errors/KLOC for projects over 512K LOC. Large projects must work proportionally harder to achieve the same field quality.
  - When to use: Setting quality expectations and review/testing investment for a given project size.
  - How: Map project size to Table 27-1 error-density ranges; scale test and review rigor accordingly.

- **Project-Size Effects on Productivity**: Productivity declines nonlinearly as project size grows; small projects (≤2K LOC) are dominated by individual skill, large projects by team organization. Productivity on large projects can be 2–3× lower than on small ones, and up to 5–10× lower at extremes.
  - When to use: Calibrating estimates and team-structure decisions at different scales.
  - How: Consult Table 27-2 productivity ranges; recognize that team organization increasingly outweighs individual skill.

- **Diseconomy of Scale (Activity Proportions)**: As project size grows, construction scales near-linearly while non-construction activities (architecture, integration, system testing, planning) scale nonlinearly and faster. A 10× size increase may mean 25× construction effort but 40× architecture/system-testing effort.
  - When to use: Planning activity budgets and recognizing that construction proportion shrinks on large projects.
  - How: Apply Figure 27-3/27-4 reasoning; budget explicitly for non-construction overhead growing faster than code volume.

- **Right-Weight Methodology**: Scale lightweight methods up for large projects rather than scaling heavyweight methods down for small ones. The goal is a methodology calibrated to the specific communication demands of the project's size and type.
  - When to use: Choosing process formality for any new project.
  - How: Start from the smallest methodology that addresses communication needs, then add formality only as project size demands it.

## Key Concepts
- **Communication paths**: The number of team communication channels grows as n(n−1)/2 with team size; a methodology's primary job is managing this explosion.
- **Diseconomy of scale**: Unlike manufacturing, software does not benefit from economies of scale — larger projects have higher per-unit cost and higher defect density.
- **Error density**: Defects per thousand lines of code (KLOC); increases with project size due to integration complexity and communication overhead.
- **Activity proportions**: The relative share of effort devoted to construction vs. other activities (architecture, requirements, integration, testing) changes nonlinearly as project size changes.
- **Right-weight methodology**: A methodology calibrated to the specific size and type of a project — neither over-engineered nor under-specified.
- **Scaling up vs. scaling down**: Agile/lightweight methods scale up more gracefully than heavyweight methods scale down.

## Mental Models
- Use the communication-path formula (n(n−1)/2) when sizing team overhead: even a 10-person team has 45 paths, a 50-person team has 1,225.
- Think of construction as a near-linear activity and everything else as superlinear: when a project grows 10×, plan for far more than 10× non-construction work.
- Use "right-weight" as a calibration question: "What is the minimum formality that keeps communication from breaking down at this size?"
- Think of error density as a size tax: the larger the project, the more defect-prevention investment is required per KLOC to achieve the same field quality.

## Anti-patterns
- **Scaling a small-project approach to a large project**: Communication breaks down, integration becomes chaotic, and activities taken for granted (change control, architectural reviews) are absent.
- **Scaling a heavyweight methodology down to a small project**: Overhead crushes productivity; the project collapses under its own process weight.
- **Assuming 10× size = 10× effort**: Ignores nonlinear scaling of non-construction activities; leads to severe underestimation.

## Key Takeaways
1. A 10× increase in project size typically requires ~30× effort and increases errors per KLOC by up to 4×.
2. Productivity is dominated by individual skill on small projects and by team organization on large ones.
3. Construction becomes a smaller fraction of total effort as projects grow — architecture, planning, and integration consume proportionally more.
4. Methodologies exist to manage communication; judge them by how well they do that.
5. Scale lightweight methods up; do not scale heavyweight methods down.
6. Activities taken for granted on small projects (change control, estimation, integration planning) must be explicitly planned on large ones.

## Connects To
- **Ch3**: Prerequisites to construction; project type and size determine appropriate process formality.
- **Ch28**: Managing construction — estimation, configuration management, and measurement all become critical as size grows.
- **Ch29**: Integration strategy is one of the activities that scales nonlinearly with project size.
