# KMutexDelete 源码独立审查

审查者：`/root/source_review`。日期：2026-11-03。结论：**needs-fix**；下述两条真实执行交错足以阻塞当前源码的 predicate/spec 通过。本记录是源码审查，不是 C 实现证明。

审查以工作区当前 `Ubiquitous/XiZi_IIoT_Macro/` 源码及 `annotated_C/src/include/xsconfig.h` 的非 SMP、32 位适配配置为依据。配置启用 `KERNEL_MUTEX`、`SCHED_POLICY_RR_REMAINSLICE`、100 Hz tick，没有定义 `ARCH_SMP`。`mutex.c` SHA-256 为 `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645`；`linklist.c` 为 `d64d3275b6d936f46352bc4625fc11efc9e0b113ca838f60a98eabaa09a7342c`；配置为 `e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28`。这些结论针对读到的文件内容，不依赖旧编译产物。

## 为什么非 SMP 仍存在交错

`kernel/thread/CriticalArea.c:117–137` 的非 SMP 分支在 Lock 时关闭中断并增加 `KTaskOsAssignLockNest`，在 Unlock 时减计数并恢复中断。进入 API 时若原本可抢占，解锁后计数回到 0、中断重新开放。`arch/risc-v/k210/interrupt.c:50–61` 保存/恢复 `mstatus`，不是一直禁止中断。

可触发抢占的实际路径是 `arch/risc-v/k210/tick.c:28–33` → `kernel/thread/tick.c:64–81` → `assign_roundrobinremain.c:63–76`。时间片耗尽执行 `DO_KTASK_ASSIGN`，其非 SMP 展开见 `kernel/include/xs_assign.h:122`。`assign.c:47–54` 在 ISR 设置切换标记；`arch/risc-v/k210/boot.S:108–113` 中断尾调用 `KTaskOsAssignAfterIrq`，`assign.c:115–186` 在计数为 0 时允许选择 ready 任务并切换。故以下交错不需要 SMP，也不只是利用 `Crtos_RTrans = True` 的形式模型自由度。

## 反例一：查找到的对象可在使用前被另一删除调用释放

初态有登记中的互斥量 M，ID 为 i，两任务 A、B 可调用同一 ID。可使用同优先级任务和到期时间片构造交错。

1. A 调用 `KMutexDelete(i)`，在 `mutex.c:246–253` 查到 M 并取得其基址，执行第 254 行解锁。
2. A 尚未到第 256 行时发生 tick 抢占；B 调用 `KMutexDelete(i)`，完整执行 `_MutexDelete`，第 70 行注销 ID、第 72 行摘管理链、第 74 行释放 M。
3. A 继续调用 `_MutexDelete(M)`。非空检查不检查生命周期。`LinklistResumeAll(&M->pend_list)` 在 `linklist.c:120` 读取已释放对象内的 `node_next`，已经发生 use-after-free。之后还可能有重复注销、链表破坏或重复 free；这些后果无需全部发生即可判定错误。

## 反例二：唤醒完等待队列后，新的等待者可挂到即将释放的对象

此反例只需一个删除调用，不依赖双重删除。初态 M 被另一任务 H 持有，`val=0`，B 不是 holder。

1. A 执行 `_MutexDelete(M)` 的第 68 行。`LinklistResumeAll` 清空当前等待链并在 `linklist.c:129` 解锁。
2. A 尚未执行 `mutex.c:69` 再加锁时被抢占；B 调用 `KMutexObtain(i, WAITING_FOREVER)`。此时 ID 仍然登记且 M 尚未释放，B 能成功查找。
3. `_MutexObtain` 的 `val=0`、`holder!=B` 路径在 `mutex.c:123` 调用 `LinklistSuspend` 把 B 的 `sched_link` 加入 M 的 `pend_list`。B 解锁并调度，A 得以继续。
4. A 第 69 行加锁后直接注销、摘管理链并释放 M，没有再次检查或唤醒 B。B 的调度节点仍引用已经释放的等待链哨兵；使用无限等待时可永久滞留，使用有限等待时后续摘链也会访问失效链节点。

这些路径在普通任务上下文成立；`KDEBUG_NOT_IN_INTERRUPT` 不提供跨调用的对象保活或排他保证。

## 查过的调用约束与既有模型

`kernel/include/xs_mutex.h:50–53` 仅声明 API，没有“删除期间禁止其他线程操作”的通用契约；`mutex.c` 的 API 注释也没有这样的约束。`kernel/kernel_service/xs_service.c:267–271` 直接转发删除 ID。另查看了 `fs/fatfs/ffsystem.c:84–91`、`resources/ethernet/LwIP/arch/sys_arch.c:211–214`、`kernel/kernel_test/test_circulararea.c:37–69` 的调用点：这些具体调用上下文不能建立整个公开 API 的通用排他条件；部分应用可能在更上层串行化，并不否认上述公开 API 反例。本审查没有声称这些现有应用必然触发反例。

`lib/CrtosRules.v` 的 OutsideCritical 只保存可被环境推进的观察，不交出对象私有所有权。`lib/MutexInv.v` 把已发布对象归共享不变量，不含引用计数或删除保活 token。`lib/CrtosInv.v:118–121` 的 `observed_ktask_published` 是任务观察条件，既不是 Mutex 生存期机制，也不能由一次 ID 查询推得。`/home/xinra/TrustBase.md` 没有批准禁止其他任务删除或新加入等待者的假设。因此不能补一条未经依据的 Require 来取得本次设计通过。

## 拟议最小修改的审查（未修改权威源码）

建议把本次删除的查找、drain、ID 注销和管理链摘除留在同一外层临界区：`KMutexDelete` 查找成功后在原锁内调用 `done.MutexDelete(mutex)`，helper 删除自身 Lock/Unlock/free，仅保留非空检查、`LinklistResumeAll`、`IdRemoveObj`、`DoubleLinkListRmNode`；返回 caller 后解锁，最后 `x_free(mutex)`。

该方案有实际调用依据：`_MutexDelete` 是 static，唯一表初始化为 `mutex.c:207`，表内该项唯一调用为第 256 行；没有独立的其他 helper 调用者。非 SMP 嵌套锁会保留外层中断屏蔽和非零 nesting，所以真实 `LinklistResumeAll` 的嵌套 Unlock 不会重新开放抢占。源码应保留真实嵌套锁；后续验证切片可按已批准“锁内调用移除嵌套 critical 操作”规则适配。

该方案消除了上述两处删除窗口，并使释放前确实已完成等待链清空与撤销发布。它不是整个 Mutex 模块生命周期安全的完整修复声明：`KMutexObtain`、`KMutexAbandon` 自身仍有“查询解锁后使用裸指针”的窗口，其他任务此前取得的旧指针也不会因本方案自动失效。未来若要求覆盖这些 API 与删除任意交错，还需修复对应调用协议或建立有来源的生命周期机制。本次尚未修改源码、编译这一修改，也未证明它。

已只读核对同目录 `proposed-mutex-delete-fix.patch`：两个 hunk 正好实现上述方案，负 ID 和 ID 未找到的早返回路径不变；`x_free` 仍在临界区外，以原对象基址调用。补丁语义审查通过的范围仅是修补两条已确认反例，不是 predicate/spec 审阅通过。补丁尚未应用。

## 对本次设计流程的影响

适用 skill 的 `references/reporting-guide.md` 明确要求：“已发现的源码问题必须先明确解决，否则不得开始或继续编写、修改 predicate 和 spec。” 当前两个反例未修复，不能给新设计 `review-ready` 或 `review-passed`，不能把它们降成已知限制后继续通过。已有源文件、配置及共享定义均保持原状。本审查未运行 symbolic、VC 生成、verification-orchestrator 或实现证明。

## 用户批准后的处理（2026-11-03，当前有效）

用户随后明确指示“假设这两种情况不会发生”。本轮据此在原 C 上恢复设计，不应用尚未获授权的修复补丁。此指示是本轮条件化设计的直接授权；上文保留了批准前的源码审查事实和门禁结论。**源码未修复**，两个反例在无约束环境下仍成立；本轮在明确排除它们的实验范围内继续设计，不把既有错误改记为已修复。

采用的精确假设是：

- **A1**：从本次查找命中到本次对象注销，同一分配对象不被其他执行方删除、回收或复用。地址相同但先释放再分配不是同一对象。
- **A2**：从本次 drain 完成到本次注销，不向该对象等待链加入新 waiter。

两项假设不冻结全部 OS 状态，不保证 mutex 的 holder/标量不变，也不保证任务永远存活；它们不授权修改共享 RTrans 为恒等关系，不凭空赋予锁外对象字节的所有权。其余并发变化仍按现有协议处理，并在后续临界区重新取得当前资源和状态。

因此当前处理状态为 **源码未修复；用户批准以 A1/A2 排除反例；恢复条件化设计**。拟议源码修复补丁不应用，TrustBase 不修改。后续 predicate/spec 可以在此范围完成编译和独立审阅，审阅通过必须显式携带 A1/A2 限制；本记录本身仍不是 predicate/spec review-passed，也不是 C 实现证明。用户明确禁止的 verification-orchestrator、symbolic、VC 和 C 实现证明继续不执行。
