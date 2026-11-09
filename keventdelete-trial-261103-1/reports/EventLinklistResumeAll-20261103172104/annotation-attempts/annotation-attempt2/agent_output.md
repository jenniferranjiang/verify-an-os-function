# EventLinklistResumeAll annotation attempt 2

本轮只修复VC-checking报告的missing-old-state-exclusivity；冻结的public/callee contracts、共享predicate、case-lib定义及可执行C全部不变。

## 精确历史VC比较

读取了annotation-attempt1/after中的旧manual及其goal，和本轮controller新发布的manual/goal。旧 `proof_of_LinklistResumeAll_entail_wit_4_2` 的两个分支都只有 `os_inv(after)`，没有旧 `os_world_wf` 或 `task_world_wf`。因此旧snapshot允许同一SUSPEND task同时在Event和Semaphore中，generic Wakeup同时摘除两份后恰好恢复有效post-state；这不能支撑只改变Event的批量效果。

当前同名backedge在两个分支中都明确保留：
- `os_world_wf sg current_2`、`task_world_wf current_2`；
- `os_world_wf sg marked`、`task_world_wf marked`。

它们不是新增用户Require，也不是假设。`which_implies_wit_4`从仍持有的 `os_inv(current)` 导出，`which_implies_wit_7`从仍持有的 `os_inv(marked)` 导出；两条生成义务继续要求证明这些提取。后续call消费的是空间os_inv，历史纯事实通过frame保留至回边。os_world_wf的sched-owner NoDup明确排除报告中同一task跨容器重复归属的旧状态。

旧/新回边的结论、空间所有权归还和批量effect目标未弱化；修复只补回原资源已蕴含、但此前在消费前没有提取的历史事实。循环backedge与两条提取VC列入vc_comparisons.current；这说明已消除所报告的annotation缺口，不等于这些VC已经完成证明。独立VC checking仍需核对整个新输入。

## 检查

按handoff依次执行formal-case-lib-design（exit0、passed，9.92s）、symexec（exit0、passed，1.67s）、formal-case-lib（exit0、passed，7.62s）。Generated family全部由controller发布，未手改manual或目标文件。仍为61个manual条目，两项既有KTaskWakeup派生兼容性义务保留，不作为该函数body新证明。

没有新增predicate，没有新增证明公理或占位证明。r1已记录的for(;;)→while(1)与单次task ID读取拆句不再变化。
