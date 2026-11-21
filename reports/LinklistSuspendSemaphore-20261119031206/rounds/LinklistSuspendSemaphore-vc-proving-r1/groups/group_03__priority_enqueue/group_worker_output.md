# priority_enqueue 完成交付

六个 assigned 顶层 VC 和两个 assigned spatial split 均以 Qed 完成。最新 group-development 与 group-check 均实际返回 exit 0 / status passed；group-check 检查的是当前 copied manual，而非历史证明。未执行 parent/final-check，该步骤由主代理负责。

## 已证明的内容

- `entail_wit_7_1`：到达 sentinel 后按扫描前缀的比较事实尾插，构造 `linklist_priority_insert` 和 `linklist_semaphore_enqueue`，移交真实自持 sched link，并提供恢复更新后 `os_inv` 的 wand。
- `entail_wit_7_2`：从实际 DLL 内存资源推出哨兵不属于成员；与非空 suffix 的首节点等于哨兵矛盾。未仅凭指针等式断言 suffix 为空。
- `entail_wit_7_3` / `7_4`：归还借出的两个 priority 字段及 next 字段，恢复 staged `os_inv`；利用实际 DLL 成员地址 NoDup，证明 current anchor 不在已扫描前缀，dispatch 恰好在首个严格较低优先级节点前插入。7_4 保留局部 list 单元并使用 next_link=list_pre；不错误转换为尾插。
- `which_implies_wit_4` / `7` 及其 spatial split：归还更新后的 DLL，应用对应恢复 wand。

## 资源保持和假设边界

资源推导使用各 assigned span 内完整证明的局部 assert：从 DLL 排他所有权得到成员地址 NoDup 及 sentinel 排他；更新选中 semaphore 的 managed-list payload；从 owned 列表移交实际 self-linked sched 节点；用排列保持 scheduler owners 的 NoDup 与发布域覆盖；保持 task/service world 约束，以及 Dataqueue 对 semaphore ID 的关联和全部其他模块 frame。waiting 链无需整体已排序，仅依赖已扫描前缀及当前严格比较事实。

没有增加 Axiom/Admitted、可信假设、Require 强化或 Ensure 弱化。沿用当前任务字段 ABI 和已批准全局模型；非零 sched link 从已拥有描述符字段的有效地址及既有布局推出。未修改 lib、spec、C、generated statements、导入或 unassigned proof。无确认的 annotation gap。

由于本组未提供 group library，公共推导在允许的三个 proof span 内作为已证明局部 assert 重用，没有创建额外 helper declaration、trial 或分析函数体。

## 验证

执行 handoff 指定 controller 命令：

- `coq-check --run LinklistSuspendSemaphore-20261119031206 --round LinklistSuspendSemaphore-vc-proving-r1 --target-kind group-development --group priority_enqueue`：passed。
- 同命令 `--target-kind group-check`：passed，exit 0。

所有 assigned spans 的 Qed、无 Abort/Admitted/Show 已检查；原有 unassigned spans 保持不动。.vo 由 controller 保留。终态报告写入后停止写入，等待主代理 finalize-delivery。
