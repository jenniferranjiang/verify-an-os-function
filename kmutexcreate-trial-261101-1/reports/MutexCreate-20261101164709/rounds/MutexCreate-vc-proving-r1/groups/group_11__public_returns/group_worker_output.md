# public_returns 完成说明

本组三个 assigned proof spans 均已完成；statement、declaration order、prelude、未分配 proof tokens 和库 seed 未修改。没有新增 helper、import 或假设。

- `proof_of__MutexCreate_return_wit_1` 使用指定 LLM route，选择 publish 后的 `replace_mutexes` 状态，消去相同 `OutsideCritical` 资源，并使用既有 ID bounds 和 ret continuation 前提。
- `proof_of__MutexCreate_return_wit_3_split_goal_1` 使用指定 LLM route，展开 `abs_mutex_create`，经 `prog_nf` 与 `safe_choice_l` 直接取得 malloc 失败 `ret (-5)` 分支，保留同一 `LastSeen`。
- `proof_of__MutexCreate_return_wit_3` 使用 aggressive route，仅以 `Goal_apply` 调用本组 split lemma。

实际 Rocq MCP 交互分别完成上述三个 Qed；所有 tactic 均写回本组 copied manual。禁用 lemma/tactic 扫描无命中。

Handoff 指定的 group-development 检查退出 0 且 JSON status passed。最终 group-check 实际编译本组 lib、goal、auto、manual 与 `VC/MutexCreate_group_11_public_returns_check.v`，退出 0，JSON status passed（elapsed_seconds 16.978572）。

已停止写入，等待 main finalize-delivery。
