# 适配后闭包与源码转换登记

依据：用户更新后的 verify-an-os-function/SKILL.md 与《源代码处理》。规则 SHA-256 记录于 `checks/c-analysis/adapted-analysis-sha256.json`。本文件是 C analysis 的范围清单；最终 candidate 需从其 active bodies 再扫描确认。原始源路径及效果沿用 c-analysis.md，不重复分析。

## 已规定适配及逐处作用

| 原位置（均在 kernel/thread，宏头例外） | 适配 | 适用证据与限制 |
|---|---|---|
| semaphore.c:95 的 DO_KTASK_ASSIGN | 替换 KTASK_ASSIGN 模型调用 | non-SMP；源代码处理明确给定 OutsideCritical/safeExec contract。该 macro 内 GetOsAssignLockLevel、DisableLocalInterrupt、KTaskOsAssign、EnableLocalInterrupt 不进入适配后闭包。 |
| semaphore.c:262 done.SemaphoreDelete | 直接 `_SemaphoreDelete` | 同文件 done 初始化234，模块内无后续写入。 |
| ktask.c:1074 task->Done->wake | 直接 `_KTaskWakeup` | ktask.c:822、866/1157；以系统初始化维护的 done table 关联为依据。 |
| ktask.c:508 ready_vector_done->insert | 直接 KTaskInsertToReadyVector | assign.c:30–35、387；non-SMP表。 |
| linklist.c:118、129 | 删除嵌套 CriticalAreaLock/UnLock | 该 canonical 的本轮调用在 _SemaphoreDelete 外层锁74–90内。 |
| ktask.c:73、76、80（GetTaskWithIdnodeInfo） | 删除嵌套锁及两条出口解锁 | 此本轮调用链由 LinklistResumeAll 在删除锁内进入。负ID/未命中返回路径保留。 |
| ktask.c:501、512（_KTaskWakeup） | 删除嵌套 CriticalAreaLock/UnLock | 调用在同一删除锁内；JudgeSuspend 失败路径保留。 |
| delay.c:107、110（KTaskUnSetDelay） | 删除条件分支内嵌套锁 | delay非空/ACTIVE条件及status/link更新保持。 |
| assign.c:210、223（KTaskInsertToReadyVector） | 删除嵌套 IRQ save/restore | 已在外层临界区；源代码处理的锁内嵌套临界区归一，并参照已有 annotated_C/src/kernel/thread/assign_ready_insert.c。stat、ready插入和bitmap更新保持。 |
| semaphore.c:74、77、90 | 保留外层 CriticalAreaLock/UnLock API | 模型接口保留真实失败/成功分支顺序。 |
| semaphore.c:92 x_free | 保留为 KERNEL_FREE 对应 trusted API | xs_memory.h:52–54 精确宏别名。只消费完整私有分配块。 |
| CONTAINER_OF / SYS_DOUBLE_LINKLIST_ENTRY | 按具体类型、字段的 API contract | TrustBase 明列；不能把任意地址视为有效对象。映射 task.sched_link、task.id、sem.id、IdNode.link。 |
| SYS_KDEBUG_LOG、KPrintf、HOOK | 删除调试输出/hook | TrustBase与源代码处理；本配置HOOK为空。检查失败的无限循环不能因删除打印而隐式消失。 |
| NULL_PARAM_CHECK | 允许保留去打印后的检查或文档规定 NULL_PARAM_CHECK_1 | 最终切片选择后必须统一登记。不因非空 caller 前提而虚构有返回成功行为。 |
| xs_ktask.h:111–112 event两位域 | 按TrustBase展开为两个 uint32 | 这改变后续字段offset；明确适配后的 TaskDescriptor size120，而非原始size116；ABI断言已通过。 |
| static/inline helper | 归一为切片外部 C 定义 | 仅链接作用域变换，不改body语义；每个canonical唯一。 |
| id.c调用隐式 uint16 转换 | 保持或显式拆出 cast | 正id仍按mod65536查询；不加强范围排除大id。 |

## 适配后保留真实 active body 的预计闭包

23 个 C symbol：

- KSemaphoreDelete、_SemaphoreDelete。
- IdGetObj、GetObj、IdRemoveObj、FreeId、RemoveObj。
- LinklistResumeAll、KTaskWakeup、GetTaskWithIdnodeInfo、_KTaskWakeup。
- KTaskUnSetDelay、KTaskInsertToReadyVector、KTaskStatSetAsReady、KTaskStateSet、AssignPolicyInsert、RoundRobinRemainReadyVectorInsert、JudgeKTaskStatIsSuspend。
- InitDoubleLinkList、DoubleLinkListInsertNodeBefore、DoubleLinkListInsertNodeAfter、DoubleLinkListRmNode、IsDoubleLinkListEmpty。

直接边使用 c-analysis.md 的原始表并应用以上删除/替换即可。除模型边界外不能再减少调用；若最终切片引入明确允许的检查替代函数，其归类应登记，而非强求它是原始C函数。

## 模型/信任边界

- KTASK_ASSIGN：文档规定的 OutsideCritical 模型，不要求原始调度的 active canonical，也不把模型证明计为硬件调度证明。
- CriticalAreaLock、CriticalAreaUnLock：TrustBase；外层 ordinary/stable contract，保留临界区协议所有权及 rely/guarantee。
- x_free：KERNEL_FREE 宏别名；消费完整合法分配块，不把共享仍可访问对象交给 free。
- 具体 CONTAINER_OF 接口：TrustBase；返回有字段地址关系的所属对象，保留传入资源。
- NULL_PARAM_CHECK_1：仅在最终选择文档允许API代换时登记，caller-local contract 必须一致。

适配后不再存在需要递归的 KTaskOsAssign 或裸 IRQ/上下文切换汇编调用。旧 B1 因用户更新明确流程而解除；不影响原始 C 存在这些调用的事实，也不扩展结论到未建模硬件行为。
