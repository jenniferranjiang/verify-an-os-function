# InitDataqueue 共享模块设计

本轮继续 `initdataqueue-trial-261112-1`，按用户授权在原有 CRTOS 库结构中增量接入 dataqueue；只设计和审阅。权威源码仅应用此前批准的句柄修复，见 source-issue.md。正式函数契约仍仅在 annotated_C/src 的真实函数定义和caller-local声明上，本文不复制契约。

## 沿用原系统状态和临界区结构

本轮正式使用 trial/lib/CrtosGlobState.v、CrtosRules.v、CrtosInv.v 的原有文件组织。在原flat `VarGlobalState` 的全部旧字段后增加 `os_dataqueues`，原有局部更新保持该分量，新增 `replace_dataqueues` 只更新队列map。稳定全局类型直接alias根类型，`project_core`仅把旧字段重构成根库原record，`restore_core`回填旧字段并保留队列；没有另建core+queue包装总状态。

未修改的库全部通过外部路径直接引用。正式trial/lib仅七份V：三份真正修改的核心文件，加DataqueueState、DataqueueInv、DataqueueSemaphore、KInitDataqueue四份新模块文件。先前不再需要的27份副本已核对冻结hash后删除；没有用generated副本替代。来源、baseline及实际改动见shared-library-sources.json。KTaskParseInfo仅为常量KOK=0被粗粒度引入，caller契约现等价归约该常量为0，不复制它或其证明辅助。

CrtosRules直接复用根库唯一Assertion carrier、STS和unit token，Inside/Outside通过project_core连接原协议；抽象LastSeen与atomic command使用本轮扩展flat总状态，rely仍允许队列在锁外变化。CrtosInv实际组合 `根os_inv(project_core st) ** dataqueue_inv(os_dataqueues st)`；Lock/Unlock、DeInit的IRQ接口实际借还这份完整资源。其他模块谓词及证明不改名重定义，不重新实例化，其纯command按core投影提升并保持queue map，空间helper在同一carrier内以queue资源为frame使用。

## 完整模块状态及资源归属

DataqueueState.v是纯状态：六个真实字段、两个仅用于保持创建对象身份的Semaphore地址ghost、按DataQueueType真实基址索引的已发布对象map、数组slot和Active/Retiring阶段。ghost map不是新增C全局登记表。Active仅表示已发布且尚未retire；容量0也可以被Init发布，后续取模操作须另满足ring_usable，不把初始化真实结果排除掉。

DataqueueInv.v在同一系统断言模型中用现有store_map唯一拥有全部已发布queue对象及buffer；有限域和唯一地址复用通用map接口，不自创第二套容器。Semaphore的ID/管理链、对象和等待者仍只归原semaphore_inv；队列只引用它们，模块不永久要求句柄对象存活，也不把sem计数等同环占用。因此通用SemaphoreDelete的原操作含义及Obtain/Abandon之间的窗口没有被偷偷收窄。

| C内存 | 初始化/失败回滚 | 发布后的正常运行 | 回收 |
|---|---|---|---|
| caller提供的整个20字节对象 | 初始化者私有Raw/字段view | dataqueue_inv中的唯一map元素 | Retiring暂持，withdraw后返还caller；不free该struct |
| malloc所得8*max_len字节数组 | 初始化者私有，内容未知 | 与同一queue entry组合，slot保存已写入值 | 交给x_free消费原基址及完整分配区域 |
| slot.data指向的外部payload | 外部调用者 | 外部调用者；queue只保存借用指针 | 不由queue释放 |
| 两个Semaphore及共享管理资源 | 原os_inv/semaphore_inv | 同左；通过纯ID/ghost身份连接 | 由原Semaphore删除接口注销/free |
| 其他OS模块、队列entry | 原os_inv | 原os_inv，通过精确frame保持 | 未触达资源返还 |

对象的完整20字节ownership与六个typed字段view使用普通同堆合取，`fields ** TT`保留字段以外剩余字节。不是把Raw与fields分离叠加，也不因只列出18字节字段而丢失memset触及的2字节。数组是连续DataElemType本体，复用store_array；None持有未知8字节，Some持有已知pointer/length，不假设malloc已清零。

模块纯状态根据front/rear派生活动环索引及内容。Push只覆盖rear槽，Pop只移动front且保留stale slot，Peek只读取front；活动区的Some条件支持实际typed load。guarded字段操作和待证valid保持、array missing-index拆/合接口支持共享view的借出、更新及恢复。这些是各API临界区内的局部内存接口，不冒充已完成所有timeout、等待和跨Lock窗口的完整Push/Pop/Peak函数契约，本轮C调用闭包没有因此扩张。背景调用证据及SERIAL_USING_DMA条件配置的限制见shared-source-analysis.md。

## 初始化、发布和失败回滚

KInitDataqueue.v的程序保留完整uint16容量范围、malloc(0)空/非空结果、合法ID 0、失败-5和三个失败点。n=0时blank初始值按uint16转换为65535。只有数组及两个Semaphore全部初始化成功，才在第一次Unlock前把对象和buffer发布进 `os_dataqueues` 并交给 `os_inv`；成功Ensure只返回已发布snapshot关系及OutsideCritical，不再额外返还同一对象/数组的private ownership。

失败对象从未发布；第一次Unlock后仍由初始化者私有持有，DeInit再进入IRQ保护区完成rollback，最后返还struct且数组已释放。各失败句柄实际值分别为(-1,-1)、(-5,-1)、(-1,-5)，不能一律写成两个-1。DeInit只把原非负句柄改-1，原负错误码、front/rear/max_len保持。

两次保护之间允许环境推进，不能合并成一次原子操作或假定共享state不变。原生assertS检查再次观察的合法OS状态仍有创建时同一对象且pending为空；命中默认ReviewWhitelist001，允许Rely=True下全称观察条件的建模妥协，不宣称其正常调用可满足性已证，不改变rely，也不把同ID的替代对象当作原对象。模块inv不自行加入此更强环境假设。

公开模块还提供Active→Retiring→withdraw接口：回收数组及sem期间对象仍有唯一owner，最终withdraw将残余struct内存返还caller。当前DeInit canonical使用本轮根Init实际到达的private init_rollback契约；一般运行时共享销毁的完整C契约和实现证明不在本轮目标中。

## 调用闭包和源码适配

本轮六个canonical函数均平铺且保留唯一active完整body：InitDataqueue、DeInitDataqueue、KSemaphoreCreate、_SemaphoreCreate、KSemaphoreDelete、_SemaphoreDelete。创建/删除包装器按固定done表initializer直接调用目标；已在caller保护区的嵌套Lock/Unlock按技能规则省略。新增IC specs不是旧OC证明已自动覆盖的接口；其真实body供后续独立证明。其他heap-only helper原样使用根库相同Assertion。LinklistResumeAll和KTASK_ASSIGN等涉及原系统state的helper通过CoreVarGlobalState、core_os_inv/core_LastSeen/core_OutsideCritical明确保持根状态域和原合同语义；本轮IC总合同使用扩展VarGlobalState，通过project_core拆出旧资源并frame queue。其连接和待证资源重组不能被称为旧C证明已自动提升。

旧版NULL_PARAM_CHECK按空指针死循环规则替换为既定API，不能使用新版诊断删除语义；对象访问权限来自Raw或共享os_inv。打印按TrustBase去除。IRQ宏展开为DisableLocalInterrupt/EnableLocalInterrupt，同一次保存level原样传回；接口采用相同系统protected-invariant schema在扩展后的os_inv上的实例，不增加硬件寄存器或更强rely结论，也不是从旧固定contract凭空多出queue内存。空map建立、publish消耗private资源、withdraw归还资源的义务明确记录。

完整闭包、调用者与被调用者合同一致性、来源和return/blocking路径见spec-sources.json及独立审阅记录。所有retained调用均有完整With/Require/Ensure；共享lib中的未改动纯状态直接复用。

## 编译与待证义务

布局、字节/字段view、任意slot数组free、typed元素拆合、module初始化/publish/withdraw、runtime纯valid保持均为typechecked待证命题，不作为已证明事实使用。本轮不新增Admitted/Axiom/Parameter。根库既有信任沿用且范围不扩大。C侧ILP32静态断言是布局证据，不是Rocq布局定理。

正式输入七份V清单及直接外部库映射在_CoqProject；Rocq真实编译和逐文件SHA-256记录在checks/rocq-summary.json。C语法及ILP32 ABI静态断言见checks/c-summary.json，全部Extern类型审计见header-type-audit.json。本轮禁止且未运行QCP parser/symbolic、VC、orchestrator、C实现证明或全局库合并。

新库将来目标：DataqueueState.v→lib/dataqueue/DataqueueState.v，DataqueueInv.v→lib/common/DataqueueInv.v，DataqueueSemaphore.v→lib/dataqueue/DataqueueSemaphore.v，KInitDataqueue.v→lib/dataqueue/KInitDataqueue.v。原库副本回到各自来源路径，imports需在真正完成实现后的合并阶段增量整理；当前不执行合并。

当前三份核心trial文件通过导入根原接口保持兼容。未来合并时须保留兼容定义并增量整理imports，不能直接覆盖同名根文件，否则会形成self-import。当前仅完成trial设计和外部库引用，不提前重构根库或承诺直接复制即可完成合并。

三份核心副本目前有意直接引用根库同名模块；其来源路径是未来增量整合位置，不是可以直接覆盖的文件复制目标。日后全局整合必须先保留兼容core定义、处理imports及所有类型连接，避免self-import或把原core API重新解释为扩展状态。若这改变已审阅/证明的接口含义，须重新设计审阅并满足实现及合并门禁。当前用户只要求trial，本轮不开展该全局重构，也不承诺未来可直接复制这三份文件完成合并。
