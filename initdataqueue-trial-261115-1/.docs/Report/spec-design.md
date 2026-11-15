# InitDataqueue spec 设计（draft）

当前尚无 review-passed revision；本记录不是人工确认请求。未运行 QCP parser/symbolic、VC 或实现证明。仅当前 trial 的源码副本和设计输入可修改，原仓库只读。当前源码重启点已由 main 核对，来源与批准修复见 context.md 和 source-errors.md。

## 必要调用闭包与独立设计变更

Init 在 CriticalAreaLock 与 UnLock 之间调用 KSemaphoreCreate；失败后解锁再调用 DeInit，后者在 DisableLocalInterrupt 与 EnableLocalInterrupt 之间调用 KSemaphoreDelete。两 wrapper 的 done-table 在权威 semaphore.c 静态初始化为 `_SemaphoreCreate` / `_SemaphoreDelete`。

现有全局四份 semaphore canonical 只有 OutsideCritical 入口。当前配置的三个参考工程 annotated_C 搜索仅找到 semaphore 的裸声明，没有另一个可用 IC contract。锁外 spec 不能仅换 token 就当作锁内特化：旧入口需要 OutsideCritical，新调用点已经拥有共享 invariant。此处不把旧 proof 当作新 IC 契约的证明。

按 spec-writing-guide §4.2“若不存在适用且已经证明的 low-level spec……先按真实 C 行为另行完成 low-level spec 的设计、审阅和实现证明”，本轮新增独立 IC low-level 草案与真实函数体。原 OC 文件和含义在全局来源中保持；去除嵌套锁后的 trial body 只标新 IC contract，不把原 OC 也挂在已去锁 body 上。源代码处理规则允许注释 callee 内嵌套进入/退出。该独立设计变更连同最终 revisions 交用户决定；当前未获实现授权，不称为语义等价导入或已有 proof 覆盖。

预计本轮新实现输入为 InitDataqueue、DeInitDataqueue、KSemaphoreCreate、_SemaphoreCreate、KSemaphoreDelete、_SemaphoreDelete；这由当前调用点重新确定，不继承旧目标数量。最终完整闭包须在正式 spec 全部写出后重新扫描。

DeInit 本轮 contract 计划覆盖 Init 失败时私有队列的回收，而非一般已共享队列的并发销毁。非负 ID 对应未有等待者且未被已发布队列引用的 semaphore；释放前后的 unlock 窗口须由外层 checked observation 条件承担，不可假设 rely 自动保持这些事实。完整模块 predicate 仍覆盖共享生命周期。

## 已写出的依赖候选

四个 semaphore 输入均位于 `annotated_C/src/`，新 IC contract 直接在 canonical 定义前，caller-local wrapper contract 与 canonical 一致。锁 token 是 caller frame，callee 只借用 `os_inv`，返回精确操作后的 `os_inv`。

Create 的失败结果是 -5，抽象共享状态不变；成功返回最小可用 ID，发布初始 value 与空等待链。分配失败与 ID 分配失败的 private allocation 都不泄漏。`IdInsertObj` 导入 `annotated_C/src/headers/id_module_spec.h` 的实际接口，不沿用全局 `_SemaphoreCreate.c` 中额外加强的“失败时必满”断言；因此完整 create effect 用分配失败允许的保守失败选择，保留成功时最小 ID 的保证。

Delete 的 IC 草案只用于 quiescent、未被 published queue 引用的 ID；保留全部真实分支。空 pending 前提使 `LinklistResumeAll` 和 `KTASK_ASSIGN` 分支在本轮调用域不可达，仍保留完整 caller-local API，不删原 body 分支。负 ID 或查无 ID 不改变抽象状态；找到 ID 时摘除 ID/管理链并释放对象。不能把抽象状态不变说成 lazy bucket 初始化前后的所有字节不变。

Rocq 新增接口位于 `lib/KSemaphoreCreate.v`、`lib/KSemaphoreDelete.v`，分别是原库的按需副本与 IC 增补；文件首注释记录复制基线。当前未完成 Rocq typecheck，不给审阅通过结论。

## 来源版本与边界候选

下列路径相对验证工程根目录；哈希为本轮读取版本。`reused-spec` 只表示采用既有接口为本轮证明边界，不代表已重新检查或证明整个提供方实现。来源的实际证明与适用性还需在候选冻结前核对。

| 来源 | SHA-256 | 用途 |
|---|---|---|
| annotated_C/src/kernel/semaphore/KSemaphoreCreate.c | 327769e9d7769fb1c630d74245e76ff24a3a7057f551cfb47e26468716072ead | 原 OC 依据，新 IC 非复用 |
| annotated_C/src/kernel/semaphore/_SemaphoreCreate.c | 1521af39810c3bc745e81800ac6ea3d38a761116e82522b0c3ecc684f878659b | 原 OC 与当前body适配依据 |
| annotated_C/src/kernel/semaphore/KSemaphoreDelete.c | ef7c27f4fbfa0aab7c3b1039fa488da9e4b82f6d92be6129c462da1b85860c83 | 原 OC 依据，新 IC 非复用 |
| annotated_C/src/kernel/semaphore/_SemaphoreDelete.c | 57b74d9f9318b92a3722bd5d4366d875f8fe670d98b6a5540ffa0a8bacca5901 | 原 OC 与当前body适配依据 |
| annotated_C/src/headers/id_module_spec.h | 2f293057ec98604ae558d528291db8ebc0081975aa3bdb741298730adc085fea | IdInsertObj imported contract；provider commit 12378745b310bfcefb150a6c0e5a5fbfdd95787c |
| annotated_C/src/kernel/id/IdGetObj.c | 6f5447b61e00e565c578815331e1b9c4d777a6b70e17f6a653a73dc6f9349cae | reused-spec候选 |
| annotated_C/src/kernel/id/IdRemoveObj.c | 5694b0d103788e448d12bb48a1090312f54e0760c2fc09bf6c576e5104a49bf7 | low_level_spec reused候选 |
| annotated_C/src/kernel/list/InitDoubleLinkList.c | 773d1d5b00d9072336041b088154b3449e6a978165917abfe9f2cc88916ecd49 | reused-spec候选 |
| annotated_C/src/kernel/list/DoubleLinkListInsertNodeAfter.c | 9b27c23929a553aacb58221941b18f37ac08b5e8433cbe2a68c398da9eab6a81 | dispatch_case reused候选 |
| annotated_C/src/kernel/list/IsDoubleLinkListEmpty.c | 4b22b601357f81ec24f89cdcfd28a186b27fc7d9db2c7930811c5cc9b14ef1ca | dll reused候选 |
| annotated_C/src/kernel/list/double_link_remove_member.c | de6b677d837aff8ad14bc3ac26a29080f0fbe3eb756082567958529c2e9d3071 | remove_member reused候选 |
| annotated_C/src/kernel/semaphore/LinklistResumeAll.c | 29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05 | semaphore_waiters IC reused候选，受本轮调用域排除 |

标准库 memset 与 KERNEL_MALLOC/FREE 宏别名依 TrustBase；CONTAINER_OF 依 TrustBase 模型；旧 NULL_PARAM_CHECK_1 与 KTASK_ASSIGN 依当前源码处理规则；CriticalArea 与 IRQ 边界分别依 TrustBase 和本轮已批准授权。每个正式调用处仍需完整 API contract。

## 当前检查

四个新增 semaphore C 输入通过 GCC `-m32 -std=c11 -Wall -Wextra -Werror -fsyntax-only`。这是 C 结构检查，不能检验 QCP 注解类型，也不表示实现满足 contract。未运行 QCP。

尚待完成：Init/DeInit 正式 contract 和模块header，外层 program 与 checked observation，Rocq 类型检查，所有复用 spec 的版本/证明状态/语义适配核对，最终闭包与返回路径扫描，已 review-passed predicate revision 上的独立 spec review。
