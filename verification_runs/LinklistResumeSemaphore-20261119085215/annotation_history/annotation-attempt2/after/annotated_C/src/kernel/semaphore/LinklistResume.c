#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/*@ Import Coq Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations */
/*@ Extern Coq
 (wand : Assertion -> Assertion -> Assertion)
 (store_ptr : Z -> Z -> Assertion)
 (store_ushort : Z -> Z -> Assertion)
 (cons : {A} -> A -> list A -> list A) (nil : {A} -> list A)
*/
/* IC adaptation: original nested locks removed; no exstatus store. */
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
/* Reused contract: annotated_C/src/kernel/semaphore/LinklistResumeAll.c,
 * SHA256 29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05.
 * Import the established semaphore_pending_head_ic contract directly;
 * its source derivation and KTaskWakeup body are outside this target. */
x_err_t KTaskWakeup(int32 id)
/*@ semaphore_pending_head_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (sem task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      semaphore_pending_nodes(sem, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_semaphore_head(sem, task, desc, before, after) &&
      semaphore_pending_nodes(sem, after, rest) && os_inv(sg, after)
 */
;

x_err_t LinklistResume(DoubleLinklistType *list)
/*@ semaphore_head_ic
    With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
    Require list == semaphore_pending_head(sem) && waiting != nil &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) && os_inv(sg, before)
    Ensure __return == 0 && exists after, semaphore_resume_head_effect(sem, before, after) && os_inv(sg, after)
 */
{
    struct TaskDescriptor *task = NONE;
    /*@ list == list@pre && list == semaphore_pending_head(sem) && waiting != nil &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) && os_inv(sg, before)
      which implies exists (first : Z) (rest : list Z),
        list == list@pre && list == semaphore_pending_head(sem) && waiting == cons(first, rest) &&
        addr_aligned(first, ALIGN_SIZE) &&
        semaphore_pending_nodes(sem, before, cons(sched_link_node(first), map(sched_link_node, rest))) &&
        store(field_addr(list, struct SysDoubleLinklistNode, node_next), void *, sched_link_of(first)) *
        wand(store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_next), sched_link_of(first)), os_inv(sg, before)) */
    /*@ Given first rest */
    task = CONTAINER_OF_TASK_SCHED(list->node_next) /*@ where task_ptr = first */;
    /*@ list == list@pre && task == first && store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_next), sched_link_of(first)) *
      wand(store_ptr(field_addr(list, struct SysDoubleLinklistNode, node_next), sched_link_of(first)), os_inv(sg, before))
      which implies list == list@pre && task == first && os_inv(sg, before) */
    /*@ task == first &&
      semaphore_pending_nodes(sem, before, cons(sched_link_node(first), map(sched_link_node, rest))) && os_inv(sg, before)
      which implies exists (task_id : Z),
        task == first && 0 <= task_id && task_id < 65536 &&
        get_task_with_idnode_success(sg, before, task_id, first) &&
        semaphore_pending_nodes(sem, before, cons(sched_link_node(first), map(sched_link_node, rest))) &&
        store(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
        wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), task_id), os_inv(sg, before)) */
    /*@ Given task_id */
    int32 resume_task_id = task->id.id;
    /*@ task == first && resume_task_id == task_id && store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), task_id) *
      wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), task_id), os_inv(sg, before))
      which implies task == first && resume_task_id == task_id && os_inv(sg, before) */
    KTaskWakeup(resume_task_id) /*@ where (semaphore_pending_head_ic) sg = sg, before = before,
      sem = sem, task = first, rest = map(sched_link_node, rest) */;
    return 0;
}
