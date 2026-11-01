# 本 trial 的实现证明范围

2026-10-29，适用于 `KSemaphoreDelete-spec-r9` / `KSemaphoreDelete-pred-r7`。
按用户确认，采用外部契约下的模块化证明：本次证明 3 个函数，20 个导入函数
作为外部契约依赖，另有 8 个既定模型/信任边界。

2026-10-30 实现阶段按既有源码处理规则启用 `NULL_PARAM_CHECK_1`，有效模型/API 边界增为 9 个；
三个实现目标和 20 个导入契约不变。该调用仅替换 recorded parser input 中的精确 NULL 检查，
正常返回保证指针非空，不承诺 NULL 分支终止。见 [适配复核](implementation-adaptations-review.md)。

## 本次需要证明的 3 个函数

| 函数 | 本次负责的行为 |
| --- | --- |
| `KSemaphoreDelete` | 公开删除入口、参数分支及抽象操作衔接 |
| `_SemaphoreDelete` | 查询、唤醒等待者、注销和摘链、解锁后释放、条件调度 |
| `LinklistResumeAll` | 逐项设置 exstatus 并调用 Wakeup，证明批量效果与循环保持 |

对应文件均为 `annotated_C/src/<函数名>.c`。这里的“新写”指本 trial 新设计或调整
的规格与证明；C 算法来自 CRTOS 源码，不是重新编写的实现。
当前 revision 的这 3 个实现尚未证明。

## 导入契约，本次不重复证明实现的 20 个函数

| 类别 | 函数 |
| --- | --- |
| ID 管理 | `IdGetObj`、`GetObj`、`IdRemoveObj`、`FreeId`、`RemoveObj` |
| 任务查询与唤醒 | `GetTaskWithIdnodeInfo`、`KTaskWakeup`、`_KTaskWakeup` |
| 延时取消 | `KTaskUnSetDelay` |
| 就绪插入 | `KTaskInsertToReadyVector`、`AssignPolicyInsert`、`RoundRobinRemainReadyVectorInsert` |
| 任务状态 | `KTaskStateSet`、`KTaskStatSetAsReady`、`JudgeKTaskStatIsSuspend` |
| 双向链表 | `InitDoubleLinkList`、`DoubleLinkListInsertNodeBefore`、`DoubleLinkListInsertNodeAfter`、`DoubleLinkListRmNode`、`IsDoubleLinkListEmpty` |

原导入契约来源为 VRTOS `bc601a1`；本轮 KTaskWakeup 更新到 `162a5e7`，
LinklistResumeAll 使用新增的 `semaphore_pending_head_ic`。其他导入契约经检查与当前上游一致。
逐函数的来源文件见 [`checks/verification-scope.json`](../../checks/verification-scope.json)。
导入文本的一致性证据见 [`interface-checks.json`](../../checks/vrtos-sync-261029/interface-checks.json)。

保留这些函数的 C 切片是为了源码追溯和调用分析，不表示必须把它们加入本次实现证明。
证明递归在外部契约处停止；结果以这些契约成立为条件，不能把同步、编译或类型检查
宣称为这些实现已在本地模型下证明。

## 既定模型/信任边界

- `CriticalAreaLock`、`CriticalAreaUnLock`：既有临界区 API 契约。
- `x_free`：既有 `KERNEL_FREE` 对应的内存释放契约。
- `KTASK_ASSIGN`：源代码处理约定的调度模型。
- `CONTAINER_OF_IDNODE_LINK`、`CONTAINER_OF_SEMAPHORE_ID`、
  `CONTAINER_OF_TASK_ID`、`CONTAINER_OF_TASK_SCHED`：既有 typed container 适配契约。

- `NULL_PARAM_CHECK_1`（2026-10-30 启用）：按源码处理指南替代精确的 NULL 检查宏；`Require emp / Ensure p != 0` 是正常返回契约，不承诺 NULL 路径终止。

这 9 项不进入本次实现证明。

## 本次仍需完成的局部义务

使用外部函数时，调用者必须建立其前置条件，并正确衔接后置资源。
本地 LittleEndian、信号量序列表示及资源拆装所需的转换引理仍需证明，不能由上游
契约文本一致性替代。循环不变式、使用到的 `semaphore_resume_all_effect` 与逐步关系
连接，以及 `SemaphoreRetired` 到 `SemaphoreRaw` 的转换，也属于目标证明的辅助义务。

[`spec-closure.json`](../../checks/spec-closure.json) 保存的是 23 个真实函数体的源码调用图；
本文件和 `verification-scope.json` 才规定本次的实现证明目标。
