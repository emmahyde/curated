---
name: passoff
description: Token-conservative session handoff. Emits symbolic-notation summary of in-progress + recently-completed tasks, pointers to remaining work, references for further context, and literal TaskCreate seeds for rehydrating the cleared TaskList. Use when user types /passoff, says "pass off", "handoff", "hand this off", "context handoff", "summarize state for next session", "prep for /clear", or wants to compactly transfer current state to a fresh session, teammate, or future-self with minimal token cost.
---

# Passoff — Compressed Session Handoff

Goal: hand the next agent (or future-you) the state of play in fewest tokens that preserve intent. Optimize fidelity-per-token, not prose.

## When to invoke

- User types `/passoff` or asks for handoff/context dump.
- Before `/clear`, before context compaction, before swapping agent or model.
- End of a working session.
## Spinoff handoff integration
- When creating a fresh split with `~/.claude/scripts/spinoff-session.sh`, pass the passoff as the 3rd argument:
-  `bash ~/.claude/scripts/spinoff-session.sh <task-file> [model] <passoff-file>`
- If no passoff file is available, pipe passoff text on stdin instead:
-  `cat <passoff-file> | bash ~/.claude/scripts/spinoff-session.sh <task-file> [model]`

## Core Principle: Legend Defines Meaning

**Any single-token word or symbol can serve as a marker for any concept — provided the legend binds it.** The notation is not sacred; the legend is. If you bind `now` to in-progress in the legend, `now` means in-progress for that document. If you bind `>>>`, it means in-progress. If you bind `xyz`, same.

This frees you to:
- Pick whatever is most readable for the audience (English, symbols, CJK, mix).
- Reuse short tokens across roles (`!` for decisions in one passoff, `!` for blockers in another) as long as the legend is unambiguous within that document.
- Drop unused legend entries — never list a marker you didn't use.

### Tiebreaker: prefer English unless symbol is strictly cheaper

Most short English words tokenize as **1 token** (`done`, `next`, `blocked`, `because`, `implies`, `high`, `low`). Symbols only beat them when they replace a *multi-word phrase*:

| English | Tokens | Symbol | Tokens | Use |
|---------|--------|--------|--------|-----|
| because | 1 | ∵ | 2 | **because** |
| therefore | 2 | ∴ | 2 | **therefore** (clearer at same cost) |
| implies | 2 | ⇒ | 3 | **implies** |
| leads to / causes | 2 | `>` | 1 | **`>`** (symbol wins) |
| at | 1 | `@` | 1 | **`@`** before paths (parses cleanly) |
| high/medium/low | 1 each | H/M/L | 1 each | **bare letters** in dense tag columns; bare words elsewhere |

Rule of thumb: **reach for a symbol only when the English equivalent is two-or-more tokens.** Otherwise English wins on readability for free.

### Use `>` not `→`

Both bare cost 1 token; `→` with surrounding spaces costs 2 (same as `>` with spaces). `>` wins because:
- ASCII — universal rendering, no font/locale risk.
- Programmer-familiar (`stdin > stdout`, comparison, JSX).
- No unicode glyph dependency for downstream consumers.

Caveat: `>` at the **start of a line** is markdown blockquote and will render as one. Keep `>` inline only — use `-` or section headers to start lines.

### Token-cheap candidates (≈1 token each in BPE)

Verified single-token in cl100k_base (Claude tokenizer comparable for ASCII):

- **English short words**: `done`, `next`, `todo`, `blocked`, `open`, `active`, `fixed`, `now`, `drop`, `kill`, `note`, `ref`, `wip`(2), `hold`, `skip`
- **ASCII symbols**: `>>>`, `<<<`, `-->`, `==>`, `!!!`, `???`, `$`, `#`, `@`, `!`, `?`
- **Single letters** (in context): `H`, `M`, `L`, `S`, `B`, `D`, `N`
- **Flow/relation (ASCII preferred)**: `>` (causes/leads to), `=>` (implies), `<-` (depends on)
- **Math (use only when English costs more)**: `∵` (because — but English wins), `∴` (therefore — tie), `→`/`⇒` (avoid; `>`/`=>` cheaper portably)

Avoid:
- Color emoji (🔗📍⚠️) — 2 tokens + variation selectors.
- Geometric (▶✓⛔) — 2-3 tokens, rare in corpus.
- Nerd Font PUA — 3+ tokens, no portability, no model semantics.
- Bracketed forms `[done]` — brackets cost 2 extra tokens; prefer bare `done`.

## Default Output Format

Use this template unless audience preferences dictate otherwise. Sections empty → omit. Order fixed. Apply caveman compression to every line (see Compression Rules).

```
# PASSOFF · <slug> · <YYYY-MM-DD HH:MM>

## LEGEND
now      in-progress       done      completed
next     upcoming          blocked   stuck / needs unblock
drop     abandoned         ref       file/commit pointer
note     decision/anchor   ?         open question
>  causes / leads to       =>  implies       <-  depends on
@path:line   #branch   $cmd   !env-var
[H/M/L] priority    {S|M|L} effort    ~approx

## NOW
- <task> @file:line — <one-line state>  blocked:<blocker>

## DONE
- <task>  > <outcome>  ref:<commit|file>

## NEXT
- [H] <task>  because <reason>  {S|M|L}
- [M] <task>  > unblocks <thing>
- [L] <task>

## BLOCKED / OPEN ?
- blocked: <issue>  > need <resolution>
- ? <question>  note:<where surfaced>

## NOTES
- <decision>  because <reason>  ref:<file/commit>

## REFS
- code: @path:line — <why matters>
- docs: <path/url> — <contents>
- prior: <sha|PR#|session-id> — <topic>
- skills: /<skill> — <when to invoke>

## RESUME
$ <exact command(s) to pick up>
#branch · uncommitted: <count> · tests: <pass/fail/unrun>

## REHYDRATE TASKS
Next agent: each line = one TaskCreate. Format: `[priority] title || activeForm`.
- [H] <imperative title> || <present-continuous active form>
- [M] <imperative title> || <present-continuous active form>
- [L] <imperative title> || <present-continuous active form>
```

## Compression Rules (apply caveman style throughout)

**Read `references/caveman-style.md` for the full caveman compression rules.** Vendored locally — does not require the upstream `caveman` plugin to be installed. The summary below is the minimum; the reference has examples, intensity calibration, auto-clarity rules, and an anti-pattern list.

1. **Legend governs.** Pick markers, bind in legend, use consistently in body. Different passoff docs may use different markers — fine.
2. **Trim legend.** Only list entries actually used. Unused = waste.
3. **Caveman prose (full intensity).** Drop articles (a/an/the), copulas (is/are/was when subject obvious), filler (just/really/basically/actually/simply), pleasantries, hedging. Fragments OK. Pattern: `[thing] [action] [reason]`. Example: `Bug @auth/mw.py:84 — token expiry uses < not <=` — not `There is a bug in the auth middleware which means that the token will never expire because...`. See `references/caveman-style.md` for the full ruleset and per-line self-check.
4. **One line per item.** Wrap only if a thought genuinely doesn't fit.
5. **Cite, don't summarize.** Findings >1 line: gist + `ref:<location>`.
6. **Priority + effort tags** on NEXT items so next agent sequences without re-deriving.
<MANDATORY>
7. **RESUME literal.** Exact command, exact branch. Copy-paste-runnable.
</MANDATORY>
<REQUIREMENTS>
8. **Preserve exact strings** for errors, paths, shas, env vars, commands. Compression for prose, not identifiers.
</REQUIREMENTS>
9. **REHYDRATE TASKS mirrors NEXT.** Same items, recast for direct `TaskCreate` consumption — TaskList clears across `/clear` and session boundaries; next agent must rebuild. Format: `[priority] imperative title || activeForm` (matches TodoWrite/TaskCreate `content` + `activeForm` fields). One line per task, no markers in title, no commentary.
10. **Auto-clarity escape hatch.** Drop caveman style for: security warnings, irreversible-action warnings, ambiguous fragment ordering. Example: a destructive `RESUME` command with side effects → write a normal-prose warning line above it, then resume caveman.

## Sourcing State

Pull in order:
1. **Current conversation** — what was just worked on, decided, half-finished.
2. **`git status` + `git log -5`** — uncommitted work, recent commits.
3. **TaskList** (if active) — explicit todos.
4. **Branch/worktree state** — branch name, ahead/behind.
5. **Open questions user raised** — most expensive context to recover; do not drop.

<MANDATORY>
Do NOT invent state. Unknown → omit section or mark `? unknown`.
</MANDATORY>

## Examples

### Minimal (single task, mid-flight)

```
# PASSOFF · memesis · 2026-05-07 14:32

## LEGEND
now active   next upcoming   @path:line   $cmd

## NOW
- consolidator dedup bug @core/consolidator.py:184 — cosine ≥0.95 false-positive on short notes

## NEXT
- [H] length-gate before cosine cmp {S}
- [M] regression test @tests/test_consolidator.py {S}

## RESUME
$ python3 -m pytest tests/test_consolidator.py::test_dedup_short -x
#branch main · uncommitted: 1 · tests: 1 fail

## REHYDRATE TASKS
- [H] add length-gate to consolidator dedup || gating consolidator dedup by length
- [M] write regression test for short-note dedup || writing short-note dedup regression test
```

### Full (end-of-session, multiple threads)

```
# PASSOFF · memesis · 2026-05-07 18:05

## LEGEND
now active   done finished   next upcoming   blocked stuck   note decision   ref pointer
> causes   @path:line   [H/M/L] priority   {S|M|L} effort

## NOW
- evolve --pick LLM ranker @scripts/evolve.py:412 — works ≤20 transcripts, OOM at 100+ blocked

## DONE
- transcript_ingest schema migration > landed  ref:a548355
- llm_cache logger fix > landed  ref:2c3d5e4

## NEXT
- [H] batch --pick chunks of 20  because avoid OOM  {M}
- [H] wire eval/recall/ harness to evolve  {M}  > unblocks pipeline diff report
- [M] backfill stats for legacy memories  {L}
- [L] dashboard polish  {S}

## BLOCKED / OPEN ?
- blocked: memvid/ vendored copy diverged from upstream  > decide vendor vs submodule
- ? crystallized->instinctive promotion: time-gated or usage-gated?  note:evolve runbook draft

## NOTES
- behavioral framing for friction signals  because transfers across sessions  ref:AGENTS.md
- atomic writes via tempfile+shutil.move  ref:core/database.py:55

## REFS
- code: @scripts/evolve.py:412 — pick loop
- code: @core/consolidator.py — dedup logic
- docs: .context/RISK-REGISTER.md — open risks
- prior: ea8da35 — evolve runbook
- skills: /memesis:evolve — replay harness

## RESUME
$ python3 scripts/evolve.py --pick --batch 20 --transcript <path>
#branch main · uncommitted: 14 · tests: pass (17:42)

## REHYDRATE TASKS
- [H] batch evolve --pick into 20-transcript chunks to avoid OOM || batching evolve --pick into 20-transcript chunks
- [H] wire eval/recall harness to evolve pipeline || wiring eval/recall harness to evolve
- [M] backfill stats for legacy memories || backfilling legacy memory stats
- [L] polish dashboard UI || polishing dashboard
```

## Anti-patterns

<ALERT>
- ✗ Prose paragraphs. Symbol-ify.
- ✗ Restating file contents. Point with `@path:line`.
- ✗ Vague NEXT items (`improve performance`). Concrete predicates: `batch X chunks of N`.
- ✗ Dropping RESUME line. Highest-leverage line in doc.
- ✗ Legend entries unused in body. Trim.
- ✗ Bracketing markers (`[done]`, `[x]`). Brackets = 2 extra tokens. Use bare.
- ✗ Color emoji (🔗📍). 2 tok each + variation selectors. Use ASCII or CJK.
- ✗ Inventing state. If unsure, mark `? unknown` or omit.
</ALERT>
