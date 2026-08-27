# 根据 C 代码设计 Predicate 和 Lemma

本指南完成三件事：理解现有 C 实现、形成 Rocq predicate 草案，并按 predicate 自己的条件完成独立审阅。Spec 另行编写和审阅；在 predicate review 前，可以用可编译的 predicate 草案编写 spec 并运行 QCP-MCP symbolic 检查，以发现草案缺口。

## 目录

1. [确认源码与范围](#1-确认源码与范围)
2. [为 C 对象定义抽象状态](#2-为-c-对象定义抽象状态)
3. [组织 Predicate 使用的逻辑状态](#3-组织-predicate-使用的逻辑状态)
4. [为函数定义抽象操作](#4-为函数定义抽象操作)
5. [为临界区定义状态关系](#5-为临界区定义状态关系)
6. [定义具体内存 Predicate](#6-定义具体内存-predicate)
7. [根据真实 C 操作定义 Lemma](#7-根据真实-c-操作定义-lemma)
8. [检查 Validity、初始化与生命周期](#8-检查-validity初始化与生命周期)
9. [检查并审阅 Predicates](#9-检查并审阅-predicates)

## 1. 确认源码与范围

从用户指定的目标模块出发，确定当前配置下属于该模块的源码与函数集合，读取这些函数
实际访问的 C 对象。为了理解这些对象怎样建立和变化，还要读取必要的初始化、查询、
修改、删除、回收及跨模块使用代码。

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

可以，下面把“投影、建模、模型”等词换成更直白的说法，并减少抽象术语。

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

当前 Task lib 使用 [task_publish_state] 组合已更新的 ID manager 和任务注册表。

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

## 4. 为函数定义抽象操作

这些接口应在 predicate 设计时确定并写入项目实际使用的 state/rules library，供其他 formal 定义直接引用。
它们不都是 spatial predicate，也不是每个 helper 都必须建立。先根据源码判断目标函数属于哪些情况。

### 4.1 SafeExec、LastSeen 和 Atomic Command

当对外公开函数的 spec 需要表达“允许从什么状态开始、执行什么抽象命令、返回后满足什么 continuation”时：

1. 直接 import QCP/StateMonad 已有的 `safeExec`，不要重新定义；
2. 根据 crtOS 自己允许的抽象状态转换定义 `LastSeen`；
3. 定义该对外函数使用的 atomic command；
4. 定义或复用模块状态到整个 `crtOSState` 的读取和更新函数。

`safeExec` 是通用执行条件；`LastSeen` 和 atomic command 是 crtOS 自己的语义。若 crtOS 允许对外函数在获得临界区前观察到
经过环境转换的状态，`LastSeen old` 应通过该转换关系定义；只有已经证明状态不会变化时，才能使用
`fun current => current = old`。

Atomic command 说明该函数在逻辑上改变什么，例如 task 状态、ready queue、delay membership 和返回值。模块局部
command 可以先修改局部 state，再通过已有 read/update 函数放回 `crtOSState`。没有 abstract-command 层的内部 helper
不需要单独定义 `safeExec`、`LastSeen` 或 atomic command。

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
允许哪些状态和结果。一个调用过程中负责进入和退出临界区的对外公开函数往往两组都需要；只在临界区内调用的内部辅助函数通常只使用
`InsideCritical` 和局部 predicate。

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

通常只为下列内容增加命名谓词：

1. 稳定、可复用的对象、容器或模块 representation；
2. 具有明确语义的对象状态，例如 `ready`、`running`、`pending`；
3. 具有不同 ownership 边界的生命周期状态；
4. 在循环迭代之间反复建立的循环不变式；
5. 项目已有通用容器库需要公开的拆分接口；
6. 跨函数边界使用且具有明确业务含义的状态。

禁止仅按程序计数器位置或一次内存访问命名，例如：

```text
manager_after_read_id
manager_missing_prev_cell
```

只有当同一种容器拆分被多个真实函数反复使用，而且通用库不能表达时，才考虑增加一个模块内部接口。此时要同时给出拆出和合回的 lemma，并保证上层函数看不到 `prefix/rest/first/last` 等实现细节。若只是当前函数的一次读取或写入，直接在证明中展开和合回稳定 predicate。

新增或审查命名 predicate 时逐项检查：

1. 它表示稳定语义或复用接口，还是只表示程序执行到某一行？
2. 它能否从稳定对象、容器或模块 predicate 推出？
3. 它是否隐藏链表、数组和遍历游标等内部表示？
4. 它是否有明确客户端并会被重复建立？
5. 若是容器拆分接口，是否确有多个客户端，并有成对 `split/merge` lemma？
6. 上层是否可以完全忽略其内部结构？
7. 是否会因读写 C 对象的不同内容而继续派生同类谓词？若会，保持这些状态为 proof-local。

#### 同一件事只定义一次

不要为同一个 predicate 反复增加 helper、wrapper 和新名字。重复定义不会增加语义，只会让代码难以读懂，
也会让证明脚本为了看到真正的 predicate 内容而连续 `unfold` 多层名字。

例如，下面三个名字实际都在表示“从第 0 项开始存储整个 items 列表”，属于不应保留的重复定义：

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

人类读者也必须先弄清 `store_items`、`store_items_aux` 和 `store_items_from` 是否真的有不同含义。这里应只保留一个正式
入口，把没有独立含义的递归过程放在定义内部：

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

这样客户端只需要认识和展开 `store_items`。只有某个递归 helper 确实被多个 definition 或 lemma 单独调用，或者工具要求
它必须是顶层 symbol 时，才单独保留它；此时必须说明它自己的用途。只改名字、转调下一层、复制相同 body 或增加未使用
参数，都不构成新定义的理由。

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

## 9. 检查并审阅 Predicates

### 9.1 检查已有定义

新增 state field、局部读取/更新函数、pure function、predicate 或 lemma 前，搜索已批准文件、项目库、
`Extern Coq`、C annotations 和 imports。同一个逻辑概念只保留一个正式定义。

| 逻辑概念 | 已有定义/位置 | 本项目使用的定义 | 使用它的函数/复用理由 | 重复项处理 |
|---|---|---|---|---|
|  |  |  |  | `reuse|merge|[REJECTED]` |

只有表达不同抽象层、具有不同输入输出语义，且有多个真实客户端或独立 lemma 时才增加 wrapper。不要保留一次性
同义定义，也不要在主树保留 `store_glob_obj_1`、`store_glob_obj_2` 之类开发历史副本。

正式 `.v` 文件是 state、predicate、statement 和设计解释的唯一来源。默认不创建 predicate Markdown template。
对生成的非平凡定义，在 definition/statement 前写简短的 `(** ... *)` 中文文档注释。例如：

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

注释按定义本身需要解释的内容自由书写，可以说明“做什么、保持什么、何时使用、何时不能折叠”等，但不要求覆盖固定字段、
固定行数或所谓完整 effect。不要逐字翻译代码，也不要给每个 projection 或显然的 private helper 添加重复说明。
Definition 改变时必须同时更新相关注释。

只有源码/config/scope 固定、每个实际访问对象能追溯到候选 owner/representation、formal definitions 与必要注释已落地并通过适用检查，且没有影响通过条件的已知 `[OPEN]` 时，
才进入 predicate full review。当前任务同时编写 spec 时，还要先使用该 predicate 草案完成验证闭包的全部 QCP-MCP symbolic 检查且未调用 `qcp.proof`；草案期间发现缺口就直接修改并重跑，不标记 `invalidated` 也不做中间 review。Review 检查 representation 和 ownership，不检查函数 Require/Ensure。
修订影响上一结论时按 dependency closure 做 delta；源码/config/scope 或抽象/ownership 边界使依据失效时重新 full review；
非语义文字变化不 review。所有适用检查通过且没有 blocker 后，将该 predicate revision 标为 `review-passed`，spec review 必须固定这份 revision。

### 9.2 交付检查

- [ ] 每个 abstract-state 分量来自可观察语义或明确 representation 关系；abstract/concrete state 高度重合时 extra components 可留在 predicate 的存在量中，差异很大时才分别组织两个逻辑状态；没有机械复制 C struct；
- [ ] Record 中没有函数 spec、待证 entailment、lemma obligation、任意 Assertion/token 生成器或 lock/IRQ 规则；
- [ ] 目标模块全部函数触达的区域均已分类为 known-owned、unknown-owned 或 not-owned，且每个实际访问字节恰好一个 owner；
- [ ] 每条路径的 load 前态、store 的 old/new 值或结构以及 write footprint 外的 frame 已明确；
- [ ] pointer、embedded subobject、container spine/payload 和跨模块关系没有重复 ownership；
- [ ] 每次增加资源时，同时检查 state、具体内存、地址是否重叠以及使用它的真实模块函数；
- [ ] Representation 结论带目标源码位置和实际 C 操作证据，没有仅凭类型名套用；
- [ ] 若确实新增了共享的 split/merge 接口，拆出与合回的内存精确互补；否则临时形状留在 proof 内部；
- [ ] 每个新命名 predicate 都对应稳定 representation、语义状态、ownership 状态、循环不变式或跨函数语义阶段；共享容器拆分接口只在多客户端条件成立时增加；
- [ ] 每个顶层递归 helper 都有独立客户端或 lemma；否则已并入唯一公开 definition/local `fix`，没有同义 wrapper 或未使用参数；
- [ ] 循环变量和容器拆分细节没有泄漏到上层函数 spec；
- [ ] lifecycle 与 initialization 说明 ownership 来源、转移和最终归还；
- [ ] 对外公开的函数需要 atomic-command 语义时，已复用 QCP `safeExec`，并定义 crtOS `LastSeen`、目标函数的 atomic command 及所需 read/update；
- [ ] 目标代码进入、退出或依赖临界区时，已写出或复用 crtOS 自己的临界区定义及 `OutsideCritical/InsideCritical/RTrans/GTrans`；
- [ ] `safeExec/LastSeen` 与临界区定义职责分开，内部辅助函数没有被迫重复对外公开函数的 atomic-command 条件；
- [ ] 每个概念只有一个正式定义；
- [ ] 模块 predicate 已覆盖当前配置下该模块拥有或管理的资源；函数级 `slice_OS_inv` 可排除无关模块，但不得把 partial invariant 冒充为完整 `OS_inv`；
- [ ] formal source 已 parser/typecheck 或编译，没有重复定义，也没有把定义复制到 Markdown；
- [ ] 非平凡或对外使用的生成定义具有与代码一致的中文注释；任务回复或最终报告给出 reviewed revision、review scope 和结论；当前任务同时编写 spec 时已完成 QCP-MCP symbolic 检查且未调用 `qcp.proof`，也没有未批准假设。

最后用一句话复核：

> 能否用普通话说明每个 Rocq 类型对应哪个 C 对象、为什么要记住这些值、哪个 predicate 拥有相关内存，以及每个 C 写操作怎样得到 spec 要求的新状态？如果不能，就继续简化或补充源码关系。
