# Chapter 28: Managing Construction

## Core Idea
Construction management requires explicit attention to coding standards, configuration management, estimation, measurement, and human factors — none of these can be assumed to work themselves out on a real project.

## Frameworks Introduced
- **Configuration Management (Change Control)**: The practice of identifying project artifacts and handling changes systematically so the system maintains integrity over time. Covers requirements changes, code changes, version control, and machine configurations.
  - When to use: On any project where more than one person touches the code, or where requirements are likely to evolve.
  - How: Control requirements changes through a change-control board or informal change list; use version-control software for source; archive every project artifact at completion.

- **Estimation**: Predicting project size, effort, and schedule. The average large software project is one year late and 100% over budget; developer estimates carry a 20–30% optimism bias.
  - When to use: At project start and iteratively as work progresses; tighten estimates as more is known.
  - How: Use multiple approaches (estimating software, algorithmic models like Cocomo II, expert judgment, task-level rollups, historical data); establish objectives, decompose work, estimate pieces, then add; distinguish estimation from control.

- **Measurement**: Collecting objective data about the construction process to support scheduling, quality control, and process improvement.
  - When to use: Continuously during construction; start simple (defects, work-months, dollars, LOC) and refine.
  - How: Set goals, determine questions, then measure to answer them (GQM approach); use metrics to identify outlier routines rather than fine-rank all code; standardize measurements across projects.

- **Treating Programmers as People**: Recognizing that programmer performance varies enormously (10:1 or more between individuals) and that motivation, religious issues, and physical environment materially affect output.
  - When to use: Team staffing, workspace design, standard-setting, and recognition decisions.
  - How: Hire the best programmers possible (top-10% vs bottom-10% yields ~3.5× productivity difference per Cocomo II); avoid mandating religious issues (language choice, brace style, IDE); provide quiet working space; make standards transparent and technically credible.

## Key Concepts
- **Configuration management (SCM)**: Systematic tracking of all project artifacts — code, requirements, design, docs — and their changes over time.
- **Version control**: Software that tracks multiple historical versions of source files, enabling rollback, comparison, and safe parallel development.
- **Change-control board**: A formal or informal mechanism for evaluating, approving, and tracking proposed changes to requirements or design.
- **Brooks's Law**: Adding people to a late software project makes it later; applies most strongly when tasks cannot be divided independently.
- **Estimation vs. control**: The accuracy of the initial estimate matters less than the ability to control resources against the schedule after the estimate is set.
- **Religious issues**: Programming decisions (language, indent style, brace placement, IDE, commenting style) that are matters of personal conviction; managers who mandate these invite resentment.
- **Programmer performance variation**: Studies show 10:1 differences between best and worst individual programmers; team-level variation of 3.4:1 to 5:1 has been documented even among professionals.
- **Good programmers cluster**: High-performing programmers tend to join and stay at organizations that already have high-performing programmers.

## Mental Models
- Think of configuration management as a safety net: without it, integration becomes finger-pointing time because no one can establish what changed when.
- Use estimation as a starting condition, not a guarantee — the real leverage is in controlling scope and resources after the estimate is set.
- Think of programmer performance as a multiplier, not an additive factor: hiring one top-10% programmer can outweigh hiring three average ones.
- Use the "I must be able to read and understand any code on this project" standard as a light-touch quality gate that discourages clever-but-unreadable code without imposing rigid rules.

## Anti-patterns
- **No change control**: Requirements drift untracked; code is written for features that get eliminated; incompatibilities accumulate until integration time.
- **Ham-handed change control**: Bureaucracy so heavy it blocks legitimate changes and drives developers to work around it.
- **Single-point estimation**: One estimate with no range, no cross-check against other methods, and no revision as the project proceeds.
- **Mandating religious issues**: Forcing language, brace style, or IDE choice destroys morale without improving code quality.
- **Adding people to a late project**: Brooks's Law — the new people require ramp-up time, partition tasks that weren't designed to be divided, and generate new communication overhead.
- **Measuring everything at once**: Starting measurement by collecting all possible metrics buries the team in uninterpretable data; start with four core metrics and refine.

## Key Takeaways
1. Configuration management — especially version control and change control — makes programmers' jobs easier and should be designed to help them, not constrain them.
2. Good estimation uses multiple approaches, decomposes work, and is tightened iteratively; the optimism bias is ~20–30%, so adjust accordingly.
3. Measurement is essential to construction management; even imperfect measurement is better than none, and outlier detection is more reliable than fine-grained ranking.
4. Individual programmer performance varies by 10:1; hiring excellent programmers is the highest-leverage management action available.
5. Managers must distinguish technical standards (appropriate to mandate) from religious issues (inappropriate to mandate).
6. When behind schedule, reducing scope is more reliable than adding people or hoping to catch up.

## Connects To
- **Ch27**: Project size determines the formality required for all management practices in this chapter.
- **Ch29**: Integration planning is a configuration management concern and benefits directly from version control.
- **Ch22**: Measurement of defects feeds the quality-assurance practices discussed there.
