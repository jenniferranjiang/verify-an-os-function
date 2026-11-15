# InitDataqueue 共享模块独立设计审阅

当前审阅针对仅保留三份实际修改核心库、直接引用全部未修改根库的新候选。此前 predicate `c6c705795a6ee2b01d875e7345d704a2b6001eb2e325c0ce049ae67b5e9bc46e` 与 spec `d3bdd13646616ad638d6502fd1adf3da2cd832fd6b9a5d6179545d9c1f141872` 的结论因状态/协议适配和输入集合变更而 invalidated，不能代替本轮结论；更早局部设计结论同样失效。

权威 `data_queue.c` 为用户批准修复后的 SHA-256 `6ff659a97e06586b48d5a77de05ee9dfb5884659ace0f5eaa340daf57376c89e`；源码、配置和信任依据见 [manifest](../../manifest.json)、[source analysis](shared-source-analysis.md) 与 [spec sources](../../spec-sources.json)。审阅者为独立 review agent，作者为 design/C analysis agents。本轮只设计审阅，不运行 QCP parser、symbolic、VC、orchestrator 或 C 实现证明，也不执行全局库合并。

## Predicate：review-passed

冻结 revision：`0bd5b847fe79b5f6be975a392d968b2c972df8228c7a3d45f8d10758db7cff31`。全部七份正式 `.v` 及 SHA-256 见 [predicate candidate](../../checks/predicate-candidate.json)；逐文件 fresh Coq 8.20.1 编译结果见 [rocq summary](../../checks/rocq-summary.json)。审阅时重新计算全部哈希，均与成功编译记录一致。仅有原有 CDCLLib remap loadpath warning，无编译错误。

### 原结构、直接复用和单一 carrier

trial/lib 仅七份正式 V：实际修改的原 CrtosGlobState、CrtosRules、CrtosInv 三文件及 DataqueueState、DataqueueInv、DataqueueSemaphore、KInitDataqueue 四个新模块文件。全部未修改 Task/ID/DLL/Semaphore 库直接 Require 根库；没有仅改 imports 的依赖副本，也没有通过 generated/tmp 中的副本替代。当前 `_CoqProject` 仅映射真实根库与这七份 trial 输入；根库三个来源的 baseline 哈希已重新计算且未变。

CrtosGlobState 仍按原字段布局定义 flat `VarGlobalState`，增加 `os_dataqueues`；StableGlobalState 直接 alias 根类型。没有另建保存 core 字段的总状态包装。`project_core` 是从这些原字段得到旧根状态的确定性纯投影，`restore_core` 回填全部原字段并保留给定队列 map；逐字段核对没有遗漏或两份状态权威。两个 roundtrip 待证命题准确描述其保守连接，不被当作已证事实。

CrtosRules 直接复用根 Assertion/STS/unit token，没有重新实例化另一套协议。新状态的 InsideCritical/OutsideCritical 与 RTrans/GTrans 都投影到同一旧 core；LastSeen 和 os_atomic_cmd 则在实际完整 flat 状态上表达观察关系，允许 queue map 在锁外按原 True rely 任意变化。状态投影并不生成 queue 权限。

CrtosInv 的实际 `os_inv` 分离组合根 `os_inv(project_core st)` 与 `dataqueue_inv(st.os_dataqueues)`，真正参与 Init/DeInit 与 primitive 资源交接。受保护 invariant schema 以 core 索引下存在的实际 queue map 描述全体 heap，空 map、publish、withdraw 明确提供资源建立和转交。不能从旧固定 Lock contract 靠 frame 凭空导出新增资源；此边界作为同一受信 primitive 的 protected-invariant schema 实例透明保留，不增加硬件或更强 rely 结论。

`lift_core` 直接调用原 pure command，正常效果/err 投影到旧根状态，同时精确保留 `os_dataqueues`。旧 helper 的 CoreVarGlobalState、core_os_inv、core_LastSeen、core_OutsideCritical 保持根类型/函数语义；根资源可以从当前 os_inv 拆出，queue invariant 在同一 Assertion carrier 下作为 frame 保存。故不需要复制未改库或将旧证明偷偷重解释为新 record 的证明。

[shared-library-sources](../../shared-library-sources.json) 记录三份实际核心修改和根库直接复用。三个 trial 文件中存在对原根接口的依赖，因此未来合并必须保留原接口、增量整合并重编，不能将 trial 文件直接覆盖同名根文件造成 self-import；本轮不执行该后续步骤。

### 完整模块资源和生命周期

新 `DataqueueState.v` 覆盖全部六字段、完整 slot 数组、ghost 对象身份、共享 map、Active/Retiring 阶段与环内容；`DataqueueInv.v` 通过既有 `store_map` 唯一持有全部已发布 struct 与数组。ghost map 以真实对象基址索引，不虚构新增可执行 C 登记表。Semaphore 对象、ID/管理链和等待节点仍只由 semaphore invariant 持有；queue 中的句柄/原对象地址仅表示引用和身份，不能据此取得其内存权限。

完整20字节对象使用 Raw 与 typed view 的同堆普通合取，`fields ** TT` 保留具名字段外的资源，不以分离合取重复拥有同一字节，也不把 memset 的范围误缩为18字节。数组复用 `store_array`；None 表示尚未写入的完整8字节，Some 表示已写入 pointer/length，外部 payload 始终不归 queue 拥有。任意 slots 的回收、typed 元素拆合均有明确待证接口，不局限初始化 None 列表。

运行期有效性包含 slot 长度=max_len、合法环下标以及活动区全部为 Some，因而 Pop/Peak 的 load 能取得已知 typed 字段。Push 只更新 rear 槽并移动 rear；Pop 不清除原槽，只移动 front；满/空分支保持原字段。容量0的初始空环仍合法发布，后续取模另需 ring_usable；容量1保留原“无空余位置”的行为。Active 仅表示已发布未 retire，不等于所有操作前置条件自动成立。

纯 runtime 保持义务在审阅中补齐了长度条件，避免“front=rear=2、capacity=5、slots=[]”这样的空活动区假合法状态。另对容量0..8的7100个合法环状态进行有限纯设计校验，front-known 和 Push/Pop 的合法性保持未见反例；该检查仅辅助审阅，不称为一般定理或 C 证明。

启动空 map 的资源来源为 emp。成功初始化只在第一次 Unlock 前 publish，消耗原 private object/buffer，改由完整 `os_inv` 持有；失败不 publish，保留 private struct/array 进入第二段 IRQ 回滚。publish 义务显式要求新 entry 有效，不能将任意损坏对象塞入有效 map。已有 entry 与 private Raw 的同地址重叠会违反唯一 ownership，故初始化的空槽依据来自真实资源，而非无据加强入口条件。Retiring/finish/withdraw 界面说明数组与 sem 的回收，以及残余 struct 返还 caller；struct 本身不交给 free。

队列 invariant 不永久要求 Semaphore 存在、原地址永不复用或计数恒等于环占用。因此既有通用 Semaphore 操作和跨保护区的 Obtain/Abandon 阶段未被新模块错误限制。原 core 模块操作通过 lift_core 保留 `os_dataqueues`，本地各 replace_* 保留它，`replace_dataqueues` 只改队列分量；与其他共享对象的地址互斥由系统 invariant 的分离组合给出。

### 路径、协议及剩余证明义务

初始化程序保留整个 uint16 容量范围、malloc(0) 的空/非空结果、合法 ID 0 和创建失败 -5。三个失败点最终句柄分别为(-1,-1)、(-5,-1)、(-1,-5)；DeInit 只把原非负句柄置-1，保留负错误码及 front/rear/max_len。成功新建 sem 的初始值为 uint16(n-1) 和0，其关联只承诺退出保护时的 snapshot，不是永久环境事实。

失败先 Unlock 再进入 DeInit IRQ，程序明确保留两段观察，不假定环境静止。原生 assertS 对再次观察的合法 `os_inv` 检查原对象身份与空 pending。适用默认 ReviewWhitelist 001，文件 SHA-256 `0c77c8b4b54a0ae03b0757cb514001abf9a495e4b2d43e95ab6535417657955b`，无用户补充；适用符号为 abs_dataqueue_deinit 和 abs_init_dataqueue 的失败组合。按该例外不以 Rely=True 全称条件尚未建立正常可满足性/非真空性为 blocker，不声称已经证明环境保持，也不排除 ID0/分配失败。

根库既有布局信任按原来源直接复用；七份本地 V 均未引入新 Axiom、Admitted 或 Parameter。布局、字节/字段桥、元素拆合、runtime 有效性保持、空 map、publish、withdraw 与全系统资源交接均明确记录为 typechecked 待证义务，未当作已证结论使用。新 Lock/IRQ caller-local 契约必须交接当前完整 `os_inv`，并按同一受信 primitive 的 protected-invariant schema 说明扩展资源来自初始化/publish，不把旧固定 contract 当作凭空产生 queue 权限的推导。该接口适配将在 spec 审阅中核对。

当前没有影响此 predicate revision 设计正确性的未解决问题；其通过仅表示设计可进入后续 spec 审阅，不表示任何 C 函数实现已证明。

## Spec：review-passed

冻结 revision：`bd320182858f13b1fb3eb06b3d450dcbb2f94d6df632d03a543e3a5769184767`，引用已通过的唯一 predicate revision `0bd5b847fe79b5f6be975a392d968b2c972df8228c7a3d45f8d10758db7cff31`。正式 spec 审阅在 predicate 通过后进行；六份 C 和四份 header 的当前 SHA-256 见 [spec candidate](../../checks/spec-candidate.json)。

[header-type-audit](../../header-type-audit.json) 对75条 Extern 声明按全限定 Printing 映射逐项 Rocq 显式类型编译通过，并用四条 eq_refl 检查 CoreVarGlobalState、core_os_inv、core_LastSeen、core_OutsideCritical 确为根类型/函数的定义别名。审阅时重新计算四份 header、七份正式 V 及全部 C 输入的哈希，与 audit、[C syntax/ABI](../../checks/c-summary.json)、[source equivalence](../../checks/source-equivalence.json) 的通过结果一致。未运行 QCP parser，因此不把这些检查称为其前端已接受或实现证明。

### 完整调用闭包及直接复用

实际 C 算法及 retained calls 未改变，六份 body 与权威源码按已记录 debug/NULL/IRQ、nested lock、done dispatch、CONTAINER_OF、调度模型等适配归一后全部一致。当前闭包和所选合同见 [spec sources](../../spec-sources.json)，仍为六份唯一同名 active canonical、24个可达 symbol；没有新 C wrapper、裸调用、未解析函数指针或宏调用。

| 类别 | Symbols |
|---|---|
| 本轮 canonical | InitDataqueue、DeInitDataqueue、KSemaphoreCreate、_SemaphoreCreate、KSemaphoreDelete、_SemaphoreDelete |
| 原 helper spec 直接复用 | IdInsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter、IdGetObj、IdRemoveObj、IsDoubleLinkListEmpty、DoubleLinkListRmNode、LinklistResumeAll |
| 原 IRQ primitive schema 接口 | DisableLocalInterrupt、EnableLocalInterrupt |
| TrustBase 支持的 critical/allocator/stdlib/container API | CriticalAreaLock、CriticalAreaUnLock、x_malloc、x_free、memset、CONTAINER_OF_SEMAPHORE_ID |
| 既定源处理模型 API | NULL_PARAM_CHECK_1、KTASK_ASSIGN |

八份 helper 与来源规范经空白、已证明定义相等的 core aliases 和 KOK→0 归约逐条一致；五组本地 caller/canonical 合同也独立比较一致。KTASK_ASSIGN 的旧 core-domain 模型同样与来源一致。来源版本、边界分类及限制均有冻结依据；模型/复用边界不递归其原内部实现闭包，不把已有声明说成重新证明了实现。

关键受影响部分已单独检查：bare ID/DLL helper 直接使用根空间谓词和同一 Assertion；LinklistResumeAll、KTASK_ASSIGN 保留根 CoreVarGlobalState 及 core invariant/协议词汇，不因本地同名扩展 record 而重解释旧契约。新总状态先投影取得旧接口的纯状态，旧资源从完整 os_inv 中拆出，queue invariant 作为 frame 保持，再由 restore/lift 恢复全体字段与相同 queue map。新增 IC Semaphore contract 仍是本轮待证目标，不能称原 OC 证明自动覆盖；非空 pending/resched 分支保留完整代码与 API，但在当前明确 empty 场景下不可达。

### 资源、所有路径及协议

Init 的 private Raw 只在成功且仍持第一次 Lock 时发布。成功 Ensure 明确给出共享 entry 与创建关联，并仅返 OutsideCritical，不把系统已持有的 object/buffer 又返给 caller。失败不 publish，三条路径分别保留(-1,-1)、(-5,-1)、(-1,-5)，base清空，array归还分配器，原struct ownership返 caller。完整 uint16 容量、0/1容量、ID0、创建失败和 malloc(0) 的结果都未被无依据前置条件删除；成功数组仍是未知初值槽。

失败第一次 Unlock 与 DeInit 的 IRQ 保护是两个观察窗口，原对象身份及 empty pending 由已 reviewed assertS/白名单001条件承担，不假定重入状态等于入口。DeInit 按同次 Disable 的 saved level 原样 Enable，只把原非负句柄置-1，保持原负码及front/rear/max_len；free需要原数组基址和完整区域，不释放payload或caller的struct。这里的 DeInit canonical 为根 Init 实际到达的 private init_rollback 场景；完整模块的 shared Retiring/withdraw 接口不被冒称为一般共享销毁的完整 C 证明。

load/store 的 ownership 分别来自当前 private Raw/typed object/array、根 module predicates 或实际完整 os_inv。新总状态的普通模块动作通过 lift_core 精确保持 queue map；已有 root helper 的 frame 也保持队列资源。成功 snapshot 关系不承诺以后对象或值永久不变。旧 NULL API 保留空指针不保证返回语义，非空权限来自对象资源，未套用新版纯诊断删除规则。

Lock/Unlock 与 IRQ contracts 操作当前 full os_inv，却继续使用根唯一 STS/token 的投影接口。protected-invariant schema 的资源建立、publish消费及归还限制保持透明，不声称旧固定合同能凭空多借出队列内存；没有强化 rely、硬件寄存器或调度保证。此处只接受设计及库复用连接，后续仍须完成具体调用和资源桥的 C 实现证明。

当前 predicate 与完整闭包 spec 均为 review-passed，无剩余设计 blocker。七份正式 V、直接根库复用和所有检查依据均已绑定当前版本。实现状态仍为 not-verified，未运行 parser、symbolic、VC、orchestrator 或 C 实现证明，也未合并到全局库。
