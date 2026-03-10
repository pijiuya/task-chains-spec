# Demo Report — 2026-03-10

## Verdict
**PASS** — the workflow system completed the task.

## Task
Create a TextEdit document, save it, close it, reopen it, and prove the content persisted.

## Evidence
### Files
- expected text: `tasks/projects/textedit-workflow-demo/expected.txt`
- saved file: `tasks/projects/textedit-workflow-demo/artifacts/red-textedit-demo.txt`

### Screenshots
- filled draft: `tasks/projects/textedit-workflow-demo/artifacts/textedit-filled.png`
- corrected content: `tasks/projects/textedit-workflow-demo/artifacts/textedit-corrected.png`
- reopened proof: `tasks/projects/textedit-workflow-demo/artifacts/textedit-reopened-corrected.png`

## What happened
1. TextEdit was focused successfully.
2. A document was created and content was pasted in.
3. The first save succeeded, but the text contained literal `\\n` escapes.
4. The workflow detected the problem by reading the saved file.
5. The content was corrected inside TextEdit.
6. The document was saved again.
7. After reopening, the visible text and on-disk file matched the expected content.
8. Final `cmp` check passed.

## Why this matters
This demo proves the system can:
- perform GUI actions
- verify its own output
- detect its own mistakes
- recover and retry
- finish with an objective file-level pass condition

## Final verification checks
- Screenshot verification: PASS
- File existence: PASS
- File content equality (`cmp`): PASS

## Notes
A strong workflow is not one that never makes mistakes; it is one that can catch and correct them. This demo passed on that standard.
