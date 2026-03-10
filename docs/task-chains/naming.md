# Task Chain Naming

## Core Term
**任务链 / Task Chain**

Definition:
A task chain is a multi-step workflow executed by an agent or agent+tool system, where each step contributes to a concrete outcome and may produce state, artifacts, or validation results.

## Recommended Subtypes

### 1. 线性任务链 / Linear Task Chain
A straight-through chain with no meaningful branch selection.

Examples:
- open app -> type text -> save file -> reopen -> compare

Use when:
- the path is predetermined
- there is no branch decision
- failure usually means retry or repair, not alternate routing

### 2. 闭环决策链 / Closed-Loop Decision Chain
A chain that must first inspect state, choose a branch, execute that branch, then verify whether the chosen branch produced the intended result.

Examples:
- read screenshot -> determine route A/B -> execute A or B -> verify branch outcome
- inspect dashboard state -> choose recovery action -> validate state change

Use when:
- perception affects execution path
- there is explicit branch logic
- outcome must be verified against the original decision

### 3. 可恢复任务链 / Recoverable Task Chain
A chain that can enter a recovery round after failure, using a different strategy instead of pretending the first run succeeded.

Examples:
- first save produced wrong formatting -> overwrite and verify again
- first OCR run clipped text -> regenerate cleaner source and retry

Use when:
- the system must preserve failed attempts as evidence
- retry strategy is part of the design
- multiple rounds are first-class, not accidental

### 4. 可审计任务链 / Auditable Task Chain
A chain whose execution history is intentionally preserved in structured logs, including writebacks, validations, and round transitions.

Examples:
- each step writes to CHAIN_LOG.md
- each verification records expected vs actual
- each new round records cause and new strategy

Use when:
- correctness matters more than appearance
- human review is expected
- the chain may later become a product/system feature

## Composition Rule
These labels are composable.

Examples:
- **线性闭环任务链**
- **可恢复闭环决策链**
- **可审计可恢复任务链**

Recommended pattern:
- start with the broad type `任务链`
- add the traits that materially matter
- avoid unnecessary stacking when one term already explains the workflow

## Preferred Default Term
If only one label is used, prefer:

> **闭环决策链**

Why:
- emphasizes sensing before acting
- implies verification after acting
- distinguishes true agentic execution from macro playback

## Practical Naming Examples
- TextEdit end-to-end demo -> **线性闭环任务链**
- OCR -> branch A/B -> TextEdit action -> verify -> **闭环决策链**
- OCR -> transfer -> fail -> remediation round -> verify -> **可恢复闭环任务链**
- full chain with per-round logs and validations -> **可审计可恢复任务链**
