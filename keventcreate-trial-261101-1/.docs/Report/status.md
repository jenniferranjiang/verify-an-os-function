# KEventCreate 实验结果

用户以“ok我们来implement吧”批准当前已审revision后，已完成 **KEventCreate 和 _EventCreate 两个函数的实现证明**。两个controller均通过final-check并返回 **done**；结论限定于已审源码适配、规格和TrustBase，不扩大为整个Event模块正确性。

| 函数 | Controller run | 顶层VC | 分组 | 终检 / 状态 | 完成时间（Asia/Shanghai） |
| --- | --- | --- | --- | --- | --- |
| `_EventCreate` | `EventCreate-20261101232623` | 52 | 13 | passed / done | 2026-11-02 00:52:00 |
| `KEventCreate` | `KEventCreate-20261101232854` | 4 | 2 | passed / done | 2026-11-01 23:43:41 |

内部52个顶层VC（含19个拆分目标）和外层4个顶层VC，均经过独立VC检查、Rocq MCP交互证明、组接纳及完整parent检查。final-apply发布正式证明后，final-check独立重放当前C、比较义务和冻结规格、检查完整证明与case库并完成清理。这里复用controller的正式终检结果，没有用重复编译或报告中的completed代替接纳。

正式证明为 [EventCreate_proof_manual.v](../../VC/EventCreate_proof_manual.v) 和 [KEventCreate_proof_manual.v](../../VC/KEventCreate_proof_manual.v)；内部辅助引理在 [EventCreate_lib.v](../../VC/EventCreate_lib.v)。机器结果及源码一致性检查见 [implementation-result.json](../../checks/implementation-result.json)，终检状态见 [内部controller](../../reports/EventCreate-20261101232623/controller_state.json) 与 [外层controller](../../reports/KEventCreate-20261101232854/controller_state.json)。

批准的predicate revision为 `bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca`，spec revision为 `1c4a7b5920e164a40891b6d64dc6f18be0debede36a1c79946dd82dad5138f00`；定义含义和函数With/Require/Ensure没有修改。实现阶段只补充函数体证明注解、case辅助引理及下述明确的ABI接口。两个创建函数的可执行正文仍与已审适配一致，caller-local合同与canonical保持一致；原权威C、配置、TrustBase及复用规格来源哈希未变。trial/lib与checks/review-inputs中的已审快照继续保留，不作为活动定义版本。

实现阶段实际VC暴露Event大小/偏移接口缺口。按TrustBase既有结构体布局及位域适配，新增并独立审阅、编译了共享 `EventLayoutABI.v`，明确依赖 `event_size_axiom` 和 `event_top_level_field_offset_axiom` 两条可信ABI事实。它们只固定模型sizeof=36及五个顶层字段地址，不授予内存权限，也不把字节转换或VC当作公理；真实位域对象仍为32字节。IdNode/DLL子字段复用既有布局接口。普通零字节转换、地址新鲜性、发布一致性和资源重建已在本次证明中完成。依据见 [布局适配审阅](event-layout-review.md) 和 [迁移/根编译记录](../../checks/event-layout-migration.json)。不能把包含这些明确ABI假设的证明表述为无假设结论。

调用闭包仍为10个symbol。本次新完成的函数体证明只有两个Create函数；IdInsertObj、InitDoubleLinkList和DoubleLinkListInsertNodeAfter仍为reused-spec边界，x_malloc/x_free、memset、CriticalAreaLock/UnLock仍采用已记录的TrustBase合同，不计为本轮新证明。Create输入保持uint32全域，保存options低3位，失败返回-5，成功返回最小空闲ID并发布events=0、空等待链的新对象。

源码问题按用户确定的范围处理，见 [source-errors.md](source-errors.md)：E1及非法等待策略作为后续API合法输入范围说明；E3依据用户明确的“使用期间不会被删除”条件排除。E2延时失败修复只保存在 [trial候选](../../source_fixes/_EventProcess.c)，包含中文差异注释并通过16个主机回归场景；权威event.c保持原样，原缺陷仍在。该候选不在Create调用闭包，本次没有证明_EventProcess，也没有声称任意事件使用/删除都维持系统不变量。

原设计阶段29个trial模块、36个受影响共享模块及45项接口检查已通过；本轮检查确认这些冻结formal输入仍保持，ABI新增模块另经根配置编译。实际C证明及其依赖检查均由当前controller执行。既有静态初始化或其他未被本次目标调用的Prop义务，不因本次完成就自动成为已证明定理。
