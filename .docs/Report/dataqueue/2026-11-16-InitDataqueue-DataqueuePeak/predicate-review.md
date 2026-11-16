> 本文保留迁移前设计审阅的依据与结论。路径已更新为全局位置；原revision/hash指迁移前输入，不能直接作为当前全局编译或实现证明结论。当前整合情况见 [设计说明](design.md) 与 [整合检查](integration-review.md)。

# Dataqueue native predicate 独立审阅

**结论：review-passed。** 当前 revision 为 `dq-predicate-native-20261116-r1`，覆盖29份 `lib/*.v`，包括新增 `KDataqueuePeak.v`。独立审阅者是 C analysis/reviewer agent，不是 predicate/spec 作者。按 trial 相对路径排序串接“路径 空格 文件SHA-256 换行”重新计算，联合 SHA-256 为 `36ddb2be676b077b06232a36527fa967dd248a4f6a1c082dc1fa9e62958e8842`，与冻结值一致。

这是对当前统一 native 候选的完整审阅，不沿用已撤回 HeapBridge 方案的通过结论。检查依据包括当前skill/配置、predicate指南与经验、白名单、源码分析/修复记录、正式29份定义和全局来源文件。29份输入及最后9份受影响文件的 coqc 成功检查、header qualified 名字和显式 native Assertion 类型检查由 main/作者完成，本审阅沿用这些结果，没有重复构建全局工程。

## 共享接口迁移与系统集成

已逐项检查当前采用的全局来源定义。去掉注释/空白后的辅助比较确认72个保留的 Definition/Fixpoint 正文与原定义一致；这只是比较证据，不代替对模块实例与类型的人工检查。实际差异集中在 native module 参数、顶层state参数缩窄及本轮新分量/操作接口。

| 检查组 | 独立结论 |
| --- | --- |
| DLL、NodeSelfLinked、idnode | 原字段、typed/unknown权限、ID bitmap、懒初始化桶、manager、found/allocated/free/remove中间形态保留；纯ID/list类型与操作继续复用全局。泛型payload和结果均属于传入R的同一Assertion。 |
| TaskStatusMemory、KTaskSchedMember、KTaskStackSetup | stat的原字节解码、六个调度标量、完整名字槽、base-info、初始上下文/前缀/尾padding栈资源保留；没有丢失字段或重复拥有sched_link。 |
| TaskInv、ServiceSlotWf | TaskState/TaskStable取代无关总state参数；map-domain、INIT/RUNNING自持、ID地址关联、优先级/对齐/bitmap约束逐项保留。服务任务lookup、entry、null delay、非READY自持及ID节点关联均在，未因缩窄参数遗漏条件。 |
| Assign、Delay、Tick、Exstatus | ready32桶和scheduler字段/table/padding、inactive/active Delay及task对应、tick范围、exstatus范围全部保留；所需map/state/地址由os_inv显式传入。 |
| ISR、Bitmap | 66个IRQ项、manager头与padding、done表及LeaderZeroCount数组仍各有唯一owner；未把函数指针值槽误写为函数规格或忽略真实全局内存。 |
| Semaphore、Mutex、Event | ID manager与管理DLL分别拥有ID/link及payload；值字段、padding、等待哨兵/节点和Event位域范围保持，wait关联来自同一native task map。 |

底层空间定义参数化于QCP的 `SeparationLogicSig` 和 `DerivedPredSig Arch32 LittleEndian`，需要数组时加入对应Store/Array接口；实际模块均实例化唯一的 `InitDataqueueTrial.lib.CrtosRules.Crtos_C_Rules`。没有新增Assertion转换、旧token投影或另一套临界区协议。全局来源中的纯定义继续直接导入，不把同文件内旧空间接口误当成本轮结果类型。

`CrtosGlobState` 在原record直接加入os_dataqueues，所有实际采用的replace函数逐项保留该分量；新增replace_dataqueues只改队列集合。`CrtosInv.os_inv` 在原定义体直接组合native各模块和dataqueue；原scheduler所有者互斥/覆盖及service条件继续存在，没有 `old_os_inv * dataqueue` 外层替代模型。`KTaskWakeup` 的ready/delay更新保持其余原字段和dataqueue，未复制无关wake-up空间接口。

本轮formal中未发现 HeapBridge、OldAssertion、lift_heap、legacy投影、Axiom、Admitted或新Parameter。既有配置/布局及QCP底层假设仍是原依赖，不把这一检查表述成整个工程无假设。

## Dataqueue内存及生命周期

结构20字节的六个字段及偏移6–7的padding、完整n×8数组均有唯一owner。当前QCP struct_padding为emp，显式padding不重复。None槽保留未知存储，Some槽保存已写字段；Pop不清除旧槽，payload指向的内存不属于queue。ready允许n=1零有效容量，不要求semaphore value与队列长度在分离的Obtain/ring/Abandon阶段恒等。

Init私有构造、成功发布、失败解锁后IRQ重入清理和retired状态与已批准副本一致。两次create结果、负失败码保留、n=0分配失败及n=1边界均被表示。共享对象withdraw只描述空间交接，不冒充锁外用户保活；保存地址/ID不排除ABA的限制已明确。

原字节转换、数组分配/回收、退役存储、split/merge、空模块初始化及publish/withdraw陈述与资源形态一致。这些都是待证Prop，不是在设计阶段已完成的证明或可直接使用的事实。

`semaphore_resume_all_ic_effect` 直接使用本轮总record及全局纯resume计算，保持原任务/ready/delay/pending变化。空waiting保持整个状态；非空只改相应分量，semaphore地址/ID与queue集合保持。因此refs/state/frame三项新增queue义务真实可推导；frame只涉及新增queue资源，未隐藏其余任务等变化。导入spec的实际证明状态及native适配义务由spec记录，不借此扩大本轮C body范围，也不声称旧carrier的Qed已经证明当前实例。

## DataqueuePeak专用检查

已对照批准的Peak副本：condition和队首读取处于同一临界区，空/非空两出口恢复同一保存值。`abs_dataqueue_peak_locked` 对空队列返回None，对非空返回当前front元素，并要求after=before；这只表示锁内操作不写共享OS对象，不抹掉加锁前的环境变化。它没有误推进front或改写semaphore/数组。

`dataqueue_nonempty_front_obligation` 可由ready推出：正容量及front/rear合法、二者不等使模意义count严格为正；contents的第一个索引为front，Forall已初始化性质因而给出front槽Some。n=1下front和rear均为0，只能走空路径。这里从纯条件导出值形态，实际读取权限仍来自owned/slot空间资源。

`dataqueue_slot_view_obligation` 的索引范围和nth=Some前提足以应用QCP数组missing_i拆合；两侧保留结构字段、其他槽、对象/数组对齐及完整数组长度。没有把未初始化槽当可读值，也没有引入payload权限。`dataqueue_peak_focus_obligation` 可从os_inv中的成员拆出owned，并以剩余资源和wand原样归还；纯ready/跨模块条件随该精确归还关系保留。

`peak_data_slot`、`peak_length_slot` 分别拥有caller的一个Ptr/UInt输出槽。Some保留已知初值，None允许未知或未初始化值，成功可覆写，空分支保留原表示。它们不混入queue invariant，也不从输出值推得payload所有权。完整C的Require/Ensure及caller声明由main的独立spec review检查，本报告不代替该阶段。

## 白名单与批准边界

默认 `ReviewWhitelist.md` SHA-256 为 `936815c7f167b58e50dc3e4332133bea94146b91cc75b47781100743487313b4`；当前配置没有补充白名单。001适用于本revision的 `dataqueue_peak_entry/abs_dataqueue_peak` 与 `dataqueue_cleanup_entry/abs_deinit_dataqueue`：不因Rely=True下assertS观察要求缺少可满足性/非真空性证明而阻塞。此例外不新增信任，也不免除任何后续VC。

当前predicate没有已知未解决blocker，可据此冻结版本开展独立spec review。待证义务仍须在用户确认两份通过的revisions后进入implement解决；当前没有函数实现已获本轮证明。审阅仅更新本报告，未修改formal/C、全局文件或原源码，未访问禁止的旧trial，未执行QCP/parser/VC。
