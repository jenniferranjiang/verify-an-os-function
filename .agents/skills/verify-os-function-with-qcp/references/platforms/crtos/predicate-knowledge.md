# CRTOS Predicate Knowledge

开始 CRTOS predicate 设计或审阅前，先读 [CRTOS 公共知识](knowledge.md) 和通用 predicate 指南。本文件只补充 CRTOS 专用状态、抽象命令、critical/IRQ 协议和已有 predicate 参考。

## 逻辑状态组织

CRTOS predicate 可以分别组织 abstract state 和 concrete state：

- 当两者高度重合，仅多出少量 bitmap、cache、padding 或容器形态时，把额外 concrete components 存在量化在 representation predicate 内，不复制大 Record。
- 当两者差异较大，且 concrete state 需要命名或跨接口复用时，分别定义逻辑类型，并以 pure represents relation 连接。
- represents 只连接逻辑值，不拥有内存；具体地址和值的权限仍由 representation predicate 给出。

~~~coq
Definition object_rep addresses abstract : Assertion :=
  EX concrete,
    [| represents abstract concrete |] &&
    store_concrete addresses concrete.
~~~

CRTOS 的全局逻辑通常区分固定地址/配置和运行时可变状态，但是否拆成 Stable/Mutable 仍由真实字段和验证范围决定，不能仅因 Task 示例这样组织就机械照搬。

若当前正式库采用该组织：

- Stable 部分保存初始化后在当前验证阶段不变的地址、容量、静态表和配置；
- Mutable 部分保存已分配 ID、对象集合、容器成员、对象状态和协议阶段；
- 前后使用同一 Stable 逻辑值不自动提供内存权限；权限仍由 store、模块 invariant 或 critical resources 给出；
- 普通运行时 update 必须保留 Stable 部分，初始化、重配置和销毁按其真实接口另行处理。

字段只有在当前 CRTOS 验证阶段内不会被当前执行、其他并发执行、中断或合法重配置路径改变时，才可归入 Stable；仅仅因为目标函数不修改它并不充分。Mutable 保存运行期间可合法变化的对象状态、容器内容、分配集合和协议阶段。

## 抽象命令与 Critical/IRQ 协议

对外 CRTOS API 需要表达允许起始状态、原子抽象效果和 continuation 时，复用 QCP/StateMonad 的 safeExec，根据 CRTOS 真实环境转换定义 LastSeen，并定义目标 API 的 atomic command 以及模块状态到 CRTOS 总状态的 read/update。内部 helper 没有该层语义时，不强行增加。

代码通过 lock、unlock、IRQ-disable/restore 取得共享 invariant 时：

1. 优先复用已审阅的 CRTOS critical_STS/CriticalCSL 实例；
2. 缺失时，以 CRTOS 自己的总状态和真实允许转换建立协议并先审阅；
3. 用 OutsideCritical、InsideCritical 和 RTrans/GTrans 或项目实际同义接口表达资源取得、环境变化和资源归还；
4. 不复制 LOS 的 Los_CS_C、Los_Verify_State 或 transition，也不为套模板另建 token Record。

RTrans/GTrans 是纯状态关系，不拥有内存。InsideCritical/OutsideCritical 与 CRTOS invariant 承担 spatial ownership；二者职责不得混淆。只有 CRTOS 真实并发语义允许环境推进时，才区分函数入口状态和取得共享资源时状态。

缺少已审阅协议时，先在 slice-design 中建立并审阅，不让 spec 假设不存在的 symbol。

## Predicate 文件组织

AI 新建的共享 Rocq definitions 写入 trial 的 lib/。文件边界按语义内聚、依赖方向和当前 CRTOS/QCP 风格确定，不规定固定前缀或后缀。常见但非强制的职责分工是：

- Pure 文件：abstract-state Record/Inductive、projection、纯 update、validity、模块操作和 transition relation；不放 Assertion、heap ownership 或 critical token。
- Rules/Critical 文件：STS、token、assertion carrier、OutsideCritical/InsideCritical、RTrans/GTrans 和 IRQ acquire/release 规则。
- Predicates/Rep 文件：C 对象、字段、数组、容器和模块 heap ownership，以及 pure state 到具体内存的解释。

若项目已有统一 CRTOS protocol，引用已审阅协议，只把当前模块适配保留在独立 rules/critical 层。

## Predicate 参考

开始新写或修改 CRTOS predicate 前阅读 [CRTOS predicate 经验](predicate-experience.md)，只采用与当前 C 形态和控制流相符的条目。

需要查看已有 CRTOS 定义时，直接检查 `/home/xinra/crtos/lib/`，并先分类为 example-only、reviewed-interface、proved 或 user-approved trusted，不能仅凭目录位置当作可信结论。
