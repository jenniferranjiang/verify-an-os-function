# InitDataqueue 全新源码分析

本记录由独立 C analysis agent 从当前源码重新分析；未读取旧 trial。当前状态：**用户授权的源码缺陷已在验证副本修复，针对性检查通过；Peak 共享访问疑点已按默认规则在副本适配。源码门禁针对该副本版本已解除，main 已独立逐行复核；尚未编写 predicate/spec、未导入复用 contract、未启动 QCP**。分析日期 2026-11-15。

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

本轮新实现目标候选为 **InitDataqueue、DeInitDataqueue**。其他模块函数仅用于模块 predicate 的生命周期分析；不自动成为 C 实现证明目标。已识别源码门禁已针对修复副本解除；正式闭包仍须在重新设计、切片/spec完成后扫描确认。

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

实际源码 semaphore.c 的静态 done table 明确 create→_SemaphoreCreate、delete→_SemaphoreDelete。若能够保持语义复用 canonical spec，则在 reused-spec 边界停止递归；当前不能先行宣称已适用。全局 lib 搜索未发现 dataqueue 定义，存在 semaphore、全局 state/critical 等共享定义，后续按当前 skill 将所需项目库及项目内传递依赖准备到 trial/lib，再原样复用或按需增补；此处不冻结依赖设计。

## 源码门禁当前结论

用户授权的 Init/DeInit 与 Push/Pop 修复均仅应用于副本，原源码缺陷仍存在。Peak 的共享访问保护按默认源码处理规则实施，不作为原算法等价的无条件保证。当前完整版本与检查见 [source-errors.md](source-errors.md) 和 [source-fix-review.md](source-fix-review.md)。这些已识别问题在当前副本均有解决依据，源码门禁针对该副本已解除，main 已独立逐行复核；没有给出 predicate/spec review-passed 或实现证明结论。

配置明确选择全局现有32位非SMP配置及 TrustBase 适配，非声称发现了对应硬件构建；后续保持 ILP32/QCP 布局。复用 semaphore contract 的临界区适用性仍是设计阶段待解决接口事项，不是这里已证明的内容。
