> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

> 当前证明文件已按用户要求恢复QCP原生auto/manual分工，Init和DeInit均重新final-check通过。最新文件、计数及信任说明见[native-auto-restoration.md](native-auto-restoration.md)。下文旧全部manual计数是历史记录。

> 当前窗口分工（用户最新指示）：本窗口只推进第一阶段Init/DeInit/Peak及必要Semaphore IC闭包；用户将在另一窗口推进Pop/Push。共享map/ABI设计沿用现状，跨窗口共享lib/header修改需协调并复核受影响证明，不能把旧输入done套用到变化后的输入。

> 最新结果：InitDataqueue run InitDataqueue-20261117224043 已由controller返回done，final-check passed（63个顶层VC）。这是相对于callee契约的Init函数证明；第一阶段闭包尚未完成。当前串行进入DeInitDataqueue run DeInitDataqueue-20261118121138。用户已取消VC预算上限。下文早期预算/部分VC计数为历史记录。

> 2026-11-18最新授权：用户要求持续完成原第一阶段及Pop/Push，取消VC证明时间上限，预先批准后续设计修改与修复建议，无需逐轮等待确认。实际审阅、证明检查和final-check照常执行，失败不得写通过；只读原源码、manual修改边界及禁止无依据假设仍保持。历史预算记录仅作已发生过程，不再作为停止条件。

> 2026-11-18恢复：用户明确给Init追加100分钟（累计上限200分钟），于2026-11-17 16:28 UTC恢复同一run，下一组call_frames_2；此前100分钟及已接纳结果保留。

> 2026-11-18最新状态：Init已接纳44/62顶层VC（10组），累计预算约99–100分钟，停止新增证明尝试；无函数final-check。余18个目标、局部对齐注解修复及重试，详见[implementation-result.md](implementation-result.md)。

> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

> **2026-11-17 当前变更：** 用户已授权地址map改造，本文r1列表版本及旧Init VC适用性已invalidated；历史证据保留。当前设计与迁移检查见 [map-refactor.md](map-refactor.md)。ABI布局连接缺口仍待解决。

# Dataqueue 当前验证上下文

> 2026-11-17：按用户要求删除Push/Pop/_SemaphoreObtain三个分析副本。下文涉及这些副本的同步与测试是删除前的历史记录；修复及适配代码保留在[source-changes.md](source-changes.md)，不表示当前仍有对应实现文件。七份canonical、lib和VC不受此次删除影响。

源码根为 `/home/xinra/crtoslatest`，commit `a07641a0b58469ae3ea19317cce2cf48974989bb`，原仓库只读。工作直接维护全局lib/annotated C，报告位于 `.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/`。

## 当前任务与输入

用户要求按新源码更新已有验证实验，并让errorreport只保留新源码仍存在的问题。当前同步范围为Init/初始化回滚DeInit/Peak三份canonical及Create/Delete四份Semaphore canonical、两个模块header、Push/Pop/_Obtain三个源码上下文。没有新增Push/Pop/Obtain/Abandon完整规格或实现证明。

当前配置沿用ILP32、非SMP、100Hz、ID_NUM_MAX=128，未启用KERNEL_STATIC_OBJECTS或KERNEL_DEFER_IPC_SCHED。只据实际当前配置归一，不声明硬件部署已验证。

## 已有授权与本轮处理

Init/DeInit的-1 sentinel、负值失败判断及非负删除；Push/Pop统一Obtain并检查失败；Peak同锁检查与读取；Push/Pop锁内缓存ID等批准修复/规则适配保留。原源码四项问题仍存在，当前source-errors.md只记录它们。

crtoslatest诊断NULL宏按skill注释移除，取消旧NULL_PARAM_CHECK_1模型；Delete新增的高ID拒绝同步到C与OC/IC抽象；Obtain上下文采用新版完整失败处理并最小保护exstatus读取。新源码自带的零超时/Delay回滚等行为不再冒充本地补丁。

DisableLocalInterrupt/EnableLocalInterrupt仍按既有非SMP ILP32授权作可信资源交接，同次保存值原样恢复；不扩大为硬件mstatus证明，也不新增其他信任。

## 结果与限制

设计解释和人工审阅重点见design.md，源码修改前后见source-changes.md，现存错误见source-errors.md，当前审阅见predicate-review.md和spec-review.md。integration-review.md保留此前全局合并的历史检查结果，本轮同步结果由当前审阅记录说明。

全局原OC删除与queue引用的生命周期兼容问题保持待处理；当前Init回滚采用受限IC契约。既有VC源保留，本轮不生成或手改VC，旧实现证明状态不能自动套到新行为。默认保留.vo供交互式查看。

## 2026-11-17 实现验证接续

用户确认 `dq-predicate-crtoslatest-20261116-r1` / `dq-spec-crtoslatest-20261116-r1` 并授权第一阶段，第二阶段按 Pop、Push 顺序自动确认通过审阅的设计。Main重新计算64份lib联合摘要 `61159901adf3504b7349629579a8aae45cd8ab222b12b9ffa404bb3e32734d7b` 以及7份C+2份header摘要 `ac42f2c9be1295424d2e941866aa08c4c78b3a31ea0cd535d6bd986a86c985fb`，均匹配记录。上游commit、data_queue.c及semaphore.c哈希也一致。未修改原仓库、TrustBase、白名单或冻结设计。

QCP工具已支持现有annotated_C输入和根Make依赖，但缺少预处理配置且默认VC输出到根。已添加根qcp-project.json（ILP32 little-endian/GCC/no-CRules）与qcp-layout.json（模块VC布局），并适配QCP外部工具四处路径解析：project_layout、path_utils、proving及symexec_tooling。默认行为保留，显式配置时kernel模块映射到VC同名模块。首个run InitDataqueue-20261117003811仅诊断配置缺失，没有生成/发布VC；因固定路径已变化由新run替代，旧状态保留作诊断，不手工修改。当前run为 [InitDataqueue-20261117004005](../../../../reports/InitDataqueue-20261117004005/controller_state.json)，尚在annotation阶段，未获done或final-check。

2026-11-17 当前实现状态：Init已生成VC并接纳annotation/VC-checking，首组因缺少正式DataQueue/DataElem ABI连接被controller接纳为blocked；无实现证明或final-check完成，后续阶段未启动。当前结果、任务表与待决方案见[implementation-result.md](implementation-result.md)。

本轮map改造已分别独立审阅通过：`dq-predicate-map-20261117-r1` / `dq-spec-map-20261117-r1`。64份lib依赖编译通过、.vo保留；无新实现证明。当前正式输入与检查见[map-refactor.md](map-refactor.md)。

## ABI授权后的验证恢复

用户已确认按原第一阶段、再Pop、再Push继续，并授权类似本次有依据的修改。DataqueueInv新增唯一具体ABI公理dataqueue_layout_abi，内容严格为既有dataqueue_layout陈述（两个sizeof及八个字段地址偏移），依据当前ILP32 GCC静态断言检查。此授权不把任何资源拆合、map操作或函数效果当作公理。TrustBase用户文件不修改，既有IRQ边界保持。map设计与canonical契约含义不变；布局缺失的阻塞已补入正式输入，实际VC是否通过仍由新workflow检查。

QCP本地适配已审计并收窄：移除非路径unfreeze/resume扩展与额外时间戳门禁，当前生成参数保持一致，详见[adapter-audit.md](adapter-audit.md)。
