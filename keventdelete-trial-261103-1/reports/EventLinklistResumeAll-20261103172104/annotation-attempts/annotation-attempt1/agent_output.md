# EventLinklistResumeAll annotation attempt 1

冻结event_waiters_oc及所有callee合同保持原文；共享predicate、headers和权威C未修改。现有IR语义为实际取得锁时的waiting批量唤醒，退出返还空pending历史观察及OutsideCritical；D1/D2仅作为已批准具名Lock接口的运行范围。循环保存同一X，不把本次较早查询时的waiting冻结到ResumeAll加锁时。

新增注解仅完成资源借还、call where、Given及两个循环的不变量。case lib保留seed的完整首个import block，增补3个字段归还wand和引用公共整体effect的剩余进度关系，没有新公理、Admitted或手写manual proof。哪些字段可拆出、更新后能否恢复、批量进度的初始化/保持/退出全部由生成的VC负责，不把wand存在当作可信事实。

## 实际诊断与修复

1. formal-case-lib-design通过。首轮symexec在解析带Inv的空头for(;;)时driver以-11退出，无输出VC。只将空头for(;;)等价归一成while(1)后，解析成功并正常报告下一个资源问题，确认这处适配解决了实际工具触发点。
2. 第二轮在if(node != list)报告局部list地址无data_at：资源which implies错误选择了当前C变量list的cell。已把资源选择中的地址统一写为未修改参数list@pre，循环仍明确list == list@pre并保留局部cell；没有削弱函数规格。
3. 第三轮controller symexec passed并原子发布全部generated family；formal-case-lib post-check随后passed。long类型exstatus在当前32位模型生成Int单元，与原TaskInv一致。

## 等价源码归一

权威来源是kernel/thread/linklist.c:110–132，本轮保留其真实CriticalAreaLock/UnLock和循环体语句顺序。
- 空头for(;;)改为while(1)：两者条件恒真、无初始化/更新语句，所有break和循环体不变。
- KTaskWakeup(task->id.id)拆成int32 resume_task_id = task->id.id，再以该局部值调用：仍单次读取同一个uint16字段、相同整型提升、相同锁内求值顺序；间隔仅有逻辑注解，无运行时副作用。Main已确认该既有源码切片规则适用。

## 生成义务与边界

本attempt第一次交付，failed_vcs为空，故vc_comparisons为空。现有with/call关系已由生成输入直接检查；循环保持需要从通用Wakeup及实际event/task资源导出队首移除和批量effect组合，交独立VC checking与后续group proof。

冻结的KTaskWakeup声明包含两个既有<=派生规格，QCP仍生成它们的derive义务。按main指示保留，这些是导入接口的派生兼容性义务，不是KTaskWakeup body VC，也不计作本轮新增C函数证明。独立VC reviewer可核对并复用现有证明；不删除声明关系或手改生成结果。

实际手工证明条目数：61。导入派生义务：
- `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic`
- `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic`

检查均通过：formal-case-lib-design（最后一次6.63s）、symexec（1.10s）、formal-case-lib（6.83s），每项exit0且JSON passed。此处只完成annotation，不宣称这些manual VC已证明。
