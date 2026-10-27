# 根据 C 代码设计 Predicate 和 Lemma

本指南完成三件事：理解现有 C 实现、形成 Rocq predicate 草案，并按 predicate 自己的条件完成独立审阅。Spec 另行编写和审阅；QCP implement 在两者 review-passed 且用户确认 revisions 后统一交给 QCP verification-orchestrator。

本指南按设计问题分节，不要求每一节对应一个 `.v` 文件。文件按主 skill 的 [文件组织与存放](../SKILL.md#文件组织与存放)安排：各模块维护自己的状态与内存表示，全局状态和系统不变量导入并组合模块定义；按依赖需要分离模块纯状态与 store 谓词，避免循环依赖。具体函数的抽象操作与 `program` 可放在该函数的文件中，跨模块共享内容沿用共享库。

## 目录

1. [确认源码与范围](#1-确认源码与范围)
2. [为 C 对象定义抽象状态](#2-为-c-对象定义抽象状态)
3. [组织 Predicate 使用的逻辑状态](#3-组织-predicate-使用的逻辑状态)
4. [为临界区操作定义抽象 program](#4-为临界区操作定义抽象-program)
5. [为临界区定义状态关系](#5-为临界区定义状态关系)
6. [定义具体内存 Predicate](#6-定义具体内存-predicate)
7. [根据真实 C 操作定义 Lemma](#7-根据真实-c-操作定义-lemma)
8. [检查 Validity、初始化与生命周期](#8-检查-validity初始化与生命周期)
9. [为正式定义编写注释](#9-为正式定义编写注释)
10. [检查并审阅 Predicates](#10-检查并审阅-predicates)

## 1. 确认源码与范围

本节由 C analysis agent 执行，Main agent 负责委派；后续 predicate 设计沿用其分析结果，不重复开展同一轮源码分析。

C analysis agent 从用户指定的目标模块出发，确定当前配置下属于该模块的源码与函数集合，读取全部实现函数，以及相关类型、全局对象和条件编译分支。结合初始化、查询、修改、删除和回收代码，查明这些函数实际访问哪些 C 对象，以及对象怎样建立和变化。

对模块中的函数分别记录控制流和返回路径、内存读写、访问的指针与字段、函数调用、副作用、循环不变式及必要假设。

为了理解模块资源的跨模块使用，还应读取必要的外部调用者或被调用者。这些上下文函数不因此归入目标模块，也不要求目标模块 predicate 拥有其他模块的内部资源。

新增定义前，先搜索项目已有的 state、predicate、lemma 和 spec。所有设计以目标项目的 C 源码和配置为依据，
不要只根据类型名、函数名或参考项目猜测。

## 2. 为 C 对象定义抽象状态

本指南中的“C 对象”指 C 代码实际操作的数据，例如一个 struct 实例、全局变量或数组。本节讨论一个 C 对象在
Rocq 中需要怎样的 abstract state、是否需要另一个 concrete state，以及这些逻辑状态怎样对应到该 C 对象的内存。

### 2.1 先确定要表示哪个 C 对象

例如目标函数操作：

```c
struct TaskDescriptor *task;
```

那么先确定：当前要为 `TaskDescriptor` 这个 C 对象设计 Rocq 抽象状态和内存 predicate。如果目标函数还操作
ready queue、ID manager，就分别确定对应的 C 对象。不要一开始就讨论 `Record`、`Inductive` 或 map。

### 2.2 读取这个 C 对象相关的代码

不只读取 C 对象的类型定义，还要查明：

- 它在哪里初始化；
- 哪些函数读取它；
- 哪些函数修改它；
- 它怎样进入 ready、delay 等容器；
- 它怎样删除或回收；
- 是否存在 `memset`、`memcpy` 或整块赋值。

例如：

```text
CreateTask
  -> 初始化 task

StartupTask
  -> INIT 变成 READY

Scheduler
  -> READY 变成 RUNNING

DeleteTask
  -> 退出容器并回收
```

读完这些代码，才能判断 C 对象中的哪些值真正表示它的状态。

### 2.3 根据 C 对象的真实行为写抽象状态

对 C 对象中每项可能有意义的内容，检查三个问题：

1. 它变化后，函数返回、分支、合法性或以后允许的操作会不会改变？
2. 它是否需要跨函数调用保留？
3. 它能否由其他已经记录的内容推导？

根据答案决定：保存到抽象状态、由其他内容推导、只在内存 predicate 中拥有，或者当前不需要表示。不要仅根据名字决定。

### 2.4 逐项决定保存、推导或只保留具体内存

下面只是分析示例，不是固定结论：

| 内容 | 主要检查 | 可能的处理 |
|---|---|---|
| `limit` | 是否影响合法范围、返回值或后续操作 | 固定配置、抽象状态或派生关系 |
| bitmap/count/cache | 是否独立影响行为，能否从 map/list 推导 | 保存逻辑内容，或保存具体内存并写一致性关系 |
| `prev/next` | 是否只表示容器，地址本身是否会被观察或跨调用保存 | 由容器 predicate 拥有，必要时再记录逻辑关系 |
| cursor | 是局部遍历位置，还是 C 对象中持久状态 | 局部量留给证明；持久量按行为决定是否保存 |
| padding/raw bytes | 是否会被整块读写 | 通常不进入抽象状态，但 predicate 可能仍需拥有内存 |

函数 spec、lemma、临界区规则和证明中的临时拆分不是 C 对象的抽象状态，应写在各自的位置。

### 2.5 选择 Abstract State 的表示形式

完成前面的内容取舍后，再选择 Abstract State 的表示方法：几个相关值可用 `Record`，互斥状态可用 `Inductive`，
按 key 查找多个对象可用 map，需要顺序可用 list。它们可以组合，也可以直接复用项目已有类型；不是四选一，
更不是每个 C struct 都必须对应一个 `Record`。

## 3. 组织 Predicate 使用的逻辑状态

第 2 节已经确定 C 对象的抽象语义中需要记住什么。本节从两个互相独立的维度组织 predicate 使用的逻辑状态：
Abstract/Concrete 区分语义与实现表示，Stable/Mutable 区分元素在系统运行中是否会变化。它们不是两组选项，也不构成
固定的四类；一个 concrete component 可以是 Stable 或 Mutable，abstract state 的不同部分也可能分别保持不变或发生变化。

### 3.1 Abstract State 与 Concrete State

经过 2.1～2.5，当前 C 对象的 Abstract State 已经确定。本节不再判断哪些内容应进入 Abstract State，而是考虑
怎样在 predicate 和函数 spec 中描述 C 实现对应的状态。

如果一组具体实现值需要在 predicate 中作为整体出现，或者函数 spec 需要区分它更新前后的具体状态，可以定义一个
Concrete State。Concrete State 是给这些实现层逻辑值命名的 Rocq 类型，通常根据 C struct 及其指向的数组、bitmap
或容器设计，但不要求与某一个 C struct 一一对应。`storeConcreteState` 则是使用这个逻辑状态描述实际内存的
predicate；具体 ownership 在后文定义内存 predicate 时继续检查。

函数 spec 可以直接使用 `storeConcreteState addresses concrete` 描述具体前后状态，也可以只使用由 Abstract State
索引的表示 predicate，把 Concrete State 隐藏在内部。对外只关心逻辑行为的 spec 通常使用后一种方式；只有确实需要
暴露实现层变化的 spec 才直接提到 Concrete State。

当 abstract state 与 concrete state 高度重合，concrete 一侧只多出 bitmap、cache 等少量 extra components 时，
不必再定义一个大量重复的 Concrete State Record。定义内存 predicate 时可以直接接收 abstract state，并在内部
存在量化 extra components：

```coq
Definition storeConcreteState
    (bitmap_addr : addr) (abs : AbstractState) : Assertion :=
  EX bitmap,
    [| bitmap_matches abs bitmap |] &&
    store_bitmap bitmap_addr bitmap.
```

这里 bitmap 本身就是 extra component，`bitmap_addr` 是单独传入 predicate 的实际地址。extra component 可以有一个，
也可以有多个；数量本身不决定是否建立 Concrete State Record。应看两种状态的重合程度，以及 concrete components
是否形成需要命名和复用的稳定整体。

当 abstract state 与 concrete state 的结构差异很大、重合很少时，可以分别定义两个逻辑类型，并用 pure relation
连接它们：

```coq
Record AbstractState := { ... }.
Record ConcreteState := { ... }.

Definition object_rep (addresses : ObjectAddresses)
    (abs : AbstractState) : Assertion :=
  EX concrete : ConcreteState,
    [| represents abs concrete |] &&
    storeConcreteState addresses concrete.
```

`represents` 只说明两个逻辑状态怎样对应；`storeConcreteState` 才描述具体地址上的内存。不要机械地从 C struct
复制 Concrete State Record，也不要因为 spec 中出现内存 predicate 就自动定义它。只有一个或两个 extra components
也不构成固定规则；选择必须来自实际字段、前后状态是否需要命名，以及 predicate 和 spec 的复用方式。

### 3.2 合并状态还是拆分 Stable/Mutable

首先判断每个字段在验证期间是否可能发生变化，然后再决定是否把它们放进不同的 record。

如果某个字段在当前验证覆盖的运行阶段内，不会被当前线程、其他线程、中断或其他合法执行路径改变，就可以放入 Stable state，记为 `sg`。这类内容通常包括：

- 全局对象的固定地址；
- 数组的起始地址；
- 初始化后不再变化的容量和配置；
- 静态函数表的地址与内容。

如果系统运行期间存在合法路径能够修改某个字段，就应把它放入 Mutable state，记为 `st`。例如：

- 当前已经分配的 ID；
- ID bitmap 和哈希桶内容；
- 链表中的成员及顺序；
- 对象当前状态；
- 只在证明中使用、但会随协议步骤变化的控制信息。

不能因为当前目标函数没有修改某个字段，就把它放入 Stable。判断标准应是：在当前验证范围内，系统是否存在能够合法修改它的路径。

这里的 Stable 不是说一个字段在系统整个生命周期中永远不变，而是说它在当前验证覆盖的阶段内保持不变。例如，某些配置在初始化时会被写入，但初始化完成后不再修改，那么验证正常运行阶段时，可以把它们放入 `sg`。如果系统支持动态重配置、重定位或销毁后重新创建，那么相关字段不能继续被当作 Stable，除非这些操作位于当前验证范围之外。

字段属于 Stable 还是 Mutable，与是否必须拆成两个 record 是两件事。

状态比较简单时，可以先使用一个统一的 `TaskState`，再通过状态更新函数或函数效果说明：

- 哪些字段发生了变化；
- 哪些字段保持原值。

当固定地址和固定配置需要在多个内存谓词、函数 Spec、加锁接口和解锁接口之间重复使用时，可以将其拆成：

```coq
sg : StableGlobalState
st : VarGlobalState
```

这样，函数执行前后可以直接使用同一个 `sg`：

```coq
crtos_inv sg st_bef
crtos_inv sg st_aft
```

这表示固定地址和固定配置在前后使用的是同一组逻辑值，而函数只需要说明 `st_bef` 如何变成 `st_aft`。

这种拆分是一种可选的代码组织方式，不是验证框架的强制要求。Skill 不应默认要求先拆成 Stable/Mutable，而应先根据实际字段和函数行为判断是否有必要拆分。

也可以把两部分包装成一个总状态。这样做时，总状态的更新函数必须直接复用
更新前的 stable 部分，只替换 mutable 部分；因此不需要在每个函数 Spec 中重复写
“更新前后的 stable 部分相等”。无论采用哪种写法，都必须保证合法的状态变化
不会随意替换固定地址或固定配置。具体 record 和更新函数应使用目标项目实际定义，
不要为了套用本指南另建一套 Task 风格的包装。

还要特别注意，`sg` 和 `st` 都只是 Rocq 中的逻辑值，本身不拥有任何 C 内存。

前后使用同一个 `sg`，只能说明前后的逻辑参数相同，不能单独证明对应的 C 内存没有被写。C 内存是否可读、可写，以及函数执行后是否仍然保存原值，还要由以下内容共同保证：

- 内存谓词；
- 内存所有权；
- 函数的 Require 和 Ensure；
- 未被函数使用的内存是否被原样保留；
- 实际 C 执行路径是否会修改这些位置。

拆分 `sg` 和 `st` 也不表示必须把内存谓词拆成两份。同一个内存谓词可以同时使用 `sg` 和 `st`：由 `sg` 说明对象位于哪里、采用什么固定配置，由 `st` 说明对象当前保存什么内容。

例如可以采用了这种拆分方式：

- `StableGlobalState` 保存 manager、task-head 和 `Done` 的地址，ID manager 的固定容量和数组地址，以及静态 `Done` 函数表的内容；
- `VarGlobalState` 保存当前已经分配的 ID、哈希桶内容、任务地址顺序、
  `task_virtual_status` 和已经发布的 descriptor map。

```coq
Definition store_task_idmanager
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  store_idmanager
    sg.(stable_idmanager_abs)
    st.(task_idmanager_abs)
    sg.(task_idmanager_ptr).
```

这里：

- `sg.(task_idmanager_ptr)` 给出 C 全局 manager 的地址；
- `sg.(stable_idmanager_abs)` 给出 manager 的固定容量、bitmap 地址和哈希表地址；
- `st.(task_idmanager_abs)` 给出当前已经分配的 ID 和各个哈希桶的内容；
- `store_idmanager` 给出这些 C 内存的实际所有权。

因此，Stable/Mutable 的拆分只是把“固定信息”和“当前内容”分别保存，并不要求把它们对应的内存所有权也分开。

以创建任务时发布新任务为例：

现有 Task 验证定义使用 [task_publish_state] 组合已更新的 ID manager 和任务注册表。

这个函数只构造一个新的 Rocq 逻辑值，不会直接修改 C 内存。它表示以下变化：

- `sg` 保持不变；
- 在 ID manager 中加入新分配的 `id`；
- 在对应哈希桶中记录 `id` 与 `&(task->id)` 的关系；
- 在任务链表表头加入 `task->link`；
- 没有被更新的字段继续使用 `st_lock` 中的原值。

实际 C 代码执行 `IdInsertObj` 和链表插入操作后，需要使用新的逻辑状态重新建立：

```coq
crtos_inv
  sg
  (task_publish_state
    task
    (idmanager_link
      sg.(stable_idmanager_abs)
      (idmanager_add st_lock.(task_idmanager_abs) id)
      id
      &(task # "TaskDescriptor" ->ₛ "id"))
    st_lock)
```

这一步说明：修改后的 ID manager 和任务链表内存，确实与新的逻辑状态一致。

还可以使用：

```coq
TaskStableContext sg
```

说明 `sg` 中保存的地址和固定配置与当前 CRTOS 的全局变量一致。但是：

```coq
TaskStableContext sg : Prop
```

只是一个纯逻辑条件，不拥有内存，也不提供读取或写入权限。真正的内存权限仍然来自 `store_task_idmanager`、`store_task_dll`、`store_task_desc_map` 和 `crtos_inv` 等内存谓词。

当前临界区只把 `VarGlobalState` 作为允许发生变化的状态，因此 `RTrans` 和 `GTrans` 只描述 `st` 前后是否符合并发规则，不描述 `sg` 的变化。同一个 `sg` 由加锁和解锁的函数 Spec 原样传递。

`RTrans` 和 `GTrans` 都只是 Rocq 中的关系，不会主动修改 C 内存。C 内存由实际 C 语句修改；验证过程需要用新的 `st` 描述修改后的内容，重新建立对应的内存谓词，并证明这次变化符合并发规则。具体的加锁、解锁和 transition 使用方式应放在函数 Spec 或并发验证部分说明。

## 4. 为临界区操作定义抽象 program

对于进入临界区、完成共享状态操作并退出临界区的函数，应定义或复用抽象 `program`，说明这次
操作的返回结果和状态变化，并在 spec 中通过 `safeExec` 连接。已有适用定义就直接复用。
Lock/Unlock 原语本身用临界区协议 spec 描述；仅在临界区内执行的辅助函数可以直接用前后置条件
描述状态和资源变化，不必各自建立 program。

### 4.1 SafeExec、LastSeen 和 Atomic Command

为上述函数准备 `safeExec` 与 crtOS 临界区协议所需的接口：

1. 直接 import QCP/StateMonad 已有的 `safeExec`，不要重新定义；
2. 复用已有 `LastSeen`；缺失时根据 crtOS 自己允许的抽象状态转换定义；
3. 定义或复用具名操作 `program`，按现有协议需要提供 atomic command；
4. 涉及模块状态提升时，定义或复用到整个 `crtOSState` 的读取和更新函数。

`safeExec` 是通用执行条件；`LastSeen` 和 atomic command 是 crtOS 自己的语义。若 crtOS 允许对外函数在获得临界区前观察到
经过环境转换的状态，`LastSeen old` 应通过该转换关系定义；只有已经证明状态不会变化时，才能使用
`fun current => current = old`。

操作 program 应明确关联前态、抽象返回结果和后态，覆盖真实的成功、失败及适用的错误语义；
不要只提供宽泛的 `RTrans/GTrans`，把具体操作效果留给每个 caller 重写。例如查询操作可以按下面
的形状定义，其中查询和成功关系应引用项目实际定义；这是需要抽象操作时的示例，不是每个函数的必备模板：

```coq
Definition abs_get_task_with_idnode_locked
    (sg : StableGlobalState) (id : Z)
    : program VarGlobalState (option addr) :=
  {| MonadErr.nrm := fun before result after =>
       after = before /\
       match result with
       | None =>
           idmanager_query before.(os_tasks).(task_idmanager_abs) id = false
       | Some task =>
           get_task_with_idnode_success sg before id task
       end;
     MonadErr.err := fun _ => False |}.
```

这是使用 `MonadErr` 接口的示意；实际构造语法沿用项目导入的 monad，不为套用示例更换库。
`None` 或 C 错误码可以是正常返回结果，不等同于 monad 的 `err`；只有操作确实没有该类错误行为时
才把 `err` 定义为 `False`。创建操作应相应定义成功时新增对象、初始化值和返回 ID，以及失败时的
状态变化，不能照搬查询的 `after = before`。

抽象 program 描述函数在临界区内完成的操作，包括返回结果和状态变化。例如，abs_get_task_with_idnode_locked 描述一次查询，查询本身满足 after = before。外层 abs_get_task_with_idnode 按已有临界区协议连接这次操作，供函数 spec 中的 safeExec 使用。函数入口记录的状态与取得临界区时的状态可能不同，因此查询自身不修改状态，不代表整个调用的入口与出口状态相同。若操作只定义在模块状态上，连接到 OS 总状态时还应明确：本次操作只更新目标模块，其他模块保持不变。

这些定义供 [Spec 指南第 4 节](spec-writing-guide.md#4-临界区调用链中的函数-spec)的外层契约使用；
它们表达操作语义，不代替具体内存 ownership 或临界区资源谓词。

## 5. 为临界区定义状态关系

源码出现 lock、unlock、IRQ-disable/restore，并且函数借此取得共享 invariant 时，需要定义或复用 crtOS 自己的
临界区定义：

1. 项目已有 QCP `critical_STS/CriticalCSL` 的 crtOS 定义时直接复用；
2. 尚未建立时，以 crtOS 自己的抽象状态和真实允许的状态转换定义 QCP `critical_STS`；
3. 使用这个定义给出的 `OutsideCritical`、`InsideCritical`、`RTrans/GTrans` 表达 lock、restore 前后的逻辑状态和资源；
4. 不复制 LOS 的 `Los_CS_C`、`Los_Verify_State` 或 transition，也不另建 token Record。

`RTrans` 和 `GTrans` 是抽象状态之间的纯逻辑关系，类型类似 `crtOSState -> crtOSState -> Prop`；它们不拥有任何
具体内存：

- `RTrans old current` 表示从外层函数刚开始时观察到的 `old`，到真正取得临界区共享资源时的 `current`，环境是否
  允许发生这种变化。若源码语义保证期间不会有其他执行改变状态，它可以退化为 `current = old`，但必须有依据；
- `GTrans current new` 表示当前函数取得共享资源后，从 `current` 更新到准备交还资源时的 `new`，这种变化是否属于
  当前 OS 允许的更新。

若项目使用 QCP `CriticalCSL`，这两个名字由 crtOS 自己的 `critical_STS_transition` 提供；若尚未定义，slice 必须先
补上并审批，spec 不能直接假设符号存在。项目采用其他临界区库时，使用其中表达相同含义的实际关系。纯关系在
separation-logic spec 中不代替 `InsideCritical` 或 `OS_inv` 等资源谓词。
QCP 当前接口可以让 `RTrans` 和 `GTrans` 指向同一个 `critical_STS_transition`；两个名字区分它在进入和退出临界区时的
用途，并不要求项目一定维护两套不同的状态转换定义。

`OutsideCritical/InsideCritical` 说明共享内存资源处于临界区外还是已交给当前执行；`safeExec/LastSeen` 说明抽象命令
允许哪些状态和结果。一个调用过程中负责进入和退出临界区的对外公开函数往往两组都需要；只在临界区内调用的内部辅助函数
按局部 predicate 描述资源变化，不要求维护完整 `os_inv`。不进行临界区资源交接时，`InsideCritical`
可由调用者通过 frame rule 保留，详见 [Spec 指南第 4.3 节](spec-writing-guide.md#43-在临界区内更新)。

## 6. 定义具体内存 Predicate

第 2～3 节已经确定每个 C 对象的 Abstract/Concrete State 及其 Stable/Mutable 组织。本节定义具体内存 predicate，
把这些逻辑状态与真实地址、内存值和 ownership 对应起来。具体内存 predicate 是 `Assertion`，不是第 3.1 节的
Concrete State。

根据 C 对象的实际布局和访问方式，分别定义对象、全局内存和容器 predicate，再把它们组合起来。最终 predicate
必须覆盖目标函数的实际 load/store。不进入 Abstract State 不等于不拥有对应内存：容器 links、派生 bitmap 和
整块操作覆盖的字节仍可能需要由 predicate 拥有。

新增 representation、容器 predicate、递归结构或辅助 lemma 前，先搜索 QCP 已有库和项目已经引入的定义。
只要已有结构能够表达目标 C 的真实布局、ownership 和所需操作，就直接复用；需要适配时优先只定义目标对象的
element/payload predicate，不复制已有结构或手写同义 Fixpoint。只有已有库确实不能表达，并能指出具体缺口时，
才新增项目自己的结构定义或 lemma。

### 6.1 确定每处内存是否由当前 Predicate 拥有

| 写法 | 拥有地址 | 知道当前值 | 含义 |
|---|---:|---:|---|
| `p # T |-> v` / `data_at p v` | 是 | 是 | 当前值与抽象语义对应 |
| `p # T |->_` / `EX v, p # T |-> v` | 是 | 否或对外隐藏 | 保留初始化、复用或写入权限 |
| 不写入 predicate / `emp` | 否 | 否 | 当前 predicate 对该地址没有 ownership |
| `[| P |]` | 否 | 只有纯事实 | 不能支持 load/store |

对 C 代码实际访问的内容逐项选择“known-owned”“unknown-owned”或“not-owned”，不能把后两种混为一谈。

例如 free object 的 `owner` 在当前阶段没有业务含义，因此不进入 free-state record；但 create 会覆盖该地址，则 free
object predicate 仍应写 `owner |->_`。若完全省略，create 的 store 将没有权限。

#### `emp`、纯谓词和指针

- `emp` 只表示当前 predicate 的 footprint 为空；必须指出真实资源由哪个其他 predicate 拥有。
- `[| address_relation |] && emp` 可以连接 ID 和地址，但不能授权读取该地址。
- `obj->owner |-> p` 只拥有保存指针的那块内存，不拥有 `p` 指向的对象。
- pointer graph 用纯 relation 连接；不要递归展开成互相占有的 ownership graph。
- `P ** Q` 要求两份 footprint 分离；不要用普通 assertion 合取代替空间拆分。

不要根据 `store_*`、`valid_*`、`complete_*` 的名字猜 ownership。展开到最底层，确认是否出现 `|->`、
`data_at`、`store_dll` 或其他实际 spatial atom。

#### 逐状态检查实际访问的内存由谁拥有

为所有实际访问的内容填写：

| C 对象状态 | 实际访问的内容 | 抽象含义 | 唯一 spatial owner | known/unknown/not-owned | 使用者 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

验收条件是：

```text
对验证边界内每个会被访问的字节：当前稳定状态下恰好有一个 owner。
```

若 owner 列出现两次，存在重复权限；一次也没有，存在缺权限。whole-struct `memset/memcpy` 必须按整个访问范围
审计，不能只检查单独写出名字的内容。

Owner ledger 之外再记录目标路径的 memory transition：load 所需前态值或关系、store 的 old/new 值或结构、
以及 write footprint 之外必须保持的 frame。只有 ownership 而没有这些前后态约束，不能支持函数验证。

### 6.2 组合 C 对象与容器 Predicate

#### 嵌套对象与容器的内存

先区分关系类型，再决定是否嵌套 spatial predicate：

| 关系 | 典型表示 | Ownership 规则 |
|---|---|---|
| 逻辑值包含 | record 中有子 record | 不直接说明 heap |
| 物理内嵌 | `struct A { B b; }` | `A_rep` 委托给唯一 `B_rep(&a->b, ...)`，不要同时 whole-struct 拥有 |
| 指针引用 | `B *b` | 默认只拥有 pointer field，不拥有 pointee |
| map/array 容器 | element collection | container 组合局部 element predicate |
| intrusive membership | B 的 link 挂入 A 的容器 | container 拥有 link；B object predicate 拥有其余内存 |
| 可由其他状态推导的索引或缓存 | 作为缓存使用的 ID、bitmap、count | 用 pure relation 连接项目中的抽象状态，不复制 heap owner；若它是 C 行为的独立依据，则按第 2.3–2.4 节重新判断 |

对每个 embedded link 单独画 owner 状态机。节点未入链时由 object-local standalone predicate 拥有；入链后由恰好
一个 container predicate 拥有；删除时 container 返还 standalone link。不要让 object predicate 和 container 同时
拥有 `prev/next`，也不要让两边同时 `emp`。

保持推荐层次：

```text
field/subobject predicate
  -> object predicate for the relevant state
  -> map/array/list predicate
  -> one module glob component
  -> store_glob_module
  -> module_inv = pure validity && store_glob_module
  -> slice_OS_inv
```

每层只增加自己负责的结构。map element predicate 不要暗中拥有其他 element 或全局 root；intrusive container 的
payload callback 不要重复拥有由 container spine 管理的 link 内存。

同时画三张图并对齐：abstract value tree、concrete address graph、ownership graph。使用下表定位冲突：

| 抽象路径 | Concrete 地址路径 | Owner predicate | 关系类型 | 所需 split lemma |
|---|---|---|---|---|
|  |  |  |  |  |

### 6.3 封装 Predicate

可以定义具名抽象操作、predicate 和辅助关系，分别表达操作语义、对象或模块资源，以及相关逻辑
条件。

不要命名每一个中间证明状态。对连续执行、属于同一逻辑阶段且没有改变抽象状态或 ownership 边界的语句，采用：

```text
稳定谓词
  -> 临时展开
  -> 连续执行一组逻辑相关的 load/store
  -> 折叠回原稳定谓词，或折叠成下一个具有真实语义的稳定谓词
```

- 只读、查找或检查且不改变抽象状态时，折叠回`对象的内存表示谓词(old)`。
- 对象语义状态或 ownership 关系改变时，折叠成`对象的内存表示谓词(new)`。
- 为证明一次内存读取或写入，可以在证明过程中临时展开已有 predicate；不要只为描述“刚读完某个值”或“刚写完某个值”
  而新增一个命名 predicate。操作完成后，应重新合回原来的或更新后的内存表示谓词。

例如，ID 查询应在展开和读取后折叠回 `store_id_manager(manager, st)`；任务从 ready 队列迁移到 semaphore
等待队列时，则从 `store_ready_task(task)` 折叠为 `store_pending_task(task, semaphore)`。

常见的命名谓词包括：

1. 对象、容器或模块 representation；
2. 具有明确语义的对象状态，例如 `ready`、`running`、`pending`；
3. 具有不同 ownership 边界的生命周期状态；
4. 在循环迭代之间反复建立的循环不变式；
5. 项目已有通用容器库需要公开的拆分接口；
6. 具有明确业务含义的状态，或当前函数中有助于理解和证明的资源组合。

禁止仅按程序计数器位置或一次内存访问命名，例如：

```text
manager_after_read_id
manager_missing_prev_cell
```

容器拆分优先复用通用库。现有接口不足时，可以增加职责明确的模块内部接口，不要求有多个调用者；
同时给出拆出和合回的 lemma，并把 `prefix/rest/first/last` 等实现细节留在内部。简单的局部访问也可以
直接在证明中展开和合回稳定 predicate。

新增或审查命名 predicate 时逐项检查：

1. 它是否表达明确的对象状态、资源组合或逻辑条件，而不只是程序执行到某一行？
2. 它能否从稳定对象、容器或模块 predicate 推出？
3. 它是否隐藏链表、数组和遍历游标等内部表示？
4. 它在当前函数或其他调用者中是否有明确用途，是否有助于理解或证明？
5. 若是容器拆分接口，是否有成对 `split/merge` lemma？
6. 上层是否可以完全忽略其内部结构？
7. 是否会因读写 C 对象的不同内容而继续派生同类谓词？若会，保持这些状态为 proof-local。

可以为函数定义一个抽象的 atomic 操作，用 program 表达这个函数做什么、返回什么，以及抽象状态
如何变化。例如 `abs_get_task_with_idnode` 表达查询操作，再由函数 spec 中的 `safeExec` 引用；
这样的函数行为封装是合理的。

这里禁止的是把整个函数契约一起封装：把参数条件、`safeExec`、临界区资源、调用者资源等全部
入口要求放进同一个 `pre`，再把返回分支和全部出口保证放进同一个 `post`，让注解只剩
`Require pre(...)` 和 `Ensure post(...)`。抽象 atomic 操作可以单独定义，其他调用条件与资源
仍应在 `Require/Ensure` 中显式组合，返回结果分支也应直接写出。

具名抽象操作、predicate 和辅助关系应满足以下条件：

- 名称指出具体对象、动作或路径，例如 semaphore allocation failure、ID insertion success、
  critical-section exit，而不是只指出它位于调用前或调用后；
- 定义对应明确的操作、对象状态、资源组合或逻辑条件，参数只包含表达这些内容所需的值，并在定义前用中文说明它拥有的
  资源或约束的状态变化；
- 即使只使用一次，也可以封装清楚的操作或资源组合。应避免没有明确用途的重复定义，以及层层
  转发却不增加语义、抽象边界或证明价值的包装。

#### 同一件事只定义一次

避免为同一个 predicate 增加没有独立用途的 helper、wrapper 和新名字。是否保留辅助定义取决于
它是否有助于表达接口或组织证明，而不是调用次数；无意义的重复转发会增加理解和展开的负担。

例如，下面 `store_items_aux` 和 `store_items` 都只是把起始下标固定为 0，形成了重复转发：

```coq
Fixpoint store_items_from base index items : Assertion :=
  match items with
  | [] => emp
  | item :: rest =>
      store_item base index item **
      store_items_from base (index + 1) rest
  end.

Definition store_items_aux base items : Assertion :=
  store_items_from base 0 items.

Definition store_items base items : Assertion :=
  store_items_aux base items.
```

遇到目标中的 `store_items base items`，证明者为了看到递归内容需要依次展开：

```coq
unfold store_items.
unfold store_items_aux.
unfold store_items_from.
```

这里可以去掉中间的 `store_items_aux`，让 `store_items` 直接使用 `store_items_from base 0 items`。
如果带下标的递归定义没有独立用途，也可以把它放到定义内部：

```coq
Definition store_items base items : Assertion :=
  let fix go index remaining :=
    match remaining with
    | [] => emp
    | item :: rest =>
        store_item base index item ** go (index + 1) rest
    end
  in go 0 items.
```

这样客户端只需要认识和展开 `store_items`。如果顶层递归 helper 有助于描述下标语义、陈述引理或
组织证明，也可以单独保留，不要求多个调用者。应说明辅助定义的用途，避免无意义的改名、转发和未使用参数。

### 6.4 直接从源码确定复杂 Representation

数组、bitmap、对象池、ID-indexed table、intrusive container、sentinel、embedded link 或多 membership 都直接读取
目标 OS 的创建、查询、插入、删除和回收源码。由实际操作确定地址公式、spine/payload 边界、ownership 转移、
container predicate 和必要 lemma；仅凭类型名或习惯性实现不能构成证据。

始终先直接读取目标 OS 源码、当前配置和项目已有定义。只有这些材料与 QCP 示例仍不足以决定设计时，才把
`references/doc/` 中同层次的 LOS 文件作为类比参考：state/config 看 `glob_vars_and_defs.v`、
`Los_Verify_State_def.v`；需要类比通用结构、对象/容器、模块操作或最外层 API 时，分别看 `List_Add.c`、
`OsSchedPriQueue.c`、`OsSchedTaskQueue.c`、`LOS_TaskCreate.c`。读取后检查 `Admitted|Axiom|Parameter`；
未证明或依赖额外假设的内容不能当作目标项目结论。

### 6.5 组合模块 Predicate

模块全局 predicate 必须覆盖当前配置下该模块拥有或管理的全部内存。开发时可以按对象或容器逐步加入并编译，但要持续修改同一个正式 definition；在模块资源和生命周期尚未闭合时，它仍是 draft。每次加入资源时，检查其唯一 owner、与现有 footprint 不重叠，并追溯到使用它的真实模块函数；发现新的逻辑状态时返回第 2 节。

`slice_OS_inv` 可以只组合目标函数及其依赖需要的模块 predicate，但其中每个模块 predicate 本身必须完整。组合时检查跨模块地址不重叠；跨模块联系优先使用纯 consistency relation，不复制 ownership。只有验证边界内的共享资源、critical protocol、initialization 和生命周期全部闭合后，才能声称为完整 `OS_inv`。

## 7. 根据真实 C 操作定义 Lemma

Lemma 只补第 6 节 predicate 无法直接支持、且真实 C 操作当前需要的接口。先搜索 QCP 和项目已有的 array、map、
list、container 及其他相关 lemma；能直接复用时不增加 wrapper。

常见需求包括数组元素更新、链表插入/删除、对象进出容器、module state 更新，以及第 6.2～6.4 节所述的 split/merge。
循环不变式和 exact remainder 可以作为模块内部接口；不要为每一次字段 load/store 分别建立一套公开的
`cursor/missing/remainder/focus/refold` 定义。

确实需要新 lemma 时，只在定义相应数据结构或模块的正式 `.v` 文件中写可审阅的 statement，并记录哪个 C 操作会使用
它。当前阶段只确认 statement 是否正确，不完成 lemma proof，也不使用 `Admitted`、`Axiom` 或未解释的 `Parameter`。

## 8. 检查 Validity、初始化与生命周期

分离纯合法性、跨模块关系和 spatial store：

```coq
Definition module_inv sg st : Assertion :=
  [| module_valid st |] &&
  store_glob_module sg st.

Definition slice_OS_inv sg os : Assertion :=
  [| OS_valid os |] &&
  module_inv_1 sg (project_1 os) **
  module_inv_2 sg (project_2 os).
```

`module_valid` 保存模块内部 ID 范围、used/free/recycle 分区、NoDup、status 与 membership 等关系；`OS_valid`
保存跨模块 consistency。Pure relation 不拥有任何地址。

为当前已进入 predicate 的资源写出初始化 interface：

```text
project_initialization_resource
  * uninitialized_global_memory
  * module_initialization_resources
  -> slice_OS_inv(sg, initial_state)
     * project_post_init_resource_or_none
```

上述两个 `project_*` 是占位符，应替换为项目已有或已批准的资源；若项目初始化不使用额外 token，
则 formal assertion 中该部分使用 `emp`，并在相关 `.v` 注释中说明没有额外 token；不得为套用模板而新建 token。

说明 initial object/module/total state、原始 memory owner、初始化顺序、成功和失败路径，以及每个 glob component 在
哪一步建立。后续 proof 可以延期，ownership 来源不能延期或用 `Parameter` 隐藏。

对每条生命周期转换检查：

```text
旧 predicate
  -> 拆出需要更新的 C 对象内容和 links
  -> 每个 C load/store 有权限
  -> concrete update 对应 abstract state 的局部更新
  -> link ownership 转交给唯一新 owner
  -> 所有临时资源 refold
  -> 新 predicate
```

特别检查 early return 和错误路径。

## 9. 正式定义注释与 Predicate 设计报告

正式 `.v` 文件是 state、predicate、statement 及其局部语义解释的唯一来源。Predicate 设计报告解释跨定义、
跨文件和模块级设计，但不是第二份 formal source；遵循
[验证记录指南](reporting-guide.md)，不要求模板或固定章节。报告引用正式文件、symbol 和 revision，
不得复制 Rocq 定义或用自然语言改写出另一套语义。
对本次设计或修改涉及的非平凡、核心组合或对外使用的定义，不论是新建还是已有，
都在 definition/statement 前写简短的 `(** ... *)` 中文文档注释。例如：

```coq
(**
  [update_task_id_map ids before] 替换 ID 管理器中的已分配 ID 列表，
  保持 [idmax]、[hoffset] 和哈希桶不变。

  这是描述 [AllocId]/[FreeId] 局部中间状态的辅助函数。单独更新位图
  后，ID 列表与哈希桶可能暂时不满足 [idbuckets_ok]；只有在后续
  哈希桶更新也完成并重新满足 shared 中的合法性条件后，才应折叠回
  完整 [store_idmanager]。
*)
Definition update_task_id_map ids before := ...
```

注释按抽象层分担解释责任。定义直接使用逻辑参数、record projection 或地址表达式时，
在该定义的注释中说明它们对应的 C 全局符号、struct 实例、字段或容器，以及定义
拥有或约束的内存。这些 C 对应关系写在最接近且直接使用相应逻辑项的定义旁，
不由上层转调它的组合定义重复说明。

组合 predicate 的注释简要列出它直接使用的主要子 predicate，各用一句说明其职责，
再说明这些部分合起来表示的整体状态、ownership 分工和必要限制。例如，某组合
定义直接使用 registry predicate 和 object-body predicate 时，可分别用一句说明前者表示
全局容器、后者表示各对象本体；容器头地址对应哪个 C 全局符号，应写在直接使用
该地址的 registry predicate 旁，对象基址的 C 含义则写在直接使用它的 object predicate 旁。
这些名称只用于说明注释放置层次，不规定项目的命名或 predicate 分层。

还可根据定义需要说明“做什么、保持什么、何时使用、何时不能折叠”等。不要求
注释覆盖固定字段、固定行数或所谓完整 effect，也不要逐字翻译代码。显然的 projection 或
private helper 不需重复说明。
Definition 改变时必须同时更新相关注释。

设计报告集中说明如果塞进单个 definition 注释就会割裂或重复的内容：验证 scope/config、模块相关 C 对象、
abstract state 的选取理由、predicate/file 分层、ownership 边界、初始化和 lifecycle、跨模块借用或转移、
公开 view/interface、重要替代方案及限制。报告中的判断必须链接到源码证据和 formal symbol；某个 definition
自身的参数、地址、字段、ownership 或使用限制仍应在紧邻它的 `.v` 注释中说清楚，不能要求读者依赖报告才能
理解该定义。跨定义设计变化时同步更新报告；只修正文句且不改变 formal semantics 时不产生新的 predicate revision。

## 10. 检查并审阅 Predicates

Predicate 审阅重点检查：源码访问的内存由谁持有，操作过程中如何交接，以及这些描述是否符合实际 C 行为。按目标代码选择适用内容，不要求逐项填表；函数 Require/Ensure 的具体写法由 spec 审阅检查。

1. **每块内存是否都有明确归属。** 对模块涉及的对象和仍然存活的链表节点，应能指出谁持有对应内存。正常共享状态下可以由共享不变量中的某个 predicate 持有；创建、受保护操作或回收期间，也可以暂时由当前操作的局部断言持有。
2. **同一块内存是否被重复算给了两方。** 不同 predicate 可以提到同一个任务，但不能各自拥有同一组链指针或描述符字段。检查节点、所在对象及全局结构的描述是否重叠，也不能因避免重叠而漏掉实际访问的字段。
3. **资源交接前后是否一致。** 节点加入、移出或换队列时，实际指针连接、抽象的队列成员、内存归属和相关状态字段应一起对应更新。操作完成、重新建立共享不变量时，这些描述必须相互一致。
4. **状态是否足以判断归属。** 如果根据“活动或非活动”等状态划分资源，要检查状态与实际内存、队列成员之间是否有不变量保证这种对应关系，不能只凭标志的名字推断。作为依据使用的不变量关系需要有证明支持。
5. **状态不够时，是否保留了必要信息。** 例如 `SUSPEND` 本身不能说明任务属于哪个等待队列，也不能保证它一定在队列中。设计应保留原队列等调用上下文，或允许不同情况使用不同约定，确保操作后还能还原原队列中未受影响的部分。
6. **是否把“知道对象在哪”误当成“有权访问对象”。** 保存指针、知道节点属于某条链表，或通过节点地址找到所在对象，都不自动带来访问其字段的权限。内存权限与抽象成员关系应分别描述，并明确它们之间的联系。
7. **发布和回收的中间阶段是否安全。** 对象可能尚未完全初始化就已注册，某个节点摘链也不一定意味着整个对象已经可以释放。检查每个可能被其他执行方看到的阶段：哪些字段可以访问、内存由谁持有、什么时候才能交接或释放。
8. **是否保留了合适的抽象并忠实于源码。** 不受操作影响的字段应保留，已有且适用的链表定义与已证明接口应复用，只展开当前操作需要的资源。发现 C 行为与模型不一致时应指出差异，不能为了让证明通过而自行修改程序；局部描述也不能冒充完整模块或系统描述。

正式 `.v` 定义和必要注释应一致，并通过编译或类型检查。影响正确性的假设或资源关系尚无依据时，说明缺少什么，不能把它当作已成立的事实给出通过结论。

满足上述要求后，给出对应 predicate 版本的审阅结论。修复与重审按主 skill 的 [`review` 部分](../SKILL.md#review)处理，报告按 [验证记录指南](reporting-guide.md#审阅报告)组织；本阶段不启动 QCP 证明流程。
