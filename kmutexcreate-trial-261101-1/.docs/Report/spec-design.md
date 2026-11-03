# KMutexCreate spec 设计

这是 2026-11-01 新实验，仅设计及独立审阅。当前完整规格均在 `annotated_C/src/`，本记录不复制 contract；C依据、宏适配和配置见 [c-analysis.md](c-analysis.md)。审阅结论与精确 revision 将记录在独立 review 文件。

`KMutexCreate.c` 与 `_MutexCreate.c` 是本轮两个实现目标。对外均使用系统 `OutsideCritical` 与 `safeExec`，引用 `KMutexCreate.v` 中的创建操作；返回分支显式区分 -5 与范围 [0,128) 的 ID。内部对象地址由操作关系存在量化；成功发布初始化对象并保留其他 OS 分量。接口不把 manager 字段、bitmap 或链指针逐层暴露给上层调用者。

`_MutexCreate` 的三条真实路径均保留。malloc 返回零时不进入临界区；登记失败时，锁内 manager 保持，解锁后回收原基址的完整对象，返回 -5；成功时初始化空等待链、四个业务字段，头插管理链，恢复完整 `os_inv` 后解锁，返回 ID。调用本身无循环或阻塞路径。锁前环境可推进，因此仅操作关系内保持未修改模块，不能把函数入口与退出的全局状态直接判等。

闭包共有 10 个 symbol，详见 [design-audit.json](../../checks/design-audit.json)：

- 本轮两个 active canonical 函数：KMutexCreate、_MutexCreate。
- 三个 `reused-spec` 边界：IdInsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。两个 DLL 文件保留原 active body 和所有具名 spec；IdInsertObj 从根已存在头文件精确抽取 declaration-only contract。不将它的内部 AllocId/InsertObj 等递归纳入本次实现目标。
- 五个既有信任边界：x_malloc、memset、CriticalAreaLock、CriticalAreaUnLock、x_free。前四个采用根现有接口；x_free 使用已获准 KERNEL_FREE 的实际别名，对同一次分配返回的原始基址实例化 MutexRaw 全对象回收接口。该实例没有新增分配器效果保证，不宣称是原 SemaphoreRaw contract 的已证明推论。

调用者中的 declaration-only contract 与各 canonical 的采用接口一致。DLL 插入选择 `dispatch_case`，将 payload 实例化为 mutex 对象，锚点为 k_mutex_list；保留但不选择已有 `rrr_ready_insert_after`。低层内存原语直接表达其最小资源范围，外层使用模块 predicate。

`IdInsertObj` 失败合同只返回原 manager 与未知值 ID node；因此 abstract 操作不要求“失败必满”，失败回收也不假设 ID node 仍为全零。这是复用接口的明确保证范围。成功仍使用该接口的最小空闲 ID，并由 mutex_context 的容量推出有效返回范围。

所有目标 load/store 都可追溯到 reviewed predicate 候选：malloc/memset 对应36字节数组；ID node 由 manager 接收；pend_list 的两个槽由 InitDoubleLinkList 初始化；四个值字段与 padding 由对象 payload 持有；link 的两个槽在插入前私有、插入后归管理 DLL；旧 mutex、其他模块资源及临界区 token 在这些局部调用间作为 frame 保留。详细字节与中间阶段交接见 predicate 设计记录及 MutexInv.v。

检查脚本 `checks/check_design.py` 从去注释后的真实 active body 重新扫描闭包，比较每个 caller-local contract、原 spec 与导入 spec，并核对两目标及两个保留 DLL body 与权威源码。允许的目标归一仅为删除 debug、固定 dispatch 与 static 外部化；sizeof、全部分支、返回值、赋值和调用顺序保持。脚本还对所有切片执行 GCC ILP32 `-Werror` 结构检查。

`checks/SpecInterfaceCheck.v` 对注解引用的 Rocq 函数逐项检查类型。GCC 不检查 QCP 注释；本轮按技能只做人工注解结构审阅和 Rocq 类型检查，未启动 QCP parser/symbolic、VC 或实现证明。后续 byte/typed 转换和 publication 义务是待证明的设计陈述，不是已取得的证明。

## 源码缺陷与本次边界

用户指出源码问题后补做了模块缺陷审查；详见 [source-errors.md](source-errors.md)。这些问题不能靠放宽 predicate 或选择导入边界消除。递归计数溢出、handle 截断、等待/唤醒语义与删除竞争均不在 KMutexCreate 的直接调用闭包；本轮创建 spec 不承诺整个 mutex 模块的互斥性、删除安全或有限等待性质。若后续验证这些 API，必须处理对应源码缺陷，不能沿用创建审阅结论宣称模块正确。创建操作自身仍需独立核对，不能因闭包外有问题而跳过其返回路径和资源审阅。

调用逻辑参数的实例化依据如下：Lock 的 sg/before 是入口系统参数；IdInsertObj 的 sm 是 sg.os_mutex_stable.mutex_manager_stable，m 是加锁取得状态的 mutex_manager(os_mutexes)；InitDoubleLinkList 使用新对象 pend_list 的两个私有槽；DLL dispatch_case 中 A=MutexAbs，storeA=store_mutex(锁内task map的pure_suspend_sched_link)，nodes 是旧mutex对象的mutex_link_node映射，a=mutex_created(本次地址,id)，head=稳定k_mutex_list。Unlock 的 st1 为加锁观察，st2 为失败时同一状态或成功发布后的replace_mutexes状态。malloc/memset参数是sizeof(Mutex)=36，free 使用本次malloc原始基址和完整MutexRaw。proof-local见证提取、展开与重新组合留待用户另行授权的实现阶段，本次不会执行这些证明。
