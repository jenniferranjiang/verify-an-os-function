# KMutexDelete 全新实验：源码问题门禁

日期：2026-11-09。实验目录：`kmutexdelete-trial-261109-1`。

本次以当前非 SMP CRTOS 权威源码为准，只进行设计前的源码与配置审查。
目标为设计并审阅 KMutexDelete 的 predicate 与完整调用闭包 spec；
`LinklistResumeAll` 的 spec 必须重新生成，不沿用历史实验合同。当前正在修改
predicate/spec 草案；未启动 verification-orchestrator、symbolic、VC 或 C 实现证明。

## 固定源码

- `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c`
  SHA-256 `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645`。
- `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c`
  SHA-256 `d64d3275b6d936f46352bc4625fc11efc9e0b113ca838f60a98eabaa09a7342c`。
- 信任边界：只采用 `/home/xinra/TrustBase.md` 当前列明内容；其中没有 mutex
  删除期间的对象保活、排他删除或禁止新 waiter 的假设。

## 源码问题（本 trial 已由下述 A1--A3 排除触发场景）

### 查找后对象可能在使用前被释放

`KMutexDelete` 在 `mutex.c` 的 ID 查询临界区内取得 `struct Mutex *`，随后解锁，
再调用 `_MutexDelete`。非 SMP 的解锁会恢复中断；tick 抢占后，另一任务可以完成
同一 ID 的删除和 `x_free`。原任务恢复后会把已经释放的地址传给 `_MutexDelete`，
其等待链读取已构成 use-after-free，并可能继续造成重复注销、链表破坏或重复释放。

### 排空后可重新加入 waiter

`_MutexDelete` 先调用锁外 `LinklistResumeAll`。该函数内部解锁返回后，
`_MutexDelete` 才再次加锁并注销 ID。在这个窗口，另一任务仍能通过 ID 找到对象，
并经 `KMutexObtain` 把新的 waiter 加入 mutex 等待链。删除任务随后注销、摘链并释放
对象，但新 waiter 的调度节点仍指向已释放的等待链哨兵。

### 已取得的 obtain/abandon 裸指针也可能跨过删除

`KMutexObtain` 和 `KMutexAbandon` 同样在 ID 查询命中后先解锁，再把裸指针
传给内部 helper。某任务可先取得指针并在 helper 调用前被抢占，另一任务随后删除并
释放对象，前一任务恢复后继续解引用。因此只排除“并发第二次 delete”和“排空后新
waiter”还不覆盖所有 in-flight 引用；条件化实验还必须排除已经取得或新取得的裸指针
跨本次删除继续调用 obtain/abandon/delete。

`KDEBUG_NOT_IN_INTERRUPT` 只排除中断上下文调用，不提供跨解锁窗口的对象保活或
排他保证。公开头文件和函数注释也没有给出上述调用者义务。

## 对设计流程的影响

按照 `verify-an-os-function` 的源码问题门禁，上述问题在修复或由用户明确批准精确
环境假设之前，不能开始编写或审阅 predicate/spec，也不能给出 `review-ready` 或
`review-passed`。历史实验曾使用的 A1/A2 批准仅属于旧实验，不能自动扩展到本次
全新实验。

若选择条件化实验，需要用户明确批准以下范围：

- A1：从本次 ID 查找命中到本次对象注销，同一分配对象不被其他执行方删除、回收
  或复用；同地址释放后再分配不算同一对象。
- A2：从本次 `LinklistResumeAll` 排空完成到本次对象注销，不向该对象等待链加入
  新 waiter。
- A3：本次删除期间，没有已经取得或新取得的该对象裸指针跨删除继续调用
  obtain、abandon 或 delete。

若选择修复源码，建议把查找、排空、ID 注销和管理链摘除保持在同一个外层临界区，
离开临界区后再释放已经撤销发布的对象。该改动需要用户另行授权；当前没有修改权威
源码。

## 当前全局 formal 状态

当前根 `lib/common/CrtosGlobState.v` 与 `CrtosInv.v` 已移除 task、assign 和 delay
状态，根 `lib/task/KTaskWakeup.v` 不存在；现有 mutex `LinklistResumeAll.c` 仍引用
这些缺失接口。因此它不能作为本次新 spec 的来源。门禁解除后，本 trial 必须重新
设计等待链与 task/ready/delay 状态的最小组合接口，重新生成并独立审阅
`LinklistResumeAll` contract，再完成 KMutexDelete 的闭包审阅。

当前闭包中的 `IdGetObj`、`IdRemoveObj` 和 `DoubleLinkListRmNode` 有可复核的
canonical reused-spec；`KTaskWakeup` 使用历史完整全局 provider 的导入接口，
来源及兼容适配见 `../lib/TASK_MODEL.md` 和当前设计报告。
权威头文件 `Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_memory.h:53`
直接定义 `KERNEL_FREE(ptr)` 为 `x_free(ptr)`。本 trial 因而使用 TrustBase 已批准
allocator API 的同一展开符号，不新增另一释放函数的信任授权。对象内存到该 API
输入资源的重组仍须由 predicate 描述，宏对应本身不提供内存权限。

## 用户决定（2026-11-10）

用户明确确认本实验默认不发生上述三类交错：对象不会被另一删除释放，不会在
排空后到注销前加入新 waiter，也不会有 obtain/abandon/delete 的裸指针跨本次
删除继续使用。该确认批准本 trial 按 A1--A3 进行条件化设计；它不修改
`TrustBase.md`，不表示权威源码缺陷已经修复，也不适用于其他实验。

当前状态：`source-gate-resolved-by-A1-A3`；可以恢复 predicate/spec 设计与审阅。

## Critical 模型方向更正（2026-11-10）

对话中曾短暂把用户的“批准”理解为允许新增 trial-scoped expanded
`CriticalAreaLock/Unlock` trusted contract。用户随后明确否定这种架构：本轮应复用
已有完整 task/assign/delay critical provider，在其上增量设计 Mutex 模块，不能
重新定义或加强 Lock/Unlock。此前 expanded-contract 解释因此撤回，不构成本 trial
的有效信任批准。

后续正式文件采用模块命名 `MutexState.v`、`MutexInv.v`，函数级抽象放在
`KMutexDelete.v`；旧 `MutexDeleteState/Rep/Rules` 候选须迁移或删除，并重新审阅。
