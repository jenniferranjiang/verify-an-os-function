---
name: verify-an-os-function
description: 验证 CRTOS 等非 SMP OS 的 C 函数与模块：设计并审阅 Rocq predicate 与 QCP spec，用户确认 revision 后交给 QCP verification-orchestrator 完成实现证明。
---

# 验证 CRTOS 函数

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

验证记录默认保存在工程的 `.docs/Report/<module>/<YYYY-MM-DD>-<目标函数>/` 中，以用户和项目约定为准。长期保留的设计说明解释本轮新增或修改的lib/spec/VC及spec中需要人重点审阅的内容，实验完成后也保留；验证结果整理为最终报告，源码缺陷记录单独保留。存放与清理规则见 [验证记录指南](references/reporting-guide.md)。

接入已有验证工作及处理用户 `AGENTS.md` 时，遵循[工程适配说明](references/project-maintenance-guide.md#接入已有验证工程)：复用已有成果，保留已有 `AGENTS.md`；与 skill 要求冲突时，以用户规则为准并报告。

## 总流程

用户要求验证一个函数时，任务同时包括完成该函数所属模块的 `lib` 设计。模块 `lib` 应依据该模块全部函数及对象生命周期，补齐模块状态、内存 predicate/invariant、共享接口，以及按资源归属所需的 OS 总状态和 `os_inv` 集成（判断条件见 [Predicate 指南第 7.4 节](references/predicate-lemma-design-guide.md#74-组合模块-predicate)）；已有定义直接复用。函数 spec 和 C 实现证明的范围仍按目标函数的调用闭包确定，不因此自动扩展为模块全部函数的实现证明。仅设计和审阅的任务也适用这一模块 `lib` 范围，但不要求提前完成引理或 C 实现证明。

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

修改共享接口时同步必要的使用处、构建配置和受影响审阅状态，依赖一致性在当前工作中处理。保护已有定义、spec、证明及用户未提交改动，不因工作位置改变扩大本轮C函数体证明范围。`source_root`仍只读；授权修复只作用于验证工程的annotated C副本。

接续已有工作时，先核对输入版本、授权、审阅记录及当前文件差异，再在实际所属文件中继续。

## 通用验证约束

设计阶段可以先写引理陈述，不要求立即完成证明；未证明的内容必须明确为待证义务，不能当作已证明结论使用。

Predicate/spec 设计与审阅前读取[默认审阅白名单](references/ReviewWhitelist.md)及配置的
`review_whitelist` 用户补充文件，按[用户审阅白名单](CONFIGURATION.md#用户审阅白名单)
应用审阅例外。两份文件分别保留，冲突条目以用户规则为准，其余共同生效；未配置用户文件时使用默认文件。
命中的例外不作为设计审阅 blocker。Agent 不自行扩大例外，白名单不免除 VC 证明或引入新的信任假设。

### 临时产物与保留边界

开始任务及首次修改已有文件时，按[最终报告的统计要求](references/reporting-guide.md#最终报告)记录修改前基线，供证明完成后的统计使用。

验证工程的 `.docs/Report/` 只保存人工可读的当前设计、审阅、错误和最终完整性记录。不把完整 formal source、控制器每步返回、编译目录或多份状态摘要复制进报告目录。

验证中仍在使用的 QCP `reports/`、`verification_runs/` 和正式 `VC/` 由 verification-orchestrator 管理，main agent 不自行整理、改写或提前删除。需要暂存的编译输出、对比快照、一次性脚本和工具日志放入为当前任务新建的 系统临时目录中的 `crtos-verify-<task>-<purpose>-XXXXXX/`（用 `mktemp -d` 创建，尊重 `TMPDIR`）；不用仓库 `.docs/` 充当工作区或备份目录。

一个阶段结束时执行一次收尾：

- 未完成时保留当前 formal 输入、证明、恢复所需状态和有效记录；完整验证结束后，输入及证明保留在全局位置，设计说明长期保留，其他记录按报告指南整理。
- 默认保留当前工程的 `.vo`，供编辑器交互式加载依赖；不得仅因它们可重建或本阶段结束而删除。仅在用户要求清理、修复已确认的缓存失效时清理相应范围。修复失效缓存时只重建受影响依赖，并保留重建后的 `.vo`。
- `.vos/.vok/.glob/.*.aux` 和 tactic cache 不一律保留：仅在当前工具或构建流程实际需要时保留，否则可在阶段收尾时清理。采用依赖 `.vos` 的快速编译流程时，须保留其加载所需产物，不能机械地只留 `.vo`。
- 删除重复 VC 副本、已被后续成功尝试取代且不再用于当前交互式工作的临时工作区，以及人工另存的 claim/finalize/step 回执副本。
- 任务中的 `/tmp` 备份只保留到目标写入、比较和必要检查成功；对应阶段结束后立即删除。不删除编辑器、Codex 或其他任务拥有的临时目录。
- 清理前确认目标没有被运行中的进程使用，且所依赖的最终摘要已存在。清理后检查报告链接、当前 revision 和正式构建输入未被损坏。

## 确认验证上下文

优先读取用户指定或项目已有的说明。开始时按[环境与路径配置](CONFIGURATION.md)读取用户配置，再按[工程组织与维护指南](references/project-maintenance-guide.md#路径配置与目录发现)确认源码与验证工程根目录、扫描现有目录结构，然后创建本次所需文件。

处理源码到验证切片的转换时，按照 [源代码处理](references/源代码处理.md) 执行，并结合当前配置与 TrustBase 核对适用条件。源码处理同时参考默认的 [源代码处理](references/源代码处理.md) 和可选配置 `source_processing` 指定的用户规则文件。两个文件分别保留，无需合并；冲突条目以用户规则为准，其余规则共同生效。未配置用户文件时使用默认文件。用户在当前任务中明确指定的规则同样优先于默认规则，具体配置见[用户源码处理规则](CONFIGURATION.md#用户源码处理规则)。本 skill 各处引用《源代码处理》时均遵循此约定。

开始时读取配置的 `trust_base`，未配置则查看项目已有信任说明；没有说明也可继续设计。信任文件由用户维护，agent 不修改。已有授权核对适用条件后直接使用，相关一致性检查仍须执行；新增或扩大信任范围须经用户批准。信任说明可以包括工具适配假设、一致性检查要求和 trusted specs等。Main agent 可以建议将复杂函数设为 `trusted`；用户明确批准具体函数及采用的 contract 后，才能跳过其函数体的递归验证，并在设计或审阅记录中注明。

## `slice-design`

### C 源码分析

配置的 `source_root` 是只读源码依据。源码适配和经用户批准的缺陷修复只修改验证工程全局annotated C中的源码副本；批准修复补丁不等于批准回写 `source_root`。只有用户另行明确要求修改原仓库时，才作为独立任务处理。副本修复后的验证结论须注明针对修复版本，不能宣称原源码已修复或已获证明；具体记录与门禁见下述指南。

Main agent 将源码分析交给 C analysis agent，按 [Predicate 指南第 1 节](references/predicate-lemma-design-guide.md#1-确认源码与范围)执行，分析结果用于后续 predicate 设计。源码问题的说明与处理见[源码错误报告](references/reporting-guide.md#源码错误报告)。

### Predicate 设计

Predicate design agent 使用 C analysis agent 的分析结果，按照 [Predicate 与 lemma 设计指南](references/predicate-lemma-design-guide.md)进行设计。开始新写或修改 predicate 前，先阅读该指南和 [Predicate 设计经验](references/predicate-experience.md)，经验条目只采用与当前 C 形态和控制流相符的内容。

Predicate design agent 从目标模块全部函数实际访问的 C 对象出发，确定模块的 abstract state、
owned memory、mutable fields、lifecycle states 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

### 已有定义复用

开始设计前先读取 CRTOS 全局库 当前验证工程的 `lib/`。已有定义直接导入复用，不重复定义。当前工程 annotated C、QCP 库及 crtosverify、LOSVerify、VRTOS 的证明参考位置见 [库与证明参考](#库与证明参考)。

新增定义直接写入全局 `lib/` 的所属模块文件；已有定义和必要imports在原位置增量修改。通过 `Require Import` 引用，需要向下游公开时使用 `Require Export`。沿用项目逻辑前缀，QCP等外部基础库按配置直接引用。

区分新增定义、语义修改、依赖适配和仅需重编译的文件，按具体使用点确定必要范围。接口调整以实际源码和依赖需要为依据。诊断和检查见[工程维护指南](references/project-maintenance-guide.md#全局工作区与依赖维护)。

### 文件组织与存放

本skill及指南中的lib、annotated C、VC布局和文件名模板均为默认示例，优先级为：**用户明确指定 > 项目已有约定 > 默认示例**。新增文件也沿用用户或项目约定；不为套用示例搬迁、重命名或重组现有文件。三类产物分别映射到实际目录，构建与工具随之适配，详见[文件组织以用户为准](references/project-maintenance-guide.md#文件组织以用户为准)。

新增或修改的全局库文件都是当前正式设计输入；审阅、revision冻结和实现交接覆盖实际输入及依赖版本。修改前记录工作树真实基线，不能用HEAD代替已有未提交内容；记录差异和影响，不把原有内容或仅路径适配计为新增证明成果。

开始验证时扫描已有 `lib/` 和annotated C目录，沿用各自布局；缺少目录才按以下默认结构创建，不为本任务搬迁已有文件。

全局库默认使用下列结构：

```text
lib/
├── common/                 # 共享 invariant/predicate 接口、系统组合、协议和通用引理
│   ├── <Module>Inv.v
│   └── CrtosInv.v
├── <module>/               # 模块状态操作、函数抽象与证明分解
│   ├── <Module>State.v
│   ├── <Module>Ops.v
│   └── K<Function>.v       # 函数专用抽象操作、program、引理或 proof support
└── index.md
```

具体职责如下：

- **`common/`**：放全局状态与系统不变量组合、统一 critical/IRQ 协议、通用内存/布局基础、共享 predicate/invariant 接口和跨模块引理。沿用 VRTOS 布局，`EventInv.v`、`MutexInv.v`、`SemaphoreInv.v`、`TaskInv.v` 等模块内存 invariant 仍放在 `common/`。
- **`<module>/`**：放该模块的状态操作、函数抽象 program、专用引理和实现证明分解。例如 `semaphore/SemaphoreState.v`、`semaphore/SemaphoreOps.v`、`semaphore/KSemaphoreCreate.v`。
- **分层优先**：是否放入 `common/` 取决于它是否属于共享 invariant/predicate 接口层，不只看文件名或引用次数。id、list 等具有独立概念和接口的子系统仍使用 `id/`、`list/` 等独立目录。
- **默认布局的根目录约定**：新建的分层库不在 `lib/` 根目录新增 `.v`；已有平铺库继续平铺，已有文件保留原路径，不为适配示例搬迁。路径确需调整时同步 imports、`_CoqProject`、Makefile、QCP 与编辑器配置。

文件拆分以实际职责和依赖关系为依据，不要求每个模块必须机械拥有 `State/Inv/Ops` 三个文件。系统组合文件导入各模块接口，模块文件不复制全局状态或系统协议。当全局state中模块级 state、predicate/invariant 和共享接口缺失时，补齐对应模块定义，并接入全局状态与系统不变量；已有定义直接复用。项目已有 OS 总状态和 `os_inv` 时，必须在其全局原定义中直接增加模块分量，保持同一套全局状态、系统不变量和临界区协议；不得另建包裹旧 state 的外层总状态或 `old_os_inv * module_inv` 外层不变量来替代这项集成。类型兼容或依赖调整的困难不构成绕开原定义的理由，具体要求见 [Predicate 指南第 7.4 节](references/predicate-lemma-design-guide.md#74-组合模块-predicate)。针对特定函数新增的抽象操作、program、局部 view、引理和证明辅助，统一放入该函数的 K<Function>.v，不另建函数专用的 State/Inv 文件。确属模块共享能力的增补，仍归入对应模块文件。

函数的 QCP `With/Require/Ensure` 仍写在 annotated C 中，不因 Rocq 目录分组而改变。新建C切片默认一函数一文件，已有文件组织按用户及项目约定处理；类型、宏、声明和共享 Coq 词汇按模块维护 header，沿用全局模块header位置（默认 `annotated_C/src/headers/`），与函数实现文件分开组织，不机械地为每个函数新建 header。详细路径和逻辑名见 [工程组织与维护指南](references/project-maintenance-guide.md#全局-lib-目录结构)。

### 定义注释与文件顺序

在重要定义旁用 `(** ... *)` 中文注释说明：它表示什么、与 C 对象或字段有什么关系，以及必要的使用限制。组合 predicate 说明各部分的作用和整体资源归属即可，不重复下层细节。注释随定义更新，让读者只看 `.v` 就能理解设计。具体示例见 [Predicate 指南第 10 节](references/predicate-lemma-design-guide.md#10-正式定义注释与设计说明)。

文件中先放定义，再放引理和证明。

### 设计记录与审阅准备

Predicate和spec的设计内容共同写入[设计说明](references/reporting-guide.md#设计说明)，解释本轮lib/spec改动的用途和原因，突出规格中需要人重点看的内容；实现阶段补充实际VC及关键证明的说明，实验完成后继续保留。


### 阅读材料与产物

- 必须读：已确认的验证上下文、目标 C/headers/config、全局 `lib/` 中已有定义、[predicate-lemma-design-guide.md](references/predicate-lemma-design-guide.md) 和 [Predicate 设计经验](references/predicate-experience.md)。开始新写或修改 predicate 前读取经验文件，并只采用其中与当前 C 形态和控制流相符的条目。
- 写：项目实际使用的 Rocq `.v`，把局部解释放在相关 definition/statement 前；同时更新[设计说明](references/reporting-guide.md#设计说明)中的改动原因、predicate含义、资源归属和系统集成关系。
- 修改已批准接口时，按 [验证记录指南](references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `write-spec`

### 验证范围

进入本模式前必须完整阅读 [spec-writing-guide.md](references/spec-writing-guide.md)。默认使用**一函数一文件切片**，直接放在全局annotated C所属模块目录，沿用已有布局。先按当前配置和 [源代码处理](references/源代码处理.md) 完成源码适配，
再从目标函数沿适配后切片中的直接调用、已解析的 function pointer/done-table dispatch 和宏展开后的调用
确定验证闭包。以文档规定的模型或 API contract 为边界，不再递归其原始内部调用。
从根 `annotated_C/` 或其他证明工程导入复用的依赖 spec 按下节作为 `reused-spec` 边界，不递归其内部调用安排实现证明。
闭包分类依据是本轮是否需要新写 spec，不是已有实现证明是否完成或能否移植。证明缺失、存在未完成义务或证明模型不同，均不自动取消 `reused-spec` 边界；规格语义的适用性仍须检查，证明状态另行记录。
其余调用递归至函数叶子或用户批准的 `trusted` 函数。Main agent 可以建议将复杂函数排除出
验证闭包，但不得代替用户决定。无法唯一解析的调用须说明调用位置和无法确定目标的原因，解决前阻塞 review。

### 已有 spec 复用与文件组织

以下是新建/空目录的默认组织；已有目录名称与布局优先。全文全局 `annotated_C/` 和 `src/...` 按扫描结果映射，平铺时直接使用该目录下的 canonical 文件。

全局 annotated C 只维护 `annotated_C/src/` 中的 canonical 输入：通用 kernel helper 放在 `src/kernel/common/`，模块函数放在 `src/kernel/<module>/`，架构和临界区外实现保留各自子目录。场景特化在相应canonical文件或caller声明中增补具名spec。`gen/` 和 `dep/` 按工具临时产物管理。本轮目标直接在全局canonical文件维护。

写 spec 时先查 当前工程解析后的 annotated C 目录，已有 spec 应在当前caller中导入并完成保持原语义的适配。复用、修改和场景特化统一按 [工程组织与维护指南](references/project-maintenance-guide.md#annotated-c-的增量维护)执行。

从该目录或其他证明工程导入复用已有 spec 的依赖函数，本轮不生成其实现的 VC，也不重新证明函数体；记录为 `reused-spec` 边界并检查适用性及接口一致性。具体范围与新增、修改规格的处理见 [已有 spec 的复用与特化](references/project-maintenance-guide.md#已有-spec-的复用与特化)。

- 导入的 spec 直接以函数声明及完整 `With/Require/Ensure` 写在使用它的 `f.c` 中、`f` 的定义前，并标明来源和 revision；不为导入的 `g` 新建 `annotated_C/src/g.c`，也不复制其函数体。多个 caller 使用时分别放置所需 spec，并核对它们与同一来源版本一致。
- 除用户明确指定的函数体证明目标外，只有本轮确实新写 spec 的函数才建立独立函数文件，包含真实 body 和 canonical spec；已有本轮目标文件在原处修改。导入已有 spec、等价适配及从已有 spec 推导的场景特化均不触发复制 body。不得因为旧证明未完成、含 `Admitted`、缺少 proof 文件或不适用于当前证明模型，就把已有 spec 改列为“本轮新写”并扩展 `src/`。
- 仅供模块predicate分析的其他函数直接读取源码，不另存函数体；修复或适配方案在报告中说明，正式编写spec时再落实到canonical文件。已有全局canonical文件不因本轮未选中而删除，也不自动纳入本轮证明。

- 本轮实现验证的每个函数 `f` 都要有明确的canonical位置，包含唯一真实active定义、完整函数体和canonical `With/Require/Ensure`。新建单函数切片默认命名为 `f.c`；已有多函数文件或用户指定组织方式直接沿用，以函数名和位置标识目标。
- `f.c` 中调用 `g` 时，只在 `f` 的定义前写 `g` 的完整 declaration-only API spec，不复制
  `g` 的函数体。`g` 必须在闭包中有自己的 active canonical 文件、属于上述源码适配的模型/API 或 `reused-spec` 边界，或由用户批准为 `trusted`；
  前者的 caller-local contract 必须与 canonical 文件中所选的同名 spec alpha/typedef 等价，包含新增的具名特化 spec；不得只在 caller 中另写一份不受 canonical 管理的规格。

### 函数约定与表达

- 调用另一个函数时，不能只写它的 C 声明，还要提供完整的 `With/Require/Ensure`，说明调用需要什么条件和资源、结束后得到什么结果。调用处应给出所需的逻辑参数。
- 上层函数用模块或对象的 predicate 描述行为，例如“创建一个信号量并加入管理集合”，不必重复展开每个字段和链表指针。具体内存细节放在 predicate 定义或底层操作中；调用条件、各条路径的结果和资源变化仍要看得清楚，不能全部藏在含义不明的 `xxx_pre`、`xxx_post` 中。具体写法参考 [Spec 编写指南](references/spec-writing-guide.md)。

### 闭包检查与审阅准备

结束 `write-spec` 前必须从适配后的目标函数重新扫描完整可达闭包。目标函数及每个递归可达 symbol 都必须
恰好满足一项：属于《源代码处理》规定且适用的模型/API 边界，并记录规则及 contract；
属于 `reused-spec` 边界，并记录原 spec 来源、revision 及一致的导入 contract；
由用户批准为 `trusted` 并记录 contract；或者具有明确的canonical位置、唯一active body、canonical spec和一致的caller-local contracts。
模型/API 与 `reused-spec` 边界的 caller-local contracts 同样须与所采用接口一致；已按规则删除、替换或由复用 spec 覆盖的内部调用不作为实现闭包缺失。
任何缺失、裸 call、未解析 dispatch/宏调用或多重归类都是 blocker。此模式只设计和审阅 spec，
不启动 QCP verification-orchestrator。Predicate `review-passed`
前不得进入 spec review 或请求用户批准。

复用 spec 的实现证明未完成或未适配，本身不是设计审阅 blocker，也不是补建函数文件的理由；报告应明确这是依赖契约而非本轮已证函数。若 spec 本身不适用于实际调用，则解决契约语义或适配问题，不能用记录证明状态代替这项检查。

Spec review-ready 条件：引用的 predicate revision 为 `review-passed`；已按 spec writing guide 完成
scope-faithfulness 检查；完整可达闭包及目标函数全部 return/blocking path 已列出；正式 contract 与
annotated C `With/Require/Ensure` 已写出且直接可读；每个 load/store 能追溯到 reviewed predicate；
Rocq predicate 文件通过 compile/typecheck，annotated C 已完成人工结构和源码等价性检查；没有影响
路径、effect、ownership、frame 或依赖结论的已知未解决问题，才达到 review-ready。

### 阅读材料与产物

- 必须读：已确认的验证上下文、当前 predicate 草案、完整可达闭包中的 C 与各 caller-local callee specs、[spec-writing-guide.md](references/spec-writing-guide.md) 和 [Spec 设计经验](references/spec-experience.md)。开始新写或修改 spec 前读取经验文件，并只采用其中与当前 C 形态、函数层次和控制流相符的条目。Spec review 时必须固定同一份 `review-passed` predicate revision。
- 写：当前函数的 canonical spec 直接写在其唯一 active 定义上；正文中每个
  真实 callee 对应的完整 declaration-only API spec 写在同一文件、当前定义
  之前。不得集中建立模块级 `*_specs.h`，不得用裸prototype代替spec。

### 草案迭代与后续验证

- 草案迭代：完成一批 annotated C、predicate 或 callee-contract 修改后，确定改动文件及其 transitive callers，重新检查受影响的源码路径、验证范围、callee contract 和 ownership；编译变化的Rocq文件及因依赖改变需要重编译的使用处。草案本身不做中间review；若共享修改使已有通过结论失效，须标为 `invalidated` 并复查受影响部分。不得通过加强无依据Require、弱化Ensure或声明deferred来取得通过。
- 完整闭包：候选首次满足其他 review-ready 条件后，从目标函数重新扫描完整可达闭包并固定 revision，交由 `review` 审阅。
- 设计阶段人工核对调用闭包；QCP闭包检查、symbolic、VC生成与实现证明由用户批准后的verification-orchestrator执行。纯文档或报告修改不产生新的设计 revision。
- Spec review 遵循 [验证记录指南](references/reporting-guide.md)，不要求套用统一模板。
- 修改已批准 predicate/spec 时，按 [验证记录指南](references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `implement`

只有用户明确确认 review-passed predicate/spec revisions 后才能进入。Main agent 读取
已配置 QCP 根目录中的 `AGENTS.md`，按[路径配置](references/project-maintenance-guide.md#implement-阶段的-qcp-路径配置)将验证工作目录指向验证工程根目录，按[QCP工具适配](references/implementation-and-validation-guide.md#qcp工具适配)要求由 QCP 工具适配本 OS 的全局工程格式，从其中指定的 `verification-orchestrator` 启动 QCP workflow，
把已批准 predicate/spec 作为冻结输入，然后只执行 controller 返回的 action，直到 `done`、明确 blocker 或达到证明时间预算。

开始目标证明前，按[工具就绪条件](references/implementation-and-validation-guide.md#证明前的工具就绪条件)确认环境已配置可用；同一环境复用已有成功结果，之后按 QCP workflow 推进。环境错误先修复。

交接时落实[每个目标函数累计 100 分钟的 VC 证明预算](references/implementation-and-validation-guide.md#vc-证明时间预算)，到时保存状态并等待用户决定是否追加时间。

交接时提供 TrustBase 文件路径，并明确按 spec 设计确定的本轮实现证明目标与 `reused-spec` 清单；导入复用函数不提交为 VC/函数体证明目标，也不因其证明状态自动扩大范围。复用依赖的证明状态和结论限制须随交接传递，不能将其冒称为已证或自动改标 trusted。trusted 和 reused-spec contract 均不作为本轮新完成的实现证明计数。

已采用审阅白名单时，要求 QCP annotation owner 及后续涉及设计检查的任务直接通过白名单中描述情况，但不因此跳过任何实际 VC。

交接给 QCP workflow 时必须明确 VC 文件修改边界：手工完成 VC 证明只修改 `*_proof_manual.v`；不得手工修改 `*_proof_auto.v`、`*_goal.v` 或 `*_goal_check.v`。

Annotation、spec、predicate、VC 和 proof 的诊断、修正与重试全部由该 workflow 按自己的规则处理；
main agent 不再定义第二套步骤或返回状态。具体调用边界见
[implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。

## `review`

审阅是对照当前配置下的项目 C 源码，检查 predicate/spec 是否准确描述了验证对象和行为。默认只读，只检查用户指定的文件和版本；除非用户同时要求修改，不实施修复或代替用户批准。Predicate 和 spec 分别给出结论；设计审阅通过不表示 C 实现已经得到证明。

审阅时读取对应正式文件、源码证据、修改差异和检查结果，以及该模式的指南。Predicate 审阅同时查看带注释的 `.v` 和设计记录。

### 审阅内容与通过条件

- **Predicate**：检查是否准确描述源码中的对象、内存归属及生命周期，是否存在资源遗漏、重复归属或无依据假设。检查方法见 [Predicate 指南第 11 节](references/predicate-lemma-design-guide.md#11-检查并审阅-predicates)。
- **Spec**：检查验证范围是否符合目标，每条真实路径的参数、返回值、状态变化、资源转移及未修改资源是否与 C 一致；`Require` 是否足以执行且没有无依据地加强调用条件，`Ensure` 是否准确表达应保证的行为；临界区及调用者资源是否在出口正确返还；被调用函数是否被错误标成已验证。不得有无依据假设或阻塞问题。详细检查项见 [Spec 指南第 6 节](references/spec-writing-guide.md#6-spec-审阅)。

- **最终完整性检查**：确认 QCP controller 已返回 `done`，复用其 `final-check` 结果，不重复执行证明检查。同时确认切片与原始 CRTOS 源码的一致性结论仍然有效：源码、配置及切片相关内容未变时复用 Spec 审阅结论，有变化则重新核对受影响部分。QCP 的完成状态不能替代这项源码一致性确认；还须确认[收尾流程](#全局一致性检查与收尾)中的全局编译、引用检查及记录安置已完成，才能给出最终完整性通过结论。

最终结论区分已证明结论和信任假设；对基于 TrustBase 的源码适配说明适用配置及结论限制，不将其表述为无条件的源码等价。TrustBase 或实际依赖发生变化时，只复查受影响结论，不把新条目自动追认为旧证明的依据。

具体检查按目标代码及设计选择适用项，不要求逐项写报告；适用的编译、类型或证明检查须通过，影响正确性的未解决问题仍阻塞审阅通过。

Spec 审阅使用明确的、已通过审阅的 predicate 版本。两者分别 `review-passed` 后，提供更新后的[设计说明](references/reporting-guide.md#设计说明)及注明两份revision的审阅记录。在完整验证流程中，main agent 随后请用户确认两份明确 revisions；确认前不得启动 QCP verification-orchestrator。确认后执行 implement，只有 controller 返回 `done`（含 `final-check`）后，才按[全局一致性检查与收尾](#全局一致性检查与收尾)执行收尾。

### 审阅与复查

Predicate/spec 草案（`draft`）可以共同修改，不做中间审阅。满足设计阶段的准备条件后标为 `review-ready`，首次做完整审阅；需要修复时标为 `needs-fix`，满足上述通过条件后才标为 `review-passed`。

写 spec 时发现现有 predicate 无法描述某个对象或操作过程，应先补充 predicate，再继续写 spec。草案直接修改；涉及已通过审阅的 predicate 时，重新审阅受影响部分后再继续 spec 审阅。

修复后只检查已报告的问题、修改处及直接或间接受影响的内容。格式、报告或不影响设计结论的证明步骤修改不触发设计重审；同一版本和依据不重复审阅。同一阻塞问题没有新修改或证据时，停止重复检查并向用户说明。

修改使原来的通过结论不再适用时，将该结论标为 `invalidated`，重新审阅受影响的部分；不影响结论的变化无需重审。

审阅记录的写法见 [验证记录指南](references/reporting-guide.md)。

## 全局一致性检查与收尾

输入和证明直接维护在全局位置。用户确认revisions且controller返回 `done`（含 `final-check`）后，main agent完成以下收尾：

1. 按[统计要求](references/reporting-guide.md#最终报告)记录manual/lib相对于修改前基线的增量，保留已有定义、spec、证明和其他任务内容。
2. 确认根构建、imports、逻辑路径、工具及编辑器引用一致，编译受影响的库及依赖者，实现目标检查到goal_check。复用同版本成功检查，不为收尾重复整库构建或重新生成VC。旧结论因共享修改不再适用时明确标记并处理，不能借旧 `.vo` 或旧done记录宣称当前版本通过。
3. 按[保留规则](references/reporting-guide.md#完成后保留什么)保留并更新设计说明，整理最终验证报告与源码缺陷记录，链接当前全局文件、revision、结果及剩余限制。
4. 完成[最终完整性审阅](#审阅内容与通过条件)，清理已不需要的任务临时产物，保留 `.vo` 和仍在使用的workflow恢复状态。不删除全局lib、annotated C或VC。

仅设计审阅或尚未完成证明时，保留当前输入与有效记录，明确draft、review-passed、未证或invalidated状态，不因文件在全局目录就报告验证完成。设计改变和证明恢复沿用同一全局输入，未解决的依赖问题如实报告。

## 项目与参考路径

验证工程根目录由用户指定或当前配置确定。根 `_CoqProject` 和Makefile统一管理全局lib、VC及外部基础库；构建、QCP和编辑器使用同一配置与已有逻辑前缀。必要依赖适配与编译随当前改动完成，见[工程维护指南](references/project-maintenance-guide.md#全局工作区与依赖维护)。

验证以当前配置下的真实 CRTOS 源码为基线；如有批准的副本修复，验证对象为记录了差异的修复版本。除按源码问题门禁批准的副本修复外，完整源码模式只修改副本中的注解；单函数切片按上述《源代码处理》规则适配，其他工具转换须保持程序行为，并在 spec review 中说明转换位置、理由及源码依据。不得超出已规定的适配范围改变算法、遗漏执行路径或副作用，也不得使用错误的数据布局。缺陷修复不得冒充等价转换。等价转换示例见 [Spec 编写指南](references/spec-writing-guide.md#单函数切片的等价转换)。

### 库与证明参考

写新定义、strategy 或断言前，先查 CRTOS 全局库及当前工程的 annotated C，再查 QCP 库；需要参考设计或证明方法时，查看已配置且可用的 crtosverify、LOSVerify 和 VRTOS；未配置的参考直接跳过。查找实际定义和用法，不猜测 QCP 语法。

外部根目录由配置的 `references` 提供；QCP 来自必填的 `qcp_root`。“位置”是查找提示，以实际扫描结果为准。

| 来源 | 位置 | 用途 |
|---|---|---|
| 当前工程全局库 | `lib/<module>/`、`lib/common/` | 复用模块定义、predicate<br>和已证明引理。 |
| 当前工程 annotated C | `annotated_C/src/kernel/<module>/`、<br>`annotated_C/src/kernel/common/` | 查找函数 spec、注解、断言<br>和 strategy 用法。 |
| QCP 基础库 | QCP 仓库的 `Rocq/SeparationLogic/`、`Rocq/MonadLib/`、<br>`Rocq/StrategyLib/`、`Rocq/auxlibs/` 等 | 复用分离逻辑、抽象 program、<br>strategy、tactic 及通用引理。 |
| QCP 示例 | QCP 仓库的 `Rocq/examples/`、`QCP_examples/` 及项目教程 | 参考注解、assertion、<br>`which implies` 和证明写法。 |
| `references.crtos_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/` | 参考 CRTOS 模块定义、predicate、<br>spec 和 VC 证明。 |
| `references.los_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 OS 模块、spec 和证明，<br>如 `lib/sem.v`、`lib/task.v`。 |
| `references.vrtos`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 CRTOS 对象表示、spec 和证明。 |

已有 spec 的复用与修改按上述“已有 spec 复用与文件组织”执行。全局文件须结合revision与审阅记录确认状态，不把已有文件直接视为已证。

复用定义或已证明结论时，确认其适用性、证明状态、依赖假设和当前工程兼容性。复用已有 spec 则是采用来源文件中的契约，不等于其函数体已经证明；其范围与状态记录按上述 `reused-spec` 规则处理。“参考”允许借鉴设计和证明方法，不表示整个目录已经可信，也不替代用户对具体 `trusted` C symbol 的批准。

跨模块调用复用全局 `lib/` 已有定义，不重复增加已有概念。接口缺少内容时直接在所属模块原文件增补；定义不符合当前C或skill要求时说明修改依据，处理受影响的使用处及证明状态，不等待实现完成才集成。
