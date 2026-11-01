# SemaphoreDelete VC checking r2

Outcome: 当前 96 个 top-level VC 可进入证明；没有新发现的 annotation/spec/dependency blocker。15 个父 VC 采用 aggressive_pre_process（27 个 split），其余 81 个采用 LLM_pre_process。本结论是可证性分析，不是证明已完成。

## Structural Blocker Scan

已扫描当前 whole goals 的地址、标量、existential 及 frame。旧 retirement 的返回 ID 节点不确定问题由新增 NoDup 排除；current.addr/ID/value、空 pending、list prefix/suffix 和 returned-node contains 都在前提中。非 semaphore 资源由 delete_global_frame 保留，删空 pending 不改变调度节点所有者。其余局部传递 VC 的 current/字段地址桥仍在；真假 query、retval 和 resched 不相容分支可直接矛盾关闭。全局 manager 非零使用既有 CNotation.addr_of_LE_var_not_zero，不引入新假设。

## Annotation Comparison Review

独立核对两条 comparison：entail_wit_4_2/_4_4 当前均有 NoDup(map semaphore_id drained.os_semaphores)，同时保留 contains 与 current ID 相等关系；它足以将 returned idnode_2 定位到 current。which_implies_wit_7 的 P 仍只有原完整 os_inv 和既有 resume/member 事实，NoDup 只出现在 Q，建立责任没有被偷换成输入假设。旧反例不再满足 P。新义务的来源是 store_idmanager -> idbuckets_ok -> idlist_ok。

## Proof-Mode Decisions

严格先判完下列所有 split，再确定父 VC 模式；每项“可证”都针对当前 statement。
- `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1`：可证。Crtos_GTrans st_lock st_lock is reflexive in the existing protocol.
- `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2`：可证。The premise &(k_sem_id_manager)=0 contradicts CNotation.addr_of_LE_var_not_zero. Close the requested safeExec fact from that contradiction.
- `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial`：可证。The same impossible global-address equality suffices; alternatively unfold delete_manager_frame/os_inv/semaphore_inv and refold the unchanged manager plus frame.
- `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1`：可证。Apply the existing GTrans reflexivity for st_lock.
- `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2`：可证。From query=false and semaphore_manager.idlist=map semaphore_id sems derive no object has semaphore_query_id id_pre (rewrite uint16 truncation to mod65536). Build the miss/false locked-effect at st_lock unchanged. Entry safeExec and RTrans to st_lock then yield the ret tt continuation through the atomic-command and bind semantics. The spatial context is unchanged.
- `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial`：可证。Unfold delete_manager_frame, semaphore_inv and os_inv; use semaphore_context to rewrite global manager/list addresses and cancel/reassemble all unchanged module resources and InsideCritical.
- `proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1`：可证。map sched_link_node original.pending <> nil implies original.pending <> nil by destructing the source list; the other hypotheses need no use.
- `proof_of__SemaphoreDelete_return_wit_2_split_goal_1`：可证。id_pre<0 makes Z.ltb id_pre 0 true; unfold abs_semaphore_delete in the existing safeExec premise and rewrite to MonadErr.ret tt.
- `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1`：可证。unsigned_last_nbits id_pre 16 is nonnegative by the standard unsigned truncation/modulo bound; 2^16=65536>0.
- `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2`：可证。Use the strict upper truncation bound unsigned_last_nbits id_pre 16 < 2^16 = 65536.
- `proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1`：可证。Unfold semaphore_pending_head at retval; the two field-address expressions are definitionally equal.
- `proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2`：可证。Identical address-definition equality; unfold semaphore_pending_head at retval.
- `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1`：可证。Use CNotation.addr_of_LE_var_not_zero for the global k_sem_id_manager address.
- `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2`：可证。Rewrite original.id=unsigned_last_nbits(id_pre,16) and use nonnegative truncation bound.
- `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3`：可证。Rewrite original.id=unsigned_last_nbits(id_pre,16) and use strict upper bound 2^16=65536.
- `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1`：可证。Use CNotation.addr_of_LE_var_not_zero for k_sem_id_manager.
- `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2`：可证。Rewrite original.id by the given uint16 truncation equality, then use its lower bound.
- `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3`：可证。Rewrite original.id by the given uint16 truncation equality, then use its strict 65536 upper bound.
- `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial`：可证。Unfold os_inv and semaphore_inv. Keep all non-semaphore modules and os_world_wf in delete_global_frame; keep the management DLL and semaphore_context in delete_manager_frame. Rewrite stable global addresses by semaphore_context and cancel.
- `proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial`：可证。Focus original in the semaphore management DLL using In and sem=original.addr. Extract its pending DLL, retaining payload/manager/global resources; use wand introduction to package restoration of exactly the same DLL as delete_pending_restore. semaphore_wait_node and sched_link_node are definitionally the same node projection. No node ownership is duplicated.
- `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1`：可证。Unfold semaphore_pending_nodes; instantiate its object witness with original using In original and sem=original.addr, with reflexive map equality.
- `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial`：可证。Unfold delete_pending_restore and semaphore_pending_head, then eliminate the spatial wand with its matching pending DLL; retain no duplicate DLL after os_inv is restored.
- `proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial`：可证。First show the resume effect retains a current semaphore at sem with original.id. Focus that ID node inside the semaphore_manager buckets of os_inv drained, extract its UShort scalar using the embedded IdNode address, and package the untouched remainder as the exact delete_id_restore wand. The nil effect is identity and the nonempty effect changes pending only in semaphore objects.
- `proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial`：可证。Unfold delete_id_restore; its antecedent is exactly the supplied UShort cell. Wand elimination returns os_inv drained, consuming the separate cell and wand.
- `proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1`：可证。Unfold delete_manager_frame and extract its existing semaphore_context pure conjunct.
- `proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial`：可证。Unfold delete_manager_frame; rewrite drained.os_semaphores=prefix++current::suffix, map_app and semaphore_link_node, then current.addr=sem and semaphore_context.list_head=k_sem_list. Cancel to delete_global_frame plus the exact DLL expected by remove_member.
- `proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial`：可证。Unfold SemaphoreRetired and SemaphoreRaw. Use its base nonzero/alignment and three link nonzero premises; convert initialized UShort/Ptr cells to undefined stores, retain each of the three complete nodes, and forget the two initialized padding arrays to undef arrays. Normalize nested field addresses; no new allocation or ownership is introduced.

所有有 split 的父 VC 均选 aggressive；无 split 的 whole goals 经独立判断选 LLM。完整 mode 与正式目标策略按 manual 名称写在 group_plan.json，覆盖校验为 96/96 且没有重复。

## Common Proof Patterns

- 纯事实/同态 frame：LLM 后展开需要的 _aux，重写已有 sem/retval/current 等式，重建 pure 合取并 cancel 同一资源。不能把消失的局部槽当作可调用 pure witness 的额外资源。
- 真假分支：同一 retval/query/resched 的相反前提直接矛盾；不在不可达分支伪造内存。
- 表示层借还：实际拆分 DLL/ID bucket，wand introduction 保留真实余下资源，wand elimination 恢复同一 os_inv；不复制 ownership。
- 删除提交：NoDup 定位 ID 节点，manager-remove 与 list-remove 对齐，空 pending 保持全局所有者集合，拼出退休对象并从原 safeExec/locked effect 得到正确 continuation。
- 数值/返回：截断界、已有 Int cell 范围、全局地址非零、负 ID 的抽象 ret 分支，以及准确选择 st_lock/after_2/after_3 作为出口 witness。

## VC Deltas

实质新增的负担是 which7 的 NoDup 导出；retirement 两个目标增加该前提。范围、局部投影和大多数 frame goals 保持原数学形状。每个 VC 的真实差异（资源集合、witness 和具体纯事实来源）列在 plan 的 strategy/split_strategies 中，不在此重复。

## Grouping Decisions

- `manager_selection`：1 个 top-level，0 个 selected split，难度 4。
- `retirement_commit`：2 个 top-level，0 个 selected split，难度 5。
- `lookup_views`：2 个 top-level，1 个 selected split，难度 4。
- `pending_views`：4 个 top-level，4 个 selected split，难度 4。
- `id_read_views`：2 个 top-level，2 个 selected split，难度 4。
- `lookup_miss`：2 个 top-level，6 个 selected split，难度 4。
- `numeric_call_bounds`：5 个 top-level，8 个 selected split，难度 2。
- `returns`：4 个 top-level，1 个 selected split，难度 2。
- `constant_safety_a`：4 个 top-level，0 个 selected split，难度 1。
- `constant_safety_b`：5 个 top-level，0 个 selected split，难度 1。
- `branch_contradictions_a`：6 个 top-level，0 个 selected split，难度 1。
- `branch_contradictions_b`：5 个 top-level，0 个 selected split，难度 1。
- `query_contradictions`：6 个 top-level，0 个 selected split，难度 1。
- `entry_frames`：5 个 top-level，0 个 selected split，难度 1。
- `pending_frames`：5 个 top-level，0 个 selected split，难度 1。
- `resume_call_bridge`：2 个 top-level，2 个 selected split，难度 1。
- `drained_frames`：4 个 top-level，0 个 selected split，难度 1。
- `id_cell_frames`：4 个 top-level，0 个 selected split，难度 1。
- `manager_call_frames`：6 个 top-level，0 个 selected split，难度 2。
- `removed_manager_frames`：5 个 top-level，2 个 selected split，难度 2。
- `remove_member_frames`：2 个 top-level，0 个 selected split，难度 1。
- `unlock_frames`：6 个 top-level，0 个 selected split，难度 1。
- `retired_raw`：5 个 top-level，1 个 selected split，难度 3。
- `schedule_frames`：4 个 top-level，0 个 selected split，难度 1。

首批为 manager_selection 与 retirement_commit：均含 comparison current，但前者是调用前建立事实与完整 manager 借出，后者是已给 NoDup 下的删除后资源/atomic 提交；两者没有新 helper 相互依赖，分开可避免不必要串行。manager_selection 的单 witness 是独立的对象保持/manager-wf helper family。retirement_commit 的两个 whole goals 同时包含内存提交和 continuation，无法在不改变正式 VC 的情况下把两半分给不同组；共享 helper 在组内分别承担纯节点唯一性、manager 代数、资源重建和 atomic continuation。

其余按各自资源/协议阶段分组，每组 2–6 个 top-level，最大6，均低于 hard limit12。公开入口结果、安全、独立 field view 与释放布局分别分组。各组不读取 sibling output，不声明 depends_on。

## Risks or Blockers

No blocker。高风险工作仍须实际证明：manager bucket/list 代数、DLL payload focus/restore、删除后的 os_world_wf/模块重组以及 safeExec atomic-b bind。需要新引理本身不构成缺口；plan 的 helper 均列出能从当前 P 得到的前提。不能使用 semaphore_retired_raw_obligation 这个 Prop Definition 充当已证 lemma。本 attempt 没有修改 canonical formal files 或 debug manual，也没有运行额外 Coq 检查。
