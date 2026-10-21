用户已授权在新 trial 内适配 controller。当前适配已能保留 canonical 路径、初始化完整九函数闭包，并通过原 owner action 启动实际 parser/symbolic。尚无任何目标函数达到 verified；适配检查不代表 C 证明完成。

原始入口仅接受 QCP_examples，因而在读入目标前拒绝 annotated_C/src/KSemaphoreCreate.c。原始命令、诊断和用户回复见 evidence/controller-adaptation-authorization.json。外部 QCP scripts 与 skills 没有修改；本地工具在 tools/qcp-controller/，其 README 解释路径、依赖与闭包调度。上游逐文件 hash、本地 hash 和修改 diff 均保存在 evidence/。

改动包括 canonical路径映射、只读外部驱动/角色skills/库路径、兼容Coq选择、完整闭包的子run调度，以及有独立修复证据时恢复原owner的action。原 annotation/VC/group 接纳、proof合并和 final-check 检查保持。共享 predicate/header 在计算前额外核对 accepted manifests；一次修复证据只适用于对应 repair_index，不可反复重开新的失败。

工具自检覆盖绝对路径/越界/非法拓扑和symlink拒绝、九个真实输入的命令规划，以及已审阅 predicate 的实际依赖发现与原生构建。34个依赖节点的检查通过，包含实际外部 coqchk，总机械耗时128.373秒。已安装QCP部分模块只有.vo；明确记录为object-only输入，未制造.v，编译依赖由coqchk核查。当前内存中的dependency graph不声称列出object-only模块全部内部imports，最终完整proof coqchk仍是完成条件。外部源码/对象hash均固定，未写外部库。

当前接受的输入为 predicate-r5-0a139d64743c 和 spec-r4-9f3ebc915b99。已改用实际 ARM32 LittleEndian 的现代 QCP 库与兼容 Coq，明确传入 --arch=32 --endian=little --no-CRules。旧默认 typed-store 大端问题和 nest 局部资源接口已修复并独立审阅。现代依赖准备成功，163 个 base artifacts；外部核查机械耗时576.129894秒。前述34节点检查仅是早期工具诊断，不作为当前ABI的验证证据。

CriticalAreaLock 的真实 symbolic 已生成三个父 VC，annotation 接纳和依赖构建成功；尚未完成证明。原始 auto 文件中的 partial_solve witness 仍是 Admitted，故适配器增加精确的自动目标覆盖：按内容hash归档原始四文件，把自动目标的原样lemma声明放入manual工作集，由证明owner完成。原goal/auto字节保持不变；原stage的auto/manual去重使实际编译的auto不含这些占位。重新生成与freshness replay使用同一处理。complete-obligation-coverage action将既有不完整工作集送入原annotation retry，不伪造证明或接纳状态。evidence/controller-auto-coverage-check.json 记录对真实输出副本的目标等价、无丢失、冲突拒绝和stage检查；它不代表VC已证明。没有因此加强Require、改变trusted、修改真实C或跳过VC。

恢复入口为 README 中的 step-closure；各owner必须继续使用返回的精确claim/finalize/tool命令。所有九个单函数run原始final-check通过以后，仍须整体 C/VC/proof/trust审计和最终 coqchk。最初检索及恢复时root git status的隔离偏差另保存在 evidence/session-constraints.json；不能把它们删去或宣称全程零枚举偏差。没有使用旧trial文件内容或证明作为输入。

分组准备实测又暴露原 upstream 对 manual/library family 的 Rocq/ 硬编码限制。trial 适配器只额外接受 VC/<合法case>_proof_manual.v 与同名 _lib.v，仍保留路径边界和现有文件检查；无 case lib 时继续保持 absent。evidence/controller-proving-path-check.json 确认真实两组加载成功，额外目录、嵌套 VC 和不匹配 library 仍被拒绝。Owner handoff 明确允许只读 accepted manifest 所列语义依赖，未开放共享输入写权限。

AllocId 的首次 group 检查发现生成器将 C 局部变量 end 原样打印为 Rocq 保留字 binder，导致 goal 解析失败。按 trial 工具适配授权新增生成阶段的严格 alpha-renaming：只将经 forall 作用域核对的逻辑变量改名为新鲜 qcp_local_end；C 地址字符串、原 C、公式、VC 身份和数量不变。原始四文件按内容 hash 归档，逆替换必须逐字恢复原 goal；拒绝捕获、自由变量及不支持的作用域。真实 goal 副本在兼容编译器下通过，证据 controller-identifier-check.json；该检查不声称证明 VC。原三个 group 的失败与草稿保留，repair-generated-identifiers 仅在相关 owner 全部停止后把任务交回原 annotation retry，再重新生成、审阅 VC 和证明。

新 accepted revision 后，`revalidate-revision` 只将旧 done 结果归档并返回原 `final-check`。终检重新执行 fresh symbolic、VC/statement/scope比较与完整当前依赖编译；全部通过才重新 done，并绑定 source/predicate/spec/_CoqProject hashes。closure 不再把旧或缺失 binding 的 done 当作当前完成。工具回归见 evidence/controller-revalidation-check.json；未借此接受任何 C VC。
