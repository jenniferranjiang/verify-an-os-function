# OS 验证 Skills

本目录把 OS 函数验证分成一个主编排和四个阶段。本文供阅读和维护时查找文件；具体执行步骤、审阅条件和证明约束以各个 `SKILL.md` 及其引用资料为准。

## 阶段分工

项目根目录的 [AGENTS.md](../../AGENTS.md) 指定主编排入口，可由用户自定义。阶段之间的关系如下：

```text
os-verification-coordinator
  1. source-processing
     原始源码与配置 → 验证切片
  2. predicate-and-spec-design
     谓词与规格设计 → Human / AI 审阅
  3. vc-proof
     annotation → VC → manual proof
  4. verification-report
     一致性检查、结果报告与收尾
```

| Skill | 负责什么 | 主要输入与产物 |
|---|---|---|
| [os-verification-coordinator](os-verification-coordinator/SKILL.md) | 总流程、阶段衔接、共享工程约束及库与证明参考。 | 根据任务和已有进度确定范围，组织各阶段并汇总结果。 |
| [source-processing](source-processing/SKILL.md) | 确认源码与工具上下文，分析 C 源码并按规则生成验证切片。 | 原始源码、配置 → annotated C 副本、转换依据及模块分析。 |
| [predicate-and-spec-design](predicate-and-spec-design/SKILL.md) | 设计模块 predicate、抽象操作与函数 spec，并完成设计审阅。 | 切片及已有库 → lib、函数契约、设计说明与明确 revision 的审阅结论。Review 包含在本阶段。 |
| [vc-proof](vc-proof/SKILL.md) | 将已批准的设计交给 QCP，完成注解、VC 和实现证明。 | 已批准的 predicate/spec → VC、证明、controller/final-check 结果或可恢复进度。 |
| [verification-report](verification-report/SKILL.md) | 核对全局一致性、整理验证结果和保留必要记录。 | 源码、设计、审阅及证明证据 → 最终或阶段报告，以及未完成事项。 |

## 文件用途

各阶段的执行正文直接放在 `SKILL.md` 中。`references/` 保存较详细的指南、经验和示例，由所属 skill 指明何时读取。每个 skill 的 `agents/openai.yaml` 保存展示名称、调用提示及已有工具依赖声明。

### os-verification-coordinator

| 文件 | 用途 |
|---|---|
| [SKILL.md](os-verification-coordinator/SKILL.md) | 主编排入口；包含总流程、全局工程约束，以及各阶段共用的“库与证明参考”。 |
| [CONFIGURATION.md](os-verification-coordinator/CONFIGURATION.md) | 源码、QCP、Rocq 路径及构建、编辑器配置；说明用户规则、白名单和可选参考工程如何配置。 |
| [config.example.json](os-verification-coordinator/config.example.json) | 可选项目设置示例，对应 workspace 中的 `.agents/verify-os.config.json`。 |
| [project-maintenance-guide.md](os-verification-coordinator/references/project-maintenance-guide.md) | 接续已有工程、维护 lib/annotated C/VC、处理共享依赖与构建路径的详细规则。 |

### source-processing

| Reference | 用途 |
|---|---|
| [source-processing-guide.md](source-processing/references/source-processing-guide.md) | 从原始源码到验证切片的默认处理规则、OS 特定适配和 trusted specs 边界；与用户补充规则一起使用。 |
| [qcp-tool-guide.md](source-processing/references/qcp-tool-guide.md) | QCP 的 C 输入适配，如预处理、布局与类型假设、固定函数指针调用的转换。 |

### predicate-and-spec-design

| Reference | 用途 |
|---|---|
| [predicate-lemma-design-guide.md](predicate-and-spec-design/references/predicate-lemma-design-guide.md) | 从 C 对象、资源归属和生命周期设计 state、predicate、抽象 program 与 lemma，并检查系统集成和设计正确性。 |
| [predicate-experience.md](predicate-and-spec-design/references/predicate-experience.md) | Predicate 设计中积累的具体经验，按当前源码和建模方式选用。 |
| [spec-writing-guide.md](predicate-and-spec-design/references/spec-writing-guide.md) | 函数规格的参数、effect、资源交接、临界区内外表达、路径覆盖及审阅要求。 |
| [spec-experience.md](predicate-and-spec-design/references/spec-experience.md) | Spec 编写中积累的具体经验和示例，辅助处理当前函数的契约表达。 |
| [qcp-definition-guide.md](predicate-and-spec-design/references/qcp-definition-guide.md) | 公共定义与记法复用，包括数据操作、模块接口和抽象程序记法。 |
| [review-whitelist.md](predicate-and-spec-design/references/review-whitelist.md) | 默认设计审阅例外及其适用条件；用户补充方式见配置说明。 |

`references/doc/` 保存用于类比设计的 LOS 示例，具体适用性由设计指南说明：

| 示例 | 参考内容 |
|---|---|
| [glob_vars_and_defs.v](predicate-and-spec-design/references/doc/glob_vars_and_defs.v) | 全局状态与配置相关的 Rocq 定义。 |
| [Los_Verify_State_def.v](predicate-and-spec-design/references/doc/Los_Verify_State_def.v) | LOS 验证状态与内存表示相关定义。 |
| [List_Add.c](predicate-and-spec-design/references/doc/List_Add.c) | 链表插入的契约与资源描述。 |
| [OsSchedPriQueue.c](predicate-and-spec-design/references/doc/OsSchedPriQueue.c) | 调度优先级队列的规格与注解。 |
| [OsSchedTaskQueue.c](predicate-and-spec-design/references/doc/OsSchedTaskQueue.c) | 调度任务队列操作的规格与注解。 |
| [LOS_TaskCreate.c](predicate-and-spec-design/references/doc/LOS_TaskCreate.c) | 任务创建的规格、调用契约及注解。 |

这些文件用于参考设计和写法，不表示可以直接作为当前工程的构建输入或已证依赖。

### vc-proof

| Reference | 用途 |
|---|---|
| [implementation-and-validation-guide.md](vc-proof/references/implementation-and-validation-guide.md) | QCP 交接与工具就绪条件、OS annotation 适配、证明范围、依赖顺序及时间预算。QCP 内部执行规则由其自身 skill 管理。 |

### verification-report

| Reference | 用途 |
|---|---|
| [reporting-guide.md](verification-report/references/reporting-guide.md) | 设计说明、审阅、源码缺陷、设计变更及最终报告的内容和存放规则，也说明增量统计与记录保留方式。前序阶段写记录时同样使用。 |
