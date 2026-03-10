# Complex UI Task Chain Report — 2026-03-10

## Goal
Run a more complex, auditable task chain that includes:
- screenshot reading
- cross-app transfer
- TextEdit write/save/reopen
- explicit per-round writebacks
- explicit per-round validations
- explicit round transitions

## Chain Summary
### Round 1
- Intended task: OCR a Preview window and transfer its text
- Result: **FAIL**
- Cause: window-title ambiguity (`source.png` matched the wrong existing Preview window)
- Why it matters: this is a real coordination failure, not a synthetic one

### Round 2
- Improvements:
  - unique window title (`chain-round2-source.png`)
  - Preview relaunched to reduce ambiguity
  - OCR-friendly source layout
- OCR result: correct
- Cross-app transfer to TextEdit: completed
- Save/reopen: completed
- Final comparison: **FAIL** due to leading blank line in saved file
- Why it matters: GUI chains often fail at exactness, not just major actions

### Round 3
- Remediation strategy:
  - open saved file
  - select all
  - overwrite content with OCR result
  - save
  - reopen
  - compare again
- Final comparison: **PASS**

## Final Verdict
**PASS after iterative recovery**

This chain demonstrates that the system can do more than a single-shot success path. It can:
- detect the wrong target
- record the failure instead of hiding it
- start a new round with a different strategy
- perform repair on an already-produced artifact
- reach a validated pass state

## Auditable Log
See `CHAIN_LOG.md` for the exact sequence of:
- round starts
- writebacks
- validations
- next-round transitions

## Key Artifacts
- `artifacts/round1/screenshot.png`
- `artifacts/round2/screenshot.png`
- `artifacts/round2/textedit-filled.png`
- `artifacts/round2/textedit-reopened.png`
- `artifacts/round3/textedit-overwrite.png`
- `artifacts/round3/textedit-reopened.png`
- `artifacts/round2/ocr-transfer.txt`

## Bottom Line
This is no longer just "can it click things?".
It can run a multi-step chain, fail honestly, write back state, branch into a recovery round, and converge to a verified result.
