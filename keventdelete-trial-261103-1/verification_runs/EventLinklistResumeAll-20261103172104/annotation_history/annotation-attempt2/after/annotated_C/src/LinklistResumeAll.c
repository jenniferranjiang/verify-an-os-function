#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import CRTOS_Verify.VC.EventLinklistResumeAll_lib */
/*@ Extern Coq
  (event_pending_at : Z -> addr -> list addr -> VarGlobalState -> Prop)
  (event_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (event_resume_remaining_effect : addr -> list addr -> VarGlobalState -> list addr -> VarGlobalState -> Prop)
  (event_resume_next_restore : StableGlobalState -> VarGlobalState -> addr -> addr -> Assertion)
  (event_resume_exstatus_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (event_resume_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (set_task_desc_exstatus : TaskDescriptorAbs -> Z -> TaskDescriptorAbs)
  (update_task_desc_map : addr -> TaskDescriptorAbs -> (addr -> option TaskDescriptorAbs) -> addr -> option TaskDescriptorAbs)
  (replace_task_desc_map : (addr -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
  (tdExstatus : TaskDescriptorAbs -> Z)
  (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
  (task_world_wf : VarGlobalState -> Prop)
 */

/* New Event outside-critical scenario. The old semaphore_waiters IC contract
 * and its differently adapted body remain untouched in root annotated_C/src.
 * This function retains its actual acquire/release; it is a new proof target. */
/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */;

/* This named boundary is valid only under the user-approved D1/D2 execution
 * restrictions of this EventDelete experiment. It is NOT derived from ordinary
 * locking and does not assert that the kernel enforces those restrictions.
 * D1 concerns the same allocation throughout the lookup-to-unpublish interval;
 * equal pointer/ID snapshots alone do not establish freedom from ABA. */
x_base CriticalAreaLock(void)
/*@ event_delete_gap
    With (sg : StableGlobalState) (before : VarGlobalState)
         (id p : Z) (empty : bool)
    Require event_delete_guard(id, p, empty, before) &&
            OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_gap(id, p, empty, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
 */;

x_err_t KTaskWakeup(int32 id)
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
 */;

x_err_t KTaskWakeup(int32 id)
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
/*@ event_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z) X
    Require list == event_pending_head(p) &&
      event_delete_guard(id, p, false, before) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      event_delete_guard(id, p, true, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;

    if (list == NONE) {
        /*@ Inv Assert list == list@pre && list == 0 &&
          list == event_pending_head(p) && event_delete_guard(id, p, false, before) &&
          safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
          has_permission(&task) * has_permission(&node) * has_permission(&lock) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, before = before, id = id, p = p, empty = false */;
    /*@ Given locked from current */
    /*@ event_delete_gap(id, p, false, before, locked) && os_inv(sg, locked)
        which implies exists (waiting : list addr),
          event_delete_gap(id, p, false, before, locked) &&
          event_pending_at(id, p, waiting, locked) && os_inv(sg, locked)
     */
    /*@ Given waiting */
    /*@ Inv Assert exists (current : VarGlobalState) (remaining : list addr) (saved_lock : Z),
      list == list@pre && list != 0 && list == event_pending_head(p) && lock == saved_lock &&
      event_delete_gap(id, p, false, before, locked) &&
      event_pending_at(id, p, waiting, locked) &&
      event_pending_at(id, p, remaining, current) &&
      event_resume_remaining_effect(p, waiting, locked, remaining, current) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      has_permission(&task) * has_permission(&node) *
      InsideCritical(sg, locked) * os_inv(sg, current)
     */
    while (1) {
        /*@ Given current remaining saved_lock */
        /*@ list@pre == event_pending_head(p) &&
            event_pending_at(id, p, remaining, current) && os_inv(sg, current)
            which implies exists next,
              list@pre == event_pending_head(p) &&
              event_pending_at(id, p, remaining, current) &&
              ((remaining == nil && next == list@pre) ||
               (exists first tail, remaining == cons(first, tail) &&
                 next == sched_link_of(first) && next != list@pre)) &&
              store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next),
                struct SysDoubleLinklistNode *, next) *
              event_resume_next_restore(sg, current, list@pre, next)
         */
        /*@ Given next */
        node = list->node_next;
        /*@ store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next),
              struct SysDoubleLinklistNode *, next) *
            event_resume_next_restore(sg, current, list@pre, next)
            which implies os_inv(sg, current)
         */
        if(node != list) {
            /*@ Given target from first */
            /*@ Given rest from tail */
            /*@ remaining == cons(target, rest) && next == sched_link_of(target) &&
                event_pending_at(id, p, remaining, current) && os_inv(sg, current)
                which implies exists desc,
                  remaining == cons(target, rest) && next == sched_link_of(target) &&
                  event_pending_at(id, p, remaining, current) &&
                  addr_aligned(target, ALIGN_SIZE) &&
                  current.os_tasks.task_desc_map(target) == Some(desc) &&
                  desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
                  os_world_wf(sg, current) && task_world_wf(current) && os_inv(sg, current)
             */
            /*@ Given desc */
            task = CONTAINER_OF_TASK_SCHED(node) /*@ where task_ptr = target */;
            /*@ current.os_tasks.task_desc_map(target) == Some(desc) && os_inv(sg, current)
                which implies exists marked,
                  current.os_tasks.task_desc_map(target) == Some(desc) &&
                  marked == replace_task_desc_map(
                    update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                      current.os_tasks.task_desc_map), current) &&
                  store(field_addr(target, struct TaskDescriptor, exstatus), long, tdExstatus(desc)) *
                  event_resume_exstatus_restore(sg, marked, target, -1)
             */
            /*@ Given marked */
            task->exstatus = -ERROR;
            /*@ store(field_addr(target, struct TaskDescriptor, exstatus), long, -1) *
                event_resume_exstatus_restore(sg, marked, target, -1)
                which implies os_inv(sg, marked)
             */
            /*@ remaining == cons(target, rest) &&
                event_pending_at(id, p, remaining, current) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                    current.os_tasks.task_desc_map), current) && os_inv(sg, marked)
                which implies exists task_id,
                  remaining == cons(target, rest) &&
                  event_pending_at(id, p, remaining, current) &&
                  marked == replace_task_desc_map(
                    update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                      current.os_tasks.task_desc_map), current) &&
                  0 <= task_id && task_id < 65536 &&
                  get_task_with_idnode_success(sg, marked, task_id, target) &&
                  event_pending_at(id, p, remaining, marked) &&
                  os_world_wf(sg, marked) && task_world_wf(marked) &&
                  store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id),
                    unsigned short, task_id) * event_resume_id_restore(sg, marked, target, task_id)
             */
            /*@ Given task_id */
            int32 resume_task_id = task->id.id;
            /*@ store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id),
                  unsigned short, task_id) * event_resume_id_restore(sg, marked, target, task_id)
                which implies os_inv(sg, marked)
             */
            KTaskWakeup(resume_task_id) /*@ where (wakeup_by_id_ic) sg = sg, before = marked */;
        } else {
            break;
        }
    }
    /*@ Given current remaining saved_lock */
    /*@ event_pending_at(id, p, remaining, current) &&
        event_resume_remaining_effect(p, waiting, locked, remaining, current) &&
        remaining == nil && event_delete_gap(id, p, false, before, locked) &&
        event_pending_at(id, p, waiting, locked) &&
        safeExec(LastSeen(before), abs_event_resume_all(id, p), X) && os_inv(sg, current)
        which implies event_delete_guard(id, p, true, current) &&
          Crtos_GTrans(locked, current) &&
          safeExec(LastSeen(current), return(tt), X) && os_inv(sg, current)
     */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = locked, st2 = current */;

    return EOK;
}
