# 新实验完整闭包 spec

Predicate `P-261019-2-r2` 已独立 review-passed；spec `S-261019-2-r1` 已独立 review-passed，结论见 [spec-review.md](spec-review.md)，文件哈希见 `checks/spec-revision.json`。用户要求删除根 `lib/SemaphoreInv.v` 并重新实验；该文件已删除，本轮从当前源码新建 `lib/semaphore.v`，未读取或恢复其他 trial 或被删文件。其他根共享库仅按本次用途检查复用，候选保存在本 trial。

正式 contract 位于 `annotated_C/src/<symbol>.c`；各 caller 中被调用者的完整 declaration-only contract 与非 trusted canonical 同步。`include/logic.h` 仅列 Rocq 词汇，`monad.h` 参考根 annotated_C 的通用接口，不放函数 spec。没有模块级 specs.h，也没有 declaration-only 冒充非 trusted 函数完成。

从 KSemaphoreCreate 重新核对闭包如下；源码和宏证据见 [source-analysis.md](source-analysis.md)。

| Canonical symbol | 直接 callee |
|---|---|
| KSemaphoreCreate | _SemaphoreCreate |
| _SemaphoreCreate | x_malloc, memset, CriticalAreaLock, IdInsertObj, x_free, InitDoubleLinkList, DoubleLinkListInsertNodeAfter, CriticalAreaUnLock, KPrintf |
| CriticalAreaLock | DisableLocalInterrupt |
| CriticalAreaUnLock | EnableLocalInterrupt |
| IdInsertObj | KPrintf, AllocId, InsertObj |
| AllocId | KPrintf |
| InsertObj | KPrintf, InitDoubleLinkList, DoubleLinkListInsertNodeAfter |
| InitDoubleLinkList | 无 |
| DoubleLinkListInsertNodeAfter | 无 |

共9个非 trusted canonical，6个且仅6个 approved trusted。后者不分析函数体，caller-local contract 遵从用户语义：malloc 对本次32字节对象给出 NULL 或完整未初始化 owner；memset 清零全部对象并返回 dest；free 消费完整清零未发布对象；IRQ 两个原语保存/关闭/恢复真实 PRIMASK 并按同一全局协议转交资源；KPrintf 为 emp 到 emp。CriticalArea 两个包装保留真实 active body，不列 trusted。

顶层有三种可直接读出的资源入口：IRQ开启且尚未取得共享投影；IRQ已关且尚未取得共享投影；已经在临界区内的嵌套调用。后两种都使用精确当前状态，但只有真正嵌套的调用者原本拥有 `critical_projection` 与计数槽。前一种允许环境在取锁前推进，因此采用状态集合与 LastSeen。没有把 saved=1 当作已有投影的证明，没有增加线程上下文、初始计数为零、计数不得65535或系统为空的 Require。

每种入口都分别覆盖返回 -5 和返回合法 ID 0..127 的分支。malloc=NULL 路径不虚构加锁；ID 耗尽路径先消费仍为完整zero的私有对象再unlock；成功路径完成最小空闲ID登记、value写入、空pend_list建立和管理链头插。嵌套时保持原anchor及更新后的投影，计数关系区分未加锁失败与已执行uint16++/条件--，包含65535→0→0。其余全局纯状态通过 `semaphore_publish` 保持；未触达物理资源保留在稳定heap frame。

lower contract 的内存与行为对应如下：

- `AllocId` 使用 manager predicate，失败保持原manager，成功给出最低空闲ID及已置位未挂桶的中间态。两个真实 -1 return 均保留，包括通用manager的尾部越界路径。
- `IdInsertObj` 使用精确 `store_private_idnode` 快照。失败返还原id/prev/next；成功把这10字节转交manager，padding仍由private remainder保留。因此free失败对象无需凭空假设再次清零。
- `InsertObj` 用 allocated-unlinked manager加未挂node，处理zero bucket初始化和已有bucket两种路径，再恢复完整manager。
- DLL两个原语使用可写的两指针字段，允许未初始化；插入的老链用 `store_dll` 描述。空链的head与旧next同址被允许，不强加三地址互异。上层传入的payload还保留对应对象主体，链插入后统一归管理DLL拥有。
- private32字节经 `semaphore_zero`、`semaphore_after_id`、`semaphore_ready` 到模块representation，ID链、管理链、value、pend与padding没有重复owner。成功unlock后代码没有再load sem。
- CriticalAreaLock/UnLock 的计数读写由 `critical_nest` 中真实全局UShort单元支持；返回的实际mask与逻辑资源模式分别传递。caller-local Enable contract消费包装已递减后的计数资源。

NULL_PARAM_CHECK 的打印及无限循环未删除。ID helper Require 显式允许NULL分支，而 Ensure只描述能返回的非空路径；这是partial correctness，不把无限循环冒称终止。KDBG_IPC日志仍为if(0)下两次KPrintf，语法闭包包含它们。wrapper空宏和固定done分派的归一有当前源码依据。

所有带逻辑形参的callee调用都有 where，临界区调用后用实际存在量 acquired/old_n。ID成功后解锁状态为具名 `semaphore_publish`，失败解锁状态为取锁观察。C函数体未改算法或控制token；`checks/source_slices.py` 去除注释后逐个对照本轮权威源码归一结果，同时核验source/config hashes。`checks/abi-compile.txt` 是实际headers及slice的ILP32布局编译和9文件C语法检查；本机无ARM工具链，不声称执行ARM交叉编译。

本轮全局IRQ协议只允许稳定frame跨IRQ状态变化，当前创建闭包使用的私有对象及其他保留内存都是heap frame；没有向任意限制旧IRQ状态的裸ghost observation承诺frame rule。完整carrier修补与证明依据见predicate设计及其审阅；不是为当前目标额外限制某个合法C输入。

Rocq vocabulary检查脚本只生成Check类型表达式，不运行QCP parser。最终spec审阅必须引用同一份review-passed predicate，核验完整闭包、canonical/caller-local一致性、路径和内存追溯。当前阶段不执行symbolic、VC、verification-orchestrator或C实现证明。

工程配置：根 `.vscode/settings.json` 的 VsRocq 参数已同步当前 trial `_CoqProject`，移除历史 trial 映射，其余编辑器设置保持原值。原根配置备份位于本 trial `checks/editor-settings-before.json`，仅用于恢复设置，不是任何旧 trial 的内容或构建依赖。
