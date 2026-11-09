# KMutexDelete 的完整调用闭包规格设计

> 历史 r1 记录；active closure 与指针接口已由 `predicate-spec-r2.md` 取代。当前 active `annotated_C/src` 仅含 3 个实现目标。

候选版本由 `../checks/spec-revision.json` 固定（S2）；Rocq predicate 固定为已独立 review-passed 的 `kmutexdelete-predicate-r1`，SHA-256 `7a4fe9106548d5f07aca0fa278e182b37535b9d346654e7c4d30ae041da63d50`。正式 With/Require/Ensure 唯一来源是本 trial 的 annotated_C/src 文件，本文不复制合同。

## 范围与调用边界

从保留原临界区位置的 KMutexDelete 重新人工扫描，闭包为12个 symbol：3个新设计函数、4个 reused-spec 边界、5个 TrustBase/模型边界。没有未解析分派、未处理可执行宏或新增 trusted 业务函数。

| symbol | 分类 | 正式位置与适用场景 |
|---|---|---|
| KMutexDelete | 新设计 | `annotated_C/src/KMutexDelete.c`，assumed_environment；负ID、未命中、命中三路径 |
| _MutexDelete | 新设计 | `annotated_C/src/_MutexDelete.c`，assumed_environment；真实锁外drain，独立注销临界区，锁外释放 |
| LinklistResumeAll | 新设计 | `annotated_C/src/LinklistResumeAll.c`，mutex_waiters_oc；保留原自身锁。与root semaphore_waiters是不同调用场景，不作为其推导特化 |
| IdGetObj | reused-spec | 同名active canonical；读取manager，允许lazy空桶初始化，ID值按uint16截断 |
| IdRemoveObj | reused-spec | 同名active canonical；caller选择low_level_spec，保留原high_level_spec |
| DoubleLinkListRmNode | reused-spec | 同名active canonical；caller选择remove_member，原5个具名spec均保留 |
| KTaskWakeup | reused-spec | 同名active canonical；caller选择wakeup_by_id_ic，原3个具名spec均保留 |
| CriticalAreaLock | TrustBase + A1/A2指定环境合同 | 根查询用ordinary；ResumeAll用mutex_live；注销用mutex_drained；本地declaration中完整列出 |
| CriticalAreaUnLock | TrustBase | 各caller的stable合同完全相同，交回更新os_inv，保留caller私有退休对象为frame |
| CONTAINER_OF_MUTEX_ID | TrustBase CONTAINER_OF模型 | KMutexDelete本地declaration；只做地址转换，不给对象字段权限 |
| CONTAINER_OF_TASK_SCHED | TrustBase CONTAINER_OF模型 | LinklistResumeAll本地declaration；只做地址转换，字段权限来自os_inv |
| x_free | TrustBase KERNEL_FREE模型 | _MutexDelete本地declaration；`xs_memory.h:52-53` 将KERNEL_FREE映射到x_free；消费原分配基址完整MutexRaw |

复用边界内部 GetObj、FreeId、RemoveObj、GetTaskWithIdnodeInfo、_KTaskWakeup 已在保留的active文件中给出原完整callee合同；它们不是本轮新增实现目标，不继续递归展开。来源revision与等价适配详见 reused-spec-imports.md。所有call的合同按canonical选取，调用处明确spec名称及已知逻辑参数；依赖当前展开资源的剩余ghost参数留实现阶段推断，不以未写证明注解冒充证明完成。

## 环境假设如何进入正式接口

用户授权的A1/A2见 source-review.md。CriticalAreaLock 的 mutex_live/mutex_drained 只允许在本次删除链条的两个特定窗口使用，是用户批准的环境限制，不是 ordinary spec 的逻辑推论，不能无条件推广到其他caller。它们只在再次加锁时取得同一p/ID以及必要的空等待链事实；仍交接原共享 InsideCritical/os_inv，没有另建锁token或改变全局RTrans。

KMutexDelete.v 的 scoped atomic 使用相同guard过滤观察，nrm/err都采用相同范围；lookup仍用普通task_atomic_cmd。程序保留查找、drain、注销三个临界区，未将它们伪装成一个原子操作。A1还排除释放后同地址/ID重用；这一整个区间的分配身份保证来自用户假设，而不是仅靠端点p/id相同推导。

drain以实际取得锁时的等待序列为准；lookup后的环境仍可改变队列和标量。排空后到注销期间A2仅禁止新入队，holder/val/递归计数等仍可变，退休对象使用最后注销临界区的当前值。其他模块在环境步骤可变化，每次锁内操作自身的frame由精确状态替换及os_inv资源保持。

## 路径、内存和资源交接

- 负ID路径完全不加锁，抽象ret不加入环境观察；非负值由真实uint16调用转换为低16位，没有加强顶层id范围。
- 未命中解锁返回，共享集合不变；允许ID懒桶初始化，不承诺失败分支所有具体字节未写。
- 命中后解锁只持有OutsideCritical及历史登记事实，A1通过下一次具名Lock合同提供当前登记和资源，历史指针不当作锁外读写权限。
- ResumeAll的循环读当前头，写首task.exstatus=-ERROR，再调用复用wakeup，逐轮移出sched_link、取消delay并插入READY。整体effect保留等待顺序导致的RRR插入效果、task其他字段和未修改模块，不只说“链空”。循环连接及合法前态非真空义务写为类型检查过的Prop，不作为已证明引理。
- NULL检查的非返回路径在两个helper切片中保留；实际目标成功查找与模块内存表示排除这些调用处NULL。未增加顶层业务前提，也未删除原死循环。
- 最后锁内读mutex.id.id、注销ID并摘管理link，ID节点与两条外部link转入私有MutexRetired，pending必须为空。剩余全局资源重新组成os_inv；退休对象独立frame过Unlock，转换成MutexRaw后交给x_free。holder仅为指针值，不拥有被指任务。
- 源码没有DO_KTASK_ASSIGN，因此本设计不新增调度调用，也不承诺函数出口所有原waiter仍为READY（drain解锁后的环境可推进任务）；批量READY/-ERROR是drain自身的效果。

## 检查与后续义务

7个active C文件、共享ABI声明通过普通GCC的ILP32语法检查；Mutex尺寸36及各字段offset通过static assertions。逻辑头声明的100项签名通过真实Rocq接口类型检查。详见 `../checks/design-checks.json`。GCC忽略规格注释，这不等于QCP parser验收；本阶段按用户要求未运行QCP任何实现验证工具。

Rocq定义编译、独立predicate review与完整spec review各自记录。所有新增效果/资源桥是设计陈述，C实现、循环保持、资源展开恢复和具体caller组合证明均尚未执行。A1/A2不替代这些义务，也不把复用/信任边界算作本轮新证明。
