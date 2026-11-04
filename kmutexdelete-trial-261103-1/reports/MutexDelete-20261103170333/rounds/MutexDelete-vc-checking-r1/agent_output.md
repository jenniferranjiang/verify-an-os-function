# _MutexDelete VC checking r1

## Outcome

当前39个top-level、17个split均已完成检查；未发现确定的annotation/spec/dependency blocker。10个parent选择aggressive_pre_process，29个whole选择LLM_pre_process，形成11个独立group。没有修改canonical或debug文件，没有运行额外证明命令。

## Structural Blocker Scan

先扫描全部top-level，并优先读取no-split whole goals。所有当前资源都使用mutex_pre或显式current.addr=mutex_pre桥；ID字段读取后保留了同值恢复wand。成功注销的退休资源VC保留原列表分解、原地址/ID NoDup、原idmanager_contains和当前empty pending；这些事实足以定位被摘除的同一IdNode，而不是从删后manager反推旧状态。失败分支同时携带query=false和query=true，因此缺少脱链ID资源的分支不可达。没有用“证明困难”替代countermodel。

管理器非零的疑点已通过当前库接口核对：目标为命名全局地址&k_mutex_id_manager，现有CNotation.addr_of_LE_var_not_zero直接覆盖；不需额外假设manager base。MutexRetired的nonzero/alignment来自当前payload、返还ID字段/自环节点的合法存储与既有布局关系。NoDup不是新增公开前置，其建立责任明确在which_implies_wit_3。

## Annotation Comparison Review

本handoff annotation_comparisons为空，无历史VC比较需要继承。独立检查新的关键前提来源：which_implies_wit_3承担current/list split、NoDup、query=true以及ID读权限的建立；which_implies_wit_4恢复os_inv；which_implies_wit_5/6提供manager和DLL view；entail_wit_3_2承担注销后的实际空间重组；which_implies_wit_7承担Retired→Raw。Case-lib只有continuation、wand和frame定义，不把共享*_obligation当定理。

## Proof-Mode Decisions

严格先完成以下全部split二元判断，再决定任何top-level mode：

- `proof_of__MutexDelete_entail_wit_3_1_split_goal_1`：可证。
- `proof_of__MutexDelete_entail_wit_3_1_split_goal_2`：可证。
- `proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial`：可证。
- `proof_of__MutexDelete_entail_wit_3_2_split_goal_1`：可证。
- `proof_of__MutexDelete_entail_wit_3_2_split_goal_2`：可证。
- `proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial`：可证。
- `proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1`：可证。
- `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1`：可证。
- `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2`：可证。
- `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3`：可证。
- `proof_of__MutexDelete_which_implies_wit_1_split_goal_1`：可证。
- `proof_of__MutexDelete_which_implies_wit_2_split_goal_1`：可证。
- `proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial`：可证。
- `proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial`：可证。
- `proof_of__MutexDelete_which_implies_wit_6_split_goal_1`：可证。
- `proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial`：可证。
- `proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial`：可证。

所有17个split可证。随后按manual声明顺序确定top-level mode：

- `proof_of__MutexDelete_safety_wit_1`：`LLM_pre_process`。
- `proof_of__MutexDelete_safety_wit_2`：`LLM_pre_process`。
- `proof_of__MutexDelete_safety_wit_3`：`LLM_pre_process`。
- `proof_of__MutexDelete_entail_wit_1`：`LLM_pre_process`。
- `proof_of__MutexDelete_entail_wit_2`：`LLM_pre_process`。
- `proof_of__MutexDelete_return_wit_1`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_1_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_1`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_2`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_3_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_3`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_4_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_4`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_5_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_5`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_6`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_7`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_8`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_9_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_9`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_10_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_10`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_11`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_12`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_13_pure`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_13`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_14`：`LLM_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_15`：`LLM_pre_process`。
- `proof_of__MutexDelete_entail_wit_3_1`：`aggressive_pre_process`。
- `proof_of__MutexDelete_entail_wit_3_2`：`aggressive_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_2_pure`：`aggressive_pre_process`。
- `proof_of__MutexDelete_partial_solve_wit_8_pure`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_1`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_2`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_3`：`LLM_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_4`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_5`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_6`：`aggressive_pre_process`。
- `proof_of__MutexDelete_which_implies_wit_7`：`aggressive_pre_process`。

## Common Proof Patterns

- **P1 纯事实与frame透传**：结论中的pure facts已是参数前提，空间部分仅交换/保留同一资源。高阶pure→aux包装不要求制造aux中不存在的局部C单元；能直接从原pure上下文证明其条件。
- **P2 死分支**：NULL路径由live的p<>0与p=0矛盾排除；IdRemove不存在路径由同一query同时为true/false排除。只用已有矛盾，不虚构缺少的退休ID内存。
- **P3 地址/范围**：pending head展开即为同一字段地址；ID范围从drained获得；命名global非零用既有库事实。
- **P4 Monad continuation**：bind的weakestpre continuation、ret的单位结果以及guarded retire正常转移，均以当前实际locked状态和已有RTrans/drained为证据。
- **P5 精确资源视图**：只展开相关os_inv/Mutex manager/DLL；ID字段与恢复wand配对，未访问资源留在frame。
- **P6 退休与回收**：保留旧唯一性并从contains识别IDnode，证明派生manager删除等式、空pending注销保持world，复合实际后态资源形成os_inv(after)+私有Retired；最后逐字段忘值为Raw。

## VC Deltas

- `safety_wit_1`：Introduce the available context; spatial resources are irrelevant to the constant C-int bounds. Prove INT_MIN <= 0 <= INT_MAX by unfolding the shared numeric constants/int_auto. Do not change or consume OutsideCritical.
- `safety_wit_2`：As for safety_wit_1, now lock is initialized to 0 rather than undefined. Only the constant 0 C-int bounds are demanded; the mutex parameter cell and OutsideCritical are a frame.
- `safety_wit_3`：Prove the constant bounds INT_MIN <= 1 <= INT_MAX; alternatively the current mutex=0 fact contradicts mutex_delete_live. No field ownership or future-state premise is needed.
- `entail_wit_1`：The NULL branch has both mutex_pre=0 and mutex_delete_live mutex_pre id before, whose first conjunct is mutex_pre<>0. Derive False and close the entire entailment. This uses the existing entry fact, not a new unreachable-path assumption.
- `entail_wit_2`：The same NULL-loop context is contradictory by the nonzero component of mutex_delete_live; discharge the whole goal. The identical OutsideCritical could otherwise be framed; no shared memory is manufactured.
- `return_wit_1`：Choose after := after_2. The exact safeExec LastSeen(after_2) ret tt X fact is PreH3 and the sole OutsideCritical resource is unchanged. Cancel it; no state relation stronger than the given one is needed.
- `partial_solve_wit_1_pure`：The goal is exactly the safeExec(abs_mutex_delete_object) premise. Retain local cells/OutsideCritical as unused frame while extracting that pure fact.
- `partial_solve_wit_1`：This is a pure-obligation-to-aux wrapper. After LLM preprocessing, reconstruct every displayed pure fact from the original premises and cancel the unchanged OutsideCritical. The aux antecedent has no local cells, so do not try to fabricate them in order to call its pure-obligation argument.
- `partial_solve_wit_2`：Reconstruct live and safeExec(abs_mutex_resume_all, mutex_delete_after_resume) from the displayed premises, and unfold mutex_pending_head for the field-address equality. Preserve/cancel OutsideCritical. This establishes aux directly without assuming local lock/mutex cells which are absent from aux.
- `partial_solve_wit_3_pure`：The post-ResumeAll safeExec ret tt (mutex_delete_after_resume p id X) is already a pure premise. Its return-code and drained facts do not need any transformation.
- `partial_solve_wit_3`：Reinsert the existing retval=KOK, drained and three continuation/entry facts; cancel OutsideCritical(drained). The pure-to-aux wrapper needs no fresh state or cell witness.
- `partial_solve_wit_4_pure`：Project mutex_delete_drained p id drained directly from the premise. The local C cells and OutsideCritical remain a frame.
- `partial_solve_wit_4`：All aux facts are preexisting drained/continuation/entry facts; return the same OutsideCritical(drained). Do not use the pure argument by supplying nonexistent local cells; the facts can be proved directly.
- `partial_solve_wit_5_pure`：Project the new acquisition fact mutex_delete_drained p id st_lock. The InsideCritical token and os_inv belong to this freshly acquired state, so no current/@pre bridge is missing.
- `partial_solve_wit_5`：Return all given pure facts and rearrange InsideCritical(sg,st_lock) ** os_inv(sg,st_lock). These are unchanged resources; no transfer or new abstract state is performed.
- `partial_solve_wit_6`：Pure-context passthrough after the ID view is exposed. Reuse the list split, current address/ID/empty pending, both NoDup facts, query=true, rely and continuation premises. Cancel the exact UShort field at mutex_pre.id.id, its mutex_delete_id_restore wand and the lock token.
- `partial_solve_wit_7`：The same stored pure context is reasserted with full os_inv restored. Every pure output is a premise, and os_inv plus InsideCritical cancel unchanged. No resource conversion is needed in this wrapper.
- `partial_solve_wit_8`：Prove the aux guard directly: id bounds follow from mutex_delete_drained (not from a local delete_mutex_id cell absent in aux); the named global manager address is nonzero by the existing addr_of_LE_var_not_zero fact. Reinsert all old pure facts and cancel manager ** manager_frame ** InsideCritical.
- `partial_solve_wit_9_pure`：The output is only the old list split and current.addr=mutex_pre, both explicit premises. Post-IdRemoveObj manager/node resources are frame and must not be used to infer old uniqueness.
- `partial_solve_wit_9`：Return the explicitly retained old list split, current identity, NoDup facts and query=true, plus the callee-provided idmanager_contains/nonzero facts. Reorder the unchanged removed-manager, three detached IdNode stores, manager_frame and InsideCritical. All old-state facts are already premises.
- `partial_solve_wit_10_pure`：The ID-absence branch carries both query=false and query=true; congruence closes the whole entailment. Alternatively its two requested facts are displayed premises, but the contradiction is the simplest complete route.
- `partial_solve_wit_10`：The same query=false/query=true contradiction persists in the pure-to-aux wrapper; close it by contradiction. It is not necessary or sound to recover ID cells that this branch does not return.
- `partial_solve_wit_11`：This DLL-call frame on the absent-ID branch retains contradictory query booleans. Use that contradiction; do not invent a detached ID node to support the later retirement state.
- `partial_solve_wit_12`：Successful DLL-call frame: all pure outputs are retained premises; reorder the unchanged full management DLL, exact non-Mutex frame, removed manager, detached IdNode stores and InsideCritical. No list mutation is performed by this VC itself.
- `partial_solve_wit_13_pure`：The required Crtos_GTrans(st_lock,after) is an explicit premise. All local cells, os_inv(after), token and MutexRetired are frame.
- `partial_solve_wit_13`：Reassert the existing after=replace_mutexes(...), current.addr identity, safeExec and GTrans facts; cancel InsideCritical(st_lock) ** os_inv(after) ** MutexRetired(current) unchanged. This is the Unlock-call wrapper, not the retirement proof.
- `partial_solve_wit_14`：Rearrange OutsideCritical(after) ** MutexRetired(current) to the opposite order, preserving all existing pure facts. The retired object is private across unlock; no os_inv is reclaimed here.
- `partial_solve_wit_15`：Rewrite mutex_pre=current.mutex_addr and cancel MutexRaw plus OutsideCritical. The equality is explicit; no stale lookup scalar or ownership assumption is needed.
- `entail_wit_3_1`：仅证明所列split；失败ID分支的3个split均由同一boolean矛盾关闭。
- `entail_wit_3_2`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `partial_solve_wit_2_pure`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `partial_solve_wit_8_pure`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_1`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_2`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_3`：Select the Mutex object supplied by mutex_delete_drained, then use In/in_split for prefix/current/suffix. From the actual old os_inv derive NoDup(map mutex_id) through store_idmanager/idbuckets_ok/idlist_ok, and NoDup(map mutex_addr) through disjoint store_mutex payload fields. Derive query=true from In current and the derived manager ID list. Locate the matching embedded IdNode in its derived hash bucket, split just its UShort ID cell, and introduce a spatial wand that restores the unchanged whole os_inv when that exact cell/value is returned. Normalize nested field addressing, retain all other bytes in the wand, and output the current acquired-state object, not an earlier snapshot. Prove the needed resource view helpers; the existing *_obligation Prop definitions are not theorems.
- `which_implies_wit_4`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_5`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_6`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。
- `which_implies_wit_7`：仅证明所列split；详见plan内逐split的资源、witness和helper前提路线。

## Grouping Decisions

按核心资源转换优先派retire_state与borrow_id；各自是独立且重型helper家族，单top-level组有意避免把它们与简单透传绑定成尾部大组。成功retirement的三个split必须跟随同一parent，因此pure continuation与空间重组留在该组。其余组各2–5个top-level，围绕continuation、module view、reclaim/exit、失败分支、入口安全和不同阶段透传组织。最大组5个，低于hard cap 12；所有组独立、不读取sibling、不声明depends_on。

组规模：retire_state=1, borrow_id=1, continuations=2, module_views=3, reclaim_exit=4, absent_id_branch=4, entry_safety=5, call_guards=4, drain_passthrough=5, locked_passthrough=5, removed_passthrough=5。

## Risks or Blockers

无确定blocker。高风险在borrow_id的空间抽取/唯一性和retire_state的派生manager删除与world/frame重组；需要正式证明列出的helper，不能直接使用类型为Prop的mutex_delete_*_obligation。规划的所有helper前提均能由当前VC取得。当前共享地址和ABI事实属于原工程模型，不新增信任假设。

本交付仅完成VC可证性分析与分组，不声称C实现已证明。
