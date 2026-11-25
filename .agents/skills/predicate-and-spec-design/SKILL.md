---
name: predicate-and-spec-design
description: 基于 OS 验证切片设计或修改模块 Rocq predicate、抽象操作和 QCP 函数 spec，完成 Human / AI 审阅并记录明确 revision 与结论。
---

# Predicate and Spec Design

沿用主编排的[共用约束](../os-verification-coordinator/SKILL.md#通用验证约束)与[环境配置](../os-verification-coordinator/CONFIGURATION.md)，复用已有上下文及有效授权。

审阅作为本阶段的一部分，按用户或项目选择 Human / AI；记录实际结论。人审已明确批准相同 revisions 时复用授权，AI 审阅不代替用户批准。

### Predicate 设计

Predicate design agent 使用 C analysis agent 的分析结果，按照 [Predicate 与 lemma 设计指南](references/predicate-lemma-design-guide.md)进行设计。开始新写或修改 predicate 前，先阅读该指南和 [Predicate 设计经验](references/predicate-experience.md)，经验条目只采用与当前 C 形态和控制流相符的内容。

Predicate design agent 从目标模块全部函数实际访问的 C 对象出发，确定模块的 abstract state、
owned memory、mutable fields、lifecycle states 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

### 已有定义复用

开始设计前先读取 CRTOS 全局库 当前验证工程的 `lib/`。已有定义直接导入复用，不重复定义。当前工程 annotated C、QCP 库及 crtosverify、LOSVerify、VRTOS 的证明参考位置见 [库与证明参考](../os-verification-coordinator/SKILL.md#库与证明参考)。

新增定义直接写入全局 `lib/` 的所属模块文件；已有定义和必要imports在原位置增量修改。通过 `Require Import` 引用，需要向下游公开时使用 `Require Export`。沿用项目逻辑前缀，QCP等外部基础库按配置直接引用。

区分新增定义、语义修改、依赖适配和仅需重编译的文件，按具体使用点确定必要范围。接口调整以实际源码和依赖需要为依据。诊断和检查见[工程维护指南](../os-verification-coordinator/references/project-maintenance-guide.md#全局工作区与依赖维护)。

### 文件组织与存放

本skill及指南中的lib、annotated C、VC布局和文件名模板均为默认示例，优先级为：**用户明确指定 > 项目已有约定 > 默认示例**。新增文件也沿用用户或项目约定；不为套用示例搬迁、重命名或重组现有文件。三类产物分别映射到实际目录，构建与工具随之适配，详见[文件组织以用户为准](../os-verification-coordinator/references/project-maintenance-guide.md#文件组织以用户为准)。

新增或修改的全局库文件都是当前正式设计输入；审阅、revision冻结和实现交接覆盖实际输入及依赖版本。修改前记录工作树真实基线，不能用HEAD代替已有未提交内容；记录差异和影响，不把原有内容或仅路径适配计为新增证明成果。

开始验证时扫描已有 `lib/` 和annotated C目录，沿用各自布局；缺少目录才按以下默认结构创建，不为本任务搬迁已有文件。

全局库默认使用下列结构：

```text
lib/
├── common/                 # 全局状态与不变量组合、公共协议和通用基础库
│   └── CrtosInv.v
├── <module>/               # 模块状态、资源与不变量、抽象操作及证明
│   ├── <Module>State.v
│   ├── <Module>Inv.v
│   ├── <Module>Ops.v
│   └── K<Function>.v       # 函数专用抽象操作、program、引理或 proof support
└── index.md
```

具体职责如下：

- **`common/`**：放全局状态与系统不变量组合、统一 critical/IRQ 协议，以及通用内存、布局和跨模块基础定义。`CrtosInv.v` 从各模块导入 invariant 并组合成系统的 `os_inv`。
- **`<module>/`**：放该模块的状态、对象与资源 predicate、模块 invariant、抽象操作、专用引理和实现证明分解。例如 `semaphore/SemaphoreInv.v`、`dataqueue/DataqueueState.v`等。
- **按资源与模块职责归档**：模块 invariant 被 `os_inv` 或其他模块引用，不是移入 `common/` 的理由。同类模块定义使用一致的归档方式；id、list 等独立子系统的定义也放在各自目录。已有工程采用其他统一布局时按项目约定维护，不把参考工程的另一套布局局部混入当前工程。
- **默认布局的根目录约定**：新建的分层库不在 `lib/` 根目录新增 `.v`；已有平铺库继续平铺，已有文件保留原路径，不为适配示例搬迁。路径确需调整时同步 imports、`_CoqProject`、Makefile、QCP 与编辑器配置。

文件拆分以实际职责和依赖关系为依据，不要求每个模块必须机械拥有 `State/Inv/Ops` 三个文件。系统组合文件导入各模块接口，模块文件不复制全局状态或系统协议。当全局state中模块级 state、predicate/invariant 和共享接口缺失时，补齐对应模块定义，并接入全局状态与系统不变量；已有定义直接复用。项目已有 OS 总状态和 `os_inv` 时，必须在其全局原定义中直接增加模块分量，保持同一套全局状态、系统不变量和临界区协议；不得另建包裹旧 state 的外层总状态或 `old_os_inv * module_inv` 外层不变量来替代这项集成。类型兼容或依赖调整的困难不构成绕开原定义的理由，具体要求见 [Predicate 指南第 7.4 节](references/predicate-lemma-design-guide.md#74-组合模块-predicate)。针对特定函数新增的抽象操作、program、局部 view、引理和证明辅助，统一放入该函数的 K<Function>.v，不另建函数专用的 State/Inv 文件。确属模块共享能力的增补，仍归入对应模块文件。

函数的 QCP `With/Require/Ensure` 仍写在 annotated C 中，不因 Rocq 目录分组而改变。新建C切片默认一函数一文件，已有文件组织按用户及项目约定处理；类型、宏、声明和共享 Coq 词汇按模块维护 header，沿用全局模块header位置（默认 `annotated_C/src/headers/`），与函数实现文件分开组织，不机械地为每个函数新建 header。详细路径和逻辑名见 [工程组织与维护指南](../os-verification-coordinator/references/project-maintenance-guide.md#全局-lib-目录结构)。

### 定义注释与文件顺序

在重要定义旁用 `(** ... *)` 中文注释说明：它表示什么、与 C 对象或字段有什么关系，以及必要的使用限制。组合 predicate 说明各部分的作用和整体资源归属即可，不重复下层细节。注释随定义更新，让读者只看 `.v` 就能理解设计。具体示例见 [Predicate 指南第 10 节](references/predicate-lemma-design-guide.md#10-正式定义注释与设计说明)。

文件中先放定义，再放引理和证明。

### 设计记录与审阅准备

Predicate和spec的设计内容共同写入[设计说明](../verification-report/references/reporting-guide.md#设计说明)，解释本轮lib/spec改动的用途和原因，突出规格中需要人重点看的内容；实现阶段补充实际VC及关键证明的说明，实验完成后继续保留。


### 阅读材料与产物

- 必须读：已确认的验证上下文、目标 C/headers/config、全局 `lib/` 中已有定义、[predicate-lemma-design-guide.md](references/predicate-lemma-design-guide.md) 和 [Predicate 设计经验](references/predicate-experience.md)。开始新写或修改 predicate 前读取经验文件，并只采用其中与当前 C 形态和控制流相符的条目。
- 写：项目实际使用的 Rocq `.v`，把局部解释放在相关 definition/statement 前；同时更新[设计说明](../verification-report/references/reporting-guide.md#设计说明)中的改动原因、predicate含义、资源归属和系统集成关系。
- 修改已批准接口时，按 [验证记录指南](../verification-report/references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `write-spec`

### 验证范围

进入本模式前必须完整阅读 [spec-writing-guide.md](references/spec-writing-guide.md)。默认使用**一函数一文件切片**，直接放在全局annotated C所属模块目录，沿用已有布局。先按当前配置和 [源代码处理](../source-processing/references/source-processing-guide.md) 完成源码适配，
再从目标函数沿适配后切片中的直接调用、已解析的 function pointer/done-table dispatch 和宏展开后的调用
确定验证闭包。以文档规定的模型或 API contract 为边界，不再递归其原始内部调用。
从根 `annotated_C/` 或其他证明工程导入复用的依赖 spec 按下节作为 `reused-spec` 边界，不递归其内部调用安排实现证明。
闭包分类依据是本轮是否需要新写 spec，不是已有实现证明是否完成或能否移植。证明缺失、存在未完成义务或证明模型不同，均不自动取消 `reused-spec` 边界；规格语义的适用性仍须检查，证明状态另行记录。
其余调用递归至函数叶子或用户批准的 `trusted` 函数。Main agent 可以建议将复杂函数排除出
验证闭包，但不得代替用户决定。无法唯一解析的调用须说明调用位置和无法确定目标的原因，解决前阻塞 review。

### 已有 spec 复用与文件组织

以下是新建/空目录的默认组织；已有目录名称与布局优先。全文全局 `annotated_C/` 和 `src/...` 按扫描结果映射，平铺时直接使用该目录下的 canonical 文件。

全局 annotated C 只维护 `annotated_C/src/` 中的 canonical 输入：通用 kernel helper 放在 `src/kernel/common/`，模块函数放在 `src/kernel/<module>/`，架构和临界区外实现保留各自子目录。场景特化在相应canonical文件或caller声明中增补具名spec。`gen/` 和 `dep/` 按工具临时产物管理。本轮目标直接在全局canonical文件维护。

写 spec 时先查 当前工程解析后的 annotated C 目录，已有 spec 应在当前caller中导入并完成保持原语义的适配。复用、修改和场景特化统一按 [工程组织与维护指南](../os-verification-coordinator/references/project-maintenance-guide.md#annotated-c-的增量维护)执行。

从该目录或其他证明工程导入复用已有 spec 的依赖函数，本轮不生成其实现的 VC，也不重新证明函数体；记录为 `reused-spec` 边界并检查适用性及接口一致性。具体范围与新增、修改规格的处理见 [已有 spec 的复用与特化](../os-verification-coordinator/references/project-maintenance-guide.md#已有-spec-的复用与特化)。

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
- Spec review 遵循 [验证记录指南](../verification-report/references/reporting-guide.md)，不要求套用统一模板。
- 修改已批准 predicate/spec 时，按 [验证记录指南](../verification-report/references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `review`

审阅是对照当前配置下的项目 C 源码，检查 predicate/spec 是否准确描述了验证对象和行为。默认只读，只检查用户指定的文件和版本；除非用户同时要求修改，不实施修复或代替用户批准。Predicate 和 spec 分别给出结论；设计审阅通过不表示 C 实现已经得到证明。

审阅时读取对应正式文件、源码证据、修改差异和检查结果，以及该模式的指南。Predicate 审阅同时查看带注释的 `.v` 和设计记录。

### 审阅内容与通过条件

- **Predicate**：检查是否准确描述源码中的对象、内存归属及生命周期，是否存在资源遗漏、重复归属或无依据假设。检查方法见 [Predicate 指南第 11 节](references/predicate-lemma-design-guide.md#11-检查并审阅-predicates)。
- **Spec**：检查验证范围是否符合目标，每条真实路径的参数、返回值、状态变化、资源转移及未修改资源是否与 C 一致；`Require` 是否足以执行且没有无依据地加强调用条件，`Ensure` 是否准确表达应保证的行为；临界区及调用者资源是否在出口正确返还；被调用函数是否被错误标成已验证。不得有无依据假设或阻塞问题。详细检查项见 [Spec 指南第 6 节](references/spec-writing-guide.md#6-spec-审阅)。

- **最终完整性检查**：确认 QCP controller 已返回 `done`，复用其 `final-check` 结果，不重复执行证明检查。同时确认切片与原始 CRTOS 源码的一致性结论仍然有效：源码、配置及切片相关内容未变时复用 Spec 审阅结论，有变化则重新核对受影响部分。QCP 的完成状态不能替代这项源码一致性确认；还须确认[收尾流程](../verification-report/SKILL.md#全局一致性检查与收尾)中的全局编译、引用检查及记录安置已完成，才能给出最终完整性通过结论。

最终结论区分已证明结论和信任假设；对依赖信任假设的源码适配说明适用配置及结论限制，不将其表述为无条件的源码等价。信任授权、适配假设或实际依赖发生变化时，只复查受影响结论，不把新条目自动追认为旧证明的依据。

具体检查按目标代码及设计选择适用项，不要求逐项写报告；适用的编译、类型或证明检查须通过，影响正确性的未解决问题仍阻塞审阅通过。

Spec 审阅使用明确的、已通过审阅的 predicate 版本。两者分别 `review-passed` 后，提供更新后的[设计说明](../verification-report/references/reporting-guide.md#设计说明)及注明两份revision的审阅记录。在完整验证流程中，main agent 随后请用户确认两份明确 revisions；确认前不得启动 QCP verification-orchestrator。确认后执行 implement，只有 controller 返回 `done`（含 `final-check`）后，才按[全局一致性检查与收尾](../verification-report/SKILL.md#全局一致性检查与收尾)执行收尾。

### 审阅与复查

Predicate/spec 草案（`draft`）可以共同修改，不做中间审阅。满足设计阶段的准备条件后标为 `review-ready`，首次做完整审阅；需要修复时标为 `needs-fix`，满足上述通过条件后才标为 `review-passed`。

写 spec 时发现现有 predicate 无法描述某个对象或操作过程，应先补充 predicate，再继续写 spec。草案直接修改；涉及已通过审阅的 predicate 时，重新审阅受影响部分后再继续 spec 审阅。

修复后只检查已报告的问题、修改处及直接或间接受影响的内容。格式、报告或不影响设计结论的证明步骤修改不触发设计重审；同一版本和依据不重复审阅。同一阻塞问题没有新修改或证据时，停止重复检查并向用户说明。

修改使原来的通过结论不再适用时，将该结论标为 `invalidated`，重新审阅受影响的部分；不影响结论的变化无需重审。

审阅记录的写法见 [验证记录指南](../verification-report/references/reporting-guide.md)。
