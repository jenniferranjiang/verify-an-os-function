# 完整闭包 Spec 独立审阅

结论：**review-passed**。审阅对象为 S1，`checks/spec-manifest.sha256` 的 SHA-256 为 `b7bb9700ea681eab8d7d2a2713ebb5d82b7aa00900fdc27a1ca20ff6ae9384ed`，覆盖 9 个 canonical C 文件及 3 个 include 文件。固定依赖 P1 **review-passed**：`cf17462f93b883ac756270977ee6484c105d16260bc9507c7fb1fac6697aff52`。本次由独立 reviewer agent 审阅 main agent 编写的 spec；两份清单和当前文件哈希均重新核对一致。

逐份对照当前 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/{semaphore,id,double_link,CriticalArea}.c` 的原始定义、相关 headers、`board/stm32f103-nano/config` 与 config.mk。四个源文件哈希与 `checks/source-locations.json` 一致。宏证据确认 NULL_PARAM_CHECK 实际开启并永久循环；KDBG_IPC=0；semaphore.c 自己把 KDEBUG_NOT_IN_INTERRUPT 置空；done 的唯一创建目标为 _SemaphoreCreate。切片保留所有执行次序、返回与副作用；只有已记录的宏展开、static 外部化、固定 dispatch 直呼以及 IdInsertObj 赋值/条件拆句。类型声明保留全部相关字段及真实 ILP32 offsets，没有错误精简布局。

人工从 KSemaphoreCreate 重新检查所有直接调用、dispatch 和宏展开后调用，闭包恰为 9 个非 trusted 函数与 6 个批准 trusted 函数。9 个非 trusted symbol 各有唯一同名 active body 与直接可读 canonical With/Require/Ensure；非 trusted 的 caller-local contract 与对应 canonical 一致，所有真实 callee 均有完整声明约定。CriticalAreaLock 和 CriticalAreaUnLock 保持非 trusted，未扩大边界。loop 宏没有被伪造成新的 canonical function。logic.h 只给逻辑接口名称，未集中隐藏函数约定。

上层 KSemaphoreCreate/_SemaphoreCreate 的同一约定覆盖 malloc 失败 -5、ID 耗尽并回收后 -5、成功 0..127，包含 ID=0、value=0 与 65535。外层与已有临界区的嵌套调用分别使用全局状态集合操作和精确状态操作；全部路径返还实际 IRQ 状态及相应协议资源。malloc 失败没有凭空进入临界区。创建成功只改变 semaphore 分量，其他抽象分量由 reviewed replace_semaphores 保持；计数变化通过独立 nest 关系描述。未添加非 ISR、IRQ 初始开启、nest 为零/小于65535或空系统要求。

逐层 ownership 和行为检查结果：

- AllocId 的两处 -1 均无写入，成功为最小空闲 ID 且只置对应 bit，canonical 保留 manager 和未改桶。通用尾部越界路径留在完整 body；固定128配置并不被用来删掉它。
- IdInsertObj 的失败保留 idnode 原值，因此创建失败对象仍为完整清零的私有对象；成功消耗 idnode 的 id/link 所有权并连入正确桶。InsertObj 的未初始化桶与已初始化桶两条路径均覆盖。
- InitDoubleLinkList 消耗完整两个指针槽并建立自环；DoubleLinkListInsertNodeAfter 维持源码四次写入顺序，允许空链 old-next=head 的 alias。新节点独立性来自分离所有权，没有额外要求 old-next 与 head 不同。
- Semaphore 的 ID 字段、ID link、管理 link、value、pend_list 与 padding 逐步转移，既无重复 owner，也没有解锁后的 sem load。调用 where 使用 acquired/old_n，以及成功发布后的状态；给定的逻辑参数与实际 callee 前后状态对应。
- 两个 critical wrapper 的实际计数 load/store 由 slice_OS_inv 支持；uint16 ++ 模65536，退出只在非零时递减。65535→0→0 未被误写为恢复入口计数，IRQ 恢复与计数恢复分开。
- NULL guard 分支明确在 Require 中允许，随后 KPrintf 和无限循环保留；Ensure 只描述能返回的非空路径。这是 partial correctness，对非返回行为没有虚假终止承诺。

六个 trusted caller-local contract 与用户批准语义逐项一致：x_malloc 只对本次32字节对象承诺 NULL 或完整未初始化 ownership；memset 完整清零并返回dest；x_free 消耗完整清零且未发布的私有对象；DisableLocalInterrupt/EnableLocalInterrupt 记录真实 PRIMASK 并依据全局协议转移/返还资源，嵌套时保留既有资源；KPrintf 为 emp 到 emp。本次没有递归读取或证明这些函数体，也没有把它们称为已验证。

检查证据：P1 的 13 个 Rocq 文件编译通过；`checks/spec-interface-check.log` 对当前头文件的58个 Extern 声明和4个实际 safeExec 组合完成 Rocq Check，exit 0；`checks/c-syntax.log` 对9个切片完成 ILP32 C 语法/类型检查。`checks/layout-check.log` 根据当前真实 headers 检查了32字节 Semaphore 及其字段布局。没有 ARM 工具链，因此没有声称运行 Cortex-M3 交叉编译。注解语法按现有工程写法人工检查，没有运行 QCP parser。

本结论仅为设计审阅通过。未启动 verification-orchestrator、closure script、symbolic、VC 或 C 实现证明；原函数仍为 **not-verified**。后续的布局符号接入、循环不变量与调用组合证明不被报告为已经完成。历史 trial 的隔离执行偏差已在 [predicate-review.md](predicate-review.md) 如实记录：一次文件名枚举输出旧路径，没有读取或依赖旧内容；本次 spec 审阅仅使用上述白名单材料。
