# 唤醒正常返回的非零保证

`LinklistResumeAll_entail_wit_5` 的实际证明发现当前模块化契约不足：挂起任务的全局表示及 `KTaskWakeup/wakeup_unified` 的原返回资源允许任务基址为 0，而恢复 READY 全局不变量需要基址非零。

证据在 [group notes](../../reports/LinklistResumeAll-20261026014440/rounds/LinklistResumeAll-vc-proving-r1/groups/group_00__wakeup_resources/group_worker_output.md)。6 个诊断引理通过 controller development 编译；它们验证零任务插入、局部注册与地址有效性等片段。完整堆/STS 反例是逐定义的空间布局分析，未冒称整条 Coq 可满足性定理。这是现有模块化保证不足，不据此宣称实际 C 错误。

修复采取追加并实际证明正常返回保证的方式，不加强调用前提、不修改共享 predicate、不改原复用接口：

- 新契约名：`wakeup_unified_nonnull`；With/Require 与原 `wakeup_unified` 逐字相同。
- Ensure 为 `target != 0 &&` 原 Ensure。
- 真实 `ktask.c` 的 Getter 之后执行 NULL_PARAM_CHECK；当前配置的 NULL 分支永不正常返回。Getter 的既有 inside_known 契约保证返回值等于 target，因此正常返回时 target 非零。
- 这不承诺终止，也不把新保证作为 trusted assumption；新契约必须独立完成函数体证明，循环恢复 frame 才能据其恢复稳定状态。

具体[契约提案](../../checks/proposals/KTaskWakeup-wakeup_unified_nonnull.spec.c)、[差异](../../checks/proposals/KTaskWakeup-wakeup_unified_nonnull.diff)和[独立增量审阅](../../checks/proposals/KTaskWakeup-normal-return-review.json)已保存。增量 `KTaskWakeup-normal-return-v1` 为 review-passed，SHA-256 为 `f5eecbe205d0b0047187976da7098fe3d9d7031a973bad6d3f2715ff392b87f0`。这是在用户既有全部人工 review 与 implement 授权内追加的、需要证明的契约，未替换冻结的 r2 接口。

新增 controller run `KTaskWakeupNonNull-20261026135754` 验证同一适配函数体的这一新增契约；原复用规格仍保留。当前尚未证明完成。后续 caller-local 新接口必须与这份 canonical 保持一致，且整体结论必须包含这项新增证明义务。
