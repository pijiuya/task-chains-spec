# Screenshot Read Demo — 2026-03-10

## Goal
Isolate and test the screenshot-reading layer by comparing recognized text against a known ground-truth image.

## Method
1. Generate a local image containing known text
2. Open it in Preview
3. Capture a screenshot of the live window
4. Ask the image model to read the screenshot text exactly
5. Compare the OCR output to the source text

## Round 1
Source text:
```text
SCREENSHOT READ TEST
token: RED-SCREENSHOT-READ-02
time: 2026-03-10 18:03 GMT+8
status: if OCR gets this exactly, screenshot reading works.
```

Observed OCR result:
```text
SCREENSHOT READ TEST
token: RED-SCREENSHOT-READ-02
time: 2026-03-10 18:03 GMT+8
status: if OCR gets this exactly, screenshot reading
```

Result: **near miss**
- Final word `works.` was truncated
- This confirms the test is strict enough to expose OCR edge failures

## Round 2
Source text:
```text
SCREENSHOT READ TEST V2
TOKEN RED-SCREENSHOT-READ-03
TIME 2026-03-10 18:03 GMT+8
OCR SHOULD READ THIS EXACTLY
```

Observed OCR result:
```text
SCREENSHOT READ TEST V2
TOKEN RED-SCREENSHOT-READ-03
TIME 2026-03-10 18:03 GMT+8
OCR SHOULD READ THIS EXACTLY
```

Result: **PASS**
- OCR matched exactly

## Conclusion
The screenshot-reading layer works, but accuracy depends on presentation quality.

### What Helps
- higher contrast
- larger font
- shorter lines
- simpler punctuation
- more whitespace

### What This Means
This system can read screenshots reliably enough for controlled UI verification, but it should not silently assume perfect OCR on dense or edge-clipped text. Verification should stay strict.
