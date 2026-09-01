# Spec 编写指南

本指南服务 `write-spec`。主 skill 已确认权威源码/config、目标模块与依赖、lock/IRQ/atomicity、abstract-command
协议和用户批准的 `trusted` 函数。当前 predicate revision 提供总状态、module state、局部读取/更新函数、predicate、lemma、crtOS `LastSeen`、目标函数的 atomic command 和适用的
crtOS 临界区定义；函数的 canonical contract 写在其自身 annotated C 的函数定义上；caller
文件可以复制 direct-callee contract 作为 declaration-only API，但必须
与 canonical spec 一致。Markdown 和手写 .v 均不得复制函数 contract 正文。Markdown 只可记录路径、symbol、C 证据、返回路径和审阅状态，不承载 spec 正文。Spec review 与 predicate review
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
3. [写每个函数的 Spec](#3-写每个函数的-spec)
   - [3.1 一函数一 Spec 与注解位置](#31-一函数一-spec-与注解位置)
   - [3.2 函数 Spec 的直接可审阅性](#32-函数-spec-的直接可审阅性)
   - [3.3 保持函数层次的抽象边界](#33-保持函数层次的抽象边界)
   - [3.4 Predicate 接口不足时的处理](#34-predicate-接口不足时的处理)
   - [3.5 Local/Glob 在 Contract 中的位置](#35-localglob-在-contract-中的位置)
4. [临界区调用链中的函数 Spec](#4-临界区调用链中的函数-spec)
5. [覆盖所有结果路径](#5-覆盖所有结果路径)
6. [进入 Spec Review 前检查](#6-进入-spec-review-前检查)

## 1. 先固定模型和函数层次

读取从目标函数递归得到的完整可达闭包、各函数的 direct callees、全部 return path、项目现有 module/function libraries、annotated C imports 和
`Extern Coq`。先确定项目实际使用的 Rocq definition 与 C 中的 `With/Require/Ensure` 应写在哪个文件；不要仅为当前工作流阶段新建
`*_specs.v`，LOS 风格项目优先使用 `VC/code_proof/<module>/<function>.v`。然后按已确认的验证上下文和项目实际
协议组织 spec。目标函数自己进入/退出临界区，或依靠临界区取得共享 invariant 时，spec 应明确写出临界区外和
临界区内。直接引用当前 slice 的 crtOS 临界区定义；若尚未建立或 state/transition 不足，返回
`slice-design` 在同一草案中补齐。只有修改已经批准的接口时才提交 breaking change request。Spec writer 不另写一套
临界区模型，也不要改写成
`entry_resource`、`held_resource` 等含糊名称或另建自定义 token Record。

只有已批准 protocol 允许等待 lock 时环境推进状态，才区分 `old/current`；顺序或中断屏蔽语义若保证无环境并发更新，
不应机械引入两个状态。

主 `SKILL.md` 给出唯一的验证闭包规则：从当前配置下的 target 出发，递归跟随直接调用、可唯一解析的
function pointer/done-table dispatch，以及 function-like 宏展开后产生的真实调用。除用户批准的
`trusted` 函数外，所有可达函数都继续递归并按本节建立 annotated C。Main agent 可以建议把复杂
callee 作为 `trusted`，但不能代替用户决定。批准的 symbol 和 contract 记录在当前任务
上下文或报告中，不写入本通用 guide。无法唯一解析的调用保持 `[OPEN]` 并阻塞 review。dispatch 和宏
归一必须绑定 table initializer、macro definition、配置分支或赋值点证据，且保持 body、路径和副作用。

实际项目常见的推进方向是：通用 link/array/bitmap 等局部操作，接着是对象或业务容器操作，再到同时维护多个
对象、容器和 globals 一致性的模块操作，最后到包含参数/返回码、critical/IRQ 和 caller resources 的最外层 API。
这只是依赖关系的常见形状，不是必须补齐的分类；源码中没有某一层就直接跳过，也不要为了形成层级虚构 wrapper。

每个 canonical 文件先声明当前函数的 direct callees 并附完整 declaration-only
`With/Require/Ensure`，随后保存当前函数自己的 canonical spec、真实定义和 active 函数体。

写完文件后按主 skill 的闭包门禁重新从 target 扫描 body calls、dispatch 和宏展开结果。
Function-like 宏产生的真实调用继续进入闭包；空宏、常量、`sizeof` 和纯类型/布局宏不产生函数；
宏产生的可执行语句在 caller 中作等价归一。只给真实 C symbol 建 canonical 文件，不为宏虚构函数。
正文不允许出现没有完整 formal API 的真实调用。

修改 callee canonical spec 时，其全部 caller API 副本失效，必须同步更新并
重新检查受影响的 dependency closure。

LOS 文件只提供函数 spec 的写法示例。可以复用的是 QCP 的通用 `critical_STS/CriticalCSL`，不是 LOS 的
`Los_CS_C`、`Los_Verify_State` 或 transition；crtOS 使用自己的状态和允许转换。

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

例如，当前 Task lib 在取得任务临界区后使用：

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
`TaskOutsideCritical sg st_aft` 和真实 caller-owned Local resources。当前正式
Task lib 没有把 `KTaskCreate` 创建期间的全部 private remainder 作为公共接口；
因此本指南不为这些中间资源虚构名称。验证目标若发生类似的部分发布，应根据
目标对象的真实字段和 ownership 转移定义自己的 Local whole/remainder 与按操作命名的发布状态。

Lock 后当前执行取得 Glob protocol 和 Glob memory，但它们不会因此变成 Local，因为 Unlock 前必须以允许的新状态
重建并归还。Lock/Unlock 自己的函数 Spec 不必列出外层调用者的 Local resources；这些资源由 frame rule 跨调用保留。
`sg`、`st_bef`、`st_lock`、`st_aft` 和 `RTrans/GTrans` 都只是逻辑值或纯关系，不提供内存权限。若临界区内还发生
allocation、free 或 container membership 变化，应使用已有 object/container predicates 描述相应的 Local frame
变化，不为此另建通用的 `Local` 或 `Glob` 定义。

## 3. 写每个函数的 Spec

### 3.1 Spec 与注解位置

每个真实 C 函数分别写一个 spec。`Require` 写调用前必须持有的具体资源和事实，`Ensure` 按真实
成功、失败、阻塞或早返回路径写返回值、状态变化、资源转移与 frame。外层函数证明调用
其他函数时，只使用这些函数已经写好并最终证明的 spec，不展开它们的实现。

先引用当前 predicate revision 的 crtOS `LastSeen`、目标函数 atomic command、read/update 和 crtOS 自己的临界区定义，在 annotated C 的函数定义上直接写 With/Require/Ensure。Rocq library 只提供这些注解引用的共享语义组件，不保存整份函数 contract。若这些接口不足，predicate 仍为 draft 时直接返回 `slice-design` 修正；修改已批准接口时才提交 slice change request。不在 spec 阶段另写一套。

### 3.2 函数 Spec 的直接可审阅性

函数 spec 必须让 reviewer 在当前函数注解中直接看到真实义务。不得把整个入口资源或所有出口效果
包装进仅名为 `pre`、`post`、`*_pre`、`*_post` 或 `*_spec` 的 predicate/relation，再让
`Require/Ensure` 只引用这个不透明名字。共享 predicate/relation 的命名、语义边界和复用条件按 predicate 设计指南执行。

`Require/Ensure` 仍须直接组合关键 object/module/critical predicates，并显式写出各路径返回值、
old/new、ownership transfer 和 frame，不能让 helper 抹平成功与失败路径。QCP 的
`With/Require/Ensure` 语法仍然保留；这里禁止的是含糊的语义封装，不是这三个语法关键字。

### 3.3 保持函数层次的抽象边界

Canonical contract 还必须保持函数层次的抽象边界。模块和容器函数使用 reviewed predicate、abstract
state 和按动作命名的 transition，不把 manager 字段、bitmap bytes、数组元素或链表指针作为 API
沿调用链逐层传递。裸 `store` 属于表示层：通常只出现在 Rocq predicate 定义和函数体中为实际字段
读写服务的局部 `which implies`；只有语义本身就是具体 memory shape 的底层内存原语，canonical
contract 才可直接暴露最小 shape，且应优先用透明、按结构命名的 predicate 表达。

这种封装的目的不是把内存变化藏掉，而是把相关字段组合成模块的真实状态。例如 semaphore create
可以分别描述“刚分配”“已经清零”“ID 已登记但尚未发布”“已经发布”等状态；具体名称由项目风格和
源码决定，不要求统一前缀。Callee 的 spec 只需说明它把哪个状态变成哪个状态，caller 就能直接使用
这个结果继续调用下一个函数。Reviewer 也能从 contract 看出函数完成了哪一步，而不必先理解 manager
字段、bitmap bytes 和链表指针的全部表示细节。底层裸 `store` 仍保留在这些 predicate 的定义或函数体
局部展开中，因此内存 ownership 和实际写入仍然可追溯。

Task 模块的 `OutsideCritical -> InsideCritical + invariant -> OutsideCritical` 展示了这种“按协议状态组织
资源”的思路。其他模块可以借鉴命名状态、明确 ownership 转移和让 caller 组合 contract 的方法，但不能
照搬 Task 的状态或临界区协议。例如 semaphore 的真实 C 如果没有相同的进入/退出路径，就应根据自己的
lock、IRQ、生命周期和调用关系定义状态，只复用抽象方法，不虚构不存在的控制流或资源转换。

### 3.4 Predicate 接口不足时的处理

验证闭包在 `write-spec` 中确定，因此展开新的可达函数时可能发现 predicate 层缺少对象表示、局部
ownership view 或创建过程的中间状态。遇到这种情况应暂停当前 spec，退回 `slice-design` 增加按对象
或动作命名的 predicate，再继续写 spec；不得把缺失抽象改写成一串裸 `store`。如果被修改的 predicate
revision 已经 `review-passed`，将其标记为 `invalidated`，固定新 revision 并重新完成 predicate review，
之后才能进入 spec review。

## 4. 临界区调用链中的函数 Spec

对于一条完整的临界区调用链，可以按下面五个位置理解各函数的 spec。对于不需要临界区函数，可以借鉴关于globalstate，mutablestate等通用状态在spec中表现形式。

### 4.1 外层函数开始执行

这是外层函数 spec 的 `Require`：

```text
With (sg : StableGlobalState)
     (st_bef : VarGlobalState)
Require
  safeExec(LastSeen(st_bef), atomic_api(args), X) &&
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

如果这里调用辅助函数，每个辅助函数也分别写自己的 spec：

```text
With (sg : StableGlobalState)
     (st_lock : VarGlobalState)
     (old_module new_module : ModuleState)
Require
  InsideCritical(sg, st_lock) *
  module_inv(sg, old_module)
Ensure
  InsideCritical(sg, st_lock) *
  module_inv(sg, new_module)
```

如果更新由外层函数自己的 C 语句完成，这里没有额外函数 spec，只是外层函数 proof 中的内存更新步骤。

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
exists (st_aft : VarGlobalState),
  safeExec(LastSeen(st_aft), return(ret), X) &&
  function_effect(sg, st_bef, st_aft, args, ret) &&
  OutsideCritical(sg, st_aft)
```

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

## 6. 进入 Spec Review 前检查

按下面四步判断，不把未解决的问题留到 proof 阶段。

1. 检查验证范围。
   从目标函数重新扫描当前配置下的全部调用、dispatch 和宏展开结果。对于每个未被用户批准为
   `trusted` 的可达函数，`annotated_C/src/` 中必须有且只有一个以该函数命名的 `.c` 文件；该文件包含
   该函数的一份真实完整定义和 canonical `With/Require/Ensure`。切片提取和调用归一不能改变原 C 的
   控制流、返回值或副作用；caller 中声明的 callee spec 必须与 callee 的 canonical spec 一致。

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

4. 进入 review。
   只有以上检查全部成功且没有相关 `[OPEN]` 或 blocker，spec 才是 `review-ready`。使用
   [spec-review-template.md](../assets/spec-review-template.md) 记录 C 路径、effect、frame、正式文件和检查结果；
   review 次序和重审规则遵循主 skill 的 Review 生命周期。Predicate 与 spec 分别 `review-passed` 后，
   再请求用户确认两份 revision。
