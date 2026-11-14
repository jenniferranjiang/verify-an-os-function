# KMutexDelete predicate 当前设计

2026-11-10；用户要求调整公开入口后，当前修改版经独立复查为 `needs-fix`，见
[predicate-review.md](predicate-review.md)。旧 combined carrier 与 expanded
Lock 方案已被替换，历史审阅不适用于本 revision。

## 正式输入与复用

本地正式文件：lib/MutexState.v、lib/MutexInv.v、lib/KMutexDelete.v。
直接复用 pinned 全局 provider 的 MutexState、mutex_inv、os_inv、
mutex_create_frame、InsideCritical、OutsideCritical 和 task_atomic_cmd。
没有新的 mutex_delete_inv、锁 token 或锁契约。

根工作区已裁掉 Task/Assign/Delay；本 trial 使用 CRTOS commit
8a16fffe3e029b56de598baa16f43865da85b92b 的完整共享 provider。
匹配 QCP commit 和 module 参数兼容 delta 见 ../../.provider/README.md。
依赖及 delta 随当前 revision 固定，不使用历史残留 .vo。

## 状态和 ownership

对象抽象复用 MutexAbs。mutex_delete_find_addr 跟踪 _MutexDelete 的 C 指针；
内部 ID 仅在调用 ID manager 时取得，不进入该函数公开参数。

ID manager 持有 bitmap、bucket、id.id/id.link；管理 DLL 持有 mutex.link；
store_mutex 持有标量、padding 和 pending 哨兵/等待者 sched_link。
Task descriptor 字段归 task_inv，ready/delay 资源归对应共享 invariant。
os_inv 组合唯一 owner，等待队列只通过纯 task map 关联任务状态。

删除先在一个临界区排空 pending，再在另一个临界区移除 ID 和管理 link。
mutex_delete_detach_callee_post 保留 mutex_create_frame、更新后的 manager/
管理链，返还私有 id/link 和 payload；detach_spatial_obligation 陈述恢复
os_inv after * MutexRaw p 的待证交接。mutex_create_frame 已含 os_world_wf after。
allocator 最后接收原基址的完整 36 字节对象。初始化沿用 provider 的
mutex_initial_memory 和创建接口，本轮从已初始化入口设计，不新增 token。

## 批量唤醒及抽象调用

mutex_delete_resume_all_step 直接描述前后态：目标 pending 清空，任务批量
READY 且 exstatus=-1，取消对应 active delay，按原等待顺序更新 ready。
复用 resume_all_task_map、resume_all_delays、resume_all_ready；replace 链
只更新 task map、delay、ready 和目标 pending，其他全局分量原样保留。
ready 接口保持 RRR 时间片比较、插入顺序、bitmap 和最高优先级缓存。
逐头 mutex_delete_resume_waiters 只供内部循环精化义务。

KTaskWakeup 使用原 wakeup_by_id_ic（os_inv 到 os_inv）；先写 exstatus，
重组 marked 状态再调用。旧局部 wakeup spatial adapter 已删除。
provider ktask_wakeup_step 本身包含 mutex pending 摘链效果。

公开程序：abs_linklist_resume_all(sg, p)、abs_mutex_delete(sg, p)、abs_kmutex_delete(sg, id)。
用既有 task_atomic_cmd 和 monad 顺序记法组合真实临界区，不传 caller 自选 env。
负 ID 返回；非负按 uint16 查询，未命中返回，命中删除；NULL 阻塞由 C spec 单列。

## 执行范围与非真空性

本次接口修订按 MsgQueueDelete/Pendlist 的原生 checked 方式：对象关联留在
program 的 entry_condition 内部，assertS 在实际 atomic 操作前检查，公开 C
规格不量化 obj，也不在 Require 重复对象查找。非空检查沿源码 NULL 阻塞语义
用 assume 过滤不正常返回路径，存在性与空 pending 则用 assertS，不能冒充阻塞。

这是语义修订，不能沿用旧 program 的 review-passed。当前 Crtos_RTrans=True，
LastSeen 的状态集合为全集，新的 checked 条件要求所有可满足 os_inv 的观察都
含同一目标对象（detach 时还须为空）；文档中的 A1--A3 没有实际限制该集合。
独立复查确认尚缺成功路径的可满足性依据，不能用编译成功或参考工程采用同样形式来替代。

A1--A3 已获用户批准：排除并发释放、排空后新 waiter、其他使用者裸指针跨越
回收。这是条件化执行范围，不由宽松 Crtos_RTrans 推出，也未加入 Lock post。
相应存活/空队列事实只能在该范围内使用。非空 _MutexDelete 指针必须属于
已发布对象域；未知任意指针不在合法域。

pure relation 只描述正常后继，无后继不能被当成安全/终止证明。
mutex_delete_resume_nonvacuity_obligation 要求完整 os_inv 和已发布对象域上
存在批量后态；有限 pending、waiter SUSPEND/登记、ready 字段、delay 分区
来自完整空间 invariant，不能仅由 os_world_wf 代替。
查询由 option 查找总定义覆盖命中/未命中；空 pending 的 detach 用
replace_mutexes 直接构造后态。所有 *_obligation : Prop 都是待证陈述，
不是公理、Admitted 或可调用 lemma。

## 当前修订的检查记录

接口修订后，QCP 依赖、本 trial 的 provider 和三个本地 Rocq 文件实际重编均成功
（exit 0）；全部 Extern 及新增 checked 条件的显式类型检查也成功（exit 0）。
这只确认类型及构建一致，不能消除上述可满足性缺口。
重跑顺序（当前 trial 根目录）：

1. 在 .provider/qcp-08a84f/Rocq 中执行
   `make COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/ -j4 SeparationLogic/SeparationLogic.vo MonadLib/MonadErr/monadesafe_lib.vo`。
2. `/home/xinra/.opam/pv-bench-8.20.1/bin/coq_makefile -f _CoqProject -o Makefile.coq`，
   然后 `make COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/ -f Makefile.coq -j4`。
3. `/home/xinra/.opam/pv-bench-8.20.1/bin/coqc $(awk '/^-/{print}' _CoqProject) checks/ExternCheck.v`；当前检查覆盖 header 所有
   Extern 的类型和 record projections，以及本次增加的两个 entry_condition
   和三个公开程序的 sg 参数。

正式 predicate source hash 见 predicate-manifest.sha256。检查只出现已有 sizeof
notation override 提示，没有新增公理、占位证明或跳过依赖编译。
未运行 QCP parser、symbolic、VC、verification-orchestrator 或 C 实现证明。

当前设计阶段因语义问题仍为 needs-fix，保留本次重建缓存供继续修订使用；
正式源码、checks/ExternCheck.v、当前 manifest 与审阅记录均保留。

