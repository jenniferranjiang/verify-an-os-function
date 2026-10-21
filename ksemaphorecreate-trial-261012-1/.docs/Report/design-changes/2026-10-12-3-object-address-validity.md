DCHG-20261012-03：C 对象及嵌入节点的地址有效性

当前表示没有提供 InsertObj 所需的两个非零地址事实，不能继续视为设计条件全部闭合。predicate-r5 与依赖它的 spec-r4 审阅结论因此标记 invalidated；原 formal sources、manifest、成功证明和失败证据均保留。此问题是表示/布局接口缺口，尚无证据表明权威 C 有缺陷。

实际证据是 InsertObj-vc-proving-r1 的 manager_open 与 bucket_insert_ready 报告，以及 annotation-attempt2 的 agent_output.md。三个未闭合 VC 分别要求未初始化 bucket head 非零，以及两条分支的 IdNode.link 地址非零。框架 isvalidptr 允许地址零；store_uninit_idbucket 只拥有两个零值指针单元。store_sem_id_detached 也没有内嵌 link 非零事实，当前抽象 eval_addr_expr 不能直接替代 Cortex-M3 的具体字段偏移。

权威源码、ABI probe 给出真实对象布局与静态/动态来源，但 C 编译证据不是已经存在的 Rocq 布局等式。修复必须检查已有 QCP 地址/sizeof 接口，并闭合静态初始化及完整32字节对象的分配、清零、释放来源；不能只在局部 Assert、泛型 Require 或 trusted Ensure 中增加未经依据证明的新保证。pending 与 registry 内嵌节点也在本次同类检查范围内。

候选 predicate-nonzero-candidate-fe8c4261db5c 已经独立 predicate review-passed（2026-10-12-6-predicate-review.md），按用户第八节自动接受并逐hash激活到本trial。作者为 nonzero_predicate_author，独立审阅者为 nonzero_source_review。新manifest为 fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3；旧active文件保留在 evidence/nonzero-activation/before。来源metadata属于原已批准完整C对象语义；不声称从旧raw字节推出，也未新增布局公理。Spec-r5-480669e8557a 也已独立review-passed（2026-10-12-4-spec-review.md），按用户第八节自动接受。设计缺口闭合；恢复controller后仍须重证实际VC并复核旧五个done结果。用户第八节允许保持原语义目标的设计修复经独立审阅后自动接受；若实际需要新增假设、改变 trusted 保证或调用域，仍须按第十四节停止请求明确决定。

影响范围包括 bucket/manager 表示、私有对象表示、相应 callee contracts、静态初始化和所有传递调用者。已完成五个单函数的 controller 机器结果仍是原 revision 下的历史证据，不自动变成新 revision 的结论。候选确定后必须依 dependency closure 重查编译、spec 一致性、相关 VC/证明及最终完整性，保留原错误和重试历史。

最终状态（2026-10-16）：本决定已落实到当前接受的 predicate/spec revisions，完整九函数闭包已重验，全部机器终检通过；当前结论与边界见 [final integrity](../2026-10-16-1-final-integrity.md)。本记录所述原诊断保留，不改变权威源码。
