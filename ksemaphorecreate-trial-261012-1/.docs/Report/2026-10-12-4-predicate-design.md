本 revision 修正 predicate 使用的字节编码，使其与已固定的 Cortex-M3 32 位小端目标一致。候选为 `predicate-r4-1b07e9068830`，当前状态 **review-ready**，尚待独立 reviewer 结论；它不代表任何目标 C 函数已经通过验证。

Manifest：`1b07e9068830369255a3a49aa90c66581e9845b7a74c618d35219ed9282bb105`，覆盖 9 个根共享源码的 trial 候选及 9 个本地正式文件。冻结来源、精确差异、配置、源码快照与18项成功编译记录见 `evidence/arm32le-candidate/frozen-r4/`。根共享原文件的 hash 检查无变化，未晋升或覆盖根定义。

源/config仍为 `source-r2-0c50c37013e9`。模块状态、task/scheduler借用范围、registry/ID manager对应、私有到发布的生命周期、pending和ready的唯一owner，以及caller IRQ/token归还设计，继续采用r3设计记录中的定义与依据。本次不改变这些抽象状态、转换关系、contract、`nest<65535`域或六个trusted。改变的是它们所解释的实际多字节heap编码；理由和原审阅失效范围见 DCHG-20261012-02。

共享候选目录为 `shared-candidate/arm32le`，来源是当前 `/home/xinra/crtos/lib` 实际依赖闭包的正式 `.v`，保留原逻辑符号身份 `CRTOS_Verify.lib`。独立候选配置 `_CoqProject.arm32le-candidate` 只把该逻辑前缀映射到trial候选；不会同时加载原根 `.vo`。框架路径全部采用官方 `Rocq/*`，用实测兼容的 `pv-bench-8.20.1/bin/coqc`（OCaml4.14.2），不与原 `SeparationLogic/*` 预编译对象混装。候选性质及这一显式映射应一直保留在最终记录中，不能声称根库已升级。

两个carrier分别是候选 `CrtosRules.Task_C_Rules` 和本地 `CrtosOSProtocol.Crtos_C_Rules`。它们的 DerivedPred/Store/Array/Map/String接口都实例化同一官方 `Arch32 LittleEndian`。因此 OSHeap 原有同址、同字节且不转移旧token的桥在两端使用一致的小端表示；这里没有声称它能把大端heap转换为小端heap。协议仍由原owner-aware嵌套STS提供，STSplumbing与正确性statement保持。

源码适配范围很小：两处carrier增加架构和字节序实例参数；KTaskPure增加Arch32的sizeof记号导入；ID manager的一处证明用定义转换恢复匹配形式。其representation和lemma statement不变。本地NestedState注释按现有来源更新，record没有改变。所有原正式定义的字节层含义由新实例统一确定，并由此次独立审阅重新核查。

作者记录18个正式文件的coqc均退出0。两carrier的指针32位、非对称16/32位小端实例、拒绝对应大端实例的8个Qed探针通过；独立初步检查也在真实加载候选时确认Ptr/UInt=4字节、UShort=2字节。`sizeof(struct Semaphore)`和结构字段地址仍通过正常QCP前端接口解释，不能用这些carrier探针代替后续实际生成产物中的32字节和field-offset检查。

原缺失的nest-cell展开接口属于后续annotation辅助工作。尚未通过的 `SemaphoreCriticalViews.v` 已移到隔离draft，不在此manifest或active build中，不用它支撑本revision结论。补齐该view时另行编译和审阅增加的定义/statement，不修改正在审阅的18个冻结输入。

独立审阅更新：r4为needs-fix，唯一open为R4-REUSE-01（现代官方nested-state原文已可编译，不应继续使用重复record）。其他字节/ownership/编译/trust项通过，详见同编号predicate-review记录。作者已在下一revision中修复该问题并加入nest view，r4冻结快照保持原样。
