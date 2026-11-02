# Spec 编写指南

本指南服务 `write-spec`。以当前配置下的权威源码、目标模块与依赖，以及用户批准的 `trusted` 函数为依据；涉及 lock/IRQ/atomicity 或 abstract-command 时，核对相应协议。当前 predicate revision 提供总状态、module state、局部读取/更新函数、predicate、lemma、crtOS `LastSeen`、目标函数的 atomic command 和适用的
crtOS 临界区定义；函数的 canonical contract 写在其自身 annotated C 的函数定义上；caller
文件可以复制 direct-callee contract 作为 declaration-only API，但必须
与 canonical 文件中所选的同名 spec 一致。Markdown 和手写 .v 均不得复制函数 contract 正文。Markdown 只可记录路径、symbol、C 证据、返回路径和审阅状态，不承载 spec 正文。Spec review 与 predicate review
分开。Predicate 和 spec 草案可以共同修改；草案期间发现 predicate 缺口时直接返回 `slice-design`
修正，不标记 `invalidated` 也不做中间 review。Spec review 必须引用同一份 `review-passed` predicate revision。

Spec 是验证前写出的正式目标，不是验证结果：它规定调用所需资源、返回或非终止路径、abstract effect、
具体内存 ownership 与值/结构的前后态、ownership 转移以及 frame；后续 proof 才证明 C 实现满足该 spec。
写完或批准 spec 都不能称为“函数已验证”。

Spec review 只审查设计：验证范围、内存与 ownership、函数行为、路径和 frame。此阶段不运行 QCP；
QCP parser/symbolic、VC 和 proof 在用户确认 review-passed revisions 后进入 `implement`。

## 目录

1. [先固定模型和函数层次](#1-先固定模型和函数层次)
2. [确定参数和 effect](#2-确定参数和-effect)
   - [2.2 Local/Glob 在 Spec 中的使用](#22-localglob-在-spec-中的使用)
3. [写每个函数的 Spec](#3-写每个函数的-spec)
   - [3.1 Spec 与注解位置](#31-spec-与注解位置)
   - [3.2 函数 Spec 的直接可审阅性](#32-函数-spec-的直接可审阅性)
   - [3.3 保持函数层次的抽象边界](#33-保持函数层次的抽象边界)
   - [3.4 Predicate 的展开、更新与恢复](#34-predicate-的展开更新与恢复)
   - [3.5 Predicate 接口不足时的处理](#35-predicate-接口不足时的处理)
4. [临界区调用链中的函数 Spec](#4-临界区调用链中的函数-spec)
5. [覆盖所有结果路径](#5-覆盖所有结果路径)
6. [Spec 审阅](#6-spec-审阅)

## 1. 先固定模型和函数层次

读取从目标函数递归得到的完整可达闭包、各函数的 direct callees、全部 return path、项目现有 module/function libraries、annotated C imports 和
`Extern Coq`。Rocq 文件按主 skill 的 [文件组织与存放](../SKILL.md#文件组织与存放)安排：模块公共定义直接复用，函数专用的抽象操作与 `program` 可写在该函数的 `.v` 文件中；`With/Require/Ensure` 仍写在对应 annotated C 中，不复制到 `.v`。然后按已确认的验证上下文和项目实际
协议组织 spec。目标函数自己进入/退出临界区，或依靠临界区取得共享 invariant 时，spec 应明确写出临界区外和
临界区内。直接引用当前 slice 的 crtOS 临界区定义；若尚未建立或 state/transition 不足，返回
`slice-design` 在同一草案中补齐。只有修改已经批准的接口时才提交 breaking change request。Spec writer 不另写一套
临界区模型，也不要改写成
`entry_resource`、`held_resource` 等含糊名称或另建自定义 token Record。

只有已批准 protocol 允许等待 lock 时环境推进状态，才区分 `old/current`；顺序或中断屏蔽语义若保证无环境并发更新，
不应机械引入两个状态。

验证闭包遵循主 `SKILL.md` 的[验证范围](../SKILL.md#验证范围)：先按当前配置和
[源代码处理](源代码处理.md) 完成适配，再沿切片中保留的调用递归。文档明确规定且适用的
模型/API 替换作为边界，无需重复批准，也不递归被替换部分的原始内部调用。
从根 annotated_C 导入复用的依赖 spec 按[工程配置指南](project-configuration-guide.md#已有-spec-的复用与特化)
记为 `reused-spec` 边界，不为该函数及其内部调用安排本轮 VC 或函数体重证；适用性和 contract 一致性仍须检查。其余非
`trusted` 函数按本节建立 annotated C。Main agent 可以建议把复杂
callee 作为 `trusted`，但不能代替用户决定。批准的 symbol 和 contract 记录在当前任务
上下文或报告中，不写入本通用 guide。无法唯一解析的调用须说明位置和原因，解决前阻塞 review。dispatch 和宏
归一必须绑定 table initializer、macro definition、配置分支、赋值点或采用的源码处理规则。
普通归一保持 body、路径和副作用；模型替换记录适用条件、接口和结论限制，不将其当作原实现已获证明。

实际项目常见的推进方向是：通用 link/array/bitmap 等局部操作，接着是对象或业务容器操作，再到同时维护多个
对象、容器和 globals 一致性的模块操作，最后到包含参数/返回码、critical/IRQ 和 caller resources 的最外层 API。
这只是依赖关系的常见形状，不是必须补齐的分类；源码中没有某一层就直接跳过，也不要为了形成层级虚构 wrapper。

每个 canonical 文件先声明当前函数的 direct callees 并附完整 declaration-only
`With/Require/Ensure`，随后保存当前函数自己的 canonical spec、真实定义和 active 函数体。

写完文件后按主 skill 的闭包门禁重新从适配后的 target 扫描 body calls、dispatch 和宏处理结果。
《源代码处理》规定的替代函数按其模型/API contract 检查；其他宏展开后保留的调用继续进入闭包，
可执行语句在 caller 中等价归一。空宏、常量、`sizeof` 和纯类型/布局宏不产生函数。
正文中每个保留的调用都须有完整 formal API，不自行发明文档未规定的替代函数。

修改 callee 已有具名 spec 时，引用该 spec 的 caller API 副本必须同步更新，并重新检查受影响的
dependency closure。只新增特化 spec 且原 spec 与依赖未变时，不使使用原 spec 的 caller 失效。

LOS 文件只提供函数 spec 的写法示例。可以复用的是 QCP 的通用 `critical_STS/CriticalCSL`，不是 LOS 的
`Los_CS_C`、`Los_Verify_State` 或 transition；crtOS 使用自己的状态和允许转换。

已有 spec 的导入、等价适配与场景特化统一按 [工程配置指南](project-configuration-guide.md#已有-spec-的复用与特化)执行。

### 单函数切片的等价转换

完整源码模式下，`annotated_C/src` 只增加或修改注解。单函数切片为适配工具可进行有源码与配置依据的等价转换，例如拆分赋值或逗号表达式、展开函数式宏、解析固定函数表分派，或把原编译单元中的 static 对象以外部声明形式提供给切片。

本节的等价转换必须保留求值顺序、执行路径、返回值、副作用、对象身份和实际访问字段的布局。外部声明须对应原对象，不能创建新的对象代替它。每项转换在 spec review 中说明位置、理由及源码/config 依据；不得换算法、隐藏函数体或凭空简化数据布局。《源代码处理》明确规定的抽象适配按主 skill 的专门规则执行，不要求将其表述为逐语句等价转换。

## 2. 确定参数和 effect

- `sg`：稳定地址、大小、ID 和 config；不因量化 `sg` 自动获得内存权限。参考
  [glob_vars_and_defs.v](doc/glob_vars_and_defs.v)。
- `st_bef/st_lock/st_aft`：只在当前并发规则确实区分函数入口、取得锁和修改完成这几个时刻时使用；
  否则只保留当前函数真正需要的状态参数。
- module state：引用当前 predicate revision 的 module-state 读取函数与 `replace_*S` 局部更新函数，只实例化允许改变的模块。参考
  [Los_Verify_State_def.v](doc/Los_Verify_State_def.v)。
- `atomic_api(args)`：成功、失败、返回值和允许的状态变化；不得授权未涉及模块变化。
- `args/ret`：明确 C handle、错误码、buffer 与抽象值的对应。
- caller resources：输入/输出 pointer、私有对象和 buffer 单独列出并在出口返还。

Stable/Mutable 是否拆分由当前 predicate revision 决定，在 spec 中不另写一套。若已拆分，同一个 `sg` 从
`Require` 传到 `Ensure`，Mutable state 再按真实协议使用 `st_bef`、`st_lock`、`st_aft`；若采用 combined state，
则使用当前 predicate revision 的 stable-projection 保持关系。

每个 C load/store 必须由当前 predicate revision 的 `data_at`、object/module predicate 或 `OS_inv` 支持；抽象 state
本身不提供访问权限。函数 spec 还必须表达 load 所需的前态值、store 产生的新值或结构，以及 write footprint
之外保持不变的 frame。

### 2.1 Stable/Mutable 在 Spec 中的使用

Stable/Mutable 如何划分由当前 predicate revision 决定，Spec 中不另写一套。对于初始化完成后正常运行的函数，如果状态已经拆成 `sg : StableGlobalState` 和 `st : VarGlobalState`，应在函数前后复用同一个 `sg`，用不同的 `st` 表示共享内容的变化。不要因为目标函数没有修改某个字段，就在 Spec 阶段临时把它移入 `sg`；也不要为了套用统一格式，让每个函数都同时携带 `st_bef`、`st_lock` 和 `st_aft`。只有实际执行过程确实区分函数入口、取得锁和修改完成这几个时刻，才需要这些状态参数。

例如，`KTaskCreate` 的外层 Spec 可以采用下面的形式：

```c
/*@ With (sg : StableGlobalState)
         (st_bef : VarGlobalState)
         (...)
    Require
      caller_resources *
      TaskOutsideCritical(sg, st_bef)
    Ensure
      exists (st_aft : VarGlobalState)
             (task : addr),
        result_relation(__return, task) &&
        function_effect(
          sg, st_bef, st_aft, task, __return) &&
        returned_caller_resources *
        TaskOutsideCritical(sg, st_aft)
 */
```

这里前后使用同一个 `sg`，表示 ID manager、task-head、`Done` 等全局对象的地址和固定配置仍然使用同一组逻辑值；`st_bef` 表示函数入口记录的可变共享内容，`st_aft` 表示函数返回时的可变共享内容。示意名称 `function_effect` 应替换为目标项目已经定义或本次正式设计的函数效果关系；它进一步说明 ID manager 和任务链表具体发生了什么变化，例如加入新分配的 ID、记录 `&(task->id)`，并把 `task->link` 插入任务链表。`TaskOutsideCritical(sg, st_aft)` 则说明函数返回时已经重新建立与新状态对应的共享资源，并退出临界区。

如果函数需要等待并取得锁，可以在函数效果中继续区分：

```coq
exists st_lock,
  TaskRTrans st_bef st_lock /\
  operation_effect sg st_lock st_aft /\
  TaskGTrans st_lock st_aft.
```

其中：

- `st_bef` 是函数入口时记录的状态；
- `st_lock` 是真正取得锁和共享内存时看到的状态；
- `st_aft` 是 C 代码修改完成、准备解锁时的状态；
- `sg` 在整个过程中保持为同一个参数；
- `operation_effect` 说明当前函数实际修改了什么；
- `TaskRTrans/TaskGTrans` 只判断这些前后状态是否符合当前并发规则，不提供内存权限，也不执行修改。

如果函数不使用锁，或者当前配置保证入口到执行期间共享状态不会被其他执行改变，就不必机械引入 `st_lock`。初始化、动态重配置或销毁重建函数可能建立或改变 Stable 部分，应按照当前 predicate revision 和函数接口单独编写 Spec。若使用一个总 state，则沿用当前 predicate revision 的更新函数或保持条件，保证固定地址和固定配置不会被普通状态更新替换。

### 2.2 Local/Glob 在 Spec 中的使用

Local/Glob 是帮助组织函数 Spec 中资源位置的说明性术语，
这里使用 Local/Glob 作为理解使用临界区相关函数 Spec 的术语，不要求项目定义名为 `Local` 或 `Glob` 的 Rocq predicate、
state 或 relation。Local resources 是当前函数或调用者直接持有、在调用链中作为 frame 保留或返回的资源；Glob
resources 是由全局 invariant、临界区、IRQ 或 STS 协议维护的资源。正式 Spec 仍然使用项目实际定义的
`OutsideCritical`、`InsideCritical`、`RTrans/GTrans`、`OS_inv` 或 module invariant，以及具体的 caller-owned
object 和 buffer predicates。

```text
Local resources
  当前函数或调用者直接持有，并在调用链中作为 frame 保留、更新或返回
  的资源；

Glob resources
  由全局 invariant、临界区、IRQ 或 STS 协议维护的资源。
```

正式 Spec 仍然使用项目实际存在的 `OutsideCritical`、
`InsideCritical`、`RTrans/GTrans`、`OS_inv` 或 module invariant，以及
具体的 object、container 和 buffer predicates。

对于一条进入和退出临界区的调用链，可以用下面的形状理解资源位置：

```text
Local * OutsideCritical(before)
  -> Local * InsideCritical(current) * GlobMemory(current)
  -> Local' * InsideCritical(current) * GlobMemory(after)
  -> Local' * OutsideCritical(after)
```

这里：

- Lock 使当前执行取得 Glob protocol 和 Glob memory，但不会把它们变成
  Local；
- Local resources 不需要写入 Lock/Unlock 自己的 Spec，而是通过 frame
  rule 跨调用保留；
- 临界区内的真实 C 操作可以把 `Local` 更新为 `Local'`；
- Unlock 前必须以 `after` 状态重建 Glob memory；
- Unlock 后不能继续单独持有已经归还协议的 Glob memory。

`sg`、`st_bef`、`st_lock`、`st_aft` 和 `RTrans/GTrans` 都只是逻辑值或
纯关系，不提供具体内存权限。

例如，现有 Task 验证定义在取得任务临界区后使用：

```coq
TaskInsideCritical sg st_lock **
crtos_inv sg st_lock
```

共享 C 操作完成后，必须按允许的新状态重新建立：

```coq
TaskInsideCritical sg st_lock **
crtos_inv sg st_aft
```

随后 Unlock 消费 `crtos_inv sg st_aft` 并交回 Glob 协议，外层函数只保留
`TaskOutsideCritical sg st_aft` 和真实 caller-owned Local resources。现有 Task 验证定义
没有把 `KTaskCreate` 创建期间的全部 private remainder 作为公共接口；
因此本指南不为这些中间资源虚构名称。验证目标若发生类似的部分发布，应根据
目标对象的真实字段和 ownership 转移定义自己的 Local whole/remainder 与按操作命名的发布状态。

Lock 后当前执行取得 Glob protocol 和 Glob memory，但它们不会因此变成 Local，因为 Unlock 前必须以允许的新状态
重建并归还。Lock/Unlock 自己的函数 Spec 不必列出外层调用者的 Local resources；这些资源由 frame rule 跨调用保留。
`sg`、`st_bef`、`st_lock`、`st_aft` 和 `RTrans/GTrans` 都只是逻辑值或纯关系，不提供内存权限。若临界区内还发生
allocation、free 或 container membership 变化，应使用已有 object/container predicates 描述相应的 Local frame
变化，不为此另建通用的 `Local` 或 `Glob` 定义。

## 3. 写每个函数的 Spec

### 3.1 Spec 与注解位置

每个真实 C 函数有唯一 canonical 文件和一份 active 函数体，可以包含原有具名 specs 及按 [工程配置指南](project-configuration-guide.md#已有-spec-的复用与特化)新增的特化 spec。`Require` 写调用前必须持有的具体资源和事实，`Ensure` 按真实
成功、失败、阻塞或早返回路径写返回值、状态变化、资源转移与 frame。外层函数证明调用
其他函数时，只使用这些函数已经写好并最终证明的 spec，不展开它们的实现。

先引用当前 predicate revision 的 crtOS `LastSeen`、目标函数 atomic command、read/update 和 crtOS 自己的临界区定义，在 annotated C 的函数定义上直接写 With/Require/Ensure。Rocq library 只提供这些注解引用的共享语义组件，不保存整份函数 contract。若这些接口不足，predicate 仍为 draft 时直接返回 `slice-design` 修正；修改已批准接口时才提交 slice change request。不在 spec 阶段另写一套。

### 3.2 函数 Spec 的直接可审阅性

可以用具名抽象操作表达函数行为，用对象或模块 predicate 表达资源，用辅助关系表达相关逻辑条件；
这些定义即使只使用一次也可以保留。函数的 `Require/Ensure` 应直接组合它们，让 reviewer 在注解中
看到调用条件、返回结果分支和资源交接。定义的职责与写法见
[Predicate 指南第 6.3 节](predicate-lemma-design-guide.md#63-封装-predicate)。

为函数定义抽象 atomic 操作是合理的：可以用 program 表达函数的返回结果和抽象状态变化，再由
`safeExec` 引用。这里禁止的是把这个 `safeExec` 连同参数条件、临界区资源、调用者资源等全部
入口要求一起放进一个 `pre`，再把返回分支和全部出口保证放进一个 `post`，让注解只剩
`Require pre(...)` 和 `Ensure post(...)`。Atomic 操作单独定义，其他条件与资源在注解中显式组合。

对于采用 `safeExec` 和 atomic command 的接口，old/new 与操作效果可以由具名、定义清楚的抽象
`program` 表达，不要求在 `Ensure` 中重复展开同一套状态更新。注解仍须显式展示 C 返回值与抽象结果的
对应、各结果分支、continuation 和资源交接；审阅时同时检查所引用的 program。具体分工见第 4 节。

避免在 spec 与其引用的 predicate、效果关系中重复编码同一入口条件。例如，Require 已说明目标
信号量存在、其 pending 等于 waiting，且 list 是该 pending 的链表头；空队列不执行任何更新时，
效果关系可直接写 `after = before`，不必再次查找信号量并要求其 pending 为空。简化须在已声明的
合法前态下保持语义，并检查该定义的其他使用处；不能把更新后的关联或必须返还的内存资源也当作重复项删去。


### 3.3 保持函数层次的抽象边界

Canonical contract 还必须保持函数层次的抽象边界。模块和容器函数使用 reviewed predicate、abstract
state 和按动作命名的 transition，不把 manager 字段、bitmap bytes、数组元素或链表指针作为 API
沿调用链逐层传递。只有语义本身就是具体 memory shape 的底层内存原语，canonical contract 才可
直接暴露最小 shape，且应优先用透明、按结构命名的 predicate 表达。函数体访问具体字段时的资源
展开与恢复统一见 [第 3.4 节](#34-predicate-的展开更新与恢复)。

这种封装的目的不是把内存变化藏掉，而是把相关字段组合成模块的真实状态。例如 semaphore create
可以分别描述“刚分配”“已经清零”“ID 已登记但尚未发布”“已经发布”等状态；具体名称由项目风格和
源码决定，不要求统一前缀。Callee 的 spec 只需说明它把哪个状态变成哪个状态，caller 就能直接使用
这个结果继续调用下一个函数。Reviewer 也能从 contract 看出函数完成了哪一步，而不必先理解 manager
字段、bitmap bytes 和链表指针的全部表示细节。

Task 模块的 `OutsideCritical -> InsideCritical + invariant -> OutsideCritical` 展示了这种“按协议状态组织
资源”的思路。其他模块可以借鉴命名状态、明确 ownership 转移和让 caller 组合 contract 的方法，但不能
照搬 Task 的状态或临界区协议。例如 semaphore 的真实 C 如果没有相同的进入/退出路径，就应根据自己的
lock、IRQ、生命周期和调用关系定义状态，只复用抽象方法，不虚构不存在的控制流或资源转换。

### 3.4 Predicate 的展开、更新与恢复

Spec 使用抽象 predicate，不妨碍函数体访问具体内存。裸 `store` 等表示层资源保留在 predicate
定义及实现证明的局部 view 中；通过拆分引理取得当前读写所需的字段、节点或容器资源，访问完成后
再恢复相应 predicate。不要仅因 C 读取链表指针或写入字段，就把 canonical spec 改成字段级接口。
锁 token、纯状态或成员关系本身不提供这些内存权限；资源必须来自实际持有的 predicate。

展开时只借出当前操作需要的部分，其余资源由明确的 frame 或归还关系保留，不盲目展开整个
`os_inv`。借出的资源不能同时留在完整 predicate 中重复拥有。可复用的表示层拆分、读写权限提取
和重组，优先通过 QCP strategy 应用相应引理；依赖具体控制流、难以安全匹配的局部推理可保留
`which implies`，状态转换及一致性推理由 Rocq 引理支撑。Strategy 是这些资源关系的自动应用机制，
其生成的正确性义务仍须证明，不能用规则匹配成功代替证明。可以参考vrtos中strategy写法。

只读访问在原资源归还后通常可恢复原 predicate；写入后必须更新抽象状态，并建立与新状态对应的
predicate。若其他模块的 predicate 引用了被更新的 task map 等共享抽象状态，即使没有写入它们的
内存，也要证明这些关联在新状态下仍成立。不能将新局部资源与任意旧 frame 拼接后直接 fold 成
新 `os_inv`。复杂更新可用 restore 关系记录“交回什么局部后态才能恢复哪个整体后态”；使用分离
蕴含 `-*` 时，该归还关系属于空间资源，不能当作可任意复制的纯事实。

函数体中间步骤可以暂时不满足完整 invariant，用局部 view 或生命周期中间态描述实际资源即可。
在调用要求完整 invariant 的 callee 前、返回承诺完整 invariant 的函数时，以及协议要求归还
invariant 的交接点，必须恢复相应状态的 invariant。对于创建和删除，恢复还包含 ownership 转移：
新发布对象并入 invariant，已撤销登记的对象由局部 predicate 接管，不能同时归全局和调用者所有。

### 3.5 Predicate 接口不足时的处理

验证闭包在 `write-spec` 中确定，因此展开新的可达函数时可能发现 predicate 层缺少对象表示、局部
ownership view、更新后的恢复接口或创建/删除过程的中间状态。遇到这种情况应暂停当前 spec，退回
`slice-design` 补齐相应 predicate 和引理接口，再继续写 spec；不得把缺失抽象改写成一串裸 `store`。如果被修改的 predicate
revision 已经 `review-passed`，将其标记为 `invalidated`，固定新 revision 并重新完成 predicate review，
之后才能进入 spec review。

## 4. 临界区调用链中的函数 Spec

对于涉及进出临界区的调用链，可以按下面五个位置理解各函数的 spec。不使用临界区的函数只采用适用的状态与抽象操作表达。

进入临界区、完成共享状态操作并退出的函数，应使用抽象 `program` 表达操作的返回结果和状态变化，
通过 `safeExec` 接入函数 spec。Program 在 predicate 设计阶段定义或复用；Lock/Unlock 原语及
临界区内辅助函数的 spec 分别见下文，不要求它们各自建立 program。设计要求见
[Predicate 指南第 4 节](predicate-lemma-design-guide.md#4-为临界区操作定义抽象-program)。
例如查询操作可以用 `abs_get_task_with_idnode_locked` 表达命中或未命中及状态保持，用外层
`abs_get_task_with_idnode` 接入环境转换协议；创建操作则在自己的 program 中表达成功发布对象、
初始化值、返回 ID 和失败时的状态变化。操作本身的效果与环境允许的变化应分别定义。

`Require/Ensure` 通过 `safeExec` 连接这些操作语义，同时直接列出调用条件、返回结果与资源。
只有当 program、总状态提升或协议已经完整表达相应保证时，才省去重复的 effect；不能为了缩短
contract 丢掉未修改模块的保持或 caller-owned 资源。下面以查询接口示意外层写法，正式定义和
返回码仍以目标项目为准。

### 4.1 外层函数开始执行

这是外层函数 spec 的 `Require`：

```text
With (sg : StableGlobalState)
     (st_bef : VarGlobalState)
     X
Require
  id < 65536 &&
  safeExec(LastSeen(st_bef), abs_get_task_with_idnode(sg, id), X) &&
  OutsideCritical(sg, st_bef)
```

如果该函数没有 atomic command，只保留它实际需要的 `OutsideCritical` 和 caller-owned 资源。

### 4.2 调用 Lock 函数

Lock 是一个独立 C 函数，有自己的 spec：

```text
With (sg : StableGlobalState)
     (st_bef : VarGlobalState)
Require
  OutsideCritical(sg, st_bef)
Ensure
  exists (st_lock : VarGlobalState),
    RTrans(st_bef, st_lock) &&
    InsideCritical(sg, st_lock) *
    OS_inv(sg, st_lock)
```

### 4.3 在临界区内更新

临界区内函数入口能提供、出口能恢复 `os_inv` 时，可以在 `Require/Ensure` 中使用它；否则用局部
predicate 描述相应资源和状态变化。例如，若 `os_inv` 要求 READY 任务位于 ready 队列，先摘链、
再改为 RUNNING 的中间步骤就可能暂时不满足该一致性条件，应使用能描述摘链后资源的局部 view。

不要求临界区内每条语句之后都恢复 `os_inv`，但恢复时机也不只由加锁、解锁决定：调用要求
`os_inv` 的 callee 前和返回承诺 `os_inv` 的函数时同样必须恢复。局部展开、strategy 与更新后恢复
的具体分工见 [第 3.4 节](#34-predicate-的展开更新与恢复)；锁操作的资源交接按第 4.2、4.4 节处理。

不进行临界区资源交接的辅助函数，其 `InsideCritical` 可由 caller 通过 frame rule 保留，不必写入 spec。

临界区内批量操作的 spec 及其效果关系优先直接描述 `before`、`after` 的整体结果，不因 C 使用循环，
就把接口写成逐个摘链、逐步转移的递归或 `Inductive` 关系。例如唤醒整条 pending，应描述等待链
清空、任务状态改变、延时取消、就绪队列更新及其余状态保持。

### 4.4 调用 Unlock 函数

Unlock 也是一个独立 C 函数，有自己的 spec：

```text
With (sg : StableGlobalState)
     (st_lock st_aft : VarGlobalState)
Require
  GTrans(st_lock, st_aft) &&
  InsideCritical(sg, st_lock) *
  OS_inv(sg, st_aft)
Ensure
  OutsideCritical(sg, st_aft)
```

恢复中断只恢复进入临界区前保存的中断开关状态，不会把 task、scheduler 等共享状态从 `new` 改回 `old`。

### 4.5 外层函数返回

这是外层函数 spec 的 `Ensure`：

```text
(exists (st_aft : VarGlobalState),
  __return == KNONE &&
  safeExec(LastSeen(st_aft), return(None), X) &&
  OutsideCritical(sg, st_aft))
||
(exists (st_aft : VarGlobalState),
  safeExec(LastSeen(st_aft), return(Some(__return)), X) &&
  OutsideCritical(sg, st_aft))
```

这里 `None/Some` 是抽象结果，`KNONE` 是 C 层未命中的返回值；成功结果的合法地址条件应由抽象
操作保证。创建 API 应按自己的返回类型和错误码写成功、失败分支，不必改用 `option`。
同一个 `X` 从入口传到出口，操作的状态变化由入口指定的 program 与出口 continuation 连接，
不再额外重复一份 `function_effect`。查询 program 中的状态保持只约束本次查询操作，不能据此
断言外层入口 `st_bef` 与出口 `st_aft` 相等，因为协议可能允许环境转换。

若某项保证尚未被抽象操作或协议表达，应先补齐相应接口，或在 contract 中保留明确的约束。
例如仅作用于 semaphore module state 的 program，不自动保证 task、scheduler 等其他模块在本次
操作中保持不变；应由总状态提升或适用的协议表达。Caller-owned 资源仍须显式组合和返还。
没有 abstract-command 层的函数，则直接写其效果关系与资源变化。

第 4.1 项和第 4.5 项合起来是外层函数的一个 spec；第 4.2 项是 Lock 的 spec；第 4.3 项中的每个辅助函数有自己的 spec；
第 4.4 项是 Unlock 的 spec。

不是所有函数都有这五个位置。只按照真实源码选择实际出现的部分：

- 只负责 Lock 的函数只有第 4.2 项；
- 已经在临界区内调用的辅助函数只有第 4.3 项；
- 只负责 Unlock 的函数只有第 4.4 项；
- 自己完成 Lock、更新和 Unlock 的外层函数会经历完整流程；
- 不使用临界区的函数不套这五步，只根据自己的参数、内存读写、atomic command 和返回值写 spec。

## 5. 覆盖所有结果路径

对每条成功、失败、阻塞和早返回路径写明：

- C return/buffer 对应的 abstract result；
- 目标 module 的 new state 与未修改 module 的保持；
- caller resources 和项目协议资源是否恢复；
- 合法前态至少存在一个 transition，避免 partial-correctness 真空成立。

读取型 API 同样需要 load ownership，但 abstract state 可以保持不变。初始化函数从 initialization ownership
建立 `OS_inv(initial)`，不能假装入口已有运行时 invariant。

## 6. Spec 审阅

从以下方面检查，根据目标代码选择适用的具体情形，不要求逐项写检查结论。验证范围、资源与行为一致性、产物完整性仍须保证，影响正确性的未解决问题不能留到 proof 阶段。

1. 检查验证范围。
   从适配后的目标函数重新扫描当前配置下保留的调用、dispatch 和宏处理结果。模型/API 边界核对
   《源代码处理》的适用规则、contract 及结论限制，不要求递归被替换部分的原始内部调用。
   `reused-spec` 边界核对原 spec 的来源、revision、导入适配及 caller-local contract 一致性，不要求重证函数体。
   对其余未被用户批准为 `trusted` 的可达函数，`annotated_C/src/` 中必须有且只有一个以该函数命名的 `.c` 文件；
   该文件包含该函数的一份真实完整定义和 canonical `With/Require/Ensure`。
   除文档规定且适用的适配外，切片提取和调用归一不能改变原 C 的控制流、返回值或副作用；
   caller 中声明的 callee spec 必须与 canonical 文件中所选同名 spec 或采用的模型/API contract 一致。复用的原 contract 保持语义；新增特化须检查原 spec 到特化的推导、调用点前提的依据及资源重组，不能把未证明的特化当成已验证保证。

   将每个切片与当前配置下对应的原始 C 函数核对，包括函数体、实际生效的宏和调用目标，以及用到的类型、字段布局和全局对象声明。只比较函数体文本不足以确认一致性；普通等价转换说明为何不改变行为，按《源代码处理》采用的抽象转换说明规则依据、适用条件和结论限制。审阅记录注明原源码、配置和切片版本，保留足以比较后续变化的依据。QCP 检查提交给它的 C，不能替代切片与原源码的核对。

2. 检查 spec 的两部分。

   - 内存与 ownership：`Require` 拥有 C 执行所需的全部内存，并给出足够的地址和下标条件；`Ensure`
     描述实际写入后的内存，原样返还未修改的资源。函数使用 lock、IRQ 或 shared invariant 时，按项目
     已有协议取得和归还相关资源。
   - 函数行为：成功、失败、阻塞和早返回各路径的进入条件、返回值、abstract state 和 effect 都与真实
     C 一致，既不遗漏实现行为，也不承诺实现没有保证的结果。

   所有 spec 固定使用同一个 review-passed predicate revision。

3. 检查产物完整性。
   Rocq predicate 文件必须能够 compile/typecheck。Annotated C 必须完成验证范围、一函数一文件、真实
   函数体、callee spec 一致性和源码等价性检查。本阶段不运行 QCP parser/symbolic 或 closure script，
   不生成 VC，也不开始 proof。

4. 给出审阅结论。
   适用检查通过且没有影响正确性的未解决问题时，将该 spec 版本标为 `review-passed`；需要修复时标为 `needs-fix`。

审阅记录注明被审阅的文件和版本、结论，以及发现的问题和对应位置。写法见 [验证记录指南](reporting-guide.md#审阅报告)，审阅与复查规则见主 skill 的 [`review` 部分](../SKILL.md#review)。Predicate 和 spec 均通过审阅后，请用户确认对应版本。
