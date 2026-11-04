# KMutexDelete：C 分析与调用闭包（2026-11-03）

本报告由独立 C analysis agent 只读分析当前权威源码得到。新实验为 `kmutexdelete-trial-261103-1`；未复用 IDE 中的旧 trial。未写 predicate/spec，未运行 symbolic、VC 或 verification-orchestrator。本报告给出设计输入，**不是 review-passed 结论**。两处跨临界区问题已由独立源码审查确认；用户随后明确批准“假设这两种情况不会发生”，因此恢复原 C 的条件化设计。源码未修复，结论仅适用于下面明确列出的两个环境假设；当前闭包分类仍是设计输入，须经正式合同与审阅完成。

## 用户批准的实验假设（当前有效）

用户在本次对话明确批准“假设这两种情况不会发生”，要求不修改原 C 并恢复设计。该批准覆盖以下两项、仅以下两项：

1. **A1 对象生存期**：从本次 KMutexDelete 查找命中开始，直到本次删除完成该对象的注销，同一分配对象不会被其他执行方删除、回收或复用。这里要求保持同一对象身份；仅地址相同但原对象已释放、重分配不满足 A1。
2. **A2 排空后的等待链**：从本次 LinklistResumeAll 完成排空开始，直到本次注销该互斥量，不再有新 waiter 加入它的等待链。

A1 不保证 holder、val、recursive_cnt、origin_prio 或等待链内容在 lookup 与 drain 之间保持不变；A2 也不冻结其余对象及任务状态。两个假设均不保证所有 OS 状态不变、任务永久存活，不能扩充为全局禁止调度/抢占。任务字段和内存权限仍须在实际 critical 区域由 reviewed invariant 获取，指针身份假设本身不授予空间所有权。排空后的临界区必须重新观察当前对象标量，不把旧快照直接当作当前值。

源码、配置和 TrustBase 均未修改；未应用拟议补丁。原反例保留用于解释条件的必要性。先前“未获批准故停止”的门禁状态已由用户的明确范围授权替代，允许在 A1/A2 下开展 predicate/spec 设计及设计所需 Rocq 类型检查；不因此启动实现证明或宣称无条件安全。

## 源码与配置

根目录为 `/home/xinra/crtos`。权威模块是 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c`，结构声明在 `kernel/include/xs_mutex.h:33–41`。读过 `/home/xinra/TrustBase.md`、skill 的 predicate 源码分析指南、源码适配与工程配置指南；检查 `/AGENTS.md`、`/home/AGENTS.md`、`/home/xinra/AGENTS.md`、根及目标子树未发现适用 `AGENTS.md`。

当前验证配置 `annotated_C/src/include/xsconfig.h` 开启 `KERNEL_MUTEX`、`SCHED_POLICY_RR_REMAINSLICE`、32 优先级、`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`；没有 `ARCH_SMP`，`ARCH_CPU_64BIT` 被注释。配置声明板型 K210/RISCV，验证 ABI 按 TrustBase 的 64→32 适配；不能把 32 位验证 ABI 声称为原始 K210 硬件 ABI。非 SMP 抢占证据来自实际内核及该板型中断链，见下文。

`Mutex` 的 ILP32 布局：`id.id` 0–1，padding 2–3，`id.link` 4–11，`val` 12–13，`recursive_cnt` 14，`origin_prio` 15，`holder` 16–19，`pend_list` 20–27，`link` 28–35，共 36 字节。不能省略 `id` 或其他字段而把后续字段偏移压缩。

## 模块生命周期与内存

| 函数及源码行 | 路径、状态及内存效果 |
|---|---|
| 全局初始化 :24–25 | `DECLARE_ID_MANAGER` 建立 bitmap、16 个懒初始化桶和 manager；`k_mutex_list` 静态自环。 |
| `_MutexCreate` :27–60 | malloc 失败返回 -5；成功 memset 全 36 字节后进锁；ID 插入失败解锁、free、返回 -5；成功建空等待链，写 val=1、holder=0、origin_prio=255、recursive_cnt=0，管理链头插，解锁返回 ID。 |
| `_MutexDelete` :62–75 | NULL 检查；锁外调用自己加锁的 `LinklistResumeAll`；随后另一次加锁，读 `mutex->id.id` 并注销 ID，移除管理链，解锁后 free 完整对象。无返回值、无 holder/recursive_cnt 条件检查，不恢复 holder 优先级，不执行调度宏。 |
| `_MutexObtain` :77–148 | 取当前 task、换算等待 tick 后进锁；写 task.exstatus=0；同 holder 时 uint8 递归计数递增（可回绕）；有空值时 val--，记录 holder/优先级并递增计数；忙且零等待返回 -ETIMEOUT，否则挂入优先级等待链、可能建立 delay、解锁调度；恢复后按 exstatus 返回或重新加锁后返回 0。源码中的优先级继承代码被注释。 |
| `_MutexAbandon` :150–203 | 非 holder 写当前 task.exstatus=-1 并返回 -1；holder 递减 uint8 计数，降到零且有 waiter 时转交 holder、记录优先级、计数++、唤醒队首，解锁后调度；无 waiter 则 val++、holder=0、origin_prio=255。被注释的优先级恢复无副作用。 |
| `KMutexCreate` :222–227 | 移除调试宏后直接 `_MutexCreate`。 |
| `KMutexDelete` :235–257 | 负 ID 直接返回；否则锁内查 ID，未命中解锁返回；命中转对象指针，**解锁后**调用 `_MutexDelete`。 |
| `KMutexObtain` :268–291 / `KMutexAbandon` :300–321 | 负 ID/查找失败返回 -1；查找命中后均解锁，再把指针交给模块方法。不是删除目标闭包，但它们说明对象的真实共享生命周期及交错可能性。 |

`done` (:205–210) 静态初始化，源码无其他写入；四个 dispatch 均可解析。本轮只保留删除入口到 `_MutexDelete` 的调用。`holder` 是引用，不授予 task 本体权限；不能据它推导 task 存活。mutex 等待链独占 task 的 sched_link，task 字段由 task 模块拥有；ID manager 独占 ID 值和哈希链，管理 DLL 独占 mutex.link，Mutex payload 拥有其余标量、padding 和 pend_list。根 `MutexState.v`、`MutexInv.v` 已采用这一分工，应复用。

已有 `MutexRaw`、`MutexZero`、`mutex_inv` 描述初始化/发布资源，但没有替当前 C 解决“查到对象后跨解锁仍可访问”的保活问题。根 `MutexOps.v` 已有 `mutex_remove_waiter_step`；`KTaskWakeup.v` 的一般 `ktask_wakeup_step` 已覆盖从 mutex 等待链摘除、就绪队列插入、延时取消。既有共享定义不是本次实现证明。

## 目标路径与循环

1. `id<0`：不查询、不进入真实临界区，直接 `return`。
2. `id>=0`：传入 `IdGetObj` 的实参按 `uint16` 截断，**不是**原始 int32。例：65536 查询 ID 0。不能为了沿用某个查询合同而把顶层 Require 加强为 `id<65536`。
3. 查询未命中：一次临界区后返回。GetObj 内部可能把空懒桶从全零初始化为自环，抽象 ID 集合不变；已有 ID representation 允许这两种空桶表示。
4. 查询命中：锁内 `CONTAINER_OF` 得到对象地址；解锁、唤醒整个 pending、再加锁注销、解锁 free。正常串行路径会清 ID 位图、哈希节点自环并把 id.id 写为 65535，管理 link 自环；对象完全退出共享容器后才能将 36 字节交还 allocator。
5. LinklistResumeAll 的 NULL 检查是非返回死循环；在对象存活及合法布局下 &pend_list 非零。循环读头 next，若非头则转换 task、写 exstatus=-1、唤醒该 task，再读头；头自环时退出并返回 EOK。每轮的有效进展来自 KTaskWakeup 将该等待 task 摘出；任务状态需由全局跨模块 invariant 保证 SUSPEND，不能只依赖一个链节点地址。
6. bulk wakeup 最终效果需表达原等待 task 的 READY/exstatus=-1、延时取消、RR_REMAINSLICE 就绪插入次序及其他模块保持。不能只承诺等待链为空。被唤醒 task 的 holder/优先级不因 delete 改写。

## 适配后闭包分类草案

```
KMutexDelete [新设计]
 ├─ CriticalAreaLock / CriticalAreaUnLock [TrustBase]
 ├─ IdGetObj [reused-spec]
 ├─ CONTAINER_OF_MUTEX_ID [TrustBase container API]
 └─ _MutexDelete [新设计]
     ├─ NULL_PARAM_CHECK [展开非空检查/死循环；调试输出删除]
     ├─ LinklistResumeAll [mutex + 锁外调用场景需新设计，非原合同复用]
     │   ├─ CriticalAreaLock / CriticalAreaUnLock [保留自身锁，TrustBase]
     │   ├─ CONTAINER_OF_TASK_SCHED [TrustBase container API]
     │   └─ KTaskWakeup [reused-spec，wakeup_by_id_ic]
     ├─ CriticalAreaLock / CriticalAreaUnLock [保留，TrustBase]
     ├─ IdRemoveObj [reused-spec，low_level_spec]
     ├─ DoubleLinkListRmNode [reused-spec，remove_member]
     └─ x_free / KERNEL_FREE [适用 allocator 模型接口]
```

`KDEBUG_NOT_IN_INTERRUPT` 按 TrustBase 删除，不产生额外调用。`done.MutexDelete` 解析为 `_MutexDelete`；static→切片外部链接不改变函数算法。`NULL_PARAM_CHECK` 的 KPrintf 可移除，非空分支和 NULL 非返回路径须保留。`SYS_DOUBLE_LINKLIST_ENTRY` 归为 CONTAINER_OF_TASK_SCHED。本路径无 `DO_KTASK_ASSIGN`，不得仿照 semaphore 删除自行添加。

**不能删除 LinklistResumeAll 自身锁**：原函数从 `_MutexDelete` 的锁外调用，只有其内部 KTaskWakeup 及更深调用属于 nested critical 适配场景。根 `annotated_C/src/LinklistResumeAll.c` 的 `semaphore_waiters` 是锁内且只覆盖 semaphore；其 body 删除了自身锁，不能原样用于本调用。mutex 新 contract 也不能声称从 semaphore 专用合同推导而来，需要独立新设计/实现义务或用户决定的范围变更。保留原 semaphore contract 不等于它能适用 mutex。

可复用接口与来源：

| symbol | 来源 / 采用接口 | 当前适用性说明 |
|---|---|---|
| IdGetObj | `annotated_C/src/IdGetObj.c:18` 完整 canonical | 0<=uint16<65536；借还完整 manager，命中提供 found。内部 GetObj/InitDoubleLinkList 被此边界覆盖，无需本轮实现闭包递归。 |
| IdRemoveObj | `annotated_C/src/IdRemoveObj.c:59` `low_level_spec` | 适用于任意完整 manager 状态，命中后返回 manager_remove 和脱离的 idnode；比要求“恰好刚插入”的 high_level_spec 更合适。内部 IdGetObj/FreeId/RemoveObj 不安排实现证明。 |
| DoubleLinkListRmNode | `annotated_C/src/kernel/thread/double_link_remove_member.c:19` + `headers/m_double_linklist.h` 的 `remove_member` | 泛型 payload 能实例化为 MutexAbs，返回 payload 和自环节点；需要展开 header 中合同到唯一 canonical active body。 |
| KTaskWakeup | `annotated_C/src/kernel/thread/ktask_wakeup.c:163` + `headers/ktask_wakeup.h` 的 `wakeup_by_id_ic` | 既有 general transition 覆盖 mutex。需适配陈旧 `libai` import 并把完整 With/Require/Ensure 放在独立 canonical 文件。callee 内部 GetTaskWithIdnodeInfo/_KTaskWakeup 等是该复用边界内部。 |
| CriticalAreaLock/UnLock | TrustBase 明确 symbol；根现有 ordinary/stable 接口 | 使用 OS invariant 与统一 critical token；不得加强为“解锁后对象必定存活”。 |
| container APIs | TrustBase 的 CONTAINER_OF 适配 | 纯地址对应不带 ownership，不能给失效指针恢复访问权限。 |
| allocator free | TrustBase 的 KERNEL_FREE；已有 x_free 模型用法 | 应核对并明确宏/模型对应；需要分配基址完整对象资源，不能只给 pointer 或对象成员关系。 |

上述边界不能当作本轮已证明，正式复用时还须保留原合同语义和 caller/canonical 一致性。当前没有新增 trusted symbol 授权；新批准的是两个限定环境假设，不是任何新 C symbol 的 trusted 授权。草案表本身不代表闭包审阅通过。

## 已定位的跨解锁生命周期问题

在默认可抢占、无额外外层锁的调用中，现有源码允许以下交错：

1. 已发布 mutex M，ID 为 i；task A 调用 KMutexDelete(i)，执行 mutex.c:246–254，查得 M 地址 p 并解锁，尚未执行 :256。
2. 时钟中断切换到另一 task B。B 调用相同 KMutexDelete(i)，完成 :62–75，包括 x_free(p)。
3. A 恢复执行 :256，将已释放但非零的 p 传入 _MutexDelete。NULL 检查不能识别它；LinklistResumeAll 在 linklist.c:120 读取 p->pend_list.node_next，形成 use-after-free。后续注销/摘链/free 还可能二次释放或破坏复用对象。

这是源码允许的具体交错，不是仅根据宽松 `Crtos_RTrans` 推测。非 SMP 不消除此问题：

- `CriticalArea.c:117–124` 禁 IRQ 并递增 nest；`:132–137` 递减 nest 并恢复进入前 IRQ 状态。通常从 nest=0 调用，解锁后重新允许抢占。
- `arch/risc-v/k210/interrupt.c:50–61` 实际清/恢复 mstatus.MIE；`xs_isr.h:87–88` 将宏映射到这些函数。
- 当前 RR_REMAINSLICE 配置：`tick.c:75–79` 调用 `RoundRobinRemainTaskTimesliceUpdate`；后者 :67–76 在 timeslice 到零时调用 DO_KTASK_ASSIGN。
- `assign.c:47–53` 在 nest=0 的 ISR 中设置切换标志；`:123–183` 在 IRQ 返回路径允许同/更高优先级 ready task 切换；`arch/risc-v/k210/boot.S:108–112` 从 HandleTrap 返回后执行 KTaskOsAssignAfterIrq。B 可以在同优先级轮转中获得运行，随后结束/阻塞，使 A 恢复。
- `xs_mutex.h:50–53` 没有声明删除排他纪律，模块入口没有引用计数、deleting 标记或持久锁。`kernel_service/xs_service.c:267–271` 的 KsDeleteMutex 也是直接转调；`UserMutexDelete` 仅转发 ID。当前查到的公开代码没有保证所有调用者禁止并发 delete。

此外，LinklistResumeAll :129 解锁到 `_MutexDelete` :69 再锁之间还开放另一个窗口：其他线程可能重新进入 mutex 等待链；不能把第一段 drain 的“空等待链”无条件保留到回收段。建议修复方向是使查找、drain、注销共享对象成为同一受保护操作，再把已完整私有化的对象交给锁外 free；具体权威 C 修复必须由用户授权并重新分析，不能仅改变验证切片。

独立审查已确认两条交错；用户批准排除这些交错后允许条件化设计，源码仍有原缺陷。已知旧报告 `.docs/Report/2026-09-30-1-ipc-source-error-report.md` 的 holder 失效、递归计数溢出和 timeout 问题不是本缺陷的解决依据。

## 源版本固定

SHA-256（本次只读观察）：

| 文件 | SHA-256 |
|---|---|
| kernel/thread/mutex.c | `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645` |
| kernel/thread/linklist.c | `d64d3275b6d936f46352bc4625fc11efc9e0b113ca838f60a98eabaa09a7342c` |
| kernel/thread/CriticalArea.c | `946b214eb678c1202c96dc6fd5272fd2c8d2dd245736888a0ea4114fdd6f113a` |
| kernel/thread/assign.c | `418f58833c6e8a9198daf6f8ce0364ee5646a0483cc3750052127f8a7f435ada` |
| kernel/thread/id.c | `189a94e7dc17d6c9da6f7992a232e4422c9dc11dea539b40452b0041546a9fca` |
| annotated_C/src/include/xsconfig.h | `e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28` |
| annotated_C/src/IdGetObj.c | `e3c81f38bc18cd95671d64d50bc5454c0b506a8c85a7aff4034c1f52da44e3d8` |
| annotated_C/src/IdRemoveObj.c | `690d8789967fa4f704153597ea79f0741e839dc47dbe39c0869ee44a2c1bbbe3` |
| annotated_C/src/LinklistResumeAll.c | `876f37e6b9377872aba575e0564957178abbfe4da21ad7081f58ee71ebf1af42` |
| annotated_C/src/kernel/thread/ktask_wakeup.c | `79eb94bfd95f0cf257d369840dbc51a0b2277c29ea98b7691981f9f734c1d7b4` |
| annotated_C/src/kernel/thread/double_link_remove_member.c | `de6b677d837aff8ad14bc3ac26a29080f0fbe3eb756082567958529c2e9d3071` |

表中 kernel 路径均相对 `Ubiquitous/XiZi_IIoT_Macro/`。只创建本报告；未修改权威源码或全局库。
