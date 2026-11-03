# Mutex 源码缺陷复查（2026-11-01）

这是针对权威 C 的静态缺陷分析，M1/M5另有主机fixture执行见证；未运行真实系统、QCP symbolic、VC 或实现证明，未修改权威 C 或 formal 定义。下列轨迹是源码允许的反例，不把设计审阅通过等同于模块正确性。前次 C analysis 只记录递归溢出与生命周期风险而未明确形成缺陷报告，这一遗漏在此纠正。

以下 `mutex.c`、`ktask.c`、`id.c`、`linklist.c`、`delay.c` 和 `CriticalArea.c` 均位于 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/`。所有轨迹适用于当前 32 位、非 SMP 配置。非 SMP 并不等于不可抢占：`CriticalArea.c:117–137` 的外层解锁恢复中断，随后允许任务切换。并发删除类问题以应用没有额外串行化对象生命周期为条件；源码/API 注释未提供引用计数或该限制。

## M1：递归计数回绕导致提前释放（已确认）

证据：`xs_mutex.h:36` 定义 `recursive_cnt` 为 `uint8`；`mutex.c:95–96` 同一holder递归获取无上限检查；`171–172` 递减到0即执行释放/转交。

最小清晰轨迹：

1. A 通过 KMutexCreate 创建对象，再由 A 连续成功 KMutexObtain 共257次（msec=0也可）。首次获得计数1，255次后255，第256次转回0，第257次变1。unsigned char赋值按模256转换；这里不是依赖未定义行为的推测。
2. A 只执行一次 KMutexAbandon，计数1→0，`191–193` 把 val设为1并清holder；若有等待者则`183–187`直接转交。
3. B 此时可成功获取，而A还有256个成功获取尚未配对释放。递归锁的互斥/嵌套语义被破坏。

使用257次轨迹直接显示“一次释放就过早开放”；256次取得后恰好配对256次释放不是这里的反例。本缺陷无需抢占或错误ID。仅调用create不会触发；由正常create结果加重复obtain/abandon触发。把模块计数允许0只是在忠实建模，不是消除了源码错误。

## M2：查询后解锁，未保证对象存活（已确认的并发生命周期漏洞）

证据：public Obtain 在 `279–288` 查询并保存mutex裸指针后Unlock，`290` 才调用内部获取，内部在 `87` 再Lock、`95` 读holder；public Abandon 同样是 `311–320`，内部`165`读holder；public Delete 是`246–256`，内部`68`开始使用对象。

最小轨迹：

1. A 执行 KMutexObtain(id,0)，查询到对象P，在`288`解锁后被抢占。
2. B 对同一id执行完整KMutexDelete，`70`删除ID、`72`删除管理链、`74`释放P，返回。
3. A 恢复，`290`把旧P传入_MutexObtain，`95`读取已释放对象；重新Lock不会使P重新存活。

同一轨迹把A改为KMutexAbandon产生释放后读取；改为KMutexDelete会在`68`访问已释放pend_list，进一步可能双重释放。即使分配器复用P，A仍可错误操作新的对象（ABA）。源码只检查指针非零，不提供pin/refcount/tombstone或锁跨查找和首个资源接管。是否允许并发delete需要在API contract中明确；不能在创建规格中默默增加“所有调用都不并发删除”来宣称整个模块安全。create直接闭包没有该lookup窗口。

## M3：删除唤醒队列与注销对象之间存在窗口（独立于M2）

证据：`_MutexDelete:68`调用LinklistResumeAll；它在`linklist.c:118–129`内部Lock/Unlock。返回后`mutex.c:69`才重新Lock，`70–74`注销并释放；第二阶段不再清理等待队列。

轨迹：

1. P由H持有。A开始Delete，`68`把已有等待者唤醒完毕，LinklistResumeAll释放外层临界区。
2. A在`68`返回至`69`之间被抢占。C完整执行KMutexObtain(id,正超时或无限等待)，对象此时仍能由ID查到，val仍0，`123`把C挂入P.pend_list，然后阻塞。
3. A继续，`69–74`移除ID/管理链并free P，未再次唤醒C。
4. 无限等待C可永不恢复；有限等待时，`KTaskTimeout:420`从sched_link移除C，需要修改它所指向的已释放P链头，形成释放后写。

这个问题即使把M2的lookup→使用窗口修好也仍然存在；删除必须原子地禁止新进入者，并在同一生命周期保护下处理等待者。create初始化与发布没有此窗口。

## M4：有限超时忽略定时器分配失败（已确认）

证据：`mutex.c:123`先挂等待链，`125–129`对正wait_time调用KTaskSetDelay而不检查返回值。`delay.c:49–53`在task尚无delay对象且malloc失败时立即返回-ENOMEMORY，没有建立计时器。随后`mutex.c:132–134`照常解锁并让出运行权。

轨迹：H持有P；C没有历史delay对象，执行KMutexObtain(id,正的可转换超时)，被挂入等待队列；此次delay分配因内存不足失败；C仍被调度出，既没有计时器，也不返回ENOMEMORY。若H一直不释放，原本有限的等待无限延长；若H很晚释放，C在超过要求的时限后仍返回成功。处理这一失败至少需要回滚挂起/队列状态并返回错误，或另有不失败的定时机制。该错误由obtain触发，不在create闭包。

## M5：int32 ID 隐式截成 uint16，超范围 ID 操作其他对象（已确认）

证据：三个public API参数都是int32，仅在`243/276/308`排除负数；调用`IdGetObj`的位置为`247/280/312`。真实`id.c:122`参数为uint16；`124`的128上界检查发生在窄化以后。

轨迹：P当前ID为0（首次create可得到0）。调用KMutexDelete(65536)，它通过id<0检查，经C参数转换成为uint16的0，查中P并删除。类似KMutexObtain(65536,0)会获取P，KMutexAbandon(65536)可释放调用者持有的P。65536不是本配置合法ID，但源码没有拒绝，而是操作ID0。若caller规范只允许[0,128)，则该范围必须明确；现有public函数对错误ID已有返回分支，不能根据它的int32接口自行假定全部非负值已被外部检查。create本身只返回合法128以内ID，故不由create单独触发。

## M6：被通用唤醒API唤醒后，可能未获得mutex却返回成功（条件明确的跨模块漏洞）

证据：`mutex.c:93`在等待前设exstatus=EOK，`136–147`从调度恢复后只检查exstatus，未检查holder或重新获取。`KTaskWakeup`为公开API（`ktask.c:1066–1074`），内部`488–515`移除挂起节点、撤销delay并进ready，但不修改exstatus、不转交mutex。

轨迹：H持有P，C正在P上等待且exstatus=0；另一任务直接KTaskWakeup(C.id)，C从P等待链移除并恢复，exstatus仍0；C走`139/145/147`返回EOK，但P.holder仍为H。H和C可能同时进入受保护区。若API明确禁止通用wakeup作用于IPC等待任务，这一轨迹可被调用约定排除；目前读取的实现与相关注释没有该约束。应向模块接口明确该限制，或在mutex等待恢复后验证实际获得情况。此项不是把正常Abandon唤醒当成错误：正常`183–187`确实先转交holder再唤醒。

## M7：优先级等待队列顺序与调度器含义相反（已确认，根因在公共LinklistSuspend）

证据：`kernel/include/xs_ktask.h:36` 定义最低优先级为0；当前RR_REMAINSLICE配置下 `assignstat.c:102–112` 以更大的cur_prio更新highest_prio，`assignstat.c:59`按该最高优先级选任务。`assign.c:70`也在ready最高值小于当前任务优先级时保留当前任务，因此排除了“数字越小优先级越高”的另一解释。

但`mutex.c:123`使用LINKLIST_FLAG_PRIO；`linklist.c:54–67`在新任务cur_prio小于已有节点时前插，其结果是数值从小到大排列。`mutex.c:178–187`从pend_list.node_next直接转交holder，实际首先转交最低优先级等待者。

轨迹：H持有P；优先级10的A先等待，优先级5的B随后等待。B在LinklistSuspend的5<10分支被插到A前面。H释放时，MutexAbandon先把P交给B而不是更高优先级A。两等待者可在H持有期间通过预先就绪/阻塞安排依次进入，无需SMP。两者按相反到达顺序也会得到相同升序队列。这违反LINKLIST_FLAG_PRIO所表达的优先级唤醒意图，并与本系统实际调度优先级相反。它不同于代码明确停用的“优先级继承”功能；即使不实现继承，等待队列的排序仍然反了。

根因位于公共LinklistSuspend，MutexObtain调用该排序，MutexAbandon消费队首。该函数不在KMutexCreate可达闭包，create单独不会触发。本项是静态源码反例，未声称真实OS运行复现。

## 对KMutexCreate本轮设计的直接影响

没有在create本身的三条路径上确认上述缺陷：malloc失败不发布；IdInsertObj失败路径解锁并回收；成功路径在同一临界区内完成ID加入、等待链初始化、字段赋值、管理链加入，最后才Unlock。尽管ID先加入再初始化payload，当前非SMP外部观察者不能在此临界区中途查到半初始化对象。不能为了迎合缺陷预期把这一顺序误报成竞态。

Create成功返回后可能发生其他线程合法删除，属于并发API的一般返回后环境演进；它本身不证明M2窗口安全，也不自动构成create内存错误。

这些模块缺陷要求设计报告诚实限定结论：本轮predicate/spec的review-passed只是对create及复用边界的设计审阅；不能声称Mutex模块实现已正确。涉及全部模块生命周期的predicate不得加入计数不溢出、只由Abandon唤醒、对象无限存活等源码未保证的无依据不变量。若当前系统rely保证排除了这些反例，应标出它依赖的外部调用约定，而不能把它当作已由权威C建立的事实。未建议通过新增trusted symbol回避这些问题。

## M1/M5 的可运行见证

`checks/source-bugs/witness.c` 包含从权威mutex.c逐字提取的三个真实函数体 `_MutexObtain`、`_MutexAbandon`、`KMutexObtain`。`extracted_mutex_functions.inc` 的三块均重新检查为原文件的连续子串，3/3通过。没有修改这些body。主机fixture提供最小对象、Task和外部函数stubs；未走的等待/调度分支直接assert失败，禁止它们悄悄改变本次见证。`IdGetObj` stub保留真实uint16签名，并记录实际收到的参数。

编译与运行 exit 0，无编译诊断：

```
gcc -std=c11 -Wall -Wextra -Werror -fno-builtin kmutexcreate-trial-261101-1/checks/source-bugs/witness.c -o /tmp/kmutex-source-bugs-witness
/tmp/kmutex-source-bugs-witness
```

输出：

```
A successful obtains=255 recursive_cnt=255
A successful obtains=256 recursive_cnt=0
A successful obtains=257 recursive_cnt=1
A releases=1 outstanding_successful_obtains=256 val=1 holder=NULL
B obtained successfully while A has 256 unmatched obtains: premature release witnessed
KMutexObtain(65536,0) passed id=0 to uint16 IdGetObj and returned EOK: ID alias witnessed
```

执行日志及原文件SHA256保存在 `checks/source-bugs/run.log`。这是原函数体在明确stub环境下的反例见证；主机fixture没有声称重现真实调度器、完整系统ABI或证明OS性质。M2/M3/M4/M6目前提供静态执行轨迹，没有把它们列为已在真实OS执行复现。

额外接口核对：`kernel/include/xs_ktask.h:190–192` 普通公开声明SuspendKTask/KTaskWakeup/KTaskTimeout，无“不得唤醒IPC等待者”的注释；`ktask.c:482–487,1059–1065`也仅称恢复任务，未给出该排除条件。
