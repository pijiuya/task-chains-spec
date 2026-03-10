# Task Chain Audit Log Schema

## Purpose
Define the minimum records needed for a task chain to be meaningfully reviewable.

## Event Types

### 1. `ROUND_TRANSITION`
Records the end of one round and the start of another.

Required fields:
- `round`
- `reason`
- `strategy`
- `status`

Example:
```md
## ROUND TRANSITION 2 — remediation start
- round: 2
- reason: initial file comparison failed due to leading blank line
- strategy: open saved file, select all, overwrite exact content, save, reopen, compare again
- status: started
```

### 2. `WRITEBACK`
Records a fact learned, artifact produced, or execution state that should not be lost.

Required fields:
- `what`
- `why_it_matters`

Optional fields:
- `artifact`
- `observed_value`
- `next_step`

Example:
```md
## WRITEBACK 3 — branch decision recorded
- what: OCR recognized `ROUTE B`; selected branch B
- why_it_matters: branch choice determines the next execution path
- next_step: execute branch-B action in TextEdit
```

### 3. `VALIDATION`
Records whether a concrete result matched expectation.

Required fields:
- `target`
- `expected`
- `actual`
- `verdict`

Optional fields:
- `artifact`
- `root_cause`
- `follow_up`

Example:
```md
## VALIDATION 5 — content comparison
- target: artifacts/round2/ocr-transfer.txt
- expected: exact normalized text match
- actual: leading blank line present
- verdict: fail
- root_cause: TextEdit creation flow introduced leading blank line
- follow_up: start remediation round
```

## Minimum Logging Standard
For a chain to be called **auditable**, it should record:
- at least one `WRITEBACK` per meaningful round
- every decisive `VALIDATION`
- every `ROUND_TRANSITION`

## Strong Recommendation
Store logs in a single human-readable file such as `CHAIN_LOG.md`, even if a machine-readable JSONL version is added later.
Human inspection should remain easy.
