> 全局整合后的位置：Init/DeInit/Peak在annotated_C/src/kernel/dataqueue；Push/Pop在annotated_C/module_context/dataqueue；已批准的_Obtain副本在annotated_C/module_context/semaphore。下面的早期阶段描述和hash保留为源码证据，当前状态见function-status.md及integration-review.md。

> 本文保留源码分析与修复复核证据，以下日期段落按当时状态理解。当前文件位置及待处理事项见 [设计说明](design.md)、[源码变更](source-changes.md) 和 [错误报告](source-errors.md)。

# InitDataqueue 全新源码分析

本记录由独立 C analysis agent 从当前源码重新分析；未读取旧 trial。2026-11-16 已重新核对基线，当前进入 predicate/spec 重新设计，尚未审阅通过或启动实现证明。源码处理状态：**用户授权的源码缺陷已在验证副本修复，针对性检查通过；Peak 共享访问疑点已按默认规则在副本适配。源码门禁针对该副本版本已解除，main 已独立逐行复核；尚未编写 predicate/spec、未导入复用 contract、未启动 QCP**。分析日期 2026-11-15。

## 源码与配置依据

工程配置 `.agents/verify-os.config.json` 指向 `/home/xinra/crtos`，目标实际为 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c:33` 的 `InitDataqueue`（大小写如此），模块为 dataqueue。源码 HEAD 为 `340892ea259f1d38e418f7099277e3ede9f1d1fd`，当前工作树有本地修改，不能只凭 commit 标识输入。

当前权威 data_queue.c SHA-256 为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`；本轮发现它从初读版本外部变化，原文件现不含 sentinel 修复。下表保留初读证据以解释变化，**不再作为当前 data_queue.c 基线**。当前五份副本及修复/适配状态见 [修复记录](source-errors.md)。

初读 SHA-256：

| 文件 | SHA-256 |
| --- | --- |
| 源码 `kernel/thread/data_queue.c` | `6ff659a97e06586b48d5a77de05ee9dfb5884659ace0f5eaa340daf57376c89e` |
| 源码 `kernel/include/xs_dataqueue.h` | `fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8` |
| 验证工程 `annotated_C/src/include/xsconfig.h` | `e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28` |

当前全局验证配置启用 KERNEL_DATAQUEUE、KERNEL_SEMAPHORE，未定义 ARCH_SMP，ARCH_CPU_64BIT/ARCH_RISCV64 被注释；这是 TrustBase 允许的 64→32 位验证适配。权威 Macro 源码树扫描未发现 xsconfig.h/.config，因此尚不能把全局验证配置宣称为某个当前硬件构建的自动生成配置；需在后续配置确认中明确此限制。`kernel/thread/Makefile:42–43` 以 CONFIG_KERNEL_DATAQUEUE 控制编译目标。源码 `xs_kdbg.h:31,96–104` 启用旧版 NULL_PARAM_CHECK：空指针会循环，不适用新版“仅测试计数、可删除”的规则。

初读 `6ff659…` 源码曾包含 sem ID 修复（当前 `a8b12c…` 原源码已不含，已按新授权在副本恢复）：Init 先设两 ID 为 -1，以 `<0` 检查 create 失败；DeInit 以 `>=0` 判断持有资源并重置为 -1。此事实仅来自本轮源码，未读取任何旧报告，不把曾经的问题视为当前缺陷。

## 模块函数与对象生命周期

模块全部实现函数为 InitDataqueue、DeInitDataqueue、PushDataqueue、PopDataqueue、DataqueuePeak。当前模块分析以Init/DeInit 的 `trial/annotated_C/src/` 副本及其余三份 `trial/annotated_C/module_context/` 副本为准：Init/DeInit 的修复恢复下表所述 sentinel 行为；Push/Pop 现统一 Obtain(id, timeout)，非 EOK 立即失败，成功才执行后续路径；Peak 现把检查与读取放在同一临界区，空/非空出口均解锁。下表中的旧控制流只用于解释原始缺陷及修复动机，不是当前副本行为。`queue_manager.c:31–41` 负责 done-table 注册，表中目标明确指向这五个函数；注册器是外部管理上下文，不属于 Init 的调用闭包。串口 `resources/serial/dev_serial.c:593–594` 分配 queue 结构并以容量 8 初始化，发送/中断代码使用 Push(-1)、Pop(0)、Peak。

`DataQueueType`（xs_dataqueue.h:36–45）拥有 front/rear/max_len 三个 uint16、base 指针及两 int semaphore ID；base 指向 NodeNumber 个 DataElemType，每项为只保存的 data 指针与 length。队列存储指针，不复制/释放 payload；predicate 不应凭此拥有 payload 内容。Queue 结构由 caller 分配，DeInit 不释放结构本体。两信号量属于共享 semaphore 管理模块，queue 保存 ID，不能与 semaphore invariant 重复拥有其内存。

| 函数 | 控制流、资源与变化 |
| --- | --- |
| Init，33–75 | 进入临界区；memset 整个 queue，含 padding；sentinel=-1、front=rear=0、max_len=参数；分配未初始化元素数组；依次创建 blank(n-1) 与 data(0)。三处失败均解锁后调用 DeInit，返回 -1；全成功解锁返回 0。不访问数组元素。n=0 时真实 x_malloc(0) 返回 NULL（byte_manage.c:646/657），不能无依据排除此输入；n=1 成功可构成零有效容量队列。初始化已持有资源的 queue 会覆盖旧指针，需以对象生命周期明确初始化前应为 caller 提供的未持有动态资源存储。 |
| DeInit，84–113 | 关中断；非空 base 释放并置 NULL；每个非负 ID 删除并置 -1；恢复中断。front/rear/max_len 保留。必须表达部分初始化状态，不只是完全 ready 状态。Init 失败清理是唯一目标可达本模块 callee。 |
| Push，125–161 | 按 timeout 取 blank；0 超时失败返回 -1，-1 忽略 obtain 返回值；进入临界区，非满时写 base[rear] 两字段并推进 rear；退出后 abandon data，返回 0。有限 timeout 路径见缺陷记录。 |
| Pop，173–212 | 按 timeout 取 data；0 失败返回 -1，-1 忽略 obtain 返回值；进入临界区，非空时读 base[front]，写 caller 两输出并推进 front；退出后 abandon blank，返回 0。有限 timeout 路径见缺陷记录。 |
| Peak，223–242 | 在锁外读 front/rear 判断非空，非空再锁内读取当前 front 元素，写 caller 两输出并返回 0；空则 -1。并发观察疑点见下文。 |

这些函数只有单次 `do … while(0)`，没有需归纳的遍历循环。循环队列合法索引、持有的资源与进行中 Push/Pop 预订需要区分：Obtain 与修改队列、修改与 Abandon 之间允许抢占，故不能对所有中间状态机械断言 semaphore count 等于当前队列长度/空槽数。成功 Init 可建立静止空队列，但模块生命周期模型不能假定这种等式始终保持。

## 目标闭包候选及复用界限

InitDataqueue 直接可达本模块 DeInitDataqueue；其他模块函数仅用于模块 predicate 的生命周期分析，不自动成为 C 实现证明目标。实现目标数量不在源码阶段冻结：必须按当前调用场景和可复用 contract 适用性重新确定，特别是锁内 semaphore 调用。已识别源码门禁已针对修复副本解除；正式闭包仍须在重新设计、切片/spec 完成后扫描确认。

| 可达项 | 候选分类与待核对事项 |
| --- | --- |
| NULL_PARAM_CHECK | 默认源代码处理的旧版正常返回模型，需完整 caller-local contract，不能声称被验证或提供内存权限。 |
| KPrintf | 根据 TrustBase 去除调试输出。 |
| memset | C 标准库信任/model 边界；须保持全结构清零及 padding 资源。 |
| x_malloc/x_free | xs_memory.h:49/53 与 KERNEL_MALLOC/FREE 精确宏别名；TrustBase 分配器边界候选，须确认 adopted contract 对 size=0 和失败释放的描述。 |
| CriticalAreaLock/UnLock | TrustBase 授权边界；当前 non-SMP 源码 CriticalArea.c:117–138 修改嵌套计数并关/恢复中断。 |
| DISABLE_INTERRUPT/ENABLE_INTERRUPT | xs_isr.h:87–88 映射到 DisableLocalInterrupt/EnableLocalInterrupt；k210 interrupt.c:50–64 只保存/恢复 mstatus。与 CriticalArea API 有实际计数差异，不能直接改名；用户已批准本轮独立 IRQ 可信资源交接边界，范围见 context.md。 |
| KSemaphoreCreate/Delete | 全局 annotated_C/src/kernel/semaphore/ 存在 canonical spec，候选 reused-spec；未导入、未核实证明状态。现有 contract 要求 OutsideCritical，但 Init 调用 create 时已经持锁、DeInit 调 delete 时关中断，适用性需进一步解决。不能只换成 InsideCritical 宣称等价。 |
| DeInitDataqueue | 当前全局未发现 canonical spec，应新写并保留唯一真实 body；为本轮实现目标。 |

实际源码 semaphore.c 的静态 done table 明确 create→_SemaphoreCreate、delete→_SemaphoreDelete。若能够保持语义复用 canonical spec，则在 reused-spec 边界停止递归；当前不能先行宣称已适用。全局 lib 搜索未发现 dataqueue 定义，存在 semaphore、全局 state/critical 等共享定义，后续按最新 skill 只将本轮实际使用且需要修改内容的库放入 trial/lib，未修改的库直接 import 全局版本，不连锁复制依赖；此处不冻结依赖设计。

## 源码门禁当前结论

用户授权的 Init/DeInit 与 Push/Pop 修复均仅应用于副本，原源码缺陷仍存在。Peak 的共享访问保护按默认源码处理规则实施，不作为原算法等价的无条件保证。当前完整版本与检查见 [source-errors.md](source-errors.md) 和 [source-fix-review.md](source-fix-review.md)。这些已识别问题在当前副本均有解决依据，源码门禁针对该副本已解除，main 已独立逐行复核；没有给出 predicate/spec review-passed 或实现证明结论。

配置明确选择全局现有32位非SMP配置及 TrustBase 适配，非声称发现了对应硬件构建；后续保持 ILP32/QCP 布局。复用 semaphore contract 的临界区适用性仍是设计阶段待解决接口事项，不是这里已证明的内容。


## 2026-11-16 重新设计前独立核对

C analysis agent 本次只读检查原源码、当前五份副本及全局/配置参考接口；未访问禁止的旧 trial。原 `data_queue.c` SHA-256 仍为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`。Init/DeInit/Peak hash 与 source-errors 的修复基线一致，Push/Pop 分别为 source-fix-review 当前记录的 `d794484d28ef1324b2859bea7bec59bb9fcd132a28186a8c0532143a6fea1064`、`eaf2bdfb44420f00312c48c00ddd61c88b913d57061dedfbe780b0e82b4ef713`。无需重做已批准修复。

真实调用证据：Init 的两次 KSemaphoreCreate 位于 CriticalAreaLock/UnLock 之间；失败路径解锁后调用 DeInit，DeInit 的 KSemaphoreDelete 位于 DisableLocalInterrupt/EnableLocalInterrupt 之间。semaphore.c 的静态 done table 唯一解析至 _SemaphoreCreate/_SemaphoreDelete。全局四份 canonical contract 均要求 OutsideCritical，不能仅替换为 InsideCritical 声称等价复用。按默认规则消除嵌套锁的 inside 场景须单独陈述契约、推导/实现义务；调用闭包依实际采用的边界继续确定。

早期同步记录曾记载semaphore五个目标的done/final-check和canonical恢复来源；该旧报告现按用户要求删除。此处保留下述历史调查摘要，当前证明适用性和回归结果以[integration-review.md](integration-review.md)为准。当前五组 goal_check 存在，manual 分别覆盖 KSemaphoreCreate 4、_SemaphoreCreate 42、KSemaphoreDelete 3、_SemaphoreDelete 96、LinklistResumeAll 38 个 goal，manual 无 Admitted；auto 的同名占位不能单独视为最终证明缺失。本次没有重新编译全局或执行 QCP，也不把这些 outside 证明追认为新的 inside 证明。

低层复用核对：全局已有 IdGetObj、IdRemoveObj 及 InitDoubleLinkList、DoubleLinkListInsertNodeAfter、IsDoubleLinkListEmpty、DoubleLinkListRmNode 对应 canonical 接口。IdInsertObj 在全局 _SemaphoreCreate.c 中只有 caller-local contract，其中 failure 的 `first_free_id=None` 比配置参考 VRTOS `annotated_C/src/headers/id_module_spec.h` 的原接口更强；不得因该声明存在就称加强项已获 provider 证明。VRTOS 原接口失败只保证 -1 与 manager/待插节点资源返还，成功精确关联 ID 和节点地址，可在无需精确失败原因时原义采用。该 header 标注 provider 为 `crtosverify-id` 的 idnode 分支 commit `12378745b310bfcefb150a6c0e5a5fbfdd95787c`；当前 provider 目录不可用，仅能核查现有导入来源与兼容性，不能宣称本次重查了 provider 的完整证明。当前全局 IdModuleSpec.v 与 VRTOS 同文件相同，idnode.v 的相关 predicate 接口兼容（差异为 import、同义自环名称及追加纯引理）。配置的另一个 crtosverify 旧接口使用不带地址的 idmanager_link，不能与当前接口直接混用。

模块设计仍须表达：结构体20字节（含偏移6–7 padding）、未初始化/陈旧槽、payload 指针不拥有 payload、部分初始化失败码保留、n=0 分配失败与 n=1 零有效容量。Push/Pop 分离的 Obtain、ring 操作和 Abandon 需要预订中状态；ID 缓存不证明并发销毁或复用安全。以上是源码约束，不预定任何撤回设计的 predicate 形式或目标数量。

## 按最新spec边界规则的范围更新（2026-11-16）

本次C行为未变化，源码分析和修复依据沿用。先前关于provider未证VC及模型差异的事实仅记录证明状态，不再据此扩展src。当前新写契约范围与八个导入边界以 [spec-design.md](design.md) 为准；本轮不递归导入ID契约内部的AllocId/InsertObj/GetObj/FreeId/RemoveObj。独立源码核对确认_SemaphoreCreate的sem->link两字段在memset后由frame保留，原InsertAfter的typed占位前置已适用。

## DataqueuePeak 新增规格前源码复核（2026-11-16）

用户本次明确要求设计 DataqueuePeak spec。独立 C analysis agent 核对原 data_queue.c 仍为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`，xs_dataqueue.h 仍为 `fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8`，当前 module_context/DataqueuePeak.c 仍为 `e44ca0f1dd5143fb06bfe15b0be6a4b0a80b96704b0fb498f65aabea2f576900`。源码及批准适配无新变化，沿用既有源码分析/复核，不重做补丁。

以已批准副本为准，CriticalAreaLock 位于 front/rear 判断之前；非空路径在同一临界区读 base[front] 的 data、length，依序写 StartAddr、size 指向的两个输出槽，解锁并返回0。空路径不写输出，解锁并返回-1。两个出口均恢复同一 saved lock。函数不改变 front/rear/max_len/base/两 semaphore ID 或任何数组槽，不访问 payload 内容，也不调用 semaphore API。

全局 annotated_C/src 及配置 VRTOS、crtosverify、LOS_Verify 对应目录搜索只发现 xs_dataqueue.h 的裸声明，没有可导入的 DataqueuePeak spec，故需本轮新 canonical。真实调用闭包仅旧 NULL_PARAM_CHECK 的正常返回模型、按规则去除的 KPrintf，以及已有 trusted CriticalAreaLock/UnLock；不新增其实现 body。

类型保持 ILP32：front/rear/max_len 为 uint16，元素data为const void*，length与输出size为x_size_t（unsigned long、32位）。队首访问的索引合法性和已初始化性须由当前共享ready队列及非空条件导出；仅有数组所有权不代表任意槽都初始化。n=1的ready状态只能走空路径。两个输出槽由caller提供权限，与共享queue资源分离；不能仅因输出为写入用途就无依据要求其入口值已初始化。空路径应保留调用前的输出表示，非空路径保存所观察队首的指针和长度。

本次只更新源码分析记录，未修改 C/formal 或原仓库，未运行 QCP；完整 native predicate 候选及函数支持完成后再进行独立审阅。


## Push/Pop 新范围只读分析与源码门禁（2026-11-16）

原 data_queue.c hash仍为 `a8b12c…`；Push/Pop批准副本分别仍为 `d794484d28ef1324b2859bea7bec59bb9fcd132a28186a8c0532143a6fea1064`、`eaf2bdfb44420f00312c48c00ddd61c88b913d57061dedfbe780b0e82b4ef713`，无新变化，不重做既有修复。两函数均先短临界区缓存Obtain ID，在锁外调用Obtain；失败立即返回-1、不执行ring更新或Abandon。成功后另入临界区：Push仅非满写rear槽/推进rear，Pop仅非空读front槽/写两个caller输出/推进front；条件不满足时实际仍继续缓存对偶ID、解锁、调用Abandon，忽略其返回值并返回0。不得从Obtain成功或ID关联凭空推出预订保证，也不能删除成功后仍满/空的路径。并发销毁/ID复用仍需明确的生命周期或观察条件。

全局及配置三个参考工程的annotated_C/src中，KSemaphoreObtain、KSemaphoreAbandon及两个内部函数没有现成spec，只有xs_sem裸声明。真实done table唯一指向 _SemaphoreObtain/_SemaphoreAbandon，新spec闭包从这四个函数继续调查，未按此前目标数量冻结。

Obtain：负ID或锁内lookup失败返回-1；正value递减返回0；wait_time=0返回-2；否则取得running task、exstatus置0，按PRIO挂起，wait_time>0调用KTaskSetDelay并忽略返回，解锁、KTASK_ASSIGN后读取task->exstatus。最终读取位于锁外，需要后续按共享访问规则最小保护适配，不靠裸指针取得权限。Abandon：负ID/lookup失败返回-1；pending非空则Resume一个队首且不增加value，pending空则uint16 value加1（包括65535到0的实际截断），解锁、必要时调度，返回0。不能假定Abandon总成功，也不能把唤醒效果写成对queue数组的修改。

已发现 **timeout=0错误挂起**，真实CalculateTickFromTimeMs(0)=1，使原Obtain零等待分支不按调用约定工作；独立实际函数体反例及最小修复提案见[source-errors.md](source-errors.md)新门禁节。此门禁发现时曾等待批准；用户现已批准最小补丁并已应用源码处理副本，当前等待main独立复核，见下方更新。

可复用接口调查：VRTOS `annotated_C/src/kernel/common/tick.c:66` 有CalculateTickFromTimeMs纯契约，精确返回tick_from_time_ms，不应改它来掩盖Obtain缺陷。`kernel/task/get_ktask_descriptor.c` 有锁内当前任务指针槽契约；`headers/ktask_set_delay.h` 有for_null_inactive和tick_out_of_bound，须保留实际NULL/inactive、时间窗口以及分配失败条件。`headers/linklist_suspend.h`、`headers/linklist_resume.h`的pendlist_ic只覆盖MsgSend/MsgRecv/Event，不含Semaphore；这是契约语义适用性缺口，不是证明状态问题，不能直接以同函数名当作semaphore接口。后续需调查/设计相应Sem场景及必要调用闭包，而不因来源未证或模型差异自动扩body。当前仅记录发现，未冻结最终依赖范围。


### 零超时门禁处理进展：用户批准且副本已应用

当前新建的 `annotated_C/module_context/semaphore/_SemaphoreObtain.c` 来自权威完整函数，仅应用用户批准的msec=0选择修复；SHA-256 `bfd1a4a4fa37af2895ffb7853d8780949f25fb20d0a8b60362e3209c6e120fd3`。实际副本对照测试通过，timeout0/value0不再挂起或设延时；其他已测路径保持。原仓库与Push/Pop已批准副本均未改，CalculateTickFromTimeMs仍保持原API。Main独立复核前不自行解除增量门禁；后续最小共享读取适配及formal设计尚待其对应阶段处理。本次未运行QCP或修改lib/既有.vo。

## Push/Pop helper契约适用性复核（零超时补丁独立通过后）

零超时补丁已经main独立复核通过；本节只读核查剩余callee接口，不扩大既有源码修复授权。

**LinklistSuspend/Resume的Sem场景须新写契约。** VRTOS `headers/linklist_suspend.h`、`headers/linklist_resume.h` 的 `pendlist_ic` 不是任意等待链接口：`lib/pendlist/Pendlist.v` 的target只有MsgSend/MsgRecv/Event，且pendlist_update明确要求semaphore状态不变。因此无法以Sem地址实例化或将其原义作为Sem场景特化。所需body直接来自当前linklist.c；内部SuspendKTask、KTaskWakeup、DLL操作仍采用适用既有契约边界，不递归它们的函数体。

LinklistSuspend真实顺序为先调用SuspendKTask（忽略返回），再按flag插入；当前Obtain调用固定PRIO=1。需要合法任务登记、可移交的sched_link及非service条件，不能把被忽略的Suspend返回强写为成功。PRIO遍历在 `new.cur_prio < current.cur_prio` 时停止，因此扫描前缀满足 other.cur_prio <= new.cur_prio，首个后缀满足 new.cur_prio < other.cur_prio，相等优先级保留原先节点在前。VRTOS LinklistSuspend.v的linklist_priority_insert关系使用相反比较方向，不能复制为当前源的Sem效果。该问题是参考关系不适用，不是本轮源码新增缺陷。

LinklistResume只读非空队首，调用KTaskWakeup并返回0，不写task.exstatus；可使用全局 `kernel/semaphore/LinklistResumeAll.c` 中已经声明的 `KTaskWakeup.semaphore_pending_head_ic`。它保留唤醒任务exstatus、取消delay并转READY，不能把这个效果替换成简单删一个pending地址而遗漏task/ready/delay变化。SuspendKTask可使用VRTOS `kernel/task/ktask_suspend.c` 的IC契约；目标任务的ID关联、具体状态及Delay条件仍须在调用处建立。

**KTaskSetDelay当前参考成功契约尚不适用于权威源码。** 当前 `kernel/thread/delay.c` SHA-256为 `96bae0517d57db4dd5b960a0bc88fa1b096b15eca5d0c69224d6b93f309e0961`，仍用普通无符号绝对deadline比较，也没有半区间超长参数拒绝；VRTOS `ktask_set_delay.c` 已使用模减比较和 `ticks>=TICK_SIZE_MAX/2` 的-INVALID路径，其header的for_null_inactive效果采用回绕排序。具体不等价例子：now=0xfffffffe，旧deadline=0xffffffff，本次ticks=3（100Hz下ms=30可达）；新deadline=1，当前源插到旧节点前，而参考效果把旧节点放在前。旧队列window和本次合法时长前提在此均满足，所以不能仅有NULL/inactive+window便复用该Ensure，也不能静默另加no-wrap前提掩盖差异。该适用性缺口已通知main及作者，待其处理；本节不批准修复或新建其body。

KTaskSetDelay的malloc失败路径同样不能丢：NULL delay时可能返回-5、保持原状态；Obtain忽略此返回，仍在pending中并继续调度，不应承诺一定建立有限超时。Suspend成功通常会取消原active delay，但未取消/已SUSPEND等允许情形必须按实际导入关系说明；NULL/inactive以及全队列时间窗口都不能仅凭“调用者刚挂起”一句话推出。

当前可追溯来源SHA-256：CalculateTickFromTimeMs的VRTOS `kernel/common/tick.c` 为 `7610c797e41c928e2156fc318a73b13662a69cf3d88d2b0db850614f5303723d`；GetKTaskDescriptor的 `kernel/task/get_ktask_descriptor.c` 为 `0882837652a96e8b72fccf22ceb0db461c7502c157393ec591eee283c1fa329f`；SuspendKTask的 `kernel/task/ktask_suspend.c` 为 `f58df5401a5c34a552171129f9f6af4202e873dbfd35ab7ec4ebfe9f1367019e`；SetDelay待解决来源header为 `eef17ae9c96644bf1127688daaf3bbc588b40dd4a0089265e52132848f3e14ee`；全局Wakeup来源 `kernel/semaphore/LinklistResumeAll.c` 为 `29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05`。读取到来源及其contract不等于本轮已证明其函数体。


### 当前等待路径调查收敛：两项新增源码门禁

SetDelay成功契约差异已进一步确认为可观测源码问题：真实SetDelay/UnsetDelay/CheckTaskDelay及DLL函数体反例显示，回绕deadline=1被排到旧deadline=0xffffffff前，阻挡旧任务按时唤醒，旧任务晚2ticks；仅比较器提案的对照按时唤醒。测试与限制、可审阅diff见[source-errors.md](source-errors.md)对应新门禁。此提案未获授权，未应用正式C。

另确认有限等待分配失败处理缺陷：running task的delay=NULL、sem.value=0时，先挂起入pending，再SetDelay分配失败返回-5，Obtain忽略返回而继续调度；任务没有Delay节点，若无其他唤醒来源就不会因有限timeout结束。不能以任意返回值或强制分配成功前提绕过。当前仅记录检查返回、撤回pending并恢复可运行状态的修复方向，不额外实施算法修改。

零超时已批准补丁及其main复核保持有效；这两项独立新问题均为needs-fix且未批准。调查阶段只补源码记录，停止新设计通过结论，等待main向用户交付原因和决定后续范围。原源码/global formal只读，未运行QCP。
