---
name: os-verification-coordinator
description: 编排 CRTOS 等非 SMP OS 函数验证：按项目 AGENTS.md 串联源码切片、predicate/spec 设计与审阅、QCP 实现证明和报告，或从已有阶段继续。
---

# OS 验证主编排

本 skill 编排 OS 函数验证的各个阶段，由项目 `AGENTS.md` 指定为主入口。

| 阶段 | Skill |
|---|---|
| 1. 源码处理 | [source-processing](../source-processing/SKILL.md) |
| 2. Predicate / spec 设计与审阅 | [predicate-and-spec-design](../predicate-and-spec-design/SKILL.md) |
| 3. Annotation → VC → manual proof | [vc-proof](../vc-proof/SKILL.md) |
| 4. Report | [verification-report](../verification-report/SKILL.md) |

按当前任务范围读取相应子 skill，不自动扩大验证范围。

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

验证记录默认保存在工程的 `.docs/Report/<module>/<YYYY-MM-DD>-<目标函数>/` 中，以用户和项目约定为准。长期保留的设计说明解释本轮新增或修改的lib/spec/VC及spec中需要人重点审阅的内容，实验完成后也保留；验证结果整理为最终报告，源码缺陷记录单独保留。存放与清理规则见 [验证记录指南](../verification-report/references/reporting-guide.md)。

接入已有验证工作及处理用户 `AGENTS.md` 时，遵循[工程适配说明](references/project-maintenance-guide.md#接入已有验证工程)：复用已有成果，保留已有 `AGENTS.md`；与 skill 要求冲突时，以用户规则为准并报告。

## 总流程

用户要求验证一个函数时，任务同时包括完成该函数所属模块的 `lib` 设计。模块 `lib` 应依据该模块全部函数及对象生命周期，补齐模块状态、内存 predicate/invariant、共享接口，以及按资源归属所需的 OS 总状态和 `os_inv` 集成（判断条件见 [Predicate 指南第 7.4 节](../predicate-and-spec-design/references/predicate-lemma-design-guide.md#74-组合模块-predicate)）；已有定义直接复用。函数 spec 和 C 实现证明的范围仍按目标函数的调用闭包确定，不因此自动扩展为模块全部函数的实现证明。仅设计和审阅的任务也适用这一模块 `lib` 范围，但不要求提前完成引理或 C 实现证明。

Main agent 负责确定模式、安排顺序、守住审批门并汇总结果。作者与 reviewer 应分开；predicate review 和 spec review 分别明确对象、条件和结论，可写在同一份记录中。Review 次数不预设，由产物 revision、修改影响和通过条件决定。没有独立检查能力时，由 main agent 按相同条件自检并注明。

```text
确认验证上下文 -> C 分析 -> predicate 与 spec 草案迭代
             -> predicate review-passed -> spec review-passed
             -> 用户确认两份 revision
             -> QCP verification-orchestrator implement（含 final-check）
             -> implement done 后完成受影响依赖的一致性检查
             -> 最终完整性审阅、整理最终报告
```

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
