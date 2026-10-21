# Implement

用户确认 predicate/spec revisions 后，main agent 完整读取
`/home/xinra/qcp-binary-democases/AGENTS.md`，从它指定的
`verification-orchestrator` 入口启动 QCP workflow，并把批准的 predicate/spec 当作冻结输入。
之后只执行 controller 返回的 action，直到 controller 报告 `done` 或明确 blocker；不要在本 skill
中复制 QCP 的阶段、命令、返回状态或 final-check。
