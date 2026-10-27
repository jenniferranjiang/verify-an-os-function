# KSemaphoreDelete 当前状态

2026-10-27：当前为 `KSemaphoreDelete-spec-r6` / `KSemaphoreDelete-pred-r4`（定向设计审阅通过）。LinklistResumeAll 同时保留 semaphore_waiters 封装版和 semaphore_waiters_expanded 展开版，语义一致；新纯谓词 tasks_ready_with_exstatus 已同步共享库，编译、类型和双规格一致性检查通过。

按用户要求，旧 implement 阶段新增的 QCP/Rocq 工作区、运行记录、证明产物及实现检查报告已移出 trial。当前源码、predicate/spec、修订快照和设计检查保留；当前 revision 尚未进行实现验证。
当前修改及检查见 [规格设计](spec-design.md)、[定向审阅](spec-review.md) 和 `checks/spec-revision.json`。

## 完成范围与修复

采用当前非 SMP、32 位验证配置，先按《源代码处理》适配，再检查 23 个真实 active body 及 8 个模型/信任边界。覆盖负 ID、非负 ID 的 uint16 转换与未命中、lazy 空桶初始化、有/无等待者、逐项写 exstatus=-ERROR 和唤醒、ID 注销、摘链、锁外释放，以及条件调度模型。源码与 ABI 依据见 [C 分析](c-analysis.md)、[适配清单](adapted-closure.md)及[切片检查](candidate-source-check.md)。

独立审阅完成两次修复闭环：P1 将信号量等待节点改为真实嵌套 `task_dync_sched_member.sched_link`；S1 恢复四类 typed container 接口，使通用查询不用额外加强 Require。另保留原 RUNNING 条件并补充有生命周期依据的 SUSPEND bitmap 一致性；纠正 `IdRemoveObj/current_node` 对完整删除出口的描述，保持内部 `RemoveObj` 摘链后仍持旧 ID 与完整删除最终写入 65535 的区别。旧错误规格的证明结论不能直接沿用。

## 共享合并与检查

正式函数定义见 [KSemaphoreDelete.v](../../../lib/KSemaphoreDelete.v)，完整设计见 [predicate-design.md](predicate-design.md) 和 [spec-design.md](spec-design.md)。目标规格见[当前 trial canonical](../../annotated_C/src/KSemaphoreDelete.c)，全局新增规格见[共享 canonical](../../../annotated_C/src/KSemaphoreDelete.c)。

合并使用复制基线、trial 修订与全局最新版本核对，没有覆盖期间的其他工作。新增/修改库、复用规格的增量及所需类型头均已进入根目录；已有多函数 C 的可执行 token 保持。根 `_CoqProject`、Makefile 和共享索引已更新。Trial 的活动引用使用 `CRTOS_Verify.lib`，留存的 trial/lib 审阅副本不再配置到构建路径。

- 根项目重新编译 8 个库：TaskInv、SemaphoreInv、CrtosInv、KTaskUnSetDelay、KTaskWakeup、SemaphoreOps、KSemaphoreDelete，以及受影响的 KSemaphoreCreate，全部 exit_code=0。见 [root build](../../checks/root-library-build.log)。
- 迁移后 137 项 formal 名称/类型/投影检查通过；23 个 C 切片的语法、唯一 active body、保留调用范围及 caller/canonical contract 一致性检查通过。
- 原始头、位域适配头和切片头的 ILP32 ABI 检查通过；31 个权威源码、配置和 TrustBase 输入哈希未变。
- [合并结果](../../checks/merge-result.json)和[迁移检查](../../checks/migration-check.json)记录文件对应及检查结果；全局新增库不依赖 trial 路径。

## 结论限制与下一步

设计阶段的检查不等于 C 实现已证明。后续实现验证须基于当前 revision 重新配置工作区并启动正式 workflow。资源转换、循环保持、全局不变量重建及新增不变量的上游保持义务仍须在实现证明中完成。`KTASK_ASSIGN` 使用文档规定的抽象模型，当前设计范围为非 SMP、32 位验证配置。

清理备份及文件清单：`/tmp/ksemaphoredelete-trial-261025-1-implement-backup-tyoe5rhw`。`_CoqProject` 已恢复共享依赖路径，并移除被清理的本地证明目录映射。
