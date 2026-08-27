---
name: verify-an-os-function
description: 验证 CRTOS 等非 SMP OS 的 C 函数与模块：以整个模块为范围设计 Rocq predicate，与按函数编写的 QCP spec 在草案期共同完成 QCP-MCP symbolic 检查，稳定后分别审阅；用户批准前不导出 proof，批准后再生成 VC、完成 Rocq 证明和完整性检查。
---

# 验证 CRTOS 函数

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

## 模式与总流程

Main agent 负责确定模式、安排顺序、守住审批门并汇总结果。作者与 reviewer 应分开；predicate review 和 spec review 的对象、条件和记录也必须分开。Review 次数不预设，由产物 revision、修改影响和通过条件决定。没有独立检查能力时，由 main agent 按相同条件自检并注明。

```text
确认验证上下文 -> C 分析 -> predicate 与 spec 草案迭代
             -> QCP-MCP symbolic(last_line) 全部成功，不调用 qcp.proof
             -> predicate review-passed -> spec review-passed
             -> 用户确认两份 revision
             -> QCP 生成 VC / Rocq proof -> final integrity check
```

### 确认验证上下文

开始 predicate 设计前，确认目标模块边界、当前配置下属于该模块的源码和函数集合、
模块直接访问或拥有的 C 对象、初始化与生命周期路径，以及相关 critical/IRQ/atomicity 行为。

优先读取用户指定或项目已有的说明。只在任务回复或最终报告中简短记录本次使用的事实和 `[OPEN]`。

上述上下文变化并影响已审阅 predicate/spec 时，按 dependency closure 将相应结论标记为 `invalidated`；与当前目标无关的
项目事实变化不触发重审。

### Review 生命周期

状态使用 `draft -> review-ready -> needs-fix|review-passed -> invalidated`。草案可根据 QCP-MCP symbolic 共同修改，不做中间 review；`invalidated` 只用于已经通过的 revision 失去审阅依据。

- 首个 review-ready revision 做一次 full review。`needs-fix` 后只检查已报告 issue、修改处及其 dependency closure；只有权威 C、配置、scope、可信边界或上游 breaking change 使审阅依据失效时才重新 full review。
- 纯格式、报告或不影响结论的 proof-local 修改不触发 review；同一 revision 不重复 review。同一 blocker 没有新修改或证据时停止空转并报告用户。
- Issue 必须给出级别、file/symbol 证据、mismatch、后果、最小修复和可执行通过条件。无 open blocker 且检查成功才可 `review-passed`。
- Final integrity 首次检查完整 proof 候选；之后只重跑失败项和 dependency closure，除非权威输入、approved revision 或 goals 改变。

### `slice-design`

C analysis agent 读取当前配置下目标模块的全部实现函数，以及模块相关类型、全局对象、
初始化/销毁路径和条件编译。对模块中的函数分别记录控制流、返回路径、memory reads/writes、
访问的指针与字段、calls、side effects、loop invariant 和必要假设。

为了理解模块资源的跨模块使用，还应读取必要的外部调用者或被调用者；这些上下文函数
不因此归入目标模块，也不要求目标模块 predicate 拥有其他模块的内部资源。

Predicate design agent 从目标模块全部函数实际访问的 C 对象出发，确定模块的 abstract state、
owned memory、mutable fields、lifecycle states 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

AI 新建的共享 Rocq definitions 写入项目 `lib/`。创建或命名 `.v` 文件、
Module 和 symbol 前，可以参考当前项目、LOS Verify 及最接近的 QCP 示例，
沿用其已有命名和目录组织；skill 不规定统一前缀、后缀或固定拆分方式。
语义和 ownership 仍以目标 CRTOS 源码为准，LOS/QCP 只作为命名与组织参考。

直接在 `.v` 中用 `(** ... *)` 中文文档注释解释生成的非平凡定义：用自然语言说明这个定义做什么，以及理解或使用它时真正需要知道的限制、保持关系或中间状态。不要规定固定栏目，也不要为了填注释机械罗列 ownership、参数、抽象边界和客户端；简单定义一句话即可。注释必须随 definition 一起更新，过时或误导性注释视为 blocker。Rocq 文件先放 definition，再放 lemma/theorem/proof；不得用 `Parameter`、`Axiom`、占位定义、手写 `Admitted/admit` 绕过证明。

Predicate review-ready 条件：目标模块、当前配置、模块源码和函数集合已经固定；
当前配置下模块全部函数实际访问的每个 C 对象和内存都能追溯到候选
owner/representation；模块的初始化、正常运行、状态转换、删除和回收路径已经覆盖；
正式 state/predicate/lemma statement 已写入 .v，必要中文注释与代码一致，并通过
适用的 compile/typecheck；当前任务同时编写 spec 时，验证闭包已使用该 predicate 草案完成全部 QCP-MCP symbolic 检查且未调用 `qcp.proof`；没有会影响 owner、抽象语义、lifecycle、frame 或 formal check 的已知 [OPEN]。

Predicate review-passed 条件：在当前配置下，对目标模块全部函数可能访问的每个字节，
在对应的稳定生命周期状态下都有且仅有一个 owner；模块 abstract state 和每个命名
predicate 都有源码语义或复用客户端依据；模块内部 container/lifecycle/critical 边界
闭合；跨模块资源的 owner 与借用/转移接口明确；formal checks 通过且没有 open blocker。

需要参考完整的 CRTOS 项目实例时，可先阅读
[Task lib 索引](references/task-lib/index.md) 作为参考。

- 必须读：已确认的验证上下文、目标 C/headers/config、当前 trial 工作区已有的 `lib/` 定义、[predicate-lemma-design-guide.md](references/predicate-lemma-design-guide.md) 和 [predicate 设计经验](references/experience.md)。开始新写或修改 predicate 前读取经验文件，并只采用其中与当前 C 形态和控制流相符的条目。
- 写：项目实际使用的 Rocq `.v`，把解释放在相关 definition/statement 前；默认不创建 predicate review template。Review issue、reviewed revision 和结论只写入任务回复或最终报告，不复制 formal source。
- 修改已批准接口时使用：[design-change-request-template.md](assets/design-change-request-template.md)。

### `write-spec`

默认使用**扁平的一函数一文件切片**：用户指定的目标函数及本轮明确纳入设计的
direct callees，各自在 `annotated_C/src/<function>.c` 中恰有一个 active 函数定义。
文件按以下顺序组织：当前函数需要的最小类型/常量；当前函数实际调用的每个
callee 的 declaration-only `With/Require/Ensure` API；当前函数自己的 canonical
`With/Require/Ensure`；真实 active 函数体。更深层 helper 默认只作为本文件前部
API，不递归复制函数体或扩成整棵源码树，除非用户明确扩大验证函数集合。

这是结构硬门禁：

- API 不能只是裸 C prototype 或 `implementation-pending` 注释；每个正文 call 都
  必须在定义前有完整 `With/Require/Ensure`，并在调用点实例化需要的 `With`。
- 正文调用的 function-like macro 必须在切片中变成具名函数 API，并在定义前写
  完整 spec；object-like 常量、`sizeof` 和纯类型/布局宏可以保留。不得只写
  `#define LOCK() Helper()` 后给 `Helper` 一个裸声明。
- 当前函数体必须 active；不得放入 `#if 0`、注释、字符串或“body snapshot”，
  也不得用 declaration-only 文件冒充 canonical 函数文件。
- Caller 不复制 callee 函数体；callee API 必须与被纳入本轮函数集合时其自身文件
  中的 canonical spec alpha/typedef 等价。不得集中建立模块级 `*_specs.h`。
- 不复制整套 kernel/libc source tree 或无关 headers。切片只保留当前函数真正需要
  的声明；若正文按字段访问 struct，声明必须保持被访问字段的真实 ABI offset，
  否则把该字段操作整体抽成具名 API，不得发明错误的精简布局。
- 从权威 C 提取单函数切片时，不改算法、路径、返回值或副作用。parser 所需的等价
  拆句、macro-to-API 和 static-to-slice-external 归一必须逐项记录并审阅；没有用户
  批准或源码/配置依据时不得做语义替换。

写完后反向扫描正文中的 calls/macros，任何裸 call、未拆的操作型宏、缺失 spec 或 inactive body 都是
`write-spec` blocker。可以先引用可编译的 predicate 草案编写 spec 和运行
QCP-MCP symbolic 检查，但 predicate `review-passed` 前不得进入 spec review、
请求用户批准或导出 proof。

Spec review-ready 条件：引用的 predicate revision 为 `review-passed`；目标函数全部 return/blocking path 和 direct-callee 状态已列出；正式 pre/post 与 annotated C `With/Require/Ensure` 已写出；每个 load/store 能追溯到 reviewed predicate；Rocq compile 和 annotated C parser/typecheck 已通过；验证闭包内每个 annotated C 都已经 `qcp.load_target_file(absolute_file)` 后执行 `qcp.symbolic(last_line)`，且到达文件末尾无 error。`qcp.check`/`qcp.step` 只用于诊断，不代替整文件 symbolic 成功；结束会话时调用 `qcp.close`，用户批准前不得调用 `qcp.proof`。任何 memory entailment、callee precondition、GlobalStrings、未实例化 `With`、unsupported call 或未能证明不可达的分支都属于当前 spec/predicate/annotation 的 blocker，不得延期到 `implement`。只有全部 symbolic 成功且没有影响路径、effect、ownership、frame 或依赖结论的已知 `[OPEN]`，才达到 review-ready。

Spec review-passed 条件：每条真实路径的参数、返回值、abstract effect、old/new、ownership transfer 和 frame 都匹配；Require 足以执行但没有无依据加强，Ensure 没有弱化实现义务；critical/caller resources 在出口正确返还；callee 状态没有冒充 verified；全部 QCP-MCP symbolic 检查成功；没有无依据假设，formal checks 通过且没有 open blocker。Predicate 与 spec 分别 review-passed 后，用户确认两份明确 revision；确认前不得调用 `qcp.proof`、生成 strategy soundness goal 或开始 proof。

- 必须读：已确认的验证上下文、当前 predicate 草案、目标 C 与 direct-callee specs，以及 [spec-writing-guide.md](references/spec-writing-guide.md)。Spec review 时必须固定同一份 `review-passed` predicate revision。
- 写：当前函数的 canonical spec 直接写在其唯一 active 定义上；正文中每个
  callee/操作型宏对应的完整 declaration-only API spec 写在同一文件、当前定义
  之前。不得集中建立模块级 `*_specs.h`，不得用裸prototype代替spec。
- 草案迭代：完成一批会影响 spec 执行的 annotated C、predicate 或 callee-contract 修改后，先确定改动文件及其 transitive callers，并调用一次 `bash <skill-dir>/scripts/check-spec-closure.sh <trial-dir> --affected <changed-or-caller.c> ...`，每个受影响文件各写一个 `--affected`。机械检查成功后，再按 leaf 到 caller 小批运行这些文件的 QCP-MCP symbolic；不要按每次保存或每个小修改重跑。Symbolic 失败时用 `qcp.check`/`qcp.step` 定位；暴露 predicate 缺口时返回 `slice-design` 修正草案。predicate 文件未变化且已有成功编译结果时，不做完整 Rocq rebuild。草案修改不标记 `invalidated` 也不做中间 review，不得通过加强无依据 Require、弱化 Ensure 或声明 deferred 来取得成功。
- 完整闭包：候选首次满足其他 review-ready 条件后，调用一次 `bash <skill-dir>/scripts/check-spec-closure.sh <trial-dir>`，不带 `--affected`；成功后再固定 revision 并开始 full review。`needs-fix` 后有语义修改时，修复完成后只调用 affected 模式并在重新 review 前固定新 revision；只有审阅依据失效、需要重新 full review 时才再次调用 full 模式。
- 纯文档或报告修改不调用该脚本，也不产生新的设计 revision。同一批未发生变化的输入不重复调用。脚本只汇总 Rocq compile、C syntax、CLI symbolic dry-run、trust scan、revision 和 VC 文件计数；其结果不代替 QCP-MCP 的整文件 symbolic 成功证据。
- Spec review 使用：[spec-review-template.md](assets/spec-review-template.md)。
- 修改已批准 predicate/spec 时使用：[design-change-request-template.md](assets/design-change-request-template.md)。

### `implement`

只有用户明确要求后才能进入。进入时所有 approved annotated C 必须已经在同一 revisions 上完成 QCP-MCP symbolic 检查。Verification agent 先重放同一 symbolic 检查并检查 `coqc --version`，再允许调用 `qcp.proof`、生成 VC 与 strategy soundness goals，记录生成文件、VC 数量和生成阶段失败，随后完成 Rocq proof 与完整性检查。

若 approved revision 在 implement 入口不能再次完成同一 QCP-MCP symbolic 检查，立即停止并使 spec review 失效，不把它当作 proof-local 失败。生成阶段之后的失败再分类为 VC generation、strategy soundness、logical proof 或 arithmetic。Predicate 变化按 predicate 条件重审；Require/Ensure、路径、ownership 或 abstract effect 变化按 spec 条件重审；proof-local lemma、strategy proof 或 tactic 调整且不改变已通过 symbolic 结果与审阅结论时，不触发设计 review。

不得手工修改 `*_goal_check.v`、`*_goal.v` 或 `*_proof_auto.v`；保留后者由 QCP 生成的 `Admitted`。手工目标放在 `*_proof_manual.v`，额外定义或 lemma 放在同前缀 `*_lib.v`。C 变化产生新 manual goals 时，先把旧 manual 文件移到 `.tmp/`，重新生成后迁移可复用 proof，全部证明后再删除备份。

沿调用依赖自底向上证明，先 leaf 再 caller。所有 proof 文件必须编译；不得删除、弱化或隐藏 goal，也不得在未实际运行 QCP 和 Rocq 时声称验证成功。

- 必须读：已确认的验证上下文、predicate slice、spec、annotated C、已有 strategy/proof，以及 [implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。
- 写：QCP strategy、loop annotations、`*_proof_manual.v`、同前缀 `*_lib.v` 和必要的人工证明；QCP 生成文件只能由工具写。
- Template：本模式不新建设计 template；若实现迫使已批准设计变化，使用 [design-change-request-template.md](assets/design-change-request-template.md) 并退回对应模式。

### `review`

默认只读，只检查用户指定的 artifact 和 revision；除非用户同时要求修改，不实施修复或自行批准。Predicate 和 spec 必须分别给出结论，不得用一个综合结论替代。是否继续 review 按 review 生命周期和 artifact 变化判断，不按预设次数。

设计 issue 使用以下固定字段：

```text
ID | blocker/non-blocker | evidence(file:line or symbol) | mismatch
   | concrete consequence | required fix | pass condition | status
```

最终检查至少覆盖：

- C integrity：完整源码模式确认只改注解；单函数切片模式确认每项可执行归一都在
  extraction/normalization记录中、有权威源码/config依据，并保持路径与副作用；
- VC integrity：确认生成 goal 完整、未删除、未弱化、未隐藏；
- proof/trust：确认 VC 计数、Rocq 编译和 `Parameter/Axiom/Admitted/admit` 扫描结果。

- 必须读：被审阅的正式文件、源码证据、diff/check 结果，以及该产物所属模式的 guide；proof review 读取 [implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。
- 写：predicate 直接审阅带注释的 `.v`，把 issue、reviewed revision 和结论写入任务回复或最终报告；spec 更新 [spec-review-template.md](assets/spec-review-template.md)，实现完成后更新 [final-integrity-template.md](assets/final-integrity-template.md)。已有旧 predicate manifest 无需迁移，也不再新建。

## 项目与参考路径

默认 trial 是 CRTOS 根 `/home/xinra/crtos/` 的直接子目录 `<function-name>-trial/`，或使用用户指定的独立目录。开始 C 分析前解析并报告绝对路径，补齐 `annotated_C/src/`、`lib/`、`VC/`、`.docs/Report/folded_history/`；不得覆盖现有内容，也不得把 trial 建在权威源码子树内。

创建或进入 trial 时，创建或维护该 trial 根目录自己的 `_CoqProject`。其中列出该 trial
实际使用的外部 `-R`/`-Q` 路径，并把本地 `lib/` 映射到与 Makefile、QCP 命令及
`Require` 完全一致的逻辑路径；任何一处逻辑路径变化时同步更新其余各处并重新编译
受影响的 `.vo`。当前 Coq 8.18--8.20 的 VsRocq 进程不能为每个文档应用局部
`_CoqProject` 的 load path；在这些版本下，还要把当前活动 trial 的外部路径和
`lib/` 映射同步到 CRTOS 根 `.vscode/settings.json` 的 `vsrocq.args`，并确保
`"*.v": "rocq"`。当前 VsRocq 扩展不会替 `vsrocq.args` 展开
`${workspaceFolder}`，这里必须写已经解析并确认存在的绝对路径。切换活动 trial 时替换
旧 trial 专属映射，不累积映射到同一逻辑路径的多个 `lib/`；Coq/VsRocq 升级后也要
先实测局部项目和路径变量是否生效，不能只假定支持。

真实 CRTOS 源码与配置是语义依据。完整源码模式下，`annotated_C/src`只能增加或
修改注解；默认单函数切片模式允许经过审阅的等价提取归一，例如拆开assignment/
comma expression、把function-like macro或稳定done-table dispatch改为具名API、
把原TU static对象声明为slice external。每项归一都必须保留路径与副作用、在报告
中绑定源码/config证据；换算法、隐藏body或凭空简化布局仍是blocker。QCP参考目录
固定为trial外的`/home/xinra/qcp-binary-democases/`；确认存在但不得修改。

写新定义、strategy 或断言前，先用 `rg` 搜索 QCP 教程、示例和项目现有 `lib/`，复用已有 predicate、tactic、assertion 与 `which implies` 写法。不要猜 QCP 语法；找到最接近的例子，最小修改后立即检查。

## 技能演进与报告

可复用的 skill 变化先记录到 `.docs/CandidateSkills/` 或 `.agents/skill-candidates/`，写清触发问题、方法、限制和验证证据；独立检查后由用户批准。

每个任务在 trial `.docs/Report/` 保存简短的 `YYYY-MM-DD-N-title.md`，用普通段落或项目符号记录阶段与明确 revision、关键修改、检查结论、必要复现命令和剩余 blocker；没有比较关系时不写表格，不逐文件抄录成功项。implement 时补充 QCP 结果、VC/证明计数和 Rocq 编译。计时只记录脚本得到的机械检查总耗时，以及任务开始到 `review-passed` 的墙钟区间；不要估算或逐项填写 analysis/edit/review/wait。昨天以前的报告移入 `folded_history/`。

始终保持以下抽象链条：

```text
CRTOS C -> Rocq predicates -> QCP spec -> local symbolic resources
        -> generated VC -> machine-checked Rocq proof
```
