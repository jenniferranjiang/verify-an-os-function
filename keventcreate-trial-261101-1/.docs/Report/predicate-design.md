# KEventCreate predicate 设计

本次新设计使用 [C 分析](c-analysis.md)，以 `KEventCreate` 和 `_EventCreate` 为目标，非 SMP、ILP32、小端配置。设计阶段仅编译 Rocq 定义、既有引理与类型化待证义务，不进行 C 实现证明。29个模块已全部编译成功，当前为 `review-ready`，不能据此称函数已验证。

`EventState.v` 保存事件对象地址、ID、options、events 和等待任务基址顺序；固定 manager/bitmap/桶/管理哨兵地址由 `EventStable` 保存。地址可覆盖分配、尚未登记、发布和回收阶段，ID只在登记期有意义。ID集合与每桶顺序从管理对象序列派生，复用 ID 模块的位图与懒桶表示，不建立第二份可变管理器。Done表已由源码证据解析为直接调用，不再占运行时表资源。

## 位域适配与参数范围

权威 `Event` 使用 options:3 和 events:29，共占一个32位字；真实 ILP32 对象32字节。依照 TrustBase 的位域适配，验证切片把两者展开为两个uint32，模型对象36字节，字段偏移由 `EventInv.event_byte_layout` 描述。切片创建写入显式取低3位，抽象 `event_created` 保存输入 mod8，接受整个uint32范围，包括2..7。`store_event` 保留3位和29位的值域。模型布局不是原ABI声明，不可将36字节解释为原对象大小；检查见ABI记录。

新布局仅为显式 `Prop` 条件，没有新公理。零字节到字段与回收合并义务必须在该条件下证明；后续生成器的具体布局/现有信任依据须与ABI检查一致。本轮仅完成这些陈述的类型检查，不把它们当作已证明的转换。

## 资源与生命周期

`EventRaw`/`EventZero` 描述发布前完整模型对象：ID的2字节标量、2字节padding、8字节ID link、两个4字节值、8字节pending哨兵、8字节管理link，共36字节。`memset` 写整个对象，因此padding不能遗漏；当前 QCP struct_padding 不拥有字节，显式padding不与其重叠。

发布后，ID manager独占ID标量和ID link；管理DLL独占Event.link；其payload `store_event` 独占options/events、padding和pending哨兵，并通过公共DLL独占等待任务的sched_link。TaskInv独占任务描述符字段，事件只使用 `pure_suspend_sched_link` 关联相同任务图。任何时刻不把同一link同时交给对象和容器。

创建成功的顺序为：分配私有字节、清零、取得系统不变量、ID登记、保存options低3位、pending自环、管理链头插、归还系统不变量。ID登记与管理链发布之间，完整event_inv暂不成立，由局部资源及精确frame支持；无需发明表示每个程序点的状态类型。

malloc失败没有对象；ID插入失败归还原manager和未知值ID节点，故回收使用EventRaw，不声称仍全零。释放使用本次malloc原始基址，pending任务绝不随Event对象回收。模块静态初始化由 `event_initial_memory` 描述BSS bitmap/16个连续桶以及静态自环管理头，`event_initialization_obligation` 陈述建立空模块不变量的义务，没有额外token。

## 系统组合及 frame

`CrtosGlobState` 加入稳定event上下文和可变对象序列，所有既有record更新均保存event分量；`replace_events`只修改该分量。`CrtosInv` 将event_inv加入共享资源，并把event等待者加入统一sched节点的排他与注册覆盖。现有Task字段资源继续复用。

统一 `CrtosRules` 协议不变；因总状态类型扩展，它和相关空间模块使用同一trial逻辑版本，避免混用两个Assertion载体。`KTaskWakeup` 增加event来源摘链关系，保留events/options；delay-only、已知semaphore队首和detached分支均明确保持event分量。`EventOps`仅定义摘除waiter的模块操作，不将Trigger中的清位混入Wakeup。

函数文件 `KEventCreate` 的 `event_create_frame` 保存借出event模块后的全部其他资源和既有全局良构事实。split、ID派生一致性、空等待链保持全局良构、成功发布restore均有明确待证命题。创建抽象程序的失败分支是-5且不改本次操作状态；不能从复用IdInsertObj规格加强为“失败必满”。成功选择最小空闲ID，头插新对象，保持其他模块。锁外malloc失败直接返回；其余操作经统一atomic command连接LastSeen，不承诺解锁后环境没有继续运行或返回ID始终存在。

## 构建及已有结论的影响

Trial只保存25个需更改逻辑导入/全局类型的既有模块副本和4个新增模块；复制基线保存在 `.baseline/lib`。必要的语义增量仅为Event四文件、CrtosGlobState、CrtosInv、KTaskWakeup；其余副本用于统一类型载体和引用。根库保持不变，待两项审阅通过后由main agent合并。另7个只受导入影响的全局使用者不复制到trial正式库，合并后按根项目配置重新编译。

构建脚本 `checks/compile-design.py` 只调用当前兼容工具链coqc，日志及每文件SHA256见 `checks/compile-results.json`。既有证明仅在实际成功重编译的陈述上保留；本次状态扩展不自动继承过去针对旧完整OS状态的C实现证明。后续审阅须固定当前文件revision，不能把待证 `Definition ... : Prop` 当作lemma使用。

模块其他API的源码问题见 [C分析](c-analysis.md)。创建闭包未发现源码错误，但本模块化设计依赖既有Lock接口提供有效os_inv；没有证明任意事件使用/删除代码均保持该前提，也没有为避开那些问题限制创建options。

Predicate候选revision：`bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca`。各文件哈希见 `checks/predicate-manifest.json`；独立审阅固定此版本。
