# TextEdit Workflow Demo — 2026-03-10

## Goal
Validate whether the workflow system can complete a real macOS GUI task end-to-end, not just analyze screenshots.

## Task
Use TextEdit to:
1. create a document
2. input exact text
3. save it to a known path
4. close it
5. reopen it
6. verify by screenshot and file-content comparison

## Expected Text
```text
OpenClaw workflow demo
timestamp: 2026-03-10 17:42 GMT+8
token: RED-TEXTEDIT-DEMO-01
result: if you can read this after reopen, the workflow passed
```

## Final Result
**PASS**

The workflow completed the GUI task and produced a byte-for-byte matching file after reopen verification.

## Real Issues Found During Test
- TextEdit auto-added `.txt` to a filename that already ended in `.txt`, producing `.txt.txt`
- Initial paste used literal escaped newlines in one attempt
- One saved version had a leading blank line
- Another version matched content except for missing trailing newline

These were corrected through iterative verification rather than being silently ignored.

## Why This Matters
This test validates that the workflow can:
- target and control a real macOS app
- perform keyboard/paste/save actions
- detect mistakes through evidence
- adapt strategy when a local fix is unstable
- reach a strict pass condition (`cmp` success)

## Final Verified Output
- File: `tasks/projects/textedit-workflow-demo/artifacts/red-textedit-demo-final.txt`
- Verification: `cmp` = PASS

## Artifacts
- `textedit-filled.png`
- `textedit-filled-final.png`
- `textedit-reopened-final.png`
- `textedit-reopened-final-corrected.png`
- `textedit-final-pass.png`
- `textedit-final-pass-2.png`
- `red-textedit-demo-final.txt`
- `expected.txt`
