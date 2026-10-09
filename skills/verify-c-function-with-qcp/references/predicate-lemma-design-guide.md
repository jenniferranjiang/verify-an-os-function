# 根据 C 代码设计 Predicate 和 Lemma

本指南用于理解目标 C、形成 Rocq predicate/lemma 草案并完成独立 predicate review。它不规定某个产品、代码库或领域的状态、路径与命名；项目事实必须来自权威源码、当前配置和明确加载的 project knowledge。

## 1. 固定范围和证据

从用户指定的模块出发，确定当前配置下属于该模块的源码和全部实现函数。为了理解对象如何建立、变化和回收，还要读取必要的初始化、查询、修改、删除、错误处理及跨模块使用代码。

对每个模块函数记录：

- 控制流、return/early-return/blocking path；
- 每个 memory read/write、访问的对象、字段和字节范围；
- direct callees、dispatch、宏展开产生的调用；
- side effects、循环和必要 invariant；
- 生命周期条件和其他影响内存语义的外部假设；
- 当前不知道的事实及其对设计的影响。

新增定义前搜索项目已有 state、predicate、lemma、spec、Extern Coq、C annotations 和 QCP 库。所有语义以目标 C 和配置为依据，不根据类型名、函数名、其他项目示例或习惯实现猜测。

## 2. 从 C 对象确定抽象状态

先确定当前要表示的具体 C 对象，再决定逻辑类型。不要一开始就选择 Record、Inductive、map 或 list。

对每项候选内容检查：

1. 它变化后是否改变分支、返回值、合法性或以后允许的操作；
2. 它是否需要跨函数调用保留；
3. 它能否由其他已记录内容推导；
4. 它是否只为证明某一步而临时出现；
5. 整块读写是否要求 predicate 仍拥有对应原始字节。

根据答案把内容放入 abstract state、作为 pure derived relation、只保留在 concrete representation，或排除在当前边界之外。函数 spec、lemma obligation 和 proof-local cursor 不是 C 对象的 abstract state。

选择表示形式时：

- 相关值可以使用 Record；
- 互斥语义状态可以使用 Inductive；
- keyed objects 可以使用 map；
- 有意义的顺序可以使用 list；
- 可以组合或复用已有类型，不要求每个 C struct 对应一个 Record。

每个 abstract-state 分量必须有可观察语义、representation 需求或真实客户端依据。

## 3. 设计具体内存 Predicate

内存 predicate 把逻辑状态与真实地址、内存值和 ownership 对应。最终组合必须覆盖验证边界内每个实际 load/store；不进入 abstract state 不等于不拥有该内存。

### 3.1 Owner ledger

为每个具名生命周期状态建立 owner ledger：

| C 对象状态 | 实际访问字节/范围 | 抽象含义 | 唯一 spatial owner | known/unknown/not-owned | 使用者 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

三类必须区分：

- known-owned：拥有地址并知道与逻辑状态对应的值或结构；
- unknown-owned：拥有地址，但当前值被隐藏或尚未初始化；
- not-owned：当前 predicate 没有该地址的权限。

Pure proposition 和 emp 不提供 load/store 权限。指针字段的 ownership 默认只覆盖保存指针的 cell，不自动拥有 pointee。Whole-struct memset/memcpy 按完整字节范围审计。

验收条件：

~~~text
验证边界内每个会被访问的字节，
在对应具名生命周期状态下恰好有一个 spatial owner。
~~~

在 owner ledger 之外记录每条目标路径的 memory transition：load 所需前态、store 的 old/new 值或结构，以及 write footprint 外必须保持的 frame。

### 3.2 嵌套对象与容器

先区分逻辑包含、物理内嵌、指针引用、数组/map 容器和 intrusive membership，再决定 spatial 组合：

- 物理内嵌 subobject 由唯一 subobject predicate 拥有，外层不重复 whole-struct ownership；
- 指针引用默认只拥有 pointer field，pointee 由其实际 owner 管理；
- array/map container 组合局部 element predicate，element 不暗中拥有其他 element 或 global root；
- intrusive container 通常由 container 拥有 link/spine，对象 predicate 拥有其余 payload；
- embedded link 在 standalone、in-container 和 removed 状态间转移时，每一时刻只能有一个 owner；
- 跨模块一致性优先用 pure relation 连接，不复制 heap ownership。

同时对齐 abstract value tree、concrete address graph 和 ownership graph。数组、bitmap、对象池、sentinel、embedded link、多 membership 的地址公式和 split/merge 都必须来自目标源码实际操作。

### 3.3 Predicate 层次和命名

推荐按实际项目需要组织：

~~~text
field/subobject
  -> object state
  -> container
  -> module representation
  -> module invariant
  -> selected global invariant
~~~

每层只增加自己负责的结构，不要求项目恰好拥有全部层次。

不要为每个程序计数器位置命名 predicate。连续操作若未改变语义状态或 ownership 边界，应临时展开、完成相关 load/store，再折叠回原 representation predicate；发生真实状态或 owner 转移时折叠为新的具名 lifecycle predicate。

具名 predicate 通常只用于：

- 语义明确且可复用的对象、容器或模块 representation；
- 有真实业务含义的对象状态；
- ownership 边界不同的生命周期阶段；
- 跨循环反复建立的 invariant；
- 多个真实客户端共享的容器 split/merge 接口；
- 跨函数边界使用的语义阶段。

禁止只按 before/after/pre/post/spec 命名的含糊 wrapper 隐藏资源或效果。共享 helper 的名称必须指出具体对象、动作或路径，并有多个真实客户端或独立 lemma 需要。一次性缩写、转发 wrapper、重复 body 和未使用参数应内联或删除。

已有结构能表达目标布局、ownership 和操作时直接复用。只有能指出已有库的具体缺口时，才新增递归结构、representation 或 lemma。

## 4. Lemma 接口

Lemma 只补 predicate 无法直接支持且真实 C 操作需要的接口。常见需求包括数组元素更新、容器插入/删除、对象进出容器、module state update 和共享 split/merge。

新增 lemma 前先搜索 QCP 和项目库。确需新增时：

- statement 写在定义相应结构或模块的正式 .v；
- 注释记录它支持哪个真实 C 操作；
- statement 必须精确互补 ownership 和 frame；
- 不为每次字段读写建立公开 cursor/missing/remainder/focus 接口；
- 设计阶段不以 Admitted、Axiom 或未解释 Parameter 代替证明。

## 5. Validity、初始化与生命周期

把 pure validity、跨模块 consistency 和 spatial store 分开：

~~~coq
Definition module_inv context state : Assertion :=
  [| module_valid state |] &&
  store_module context state.
~~~

Pure relation 不拥有地址。模块 predicate 覆盖当前配置下该模块拥有或管理的全部资源；函数级 global slice 可以排除无关模块，但不得把 partial invariant 冒充完整 global invariant。

为已进入 predicate 的资源说明初始化接口：

~~~text
authoritative initialization resources
  * uninitialized memory
  -> module/global invariant at initial state
     * returned project resources
~~~

说明原始 owner、初始化顺序、成功/失败路径、各 component 建立时点和最终返还。项目不使用额外 token 时用 emp，并在注释中说明；不得为套模板创建 token。

对每条生命周期转换检查：

~~~text
old representation predicate
  -> split required object/link resources
  -> authorize every load/store
  -> relate concrete update to abstract update
  -> transfer each resource to one new owner
  -> refold all temporary resources
  -> new representation predicate
~~~

特别检查 early return、partial initialization、rollback、delete 和 recycle。

## 6. 正式注释与设计报告

正式 .v 是 definition、statement 及局部语义解释的唯一来源。对本次设计或修改涉及的非平凡、核心组合或对外定义，在紧邻位置说明：

- 逻辑参数、projection 和地址表达式对应的 C symbol/object/field/container；
- 直接拥有或约束的内存；
- 状态含义、保持关系、适用时机和不能折叠的中间状态；
- 组合 predicate 的直接组成项和 ownership 分工。

上层不重复下层已解释的 C 对应；简单 private helper 可只写一句。Definition 改变时同步更新注释，过时或误导性注释是 blocker。

使用 [predicate 设计报告模板](../assets/predicate-design-report-template.md)记录模块级、跨文件和跨定义设计：scope/config、C 对象到 abstract state 的整体映射、分层、ownership/lifecycle、公开 view、取舍、限制、[OPEN] 和 formal revision。报告引用 file/symbol/revision，不复制定义或成为第二份 formal source。

## 7. Review-ready 与 review-passed

只有以下条件全部满足才 review-ready：

- 源码/config/scope 和目标模块函数集合固定；
- 每个实际访问对象和字节都有候选 owner/representation；
- abstract state、predicate 和 lemma statements 已写入正式 .v；
- 初始化、正常转换、错误、删除和回收路径已覆盖；
- 必要注释及设计报告与 formal revision 一致；
- formal files 通过适用的 parser/typecheck/compile；
- 没有影响 owner、语义、lifecycle、frame 或后续 spec 的 [OPEN]。

Review-passed 还要求：

- 每个 abstract-state 分量有源码语义或复用客户端依据；
- 每个具名生命周期状态的可访问字节恰好一个 owner；
- object/container/module ownership 边界闭合；
- 跨模块资源 owner 与借用/转移接口明确；
- load 前态、store old/new 和 frame 足以支持真实路径；
- 没有同义定义、无客户端 wrapper、重复 owner 或缺失 owner；
- formal checks 通过且无 open blocker。

Predicate review 只检查 representation、ownership 和 predicate interfaces，不替代 spec review。Spec 草案若暴露 predicate 缺口，仍在 draft 时直接修正；已 review-passed 时固定新 revision 并按 dependency closure 重审。
