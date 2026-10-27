# KSemaphoreDelete C 分析

分析日期：2026-10-25（Asia/Shanghai）。独立 C analysis agent；仅作源码、配置、已有表示的分析，不声明设计审阅或实现证明通过。完整阅读 `/home/xinra/TrustBase.md`、skill 的 predicate 指南第 1 节及源代码处理指南；本工作目录及其父目录未发现适用 AGENTS.md。本轮未运行 QCP implement、symbolic 或 VC。

## 固定依据与配置

权威 C 位于 `Ubiquitous/XiZi_IIoT_Macro/`（下文源码路径省略此前缀）。现行验证配置采用 `annotated_C/src/include/xsconfig.h`，完整快照在 `checks/c-analysis/xsconfig.h`，所读关键源文件及 TrustBase 的 SHA-256 在 `checks/c-analysis/source-sha256.json`。该快照选择 BOARD_K210_EVB、ARCH_RISCV、KERNEL_SEMAPHORE、SCHED_POLICY_RR_REMAINSLICE、KTASK_PRIORITY_MAX=32、ID_NUM_MAX=128、ID_HTABLE_SIZE=16、NAME_NUM_MAX=32、KERNEL_STACK_OVERFLOW_CHECK、KERNEL_EVENT；未定义 ARCH_SMP、SEPARATE_COMPILE、KERNEL_HOOK；ARCH_CPU_64BIT 与 ARCH_RISCV64 被注释。

这是现有项目的 non-SMP、32 位验证适配配置，不能当成 K210 板的原生构建配置。`board/kd233/config.mk` 实际使用 rv64imafdc/lp64d，`board/kd233/.defconfig` 定义 ARCH_CPU_64BIT、ARCH_RISCV64、ARCH_SMP。TrustBase 授权 64→32 位配置适配，但不能据此宣称原生 64 位/SMP 实现已验证。全局库中的 Cortex-M3 文字不能替代当前源配置证据，也不能将本轮架构悄悄换成 ARM。

依据 `arch/risc-v/Makefile` 的 BOARD_K210_EVB 分支及 shared 目录选择，架构来源为 k210/interrupt.c 和 shared/riscv64_switch.c。shared/Makefile 无条件包含 riscv64_switch.c；其文件名不意味着只能 64 位，`register_para.h:18–33` 在未定义 ARCH_CPU_64BIT 时选择 lw/sw、RegLength=4。因此 32 位适配本身不会使 SwitchKtaskContext 无定义。

`kernel/include/xs_kdbg.h:31` 无条件定义 KERNEL_DEBUG，不能因为 xsconfig 未写它就把所有检查当作空宏。NULL_PARAM_CHECK、CHECK、NOT_IN_CRITICAL_AREA 均包含失败后的无限循环（96–143）；调试输出可按 TrustBase 去除，但保留/消除检查失败路径必须与具体授权范围一致。semaphore.c:24–28 自行将 KDEBUG_NOT_IN_INTERRUPT 重定义为空。KDBG_IPC/KDBG_KTASK/KDBG_SCHED=0，使对应日志条件恒假。KERNEL_HOOK 未定义，HOOK 在 xs_hook.h:30–35 展开为空。

## 完整信号量模块及生命周期

已读取 semaphore.c 全部 304 行。全局 `k_sem_id_manager` 由 DECLARE_ID_MANAGER 建立（semaphore.c:30；xs_id.h:48–56）：128 个 ID、16 个桶、16 字节 bitmap，桶 BSS 全零。`k_sem_list` 静态自环（31）。Semaphore 是 id/value/pend_list/link（xs_sem.h:33–40）；三类链互不相同：ID hash link、信号量管理 link、等待任务的 sched_link。

| 函数 | 路径与主要效果 |
|---|---|
| `_SemaphoreCreate` 33–62 | malloc 失败返回 -ENOMEMORY；成功 memset 全零；锁内分配 ID，失败在锁内 free/unlock；成功设置 value、初始化 pend_list、头插管理链、解锁并返回 ID。 |
| `_SemaphoreDelete` 64–97 | 负 ID 立即返回；锁内 uint16 查找，失败解锁返回；成功按 pend 是否为空决定 resume-all；删 ID、摘管理链；解锁后 free；原有 waiters 非空才 DO_KTASK_ASSIGN。 |
| `_SemaphoreObtain` 99–153 | 负 ID/不存在返回 -ERROR；先转换等待时间；计数>0 则减一返回 EOK；计数零且不等待返回 -ETIMEOUT；否则当前 task.exstatus=EOK，按优先级进入 pend，正等待时间调用 KTaskSetDelay，解锁并调度，返回恢复后的 task.exstatus。此返回值不保证总是 EOK。 |
| `_SemaphoreAbandon` 155–190 | 负 ID/不存在返回 -ERROR；非空 pend 唤醒首任务且 resched；否则 uint16 value++（包括 65535→0）；解锁，按需调度，返回 EOK。 |
| `_SemaphoreSetValue` 192–230 | 负 ID/不存在返回 -ERROR；相同值仅解锁返回；不同值时只要 pend 非空就 resume-all（包括新值为 0，源码并不检查 val>0），再写 value、解锁、按需调度，返回 EOK。 |
| 五个 KSemaphore* wrapper 246–304 | debug 检查实际为空，调用本文件唯一静态 done 表。done 的五项在 232–238 初始化，搜索未发现写入，Delete 唯一解析到 `_SemaphoreDelete`。 |

模块表示必须容纳 value 的整个 uint16 范围、等待顺序、发布/摘除/私有待回收生命周期；不能根据 SetValue 的注释错误地假设仅 val>0 才唤醒。模块资源复用 SemaphoreState/SemaphoreInv；任务、延时、ready queue 应复用各自模块，不复制到 semaphore 状态内。

## 删除路径和关键边界

1. `id<0`（71–72）：不取锁，不查询、不回收、不调度。
2. `id>=0`（74–79）：`IdGetObj` 形参是 uint16（id.c:122），因此真正查找 `id mod 65536`。例如 id=65536 查询 ID 0。不能加 `id<128` Require 排除真实输入，也不能把所有大 int32 ID 写成 no-op。转换后值≥128 时返回空；值在 0..127 时进入 GetObj。
3. 未命中：GetObj（75–96）会将 `node_prev==NULL` 的 lazy bucket 初始化成自环再返回 NULL。抽象对象集合可不变，具体桶内存不是逐字节不变；store_idmanager 允许空桶的 zero/self-linked 两态，适合保持同一抽象状态。
4. 命中且无等待者：删除对应 ID bitmap bit 与桶节点（id.c:130–142），`idnode->id=-1` 的 uint16 存储结果为 65535；摘管理链；解锁；回收对象；不调用调度。
5. 命中且有等待者：先 `LinklistResumeAll`；每轮给首 waiter `exstatus=-ERROR`（linklist.c:123），唤醒并迁入 ready queue；所有 waiters 摘除后按上一项删除/回收，再执行调度。不能将 wake 后异常值写成 EOK。

源码没有在删除过程中修改 semaphore.value。任务 Delay 对象也没有释放：KTaskUnSetDelay 只在 delay 非空且 ACTIVE 时写 INACTIVE 并摘其 delay.link（delay.c:97–114）。原有 delay 指针、ticks、task 字段及分配对象保留。

LinklistResumeAll 的循环每次重新读 list->node_next；不是预先缓存 next 的遍历。自然不变式为“已处理前缀与未处理后缀”，未处理任务仍在该 pend list、注册且 SUSPEND，已处理者 exstatus=-ERROR、ready、延时取消，其他模块资源保持。当前 os_inv 的 pure_suspend_sched_link 已绑定已登记 task map 与 SUSPEND（TaskInv.v），全局 os_sched_owners coverage 确保 sched_link 唯一拥有（CrtosInv.v）。这些实际系统不变量可支撑调用成功和链长下降，不应额外假设任意列表调用都成功。若列表含非 SUSPEND 任务，_KTaskWakeup 会返回 -ERROR 且不摘节点，ResumeAll 不退出；必须明确合法系统状态与任意坏链表的边界。

## 原始调用关系（按下文适配后确定最终闭包）

以下列出直接边，按当前配置解析 done dispatch。图中同名函数只算一个 canonical symbol；后续 write-spec 须给每个非 trusted symbol 唯一 active body，已有 module/header spec 不可代替。

| caller | 直接真实 callee / 解析依据 |
|---|---|
| KSemaphoreDelete | _SemaphoreDelete；semaphore.c:232–262 静态 done |
| _SemaphoreDelete | CriticalAreaLock/UnLock；IdGetObj；IsDoubleLinkListEmpty；LinklistResumeAll；IdRemoveObj；DoubleLinkListRmNode；x_free；DO_KTASK_ASSIGN 的展开（下述）；CONTAINER_OF 适配 |
| IdGetObj | GetObj；id.c:122–128 |
| GetObj | InitDoubleLinkList；CONTAINER_OF；id.c:75–96，for 宏为字段遍历 |
| IdRemoveObj | IdGetObj、FreeId、RemoveObj；id.c:130–142 |
| FreeId | 无函数调用（仅 NULL_PARAM_CHECK 诊断/循环），读改写 bitmap；55–60 |
| RemoveObj | DoubleLinkListRmNode；98–104。声明返回 IdNode* 但无 return，所有实际调用丢弃结果；保留真实声明和完整 body，不能假造返回值。 |
| LinklistResumeAll | CriticalAreaLock/UnLock、KTaskWakeup、CONTAINER_OF；linklist.c:110–132 |
| KTaskWakeup | GetTaskWithIdnodeInfo、_KTaskWakeup；ktask.c:1066–1075，Done 初始化 810–822，task->Done 赋值 866/1157 |
| GetTaskWithIdnodeInfo | CriticalAreaLock/UnLock、IdGetObj、CONTAINER_OF；ktask.c:64–82 |
| _KTaskWakeup | JudgeKTaskStatIsSuspend、CriticalAreaLock/UnLock、DoubleLinkListRmNode、KTaskUnSetDelay、KTaskInsertToReadyVector；ktask.c:488–515 |
| KTaskUnSetDelay | CriticalAreaLock/UnLock、DoubleLinkListRmNode；delay.c:97–114 |
| KTaskInsertToReadyVector | DisableLocalInterrupt、KTaskStatSetAsReady、AssignPolicyInsert、EnableLocalInterrupt；assign.c:204–224。MERGE_FLAG 是字段位或赋值。 |
| KTaskStatSetAsReady | KTaskStateSet；ktask_stat.c:43–47 |
| KTaskStateSet | 无函数调用；保留 stat 高位、写低三位；ktask_stat.c:31–35 |
| AssignPolicyInsert | RoundRobinRemainReadyVectorInsert；assignstat.c:89–114。末尾更新 highest_prio，不能只规格化 bucket。 |
| RoundRobinRemainReadyVectorInsert | DoubleLinkListInsertNodeBefore/After、CONTAINER_OF；advance_cnt<1 时按 rest_timeslice 比较，否则尾插；assign_roundrobinremain.c:33–61 |
| InitDoubleLinkList / DoubleLinkListInsertNodeBefore / After / RmNode / IsDoubleLinkListEmpty | 均字段操作叶子；double_link.c:30–89。RmNode 后节点自环。 |
| JudgeKTaskStatIsSuspend | 字段比较叶子；ktask_stat.c:85–89 |

上述 IRQ 叶子已经由 ready-insert 到达，不仅由末尾 DO_KTASK_ASSIGN 到达。嵌套 CriticalAreaLock/UnLock 不可误写为释放外层锁；non-SMP 实现是 Nest++/Nest-- 与保存/恢复 IRQ（CriticalArea.c:117–138）。源代码处理指南有锁内 callee 消除嵌套锁的既有归一，若采用须逐函数记录并核对适用条件。

### 原始调度内部关系（适配后不进入验证闭包）

DO_KTASK_ASSIGN 的 non-SMP 展开是 xs_assign.h:122–130：NOT_IN_CRITICAL_AREA；DisableLocalInterrupt；KTaskOsAssign；EnableLocalInterrupt。NOT_IN_CRITICAL_AREA 含 GetOsAssignLockLevel 和诊断失败无限循环。

| caller | callee/效果 |
|---|---|
| KTaskOsAssign | GetOsAssignLockLevel；IsInIsr；SetIsrSwitchTrigerFlag；JudgeAssignReadyBitmapIsEmpty；ChooseTaskWithHighestPrio；JudgeKTaskStatIsRunning；KTaskInsertToReadyVector；KTaskOsAssignRemoveKTask；KTaskStatSetAsRunning；_KTaskOsAssignStackCheck；SwitchKtaskContext（assign.c:40–113） |
| GetOsAssignLockLevel | 读 KTaskOsAssignLockNest；CriticalArea.c:105–107 |
| IsInIsr / SetIsrSwitchTrigerFlag | 读 isr_count / 写 isr_switch_trigger_flag=1；isr.c:68–76,158–167；isrDone 190–203，SysInitIsrManager 211 绑定 |
| JudgeAssignReadyBitmapIsEmpty | 读 priority_ready_group；assignstat.c:47–51 |
| ChooseTaskWithHighestPrio | 读 highest_prio、对应 bucket 首节点，CONTAINER_OF；assignstat.c:53–64 |
| JudgeKTaskStatIsRunning | 读 stat 低三位；ktask_stat.c:91–95 |
| KTaskOsAssignRemoveKTask | DisableLocalInterrupt；DoubleLinkListRmNode；IsDoubleLinkListEmpty；PrioCaculate；EnableLocalInterrupt；更新 bitmap/highest_prio（assign.c:232–263） |
| PrioCaculate | 只读 const LeaderZeroCount，四个 byte 非零分支及零分支；bitmap.c:44–66 |
| KTaskStatSetAsRunning | KTaskStateSet；ktask_stat.c:55–59 |
| _KTaskOsAssignStackCheck | 栈指针范围检查；失败 KPrintf（可去除输出）并 while(1)；assignstat.c:30–44。KERNEL_STACK_OVERFLOW_CHECK 开启，不得整个删除。 |
| DisableLocalInterrupt / EnableLocalInterrupt | K210 interrupt.c:50–62 的 csrrci/csrw inline asm。不是空 C 函数。 |
| SwitchKtaskContext | shared/riscv64_switch.c:187–200 naked inline asm，跳转 SaveMpie 并最终通过恢复寄存器/特权返回切换。不能把 asm 中跨函数标签 jump 当普通 C return。 |

ready_vector_done 的 insert/remove 在 assign.c:30–35、387 唯一绑定到 KTaskInsertToReadyVector/KTaskOsAssignRemoveKTask（非 SMP）；isr done 如上；task Done 如上。必须由初始化/全局 context 保证表未被外部篡改；不能以函数名相似代替解析。

调度真实路径包含锁层级≥1提前返回、ISR 置触发标志后返回、ready bitmap 为空返回、当前 running task 优先级更高返回；切换分支可重新插入旧任务、移除新任务、改 stat/current_priority/os_running_task、栈检查，再上下文切换；new_task==running_task 分支仍从 ready 摘节点并写 RUNNING。因而原样恒等状态模型不是逐语句 C 等价。

## ABI、所有权和已有定义复用

32 位验证 ABI 下 Semaphore/IdNode/DLL 节点布局预期为 32/12/8 bytes，Semaphore.id=0、value=12、pend_list=16、link=24，padding 为 [2,4)、[14,16)。这些与现有 SemaphoreState.v/SemaphoreInv.v 的显式布局一致；本分析没有将 .vo 编译成功当成 C ABI 检查。本轮正式候选须以当前配置做 ABI/typecheck，不能复用不同 ARM 板配置的结论。TaskDescriptor 的原始 event 两个位域被已有验证头转换成两个 uint32，属于 TrustBase 已列适配；这会改变 exstatus/id/Done 的 offset，必须保留完整前置布局或核对所有字段转换，不能用紧凑 fake struct。

已读/搜索根 lib 的 SemaphoreState、SemaphoreInv、CrtosInv、TaskInv、idnode、KTaskOsAssign 以及 annotated_C 的 ktask_wakeup、assign_ready_insert、ktask_assign_oc、ID specs。根库有信号量状态/内存、任务/延时/ready queue/ID manager 表示，可增量复用。现有 `KTASK_ASSIGN` 的 .c/.v 明确标注“用户指定/授权逻辑模型”，并不证明 DO_KTASK_ASSIGN 实现；历史注释不能作为本轮新授权。

删除时 ID 字段/ID link 在 ID manager，管理 link 在全局 DLL，value/padding/pend 哨兵在 payload，waiter sched_link 在 pend DLL，任务其余字段在 task_inv；撤回 ID 与管理链后须重组完整私有 SemaphoreRaw，再带过解锁交 x_free。信号量管理状态移除对象不应丢失私有所有权。其他信号量的 value/pending、未触及 task 字段、delay 对象非状态字段、未触及队列顺序均保留；ready 插入与调度造成的合法改变须明确列出。

## 当前适配边界与结论（按用户更新的 skill 修订）

用户更新 skill 后，write-spec 明确要求“先按当前配置和《源代码处理》完成源码适配，再确定闭包”，并明确文档规定的模型/API contract 为递归边界、具体适配优先于一般等价要求。本报告据此解除原 B1；这只更新本轮依据，不把旧版本审阅结论追认为已通过。源码主体分析仍有效，不重复分析。

TrustBase 明列 CriticalAreaLock、CriticalAreaUnLock、KERNEL_MALLOC/KERNEL_FREE、CONTAINER_OF 及调试适配。`xs_memory.h:52–54` 精确声明 KERNEL_FREE(ptr)=x_free(ptr)，可将 x_free 视为该已授权 free 边界的实际 symbol，采用消费合法分配基址及完整 owned allocation 的 contract，不递归 allocator。原始 x_free 本体已读 byte_manage.c:807–868。

`DO_KTASK_ASSIGN` 按《源代码处理》替换为 KTASK_ASSIGN，使用该文档给定的 OutsideCritical/safeExec/abs_ktask_assign contract。它是允许的抢占逻辑模型接口，不再递归 KTaskOsAssign、SwitchKtaskContext 和宏内部 IRQ 调用；不能把这些原始汇编/调度实现报告为已证明。锁内 callee 的嵌套临界区及 IRQ 屏蔽操作按同一文档和现有 assign_ready_insert.c 适配删除；操作列表及余下闭包见 [适配清单](adapted-closure.md)。

原始代码的全部 paths 和效果仍见前文；仅文档指定替换部分按模型范围说明。外层删除锁、解锁与锁外 free 的顺序仍保留，不把删除函数整体抽象化。静态 dispatch 仍由源码表解析；NULL_PARAM_CHECK 可保留去打印后的非返回检查，或采用文档允许的 NULL_PARAM_CHECK_1 API，并按最终切片单独登记边界。

当前配置 ABI 新检查已完成：使用配置快照加真实 kernel/include（不使用 annotated 类型头）以 GCC -m32 检查原始定义，再仅对 TaskDescriptor 的两处事件位域作 TrustBase 指定 uint32 展开，在同一配置再次检查。详见 checks/c-analysis/abi-{original,adapted}.c、run-abi-check.py、abi-check-results.json；全部 static assertions 通过。原始 TaskDescriptor 为116 bytes，exstatus/id/Done 为88/100/112；适配后120 bytes，对应92/104/116，与根 lib/StructFieldOffsetAxiom.v 一致。Semaphore 为32 bytes，id/value/pend_list/link 为0/12/16/24。详细其他字段见断言源。GCC -m32 用来核对选定 ILP32 内存载体，不声称检查了 K210 原生 LP64D ABI，更没有运行板级汇编。

当前 ABI 检查建立真实头文件与明确位域转换的依据；最终 slice_types.h 现已运行相同断言并通过，23个body和接口结构检查也已完成，见 [candidate检查](candidate-source-check.md)。B1 已解除；这不等于 predicate/spec 的正式设计审阅通过，也未启动 QCP implement/symbolic/VC。
