---
name: verify-an-os-function
description: 验证 CRTOS 等非 SMP OS 的 C 函数与模块：设计并审阅 Rocq predicate 与 QCP spec，用户确认 revision 后交给 QCP verification-orchestrator 完成实现证明。
---

# 验证 CRTOS 函数

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

验证记录保存在 trial 的 `.docs/Report/` 中。按实际需要组织，可合并相关内容，不要求每类单独成文。报告类型与写法见 [验证记录指南](references/reporting-guide.md)。

## 总流程

Main agent 负责确定模式、安排顺序、守住审批门并汇总结果。作者与 reviewer 应分开；predicate review 和 spec review 分别明确对象、条件和结论，可写在同一份记录中。Review 次数不预设，由产物 revision、修改影响和通过条件决定。没有独立检查能力时，由 main agent 按相同条件自检并注明。

```text
确认验证上下文 -> C 分析 -> predicate 与 spec 草案迭代
             -> predicate review-passed -> spec review-passed
             -> 用户确认两份 revision
             -> QCP verification-orchestrator implement（含 final-check）
             -> 最终完整性审阅与结果汇总
```

## 通用验证约束

设计阶段可以先写引理陈述，不要求立即完成证明；未证明的内容必须明确为待证义务，不能当作已证明结论使用。不得用 `Parameter`、`Axiom`、占位定义或手写 `Admitted/admit` 绕过证明。

## 确认验证上下文

优先读取用户指定或项目已有的说明。

CRTOS 任务开始时完整读取用户维护的 [TrustBase.md](/home/xinra/TrustBase.md)，作为项目的信任边界依据。该文件仅由人工编辑，agent 不修改它。

区分其中的工具适配假设、一致性检查要求和 trusted specs：适配条目须核对当前任务的实际转换与适用条件，一致性要求仍须执行，trusted specs 按已列明的范围使用。文件中已明确授权且适用于当前任务的条目无需重复请求批准；宽泛类别不自动批准任意 symbol 或 contract。未覆盖的新信任假设或范围扩展需单独说明并取得用户批准，不能通过修改 TrustBase 或引入占位证明消除待证义务。

`trusted` 函数由用户决定。Main agent 可以建议把复杂 callee 作为 `trusted`，但只有用户明确同意
具体 C symbol 后才能停止递归；批准的 symbol 和采用的 contract/保证记录在对应的 predicate 设计报告或 spec review 记录中。

## `slice-design`

### C 源码分析

Main agent 将源码分析交给 C analysis agent，按 [Predicate 指南第 1 节](references/predicate-lemma-design-guide.md#1-确认源码与范围)执行，分析结果用于后续 predicate 设计。

### Predicate 设计

Predicate design agent 使用 C analysis agent 的分析结果，按照 [Predicate 与 lemma 设计指南](references/predicate-lemma-design-guide.md)进行设计。开始新写或修改 predicate 前，先阅读该指南和 [Predicate 设计经验](references/predicate-experience.md)，经验条目只采用与当前 C 形态和控制流相符的内容。

Predicate design agent 从目标模块全部函数实际访问的 C 对象出发，确定模块的 abstract state、
owned memory、mutable fields、lifecycle states 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

### 已有定义复用

开始设计前先读取 CRTOS 全局库 `/home/xinra/crtos/lib`。已有定义直接导入复用，不重复定义。QCP 库及 LOSVerify、VRTOS 的证明参考位置见 [库与证明参考](#库与证明参考)。

新增定义放入职责对应的模块文件，使用处通过 `Require Import` 引用；需要向下游公开的接口使用 `Require Export`。已有模块增加元素或操作时，在该模块中增量补充；新增模块时，由全局状态或系统不变量导入并增加必要的组合项，不复制整套共享定义。

共享定义可以直接在 `/home/xinra/crtos/lib/` 对应文件中增补或修改，无需先复制到 trial。当前实验专用、尚在探索的定义可放在 trial 的 `lib/`；这些文件通过审阅及编译或类型检查后，也可以复制到共享库并重新编译，不要求被多个模块或 trial 使用。修改已有文件时检查修改处及受影响内容，新建文件时检查完整文件。

### 文件组织与存放

Trial 中用于实验的 Rocq 库源文件，无论是本次新增的定义，还是从共享库复制并在本次使用或修改的文件，都统一放在 `trial/lib/`。模块职责通过文件划分，依赖通过 imports 和构建配置管理。

参考 LiteOS 验证工程 `/home/xinra/LOS_Verify/lib/` 的职责分层：
`glob_vars_and_defs.v` 保存稳定全局变量及公共基础定义，`Los_Verify_State_def.v`
定义抽象状态，`sem.v`、`task.v` 等提供模块内存表示，`Los_Verify_inv.v`
导入各模块并组合系统不变量。参考其职责与依赖关系，不机械复制文件名或全部布局；
其中的内容不因此自动成为已验证或可直接复用的结论。

CRTOS 按全局、模块、函数三个层次说明文件职责：

- **全局状态**：例如 `CrtosGlobState.v`，导入各模块状态并组合成 `StableGlobalState`、`VarGlobalState`，保留确实作用于整个 OS 状态的操作和上下文关系。
- **系统协议**：保留独立的 `CrtosRules.v`，基于全局状态定义统一的 critical/IRQ 状态机、断言模型及进入和退出临界区等协议接口，供各模块共同使用；不在各模块中重复实例化协议。
- **系统不变量**：例如 `CrtosInv.v`，导入模块内存表示，组合系统内存不变量并表达跨模块关联，具体模块的 store 谓词由模块文件提供。
- **模块定义**：各模块分别维护自己的抽象类型、状态、稳定地址或配置，以及局部操作。例如信号量的 `SemaphoreAbs`、`SemaphoreState`、`SemaphoreStable` 归信号量模块，不集中堆入全局状态文件。
- **模块内存表示**：例如 `semaphore.v`，使用该模块的抽象定义，提供其对应 C 内存的 store 谓词、局部不变量及相关引理，供模块各函数和系统不变量复用。模块定义和内存表示属于同一模块，可按依赖需要合并或分文件。
- **函数文件**：验证具体函数时，可以按函数单独建立 `.v` 文件，例如 `KSemaphoreCreate.v`，放该函数的 `abs_*` 操作、`program`、操作组合及专用辅助定义等函数特有内容，引用模块和系统共享定义，不复制公共内容。函数的 QCP `With/Require/Ensure` 仍写在 annotated C 中。

文件拆分以实际依赖关系为依据。例如模块内存谓词依赖全局协议，而全局协议依赖
OS 总状态时，将模块纯状态放在不依赖全局协议的 `semaphore_def.v` 等下层文件中，
供全局状态和模块内存表示共同import。上述名称仅作示例；是否单设
`glob_vars_and_defs.v` 取决于稳定全局上下文或公共基础定义是否需要独立的依赖层。

文件按上述职责放入共享库或当前 trial。Trial 中的模块文件和函数专用文件均可在文件及必要依赖通过对应审阅后复制到共享 `lib/`；更新使用处的 imports 和必要的全局组合，并使用根项目配置重新编译复制的文件及受影响的依赖者。Trial 中保留此次通过审阅的版本，但避免它与共享版本在构建路径中相互遮蔽。

当前任务范围内的共享库修改，以及通过审阅后的 trial 文件复制与重新编译，无需另设一次共享库更新确认。若改变已有定义的含义或接口，应说明原因和影响，更新受影响的构造、操作、规格与证明，并按审阅规则复查相关结论。不得覆盖其他人的修改；依赖、索引和路径配置按 [工程配置指南](references/project-configuration-guide.md#共享库的增量维护)处理。进入实现证明前的 predicate/spec revision 确认要求仍按总流程执行。


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
一函数一文件切片**。验证闭包从用户指定的目标函数开始，在当前配置下递归跟随
全部直接调用、可唯一解析的 function pointer/done-table dispatch，以及 function-like 宏展开后产生的
真实函数调用，直到函数叶子或用户批准的 `trusted` 函数。Main agent 可以建议将复杂函数排除出
验证闭包，但不得代替用户决定。无法唯一解析的调用须说明调用位置和无法确定目标的原因，解决前阻塞 review。

### 参考与文件组织

写 spec 时可先参考 `/home/xinra/crtos/annotated_C/` 中已有的 annotated C；它们只作为参考，
当前目标仍须按权威源码、配置和本流程在 trial 中建立并审阅自己的 canonical spec。

- 闭包中每个非 `trusted` 函数 `f` 必须且只能有一个 `annotated_C/src/f.c`，其中包含 `f` 的一个真实
  active 定义、完整函数体和 canonical `With/Require/Ensure`；declaration-only 文件不合格。
- `f.c` 中调用 `g` 时，只在 `f` 的定义前写 `g` 的完整 declaration-only API spec，不复制
  `g` 的函数体。`g` 必须在闭包中有自己的 active canonical 文件，或由用户批准为 `trusted`；
  前者的 caller-local contract 必须与 canonical spec alpha/typedef 等价。

### 函数约定与表达

- 调用另一个函数时，不能只写它的 C 声明，还要提供完整的 `With/Require/Ensure`，说明调用需要什么条件和资源、结束后得到什么结果。调用处应给出所需的逻辑参数。
- 上层函数用模块或对象的 predicate 描述行为，例如“创建一个信号量并加入管理集合”，不必重复展开每个字段和链表指针。具体内存细节放在 predicate 定义或底层操作中；调用条件、各条路径的结果和资源变化仍要看得清楚，不能全部藏在含义不明的 `xxx_pre`、`xxx_post` 中。具体写法参考 [Spec 编写指南](references/spec-writing-guide.md)。

### 宏展开与源码切片

- Function-like 宏先按当前配置展开：展开产生的真实函数调用继续加入闭包；空宏、常量和纯
  类型/布局宏不产生函数；展开产生的可执行语句在 caller 切片中作有源码依据的等价归一，
  不为源码中不存在的宏虚构 canonical 函数。
- 不得集中建立模块级 `*_specs.h`。
- 不按目录复制整套 kernel/libc source tree 或无关 headers；已进入闭包的 kernel/libc
  函数仍按一函数一文件切片。切片只保留当前函数真正需要的声明；若正文按字段访问 struct，声明必须保持被访问字段的真实 ABI offset，
  否则把该字段操作整体抽成具名 API，不得发明错误的精简布局。
- 从权威 C 提取单函数切片时，不改算法、路径、返回值或副作用。parser 所需的等价
  拆句、宏展开、dispatch 解析和 static-to-slice-external 归一必须逐项记录并审阅；没有用户
  批准或源码/配置依据时不得做语义替换。

### 闭包检查与审阅准备

结束 `write-spec` 前必须从目标函数重新扫描完整可达闭包。目标函数及每个递归可达 symbol 都必须
恰好满足一项：由用户批准为 `trusted` 并记录 contract；或者具有唯一同名文件、active body、
canonical spec 和一致的 caller-local contracts。
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

只有用户明确确认 review-passed predicate/spec revisions 后才能进入。Main agent 在这里读取
`/home/xinra/qcp-binary-democases/AGENTS.md`，从其中指定的 `verification-orchestrator` 启动 QCP workflow，
把已批准 predicate/spec 作为冻结输入，然后只执行 controller 返回的 action，直到 `done` 或明确 blocker。

交接时提供 TrustBase 文件路径；trusted contract 不作为已完成的实现证明计数。

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

Spec 审阅使用明确的、已通过审阅的 predicate 版本。两者分别 `review-passed` 后，请用户确认两份明确版本；确认前不得启动 QCP verification-orchestrator。

### 审阅与复查

Predicate/spec 草案（`draft`）可以共同修改，不做中间审阅。满足设计阶段的准备条件后标为 `review-ready`，首次做完整审阅；需要修复时标为 `needs-fix`，满足上述通过条件后才标为 `review-passed`。

写 spec 时发现现有 predicate 无法描述某个对象或操作过程，应先补充 predicate，再继续写 spec。草案直接修改；涉及已通过审阅的 predicate 时，重新审阅受影响部分后再继续 spec 审阅。

修复后只检查已报告的问题、修改处及直接或间接受影响的内容。格式、报告或不影响设计结论的证明步骤修改不触发设计重审；同一版本和依据不重复审阅。同一阻塞问题没有新修改或证据时，停止重复检查并向用户说明。

修改使原来的通过结论不再适用时，将该结论标为 `invalidated`，重新审阅受影响的部分；不影响结论的变化无需重审。

审阅记录的写法见 [验证记录指南](references/reporting-guide.md)。

## 项目与参考路径

默认 trial 是 CRTOS 根 `/home/xinra/crtos/` 的直接子目录 `<function-name>-trial-YYMMDD-N/`，或使用用户指定的独立目录。新实验按当前日期 + 当天第几次实验命名，不沿用 IDE、终端或历史上下文残留的名称。先检查 crtos 中当天已有的实验目录，自动计算下一次序号。只有 crtos 中确实存在尚未运行完成的实验目录时，才继续该实验。如果发现多个未完成实验或完成状态不明确，先向我确认，不自行猜测。

每个 trial 维护自己的 `_CoqProject`；全局 `lib/` 由 CRTOS 根目录的 `_CoqProject` 统一管理，不依赖某个 trial 的配置或实验文件。各 trial 显式配置对全局库的引用，本地实验定义使用独立逻辑路径。确保构建工具、QCP 和编辑器使用一致的库路径；路径变化后同步配置并重新编译受影响的文件。配置或调整路径时参考 [工程配置指南](references/project-configuration-guide.md)。

验证以当前配置下的真实 CRTOS 源码为准。完整源码模式只修改注解；单函数切片允许为工具适配进行不改变程序行为的转换，并在 spec review 中说明转换位置、理由及源码依据。不得改变算法、遗漏执行路径或副作用，也不得使用错误的数据布局。转换示例见 [Spec 编写指南](references/spec-writing-guide.md#单函数切片的等价转换)。

### 库与证明参考

写新定义、strategy 或断言前，先查 CRTOS 全局库，再查 QCP 库；需要参考设计或证明方法时，查看 LOSVerify 和 VRTOS。用 `rg` 查找实际定义和用法，不猜测 QCP 语法。

| 来源 | 位置 | 用途 |
|---|---|---|
| CRTOS 全局库 | `/home/xinra/crtos/lib/`| 优先复用已有模块定义、predicate 和适用的已证明引理。 |
| QCP 基础库 | `/home/xinra/qcp-binary-democases/SeparationLogic/`，包括 `SeparationLogic/`、`MonadLib/`、`StrategyLib/`、`auxlibs/` 等 | 复用QCP已有库分离逻辑、抽象 program、strategy、tactic 及通用引理。 |
| QCP 示例 | `/home/xinra/qcp-binary-democases/SeparationLogic/examples/` 及 QCP 项目中的教程、示例 | 参考注解、assertion、`which implies` 和证明写法。 |
| LOSVerify | `/home/xinra/LOS_Verify/lib/`、`annotated_C/`、`VC/code_proof/` | 参考 OS 模块定义、函数 spec 和证明，例如 `lib/sem.v`、`lib/task.v`。 |
| VRTOS | `/home/xinra/vrtos/lib/`、`annotated_C/`、`VC/code_proof/` | 参考 CRTOS 对象表示、函数 spec 和证明。 |

表中“复用”指使用适合当前目标的可使用实际定义或已证明结论；作为证明依据时确认其证明状态、依赖假设和当前工程兼容性。“参考”允许借鉴设计和证明方法，不表示整个目录已经可信，也不替代用户对具体 `trusted` C symbol 的批准。

涉及跨模块调用时必须导入共享 `lib/` 中的已有定义，不得重复增加已有概念。若现有接口缺少所需内容，直接在所属共享模块增补定义，并更新必要的导入与全局组合；若已有定义不符合当前 C 或本 skill 的要求，应说明定义位置、修改依据和影响，修改对应文件并检查受影响的使用处。

