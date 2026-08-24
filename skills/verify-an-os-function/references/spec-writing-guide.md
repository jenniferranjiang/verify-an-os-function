# Spec 编写指南

本指南服务 `write-spec`。主 skill 已确认权威源码/config、目标模块与依赖、lock/IRQ/atomicity、abstract-command
协议和可信边界；review-passed predicate revision
提供总状态、module state、局部读取/更新函数、predicate、lemma、crtOS `LastSeen`、目标函数的 atomic command 和适用的
crtOS 临界区定义；本阶段引用 review-passed 的共享 Rocq state、predicate、effect relation 和 lemma，把函数的正式 pre/post 唯一地写入对应 annotated C 的 With/Require/Ensure。Markdown 和手写 .v 均不得复制函数 contract 正文。Markdown 只可记录路径、symbol、C 证据、返回路径和审阅状态，不承载 spec 正文。Spec review 与 predicate review
分开；发现 predicate 缺陷时使其 review 失效并返回 `slice-design`，predicate 再次通过后只重审受影响的 spec closure。

Spec 是验证前写出的正式目标，不是验证结果：它规定函数的 pre/post、返回或非终止路径、abstract effect、
具体内存 ownership 与值/结构的前后态、ownership 转移以及 frame；后续 proof 才证明 C 实现满足该 spec。
写完或批准 spec 都不能称为“函数已验证”。

## 目录

1. [先固定模型和函数层次](#1-先固定模型和函数层次)
2. [确定参数和 effect](#2-确定参数和-effect)
3. [写每个函数的 Spec](#3-写每个函数的-spec)
4. [覆盖所有结果路径](#4-覆盖所有结果路径)
5. [交给 Proof 前检查](#5-交给-proof-前检查)

## 1. 先固定模型和函数层次

读取目标函数、直接 callee、全部 return path、项目现有 module/function libraries、annotated C imports 和
`Extern Coq`。先确定项目实际使用的 Rocq definition 与 C 中的 `With/Require/Ensure` 应写在哪个文件；不要仅为当前工作流阶段新建
`*_specs.v`，LOS 风格项目优先使用 `VC/code_proof/<module>/<function>.v`。然后按已确认的验证上下文和项目实际
协议组织 spec。目标函数自己进入/退出临界区，或依靠临界区取得共享 invariant 时，spec 应明确写出临界区外和
临界区内。直接引用当前 slice 的 crtOS 临界区定义；若尚未建立或 state/transition 不足，返回
`slice-design` 在同一草案中补齐。只有修改已经批准的接口时才提交 breaking change request。Spec writer 不另写一套
临界区模型，也不要改写成
`entry_resource`、`held_resource` 等含糊名称或另建自定义 token Record。

只有已批准 protocol 允许等待 lock 时环境推进状态，才区分 `old/current`；顺序或中断屏蔽语义若保证无环境并发更新，
不应机械引入两个状态。

不要先给函数填写层级表或贴 L0–L3 标签。直接建立 direct-callee dependency graph：目标函数缺少 callee spec 时，
先写 callee；callee 还有依赖就继续向下，直到当前没有未处理依赖的 leaf。完成 leaf 的 spec 后逐层回到 caller。

实际项目常见的推进方向是：通用 link/array/bitmap 等局部操作，接着是对象或业务容器操作，再到同时维护多个
对象、容器和 globals 一致性的模块操作，最后到包含参数/返回码、critical/IRQ 和 caller resources 的最外层 API。
这只是依赖关系的常见形状，不是必须补齐的分类；源码中没有某一层就直接跳过，也不要为了形成层级虚构 wrapper。

初始化函数同样按它自己的 direct callees 自底向上处理。它从未初始化内存和 initialization ownership 建立第一个
稳定 invariant；在声称系统完成初始化或证明依赖初始 invariant 的顶层结论前完成相应 Init proof。

对调用依赖图按 leaf 到 wrapper 分别写 spec。上层 spec 可以引用下层已经冻结的 spec 接口来表达调用边界，
但要在依赖列表中把下层标成 `spec-approved/proof-pending`；只有后续证明完成后，caller proof 才能把它作为
已验证调用规则。没有 callee spec 时先写 callee spec，不把 callee 实现内联进 caller spec。

对进入当前验证闭包的每个函数，分别建立一个 annotated C 文件。文件必须包含当前配置下的真实函数定义和完整函数体，并把 With/Require/Ensure 直接写在该定义上。对纳入验证范围的真实 C 函数，annotated C 必须保留当前配置下的完整函数定义和可执行函数体。未经用户批准为 trusted/external boundary，不得用 declaration-only、空函数或伪实现替代。

宏不要求一律手工展开。影响当前配置控制流、返回路径、内存访问、锁或 IRQ 行为的宏，必须由可信预处理器精确展开，或保留宏并检查预处理结果；不得用语义较弱的手写代码替代。

LOS 文件只提供函数 spec 的写法示例。可以复用的是 QCP 的通用 `critical_STS/CriticalCSL`，不是 LOS 的
`Los_CS_C`、`Los_Verify_State` 或 transition；crtOS 使用自己的状态和允许转换。

## 2. 确定参数和 effect

- `sg`：稳定地址、大小、ID 和 config；不因量化 `sg` 自动获得内存权限。参考
  [glob_vars_and_defs.v](doc/glob_vars_and_defs.v)。
- `st_bef/st_lock/st_aft`：只在已经通过审阅的并发规则确实区分函数入口、取得锁和修改完成这几个时刻时使用；
  否则只保留当前函数真正需要的状态参数。
- module state：引用 review-passed slice 的 module-state 读取函数与 `replace_*S` 局部更新函数，只实例化允许改变的模块。参考
  [Los_Verify_State_def.v](doc/Los_Verify_State_def.v)。
- `atomic_api(args)`：成功、失败、返回值和允许的状态变化；不得授权未涉及模块变化。
- `args/ret`：明确 C handle、错误码、buffer 与抽象值的对应。
- caller resources：输入/输出 pointer、私有对象和 buffer 单独列出并在出口返还。

Stable/Mutable 是否拆分由 review-passed predicate revision 决定，本阶段不重新设计。若已拆分，同一个 `sg` 从
`Require` 传到 `Ensure`，Mutable state 再按真实协议使用 `st_bef`、`st_lock`、`st_aft`；若采用 combined state，
则使用 predicate 阶段已批准的 stable-projection 保持关系。

每个 C load/store 必须由 review-passed slice 的 `data_at`、object/module predicate 或 `OS_inv` 支持；抽象 state
本身不提供访问权限。函数 spec 还必须表达 load 所需的前态值、store 产生的新值或结构，以及 write footprint
之外保持不变的 frame。

### 2.1 Stable/Mutable 在 Spec 中的使用

Stable/Mutable 如何划分已经由通过审阅的 predicate 决定，Spec 阶段不再重新划分。对于初始化完成后正常运行的函数，如果状态已经拆成 `sg : StableGlobalState` 和 `st : CrtosGlobalState`，应在函数前后复用同一个 `sg`，用不同的 `st` 表示共享内容的变化。不要因为目标函数没有修改某个字段，就在 Spec 阶段临时把它移入 `sg`；也不要为了套用统一格式，让每个函数都同时携带 `st_bef`、`st_lock` 和 `st_aft`。只有实际执行过程确实区分函数入口、取得锁和修改完成这几个时刻，才需要这些状态参数。

例如，`KTaskCreate` 的外层 Spec 可以采用下面的形式：

```c
/*@ With (sg : StableGlobalState)
         (st_bef : CrtosGlobalState)
         (...)
    Require
      caller_resources *
      TaskOutsideCritical(sg, st_bef)
    Ensure
      exists (st_aft : CrtosGlobalState)
             (task : addr),
        result_relation(__return, task) &&
        ktask_create_success(
          sg, st_bef, st_aft, task, __return) &&
        returned_caller_resources *
        TaskOutsideCritical(sg, st_aft)
 */
```

这里前后使用同一个 `sg`，表示 ID manager、task-head、`Done` 等全局对象的地址和固定配置仍然使用同一组逻辑值；`st_bef` 表示函数入口记录的可变共享内容，`st_aft` 表示函数返回时的可变共享内容。`ktask_create_success` 进一步说明 ID manager 和任务链表具体发生了什么变化，例如加入新分配的 ID、记录 `&(task->id)`，并把 `task->link` 插入任务链表。`TaskOutsideCritical(sg, st_aft)` 则说明函数返回时已经重新建立与新状态对应的共享资源，并退出临界区。

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

如果函数不使用锁，或者当前配置保证入口到执行期间共享状态不会被其他执行改变，就不必机械引入 `st_lock`。初始化、动态重配置或销毁重建函数可能建立或改变 Stable 部分，应按照已经通过审阅的 predicate 和函数接口单独编写 Spec。若使用一个总 state，则沿用 predicate 阶段已经确认的更新函数或保持条件，保证固定地址和固定配置不会被普通状态更新替换。

对，这样更顺：放在 `spec-writing-guide.md` 的第 2 节，紧接现有：

```markdown
### 2.1 Stable/Mutable 在 Spec 中的使用
```

新增：

```markdown
### 2.2 Local/Glob 在 Spec 中的使用
```

这样正好对应 `Three-State-Relation-Pairs.md` 中的两组关系：

```text
2.1 Stable/Mutable：状态前后是否变化
2.2 Local/Glob：Spec 中资源位于调用者侧还是全局协议侧
```

第 3 节再具体展开外层函数、Lock、临界区 helper、Unlock 和返回。

建议的 §2.2 如下，我现在先不改文件：

```markdown
### 2.2 Local/Glob 在 Spec 中的使用

Local/Glob 是帮助组织函数 Spec 中资源位置的说明性术语，不要求项目定义
名为 `Local` 或 `Glob` 的 Rocq predicate、state 或 relation。

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

例如

在 `KTaskCreate` 中，动态分配并清零的 `TaskDescriptor` 最初由当前调用
直接持有：

```coq
store_zeroed_task_descriptor task
```

这是发布前的 Local whole。进入任务临界区后，当前执行同时持有：

```coq
store_zeroed_task_descriptor task **
TaskInsideCritical sg st_lock **
store_task_shared sg st_lock
```

随后 `IdInsertObj` 把 `task->id` 发布到全局 ID manager，
`DoubleLinkListInsertNodeAfter` 把 `task->link` 发布到 task-head。完成这两项
发布后，在对应程序点可以理解为：

```coq
store_ktask_create_private_zeroed task **
TaskInsideCritical sg st_lock **
store_task_shared sg st_aft
```

这里 `store_ktask_create_private_zeroed` 只保留 descriptor 中没有发布的
Local remainder；`task->id` 和 `task->link` 已由更新后的
`store_task_shared sg st_aft` 唯一拥有。

成功返回时，调用者得到的 Local post 使用：

```coq
store_created_task_descriptor task id info sched sg
```

它明确不再拥有 `task->id` 和 `task->link`。Glob 一侧已经在 Unlock 时交回
全局协议，因此最终后置组合为：

```coq
store_created_task_descriptor task id info sched sg **
TaskOutsideCritical sg st_aft
```

而不是再额外加入：

```coq
store_task_shared sg st_aft
```

这个例子说明 Local/Glob 不是一对固定 predicate。它们表示 Spec 中的资源
责任边界；随着对象发布和函数执行，Local 一侧可以从 whole 变成 remainder
再变成最终 post，Glob 一侧则由 `OutsideCritical`、`InsideCritical` 和
共享内存 predicate 按临界区协议取得、更新并归还。

## 3. 写每个函数的 Spec

每个真实 C 函数分别写一个 spec。函数的 `Require` 是 precondition，`Ensure` 是 postcondition。外层函数证明调用
其他函数时，只使用这些函数已经写好并最终证明的 spec，不展开它们的实现。

先引用 review-passed slice 的 crtOS `LastSeen`、目标函数 atomic command、read/update 和 crtOS 自己的临界区定义，在 annotated C 的函数定义上直接写 With/Require/Ensure。Rocq library 只提供这些注解引用的共享语义组件，不保存完整函数 pre/post。若这些接口在 annotated C 中写 `With/Require/Ensure`
不足，提交 slice change request，不在 spec 阶段另写一套。

这里使用 Local/Glob 作为理解临界区 Spec 的说明性术语，不要求项目定义名为 `Local` 或 `Glob` 的 Rocq predicate、
state 或 relation。Local resources 是当前函数或调用者直接持有、在调用链中作为 frame 保留或返回的资源；Glob
resources 是由全局 invariant、临界区、IRQ 或 STS 协议维护的资源。正式 Spec 仍然使用项目实际定义的
`OutsideCritical`、`InsideCritical`、`RTrans/GTrans`、`OS_inv` 或 module invariant，以及具体的 caller-owned
object 和 buffer predicates。

一条外层临界区调用链中的资源位置可以概括为：

```text
LocalResources * OutsideCritical(sg, st_bef)
  -> LocalResources * InsideCritical(sg, st_lock) * OS_inv(sg, st_lock)
  -> LocalResources' * InsideCritical(sg, st_lock) * OS_inv(sg, st_aft)
  -> LocalResources' * OutsideCritical(sg, st_aft)
```

Lock 后当前执行取得 Glob protocol 和 Glob memory，但它们不会因此变成 Local，因为 Unlock 前必须以允许的新状态
重建并归还。Lock/Unlock 自己的函数 Spec 不必列出外层调用者的 Local resources；这些资源由 frame rule 跨调用保留。
`sg`、`st_bef`、`st_lock`、`st_aft` 和 `RTrans/GTrans` 都只是逻辑值或纯关系，不提供内存权限。若临界区内还发生
allocation、free 或 container membership 变化，应使用已有 object/container predicates 描述相应的 Local frame
变化，不为此另建通用的 `Local` 或 `Glob` 定义。

对于一条完整的临界区调用链，可以按下面五个位置理解各函数的 spec。

### 3.1 外层函数开始执行

这是外层函数 spec 的 `Require`：

```text
With (sg : StableGlobalState)
     (st_bef : CrtosGlobalState)
Require
  safeExec(LastSeen(st_bef), atomic_api(args), X) &&
  OutsideCritical(sg, st_bef)
```

如果该函数没有 atomic command，只保留它实际需要的 `OutsideCritical` 和 caller-owned 资源。

### 3.2 调用 Lock 函数

Lock 是一个独立 C 函数，有自己的 spec：

```text
With (sg : StableGlobalState)
     (st_bef : CrtosGlobalState)
Require
  OutsideCritical(sg, st_bef)
Ensure
  exists (st_lock : CrtosGlobalState),
    RTrans(st_bef, st_lock) &&
    InsideCritical(sg, st_lock) *
    OS_inv(sg, st_lock)
```

### 3.3 在临界区内更新

如果这里调用辅助函数，每个辅助函数也分别写自己的 spec：

```text
With (sg : StableGlobalState)
     (st_lock : CrtosGlobalState)
     (old_module new_module : ModuleState)
Require
  InsideCritical(sg, st_lock) *
  module_inv(sg, old_module)
Ensure
  InsideCritical(sg, st_lock) *
  module_inv(sg, new_module)
```

如果更新由外层函数自己的 C 语句完成，这里没有额外函数 spec，只是外层函数 proof 中的内存更新步骤。

### 3.4 调用 Unlock 函数

Unlock 也是一个独立 C 函数，有自己的 spec：

```text
With (sg : StableGlobalState)
     (st_lock st_aft : CrtosGlobalState)
Require
  GTrans(st_lock, st_aft) &&
  InsideCritical(sg, st_lock) *
  OS_inv(sg, st_aft)
Ensure
  OutsideCritical(sg, st_aft)
```

恢复中断只恢复进入临界区前保存的中断开关状态，不会把 task、scheduler 等共享状态从 `new` 改回 `old`。

### 3.5 外层函数返回

这是外层函数 spec 的 `Ensure`：

```text
exists (st_aft : CrtosGlobalState),
  safeExec(LastSeen(st_aft), return(ret), X) &&
  function_effect(sg, st_bef, st_aft, args, ret) &&
  OutsideCritical(sg, st_aft)
```

第 3.1 项和第 3.5 项合起来是外层函数的一个 spec；第 3.2 项是 Lock 的 spec；第 3.3 项中的每个辅助函数有自己的 spec；
第 3.4 项是 Unlock 的 spec。

不是所有函数都有这五个位置。只按照真实源码选择实际出现的部分：

- 只负责 Lock 的函数只有第 3.2 项；
- 已经在临界区内调用的辅助函数只有第 3.3 项；
- 只负责 Unlock 的函数只有第 3.4 项；
- 自己完成 Lock、更新和 Unlock 的外层函数会经历完整流程；
- 不使用临界区的函数不套这五步，只根据自己的参数、内存读写、atomic command 和返回值写 spec。

## 4. 覆盖所有结果路径

对每条成功、失败、阻塞和早返回路径写明：

- C return/buffer 对应的 abstract result；
- 目标 module 的 new state 与未修改 module 的保持；
- caller resources 和项目协议资源是否恢复；
- 合法前态至少存在一个 transition，避免 partial-correctness 真空成立。

读取型 API 同样需要 load ownership，但 abstract state 可以保持不变。初始化函数从 initialization ownership
建立 `OS_inv(initial)`，不能假装入口已有运行时 invariant。

## 5. 交给 Proof 前检查

- 函数层次、项目实际使用的 lock/IRQ/atomicity model 和 invariant 明确；
- 每个 load/store 有唯一 owner，pointer/index 条件充分；
- 每条路径的 load 前态、store 的 old/new 值或结构以及 write footprint 外的 frame 已明确；
- `replace_*S` 只改变获准 module，返回值匹配 abstract result；
- 只在项目协议授权时展开 shared invariant，restore/返回前已重建它要求的新 invariant 或 footprint；
- abstract-execution relation、rely/guarantee、opaque invariant 按项目真实定义使用，没有假设更强语义；
- 函数 spec 引用已确认的验证上下文和 review-passed predicate revision，并记录尚未完成的后续 proof obligation；
- 每个 direct callee 的状态明确区分 `spec-missing|spec-approved/implementation-proof-pending|spec-approved/implementation-proved`；不得把前两者写成 verified dependency；
- 每个 annotated C 文件写完后立即运行项目 parser，至少使用 symexec --no-coq-gen --no-exec-info 或等价检查。普通 cc -fsyntax-only 会忽略注解，不能作为 QCP spec 语法通过的证据。parser 失败与后续 symbolic-execution/ownership 失败必须分开记录。；
- [spec-review-template.md](../assets/spec-review-template.md) 已用普通话说明调用条件和结果，并列出每条 C 路径、effect、frame、formal file/symbol 和实际检查；没有复制 pre/post 或 `Require/Ensure` 正文；
- Review-ready 条件全部满足且没有影响路径/effect/ownership/frame/dependency 的已知 `[OPEN]` 后才开始 spec review；所有适用 pass 条件有证据、formal checks 通过且没有 blocker 后标为 `review-passed`；
- Spec revision 或依赖变化影响上一结论时做 delta；源码/config/scope、reviewed predicate 或 spec 语义使审阅依据失效时做 full；非语义文字变化不 review；
- Predicate 与 spec 分别 review-passed 后，再请求用户确认两份 revision。
