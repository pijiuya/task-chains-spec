# Task Chain State Machine

## Goal
Provide a simple state model for task chains that include execution, validation, branching, and recovery.

## Canonical States

### 1. `planned`
The chain exists as intent, but no live execution has started.

### 2. `running`
The current round is actively executing steps.

### 3. `writeback_pending`
A meaningful state update, artifact, or observation should be recorded before continuing.

Typical triggers:
- scaffold created
- OCR result obtained
- branch selected
- file saved
- error observed

### 4. `validation_pending`
A concrete result now exists and must be checked.

Typical triggers:
- screenshot captured
- file reopened
- expected vs actual comparison required
- branch outcome must be confirmed

### 5. `decision_pending`
The chain has enough information to choose a branch, retry, or stop, but has not committed yet.

Typical triggers:
- OCR says route A or B
- validation failed and recovery strategy must be chosen
- ambiguous state needs classification

### 6. `round_transition`
The chain is explicitly ending one round and starting another.

Typical triggers:
- first attempt failed, remediation round begins
- branch path changed
- strategy changed after diagnosis

### 7. `passed`
The chain reached a validated success condition.

### 8. `failed`
The chain reached a terminal failure condition.

Use `failed` when:
- validation disproved correctness and no new recovery round is approved
- execution environment is broken
- safety or permissions block continuation

### 9. `blocked`
The chain cannot proceed until an external dependency changes.

Examples:
- permission missing
- app unavailable
- user confirmation required

## Required Transition Rules

### Rule A — execution is not success
A chain may not move from `running` directly to `passed` without entering `validation_pending`.

### Rule B — writeback before forgetting
If a round discovers a meaningful fact, it should enter `writeback_pending` before moving on when practical.

### Rule C — failed validation must branch or stop
If validation fails, the chain must go to either:
- `decision_pending`
- `round_transition`
- `failed`

It should not silently continue as if the validation passed.

### Rule D — branch execution requires recorded choice
If the chain uses branching, the selected branch should be recorded before execution continues.

### Rule E — new round requires explicit reason
Entering `round_transition` should record:
- why the prior round ended
- what changes in the next round

## Minimal Transition Diagram

`planned`
-> `running`
-> `writeback_pending` (optional but recommended)
-> `validation_pending`
-> `decision_pending` (if branch/recovery needed)
-> `running` (continue same round) or `round_transition`
-> `running` (new round)
-> `passed` or `failed` or `blocked`

## Typical Patterns

### Pattern 1 — simple linear chain
`planned -> running -> validation_pending -> passed`

### Pattern 2 — branch chain
`planned -> running -> validation_pending -> decision_pending -> running -> validation_pending -> passed`

### Pattern 3 — recovery chain
`planned -> running -> validation_pending -> round_transition -> running -> validation_pending -> passed`

### Pattern 4 — blocked chain
`planned -> running -> blocked`

## Execution Notes
- `writeback_pending` may be lightweight, but should exist conceptually even when merged into the current step.
- `decision_pending` is the critical boundary between automation and actual agency.
- `round_transition` is what makes recovery auditable instead of hidden.
