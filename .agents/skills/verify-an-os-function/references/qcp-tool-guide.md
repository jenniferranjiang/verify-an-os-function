# QCP 工具使用与适配指南

处理 QCP 输入适配，或编写 predicate、abstract program 和 spec 时，按相关章节使用本指南。源码提取、OS 特定处理和 trusted specs 见[源码处理指南](source-processing-guide.md)。用户源码处理规则的优先级、原始源码只读及未覆盖情况的处理沿用该指南。

## C 输入与工具适配

适配仅作用于验证副本，记录原源码、配置、转换依据和结论限制。以下布局、类型与目标平台条目迁自原 `TrustBase.md`，保留既有信任范围，不将它们视为无条件的源码等价或对其他配置的自动授权；新增或扩大假设须经用户批准。

- **预处理**：使用 GCC / QCP 预处理展开宏和移除未激活的条件编译分支，保持必要的最小处理，并由 agent 核对激活配置与结果。
- **结构体布局**：沿用适用的结构体对齐公理，例如 `StackRegisterContext`；记录实际采用的公理与目标 ABI。
- **结构体位域**：原适配将 task descriptor 的两个位域作为两个普通 `uint32` 处理。使用时明确对应的布局与模型假设，不宣称保持原位域物理布局。
- **布尔类型**：原适配将 GCC 内建 `_Bool` 改为 `typedef unsigned char BOOL`，并相应修改验证副本；核对相关表达式与存储语义，记录适用范围。
- **目标位宽**：原适配通过 `xsconfig.h` 选择从 64 位到 32 位的配置；只修改验证副本，结论对应选定的 32 位配置，不自动覆盖 64 位源码行为。
- **C 标准库契约**：使用实际函数的 spec；QCP 中已有证明的契约按来源复用并记录证明状态，其余契约不能仅因属于标准库而自动标记已证或 trusted。

调试输出和调试宏删除、复杂宏函数化及新旧 `NULL_PARAM_CHECK` 的区别统一见[源码处理指南](source-processing-guide.md)，不在这里重复定义。历史上部分宏已函数化并验证 spec，使用时核对具体证明来源，不能据此推定所有宏契约已证。

### 1. 函数指针调用转为直接调用

当函数指针或 `done` 表项在验证覆盖的阶段内目标固定，且调用目标可由源码和配置
确定时，可在 annotated C 副本中将间接调用改为该目标函数的直接调用。固定目标
是转换依据，不能仅因为工具不支持函数指针就任意选择一个函数。

例如原始 C 中：

```c
static SemaphoreDoneType done = {
    .SemaphoreCreate = _SemaphoreCreate,
    /* ... */
};

return done.SemaphoreCreate(val);
```

若确认表项不会在该阶段被重新赋值，可在切片中写为：

```c
return _SemaphoreCreate(val);
```

转换须保留参数求值、调用顺序、返回值和目标函数的副作用；表对象及表项定位表达式
自身若有必须保留的求值或可观察行为，也不能直接丢弃。直接调用的函数仍按普通
callee 处理，使用完整契约并遵循已有验证范围；替换调用形式不赋予 trusted 身份。
记录原表项与目标函数的对应关系、配置及不变性依据，供源码一致性审查使用。

若目标会随运行时状态变化或无法确定，保留实际分派行为并按源码建模。即使全部调用点均已改成直接调用，切片仍保留静态操作表的类型、对象及初始化，抽象模型仍描述该对象。以本例为例，稳定状态保留表地址和固定表项，模块内存谓词描述表内容及访问权限，稳定上下文将表地址绑定到切片中的 C 符号。系统不变量按模块资源归属组合该谓词，每块表内存只归属一次。

### 2. 不同编译单元中的同名静态全局变量

不同 C 文件各自定义的文件级静态变量是不同对象。在 `annotated_C/src/` 验证切片中，为这些同名变量使用唯一、可追溯的名称。例如两个模块各有一张 `static ... done` 表，可分别命名为 `SemaphoreDone` 和 `MsgQueueDone`。按原编译单元逐一对应，同步切片中的定义、声明、初始化、取址、使用处及注解中的符号。抽象状态为各对象保留各自的地址字段，模块谓词与上下文约束引用对应符号，避免将不同表的地址或内容混为一处。记录原文件、原名与切片名的对应关系，原始 OS 源码保持只读。

## 公共定义与记法复用

编写或修改 predicate、abstract program 和 spec 时，已有通用定义或公共接口能够准确表达所需语义，就直接使用。适用范围包括 QCP 基础库和当前项目公共库。

### 通用数据操作

1. 谓词列表表示的数组或有效元素序列，其长度直接使用 `Zlength xs`，不另写 `Z.of_nat (List.length xs)` 或仅用于取长度的模块包装函数。已有列表时，不绕经 `max_len`、首尾索引等字段推算其长度。

   先明确列表表示什么：例如 `q.(dq_slots)` 只记录队列的有效元素，`Zlength q.(dq_slots)` 表示当前元素数量；`dq_max_len` 表示底层环形数组容量，二者不能互换。容量、物理索引与有效元素数量之间的关系放在表示不变量中；真实 C 字段的存储关系仍按其含义描述。

2. QCP 的断言标注和 C spec 中，Record 变量的字段引用优先使用
    `record_name.field_name`，嵌套字段使用连续的点号，避免多层投影函数调用影响阅读。
    例如，使用 `sg.os_semaphore_stable.semaphore_manager_stable`，而不是
    `semaphore_manager_stable(os_semaphore_stable(sg))`。这两层 Record 的声明
    可参考当前工程的 `annotated_C/src/headers/semaphore_create_logic.h`；
    示例访问的是已有的 ID manager 配置。

    使用点号语法前，必须在 QCP 的 C 标注中通过 `Extern Coq Record ...` 引入相关
    Record 及所用字段；嵌套访问涉及的各层 Record 都须有相应声明，并在使用处可见。
    只有 Rocq 中的 Record 定义或普通投影函数声明不足以支持该语法，缺少 Record
    声明会导致 QCP 符号执行报错。声明格式参考项目已有 C spec 或逻辑 header 中的
    `/*@ Extern Coq Record ... { ... } */`，字段名和类型须与实际 Rocq 定义一致。

    编写或修改这类字段引用时，应先复用或补齐相应 Record 声明，再使用点号写法，
    不要为了避开声明问题退回难读的嵌套投影调用。这条经验针对 QCP 的 C 标注语法，
    不要求将 Rocq `.v` 文件中的投影语法改成 C 标注写法。

### 公共模块接口

判断 ID 是否登记或查询 ID 对应节点时，优先使用 ID manager 的公共接口，不在使用方遍历 `SemaphoreState` 等对象集合重新实现相同查询。

- 只判断 ID 是否登记，使用 `idmanager_query idm id = true`。例如已有 `semaphore_manager ss` 视图时，直接使用 `idmanager_query (semaphore_manager ss) id = true`，不另写 `exists s, In s ss /\ s.(semaphore_id) = id`。
- 需要表达 ID 与节点地址的对应关系时，使用 `idmanager_contains sm idm id p` 等已有接口；这里的 `p` 是 ID 节点地址，需要对象基址时按实际布局建立对应关系。
- 需要计数、等待队列等对象特有信息时，再连接到模块对象表示。ID 登记关系本身不替代这些信息，也不提供内存 ownership。

使用当前对象状态已有的管理器视图，并由模块不变量或相应引理保证它与对象集合一致；不为复用查询另建一份独立维护的管理器状态。

### 抽象程序记法

- 顺序组合使用 monad 记法，不直接写 `MonadErr.bind`。
  使用 `x <- c1 ;; c2`、`c1 ;; c2` 和 `return v` 直接表达顺序控制流；
  不只是避免多层嵌套，单层组合也使用上述记法。
- 条件分支使用 QCP 的 `if_else`，纯命题条件使用项目的 `IF` 记法。
  不使用 Rocq 普通的 `if ... then ... else`（if-then-else）表达
  abstract program 的条件控制流，也不手工展开为 `choice` 与守卫的组合。
  条件依赖 monad 状态时，直接使用接受状态谓词的 `if_else`。

下面的例子同时遵守这两个要求（`result : bool`）：

```coq
result <- operation1 ;;
operation2 result ;;
IF (result = true) operation3 (return tt).
```

`x <- c1 ;; c2`、`c1 ;; c2` 和 `return v` 分别对应 `bind`、忽略返回值的
`bind` 和 `MonadErr.ret`，改写记法不改变抽象语义。`assume!! P` 只过滤
不满足 `P` 的路径，不产生 `err`。返回类型和 `sg` 等参数仍按目标 C 语义决定，不机械照抄示例。

QCP 的 `if_else` 已经把条件分支封装为
带互补 `test` 的 `choice`，不要再手工写
`choice (assume!! P ;; c1) (assume!! (~ P) ;; c2)`。CRTOS 的
`lib/common/CrtosRules.v` 为与 monad 状态无关的纯命题提供了
`IF P c1 c2` 记法，其定义就是 `if_else (fun _ => P) c1 c2`。例如：

```coq
Definition abs_get_msgqueue_by_id (sg : StableGlobalState) (id : Z)
    : program (VarGlobalState -> Prop) (option addr) :=
  IF (id < 0)
    (ret None)
    (task_atomic_cmd (msgqueue_lookup_locked sg id)).
```
