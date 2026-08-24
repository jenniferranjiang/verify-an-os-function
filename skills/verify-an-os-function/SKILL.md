---
name: verify-an-os-function
description: 验证 CRTOS 等非 SMP OS 的 C 函数：读取真实源码和当前配置，按 slice-design、write-spec、implement、review 四种模式，分别设计和审阅 Rocq predicate 与 QCP spec，在两者通过并由用户批准后运行 QCP、生成 VC、完成 Rocq 证明和完整性检查。适用于建立或继续 task、scheduler、IPC 等模块的验证，以及审阅已有 predicate、spec、VC 和 proof。
---

# 验证 CRTOS 函数

使用 QCP、Rocq/Coq、分离逻辑、符号执行和 VC，为 CRTOS 内核 C 代码逐步建立可机器检查的功能正确性证明。默认处理当前配置实际编译的非 SMP 代码。

## 模式与总流程

Main agent 负责确定模式、安排顺序、守住审批门并汇总结果。作者与 reviewer 应分开；predicate review 和 spec review 的对象、条件和记录也必须分开。Review 次数不预设，由产物 revision、修改影响和通过条件决定。没有独立检查能力时，由 main agent 按相同条件自检并注明。

```text
确认验证上下文 -> C 分析 -> predicate 草案 -> predicate review-passed
             -> spec 草案 -> spec review-passed -> 用户确认两份 revision
             -> QCP/VC/Rocq proof -> final integrity check
```

### 确认验证上下文

开始 predicate 设计前，确认权威 C 源码与当前配置、目标函数/模块及 direct dependencies、实际 critical/IRQ/atomicity 行为，
以及可信或排除组件。优先读取用户指定或项目已有的说明，包括已有 baseline 文件；默认不新建 OS baseline、module baseline
或对应模板，也不为这一步单独安排 review/approval。只在任务回复或最终报告中简短记录本次使用的事实和 `[OPEN]`。

上述上下文变化并影响已审阅 predicate/spec 时，按 dependency closure 将相应结论标记为 `invalidated`；与当前目标无关的
项目事实变化不触发重审。

### Review 生命周期

每份 predicate/spec 产物使用 `draft -> review-ready -> needs-fix|review-passed -> invalidated`。状态可以记录在任务报告中；predicate 不要求单独的 Markdown manifest。只在以下条件成立时 review：

- 首次 full review：产物满足本模式的 review-ready 条件，且该 revision 尚未审过；
- delta review：作者提交了新 revision，修改会影响上一轮 issue、formal symbol、语义、ownership、Require/Ensure 或依赖结论；只检查修改和 dependency closure；
- 重新 full review：权威 C、配置、目标 scope、可信边界发生变化，或上游 breaking change 使原审阅依据失效；先标记 `invalidated`，补齐新输入并重新达到 review-ready 后才开始 full review。

只改格式、注释、报告措辞或 proof-local tactic，且不影响上述结论时，不触发 review。不得对同一 revision、同一证据重复
给出相同意见；同一 blocker 没有新修改或新证据时，标记 blocked 并交给用户决定，而不是空转增加 round。

每条意见必须包含严重级别、源码或 formal file/symbol 证据、具体不一致、实际后果、最小修改和可执行通过条件。
禁止只写“抽象边界不清晰”或“ownership 可能不完整”。Review 在所有适用通过条件有证据、检查成功且没有 open blocker
时结束；non-blocker 可以明确接受或延期。

Final integrity check 同样按条件运行：proof 候选完成时做完整检查；修复后只重跑失败项和受影响项；权威 C、approved
predicate/spec revision 或生成 goals 变化时重新做完整检查。

### `slice-design`

C analysis agent 读取目标函数、direct callees、相关类型、全局对象、初始化/销毁路径和条件编译，记录控制流、返回路径、memory reads/writes、指针与字段、calls、side effects、loop invariant 和必要假设。遵循当前配置，忽略未定义宏保护的代码，例如 `SEPARATE_COMPILE`、`TASK_ISOLATION`。

Predicate design agent 从实际访问的 C 对象确定 abstract state、owned memory、mutable fields 和 unchanged resources。隐藏不必要的实现细节；不要盲目展开大型 predicate，优先用 `which implies` 导出字段、节点、数组片段等局部 view，并保留未触达资源。

AI 新建的共享 Rocq semantic definitions 直接写入项目 lib/。lib/ 中的文件应按源码对象、ownership 边界、容器、协议、module invariant 或可独立复用的语义职责拆分。不得把一个 verification slice 的全部 state、container representation、critical protocol、module invariant、function effect 和 lemma 机械集中到单一 *Predicates.v 文件。直接在 `.v` 中用 `(** ... *)` 中文文档注释解释生成的非平凡定义：用自然语言说明这个定义做什么，以及理解或使用它时真正需要知道的限制、保持关系或中间状态。不要规定固定栏目，也不要为了填注释机械罗列 ownership、参数、抽象边界和客户端；简单定义一句话即可。注释必须随 definition 一起更新，过时或误导性注释视为 blocker。Rocq 文件先放 definition，再放 lemma/theorem/proof；不得用 `Parameter`、`Axiom`、占位定义、手写 `Admitted/admit` 绕过证明。

Predicate review-ready 条件：目标 C/config/scope 与 context functions 已固定；每个实际访问的 C 对象和内存都能追溯到候选 owner/representation；正式 state/predicate/lemma statement 已写入 `.v`，必要中文注释与代码一致，并通过适用的 compile/typecheck；没有会影响 owner、抽象语义、lifecycle、frame 或 formal check 的已知 `[OPEN]`，也没有用假设掩盖缺口。已知 blocker 应先由作者处理，不用 review 重复发现。

Predicate review-passed 条件：每个实际访问字节有且仅有一个 owner；abstract state 和每个命名 predicate 都有源码语义或复用客户端依据；container/lifecycle/critical 边界能闭合；没有重复 ownership、无依据假设或禁止的 `Parameter/Axiom/Admitted/admit`；formal checks 通过且没有 open blocker。通过后固定 reviewed revision，再进入 `write-spec`。

- 必须读：已确认的验证上下文、目标 C/headers/config、当前 trial 工作区已有的 `lib/` 定义和 [predicate-lemma-design-guide.md](references/predicate-lemma-design-guide.md)。
- 写：项目实际使用的 Rocq `.v`，把解释放在相关 definition/statement 前；默认不创建 predicate review template。Review issue、reviewed revision 和结论只写入任务回复或最终报告，不复制 formal source。
- 修改已批准接口时使用：[design-change-request-template.md](assets/design-change-request-template.md)。

### `write-spec`

Spec writing agent 基于 review-passed predicate revision，在 annotated C 中为每个函数分别编写 `With/Require/Ensure`；上层引用 direct-callee spec，不展开整棵调用树。Spec 覆盖实际控制流和每条返回路径，明确参数、返回值、ownership、可变资源和不变资源。发现 predicate 缺陷时使其状态变为 `invalidated` 并退回 `slice-design`；predicate 再次通过后，只重审实际受影响的 spec。

Spec review-ready 条件：引用的 predicate revision 为 `review-passed`；目标函数全部 return/blocking path 和 direct-callee 状态已列出；正式 pre/post 与 annotated C `With/Require/Ensure` 已写出；每个 load/store 能追溯到 reviewed predicate；Rocq compile 和 annotated C parser/typecheck 已通过适用检查；没有会影响路径、effect、ownership、frame 或依赖结论的已知 `[OPEN]`。

Spec review-passed 条件：每条真实路径的参数、返回值、abstract effect、old/new、ownership transfer 和 frame 都匹配；Require 足以执行但没有无依据加强，Ensure 没有弱化实现义务；critical/caller resources 在出口正确返还；callee 状态没有冒充 verified；没有无依据假设，formal checks 通过且没有 open blocker。Predicate 与 spec 分别 review-passed 后，用户确认两份明确 revision；确认前不运行 QCP、生成 VC 或开始 proof。

- 必须读：已确认的验证上下文、review-passed predicate revision、目标 C 与 direct-callee specs，以及 [spec-writing-guide.md](references/spec-writing-guide.md)。
- 写：只在每个函数对应的 annotated C 中编写 With/Require/Ensure，不在 `write-spec` 阶段直接新增或修改共享 Rocq semantic definitions。
- 回退条件：若编写 spec 时发现缺少或需要修改共享 state、predicate、effect relation 或 semantic lemma，将 predicate revision 标记为 `invalidated`，退回 `slice-design`，在当前 trial 工作区的 `lib/` 中完成修改和 predicate review；新的 predicate revision 再次 `review-passed` 后恢复 `write-spec`。
- Spec review 使用：[spec-review-template.md](assets/spec-review-template.md)。
- 修改已批准 predicate/spec 时使用：[design-change-request-template.md](assets/design-change-request-template.md)。

### `implement`

只有用户明确要求后才能进入。Verification agent 使用项目环境运行 QCP 预处理、输入生成、符号执行和 VC 生成，记录命令、生成文件、VC 数量和失败；再完成 strategy、loop invariant、辅助 lemma 与 Rocq proof。先检查 `coqc --version`。

先分类失败，只修改对应内容：C parsing、specification、symbolic execution、logical proof 或 arithmetic。Predicate 变化按 predicate 条件重审；Require/Ensure、路径、ownership 或 abstract effect 变化按 spec 条件重审；proof-local lemma、strategy、tactic 或不改变审阅结论的实现修正不触发设计 review。

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

- C integrity：确认 `annotated_C/src` 只改注解，未改可执行 C；
- VC integrity：确认生成 goal 完整、未删除、未弱化、未隐藏；
- proof/trust：确认 VC 计数、Rocq 编译和 `Parameter/Axiom/Admitted/admit` 扫描结果。

- 必须读：被审阅的正式文件、源码证据、diff/check 结果，以及该产物所属模式的 guide；proof review 读取 [implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。
- 写：predicate 直接审阅带注释的 `.v`，把 issue、reviewed revision 和结论写入任务回复或最终报告；spec 更新 [spec-review-template.md](assets/spec-review-template.md)，实现完成后更新 [final-integrity-template.md](assets/final-integrity-template.md)。已有旧 predicate manifest 无需迁移，也不再新建。

## 项目与参考路径

开始一个新的函数验证任务时，在原始 CRTOS 源码目录之外新建独立工作区，默认命名为
`<function-name>-trial/`；若用户指定了其他名称或已有工作区，则使用用户指定的目录。

在进入 C 分析前，立即创建并检查 trial 工作区的最小目录结构：
`annotated_C/src/`、`lib/`、`VC/` 和 `.docs/Report/folded_history/`。
已有工作区只补齐缺失目录，不覆盖或清空已有文件。创建或写入前先解析并报告工作区的
绝对路径，并确认这些目录都位于 trial 工作区内，不得落入原始 CRTOS 源码目录。

QCP 源码、教程和示例固定使用工作区外的 `../qcp-binary-democases/`，当前绝对路径为
`/home/xinra/qcp-binary-democases/`。开始验证前确认该目录存在；不得自动创建、重命名或修改它。

典型布局为：

```text
../crtos/                                  CRTOS 原始源码，只读语义依据
../crtos/Ubiquitous/XiZi_IIoT_Macro/       当前目标子系统示例
../qcp-binary-democases/                   固定的 QCP 源码、教程和示例
../<function-name>-trial/                  当前函数的独立验证工作区
├── annotated_C/src/                       待验证 C 与必要头文件的副本
├── lib/                                   AI 新建的 Rocq 定义和证明
├── VC/                                    QCP 生成的 VC 与 proof 文件
└── .docs/Report/
    └── folded_history/                    任务报告及折叠历史
```

真实 CRTOS 源码和当前配置是 C 语义依据；trial 工作区的 `annotated_C/src` 只能增加或修改注解，
不能改变复制来的可执行 C。发现可执行 C 被修改时立即报告。不得修改原始 CRTOS 或已确认的 QCP 工具目录。

写新定义、strategy 或断言前，先用 `rg` 搜索 QCP 教程、示例和项目现有 `lib/`，复用已有 predicate、tactic、assertion 与 `which implies` 写法。不要猜 QCP 语法；找到最接近的例子，最小修改后立即检查。

## 技能演进与报告


一次性经验不要直接写成新 skill。可复用的行为变化先记录到 `.docs/CandidateSkills/` 或 `.agents/skill-candidates/`，包含触发问题、方法、适用条件、限制、受影响文件、命令和验证证据。优先扩展现有 skill；按受影响内容做独立一致性检查并由用户明确批准，不按固定次数建立 review cycle。

每个任务都给出并保存最终报告。报告先列修改文件和阶段状态，再说明 predicate、抽象边界、ownership、实际检查结果、简洁复现命令和剩余问题；未完成时写明 failing VC、缺失 lemma、推测原因和下一步。implement部分至少包含：

```text
Function:
QCP result:
Generated VC count:
Proved VC count:
Remaining VC:
Rocq compilation:
```

将 Markdown 报告写入当前 trial 工作区的 `.docs/Report/`，文件名使用 `YYYY-MM-DD-N-title.md`，例如 `2026-07-25-1-assertion-model-migration.md`。将昨天以前的旧报告移入当前 trial 工作区的 `.docs/Report/folded_history/`。

始终保持以下抽象链条：

```text
CRTOS C -> Rocq predicates -> QCP spec -> local symbolic resources
        -> generated VC -> machine-checked Rocq proof
```
