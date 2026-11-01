# SemaphoreDelete VC 检查结果

本 attempt 发现确定的 annotation gap，尚不适合进入 proving。当前 manual 有 96 个 top-level VC 和 27 个 split declarations。没有修改 canonical 文件、调试 manual 或生成文件，也没有运行额外 Coq 检查。

## Structural Blocker Scan

失败的 whole goals 为 `proof_of__SemaphoreDelete_entail_wit_4_2` 和 `proof_of__SemaphoreDelete_entail_wit_4_4`，均无 split 子目标。它们位于 IdRemoveObj 与 DoubleLinkListRmNode 之后、解锁之前，分别是无等待者和有等待者的退休资源重建。

两者的 P 拥有删除后的 ID manager、剩余管理 DLL、被摘出的 current payload/管理自环节点、delete_global_frame 和临界区 token，以及 IdRemoveObj 返回的 `idnode_2` 的 ID=65535 与 ID-link 自环。纯条件只保留 `idmanager_contains old_manager original.id idnode_2`，没有旧 manager 的 `idlist_ok`/ID NoDup，也没有足以确定同 ID 节点唯一地址的条件。

`IDNode.idmanager_remove` 使用 `remove Z.eq_dec` 和 `idnodes_remove_id`，会从抽象 ID 列表及对应桶删除所有同 ID 项。删除后 manager 的 wf 因而不能推出被删除 ID 在旧列表中唯一。`delete_global_frame` 不含 semaphore ID-manager wf；其 `os_world_wf` 约束调度节点的覆盖/互斥，不约束 semaphore ID 唯一性。`store_semaphore` 只拥有 value、padding、pending，ID 字段/ID-link 明确归 manager。

## 具体反例形状

以 `_entail_wit_4_2` 为例，取两个不同、非零、对齐且互不重叠的 semaphore 基址 p、q：

- drained.os_semaphores = [A; B]，A.addr=p、B.addr=q，A.id=B.id=0，pending 均为空。
- original=current=A，prefix=[]、suffix=[B]，st_lock=drained、sem=p、idnode=p.id、resched=0、id_pre=0。
- `semaphore_resume_all_effect p [] st_lock drained` 成立；pending-nodes 为空的条件成立。
- `idnode_2=q.id` 满足 `idmanager_contains (semaphore_manager [A;B]) 0 idnode_2`；query 为 true。
- remove 后的 manager 没有 ID 0 节点，空 manager 的 bitmap/桶可满足其空间谓词和 wf。P 同时拥有 B 的管理链/payload、A 的 payload/自环管理节点，以及 q.id=65535 与 q 的自环 ID-link；这些资源可以互不重叠。
- 其他模块和临界区资源取合法且不与 p/q 重叠的资源；没有任何 P 分量拥有 p.id 的两个字节或 p 的 ID-link。取恒真 continuation 可满足未限定结果的 safeExec 前提，不能从它得到缺失的内存或旧 ID 唯一性。

Q 无论选择哪个 after，都要求 `SemaphoreRetired p A.value`，其中必须拥有 p.id=65535 与 p 的 ID-link。P 缺这些地址上的所有权，因此 P 可成立而 Q 失败。两个 disjunct 都要求同一退休对象，选择另一 proof route 无法修复。`_entail_wit_4_4` 的相同资源桥也缺同一信息：给 A 加合法等待任务并按整体 effect 排空，B 保持相同 ID，仍可让返回 idnode_2 指向 B。

这不是说真实入口 os_inv 允许重复 ID；真实调用前的完整 manager 确实排除了它。问题是该事实没有作为纯条件跨越 callee contract 保留到当前 VC。

## Annotation Comparison Review

Handoff 的 annotation_comparisons 为空。当前 which-implies_7 建立 query=true 和 current 的地址/ID/value，但未将旧 ID 唯一性保留到调用后；which-implies_8 只从 manager frame 借出管理 DLL，不补回已丢失的信息。补前提时必须由调用前真实 store_idmanager 的 id_map/idbuckets wf 导出，不能直接假定。

## Proof-Mode Decisions

上述两个 no-split whole goals 不可证，故不为它们选择 LLM_pre_process，也不输出成功 group plan。其他多数 safety、局部投影与 frame VC 呈现直接矛盾/范围/取消结构；本次不把未完成的整体模式与证明规划当作已完成交付。

## Common Proof Patterns / VC Deltas / Grouping Decisions

未进入详细策略与分组阶段。不能用一个需要额外 NoDup 前提的 helper 掩盖这里的 annotation 缺口。

## 修复范围

在 IdRemoveObj 前从完整 manager 导出并保留 `NoDup (map semaphore_id drained.os_semaphores)`，或保留等价的“查询 ID 的唯一节点地址”条件；将该纯事实贯穿 IdRemoveObj 与管理链摘除直到退休重建断言。它应使 returned idnode_2 可确定为 current/sem 的 ID 子对象，并支持删除后的 manager 与只去掉该对象的 semaphore 序列一致。必要的唯一性/投影 lemma 仍要证明。

本问题只要求补充函数体注解及真实来源的桥接事实，不要求改变冻结的 predicate/canonical/caller contract 或扩大信任边界。修复后重新生成当前 VC，并定向检查上述两个目标及建立/传递新事实的 related VCs。
