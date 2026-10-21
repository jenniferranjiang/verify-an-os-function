# KSemaphoreCreate 完整闭包 spec

本次设计仅对应当前权威源码及 stm32f103-nano 配置。Predicate 固定为 **P1 — review-passed**，清单摘要 `cf17462f93b883ac756270977ee6484c105d16260bc9507c7fb1fac6697aff52`；见 [predicate-review.md](predicate-review.md)。Spec 当前为 **S1 — review-passed**，清单摘要 `b7bb9700ea681eab8d7d2a2713ebb5d82b7aa00900fdc27a1ca20ff6ae9384ed`；独立结论见 [spec-review.md](spec-review.md)。具体文件内容以 `checks/spec-manifest.sha256` 固定。正式函数约定只写在 annotated C，不在本文复制。

## 闭包与函数层次

重新人工从 KSemaphoreCreate 扫描所有当前配置下可达调用，结果与 [source-analysis.md](source-analysis.md) 的 9+6 表一致。每个非 trusted symbol 在 `annotated_C/src/` 恰有一个同名文件、一份真实完整 active body 和 canonical With/Require/Ensure。callee 的完整 declaration-only contract 位于 caller 文件的定义前，与该 callee 的 canonical 文本保持一致；没有模块级 specs.h、裸调用或未解析分派。`include/logic.h` 仅声明类型及 predicate/program 名称，不放任何 C 函数约定。

| 层次 | Canonical 文件 | 返回、阻塞与资源 |
|---|---|---|
| 对外与实现入口 | KSemaphoreCreate.c、_SemaphoreCreate.c | 分配失败 -5；ID 耗尽回收后 -5；成功 0..127。两种临界区模式，返回原 IRQ 位，嵌套保留外层锁及更新后的模块 |
| 临界区计数包装 | CriticalAreaLock.c、CriticalAreaUnLock.c | 不列为 trusted；++ 的 uint16 回绕与条件 -- 全部保留，保存/恢复实际 IRQ 位 |
| ID 登记 | IdInsertObj.c | 最小可用 ID 的登记成功消费 node；耗尽返回 -1 且原 node 精确保持；两个 NULL 检查均有真实无限路径 |
| 位图分配 | AllocId.c | 返回最小空 ID；全位图满与尾部越界两处 -1 均保持 manager；NULL 无限循环 |
| 哈希桶插入 | InsertObj.c | 按 id%hoffset 定位；零指针桶先初始化、已有桶直接插入；NULL 无限循环 |
| 局部 DLL | InitDoubleLinkList.c、DoubleLinkListInsertNodeAfter.c | 自环初始化及头后插入；空链 old-next==head 合法，插入节点由分离所有权排除重叠 |

NULL helper 的 Require 显式包含空指针分支，Ensure 只允许非空返回；这是 partial correctness 对实际 `KPrintf` 后永久循环的表达，不声称其终止。创建正常路径的 manager 与 node 非空来自具名全局对象及 allocator ownership。固定128 ID时 AllocId 的尾部越界分支不可达，但 generic canonical body 和失败约定保留该路径。value 的全部 uint16 输入及成功 ID 0 都被包含。

## Trusted 边界及调用逻辑参数

Trusted 恰为六个用户批准的 symbol，未递归读取或处理其函数体。

- `_SemaphoreCreate.c` 中 x_malloc 只针对 sizeof(Semaphore)=32：NULL 不交出对象，成功交出完整未初始化对象；memset 仅完整32字节清零且返回dest；x_free 只消费完整清零未发布对象。失败路径在 x_free 前没有字段或链表写入。
- `CriticalAreaLock.c` 中 DisableLocalInterrupt 返回真实原 PRIMASK，关闭中断并按已有持锁模式取得或保留资源。
- `CriticalAreaUnLock.c` 中 EnableLocalInterrupt 消费计数已经递减后的共享资源，按调用模式归还或保留全局锁，恢复保存位。IRQ 和计数不同，65535回绕不会被误报为恢复原计数。
- KPrintf 在所有 caller 中均为 emp 到 emp，无受验证状态修改；包括真实 NULL 分支和语法保留的 if(0) 日志。

所有带 With 的 callee 在调用处有 where 参数。Lock 的存在量 acquired/old_n 供 subsequent ID 操作与 Unlock 使用；失败解锁归还 acquired 状态，成功解锁归还按具名发布操作计算的状态。KSemaphoreCreate 和 _SemaphoreCreate 使用相同的外层/嵌套 canonical 约定。

## 内存追溯及 frame

- x_malloc/memset/x_free 使用 `sem_allocated` 与 `sem_zero`，覆盖对象32字节和两段padding。
- IdInsertObj 使用 `store_idmanager` 与 `idnode_private`；AllocId 读 manager 配置和 bitmap，在成功后返回 `store_idmanager_allocated_unlinked`，哈希桶及其他字节保留；InsertObj 从该中间态连入 ID 桶，恢复完整 manager。
- IdInsertObj 成功后 private remainder 保留 value、padding、pend_list 与全局link。value赋值和 pend_list初始化建立 `sem_ready_to_publish`，全局链插入后合入 `semaphore_inv`。没有把 ID-chain、全局链和对象payload重复归属。
- DLL 的 canonical 只暴露本原语必需的局部链形状；上层 ID/创建约定使用模块与对象 predicate。既有 DLL 节点在本闭包所有调用点已经清零或属于有效链，旧指针值对插入/初始化不作额外条件。
- KTaskOsAssignLockNest 的读写由 `slice_OS_inv` 中唯一 ushort 单元支持，关闭中断后递增、恢复中断前按条件递减。该 slice invariant 包含本次完整 semaphore 模块；未触达系统内存由分离逻辑 frame 保留，不要求复制整个任务或调度子系统。
- 外层经过临界区的 effect 由具名 abstract program/continuation 表达；嵌套还直接关联 before/after 与计数关系。只替换 semaphore 状态，其余全局抽象分量保持。malloc 未成功时不虚构加锁步骤。成功解锁后无 sem 字段 load。

## 等价归一和检查证据

沿用源码报告列出的宏、static、dispatch 归一。本次新增唯一可执行写法调整：IdInsertObj 原 `if ((id = AllocId(manager)) < 0)` 拆为先赋值、再判断，求值次数、顺序、副作用和两个 return 不变，便于在调用后写 where。

`checks/c-syntax.log` 记录9个文件以 gcc -m32 -ffreestanding 完成 C 语法/类型检查，含完整 caller-local prototypes，无隐式callee声明。`checks/layout-check.log` 基于真实头文件检查32位布局；本机没有ARM/newlib工具链，故不声称执行了Cortex-M3交叉编译。memset保持标准size_t声明，取自stddef.h，不用x_size_t替换。Rocq定义与两类safeExec检查见 `checks/predicate-compile.log`；Extern Coq接口交叉检查另存 `checks/spec-interface-check.log`。

本阶段没有运行QCP parser、closure script、symbolic、VC或C实现证明。循环不变量的symbolic接入、字节/字段桥接和调用组合证明仍属实现工作，不被标成已完成。设计审阅的通过状态由独立 [spec-review.md](spec-review.md) 决定。
