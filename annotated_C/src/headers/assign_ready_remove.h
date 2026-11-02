#ifndef CRTOS_ASSIGN_READY_REMOVE_H
#define CRTOS_ASSIGN_READY_REMOVE_H

#include "m_assign.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Extern Coq
      (OsAssignReadyVectorAbs :: *)
 */
/*@ Extern Coq
      (assign_remove_from_ready_ic :
        Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (assign_remove_beyond_ready_ic :
        TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (In : {A} -> A -> list A -> Prop)
      (store_task_descriptor : Z -> TaskDescriptorAbs -> Assertion)
      (store_os_assign_ready_vector : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (store_prio_lookup_table : Assertion)
      (sched_link_of : Z -> Z)
      (sched_link_node : Z -> DL_Node Z)
 */

/* 锁内 descriptor 接口：借入并原样归还主体，其谓词已提供基址对齐。
 * LINKED 的 sched_link 由 ready-vector 拥有；LONE 则单独提供自环节点。
 * 优先级范围仍需单独要求，用于数组索引；主体谓词只提供字段的表示范围。
 * 函数不建立任务登记，后置转移关系只描述 ready-vector 的变化。
 * task != 0 来自 NULL_PARAM_CHECK_1 的正常返回，不要求空指针路径终止。
 */
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ linked_ic
    With (desc : TaskDescriptorAbs) (before : OsAssignReadyVectorAbs)
    Require
      0 <= desc.tdSchedMember.tsmCurPrio &&
      desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      In(sched_link_node(task), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
      store_task_descriptor(task, desc) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_prio_lookup_table
    Ensure exists after,
      task != 0 &&
      assign_remove_from_ready_ic(task, desc, before, after) &&
      store_task_descriptor(task, desc) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
      store_node_self_linked(sched_link_of(task)) * store_prio_lookup_table
 */;

void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ detached_ic
    With (desc : TaskDescriptorAbs) (before : OsAssignReadyVectorAbs)
    Require
      0 <= desc.tdSchedMember.tsmCurPrio &&
      desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      store_task_descriptor(task, desc) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_node_self_linked(sched_link_of(task)) * store_prio_lookup_table
    Ensure exists after,
      task != 0 &&
      assign_remove_beyond_ready_ic(desc, before, after) &&
      store_task_descriptor(task, desc) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
      store_node_self_linked(sched_link_of(task)) * store_prio_lookup_table
 */;

/* 外部 DLL 成员接口：head 是调用者提供的哨兵，l 记录节点及任务地址。
 * sched_link_node 仅构造 (task, sched_link_of(task))，不要求 READY 状态。
 * storeA(link, task) 可携带一般资源；DLL 独占 next/prev。
 * 后置原样归还摘下节点的 payload，并单独归还自环节点。
 * IPC pend_list 可传 pure_suspend_sched_link(T)，zombie 可传 pure_close_sched_link(T)。
 * 外部 DLL 与 ready-vector 分离拥有，因此所有 ready buckets 保持不变。
 * assign_remove_beyond_ready_ic 不要求节点原先自环，
 * 只描述对应桶非空时保持、为空时清位并重算最高优先级。
 * 前置已知成员，后置直接给出摘除位置及 prefix ++ suffix，保留其余顺序。
 */
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ external_list_ic
    With (desc : TaskDescriptorAbs) (before : OsAssignReadyVectorAbs)
         (storeA : addr -> addr -> Assertion)
         (head : addr) (l : list(DL_Node addr))
    Require
      0 <= desc.tdSchedMember.tsmCurPrio &&
      desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      In(sched_link_node(task), l) &&
      store_task_descriptor(task, desc) *
      store_dll(storeA, head, l) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_prio_lookup_table
    Ensure exists after l_after prefix suffix,
      task != 0 &&
      l == app(prefix, cons(sched_link_node(task), suffix)) &&
      l_after == app(prefix, suffix) &&
      assign_remove_beyond_ready_ic(desc, before, after) &&
      store_task_descriptor(task, desc) *
      store_dll(storeA, head, l_after) *
      storeA(sched_link_of(task), task) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
      store_node_self_linked(sched_link_of(task)) * store_prio_lookup_table
 */;

#endif
