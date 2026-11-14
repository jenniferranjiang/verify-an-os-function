# KMutexDelete 当前 spec 设计

状态：公开入口修订版经独立影响复查为 `needs-fix`，原通过结论对受影响部分已 invalidated，见 [spec-review.md](spec-review.md)。设计通过不代表实现证明。未运行 QCP/parser/closure script/symbolic/VC/proof。

本次按用户要求删除 _MutexDelete 与 LinklistResumeAll 入口中的 exists obj，
也不把 obj 放入 With。公开入口由 safeExec 和 OutsideCritical 组合；等待链
helper 仅保留实际 list 参数与目标 pending head 的对应。三个 abs program
增加 sg 参数，对象存在性和注销时空 pending 由原生 assertS 检查，NULL 删除
路径由 assume 对应不正常返回语义。caller-local 契约、逻辑头和 ExternCheck 同步。
当前 True rely 对 checked 条件可满足性的限制见 predicate-design；该问题经独立
复查确认仍未解决，当前版本不能获得新的通过结论。

正式输入为 `annotated_C/src/{KMutexDelete,_MutexDelete,LinklistResumeAll}.c`；同目录两个头文件只定义类型及 Rocq 导入/符号，不汇集 API contract。目标全局路径分别为 `src/kernel/mutex/KMutexDelete.c`、`src/kernel/mutex/_MutexDelete.c`、`src/kernel/mutex/LinklistResumeAll.c`。当前不合并到根目录。

## 范围与来源

当前 32-bit 非 SMP、RR_REMAINSLICE、32 priority、128 mutex ID 配置。用户已批准的 A1–A3 是执行环境限制：lookup 到撤销登记期间不发生竞争删除/释放/ABA；排空后到撤销登记不重新入队；不会有跨越销毁的未完成 obtain/abandon/delete 裸指针使用。这些不是源码修复，也不是普通 Lock 的保证。所有结论仅针对满足限制的执行；ordinary `Crtos_RTrans`、`os_inv`、`InsideCritical`、`OutsideCritical` 直接复用，未加 delete-specific Lock 或 invariant。

| 原输入 | SHA256 |
|---|---|
| `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c` | `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645` |
| 同目录 `linklist.c` | `d64d3275b6d936f46352bc4625fc11efc9e0b113ca838f60a98eabaa09a7342c` |
| `annotated_C/src/include/xsconfig.h` | `e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28` |

## 完整可达闭包（人工按实际 body 调用扫描）

| Caller | 直接调用 | 边界 |
|---|---|---|
| KMutexDelete | CriticalAreaLock, CriticalAreaUnLock | TrustBase ordinary critical API |
| KMutexDelete | IdGetObj | reused-spec，根 `kernel/id/IdGetObj.c` |
| KMutexDelete | CONTAINER_OF_MUTEX_ID | TrustBase CONTAINER_OF model，id offset 0 |
| KMutexDelete | _MutexDelete | 本轮新 canonical body/spec |
| _MutexDelete | NULL_PARAM_CHECK_1 | skill 源代码处理模型，空输入不正常返回 |
| _MutexDelete | LinklistResumeAll | 本轮全新 mutex 场景 canonical body/spec |
| _MutexDelete | CriticalAreaLock, CriticalAreaUnLock | TrustBase ordinary critical API |
| _MutexDelete | IdRemoveObj | reused-spec，根 `kernel/id/IdRemoveObj.c::low_level_spec` |
| _MutexDelete | DoubleLinkListRmNode | reused-spec，根 `headers/m_double_linklist.h::remove_member` |
| _MutexDelete | x_free | TrustBase KERNEL_FREE API 的实际宏展开 symbol |
| LinklistResumeAll | NULL_PARAM_CHECK_1 | 同一 skill 模型 |
| LinklistResumeAll | CriticalAreaLock, CriticalAreaUnLock | 同一 ordinary critical API |
| LinklistResumeAll | CONTAINER_OF_TASK_SCHED | TrustBase CONTAINER_OF model，sched link offset 16 |
| LinklistResumeAll | KTaskWakeup | reused-spec，revision `8a16fffe3e029b56de598baa16f43865da85b92b:annotated_C/src/headers/ktask_wakeup.h::wakeup_by_id_ic` |

不递归复用/API 边界的内部实现，不给这些 callee 新建函数体文件，不宣称它们是本轮已证明结果。KTaskWakeup 通用 step 已包含 mutex/event/semaphore pending removal；使用原 IC spec，而非新增 mutex 特化。当前 full provider 恢复兼容性由 predicate 构建记录说明。

复用 spec 基线 SHA256：IdGetObj `6f5447b61e00e565c578815331e1b9c4d777a6b70e17f6a653a73dc6f9349cae`；IdRemoveObj `5694b0d103788e448d12bb48a1090312f54e0760c2fc09bf6c576e5104a49bf7`；m_double_linklist.h `8e67a7da9673c31ca64c330eac42066d37ef2c6257c7323792659a6580435a40`。导入正文仅排版调整。KTaskWakeup 历史复用一致性证据见根 `.docs/checks/trial-maintenance-20261101/sync.json`；不能以这份复用核对记录声称本轮完成实现证明。

KTaskWakeup 的历史 C 文件导入 `CRTOS_Verify.libai.KTaskWakeupProof` 与 `GetTaskWithIdnodeInside`，但这两个源码不在所固定 8a16 Git tree 中；其 wrapper 注释涉及历史 query publication 假设，完整旧 proof/axiom chain 未核实。本轮只使用既有设计 contract 的 reused-spec 边界，不宣称旧证明无额外假设。本次调用点的 publication 有独立依据：`CrtosInv.os_sched_owners` 包含 mutex pending；`os_wf_sched_domain` 推出 task_desc_map 已发布；已证 `os_sched_owners_in_task_list` 与 `TaskInv.task_wf_id_nodes` 将实际 task 的 ID 节点连接到 manager；`store_idmanager` 拥有读取的 ID 字段。因此 pending 队首的 publication/ID 查询对应须作为后续明确的局部推导义务完成，不引入新的 query→published 公理。

## 路径、effect 与 ownership

- KMutexDelete：负 id 不加锁直接返回；非负 id 隐式转 uint16 查询（保留 65536→0 等行为）；未命中解锁返回；命中在解锁后调用 pointer-only _MutexDelete。未增加 id<65536 前提。
- _MutexDelete：公开目标只有 C 指针，不在 With 或 Require 引入 ID；体内从当前对象取得 ID 供 IdRemoveObj 使用。先排空等待队列，再单独加锁撤销 ID 和管理 DLL，解锁后消费 MutexRaw 调用 free。不存在重调度或 holder 优先级恢复。
- LinklistResumeAll：保留自己真实的 Lock/Unlock；空 pending 返回 0；非空循环写 exstatus=-1，调用 KTaskWakeup 并忽略返回。共享 invariant 保证 pending task 为已发布 SUSPEND task，因此本场景是成功唤醒。公开 abs_linklist_resume_all 使用整批前后态关系，表达清空、任务 READY/exstatus、取消延时、RR ready 插入及其他状态保持；逐头关系仅供后续循环精化。
- 原源码 NULL_PARAM_CHECK 的非返回路径保留为 skill 模型。_MutexDelete 与 LinklistResumeAll 另有 null_only partial-correctness spec，空输入的 Ensure 为假（不承诺终止）；对象有效域现由 safeExec 引用的抽象程序检查，不在正常入口重复量化 obj。
- 资源全部来自复用的全局 os_inv；任务字段、延时与 ready 资源由对应模块拥有。删除完成后对象先从全局 invariant 脱离到 MutexRaw，再 free，不与全局重复拥有。未改资源由抽象 replace 操作和空间 frame 保存。

## 源码适配与结构检查

仅进行：TrustBase debug 宏移除；固定 done.MutexDelete initializer 解析为 _MutexDelete；static 函数导出为切片外部 symbol；CONTAINER_OF 两个布局模型；NULL_PARAM_CHECK 使用 skill 模型。未移动任何临界区、未改算法或返回码。KERNEL_FREE 在 `kernel/include/xs_memory.h` 及当前适配头中定义为 x_free，未增加新 allocator trust。

x_free 的 mutex_object contract 与根 `kernel/mutex/_MutexCreate.c` 已有接口一致。MutexRaw 在 provider `MutexInv.v` 中覆盖 ID、所有字段、两个 DLL 与 [2,4) padding 的完整36字节；它本身不证明分配来源，沿用原 allocator API 对对象分配基址的信任边界。detach→MutexRaw 是待实现的空间重组义务，不作为已证明事实。

2026-11-10 `gcc -m32 -std=c11 -fsyntax-only -Wall -Wextra` 对三个 C 文件 exit 0。仅模型 NULL_PARAM_CHECK_1 的 declaration-only inline 警告，非语法错误。stdin `_Static_assert` 通过：Mutex size36，id/value/recursive/origprio/holder/pending/link offsets0/12/14/15/16/20/28；TaskDescriptor size120，sched16/exstatus92/id104/idlink108；IdNode/IdManager size12，DLL node size8。检查没有输出对象文件，不是 QCP 或实现证明。

2026-11-10 predicate 作者完成三个本地 Rocq 文件构建。Spec 作者独立复跑临时 ExternCheck.v，使用本 trial `_CoqProject` 的全部 -R/-Q 及指定 pv-bench-8.20.1 coqc，exit 0；检查覆盖头文件所有 Extern 符号、Record projections 与完整类型，包括 safeExec、MutexRaw、ID manager 接口、mutex_pending_head 和三个公开 abs program。检查中发现并修复了头文件缺失 Coq.ZArith.ZArith、Coq.Lists.List、SimpleC.SL.Mem 显式导入的问题。该检查仅做 Rocq 符号/类型核对，不是 QCP 注解解析或实现证明。

修改前的独立审阅结论已对受影响部分 invalidated，当前修订已按新 formal hashes 完成独立影响复查，结论 needs-fix。可重跑的接口类型检查输入保存在 `checks/ExternCheck.v`。本次按用户要求仅进行设计和审阅，不进入 implement。

公开入口修订后，三个 C 文件重新通过 GCC ILP32 语法检查（仅 NULL 模型的
declaration-only inline 警告）。QCP/provider/本地三个 Rocq 文件的构建和
更新后的 checks/ExternCheck.v 均实际 exit 0；两份当前 source manifest 的校验
均通过。独立影响复查已确认 caller-local 契约与 canonical 一致。当前 needs-fix
由语义检查的可满足性缺口导致，不是编译或声明不同步。
