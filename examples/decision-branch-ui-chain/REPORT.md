# Decision Branch UI Chain Report — 2026-03-10

## Proposed Name
Preferred term: **闭环决策链**

Other acceptable names:
- 分支任务链
- 决策任务链
- 可恢复任务链
- agentic workflow（偏系统术语）

## What This Demo Tested
A screenshot-driven branch selection workflow:
1. read screenshot text
2. infer branch A or B
3. execute the chosen branch in TextEdit
4. save and reopen
5. compare final artifact
6. if needed, remediate and verify again

## Result
**PASS after remediation**

## Why It Matters
This is closer to a real agent loop than a single linear automation.
The system had to:
- use screenshot understanding to choose a branch
- commit to a path
- produce an artifact representing that path
- validate whether the chosen path actually persisted
- repair the artifact when exactness failed

## Can This Be Run By a Subagent?
### Good fit for subagents
- planning the rounds
- deciding branch logic
- writing logs and reports
- comparing expected vs actual outputs
- deciding whether another round is needed

### Better kept in the main session
- live macOS GUI control
- focus-sensitive app/window actions
- timing-sensitive Peekaboo operations
- desktop permissions and immediate state handling

### Recommended architecture
- **Subagent = brain / planner / validator / recorder**
- **Main session = hands / local GUI executor**

That split is the most robust for now.
