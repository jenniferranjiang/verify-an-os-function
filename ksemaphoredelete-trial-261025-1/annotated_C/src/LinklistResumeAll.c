#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import CRTOS_Verify.VC.LinklistResumeAll_lib */
/*@ Extern Coq
  (resume_remaining_effect : addr -> list addr -> VarGlobalState -> list addr -> VarGlobalState -> Prop)
  (semaphore_resume_all_steps : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (set_task_desc_exstatus : TaskDescriptorAbs -> Z -> TaskDescriptorAbs)
  (resume_next_restore : StableGlobalState -> VarGlobalState -> addr -> addr -> Assertion)
  (resume_exstatus_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (resume_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
 */

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c. Current 32-bit non-SMP configuration. */
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

x_err_t KTaskWakeup(int32 id)
/*@ wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
        ktask_wakeup_step(task, desc, before, after))) && os_inv(sg, after)
 */
/*@ detached_sched_null_delay <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && ktask_wakeup_detached_null_condition(sg, before, id) &&
      os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) && desc.tdDelay == 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
          ktask_wakeup_detached_null_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */
/*@ semaphore_pending_head_ic <= wakeup_by_id_ic
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
/*@ msgqueue_send_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (mq task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      msgqueue_send_pending_nodes(mq, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_msgqueue_send_head(mq, task, desc, before, after) &&
      msgqueue_send_pending_nodes(mq, after, rest) && os_inv(sg, after)
 */
/*@ msgqueue_recv_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (mq task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      msgqueue_recv_pending_nodes(mq, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_msgqueue_recv_head(mq, task, desc, before, after) &&
      msgqueue_recv_pending_nodes(mq, after, rest) && os_inv(sg, after)
 */
;

/* waiting 是调用前的挂起任务序列。正常返回时原等待任务均为 READY、
 * exstatus=-ERROR，等待链为空；整体效果还约束延时、就绪队列及其余状态变化。
 */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (before : VarGlobalState)
         (sem : addr) (waiting : list addr)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
      os_inv(sg, before)
    Ensure __return == KOK && exists after,
      semaphore_resume_all_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes(sem, after, nil) && os_inv(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = ((void *)0);
    DoubleLinklistType *node = ((void *)0);

    if (list == ((void *)0)) {
        /*@ Inv Assert list == list@pre && list == 0 &&
            list == semaphore_pending_head(sem) &&
            semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
            has_permission(&task) * has_permission(&node) * has_permission(&lock) *
            os_inv(sg, before)
         */ while (1) { } }

    /* Nested critical operation removed under the documented inside-critical adaptation. */
    /*@ Inv Assert exists (current : VarGlobalState) (remaining : list addr),
        list == list@pre && list != 0 && list == semaphore_pending_head(sem) &&
        semaphore_pending_nodes(sem, current, map(sched_link_node, remaining)) &&
        resume_remaining_effect(sem, waiting, before, remaining, current) &&
        has_permission(&task) * has_permission(&node) * has_permission(&lock) *
        os_inv(sg, current)
     */
    while (1) {
        /*@ Given current remaining */
        /*@ list@pre == semaphore_pending_head(sem) && list@pre != 0 &&
            semaphore_pending_nodes(sem, current, map(sched_link_node, remaining)) &&
            os_inv(sg, current)
            which implies exists next,
            list@pre == semaphore_pending_head(sem) && list@pre != 0 &&
            semaphore_pending_nodes(sem, current, map(sched_link_node, remaining)) &&
            ((remaining == nil && next == list@pre) ||
             (exists first tail, remaining == cons(first, tail) &&
               next == sched_link_of(first) && next != list@pre)) &&
            store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) * resume_next_restore(sg, current, list@pre, next)
         */
        /*@ Given next */
        node = list->node_next;
        /*@ store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) * resume_next_restore(sg, current, list@pre, next)
            which implies os_inv(sg, current)
         */
        if(node != list) {
            /*@ Given target from first */
            /*@ Given rest from tail */
            /*@ remaining == cons(target, rest) && next == sched_link_of(target) &&
                semaphore_pending_nodes(sem, current, map(sched_link_node, remaining)) &&
                os_inv(sg, current)
                which implies exists desc,
                remaining == cons(target, rest) && next == sched_link_of(target) &&
                addr_aligned(target, ALIGN_SIZE) &&
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
                semaphore_pending_nodes(sem, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                os_inv(sg, current)
             */
            /*@ Given desc */
            task = CONTAINER_OF_TASK_SCHED(node) /*@ where task_ptr = target */;
            /*@ current.os_tasks.task_desc_map(target) == Some(desc) &&
                os_inv(sg, current)
                which implies exists marked,
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                store(field_addr(target, struct TaskDescriptor, exstatus), int, desc.tdExstatus) * resume_exstatus_restore(sg, marked, target, -1)
             */
            /*@ Given marked */
            task->exstatus = -ERROR;
            /*@ store(field_addr(target, struct TaskDescriptor, exstatus), int, -1) * resume_exstatus_restore(sg, marked, target, -1)
                which implies os_inv(sg, marked)
             */
            /*@ remaining == cons(target, rest) &&
                semaphore_pending_nodes(sem, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                os_inv(sg, marked)
                which implies exists task_id,
                remaining == cons(target, rest) &&
                semaphore_pending_nodes(sem, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                0 <= task_id && task_id < 65536 &&
                get_task_with_idnode_success(sg, marked, task_id, target) &&
                semaphore_pending_nodes(sem, marked, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) * resume_id_restore(sg, marked, target, task_id)
             */
            /*@ Given task_id */
            int32 resume_task_id = task->id.id;
            /*@ store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) * resume_id_restore(sg, marked, target, task_id)
                which implies os_inv(sg, marked)
             */
            KTaskWakeup(resume_task_id) /*@ where (semaphore_pending_head_ic) sg = sg, before = marked, sem = sem, task = target, rest = map(sched_link_node, rest) */;
            /*@ Given woke_desc from desc */
            /*@ Given next_state from after */
        } else {
            break;
        }
    }
    

    return EOK;
}
