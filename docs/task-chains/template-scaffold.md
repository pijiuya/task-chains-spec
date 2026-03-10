# Task Chain Template Scaffold

## Purpose
This scaffold is the minimum practical starting point for a new task chain.

It is designed to make sure a chain begins with:
- a clear goal
- a pass condition
- a human-readable log
- a report file
- expected outputs
- artifacts
- optional round-specific workspace

## Directory Layout

```text
templates/task-chain-template/
  README.md
  CHAIN_LOG.md
  REPORT.md
  expected/
  artifacts/
  rounds/
```

## Why These Files Exist

### `README.md`
Explains what the chain is.

### `CHAIN_LOG.md`
Holds writebacks, validations, and round transitions.

### `REPORT.md`
Summarizes the final outcome after execution.

### `expected/`
Stores the intended outputs or baselines used for validation.

### `artifacts/`
Stores the evidence produced during execution.

### `rounds/`
Stores round-specific files when recovery or branching gets messy.

## Recommended Workflow
1. Copy the scaffold into a new project directory.
2. Fill in `README.md` with goal, type, and pass condition.
3. Replace the initial placeholder records in `CHAIN_LOG.md`.
4. Add expected outputs to `expected/`.
5. Run the chain.
6. Save evidence into `artifacts/`.
7. Write the final `REPORT.md`.

## Minimum Standard
A chain created from this scaffold should not claim success unless:
- at least one validation has a final verdict
- the pass condition is explicitly met
- the report reflects what actually happened

## Automation
Use `scripts/new-task-chain.sh <name>` to create a new chain instance from this scaffold.
