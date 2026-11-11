---
name: verify-an-os-function
description: 验证 CRTOS 等非 SMP OS 的 C 函数与模块：设计并审阅 Rocq predicate 与 QCP spec，用户确认 revision 后交给 QCP verification-orchestrator 完成实现证明。
---

# 验证 CRTOS 函数

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

`SKILL.md.orig` 是历史备份，不作为执行入口或参考依据，不从中继承路径、信任授权或流程约定。

验证记录保存在 trial 的 `.docs/Report/` 中。按实际需要组织，可合并相关内容，不要求每类单独成文。报告类型与写法见 [验证记录指南](references/reporting-guide.md)。

## 总流程

Main agent 负责确定模式、安排顺序、守住审批门并汇总结果。作者与 reviewer 应分开；predicate review 和 spec review 分别明确对象、条件和结论，可写在同一份记录中。Review 次数不预设，由产物 revision、修改影响和通过条件决定。没有独立检查能力时，由 main agent 按相同条件自检并注明。

```text
确认验证上下文 -> C 分析 -> predicate 与 spec 草案迭代
             -> predicate review-passed -> spec review-passed
             -> 用户确认两份 revision
             -> QCP verification-orchestrator implement（含 final-check）
             -> implement done 后自动合并 trial 库及复用 spec 的增量修改到全局目录并完成一致性检查
             -> 最终完整性审阅与结果汇总
```

## 通用验证约束

设计阶段可以先写引理陈述，不要求立即完成证明；未证明的内容必须明确为待证义务，不能当作已证明结论使用。

### 临时产物与保留边界

`trial/.docs/Report/` 只保存人工可读的当前设计、审阅、错误和最终完整性记录。不把完整 formal source、控制器每步返回、编译目录或多份状态摘要复制进报告目录。

验证中仍在使用的 QCP `reports/`、`verification_runs/` 和正式 `VC/` 由 verification-orchestrator 管理，main agent 不自行整理、改写或提前删除。需要暂存的编译输出、对比快照、一次性脚本和工具日志放入为当前任务新建的 系统临时目录中的 `crtos-verify-<trial>-<purpose>-XXXXXX/`（用 `mktemp -d` 创建，尊重 `TMPDIR`）；不用仓库 `.docs/` 充当工作区或备份目录。

一个阶段结束时执行一次收尾：

- 保留当前 formal 输入与证明、当前 revision/manifest、有效的 review 结论、必要的源码对应与信任假设，以及 `done` 后的 final-check/最终完整性摘要。
- 删除可重建的 `.vo/.vos/.vok/.glob/.*.aux`、tactic cache、重复 VC 副本、已被后续成功尝试取代的工作区，以及人工另存的 claim/finalize/step 回执副本。
- 任务中的 `/tmp` 备份只保留到目标写入、比较和必要检查成功；对应阶段结束后立即删除。不删除编辑器、Codex 或其他任务拥有的临时目录。
- 清理前确认目标没有被运行中的进程使用，且所依赖的最终摘要已存在。清理后检查报告链接、当前 revision 和正式构建输入未被损坏。

## 确认验证上下文

优先读取用户指定或项目已有的说明。开始时按[环境与路径配置](CONFIGURATION.md)读取用户配置，再按[工程组织与维护指南](references/project-maintenance-guide.md#路径配置与目录发现)确认源码与验证工程根目录、扫描现有目录结构，然后创建本次所需文件。

源码处理同时参考默认的 [源代码处理](references/源代码处理.md) 和可选配置 `source_processing` 指定的用户规则文件。两个文件分别保留，无需合并；冲突条目以用户规则为准，其余规则共同生效。未配置用户文件时使用默认文件。用户在当前任务中明确指定的规则同样优先于默认规则，具体配置见[用户源码处理规则](CONFIGURATION.md#用户源码处理规则)。本 skill 各处引用《源代码处理》时均遵循此约定。

开始时读取配置的 `trust_base`，未配置则查看项目已有信任说明；没有说明也可继续设计。信任文件由用户维护，agent 不修改。已有授权核对适用条件后直接使用，相关一致性检查仍须执行；新增或扩大信任范围须经用户批准。中可以包括工具适配假设、一致性检查要求和 trusted specs等。Main agent 可以建议将复杂函数设为 `trusted`；用户明确批准具体函数及采用的 contract 后，才能跳过其函数体的递归验证，并在设计或审阅记录中注明。

## `slice-design`

### C 源码分析

Main agent 将源码分析交给 C analysis agent，按 [Predicate 指南第 1 节](references/predicate-lemma-design-guide.md#1-确认源码与范围)执行，分析结果用于后续 predicate 设计。源码问题的处理与设计前门禁见[验证记录指南](references/reporting-guide.md#源码问题门禁)。

### Predicate 设计

Predicate design agent 使用 C analysis agent 的分析结果，按照 [Predicate 与 lemma 设计指南](references/predicate-lemma-design-guide.md)进行设计。开始新写或修改 predicate 前，先阅读该指南和 [Predicate 设计经验](references/predicate-experience.md)，经验条目只采用与当前 C 形态和控制流相符的内容。

Predicate design agent 从目标模块全部函数实际访问的 C 对象出发，确定模块的 abstract state、
owned memory、mutable fields、lifecycle states 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

### 已有定义复用

开始设计前先读取 CRTOS 全局库 当前验证工程的 `lib/`。已有定义直接导入复用，不重复定义。当前工程 annotated C、QCP 库及 crtosverify、LOSVerify、VRTOS 的证明参考位置见 [库与证明参考](#库与证明参考)。

Trial 中所有本地库文件统一平铺在 `trial/lib/`，只记录其全局来源或目标路径，不建模块子目录。使用处通过 `Require Import` 引用；需要向下游公开的接口使用 `Require Export`。

已有共享库允许按源码和验证需求增补或修改；无需修改的定义直接导入，需要修改的文件在 trial 副本中处理。修改范围、依赖调整与审阅要求统一按 [工程组织与维护指南](references/project-maintenance-guide.md#已有共享库的复用与修改)执行。

### 文件组织与存放

`trial/lib/` 只保存本次需要修改的全局库文件副本及新增库文件，所有 `.v` 都直接放在该目录下。复制已有文件时记录全局来源和基线；新增文件时记录 implement 完成后的目标全局路径。无需改动的库文件继续直接引用全局版本。

开始验证时，先扫描当前目录下有没有 `lib/` 和 `annotated C/` 目录。没有的就按下面的结构新建；已经有的就沿用用户原来的组织方式，比如若原有用户文件直接放在 `lib/` 下，就继续直接放进去，不用再建模块子目录；若和默认描述结构一致，则也继续使用默认结构组织。Trial 里的文件仍按前面说的平铺存放。

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

文件拆分以实际职责和依赖关系为依据，不要求每个模块必须机械拥有 `State/Inv/Ops` 三个文件。系统组合文件导入各模块接口，模块文件不复制全局状态或系统协议。当全局state中模块级 state、predicate/invariant 和共享接口缺失时，补齐对应模块定义，并接入全局状态与系统不变量；已有定义直接复用。针对特定函数新增的抽象操作、program、局部 view、引理和证明辅助，统一放入该函数的 K<Function>.v，不另建函数专用的 State/Inv 文件。确属模块共享能力的增补，仍归入对应模块文件。

函数的 QCP `With/Require/Ensure` 仍写在 annotated C 中，不因 Rocq 目录分组而改变。详细路径、逻辑名和迁移检查见 [工程组织与维护指南](references/project-maintenance-guide.md#全局-lib-目录结构)。

### 实现完成后自动合并库

在完整验证流程中，只有用户已确认 `review-passed` 的 predicate/spec revisions，且 QCP verification-orchestrator 已对它们完成 implement、controller 返回 `done`（含 `final-check`）后，main agent 才必须主动将本次修改及新增的库文件按已记录的目标路径合并到全局 `lib/<module>/` 或 `lib/common/`，包括模块文件和函数专用文件，不要求已被多个 trial 使用。无需另行请求共享库更新确认。仅审阅通过、implement 未到 `done` 或用户仅要求只读 review 时都不得合并。

按复制时的基线、trial 修改版及全局最新版本合并已有文件，保留其他工作；必要的新增依赖一并纳入全局库，全局库不得依赖 trial 文件或专属路径。按 [工程组织与维护指南](references/project-maintenance-guide.md#共享库的增量维护)更新 imports、索引、全局组合和相关配置，将当前 trial 对已合并定义的引用切回全局库。审阅留存副本不再参与构建。

使用根项目配置重新编译新增、修改的库文件及受影响的依赖者，并检查当前 trial 的引用与类型一致性；不得用 trial 的旧编译产物充当检查结果。检查通过后才报告合并完成。纯路径迁移且不改变已实现证明的语义时记录迁移对应关系即可；若合并冲突迫使定义含义或接口发生变化，不得直接写入全局库：先在 trial 中说明原因和影响，更新受影响的构造、操作、规格与证明，重新审阅并经用户确认后，再次 implement 到 `done`，然后合并。


### 定义注释与文件顺序

在重要定义旁用 `(** ... *)` 中文注释说明：它表示什么、与 C 对象或字段有什么关系，以及必要的使用限制。组合 predicate 说明各部分的作用和整体资源归属即可，不重复下层细节。注释随定义更新，让读者只看 `.v` 就能理解设计。具体示例见 [Predicate 指南第 9 节](references/predicate-lemma-design-guide.md#9-正式定义注释与-predicate-设计报告)。

文件中先放定义，再放引理和证明。

### 设计记录与审阅准备

Predicate 设计记录按 [验证记录指南](references/reporting-guide.md)编写。


### 阅读材料与产物

- 必须读：已确认的验证上下文、目标 C/headers/config、根共享 `lib/` 与当前 trial `lib/` 中已有定义、[predicate-lemma-design-guide.md](references/predicate-lemma-design-guide.md) 和 [Predicate 设计经验](references/predicate-experience.md)。开始新写或修改 predicate 前读取经验文件，并只采用其中与当前 C 形态和控制流相符的条目。
- 写：项目实际使用的 Rocq `.v`，把局部解释放在相关 definition/statement 前；同时按 [验证记录指南](references/reporting-guide.md) 创建或维护简单易懂的 predicate 设计记录，记录当前跨定义设计、formal revision、review/error 链接和结论，不复制 formal source 或累积完整故障史。
- 修改已批准接口时，按 [验证记录指南](references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `write-spec`

### 验证范围

进入本模式前必须完整阅读 [spec-writing-guide.md](references/spec-writing-guide.md)。默认使用**扁平的
一函数一文件切片**。先按当前配置和 [源代码处理](references/源代码处理.md) 完成源码适配，
再从目标函数沿适配后切片中的直接调用、已解析的 function pointer/done-table dispatch 和宏展开后的调用
确定验证闭包。以文档规定的模型或 API contract 为边界，不再递归其原始内部调用。
从根 `annotated_C/` 或其他证明工程导入复用的依赖 spec 按下节作为 `reused-spec` 边界，不递归其内部调用安排实现证明。
其余调用递归至函数叶子或用户批准的 `trusted` 函数。Main agent 可以建议将复杂函数排除出
验证闭包，但不得代替用户决定。无法唯一解析的调用须说明调用位置和无法确定目标的原因，解决前阻塞 review。

### 已有 spec 复用与文件组织

以下是新建/空目录的默认组织；已有目录名称与布局优先。全文全局 `annotated_C/` 和 `src/...` 按扫描结果映射，平铺时直接使用该目录下的 canonical 文件。

全局 annotated C 只维护 `annotated_C/src/` 中的 canonical 输入：通用 kernel helper 放在 `src/kernel/common/`，模块函数放在 `src/kernel/<module>/`，架构和临界区外实现保留各自子目录。不新建全局 `scenarios/`；场景特化写成 canonical 文件中的具名 spec。`gen/` 和 `dep/` 只是可重生成的临时产物，不作为全局维护或合并目标。Trial 的实现验证闭包仍平铺在 `trial/annotated_C/src/`，每个本地文件记录全局来源或 implement 完成后的目标 `src/` 路径。

写 spec 时先查 当前工程解析后的 annotated C 目录，已有 spec 应导入 trial 并完成保持原语义的适配。复用、修改、场景特化及实现完成后合并统一按 [工程组织与维护指南](references/project-maintenance-guide.md#annotated-c-的增量维护)执行。

从该目录或其他证明工程导入复用已有 spec 的依赖函数，本轮不生成其实现的 VC，也不重新证明函数体；记录为 `reused-spec` 边界并检查适用性及接口一致性。具体范围与新增、修改规格的处理见 [已有 spec 的复用与特化](references/project-maintenance-guide.md#已有-spec-的复用与特化)。

- 导入的 spec 直接以函数声明及完整 `With/Require/Ensure` 写在使用它的 `f.c` 中、`f` 的定义前，并标明来源和 revision；不为导入的 `g` 新建 `annotated_C/src/g.c`，也不复制其函数体。多个 caller 使用时分别放置所需 spec，并核对它们与同一来源版本一致。
- 只有本轮新写 spec、需要实现验证的函数才新建独立函数文件；已有本轮目标文件就在原文件中修改。对导入 spec 的等价适配不算新写，不触发建文件。

- 闭包中保留实现验证的每个非 `trusted` 函数 `f` 必须且只能有一个 `annotated_C/src/f.c`，其中包含 `f` 的一个真实
  active 定义、完整函数体和 canonical `With/Require/Ensure`；declaration-only 文件不合格。
- `f.c` 中调用 `g` 时，只在 `f` 的定义前写 `g` 的完整 declaration-only API spec，不复制
  `g` 的函数体。`g` 必须在闭包中有自己的 active canonical 文件、属于上述源码适配的模型/API 或 `reused-spec` 边界，或由用户批准为 `trusted`；
  前者的 caller-local contract 必须与 canonical 文件中所选的同名 spec alpha/typedef 等价，包含新增的具名特化 spec；不得只在 caller 中另写一份不受 canonical 管理的规格。

### 函数约定与表达

- 调用另一个函数时，不能只写它的 C 声明，还要提供完整的 `With/Require/Ensure`，说明调用需要什么条件和资源、结束后得到什么结果。调用处应给出所需的逻辑参数。
- 上层函数用模块或对象的 predicate 描述行为，例如“创建一个信号量并加入管理集合”，不必重复展开每个字段和链表指针。具体内存细节放在 predicate 定义或底层操作中；调用条件、各条路径的结果和资源变化仍要看得清楚，不能全部藏在含义不明的 `xxx_pre`、`xxx_post` 中。具体写法参考 [Spec 编写指南](references/spec-writing-guide.md)。

### 宏展开与源码切片

处理源码到验证切片的转换时，按照 [源代码处理](references/源代码处理.md) 执行，并结合当前配置与 TrustBase 核对适用条件。
其中明确规定的适配优先于下述一般宏展开与源码等价要求。

- Function-like 宏先按《源代码处理》选择适用的处理方式。没有规定抽象替换的宏按当前配置展开，
  展开后保留的调用继续加入闭包；空宏、常量和纯类型/布局宏不产生函数。
  允许使用文档规定的宏替代函数及其 spec；其余可执行语句在 caller 中等价归一，不自行发明替代 API。
- 不得集中建立模块级 `*_specs.h`。
- 不按目录复制整套 kernel/libc source tree 或无关 headers；已进入闭包的 kernel/libc
  函数仍按一函数一文件切片。切片只保留当前函数真正需要的声明；若正文按字段访问 struct，声明必须保持被访问字段的真实 ABI offset，
  否则把该字段操作整体抽成具名 API，不得发明错误的精简布局。
- 除《源代码处理》明确规定且适用的适配外，从权威 C 提取单函数切片时，不改算法、路径、返回值或副作用。parser 所需的等价
  拆句、宏展开、dispatch 解析和 static-to-slice-external 归一必须逐项记录并审阅；没有用户
  批准或源码/配置依据时不得做语义替换。

### 闭包检查与审阅准备

结束 `write-spec` 前必须从适配后的目标函数重新扫描完整可达闭包。目标函数及每个递归可达 symbol 都必须
恰好满足一项：属于《源代码处理》规定且适用的模型/API 边界，并记录规则及 contract；
属于 `reused-spec` 边界，并记录原 spec 来源、revision 及一致的导入 contract；
由用户批准为 `trusted` 并记录 contract；或者具有唯一同名文件、active body、canonical spec 和一致的 caller-local contracts。
模型/API 与 `reused-spec` 边界的 caller-local contracts 同样须与所采用接口一致；已按规则删除、替换或由复用 spec 覆盖的内部调用不作为实现闭包缺失。
任何缺失、裸 call、未解析 dispatch/宏调用或多重归类都是 blocker。此模式只设计和审阅 spec，
不启动 QCP verification-orchestrator。Predicate `review-passed`
前不得进入 spec review 或请求用户批准。

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

- 草案迭代：完成一批 annotated C、predicate 或 callee-contract 修改后，确定改动文件及其 transitive callers，重新检查受影响的源码路径、验证范围、callee contract 和 ownership；只编译发生变化的 Rocq 文件。草案修改不标记 `invalidated` 也不做中间 review，不得通过加强无依据 Require、弱化 Ensure 或声明 deferred 来取得通过。
- 完整闭包：候选首次满足其他 review-ready 条件后，从目标函数重新扫描完整可达闭包并固定 revision，交由 `review` 审阅。
- Closure、symbolic、VC 和 Rocq proof 统一留给用户批准后的 QCP verification-orchestrator；本 skill 不另行维护工具执行顺序。纯文档或报告修改不产生新的设计 revision。
- Spec review 遵循 [验证记录指南](references/reporting-guide.md)，不要求套用统一模板。
- 修改已批准 predicate/spec 时，按 [验证记录指南](references/reporting-guide.md)写简短设计变更记录；只有变更由真实源码缺陷触发时才链接源码错误报告。

## `implement`

只有用户明确确认 review-passed predicate/spec revisions 后才能进入。Main agent 读取
已配置 QCP 根目录中的 `AGENTS.md`，按[路径配置](references/project-maintenance-guide.md#implement-阶段的-qcp-路径配置)将验证工作目录指向当前 trial，按[QCP工具适配](references/implementation-and-validation-guide.md#qcp工具适配)要求由 QCP 工具适配本 OS 的 trial 格式，从其中指定的 `verification-orchestrator` 启动 QCP workflow，
把已批准 predicate/spec 作为冻结输入，然后只执行 controller 返回的 action，直到 `done` 或明确 blocker。

开始目标证明前，按[工具就绪条件](references/implementation-and-validation-guide.md#证明前的工具就绪条件)确认环境已配置可用；同一环境复用已有成功结果，之后按 QCP workflow 推进。环境错误先修复。

交接时提供 TrustBase 文件路径，并明确本轮实现证明目标与 `reused-spec` 清单；导入复用函数不提交为 VC/函数体证明目标。trusted 和 reused-spec contract 均不作为本轮新完成的实现证明计数。

交接给 QCP workflow 时必须明确 VC 文件修改边界：手工完成 VC 证明只修改 `*_proof_manual.v`；不得手工修改 `*_proof_auto.v`、`*_goal.v` 或 `*_goal_check.v`。

Annotation、spec、predicate、VC 和 proof 的诊断、修正与重试全部由该 workflow 按自己的规则处理；
main agent 不再定义第二套步骤或返回状态。具体调用边界见
[implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。

## `review`

审阅是对照当前配置下的项目 C 源码，检查 predicate/spec 是否准确描述了验证对象和行为。默认只读，只检查用户指定的文件和版本；除非用户同时要求修改，不实施修复或代替用户批准。Predicate 和 spec 分别给出结论；设计审阅通过不表示 C 实现已经得到证明。

审阅时读取对应正式文件、源码证据、修改差异和检查结果，以及该模式的指南。Predicate 审阅同时查看带注释的 `.v` 和设计记录。

### 审阅内容与通过条件

- **Predicate**：检查是否准确描述源码中的对象、内存归属及生命周期，是否存在资源遗漏、重复归属或无依据假设。检查方法见 [Predicate 指南第 10 节](references/predicate-lemma-design-guide.md#10-检查并审阅-predicates)。
- **Spec**：检查验证范围是否符合目标，每条真实路径的参数、返回值、状态变化、资源转移及未修改资源是否与 C 一致；`Require` 是否足以执行且没有无依据地加强调用条件，`Ensure` 是否准确表达应保证的行为；临界区及调用者资源是否在出口正确返还；被调用函数是否被错误标成已验证。不得有无依据假设或阻塞问题。详细检查项见 [Spec 指南第 6 节](references/spec-writing-guide.md#6-spec-审阅)。

- **最终完整性检查**：确认 QCP controller 已返回 `done`，复用其 `final-check` 结果，不重复执行证明检查。同时确认切片与原始 CRTOS 源码的一致性结论仍然有效：源码、配置及切片相关内容未变时复用 Spec 审阅结论，有变化则重新核对受影响部分。QCP 的完成状态不能替代这项源码一致性确认；两者均通过后才能报告原 CRTOS 目标验证完成。

最终结论区分已证明结论和信任假设；对基于 TrustBase 的源码适配说明适用配置及结论限制，不将其表述为无条件的源码等价。TrustBase 或实际依赖发生变化时，只复查受影响结论，不把新条目自动追认为旧证明的依据。

具体检查按目标代码及设计选择适用项，不要求逐项写报告；适用的编译、类型或证明检查须通过，影响正确性的未解决问题仍阻塞审阅通过。

Spec 审阅使用明确的、已通过审阅的 predicate 版本。在完整验证流程中，两者分别 `review-passed` 后，main agent 先请用户确认两份明确 revisions；确认前不得启动 QCP verification-orchestrator。确认后执行 implement，只有 controller 返回 `done`（含 `final-check`）后，才按[实现完成后自动合并库](#实现完成后自动合并库)完成全局合并、依赖检查与版本对应记录，再进入最终完整性审阅。

### 审阅与复查

Predicate/spec 草案（`draft`）可以共同修改，不做中间审阅。满足设计阶段的准备条件后标为 `review-ready`，首次做完整审阅；需要修复时标为 `needs-fix`，满足上述通过条件后才标为 `review-passed`。

写 spec 时发现现有 predicate 无法描述某个对象或操作过程，应先补充 predicate，再继续写 spec。草案直接修改；涉及已通过审阅的 predicate 时，重新审阅受影响部分后再继续 spec 审阅。

修复后只检查已报告的问题、修改处及直接或间接受影响的内容。格式、报告或不影响设计结论的证明步骤修改不触发设计重审；同一版本和依据不重复审阅。同一阻塞问题没有新修改或证据时，停止重复检查并向用户说明。

修改使原来的通过结论不再适用时，将该结论标为 `invalidated`，重新审阅受影响的部分；不影响结论的变化无需重审。

审阅记录的写法见 [验证记录指南](references/reporting-guide.md)。

## 项目与参考路径

默认 trial 是 当前验证工程根目录 的直接子目录 `<function-name>-trial-YYMMDD-N/`，或使用用户指定的独立目录。新实验按当前日期 + 当天第几次实验命名，不沿用 IDE、终端或历史上下文残留的名称。先检查验证工程中当天已有的实验目录，自动计算下一次序号。只有验证工程中确实存在尚未运行完成的实验目录时，才继续该实验。如果发现多个未完成实验或完成状态不明确，先向我确认，不自行猜测。

每个 trial 维护自己的 `_CoqProject`；全局 `lib/` 由 CRTOS 根目录的 `_CoqProject` 统一管理，不依赖某个 trial 的配置或实验文件。各 trial 显式配置对全局库的引用，本地实验定义使用独立逻辑路径。确保构建工具、QCP 和编辑器使用一致的库路径；路径变化后同步配置并重新编译受影响的文件。配置或调整路径时参考 [工程组织与维护指南](references/project-maintenance-guide.md)。

验证以当前配置下的真实 CRTOS 源码为准。完整源码模式只修改注解；单函数切片按上述《源代码处理》规则适配，其他工具转换须保持程序行为，并在 spec review 中说明转换位置、理由及源码依据。不得超出已规定的适配范围改变算法、遗漏执行路径或副作用，也不得使用错误的数据布局。等价转换示例见 [Spec 编写指南](references/spec-writing-guide.md#单函数切片的等价转换)。

### 库与证明参考

写新定义、strategy 或断言前，先查 CRTOS 全局库及当前工程的 annotated C，再查 QCP 库；需要参考设计或证明方法时，查看已配置且可用的 crtosverify、LOSVerify 和 VRTOS；未配置的参考直接跳过。查找实际定义和用法，不猜测 QCP 语法。

外部根目录由配置的 `references` 提供；QCP 来自必填的 `qcp_root`。“位置”是查找提示，以实际扫描结果为准。

| 来源 | 位置 | 用途 |
|---|---|---|
| 当前工程全局库 | `lib/<module>/`、`lib/common/` | 复用模块定义、predicate<br>和已证明引理。 |
| 当前工程 annotated C | `annotated_C/src/kernel/<module>/`、<br>`annotated_C/src/kernel/common/` | 查找函数 spec、注解、断言<br>和 strategy 用法。 |
| 当前 trial | `<trial>/annotated_C/` | 参考当前函数及依赖函数的<br>切片、spec 和局部断言。 |
| QCP 基础库 | QCP 仓库的 `Rocq/SeparationLogic/`、`Rocq/MonadLib/`、<br>`Rocq/StrategyLib/`、`Rocq/auxlibs/` 等 | 复用分离逻辑、抽象 program、<br>strategy、tactic 及通用引理。 |
| QCP 示例 | QCP 仓库的 `Rocq/examples/`、`QCP_examples/` 及项目教程 | 参考注解、assertion、<br>`which implies` 和证明写法。 |
| `references.crtos_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/` | 参考 CRTOS 模块定义、predicate、<br>spec 和 VC 证明。 |
| `references.los_verify`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 OS 模块、spec 和证明，<br>如 `lib/sem.v`、`lib/task.v`。 |
| `references.vrtos`（可选） | `lib/`、`annotated_C/`<br>`VC/code_proof/` | 参考 CRTOS 对象表示、spec 和证明。 |

已有 spec 的复用与修改按上述“已有 spec 复用与文件组织”执行。当前 trial 的内容须结合对应 revision 与审阅记录确认状态；历史 trial 不作为新任务的默认位置。

上述“复用”指使用适合当前目标的可使用实际定义或已证明结论；作为证明依据时确认其证明状态、依赖假设和当前工程兼容性。“参考”允许借鉴设计和证明方法，不表示整个目录已经可信，也不替代用户对具体 `trusted` C symbol 的批准。

涉及跨模块调用时必须复用共享 `lib/` 中的已有定义，不得重复增加已有概念。若现有接口缺少所需内容，把所属模块文件复制到平铺的 `trial/lib/`，在副本中增补定义并记录其全局来源与目标路径；若已有定义不符合当前 C 或本 skill 的要求，应说明修改依据和影响，并检查受影响的使用处。按上述实现完成后自动合并流程写回全局库。

