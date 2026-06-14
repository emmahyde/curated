# AI System Prompts — SOTA Pattern Reference

Source repo: https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools
Raw fetch base: `https://raw.githubusercontent.com/x1xhlol/system-prompts-and-models-of-ai-tools/main/<Tool>/<File>.txt`
Covers: Cursor, Devin, Kiro, Claude Sonnet 4.6, Windsurf, Comet, Emergent, Amp, and 15+ others.

## When to use this reference

During **Step 2 (research/cherry-pick)** of source-to-skill: when the skill you're generating involves agentic behavior, multi-step workflows, code editing, or tool orchestration — check this reference before writing the SKILL.md. SOTA prompts are the highest-signal source of what patterns actually work in production AI coding assistants.

## Cross-cutting patterns (appear in 2+ tools)

| Pattern | Rule | Source tools |
|---------|------|-------------|
| **Think-before-act gate** | Require explicit reasoning before: git decisions, switching from explore→edit, reporting done | Devin, Kiro |
| **Explore-before-edit** | Gather all context, find every edit location, inspect references/types before touching code | Devin, Cursor |
| **Verify-after-edit** | Post-implementation: confirm all locations changed, lint passes, tests pass | Devin, Kiro |
| **Stage-gated approval** | Requirements → Design → Tasks; explicit user "yes" required before advancing each stage | Kiro |
| **Artifact-based state** | Store plans/tasks as files (e.g. `.kiro/specs/{name}/tasks.md`), not in model memory | Kiro |
| **Tool specialization** | Never use shell for file edits; never use editor for shell commands; one tool per job | Devin |
| **Minimal surgical diffs** | Edit only what's needed; match surrounding style; no unrequested rewrites | Cursor, Devin |
| **Completion verification** | Before reporting done: re-read task, verify ALL locations changed, run lint/test | Devin, Kiro |
| **Warm direct tone** | No filler words ("genuinely", "honestly"); no emojis by default; push back constructively | Claude 4.6 |

See [[knowledge-and-memory]] for how to persist patterns found here into Claude's memory system.

## Tool inventory for targeted fetch

| Tool | Prompt path | Size | Notable for |
|------|------------|------|-------------|
| Cursor | `Cursor Prompts/Chat Prompt.txt` | 12KB | Context auto-attachment, pair-programming framing |
| Devin | `Devin AI/Prompt.txt` | 34KB | Think-gate, tool specialization, verification loops |
| Kiro | `Kiro/Spec_Prompt.txt` | 32KB | Stage-gated spec workflow, approval loops, artifact state |
| Kiro Vibe | `Kiro/Vibe_Prompt.txt` | 14KB | Lightweight coding mode |
| Claude Sonnet 4.6 | `Anthropic/Claude Sonnet 4.6.txt` | 43KB | Tone rules, memory system, artifact storage API |
| Comet | `Comet Assistant/System Prompt.txt` | 53KB | Broadest tool surface |
| Emergent | `Emergent/Prompt.txt` | 37KB | Agent loop + tools.json |
| Amp | `Amp/claude-4-sonnet.yaml` | 66KB | YAML-structured agent config |
| Devin DeepWiki | `Devin AI/DeepWiki Prompt.txt` | 5KB | Documentation-driven exploration |

Fetch any prompt: `WebFetch <raw-base-url>/<path>` — search for `MUST`/`SHOULD`/`NEVER` rules and stage/workflow definitions.

## Application to source-to-skill Step 2 cherry-pick

Match the skill shape you chose in Step 4 to the most relevant SOTA pattern:

- **Low-freedom workflow skill** → apply Devin's think-gate + verify-after
- **Stage-gated skill** → apply Kiro's approval loop (explicit "yes" before advancing)
- **Agent/coding skill** → apply Cursor's context-attachment + minimal-diff rules
- **Any skill with persistent state** → apply Kiro's artifact-based state (files > memory)
- **Reference/lookup skill** → apply Claude 4.6's tone rules + completion verification
