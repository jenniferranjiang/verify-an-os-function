# KMutexCreate 新实验结果（2026-11-01）

本实验按 `verify-an-os-function` 完成设计和独立审阅。Predicate 与完整调用闭包 spec 均为 **review-passed**；该结论仅针对创建的模块化设计，不是 C 实现证明，也不是整个 mutex 模块正确性结论。

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

## 停止边界

未启动 verification-orchestrator；未运行 QCP parser/symbolic，未生成 VC，未进行 C 实现证明。字节转换、初始化、发布资源重组等仍为明确的待证义务；没有用新增 Axiom、Parameter 或 Admitted 冒充证明。本轮不请求进入实现阶段。
