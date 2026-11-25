# OS 函数验证 Skill

[verify-an-os-function](verify-an-os-function/SKILL.md) 使用 QCP、Rocq/Coq 和分离逻辑，支持 CRTOS 等非 SMP OS 的函数与模块验证。本文介绍执行阶段和各文件的用途，供阅读与维护时查找；具体规则以 `SKILL.md` 及其引用资料为准。

## 验证流程

```text
确认源码、配置与工具上下文
  → C 源码分析与验证切片
  → predicate / spec 设计
  → predicate / spec 审阅及用户确认 revision
  → QCP annotation、VC、manual proof 与 final-check
  → 全局一致性检查、报告与收尾
```

各阶段由同一个 skill 入口组织，可根据任务范围设计、审阅或继续已有验证工作。

| 入口章节 | 负责什么 | 主要输入与产物 |
|---|---|---|
| [总流程](verify-an-os-function/SKILL.md#总流程) | 确定验证范围、安排阶段衔接并维护共享工程约束。 | 目标函数及已有进度 → 验证范围与阶段安排。 |
| [确认验证上下文](verify-an-os-function/SKILL.md#确认验证上下文)、[C 源码分析](verify-an-os-function/SKILL.md#c-源码分析) | 确认源码与工具路径，依据配置和处理规则分析 C 源码及切片。 | 原始源码、配置 → 验证副本、转换依据与模块分析。 |
| [Predicate 设计](verify-an-os-function/SKILL.md#predicate-设计)、[write-spec](verify-an-os-function/SKILL.md#write-spec) | 设计模块资源、抽象操作与函数契约。 | 模块分析及已有库 → lib、canonical/caller specs、设计说明。 |
| [review](verify-an-os-function/SKILL.md#review) | 核对源码与设计，分别审阅 predicate/spec 的明确版本。 | 源码证据与候选 revisions → 审阅结论，交用户确认。 |
| [implement](verify-an-os-function/SKILL.md#implement) | 将已批准的设计交给 QCP，完成注解、VC 和实现证明。 | 冻结 revisions → VC、证明、controller/final-check 结果或可恢复进度。 |
| [全局一致性检查与收尾](verify-an-os-function/SKILL.md#全局一致性检查与收尾) | 检查依赖、源码对应和构建一致性，整理验证记录。 | 当前输入与检查结果 → 最终或阶段报告及剩余事项。 |

## 文件用途

执行步骤、审阅条件和证明约束位于 `verify-an-os-function/SKILL.md`；`references/` 保存详细指南、经验和示例，由入口指明何时读取。

### 入口与工程配置

| 文件 | 用途 |
|---|---|
| [SKILL.md](verify-an-os-function/SKILL.md) | 主编排入口；包含总流程、全局工程约束，以及各阶段共用的“库与证明参考”。 |
| [CONFIGURATION.md](verify-an-os-function/CONFIGURATION.md) | 源码、QCP、Rocq 路径及构建、编辑器配置；说明用户规则、白名单和可选参考工程如何配置。 |
| [config.example.json](verify-an-os-function/config.example.json) | 可选项目设置示例，对应 workspace 中的 `.agents/verify-os.config.json`。 |
| [agents/openai.yaml](verify-an-os-function/agents/openai.yaml) | Skill 展示名称、调用提示及 QCP、Rocq MCP 工具依赖声明。 |
| [project-maintenance-guide.md](verify-an-os-function/references/project-maintenance-guide.md) | 接续已有工程、维护 lib/annotated C/VC、处理共享依赖与构建路径的详细规则。 |

### 源码处理与 QCP 适配

| Reference | 用途 |
|---|---|
| [source-processing-guide.md](verify-an-os-function/references/source-processing-guide.md) | 从原始源码到验证切片的默认处理规则、OS 特定适配和 trusted specs 边界；与用户补充规则一起使用。 |
| [qcp-tool-guide.md](verify-an-os-function/references/qcp-tool-guide.md) | QCP 的 C 输入适配，如预处理、布局与类型假设、固定函数指针调用的转换；也说明公共数据操作、模块接口及抽象程序记法的复用。 |

### 谓词与规格设计

| Reference | 用途 |
|---|---|
| [predicate-lemma-design-guide.md](verify-an-os-function/references/predicate-lemma-design-guide.md) | 从 C 对象、资源归属和生命周期设计 state、predicate、抽象 program 与 lemma，并检查系统集成和设计正确性。 |
| [predicate-experience.md](verify-an-os-function/references/predicate-experience.md) | Predicate 设计中积累的具体经验，按当前源码和建模方式选用。 |
| [spec-writing-guide.md](verify-an-os-function/references/spec-writing-guide.md) | 函数规格的参数、effect、资源交接、临界区内外表达、路径覆盖及审阅要求。 |
| [spec-experience.md](verify-an-os-function/references/spec-experience.md) | Spec 编写中积累的具体经验和示例，辅助处理当前函数的契约表达。 |
| [review-whitelist.md](verify-an-os-function/references/review-whitelist.md) | 默认设计审阅例外及其适用条件；用户补充方式见配置说明。 |

`references/doc/` 保存用于类比设计的 LOS 示例，具体适用性由设计指南说明：

| 示例 | 参考内容 |
|---|---|
| [glob_vars_and_defs.v](verify-an-os-function/references/doc/glob_vars_and_defs.v) | 全局状态与配置相关的 Rocq 定义。 |
| [Los_Verify_State_def.v](verify-an-os-function/references/doc/Los_Verify_State_def.v) | LOS 验证状态与内存表示相关定义。 |
| [List_Add.c](verify-an-os-function/references/doc/List_Add.c) | 链表插入的契约与资源描述。 |
| [OsSchedPriQueue.c](verify-an-os-function/references/doc/OsSchedPriQueue.c) | 调度优先级队列的规格与注解。 |
| [OsSchedTaskQueue.c](verify-an-os-function/references/doc/OsSchedTaskQueue.c) | 调度任务队列操作的规格与注解。 |
| [LOS_TaskCreate.c](verify-an-os-function/references/doc/LOS_TaskCreate.c) | 任务创建的规格、调用契约及注解。 |

这些文件用于参考设计和写法，不表示可以直接作为当前工程的构建输入或已证依赖。

### 实现证明

| Reference | 用途 |
|---|---|
| [implementation-and-validation-guide.md](verify-an-os-function/references/implementation-and-validation-guide.md) | QCP 交接与工具就绪条件、OS annotation 适配、证明范围、依赖顺序及时间预算。QCP 内部执行规则由其自身 skill 管理。 |

### 验证报告

| Reference | 用途 |
|---|---|
| [reporting-guide.md](verify-an-os-function/references/reporting-guide.md) | 设计说明、审阅、源码缺陷、设计变更及最终报告的内容和存放规则，也说明增量统计与记录保留方式。前序阶段写记录时同样使用。 |
