#ifndef CRTOS_KTASK_DELETE_RESOURCE_H
#define CRTOS_KTASK_DELETE_RESOURCE_H
#include "assign_ready_remove.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDelete */
/*@ Extern Coq
 (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
 (ktask_resource_delete_resources : StableGlobalState -> VarGlobalState -> Z -> Assertion)
 (ktask_resource_delete_transition : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (set_sched_member_status : TaskSchedMemberAbs -> TaskStatus -> TaskSchedMemberAbs)
 (update_sched_member : TaskDescriptorAbs -> TaskSchedMemberAbs -> TaskDescriptorAbs)
 (remove_found_prop : {A} -> A -> list A -> list A -> Prop)
 */

/* 锁内内存接口：kind=0 是 ready 成员，1 是自环，2 是外部 DLL。
 * 公开 registered 接口从全局资源派生这三个分支；kind 不是 C 参数。
 * storeA 的 payload 原样归还，不能假设一般 DLL payload 不拥有内存。
 */
static inline void _KTaskResourceDelete(struct TaskDescriptor *task)
/*@ resource_delete_local_ic
 With (desc : TaskDescriptorAbs) (before : OsAssignReadyVectorAbs)
      (kind : Z) (storeA : Z -> Z -> Assertion) (head : Z) (nodes : list(DL_Node Z))
 Require 0 <= desc.tdSchedMember.tsmCurPrio && desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
   store_task_descriptor(task, desc) *
   store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) * store_prio_lookup_table *
   ((kind == 0 && In(sched_link_node(task), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) && emp) ||
    (kind == 1 && store_node_self_linked(sched_link_of(task))) ||
    (kind == 2 && In(sched_link_node(task), nodes) && store_dll(storeA, head, nodes)))
 Ensure exists after,
   task != 0 &&
   store_task_descriptor(task, update_sched_member(desc, set_sched_member_status(desc.tdSchedMember, TSK_CLOSE))) *
   store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) * store_prio_lookup_table *
   store_node_self_linked(sched_link_of(task)) *
   ((kind == 0 && assign_remove_from_ready_ic(task, desc, before, after) && emp) ||
    (kind == 1 && assign_remove_beyond_ready_ic(desc, before, after) && emp) ||
    (exists remaining, kind == 2 && assign_remove_beyond_ready_ic(desc, before, after) &&
      remove_found_prop(sched_link_node(task), nodes, remaining) &&
      store_dll(storeA, head, remaining) * storeA(sched_link_of(task), task)))
 */;

static inline void _KTaskResourceDelete(struct TaskDescriptor *task)
/*@ resource_delete_registered_ic <= resource_delete_local_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (desc : TaskDescriptorAbs)
 Require before.os_tasks.task_desc_map(task) == Some(desc) && os_world_wf(sg, before) &&
   ktask_resource_delete_resources(sg, before, task)
 Ensure exists after, task != 0 &&
   ktask_resource_delete_transition(task, desc, before, after) && os_world_wf(sg, after) &&
   ktask_resource_delete_resources(sg, after, task)
 */;

static inline void _KTaskResourceDelete(struct TaskDescriptor *task)
/*@ resource_delete_detached_local_ic <= resource_delete_local_ic
 With (desc : TaskDescriptorAbs) (before : OsAssignReadyVectorAbs)
 Require 0 <= desc.tdSchedMember.tsmCurPrio && desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
   store_task_descriptor(task, desc) * store_node_self_linked(sched_link_of(task)) *
   store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) * store_prio_lookup_table
 Ensure exists after, task != 0 && assign_remove_beyond_ready_ic(desc, before, after) &&
   store_task_descriptor(task, update_sched_member(desc, set_sched_member_status(desc.tdSchedMember, TSK_CLOSE))) *
   store_node_self_linked(sched_link_of(task)) *
   store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) * store_prio_lookup_table
 */;
#endif
