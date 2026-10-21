---
name: verify-c-function-with-qcp
description: 使用 QCP、Rocq/Coq 和分离逻辑验证 C 函数或模块：确定源码与配置，设计并分别审阅 predicate 和 spec，经用户确认 revisions 后完成 symbolic、VC、proof 和完整性检查。
---

# 使用 QCP 验证 C 函数与模块

为 C 代码建立可机器检查的功能正确性证明。始终保持下列链条闭合：

~~~text
authoritative C/config -> Rocq predicates -> QCP specs
                       -> symbolic resources -> generated VC
                       -> machine-checked Rocq proof
~~~

## 必读内容

先确定目标 C 工程，再按阶段读取必需内容：

- 设计或修改 predicate/lemma 前，完整阅读 [Predicate 与 lemma 设计指南](references/predicate-lemma-design-guide.md)。
- 设计或修改 spec 前，完整阅读 [Spec 编写指南](references/spec-writing-guide.md)。
- 进入 symbolic、VC 或 proof 前，完整阅读 [实现与验证指南](references/implementation-and-validation-guide.md)。
- 需要参考既有正式定义、已审阅接口或已完成证明时，阅读 [已有证明库的使用方式](references/existing-proof-library-guide.md)。
- 创建、更新或关闭设计、审阅、错误或最终检查记录前，完整阅读 [验证记录指南](references/reporting-guide.md)。

项目或领域专用事实应由独立 knowledge package 提供。本 skill 不内置任何特定产品、代码库、目录布局、状态机或并发模型；外部 knowledge 与本流程冲突时，以权威源码、当前配置和本 skill 的正确性门禁为准。

## 总流程

Main agent 负责确定模式、守住审批门并汇总证据。Predicate 和 spec 的作者与 reviewer 应尽量分开；没有独立 reviewer 时，由 main agent 按相同条件自检并注明。

~~~text
确认验证上下文 -> C 分析 -> predicate/spec 草案迭代
                 -> predicate review-passed
                 -> spec review-passed
                 -> 用户确认两份 revision
                 -> QCP parser/symbolic -> VC -> Rocq proof
                 -> final integrity check
~~~

### 确认验证上下文

在 predicate 设计前固定并记录：

- 目标工程、权威源码与 revision、构建配置和实际激活的条件编译分支；
- 目标模块边界、函数集、初始化/销毁/回收路径和模块直接访问或拥有的 C 对象；
- 影响内存语义的外部假设和当前证明边界；
- trial/workspace 的绝对路径、正式 Rocq/annotated C 产物位置及允许修改的文件；
- 用户批准的 trusted C symbols 和采用的 contract/保证。

Main agent 可以建议将复杂 callee 列为 trusted，但只有用户明确同意具体 symbol 后才停止递归。未解决事实标记为 [OPEN]；影响 scope、ownership、路径或 effect 的 [OPEN] 阻塞 review-passed。

### Review 生命周期

状态使用 draft -> review-ready -> needs-fix|review-passed -> invalidated。Predicate 和 spec 各自固定 revision、各自审阅和记录结论，不得用一个综合结论代替。

- 首个 review-ready revision 做 full review。needs-fix 后只复查已报 issue、修改处及 dependency closure；权威 C、config、scope、trusted 列表或上游 breaking change 使依据失效时重做 full review。
- 纯格式、报告或不影响已批准设计的 proof-local 修改不触发重审；同一 revision 不重复 review。
- Issue 必须给出 ID、级别、file/symbol 证据、mismatch、后果、最小修复、可执行通过条件和状态，并按验证记录指南分类：权威 C 缺陷写源码错误报告；predicate/spec 等已审阅设计必须变化时写设计变更记录；不改变 formal 语义的 proof/tool 实施问题不冒充前两类。
- 已通过产物仅在其审阅依据变化时标记 invalidated。同一 blocker 没有新 revision 或新证据时停止空转并报告用户。

## 工作模式

### slice-design

读取当前配置下目标模块的全部实现函数，以及必要的 types、globals、初始化/销毁路径和外部调用上下文。按函数记录控制流、所有返回/阻塞路径、memory reads/writes、calls、side effects、loop invariants 和必要假设。外部函数只因上下文需要被读取，不因此自动归入目标模块。

从全模块真实访问的 C 对象出发，设计 abstract state、representation、owned memory、lifecycle states、unchanged resources 和所需 lemma statements。优先复用项目和 QCP 已有库；用具名 view 或 which implies 导出局部资源，不让上层 spec 泄漏容器和字段实现。

若工程已有正式定义或证明库，按 [已有证明库的使用方式](references/existing-proof-library-guide.md)先区分 example-only、reviewed-interface、proved 和 user-approved trusted，再决定复用、适配或只参考组织方式。文件存在或名字相似不代表其结论可直接使用。

共享 Rocq definitions 写入项目约定的 library，按 pure state、protocol、heap representation 的语义和依赖方向组织，不强制固定文件名。正式 .v 中为非平凡、核心组合或对外 definition/statement 写紧邻定义的文档注释，说明逻辑参数、地址/字段与 C 对象的直接对应、ownership 和限制。不得使用 Parameter、Axiom、占位定义或手写 Admitted/admit 绕过设计或证明义务。

在工作区报告目录维护 predicate 设计记录。它必须说清 scope/config、C 对象到抽象状态的整体映射、分层、ownership/lifecycle、对外 interface、限制、[OPEN] 和 formal revision，但应按目标模块最容易理解的方式组织，不要求模板、固定章节或空占位项。遵循 [验证记录指南](references/reporting-guide.md)。报告不复制 formal definitions，也不成为第二份语义源。

Predicate 只有在以下条件成立时才 review-ready：模块范围与配置固定；每个实际访问字节都能追溯到候选的唯一 owner/representation；初始化、正常运行、状态转换、删除和回收已覆盖；formal sources 和注释落地并通过适用检查；没有影响 owner、抽象语义、lifecycle、frame 或后续验证的 [OPEN]。

### write-spec

从用户指定 target 出发，在当前配置下递归跟随直接调用、可唯一解析的 function-pointer/table dispatch 和 function-like 宏展开后产生的真实调用，直到 leaf 或用户批准的 trusted symbol。无法唯一解析的调用保持 [OPEN] 并阻塞 review。

默认使用扁平的一函数一文件切片：

- 闭包内每个非 trusted 函数 f 必须且只能有一个 canonical annotated C 文件，其中有一份真实 active body 和完整 With/Require/Ensure。
- f 调用 g 时，在 f 定义前写 g 的完整 declaration-only API spec，不复制 g 函数体；caller-local contract 必须与 canonical spec alpha/typedef 等价。
- 不得用裸 C prototype、implementation-pending 或模块级 specs header 替代 callee spec。
- Canonical contract 直接表达各真实返回/阻塞路径、abstract effect、old/new、ownership transfer 和 frame。裸 store 通常留在 representation predicate 或函数体局部展开中，不沿调用链泄漏实现字段。
- 不得用含糊的 pre/post/spec helper 隐藏入口资源、成功/失败路径或出口效果。
- 切片可作有源码/config 依据的等价归一，但不得改算法、路径、返回值、ABI 布局或副作用；每项可执行归一都要记录并审阅。

如果新可达函数暴露出 predicate 缺失的对象表示、ownership view 或中间状态，暂停 spec 并返回 slice-design；不得用更多裸 store 代替缺失抽象。已 review-passed 的 predicate 被修改时，固定新 revision 并重新审阅。

结束前从 target 重新扫描完整闭包。任何缺失 body/canonical spec、裸 call、未解析 dispatch/宏调用、错误 ABI 或多重归类都是 blocker。write-spec 不运行 QCP parser/symbolic、闭包脚本、VC 生成或 proof。Predicate review-passed 前不进入 spec review。

### review

默认只读，只检查用户指定 artifact 和 revision；除非用户同时要求修改，不实施修复、不自行批准。

Predicate review 至少检查：抽象语义有源码/客户端依据；每个具名生命周期状态内的可访问字节恰好一个 owner；容器、lifecycle 和 ownership 边界闭合；跨模块借用/转移明确；formal checks 通过且无 blocker。

Spec review 至少检查：scope-faithfulness；每条真实路径的参数、返回值、effect、old/new、ownership transfer 和 frame；Require 足以执行但不无据加强；Ensure 不弱化实现义务；protocol/caller resources 在出口正确返还；callee spec 不冒充 proved。记录遵循 [验证记录指南](references/reporting-guide.md)，不要求套用统一模板。

Predicate 和 spec 分别 review-passed 后，请用户确认两份明确 revision。用户确认前不得运行 QCP、生成 VC 或开始 proof。修改已批准接口时，按 [验证记录指南](references/reporting-guide.md)写简短设计变更记录，并说明变更原因和影响范围；只有变更由真实源码缺陷触发时才链接源码错误报告。

### implement

只有用户明确确认两份 review-passed revisions 后才进入。先确认源码、config、trusted 列表和批准 revisions 未变，再运行完整闭包检查。对闭包内每个 annotated C 执行 parser 和 symbolic，全部到达文件末尾后才生成 VC/strategy soundness goals 并完成 Rocq proof。

项目适配后可运行：

~~~bash
QCP_STRATEGY=<logical-or-file-strategy> \
bash <skill-dir>/scripts/check-spec-closure.sh <workspace-dir>
~~~

项目若已在 CONFIGURE 中声明 QCP_Strategy，可省略环境变量。脚本不推测项目名或逻辑路径；未提供 strategy 时应报错，不得默认套用其他工程配置。

Parser/symbolic 若暴露问题，先按 [验证记录指南](references/reporting-guide.md)归因。若权威 C 本身违反明确要求，建立源码错误报告；若 Require/Ensure、路径、ownership、predicate 或 callee contract 必须变化，建立设计变更记录，按 dependency closure 使相关 review 失效并返回设计模式；只有不改变批准设计的 proof annotation、strategy、lemma、tactic 或工具调用问题可留在 implement。

不得手工修改 QCP 生成的 goal/auto-proof 文件；手工目标和辅助 lemma 写在项目约定的 manual/lib 文件。沿调用图自底向上证明，leaf 在 caller 之前。所有 proof 必须编译；不得删除、弱化、隐藏 goal，也不得在未实际运行 QCP/Rocq 时声称验证成功。

完成后建立最终完整性记录，覆盖 C/source 等价性、QCP symbolic、VC 计数、goal 完整性、Rocq 编译、proof 和 Parameter/Axiom/Admitted/admit 扫描；只汇总当前有效证据，并按需链接源码错误报告或设计变更记录，不在正文重写诊断历史。记录遵循 [验证记录指南](references/reporting-guide.md)，不要求套用统一模板。所有必需检查通过、全部目标 VC 已证明、没有影响结论的未解决源码错误或未批准设计变更，且无未批准信任依赖时，才能标记 verified。

## 产物与配置原则

- 工作区路径和子目录由目标项目配置决定；不覆盖现有内容，不把 trial 放入权威源码子树。
- 维护项目的 _CoqProject 或等价配置，使 library mapping、Makefile、QCP 命令和 Require 一致；任何逻辑路径变化都要同步并重编译受影响文件。
- 写新 predicate、lemma、strategy 或 assertion 前，先用 rg 搜索 QCP 库和项目已有定义；不猜测 QCP 语法。
- 复用跨模块定义前检查其内容。若有疑点，在任务回复和对应设计/review 记录标记 [OPEN]；未经授权不修改共享定义，影响正确性的问题解决前不得 review-passed。
- 可复用的 skill 变化先记录触发问题、方法、适用边界和验证证据，经独立检查和用户批准后再吸收到主干。
