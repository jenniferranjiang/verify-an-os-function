# KMutexCreate 新实验结果（2026-11-01）

本实验按 `verify-an-os-function` 完成设计、独立审阅及用户批准后的实现证明。Predicate 与完整调用闭包 spec 均为 **review-passed**；`KMutexCreate` 和 `_MutexCreate` 的 controller 均已通过 final-check 并返回 **done**。结论限定于既定信任边界下的创建函数，不是整个 mutex 模块正确性结论。

| 产物 | 已审 revision SHA256 | 结论 |
| --- | --- | --- |
| Predicate | `038457b98a07c2fa559a7ec4ea7d63e980af6b73b4a8d8782668ffd97640e036` | review-passed |
| Spec | `55bbd4bac08ceb62317b2e176f7ce83d5bc6a46314248abfd8a89f9edc497929` | review-passed，固定引用上行 predicate |

独立审阅：[predicate-review.md](predicate-review.md)、[spec-review.md](spec-review.md)。源码与配置：[c-analysis.md](c-analysis.md)。设计说明：[predicate-design.md](predicate-design.md)、[spec-design.md](spec-design.md)。正式 QCP contracts 位于本实验 `annotated_C/src/`，不在 Markdown 中复制。

完整闭包包含两个本轮实现目标 KMutexCreate/_MutexCreate、三个 reused-spec 边界（IdInsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter），以及五个既有 TrustBase 原语/标准库边界（x_malloc、memset、CriticalAreaLock、CriticalAreaUnLock、x_free）。全部10个symbol已分类，无缺失或未解析调用。已核对三条返回路径、caller-local合同一致性与保留body的源码对应。

## 源码问题没有被设计通过掩盖

[源码缺陷报告](source-errors.md) 记录七项问题。M1递归计数回绕、M5 ID截断有保留真实函数体的主机fixture见证，记录见 [run.log](../../checks/source-bugs/run.log)；其余为带触发条件的静态执行轨迹，未声称在真实OS运行复现。

其中 M2/M3 删除竞争可能破坏真实共享heap及系统不变量。创建的设计使用既有受信任Lock接口交出有效 `os_inv` 的模块化边界，**没有证明现有全部OS代码能维持这一边界**。当前已发现问题不在创建直接调用闭包；创建没有通过新增Require、改算法、削弱复用合同或新增trusted函数来排除它们。若目标扩为任意并发使用/删除、全模块互斥或系统不变量保持性，这些缺陷是阻塞项。权威 C 未修改。

先前分析只把计数回绕当作模型不应添加无据不变量的理由，没有明确报告实际提前释放后果，这是分析和报告遗漏；用户指出后已补充反例、七项错误报告与独立影响复查。

## 共享迁移与证据

按照技能的审阅后合并规则，只把基线之外的实际语义增量合并到全局：新增或重新设计 MutexState、MutexInv、MutexOps、KMutexCreate，并调整 CrtosGlobState、CrtosInv、KTaskWakeup。合并前比较的是本次开始时的工作区基线，保留了已有未提交工作；其余仅为trial逻辑前缀适配的副本没有覆盖根库。

全局文件使用 `CRTOS_Verify.lib`，不依赖trial。trial/lib仅保留本次规格依赖的29个已审文件；另7个不应随本次实验复制的全局回归使用者已移至checks/review-inputs/lib，位置映射见checks/review-file-locations.json。这些快照均不参与当前构建；原annotated C与项目配置保存在 `checks/review-inputs/`，当前输入已切换到全局库。根与trial项目配置、根Makefile及库索引已同步。复用合同原文没有修改，也没有新增具名DLL/ID特化，因此根annotated_C没有需回写的合同增量。

版本映射见 [migration.json](../../checks/migration.json)。[migration-check.json](../../checks/migration-check.json) 核对36份库文件及13份spec输入，迁移只替换逻辑前缀，审阅语义不变。

设计阶段36个Rocq模块全部编译成功，[compile-results.json](../../checks/compile-results.json) 保存结果；规格引用接口通过逐项Rocq类型检查。权威与切片头分别通过相同ILP32 ABI断言（Mutex36字节，唯一padding[2,4)）。[design-audit.json](../../checks/design-audit.json) 保存闭包、合同/源码比较及10个切片的GCC `-Werror`结构检查；GCC不解析QCP注解，未把它当作QCP parser验收。

迁移后使用根项目配置重新编译全部36个受影响模块，退出码0，见 [root-build-result.json](../../checks/root-build-result.json) 与 [root-build.log](../../checks/root-build.log)。当前trial只引用全局库，接口再次类型检查成功，见 [post-merge-interface.log](../../checks/post-merge-interface.log)。未沿用trial旧编译产物作为根库检查结果。共享迁移与一致性检查已完成。

## 实现证明已完成

用户以“我通过了 你继续implement”批准上述两份 revision 后，沿用现有 trial 进入 verification-orchestrator。批准的 predicate/spec 语义未修改，权威 C 未修改；切片仅增加证明所需注解。设计阶段未运行 symbolic/VC 的停止边界已由本次明确批准解除。

| 本轮实现目标 | Controller run | 证明规模 | 最终结果 |
| --- | --- | --- | --- |
| `_MutexCreate` | `MutexCreate-20261101164709` | 55 个顶层 VC，13 组 | final-check passed，done，errors=[] |
| `KMutexCreate` | `KMutexCreate-20261101170140` | 4 个顶层 VC，2 组 | final-check passed，done，errors=[] |

全部分组经过 Rocq MCP 交互证明、分组编译和 controller 正式接纳。合并后的完整 goal-check 编译通过；final-apply 发布正式证明，final-check 独立重新生成当前 C 的义务并检查完整证明、冻结合同、case library 和文件一致性。最后的内部函数终检完成于 2026-11-01 19:30:20（Asia/Shanghai）。本完整性审阅复用 controller 终检结果，没有另行重复执行证明检查。

机器记录见 [implementation-result.json](../../checks/implementation-result.json)，包含两次终检状态及正式 VC 源文件 SHA256；原始 controller 状态见 [内部函数](../../reports/MutexCreate-20261101164709/controller_state.json) 和 [包装函数](../../reports/KMutexCreate-20261101170140/controller_state.json)。正式证明是 [MutexCreate_proof_manual.v](../../VC/MutexCreate_proof_manual.v) 与 [KMutexCreate_proof_manual.v](../../VC/KMutexCreate_proof_manual.v)，新增局部辅助引理在 [MutexCreate_lib.v](../../VC/MutexCreate_lib.v)。trial 项目文件已列入正式 VC 文件，编辑器使用同一 VC 逻辑路径；审阅快照不参与构建。

生成器原来留在 auto 文件中的 49 个 Admitted 模板全部按原陈述转交证明流程并消除，未因文件名为 auto 就视作已证。没有新增信任公理或用 Admitted 绕过义务；未采用的生成 split 所保留的 Abort 不是漏证顶层 VC，顶层义务均由 controller 检查通过。工具适配和回归证据见 [controller-adaptation.md](controller-adaptation.md)。

[实现后源码一致性检查](../../checks/implementation-source-audit.json) 通过：9 份权威源码、配置或复用来源 hash 未变；36 份已审库快照及其全局迁移对应一致；10 个闭包 symbol 分类完整；caller-local 合同等于所选 canonical 合同；剥除注解并执行已审适配后，创建函数 body 与权威 C 一致；10 份 C 切片通过 GCC 结构检查。GCC 检查不替代 QCP 或 Rocq 证明。

本轮新完成的函数体证明只有上述两个创建函数。IdInsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter 仍是 reused-spec 边界；x_malloc、x_free、memset、CriticalAreaLock、CriticalAreaUnLock 仍依赖已有 TrustBase 合同，不计为本轮新证明。适用配置仍为非 SMP、32 位、小端，已审宏和 dispatch 适配保持原范围。

前述七项源码问题仍未修复。特别是其他 API 的删除竞争可能破坏真实系统中的 os_inv；本证明依赖既有 Lock 合同提供有效 os_inv，未证明任意使用/删除操作都维持该条件。批准范围与具体合同见 [implementation-context.md](implementation-context.md)，缺陷证据及触发条件见 [source-errors.md](source-errors.md)。
