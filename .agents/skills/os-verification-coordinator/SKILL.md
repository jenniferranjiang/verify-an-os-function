---
name: os-verification-coordinator
description: 编排 CRTOS 等非 SMP OS 函数验证：按项目 AGENTS.md 串联源码切片、predicate/spec 设计与审阅、QCP 实现证明和报告，或从已有阶段继续。
---

# OS 验证主编排

本 skill 编排 OS 函数验证的各个阶段，由项目 `AGENTS.md` 指定为主入口。

| 工作环节 | Skill |
|---|---|
| 1. 源码处理 | [source-processing](../source-processing/SKILL.md) |
| 2. Predicate / spec 设计与审阅 | [predicate-and-spec-design](../predicate-and-spec-design/SKILL.md) |
| 3. Annotation → VC → manual proof | [vc-proof](../vc-proof/SKILL.md) |
| 4. Report | [verification-report](../verification-report/SKILL.md) |

源码处理和设计审阅属于 Stage 1；实现证明及其最终收尾属于 Stage 2。阶段报告可在任一阶段生成。按当前任务范围读取相应子 skill，不自动扩大验证范围。

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

验证记录默认保存在工程的 `.docs/Report/<module>/<YYYY-MM-DD>-<目标函数>/` 中，目录沿用用户和项目约定。报告文件名使用 `YYYY-MM-DD-N-title.md`。长期保留的设计说明解释本轮新增或修改的lib/spec/VC及spec中需要人重点审阅的内容，实验完成后也保留；验证结果整理为最终报告，源码缺陷记录单独保留。存放与清理规则见 [验证记录指南](../verification-report/references/reporting-guide.md)。

接入已有验证工作及处理用户 `AGENTS.md` 时，遵循[工程适配说明](references/project-maintenance-guide.md#接入已有验证工程)：复用已有成果，保留已有 `AGENTS.md`；与 skill 要求冲突时，以用户规则为准并报告。

## 总流程

按用户指定的目标、文件和问题范围选择增量修改或统一修正同类问题。单函数验证需结合所属模块各函数和对象生命周期理解资源归属，复用已有定义，在任务范围内补齐所需的模块状态、predicate、共享接口及 `os_inv` 集成（见 [Predicate 指南第 7.4 节](../predicate-and-spec-design/references/predicate-lemma-design-guide.md#74-组合模块-predicate)）。函数规格和实现证明按目标及其调用闭包确定。独立验证整个模块且用户未进一步限定范围时，可以检查并统一修正该模块内的同类问题。仅审阅时按指定文件和版本只读检查。

简单任务可由同一个 agent 完成所需的分析、设计和审阅，自检时注明。复杂任务可把能独立完成的源码分析、设计或审阅交给不同角色，主 agent 核对任务范围和用户授权并汇总结果。Predicate 和 spec 分别给出审阅结论，可写在同一份记录中。复查次数取决于版本变化、影响范围和通过条件。

- **Stage 1（设计与审阅）**：确认配置和真实 C 行为，在 `slice-design`、`write-spec` 中设计谓词与规格，编译或类型检查相关 Rocq 定义，人工核对切片与调用闭包。在 `review` 中先审谓词，再基于该版本审规格，记录各自的 revision 和结论。只有设计或审阅请求时，完成所请求的工作即停在本阶段。
- **阶段授权**：向用户提交 Stage 1 结果，列明通过审阅的 predicate/spec 版本。用户确认 Stage 1 完成并明确指定进入 Stage 2 后才能启动实现证明。两项意思可以在同一条指令中表达；仅确认设计完成时停在 Stage 1。
- **Stage 2（实现证明）**：以获准版本为输入，由 QCP verification-orchestrator 执行预处理、符号执行、VC 生成、证明及 final-check。完成后检查受影响依赖和源码一致性，整理最终报告。已批准规格发生语义变化时，暂停受影响的证明，按[设计变更报告](../verification-report/references/reporting-guide.md#设计变更报告)提交新版本供人类专家审阅，经确认后继续。

## 维护全局工程

设计、审阅和实现证明直接在验证工程的全局 `lib/`、解析后的 annotated C 目录和 `VC/` 中增量修改，沿用已有布局和逻辑前缀。写入全局目录不表示已审阅或已证明，完成状态以明确revision及检查结果为准。

修改共享接口时同步必要的使用处、构建配置和受影响审阅状态，依赖一致性在当前工作中处理。保护已有定义、spec、证明及用户未提交改动，不因工作位置改变扩大本轮C函数体证明范围。原始 OS 源码始终只读，授权修复只作用于验证工程的 annotated C 副本。

接续已有工作时，先核对输入版本、授权、审阅记录及当前文件差异，再在实际所属文件中继续。

## 通用验证约束

设计阶段可以先写引理陈述，不要求立即完成证明；未证明的内容必须明确为待证义务，不能当作已证明结论使用。

Predicate/spec 设计与审阅前读取[默认审阅白名单](../predicate-and-spec-design/references/review-whitelist.md)及配置的
`review_whitelist` 用户补充文件，按[用户审阅白名单](CONFIGURATION.md#用户审阅白名单)
应用审阅例外。两份文件分别保留，冲突条目以用户规则为准，其余共同生效；未配置用户文件时使用默认文件。
命中的例外不作为设计审阅 blocker。Agent 不自行扩大例外，白名单不免除 VC 证明或引入新的信任假设。

## 项目与参考路径

从用户 workspace 的根目录使用项目已有的构建入口。构建、QCP 和编辑器使用同一配置与已有逻辑前缀。必要依赖适配与编译随当前改动完成，见[工程维护指南](references/project-maintenance-guide.md#全局工作区与依赖维护)。

验证以当前配置下的真实 CRTOS 源码为基线；如有批准的副本修复，验证对象为记录了差异的修复版本。除按源码问题门禁批准的副本修复外，完整源码模式只修改副本中的注解；单函数切片按上述《源代码处理》规则适配，其他工具转换须保持程序行为，并在 spec review 中说明转换位置、理由及源码依据。不得超出已规定的适配范围改变算法、遗漏执行路径或副作用，也不得使用错误的数据布局。缺陷修复不得冒充等价转换。等价转换示例见 [Spec 编写指南](../predicate-and-spec-design/references/spec-writing-guide.md#单函数切片的等价转换)。

### 库与证明参考

编写或修改 predicate、abstract program 和 spec 前，阅读[QCP 工具指南](../predicate-and-spec-design/references/qcp-definition-guide.md#公共定义与记法复用)，按其中规则使用通用数据操作、公共模块接口及抽象程序记法。

写新定义、strategy 或断言前，先查 CRTOS 全局库及当前工程的 annotated C，再查 QCP 库；需要参考设计或证明方法时，查看已配置且可用的 crtosverify、LOSVerify 和 VRTOS；未配置的参考直接跳过。查找实际定义和用法，不猜测 QCP 语法。

可选外部参考目录由 `references` 提供。QCP 使用 workspace 构建配置选定的安装。下表中的位置是查找提示，以实际扫描结果为准。

| 来源 | 位置 | 用途 |
|---|---|---|
| 当前工程全局库 | `lib/<module>/`、`lib/common/` | 复用模块定义、predicate<br>和已证明引理。 |
| 当前工程 annotated C | `annotated_C/src/kernel/<module>/`、<br>`annotated_C/src/kernel/common/` | 查找函数 spec、注解、断言<br>和 strategy 用法。 |
| QCP 基础库 | QCP 仓库的 `Rocq/SeparationLogic/`、`Rocq/MonadLib/`、<br>`Rocq/StrategyLib/`、`Rocq/auxlibs/` 等 | 复用分离逻辑、抽象 program、<br>strategy、tactic 及通用引理等。 |
| QCP 示例 | QCP 仓库的 `Rocq/examples/`、`QCP_examples/` 及项目教程 | 参考注解、assertion、<br>`which implies` 和证明写法。 |
| `references.crtos_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/` | 参考 CRTOS 模块定义、predicate、<br>spec 和 VC 证明。 |
| `references.los_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 OS 模块、spec 和证明，<br>如 `lib/sem.v`、`lib/task.v`。 |
| `references.vrtos`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 CRTOS 对象表示、spec 和证明。 |

已有 spec 的复用与修改按[已有 spec 复用与文件组织](../predicate-and-spec-design/SKILL.md#已有-spec-复用与文件组织)执行。全局文件须结合revision与审阅记录确认状态，不把已有文件直接视为已证。

复用定义或已证明结论时，确认其适用性、证明状态、依赖假设和当前工程兼容性。复用已有 spec 则是采用来源文件中的契约，不等于其函数体已经证明；其范围与状态记录按[设计阶段的 `reused-spec` 规则](../predicate-and-spec-design/SKILL.md#验证范围)处理。“参考”允许借鉴设计和证明方法，不表示整个目录已经可信，也不替代用户对具体 `trusted` C symbol 的批准。

跨模块调用复用全局 `lib/` 已有定义，不重复增加已有概念。接口缺少内容时直接在所属模块原文件增补；定义不符合当前C或skill要求时说明修改依据，处理受影响的使用处及证明状态，不等待实现完成才集成。
