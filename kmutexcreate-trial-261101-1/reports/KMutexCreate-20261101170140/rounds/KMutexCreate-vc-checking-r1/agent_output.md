# Outcome

当前 4 个 top-level VC 均可证；plan 精确覆盖全部 4 个。此次仅分析和分组，不宣称 Rocq 证明已经完成。

## Structural Blocker Scan

依次扫描 `return_wit_1`、`return_wit_2`、`partial_solve_wit_1_pure`、`partial_solve_wit_1`。全部为 no-split whole goals。两项 return 的空间资源均为 `OutsideCritical sg after_3`，目标存在量词可直接取 `after_3`；返回值约束与相同状态/continuation 的 safeExec 都已有 premise。调用前提目标使用同一个 `before_outside_critical` 和 `sg_outside_critical`。未发现缺失的地址、current/@pre 等式桥、scalar equality 或 existential witness；没有反例。

## Annotation Comparison Review

handoff 的 annotation comparisons 为空。独立检查发现两项 return 的 pure facts 来自被调用 `_MutexCreate` 的相应返回分支；调用目标的 safeExec 直接来自当前函数 Require 对应的 PreH1。没有新增断言需要另一条 VC 建立。此次分析将四项均视为尚待证明的 manual 义务。

## Proof-Mode Decisions

先完成 split 枚举：上述四个 top-level VC 的 split 列表均为空，所以不存在待判断的 split goal。随后按 manual 顺序分析全部 whole goals：

- `proof_of_KMutexCreate_return_wit_1`：可证，`LLM_pre_process`。
- `proof_of_KMutexCreate_return_wit_2`：可证，`LLM_pre_process`。
- `proof_of_KMutexCreate_partial_solve_wit_1_pure`：可证，`LLM_pre_process`。
- `proof_of_KMutexCreate_partial_solve_wit_1`：可证，`LLM_pre_process`。

全部 mode 确定后才制定下述策略和分组。goal 文件已明确展开各定义的 P/Q，无需调试副本或 coq-debug。

## Common Proof Patterns

P1（return）：展开 witness 定义并引入变量/前提，右侧 existential 取 antecedent 资源中的 `after_3`；由当前 premise 引入各 pure conjunct，保留相同 `OutsideCritical`，用资源反身性关闭。safeExec 和 OutsideCritical 保持不透明；source/target state 和 continuation 完全一致，没有新 transition、list transformation 或 helper。

P2（call premise）：展开 witness 定义，用已有 `PreH1` 引入 RHS 的 safeExec pure fact；若 RHS 包含空间资源，则保留原 `OutsideCritical sg before`。重复 pure fact 不复制空间所有权。无需 existential、额外算术事实或 helper。

## VC Deltas

- `return_wit_1` 用 P1：PreH1 为 retval = -5，PreH2 为返回态 safeExec；较早的 PreH3 无需使用。
- `return_wit_2` 用 P1：PreH1/PreH2 为 0 <= retval < 128，PreH3 为返回态 safeExec；较早的 PreH4 无需使用。
- `partial_solve_wit_1_pure` 用 P2：目标仅为 pure assertion，直接由 PreH1 得出，不要求空间资源匹配或 existential。
- `partial_solve_wit_1` 用 P2：先引入顶层 implication premise，再展开 aux；两个 safeExec pure conjunct 都由 aux 的 PreH1 得出，同时保留原空间资源。该 implication premise 可不使用。

## Grouping Decisions

按程序阶段分为 `wrapper_returns`（两个结果投影）和 `wrapper_call_premises`（两个调用前提），均为 2 个 top-level、0 个 split、0 个 helper，difficulty 1。两组独立，冻结语义保持不变；没有重型数学 lemma 或尾部关键路径。plan 按上述顺序派发。

## Risks or Blockers

无结构 blocker。这里仅完成可证性判断；后续 worker 仍须提交四项真正的 Rocq 证明。调用正确性依赖已有 `_MutexCreate` 契约，不能据此单独宣称内部实现或整个 mutex 模块已证。
