# Task Chains Development Guide

## Purpose
This document explains how to design, implement, and evolve task chains as a practical agent runtime pattern.

It is intended for developers building systems that combine:
- perception (OCR, screenshot understanding, UI state reading)
- action (GUI control, browser control, file operations)
- verification (expected vs actual checks)
- recovery (new rounds, alternate strategies)
- auditability (human-readable logs)

---

## 1. What a Task Chain Is
A task chain is not a single tool call.
It is a managed sequence of steps that moves from intent to outcome while preserving enough structure to:
- know what happened
- verify whether it worked
- recover when it failed
- explain itself afterward

A useful mental model is:

> **Task chain = plan + execution + validation + recovery + history**

If one of those pieces is missing, the chain may still be useful, but it is less trustworthy.

---

## 2. Design Principles

### 2.1 Execution is not success
Clicking buttons or producing a file does not mean the chain succeeded.
A chain should only be considered successful after validation.

### 2.2 Perception must influence action
If the system reads the world but always runs the same path, it is not yet a true decision chain.
At least some chains should change behavior based on perceived state.

### 2.3 Recovery must be explicit
Retries are not free.
If a first attempt failed, the chain should record that failure and explain why a second round exists.

### 2.4 Logs are part of the product
`CHAIN_LOG.md` is not decoration.
It is part of the execution contract.
If humans cannot inspect what happened, the chain is harder to trust and harder to debug.

### 2.5 Keep the hand and the brain separate when needed
For local GUI automation, it is often best to split roles:
- **planner / validator / recorder**
- **local executor**

This becomes even more important when subagents are introduced.

---

## 3. Recommended Project Structure

```text
my-task-chain/
  README.md
  REPORT.md
  CHAIN_LOG.md
  expected/
  artifacts/
  rounds/
```

### File roles

#### `README.md`
Short orientation.
What the chain is and what it demonstrates.

#### `REPORT.md`
Human summary of the chain after execution.
Should answer:
- what was tested
- what passed
- what failed
- what was learned

#### `CHAIN_LOG.md`
Main audit trail.
Should include:
- round starts
- writebacks
- validations
- transitions to new rounds

#### `expected/`
Ground truth artifacts or reference outputs.

#### `artifacts/`
Captured screenshots, generated files, and produced outputs.

#### `rounds/`
Optional directory for round-specific working material when chains become more complex.

---

## 4. Lifecycle

A healthy task chain usually follows this shape:

1. **Plan**
2. **Execute**
3. **Write back meaningful state**
4. **Validate**
5. **Decide whether to continue, branch, recover, or stop**
6. **Repeat until pass / fail / blocked**

This maps to the state machine in `state-machine.md`.

---

## 5. When to Use Which Chain Type

### Linear Task Chain
Use when the path is predetermined.

Examples:
- open file
- type content
- save
- reopen
- compare

### Closed-Loop Decision Chain
Use when the system must inspect state before acting.

Examples:
- read screenshot -> choose A/B -> execute selected path -> verify
- inspect UI status -> choose recovery action -> check whether state changed

### Recoverable Task Chain
Use when iterative repair is part of the intended behavior.

Examples:
- first run clipped OCR text -> regenerate cleaner source -> retry
- saved file has formatting defect -> overwrite and verify again

### Auditable Task Chain
Use when humans should later be able to review execution.

Examples:
- productized workflows
- operational automations
- tasks involving stateful desktop actions

---

## 6. Logging Standard
Every serious chain should record three event types.

### 6.1 `WRITEBACK`
Use for important facts that should not be lost.

Examples:
- OCR result captured
- branch decision chosen
- file saved to path
- root cause identified

### 6.2 `VALIDATION`
Use whenever an output is checked against a condition.

Examples:
- screenshot captured successfully
- reopened file matches expected content
- chosen branch produced correct artifact

### 6.3 `ROUND_TRANSITION`
Use whenever the strategy changes or a new attempt begins.

Examples:
- first run failed because target window was ambiguous
- second run uses unique title and refreshed app state
- remediation round begins after exact-content mismatch

---

## 7. Validation Strategy

### 7.1 Prefer exact validation when practical
For text outputs, exact compare is ideal.
For screenshots, exact text OCR or targeted visual checks are usually better than vague summaries.

### 7.2 Normalize only what is intentionally non-essential
Examples of acceptable normalization:
- trailing newline differences
- platform-specific path separators, if irrelevant

Examples of unacceptable normalization:
- silently ignoring missing lines
- silently ignoring wrong branch outputs
- silently ignoring mis-targeted windows

### 7.3 Validation failure should change control flow
A failed validation should not be treated as a soft warning if correctness matters.
It should force either:
- a new decision
- a new round
- or terminal failure

---

## 8. Recovery Design
Recovery is not just retry count.
Good recovery changes something.

Examples of good recovery adjustments:
- unique window title instead of ambiguous title
- simpler OCR layout
- overwrite existing file instead of patching a partial state
- re-capture after refocusing target app

Examples of weak recovery:
- repeat same action without learning
- mark pass because output is “close enough” without declared tolerance

---

## 9. Subagent Architecture Guidance

### Best role for subagents
Subagents are strong at:
- planning rounds
- interpreting logs
- deciding branch logic
- comparing expected vs actual results
- generating reports and summaries

### Best role for the main session
Main session is better for:
- direct macOS GUI execution
- focus-sensitive desktop actions
- permission-bound local operations
- time-sensitive interactive steps

### Recommended split

> **Subagent = brain**
> 
> **Main session = hand**

This split is especially useful for closed-loop decision chains where the decision logic is stable but the local environment is volatile.

---

## 10. Anti-Patterns
Avoid these patterns.

### 10.1 Hidden retries
If the first attempt failed, pretending only the final attempt existed destroys auditability.

### 10.2 Success by narration
“Should be done” is not validation.
If the chain claims success, there should be an actual check.

### 10.3 Unlogged branch selection
If a branch was chosen and that choice is not recorded, debugging later becomes painful.

### 10.4 Mixing unrelated project files into publication
When publishing task-chain work, isolate it into a clean repo or package.
Do not dump an entire noisy workspace into GitHub unless that is the actual intended repository.

---

## 11. Suggested Maturity Levels

### Level 1 — Scripted
The chain runs steps, but has weak validation.

### Level 2 — Validated
The chain validates outputs before claiming success.

### Level 3 — Recoverable
The chain can enter a new round with a changed strategy.

### Level 4 — Auditable
The chain keeps a clear execution history.

### Level 5 — Agentic
The chain uses perception to choose execution paths and still maintains validation and recovery.

---

## 12. Minimum Viable Standard
For a new task chain design to be considered production-worthy, it should satisfy at least:
- one explicit validation step
- one explicit writeback step
- a defined failure path
- a defined pass condition
- a human-readable execution log

If branching exists, it should also include:
- a recorded branch decision
- a validation that the chosen branch actually produced the intended result

---

## 13. Recommended Next Additions
The next useful artifacts to formalize are:
- a reusable directory template
- a machine-readable JSONL audit stream
- a subagent/main-session cooperation protocol
- a task-chain runner that enforces state transitions automatically

---

## 14. Bottom Line
A task chain becomes genuinely useful when it stops being “a script that did some things” and becomes:
- inspectable
- falsifiable
- recoverable
- explainable

That is the difference between fragile automation and trustworthy agentic execution.
