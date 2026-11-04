#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import KMutexDeleteProof.VC.MutexResumeAll_lib */
/*@ Extern Coq
  (mutex_resume_remaining_effect : addr -> list addr -> VarGlobalState -> list addr -> VarGlobalState -> Prop)
  (mutex_resume_all_steps : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (set_task_desc_exstatus : TaskDescriptorAbs -> Z -> TaskDescriptorAbs)
  (mutex_resume_next_restore : StableGlobalState -> VarGlobalState -> addr -> addr -> Assertion)
  (mutex_resume_exstatus_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (mutex_resume_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
 */

/* Source: kernel/thread/linklist.c:110-132. This is a NEW mutex/outside
 * contract, not derived from the root semaphore_waiters contract. Both
 * real lock/unlock calls are retained. KTaskWakeup is the existing inside
 * reused-spec boundary; its nested locks are covered by that adaptation.
 */
/* A1: caller-scoped trusted environment contract, NOT a consequence of
 * ordinary CriticalAreaLock. Only this experiment's approved delete chain
 * may select it. The same allocation stays published between its lookup
 * and this acquisition; other fields and OS modules may change. */
x_base CriticalAreaLock(void)
/*@ mutex_live
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z)
    Require mutex_delete_live(p, id, before) && OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && mutex_delete_live(p, id, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
      sched_link_ptr == sched_link_of(task_ptr) && emp
    Ensure __return == task_ptr && addr_aligned(__return, ALIGN_SIZE) &&
      sched_link_ptr == &(__return->task_dync_sched_member.sched_link)
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
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z) X
    Require list == mutex_pending_head(p) &&
      mutex_delete_live(p, id, before) &&
      safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
      mutex_delete_drained(p, id, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;
    if (list == NONE) {
        /*@ Inv Assert list == list@pre && list == 0 &&
          list == mutex_pending_head(p) && mutex_delete_live(p, id, before) &&
          safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
          has_permission(&task) * has_permission(&node) * has_permission(&lock) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    lock = CriticalAreaLock()
      /*@ where (mutex_live) sg = sg, before = before, p = p, id = id */;
    /*@ Given st_lock */
    /*@ mutex_delete_live(p, id, st_lock) && os_inv(sg, st_lock)
        which implies exists (original : MutexAbs),
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p &&
        original.mutex_id == id && mutex_delete_live(p, id, st_lock) &&
        mutex_pending_nodes(p, st_lock, map(sched_link_node, original.mutex_pending_addrs)) &&
        os_inv(sg, st_lock)
     */
    /*@ Given original */
    /*@ Inv Assert exists (current : VarGlobalState) (remaining : list addr)
                         (saved_lock : Z),
        list == list@pre && list != 0 && list == mutex_pending_head(p) &&
        lock == saved_lock &&
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p &&
        original.mutex_id == id && Crtos_RTrans(before, st_lock) &&
        mutex_delete_live(p, id, st_lock) && mutex_delete_live(p, id, current) &&
        mutex_pending_nodes(p, current, map(sched_link_node, remaining)) &&
        mutex_resume_remaining_effect(p, original.mutex_pending_addrs, st_lock, remaining, current) &&
        safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
        has_permission(&task) * has_permission(&node) *
        InsideCritical(sg, st_lock) * os_inv(sg, current)
     */
    while (1) {
        /*@ Given current remaining saved_lock */
        /*@ list@pre == mutex_pending_head(p) && list@pre != 0 &&
            mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && os_inv(sg, current)
            which implies exists next,
            list@pre == mutex_pending_head(p) && list@pre != 0 &&
            mutex_pending_nodes(p, current, map(sched_link_node, remaining)) &&
            ((remaining == nil && next == list@pre) ||
             (exists first tail, remaining == cons(first, tail) &&
               next == sched_link_of(first) && next != list@pre)) &&
            store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) *
            mutex_resume_next_restore(sg, current, list@pre, next)
         */
        /*@ Given next */
        node = list->node_next;
        /*@ store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) *
            mutex_resume_next_restore(sg, current, list@pre, next)
            which implies os_inv(sg, current)
         */
        if (node != list) {
            /*@ Given target from first */
            /*@ Given rest from tail */
            /*@ remaining == cons(target, rest) && next == sched_link_of(target) &&
                mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && os_inv(sg, current)
                which implies exists desc,
                remaining == cons(target, rest) && next == sched_link_of(target) &&
                addr_aligned(target, ALIGN_SIZE) &&
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                os_inv(sg, current)
             */
            /*@ Given desc */
            task = CONTAINER_OF_TASK_SCHED(node) /*@ where task_ptr = target */;
            /*@ current.os_tasks.task_desc_map(target) == Some(desc) && os_inv(sg, current)
                which implies exists marked,
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                store(field_addr(target, struct TaskDescriptor, exstatus), int, desc.tdExstatus) *
                mutex_resume_exstatus_restore(sg, marked, target, -1)
             */
            /*@ Given marked */
            task->exstatus = -ERROR;
            /*@ store(field_addr(target, struct TaskDescriptor, exstatus), int, -1) *
                mutex_resume_exstatus_restore(sg, marked, target, -1)
                which implies os_inv(sg, marked)
             */
            /*@ remaining == cons(target, rest) &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                os_inv(sg, marked)
                which implies exists task_id,
                remaining == cons(target, rest) &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                0 <= task_id && task_id < 65536 &&
                get_task_with_idnode_success(sg, marked, task_id, target) &&
                mutex_pending_nodes(p, marked, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
                mutex_resume_id_restore(sg, marked, target, task_id)
             */
            /*@ Given task_id */
            /* Equivalent normalization: read the original uint16 argument once;
             * only ghost annotations separate this read from its call. */
            int32 resume_task_id = task->id.id;
            /*@ store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
                mutex_resume_id_restore(sg, marked, target, task_id)
                which implies os_inv(sg, marked)
             */
            KTaskWakeup(resume_task_id) /*@ where (wakeup_by_id_ic) sg = sg, before = marked */;
        } else {
            break;
        }
    }
    /*@ Given current remaining saved_lock */
    /*@ mutex_delete_live(p, id, current) &&
        mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && remaining == nil &&
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p && original.mutex_id == id &&
        Crtos_RTrans(before, st_lock) && mutex_delete_live(p, id, st_lock) &&
        mutex_resume_remaining_effect(p, original.mutex_pending_addrs, st_lock, remaining, current) &&
        safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) && os_inv(sg, current)
        which implies mutex_delete_drained(p, id, current) && Crtos_GTrans(st_lock, current) &&
        safeExec(LastSeen(current), return(tt), X) && os_inv(sg, current)
     */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = current */;
    return EOK;
}
