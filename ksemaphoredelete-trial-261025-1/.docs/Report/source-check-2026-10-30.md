# 当前删除实现的源码一致性复核

2026-10-30，独立 C analysis agent 对 `KSemaphoreDelete-pred-r7` / `KSemaphoreDelete-spec-r9`
所用切片进行定向复核。结论：当前 3 个实现目标的源码、配置、路径及 ABI 一致性检查通过；
原有适配依据仍有效。本报告不作 predicate/spec 语义审阅，也没有运行 QCP 或证明函数体。

依据为当前 `/home/xinra/TrustBase.md`、技能的《源代码处理》、
[原 C 分析](c-analysis.md)和[候选切片检查](candidate-source-check.md)。
新检查证据保存在 [source-check.json](../../checks/review-261030/source-check.json)，没有覆盖历史证据。

## 输入和布局

历史 `checks/c-analysis/source-sha256.json` 的 31 个源码、头文件、配置、架构依据及 TrustBase
输入哈希全部未变。配置仍为 non-SMP、32 位、RR_REMAINSLICE、32 个优先级、128 个 ID、16 个
ID 桶；事件位域按 TrustBase 展开为两个 uint32。配置快照、三份 ABI 断言源码、适配类型头和
当前 `slice_types.h` 均与既有 ABI 证据一致。

本次重新执行原始头、位域适配头及切片头三组 GCC `-m32` ABI static assertions，全部退出码为 0。
Semaphore 大小为 32，id/value/pend_list/link 偏移为 0/12/16/24；适配 TaskDescriptor 大小为 120，
嵌套 sched_link/exstatus/id/Done 偏移为 16/92/104/116。检查的是已选 ILP32 数据布局，
不能据此声称原生 K210 LP64D/SMP 配置或 RISC-V 汇编已验证。

适配记录中仅主 `SKILL.md` 的历史哈希不同；已按当前技能核对本轮的三目标与外部契约边界规则，
实际《源代码处理》文件哈希未变，不影响上述源码适配结论。

## 三个目标的路径及直接调用

- `KSemaphoreDelete`：原源码 semaphore.c:258 的 `KDEBUG_NOT_IN_INTERRUPT` 在该文件已定义为空；
  静态 done 表的删除项唯一绑定 `_SemaphoreDelete`，切片的直接调用保持该行为。
- `_SemaphoreDelete`：保留负 ID 立即返回、非负 int32 向 IdGetObj 的 uint16 形参转换、未命中解锁返回、
  有/无等待者分支。成功路径顺序仍为批量唤醒、注销 ID、摘管理链、解锁、free；仅原等待链非空时调度。
  value 未被写入。CONTAINER_OF 按具体 Semaphore.id 适配；DO_KTASK_ASSIGN 按既定模型替换为
  KTASK_ASSIGN，并不构成原调度器实现证明。
- `LinklistResumeAll`：保留 NULL_PARAM_CHECK 去打印后的无限循环；删除内层 lock/unlock 的依据是
  本轮唯一目标调用点位于 `_SemaphoreDelete` 外层临界区。每轮重新读 `list->node_next`，由真实嵌套
  `task_dync_sched_member.sched_link` 找到任务，先写 `exstatus = -ERROR`，再调用 KTaskWakeup；
  空链退出，返回 EOK。没有把遍历改成缓存 next 或跳过写入。

重新扫描当前 3 个 active body 的直接调用，所得清单与既有范围一致，见机器证据的 `target_calls`。
KTaskWakeup、IdGetObj、IdRemoveObj、IsDoubleLinkListEmpty、DoubleLinkListRmNode 是直接使用的
外部契约；其内部调用按已确认边界停止。本轮仍只证明这 3 个目标，20 个导入函数不增加为实现目标。
CriticalAreaLock/UnLock、x_free、KTASK_ASSIGN 和 typed container 保持既定模型/信任边界。

3 个目标均通过 GCC `-m32 -std=c11 -ffreestanding -fsyntax-only -Wall`；ResumeAll 保留的 lock
变量有未使用警告，无错误。23 个留存切片的可执行 token 哈希均与 2026-10-29 同步证据相同，
因此源码图的其余函数无需重复人工逐体分析。契约文本更新仍须由本轮 spec reviewer 审查，
本检查不能以 C 编译或 token 一致替代其语义审阅。
