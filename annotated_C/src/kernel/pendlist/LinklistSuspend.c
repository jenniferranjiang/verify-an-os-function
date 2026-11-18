#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/* Current crtoslatest linklist.c; IC removes nested lock only. Invalid flag returns before suspension. */
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
            sched_link_ptr == sched_link_of(task_ptr) &&
            emp
    Ensure __return == task_ptr &&
           addr_aligned(__return, ALIGN_SIZE) &&
           sched_link_ptr ==
             &(__return->task_dync_sched_member.sched_link)
 */;
/* Reused: VRTOS kernel/pendlist/linklist_suspend.c suspend_by_id_ic.
 * State representation adapted in lib/task/KTaskSuspend.v; proof not imported. */
x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_ic
 With (sg : StableGlobalState) (before : VarGlobalState)
 Require id < 65536 && os_inv(sg, before)
 Ensure exists (found : Z) (after : VarGlobalState),
   found != 0 && get_task_with_idnode_success(sg, before, id, found) &&
   ktask_suspend_step(found, before, __return, after) && os_inv(sg, after)
*/;

/* Reused canonical kernel/list/DoubleLinkListInsertNodeBefore.c dispatch_case. */
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: Z -> A -> Assertion)
             (head: Z) (nodes: list(DL_Node A)) (inserted_data: A)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, inserted_data) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_before_dispatch(
               head, nodes, linklist,
               Build_DL_Node(inserted_data, linklist_node)))
*/;

/* Reused canonical kernel/list/DoubleLinkListInsertNodeAfter.c dispatch_case. */
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/;

x_err_t LinklistSuspend(DoubleLinklistType *list, struct TaskDescriptor *task, uint8 flag)
/*@ semaphore_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure exists after, linklist_suspend_step(sem, task, flag, before, __return, after) &&
   os_inv(sg, after)
*/
/*@ semaphore_prio_ic <= semaphore_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) && flag == 1 &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure __return == 0 && exists after,
   linklist_suspend_prio(sem, task, before, after) && os_inv(sg, after)
*/

{
 int32 ret = 0;
 DoubleLinklistType *node = NONE;
 DoubleLinklistType *tail = NONE;
 struct TaskDescriptor *tmp_task = NONE;
 /* NULL_PARAM_CHECK(list/task): diagnostic-only omitted. */
 if (flag != 0 && flag != 1) return -10;
 /* CriticalAreaLock/UnLock: nested IC calls removed by source-processing rule. */
 SuspendKTask(task->id.id);
 switch(flag) {
 case 0:
  DoubleLinkListInsertNodeBefore(list, &(task->task_dync_sched_member.sched_link));
  break;
 case 1:
  for(node = list->node_next; node != list; node = node->node_next) {
   tmp_task = CONTAINER_OF_TASK_SCHED(node);
   if(task->task_dync_sched_member.cur_prio > tmp_task->task_dync_sched_member.cur_prio) break;
  }
  if(node != list) {
   DoubleLinkListInsertNodeBefore(&(tmp_task->task_dync_sched_member.sched_link), &(task->task_dync_sched_member.sched_link));
  } else {
   tail = list->node_prev;
   DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link));
  }
  break;
 }
 return ret;
}
