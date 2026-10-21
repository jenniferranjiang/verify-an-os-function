> 当前范围更新：CriticalAreaLock/UnLock 已改为 trusted spec，当前七个实现目标及自检结果见 [spec 设计](spec-design.md#trusted-临界区接口调整)。下文为旧 revision 的历史记录。

> 2026-10-21 更新：用户已要求移除中断状态建模。以下为修改前 r1 的历史记录，其中审阅通过和检查结论不适用于当前版本。当前修改及检查见 [DCHG-20261021-01](design-changes/2026-10-21-1-remove-irq-state.md)。

# 独立 Spec Review

结论：**review-passed**。

固定 spec revision：`spec-r1-7f4d155c90f7`，完整SHA256 `7f4d155c90f7d5b8219a0b52b7221443b19a9de69dff7591f3c81b1de634a224`。固定 predicate revision：`predicate-r1-8a944cddeb13`，已由独立predicate review通过。正式审阅对象为 `checks/spec-r1-manifest.json` 中九份canonical C、`logic.h`和`slice_types.h`共11文件。审阅结束独立重新核对这11文件、predicate的29文件及14个权威源码/配置hash，全部匹配。

Reviewer：C analysis agent；未编写或修改predicate/spec。已完整阅读当前spec-writing-guide与spec-experience，直接逐份阅读正式contracts及其引用的predicate/program，并对照本轮源文件和配置。结构脚本作为证据辅助，不替代下述语义审查。未读取历史trial。

## 闭包、类型与源码等价性

从 KSemaphoreCreate 重新跟随wrapper dispatch、直接calls和宏展开，共9个非trusted symbol：KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock、IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。每个恰有唯一同名canonical文件、一份完整active body和完整With/Require/Ensure。19条去重直接调用边均有caller-local declaration-only contract；非trusted副本与canonical完全一致。唯一trusted集合恰为批准的6个symbol，全部出现完整caller-local contract，无新增trusted或未解析dispatch。

手工确认宏依据：done为static且create槽固定；KDEBUG_NOT_IN_INTERRUPT在semaphore.c覆写为空；xs_kdbg.h强制debug使NULL检查保留；KDBG_IPC=0使成功日志的两个KPrintf运行时不可达。切片保留所有NULL诊断及while(1)，没有将源码宏失败分支抹掉。KPrintf的原行号31、64、65、110、111和59已由#line保留，__FUNCTION__/__func__仍为同名函数。static helper变为slice外部函数、static nest变为同一对象的extern引用、常量及IRQ宏展开、dispatch解析均有源依据，无算法或副作用改写。

`slice_types.h`保留实际访问结构的完整自然布局，未缩减offset；x_malloc/x_free/KPrintf原型直接与权威headers核对。原header及切片header的独立ILP32 ABI静态断言均通过。九份C通过GCC ILP32语法/告警检查。`SpecVocabulary.v`实际coqc检查41项逻辑类型及printing映射，包含MonadErr.M、safeExec和ret，并复用已通过编译的predicate依赖。这里没有运行QCP parser，因此不声称已通过后续实现工具前端；当前设计阶段所要求的人工结构、类型和源码等价性检查通过。

## Contract 语义检查

| 函数层 | 本轮核查结论 |
|---|---|
| KSemaphoreCreate / _SemaphoreCreate | 参数范围只重述uint16；入口显式OutsideCritical及safeExec，未要求IRQ开启、ISR计数为0或ID未满。两出口均归还OutsideCritical、同一continuation并恢复保存mask；成功ID为0..127，失败仅-5。具体创建effect由固定program表达，未误返还已发布对象ownership。 |
| CriticalAreaLock | 真实Disable契约将outside转inside，交出os_inv与nest0，返回入口真实mask；C写nest1且返回该值。锁前观察允许rely变化。无计数溢出隐藏假设。 |
| CriticalAreaUnLock | 入参绑定取得锁时保存的mask；Require为inside、提交后os_inv和nest1。真实C降到0，Enable按相同mask归还协议和资源。源码的条件分支完整保留，在该调用闭包状态下真分支可证。 |
| AllocId | manager谓词提供字段、bitmap、范围及桶不变量。首字节/首零位扫描得到最小空闲ID，allocated-unlinked包含该关系及只更新bitmap的资源；失败full且完整返还旧manager。一般idmax不整除8时尾位保护同样准确，未无依据加128前提。 |
| IdInsertObj | 从实际零私有ID节点出发；分配失败不写节点并返还原manager与ZeroIdNode；成功写ID后由InsertObj将ID字段及link资源转移到manager，返回最小空闲ID。私有padding和对象其余部分留在caller frame。 |
| InsertObj | allocated-unlinked与AssignedIdNode描述实际内部状态；hoffset非零由manager不变量提供。零桶先初始化，既有空/非空桶直接插入；Ensure准确变为新增ID节点的manager，不错误要求outside。 |
| InitDoubleLinkList | NodeStorage提供两指针槽且非零；两次赋值建立自环，未取得额外对象字段。 |
| DoubleLinkListInsertNodeAfter | 最小cut拥有head.next、next.prev及新节点两槽；四次写与Ensure顺序/结果一致。head==next空链合法，未假设两者不相等；不触达的槽留在frame。 |

所有量化逻辑参数在调用点给出真实绑定。wrapper传相同sg/before/X；Lock取得的exists locked用于当前manager和失败/成功Unlock；成功Unlock的after只替换semaphore分量；两个DLL调用的next分别由真实旧bucket/global list得到，oldprev/oldnext=0来自刚清零的新link。局部ID/list辅助函数无需再次要求outside，临界区token和其他模块通过frame保留。

## Trusted 保证和每条路径

- x_malloc只用于32字节：NULL分支emp，成功完整SemaphoreRaw。调用前后的outside协议作为frame保留；未读取其实现。
- memset仅此完整对象清零：c=0、n=32，消费Raw返回同dest和完整Zero；包含padding。
- x_free仅失败路径：消费完整Zero，返回emp；此时IdInsertObj失败保证节点和manager均未改动，且对象未发布。free在临界区内发生，inside/os_inv/nest通过frame保留，随后真实Unlock恢复中断和资源。
- Disable/Enable按已批准语义保存、关闭、恢复实际PRIMASK并取得/归还资源；mask允许0和1，未扩大成IRQ必然开启。CriticalAreaLock/UnLock保持非trusted并有完整body。
- KPrintf为批准的emp→emp，不修改受验证状态；包括实际入口不可达的NULL诊断与常量false日志调用，均已纳入审阅。

分配失败在临界区外立即返回，不伪造锁内观察；ID后续失败清零对象完整释放、共享操作自身不变；成功先注册ID再初始化value/pend并插入管理链，在inside期间允许局部尚未完全发布的状态，解锁前恢复全部模块不变量。旧semaphore对象、等待任务及其他全局模块不被本次创建修改。解锁后环境可以运行，spec没有承诺调用者仍持有新对象或ID永远有效。

NULL诊断的非终止分支在本入口闭包中由有效manager/成功分配对象资源排除；保留源码分支和trusted日志契约并不额外将无效NULL调用纳入本次范围。AllocId循环和其全部return路径均已检查；当前配置没有丢失的真实blocking path。

不存在影响scope、effect、ownership、frame、依赖一致性或源码等价性的已知阻塞项。此结论仅完成设计和审阅；未运行symbolic、VC、verification-orchestrator或C实现证明，也不表示KSemaphoreCreate已经验证。
