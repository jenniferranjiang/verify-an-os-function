> 全局整合后的位置：Init/DeInit/Peak在annotated_C/src/kernel/dataqueue；Push/Pop在annotated_C/module_context/dataqueue；已批准的_Obtain副本在annotated_C/module_context/semaphore。下面的早期阶段描述和hash保留为源码证据，当前状态见function-status.md及integration-review.md。

> 本文保留源码分析与修复复核证据，以下日期段落按当时状态理解。当前文件位置及待处理事项见 [设计说明](design.md)、[源码变更](source-changes.md) 和 [错误报告](source-errors.md)。

# 副本源码修复独立复核

初次 Push/Pop 审阅者：C analysis agent（非其补丁作者）。后续 Init/DeInit/Peak 补丁由同一 C analysis agent 编写，独立复核改由 main 执行，不能把该 agent 的自测当作独立审阅。本记录是 C 修复复核，不是 predicate/spec 审阅，不表示实现已获形式化证明。依据用户授权只修 trial 副本，以及当前更新后的 SKILL、reporting-guide 源码问题门禁和源代码处理规则。

## Push/Pop 修复结论

**所报 timeout 缺陷在验证副本已修复，原源码缺陷仍存在。** 本轮审阅 revision：

| 文件 | SHA-256 |
| --- | --- |
| `annotated_C/module_context/dataqueue/PushDataqueue.c` | `31d2a1e65c031bcdbc824457fc007083b2a1b4c3c1266b85dd08ae56b88e87b8` |
| `annotated_C/module_context/dataqueue/PopDataqueue.c` | `fab095b76f466969a845e1b48688de69e5a8729e99a980eeea4e1e137bbe8370` |

补丁完整注释保留原分支，以一次 `KSemaphoreObtain(id, timeout)` 统一处理所有 timeout，返回非 EOK 时立即返回 -ERROR，未访问元素/修改索引，也不 Abandon 对偶 semaphore。成功路径保留原数组、索引和 Abandon 操作。此修改同时避免 WAITING_FOREVER 分支原先忽略 Obtain 失败；并未限定输入只能是0/-1。

独立针对性检查：用 GCC C11 `-Wall -Wextra -Werror` 编译两份副本函数体，以受控 semaphore stub 检查 timeout=-1、0、1、20 的 Pop失败、Push失败、Push成功、Pop成功，共16种情形，全部通过。失败检查包括 Obtain 恰一次、timeout和ID准确传入、无 Abandon、输出/索引/已有元素不变；成功检查包括元素与索引变化和对偶ID释放。测试临时目录已删除。此检查验证控制流修复，不证明完整 semaphore 实现或并发安全；正式契约尚未编写。

## 外部源码变化形成的新门禁（已由后续授权副本修复解决）

审阅时重新读取权威 `kernel/thread/data_queue.c`，当前 SHA-256 为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`，不同于上一轮分析的 `6ff659…`。两份副本来源注释已记录新 hash。当前 Init 的 create 检查变为 `if (!id)`，DeInit 变为 `if (id)`，且 memset 后没有 -1 sentinel 初始化。

必须重新处理实际可达缺陷：有效 semaphore ID 0 被 Init 当成失败，DeInit 又不删除它；负失败值被 Init 当成成功，可能返回 EOK 却持有无效 semaphore ID。源码变化使上一轮“当前已含 sentinel 修复”的结论不再适用。应在用户批准相应副本补丁并通过针对性检查后解除此新门禁；Push/Pop 修复通过不能替代该处理。此为该轮审阅时的状态；现已有用户授权的副本修复及 main 独立复核，当前版本见下方更新。

## Peak 与配置初次结论（Peak已由后续适配解决）

Peak 仍为待查证/待适配事项，未被修改。本函数在锁外检查 front/rear，锁内重新读取 front，不能仅根据已知串口 caller 就推导所有并发调用下检查与读取一致。默认《源代码处理》允许在直接访问共享内存的 callee 内增加最小临界区；把 Peak 的检查与随后槽读取纳入同一临界区，并在两个出口解锁，属于该规则可表达的共享访问保护方案，需要实际副本及一致性检查。只给锁外检查单独加锁再解锁不能解决两阶段观察问题。若不采用适配，也未证明调用上下文排除并发变化，则不能把疑点写成已解决；本审阅不自行修改 Peak。

可以明确采用工程现有 `annotated_C/src/include/xsconfig.h` 作为此次验证配置：启用 DATAQUEUE/SEMAPHORE，未定义 ARCH_SMP 与 ARCH_CPU_64BIT，ID_NUM_MAX=128，与 `lib/common/CrtosConfig.v` 的 CORE_COUNT=1、ID_MAX_NUM=128 一致；TrustBase 已授权64→32位适配。不能宣称已发现对应硬件构建的 xsconfig/.config。原类型 x_base/x_size_t 使用 long/unsigned long，正式编译/布局仍须明确采用 ILP32/QCP32位，不能以64位宿主的 sizeof 代替。

## Skill 冲突状态

当前 spec-writing-guide §4.3 已改为复用依赖 spec 只放 caller 声明及特化、不复制 callee body；本轮此前发现的 §4.3 与 SKILL/maintenance 冲突已解除。此结论仅说明规则文本现已一致，不等于任何导入 contract 的适用性已通过审阅。

## 当前更新：Init/DeInit修复及Peak适配

用户明确批准额外修复 Init/DeInit 的 trial 副本。C analysis agent 从当前 `a8b12c…` 基线提取三份函数文件，实施 sentinel/-1、<0、>=0 修复，以及默认规则允许的 Peak 检查和读取同临界区适配；原出错代码/锁位置保留为注释。Main 独立逐行复核，结论“修复与默认适配合理”。全部副本hash与具体测试结果统一记录于 [source-errors.md](source-errors.md)，避免版本重复。

作者控制流测试覆盖 ID0在任一位置的成功、三处失败回滚、重复DeInit、n=0/n=1和Peak两分支，编译与执行均通过。检查采用两ID均负的失败状态，未假定失败码一律被改为-1；main同时指出并核对了这一性质。具体负失败值在DeInit中保留，供后续predicate/spec忠实描述。

结论：本轮已识别源码问题针对所记录修复/适配副本解除门禁，原源码缺陷仍存在；formal设计和实现证明尚未完成，配置与依赖contract仍需在各自阶段落实。该结论不扩大Init实现闭包，Push/Pop/Peak只供完整模块分析。

## 重新设计时的共享 ID 访问适配复核（2026-11-15）

本次 predicate 作者检查发现 Push/Pop 的 Obtain 实参及 Abandon 实参直接在锁外读取共享 queue 的 semaphore ID。依据当前《源代码处理》的最小共享访问临界区规则，作者在 module_context 副本中增加短临界区缓存 Obtain 的 ID，并在已有数组操作临界区内缓存 Abandon 的 ID；调用本身仍在锁外，timeout 失败立即返回，已批准修复不变。这是规则允许的适配，不宣称对所有并发执行无条件等价，也不单凭缓存排除并发销毁/ID复用；对象使用期间的生命周期条件仍须由设计表达。

Main 独立逐行复核 active 字段访问及锁边界，并用 GCC C11 `-Wall -Wextra -Werror` 编译实际两份函数体，检查 timeout=-1/0/1/20、成功/失败、Push/Pop 共16例：ID和timeout原样传递，Obtain/Abandon在锁外，成功两次锁与失败一次锁均成对恢复同一保存值，输出、索引和失败frame正确。全部通过；临时目录已清理。该检查不是并发或实现证明。此适配事项针对下列副本解除设计前门禁：

- PushDataqueue.c SHA-256 `d794484d28ef1324b2859bea7bec59bb9fcd132a28186a8c0532143a6fea1064`。
- PopDataqueue.c SHA-256 `eaf2bdfb44420f00312c48c00ddd61c88b913d57061dedfbe780b0e82b4ef713`。

原仓库未修改；两函数仍仅为模块分析输入，不加入 Init 实现目标。source-errors 中旧hash是授权缺陷修复基线，当前额外共享访问适配以上述hash为准。

本次额外执行 `gcc -m32 -std=c11 -Wall -Wextra -Werror -fsyntax-only` 静态断言检查，按源码字段顺序和 ILP32 类型：DataQueueType 大小20，front/rear/max_len/base/sem_blank/sem_data偏移0/2/4/8/12/16；DataElemType 大小8，均通过。此检查确认采用的C布局，不替代后续QCP的ABI义务。一次性检查目录已清理。


## 已批准的零超时补丁：待main独立复核（2026-11-16）

用户已明确批准只修本trial的 `_SemaphoreObtain` 等待时间选择：先处理msec=0为wait_time=0，再沿用-1及其余转换。C analysis agent作为本补丁作者创建 `annotated_C/module_context/semaphore/_SemaphoreObtain.c`，SHA-256 `bfd1a4a4fa37af2895ffb7853d8780949f25fb20d0a8b60362e3209c6e120fd3`；原代码完整提取、旧选择保留注释，active body经对照确认仅有批准差异。未修改原仓库、Push/Pop既有副本或其他算法。

作者使用实际新副本body重跑既有最小反例，编译与全部对照通过；结果及限制见[source-errors.md](source-errors.md)“已批准零超时补丁的应用与实际副本测试”。原版timeout0/value0调用Suspend/Delay(1)/Assign，新副本立即返回-ETIMEOUT且不调用三者。可用value、负ID、finite与infinite对照也通过。

**本节是作者检查交接，不是独立审阅结论。** Main需独立读取批准diff和实际副本，复核只改获批选择、正常与失败路径/锁保存值保持，再记录门禁解除。当前不宣称predicate/spec审阅或实现证明完成。

### Main独立复核：零超时副本修复

已独立从当前原semaphore.c提取完整函数，与新副本去注释/空白后比较：仅增加用户批准的msec==0分支，其余active语句保持。测试中fixed函数体与实际新副本逐token一致，main重新以GCC -std=c11 -Wall -Wextra -Werror编译运行，零超时及计数可用/负ID/有限/无限等待对照均通过。源码门禁针对此修复副本解除，可以继续新增predicate/spec；该结论不是实现证明，也不覆盖后续exstatus共享读取适配。
