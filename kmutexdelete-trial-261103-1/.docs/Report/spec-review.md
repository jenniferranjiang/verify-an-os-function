# 完整调用闭包 Spec 独立审阅

结论：**review-passed**，仅在用户批准的 A1/A2 环境假设和既有 TrustBase 适配范围内成立。审阅者 `/root/source_review`，规格作者 `/root`，日期 2026-11-03。本次未编写或修改任何正式 spec/predicate，仅审阅并记录结论。

固定 spec revision 为 **`S2-19632ed3e5482b4086f38e90555d504a40f14a9eb89a23fc04ccf5d377ad4271`**，7 个 C 文件及两个头文件的逐文件 SHA-256 见 [spec-revision.json](../checks/spec-revision.json)，已与实际文件重新核对。固定 predicate 为已独立通过的 **`kmutexdelete-predicate-r1`**，`lib/KMutexDelete.v` SHA-256 `7a4fe9106548d5f07aca0fa278e182b37535b9d346654e7c4d30ae041da63d50`，见 [predicate-review.md](predicate-review.md)。所有合同固定引用这一版本。

已完整读取 skill 的 spec-writing-guide/spec-experience、上述正式文件、依赖 predicate、[spec-design.md](spec-design.md)、[source-consistency.md](source-consistency.md)、[reused-spec-imports.md](reused-spec-imports.md)、源码及用户假设。S1 到 S2 的两个改动均为 `LinklistResumeAll` 返回注释中 EOK→共享 Rocq KOK（定义为 0）；canonical 与 `_MutexDelete` 的 caller-local 同步，C 的 `return EOK` 未改，故语义保持。旧导入 GetTaskWithIdnodeInfo 的 KNONE→0 也符合 C 的 NONE 零指针分支，没有引入假常量。

## 范围、来源与接口一致性

重新逐文件人工读取实际调用后，根可达边界恰为 12 个 symbol：3 个新设计函数 `KMutexDelete`、`_MutexDelete`、`LinklistResumeAll`；4 个 reused-spec `IdGetObj`、`IdRemoveObj`、`DoubleLinkListRmNode`、`KTaskWakeup`；5 个模型/TrustBase 边界 `CriticalAreaLock`、`CriticalAreaUnLock`、`CONTAINER_OF_MUTEX_ID`、`CONTAINER_OF_TASK_SCHED`、`x_free`。没有未解析 dispatch、裸执行宏、漏调用或重复分类。

7 个实现输入均有唯一同名 active canonical 文件和真实完整函数体。模型接口为 caller-local declaration；两个 header 只存 ABI/逻辑词汇，不集中定义函数规格。根 IdGetObj/IdRemoveObj 与 trial 逐字一致；DLL 的五个、Wakeup 的三个原具名合同均保留，caller 选择项与 canonical 对应完整合同一致。复用边界内部 GetObj/FreeId/RemoveObj/GetTaskWithIdnodeInfo/_KTaskWakeup 继续保留原 caller-local API，不递归扩张为本轮实现目标，也未将边界称为本轮新证明。

Mutex 的 LinklistResumeAll 是本次独立的锁外场景：保留自己的真实 Lock/Unlock，不能从根 semaphore_waiters 锁内合同直接推出。它使用通用 KTaskWakeup 边界，未把 semaphore 专属效果改名后当作已验证保证。

done 表静态初始化到 `_MutexDelete` 的解析、NULL 宏保留死循环并移除调试输出、nested critical 仅在实际锁内复用函数适配、32 位与事件位域布局转换，均有权威源码、配置或 TrustBase 依据。查找、drain、注销三个原临界区边界没有移动；权威 C 未修改。源码与 ABI 的具体依据及版本沿用 source-consistency.md，该记录与本次逐文件审阅相符。

## 参数、路径与可调用性

KMutexDelete 的 signed int32 入参没有无依据加强为小于 65536；原负 ID 直接返回，其余查询按 uint16 转换为低 16 位。缺失 ID 路径先解锁再返回；查询 lazy bucket 初始化允许具体字节变化，抽象状态不变不等于字节不写。命中路径保持三段真实操作，公开 void 结果与抽象 unit 对应，同一个 continuation X 和 OutsideCritical 贯穿入口/出口。

helper 的非空/已登记条件来自实际成功查询，ResumeAll 的 list 与对应 pending 哨兵关联；没有仅凭非空指针声称持有对象字节。NULL 检查的非返回控制流保留，但从本次调用点的已登记对象与合法布局可排除 NULL，未借此删掉目标的合法路径。LinklistResumeAll 的返回值明确为 KOK=0，循环正常终止以实际空等待链为条件。

两个具名 Lock 模型仅在本次删除调用链的指定窗口可用。A1 保证同一分配对象在查找到注销期间不被别人删除、回收或复用；A2 保证排空到注销期间无新 waiter。pure 历史关系不自动提供未来事实，也不提供内存权限；当前事实和共享内存在再次 acquisition 时经这个已获用户批准的环境合同取得。ordinary Lock 未被无条件加强，原 RTrans 不改为恒等；无“所有可能状态都保活”的不可满足前提。

safeExec 所引用程序与所选锁合同使用相同 guard，正常与错误关系均限定相同环境；每条合法路径的正常行为存在性已在 predicate review 核对，不利用 guard 排除所有成功执行。A1 的禁止 ABA 仍依赖用户假设，不能从端点地址/ID 相同证明。函数外层 Ensure 没有承诺入口到出口全部 OS 状态不变，也没有承诺 drain 后经过环境变化的任务永远维持 READY。

## 内存、效果与 frame

所有真实 load/store 可追到固定 predicate：查询/注销的 manager、bitmap、ID 节点由 Mutex 的 manager 资源提供；管理 link 由全局 Mutex DLL 提供；pending 哨兵与 task.sched_link 由 Mutex 等待 DLL 提供；exstatus、任务 ID/status 等由共享 Task 资源提供。纯 CONTAINER_OF 地址关系不代替 pointee 所有权。

ResumeAll 每轮读取当前队首，写 exstatus=-ERROR，复用 wakeup 的确切任务、Delay、RRR 插入和来源链更新；在调用要求 os_inv 的 Wakeup 前须恢复与 exstatus 修改相符的不变量。公开效果描述整队处理，逐步关系仅作为后续循环连接义务。跨模块任务关联及调度节点的唯一归属在正式 predicate 的 effect/obligation 中可定位，没有漏掉被更新 task map 对其他模块的关联影响。

最后取得锁才读取当前 mutex.id.id 和退休对象标量。A2 只保持空队列，不冻结 holder/val 等。ID 注销和管理链摘除后的中间资源由 reviewed split/restore 陈述覆盖：剩余系统资源重新形成 os_inv，36 字节对象成为唯一私有 MutexRetired，不与系统重复拥有。Unlock 的共享资源交接不消费这个私有 frame；MutexRaw 转换后以原分配基址 x_free 消费它。没有把已经迁到 READY 的任务节点交给 free，也没有用旧标量快照回填资源。

公开合同保持函数层次：os_inv、对象状态和抽象操作承担整体行为，未把完整 API 降为几十条字段 store。当前 annotated C 不含实现阶段的所有展开、循环 invariant 和 ghost 推断注解；这些后续证明工作尚未执行，不影响本阶段完整合同的可审阅性，也不被伪称为已完成的实现证明。

## 检查与迁移范围

Rocq predicate 编译 exit 0 与固定 hash 已核对。逻辑头 100 个签名的真实 Rocq 检查，以及 GCC ILP32 结构检查/布局 static assertions 均为 exit 0，见 [design-checks.json](../checks/design-checks.json)。GCC 把规格视作注释，因此这些结果不表示 QCP parser 接受，更不表示 symbolic、VC 或 C 证明完成。本次没有运行上述被用户排除的阶段。

审阅后共享合并方案可保持语义：新增根 `lib/KMutexDelete.v`；保存新 KMutexDelete/_MutexDelete 输入及独立 `annotated_C/src/outside_critical/LinklistResumeAll.c` 场景；使用独立 mutex-delete 类型/逻辑头，保留既有 semaphore 锁内版本及原合同。两种 LinklistResumeAll 场景不能混编成同一 C 单元，也不能把本次外锁合同称作旧合同的推导特化。全局库不能依赖 trial 路径；trial 切回根逻辑路径后仍需根项目重新编译和引用检查，审阅副本退出构建。这里只认可迁移方案的语义边界，实际迁移完成与检查结果由 main agent 另记。

在上述固定版本、配置、A1/A2 及现有信任/复用边界内，没有阻塞完整调用闭包 spec 审阅的未解决问题。两份设计审阅通过仍不表示源级并发缺陷已修复或 C 实现已获证明；本轮应结束于设计和审阅，不进入 implement 审批或工具流程。
