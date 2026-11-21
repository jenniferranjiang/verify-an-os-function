# Outcome

发现确定的 annotation-gap；当前 VC 不可交给 proving。Canonical 文件未修改，未运行证明或新增假设。

## Structural Blocker Scan

先检查无 split 的 `proof_of__SemaphoreCreate_entail_wit_3` 与 `proof_of__SemaphoreCreate_return_wit_1`：前者当前 pointer/scalar 与资源位置一致；后者存在明确发布后状态候选，未发现直接结构反例。继续扫描全部 top-level 时，`proof_of__SemaphoreCreate_entail_wit_1` 出现确定缺口。

其两个顶层析取分支均全称量化 `val_pre : Z`，前提只有 malloc 地址、长度及对齐事实，空间前提为 `CharArray.full retval 32 (repeat_Z 0 32) ** os_inv sg before`。前提完全不涉及 `val_pre`，结论却都要求 `0 <= val_pre <= 65535`。取任何满足这两项空间资源的合法 OS/malloc heap，保持其他参数不变，取 `val_pre = -1` 即使两支所要求的下界都为假；取 `65536` 同样破坏上界。函数 C 参数的 ushort 类型信息在该 which-implies 边界已从生成命题丢失，不能作为 Rocq 隐含前提使用。

这不只是 split 失败：整个 top-level 的两个析取分支均无此前提，故不能通过选择 LLM 模式修复。关联 split 为 `_split_goal_6`（上界）和 `_split_goal_7`（下界）。

## Annotation Comparison Review

handoff comparison 列表为空，没有已声称修复的历史 VC 需要复核。本次为当前生成 VC 的直接检查。

## Proof-Mode Decisions

结构扫描已有确定 countermodel，按 workflow 提前返回；未继续 split-first 全量分析，不写成功 group plan。

## Common Proof Patterns / VC Deltas / Grouping Decisions

不适用：当前轮被 annotation 缺口阻塞。

## Risks or Blockers

修复位置：malloc/memset 后将 `CharArray.full ** os_inv` 转换为 semaphore 字段和 OS frame 的 which-implies。应把 C 参数现有 `val`/`val_pre` 的 UShort ownership 或显式已经导出的范围事实保留在该注解前提，使生成 VC 含真实范围来源。不要加强冻结函数 Require，不要直接假设范围，不要修改 generated goal。修复后重新 symexec 并复查这个 top-level 及相关 split。
