#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/*@ Import Coq Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations */
/* Existing logical vocabulary for local ownership views. */
/*@ Extern Coq
 (os_tasks : VarGlobalState -> TaskState)
 (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
 (sched_owned_tasks : TaskState -> list Z)
 (ktask_not_os_service : Z -> VarGlobalState -> Prop)
 (sepcon : Assertion -> Assertion -> Assertion)
 (wand : Assertion -> Assertion -> Assertion)
 (store_ushort : Z -> Z -> Assertion)
 (store_ptr : Z -> Z -> Assertion)
 (store_uchar : Z -> Z -> Assertion)
 (cons : {A} -> A -> list A -> list A) (nil : {A} -> list A)
 (app : {A} -> list A -> list A -> list A)
 (linklist_priority_insert : (Z -> option TaskDescriptorAbs) -> Z -> list(DL_Node Z) -> list(DL_Node Z) -> Prop)
 (linklist_semaphore_enqueue : Z -> Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Extern Coq Record VarGlobalState {
  os_tasks: TaskState;
} */
/*@ Extern Coq Record TaskState {
  task_desc_map: Z -> option TaskDescriptorAbs;
  sched_owned_tasks: list Z;
} */
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

/* Derived interface follows QCP native declaration form (bst_insert.c). */
x_err_t LinklistSuspend(DoubleLinklistType *list, struct TaskDescriptor *task, uint8 flag)
/*@ semaphore_prio_ic <= semaphore_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) && flag == 1 &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure __return == 0 && exists after,
   linklist_suspend_prio(sem, task, before, after) && os_inv(sg, after)
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


{
 int32 ret = 0;
 int32 suspend_id;
 DoubleLinklistType *node = NONE;
 DoubleLinklistType *tail = NONE;
 struct TaskDescriptor *tmp_task = NONE;
 /* NULL_PARAM_CHECK(list/task): diagnostic-only omitted. */
 if (flag != 0 && flag != 1) return -10;
 /* CriticalAreaLock/UnLock: nested IC calls removed by source-processing rule. */
 /*@ Assert exists (task_id : Z),
   0 <= task_id && task_id < 65536 &&
   get_task_with_idnode_success(sg, before, task_id, task) &&
   list == list@pre && task == task@pre && flag == flag@pre &&
   (flag == 0 || flag == 1) &&
   list == semaphore_pending_head(sem) &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) &&
   ret == 0 && node == 0 && tail == 0 && tmp_task == 0 &&
   undef_data_at(&suspend_id) * store(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
   wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), task_id), os_inv(sg, before)) */
 /*@ Given task_id */
 suspend_id = task->id.id;
 /*@ task == task@pre && list == list@pre && store(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
   wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), task_id), os_inv(sg, before))
   which implies task == task@pre && list == list@pre && os_inv(sg, before) */
 SuspendKTask(suspend_id);
 /*@ Assert exists (staged : VarGlobalState) (ignored : Z) (desc : TaskDescriptorAbs),
   list == list@pre && task == task@pre && flag == flag@pre &&
   (flag == 0 || flag == 1) && ret == 0 && node == 0 && tail == 0 && tmp_task == 0 &&
   suspend_id == task_id &&
   ktask_suspend_step(task, before, ignored, staged) &&
   semaphore_pending_nodes(sem, staged, map(sched_link_node, waiting)) &&
   list == semaphore_pending_head(sem) &&
   (staged.os_tasks.task_desc_map)(task) == Some(desc) &&
   desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
   In(task, staged.os_tasks.sched_owned_tasks) && ktask_not_os_service(task, staged) &&
   os_inv(sg, staged) */
 /*@ Given staged ignored desc */
 if(flag == 0) {
  /*@ Assert exists (after_fifo : VarGlobalState),
    list == list@pre && task == task@pre && flag == flag@pre && flag == 0 && ret == 0 &&
    node == 0 && tail == 0 && tmp_task == 0 && suspend_id == task_id &&
    ktask_suspend_step(task, before, ignored, staged) &&
    linklist_semaphore_enqueue(sem, task, 0, staged, after_fifo) &&
    sched_link_of(task) == &task->task_dync_sched_member.sched_link &&
    &task->task_dync_sched_member.sched_link != 0 &&
    dll_insert_anchor(list, map(sched_link_node, waiting), list) &&
    dll_insert_before_dispatch(list, map(sched_link_node, waiting), list, Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) ==
      map(sched_link_node, app(waiting, cons(task, nil))) &&
    store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting)) *
    pure_suspend_sched_link(staged.os_tasks.task_desc_map, &task->task_dync_sched_member.sched_link, task) *
    occupy_dll_node(&task->task_dync_sched_member.sched_link) *
    wand(store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list,
      map(sched_link_node, app(waiting, cons(task, nil)))), os_inv(sg, after_fifo)) */
  /*@ Given after_fifo */
  DoubleLinkListInsertNodeBefore(list, &(task->task_dync_sched_member.sched_link))
    /*@ where (dispatch_case) {A = Z} storeA = pure_suspend_sched_link(staged.os_tasks.task_desc_map),
       head = list, nodes = map(sched_link_node, waiting), inserted_data = task */;
  /*@ task == task@pre && list == list@pre && store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list,
      dll_insert_before_dispatch(list, map(sched_link_node, waiting), list, Build_DL_Node(task, &task->task_dync_sched_member.sched_link))) *
    wand(store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list,
      map(sched_link_node, app(waiting, cons(task, nil)))), os_inv(sg, after_fifo)) &&
    dll_insert_before_dispatch(list, map(sched_link_node, waiting), list, Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) ==
      map(sched_link_node, app(waiting, cons(task, nil)))
    which implies task == task@pre && list == list@pre && os_inv(sg, after_fifo) */
 } else if(flag == 1) {
  /*@ task == task@pre && list == list@pre && semaphore_pending_nodes(sem, staged, map(sched_link_node, waiting)) &&
    list == semaphore_pending_head(sem) && os_inv(sg, staged)
    which implies task == task@pre && list == list@pre && exists (first_link : Z),
      ((waiting == nil && first_link == list) ||
       (exists (first_task : Z) (rest_tasks : list Z),
          waiting == cons(first_task, rest_tasks) && first_link == sched_link_of(first_task))) &&
      store(field_addr(list, struct SysDoubleLinklistNode, node_next), void *, first_link) *
      wand(store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_next), first_link), os_inv(sg, staged)) */
  /*@ Given first_link */
  /* The scanned prefix has priority at least that of task. The suffix starts
   * at node, or is empty at the sentinel. No sorted-list assumption is used. */
  /*@ Inv Assert exists (prefix_loop suffix_loop : list Z) (old_tmp : Z),
    list == list@pre && task == task@pre && flag == flag@pre && flag == 1 && ret == 0 &&
    tail == 0 && tmp_task == old_tmp && suspend_id == task_id &&
    ktask_suspend_step(task, before, ignored, staged) &&
    list == semaphore_pending_head(sem) &&
    semaphore_pending_nodes(sem, staged, map(sched_link_node, waiting)) &&
    (staged.os_tasks.task_desc_map)(task) == Some(desc) &&
    desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
    In(task, staged.os_tasks.sched_owned_tasks) && ktask_not_os_service(task, staged) &&
    waiting == app(prefix_loop, suffix_loop) &&
    (forall (scanned : Z), In(scanned, prefix_loop) =>
       exists (other_desc : TaskDescriptorAbs),
         (staged.os_tasks.task_desc_map)(scanned) == Some(other_desc) &&
         desc.tdSchedMember.tsmCurPrio <= other_desc.tdSchedMember.tsmCurPrio) &&
    ((suffix_loop == nil && node == list) ||
     (exists (first_task : Z) (rest_tasks : list Z),
       suffix_loop == cons(first_task, rest_tasks) && node == sched_link_of(first_task))) &&
    os_inv(sg, staged) */
  for(node = list->node_next; node != list; node = node->node_next) {
   /*@ Given prefix_loop suffix_loop old_tmp */
   /*@ Assert exists (current_task next_link : Z) (rest_tasks : list Z) (current_desc : TaskDescriptorAbs),
     list == list@pre && task == task@pre && flag == flag@pre && flag == 1 && ret == 0 &&
     tail == 0 && tmp_task == old_tmp && suspend_id == task_id &&
     ktask_suspend_step(task, before, ignored, staged) &&
     list == semaphore_pending_head(sem) &&
     semaphore_pending_nodes(sem, staged, map(sched_link_node, waiting)) &&
     (staged.os_tasks.task_desc_map)(task) == Some(desc) &&
     desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
     In(task, staged.os_tasks.sched_owned_tasks) && ktask_not_os_service(task, staged) &&
     waiting == app(prefix_loop, cons(current_task, rest_tasks)) &&
     (forall (scanned : Z), In(scanned, prefix_loop) =>
       exists (other_desc : TaskDescriptorAbs),
         (staged.os_tasks.task_desc_map)(scanned) == Some(other_desc) &&
         desc.tdSchedMember.tsmCurPrio <= other_desc.tdSchedMember.tsmCurPrio) &&
     node == sched_link_of(current_task) && node != list && addr_aligned(current_task, 4) &&
     (staged.os_tasks.task_desc_map)(current_task) == Some(current_desc) &&
     ((rest_tasks == nil && next_link == list) ||
      (exists (next_task : Z) (next_rest : list Z),
        rest_tasks == cons(next_task, next_rest) && next_link == sched_link_of(next_task))) &&
     store(field_addr(field_addr(task, struct TaskDescriptor, task_dync_sched_member), struct TaskDyncSchedMember, cur_prio), unsigned char, desc.tdSchedMember.tsmCurPrio) *
     store(field_addr(field_addr(current_task, struct TaskDescriptor, task_dync_sched_member), struct TaskDyncSchedMember, cur_prio), unsigned char, current_desc.tdSchedMember.tsmCurPrio) *
     store(field_addr(node, struct SysDoubleLinklistNode, node_next), void *, next_link) *
     wand(sepcon(store_uchar(field_addr(field_addr(task, struct TaskDescriptor, task_dync_sched_member), struct TaskDyncSchedMember, cur_prio), desc.tdSchedMember.tsmCurPrio),
       sepcon(store_uchar(field_addr(field_addr(current_task, struct TaskDescriptor, task_dync_sched_member), struct TaskDyncSchedMember, cur_prio), current_desc.tdSchedMember.tsmCurPrio),
       store_ptr(field_addr(node, struct SysDoubleLinklistNode, node_next), next_link))), os_inv(sg, staged)) */
   /*@ Given current_task next_link rest_tasks current_desc */
   tmp_task = CONTAINER_OF_TASK_SCHED(node)
     /*@ where task_ptr = current_task */;
   if(task->task_dync_sched_member.cur_prio > tmp_task->task_dync_sched_member.cur_prio) break;
  }
  /*@ Assert exists (prefix_done suffix_done : list Z) (last_tmp : Z)
      (new_nodes : list(DL_Node Z)) (after_prio : VarGlobalState),
    list == list@pre && task == task@pre && flag == flag@pre && flag == 1 && ret == 0 &&
    tmp_task == last_tmp && tail == 0 && suspend_id == task_id &&
    ktask_suspend_step(task, before, ignored, staged) &&
    waiting == app(prefix_done, suffix_done) &&
    new_nodes == map(sched_link_node, app(prefix_done, cons(task, suffix_done))) &&
    linklist_priority_insert(staged.os_tasks.task_desc_map, task, map(sched_link_node, waiting), new_nodes) &&
    linklist_semaphore_enqueue(sem, task, 1, staged, after_prio) &&
    ((node == list && suffix_done == nil) ||
     (exists (rest_tasks : list Z), suffix_done == cons(last_tmp, rest_tasks) &&
        node == &tmp_task->task_dync_sched_member.sched_link && node != list)) &&
    &task->task_dync_sched_member.sched_link != 0 &&
    (node != list =>
      dll_insert_anchor(list, map(sched_link_node, waiting), &tmp_task->task_dync_sched_member.sched_link) &&
      dll_insert_before_dispatch(list, map(sched_link_node, waiting), &tmp_task->task_dync_sched_member.sched_link,
        Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) == new_nodes) &&
    (node == list => new_nodes == map(sched_link_node, app(waiting, cons(task, nil)))) &&
    store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting)) *
    pure_suspend_sched_link(staged.os_tasks.task_desc_map, &task->task_dync_sched_member.sched_link, task) *
    occupy_dll_node(&task->task_dync_sched_member.sched_link) *
    wand(store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, new_nodes), os_inv(sg, after_prio)) */
  /*@ Given prefix_done suffix_done last_tmp new_nodes after_prio */
  if(node != list) {
   DoubleLinkListInsertNodeBefore(&(tmp_task->task_dync_sched_member.sched_link), &(task->task_dync_sched_member.sched_link))
    /*@ where (dispatch_case) {A = Z} storeA = pure_suspend_sched_link(staged.os_tasks.task_desc_map),
       head = list, nodes = map(sched_link_node, waiting), inserted_data = task */;
   /*@ task == task@pre && list == list@pre && tmp_task == last_tmp && dll_insert_before_dispatch(list, map(sched_link_node, waiting), &tmp_task->task_dync_sched_member.sched_link,
        Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) == new_nodes &&
     store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list,
       dll_insert_before_dispatch(list, map(sched_link_node, waiting), &tmp_task->task_dync_sched_member.sched_link,
         Build_DL_Node(task, &task->task_dync_sched_member.sched_link))) *
     wand(store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, new_nodes), os_inv(sg, after_prio))
     which implies task == task@pre && list == list@pre && tmp_task == last_tmp && os_inv(sg, after_prio) */
  } else {
   /*@ task == task@pre && list == list@pre && new_nodes == map(sched_link_node, app(waiting, cons(task, nil))) &&
     store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting))
     which implies task == task@pre && list == list@pre && exists (last_link : Z),
       dll_insert_anchor(list, map(sched_link_node, waiting), last_link) &&
       dll_insert_after_dispatch(list, map(sched_link_node, waiting), last_link,
         Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) == new_nodes &&
       store(field_addr(list, struct SysDoubleLinklistNode, node_prev), void *, last_link) *
       wand(store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_prev), last_link),
         store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting))) */
   /*@ Given last_link */
   tail = list->node_prev;
   /*@ task == task@pre && list == list@pre && store(field_addr(list, struct SysDoubleLinklistNode, node_prev), void *, last_link) *
       wand(store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_prev), last_link),
         store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting)))
     which implies task == task@pre && list == list@pre && store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, map(sched_link_node, waiting)) */
   DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link))
    /*@ where (dispatch_case) {A = Z} storeA = pure_suspend_sched_link(staged.os_tasks.task_desc_map),
       head = list, nodes = map(sched_link_node, waiting), a = task */;
   /*@ task == task@pre && list == list@pre && tail == last_link && dll_insert_after_dispatch(list, map(sched_link_node, waiting), tail,
        Build_DL_Node(task, &task->task_dync_sched_member.sched_link)) == new_nodes &&
     store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list,
       dll_insert_after_dispatch(list, map(sched_link_node, waiting), tail,
         Build_DL_Node(task, &task->task_dync_sched_member.sched_link))) *
     wand(store_dll(pure_suspend_sched_link(staged.os_tasks.task_desc_map), list, new_nodes), os_inv(sg, after_prio))
     which implies task == task@pre && list == list@pre && tail == last_link && os_inv(sg, after_prio) */
  }
 }
 return ret;
}
