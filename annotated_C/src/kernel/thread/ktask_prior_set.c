#include "m_assign.h"
#include "ktask_set_status.h"
#include "monad.h"
#include "task_name_view.h"
#include "string_literal_view.h"
/*@ include strategies "string_literal_view.strategies" */
#include "task_stat_view.h"
#include "task_sched_view.h"
/*@ include strategies "task_name_view.strategies" */
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_stat_view.strategies" */
/*@ include strategies "task_sched_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskPrioSet */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskPrioSetFrame */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_prior_set_lib */
/*@ Import Coq Import DLL */

/*@ Extern Coq
      (option :: * => *)
      (OsAssignReadyVectorAbs :: *)
 */
/*@ Extern Coq
      (KERROR : Z)
      (task_addr_aligned : Z -> OsAssignReadyVectorAbs -> Prop)
      (ready_task_node : Z -> DL_Node Z)
      (assign_remove_member_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> list(DL_Node Z) -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs -> Prop)
      (assign_insert_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
      (update_task_desc_map :
        Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) ->
        Z -> option TaskDescriptorAbs)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (store_prio_lookup_table : Assertion)
      (ktask_strncmp_result : list Z -> list Z -> Z -> Z -> Prop)
      (ktask_idle_prefix : list Z)
      (ktask_prio_set_body : Z -> Z -> program (VarGlobalState -> Prop) Z)
      (ktask_prio_set_frame : StableGlobalState -> VarGlobalState -> Assertion)
      (ktask_name_is_idle : list Z -> Prop)
      (In : {A} -> A -> list A -> Prop)
      (os_ready_nodes : list(list(DL_Node Z)) -> list(DL_Node Z))
      (update_sched_member : TaskDescriptorAbs -> TaskSchedMemberAbs -> TaskDescriptorAbs)
      (set_sched_member_priority : TaskSchedMemberAbs -> Z -> TaskSchedMemberAbs)
      (ktask_prio_set_state : VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
      (LastSeen :
        VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_ktask_prio_set :
        StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (ktask_prio_set_locked :
        Z -> Z -> program VarGlobalState Z)
 */

/*
 * Stage-1 inside-critical contracts synchronized with assign_ready_remove.c
 * (linked_ic) and assign_ready_insert.c; task_inv supplies every scalar.
 * KTaskStatGet is declared by the verified ktask_set_status.h.
 * CriticalAreaLock/UnLock retain the existing m_ktask.h contracts.
 */
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ linked_ic
    With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
         (prefix suffix : list(DL_Node Z))
    Require
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
        app(prefix, cons(ready_task_node(task), suffix)) &&
      task_fields(sg, st) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_prio_lookup_table
    Ensure
      exists removed,
        assign_remove_member_step_ic(
          st.os_tasks.task_desc_map, task, desc, before, prefix, suffix, removed) &&
        task_fields(sg, st) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), removed) *
        store_node_self_linked(sched_link_of(task)) *
        store_prio_lookup_table
 */;

void KTaskInsertToReadyVector(struct TaskDescriptor *task)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require
      os_global_context(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) * assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      exists (before after : OsAssignReadyVectorAbs) (st' : VarGlobalState),
        before == st.os_assign.assignReadyVector &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, before, after) &&
        st' == replace_global_ready_vector(after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) &&
        task_fields(sg, st') * assign_ready_pending(sg, st')
 */;

/*
 * Stage-1 libc boundary drafts, adapted from QCP_examples/stdlib/string.h.
 * These are not among the already verified scheduler contracts above.
 * Keep the real size_t prototypes and the project's own string predicates.
 * Use QCP stdlib's pure valid_string (ASCII, no inner NUL) explicitly:
 * the CRTOS string module also exports a different valid_string definition.
 * Match the reference INT_MAX bounds. The strengthened store_string_n owns
 * a terminated string plus padding; strncmp stops at NUL, so n need not be
 * bounded by the capacity of the fixed-size task-name array.
 */
/*@ Extern Coq (valid_string : list Z -> Prop) */
/*@ Printing Coq Name valid_string := SimpleC.StdLib.string_lib.valid_string */

size_t strlen(const char *s)
/*@ With (text : list Z)
    Require valid_string(text) && string_length(text) < INT_MAX &&
      store_string(s, text)
    Ensure __return == string_length(text) && store_string(s, text)
 */;

int strncmp(const char *s1, const char *s2, size_t n)
/*@ With (left right : list Z) (capacity : Z)
    Require valid_string(left) && valid_string(right) &&
      0 <= n && n < INT_MAX &&
      string_length(left) < INT_MAX && string_length(right) < INT_MAX &&
      store_string(s1, left) * store_string_n(s2, capacity, right)
    Ensure ktask_strncmp_result(left, right, n, __return) &&
      store_string(s1, left) * store_string_n(s2, capacity, right)
 */;

/* Same domain as bitmap_site_mask.c in the current QCP integer model. */
static inline void __BitmapSiteMask(struct TaskDescriptor *task)
/*@ With (prio : Z)
    Require 0 <= prio && prio <= 31 &&
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      has_permission(&(task->task_dync_sched_member.bitmap_column))
    Ensure
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      store_uint(&(task->task_dync_sched_member.bitmap_column), 1 << prio)
 */
{
    NULL_PARAM_CHECK_1(task);
    /* Exact expansion of BITMAP_SETCOLUMN; keep the signed literal 1. */
    task->task_dync_sched_member.bitmap_column =
        (1 << task->task_dync_sched_member.cur_prio);

}

/**
 * This function sets the task's priority.
 *
 * @param task task descriptor
 * @param prio priority value
 *
 * @return EOK, -ERROR for an idle-name prefix, or -EINVALED for invalid state
 */
x_err_t _KTaskPrioSet(KTaskDescriptorType task, uint8 prio)
/*@ outside_critical
    With LitMap (sg : StableGlobalState) (st_before : VarGlobalState) X
    Require
      safeExec(LastSeen(st_before), abs_ktask_prio_set(sg, task, prio), X) &&
      OutsideCritical(sg, st_before) *
      GlobalStrings(LitMap)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after) *
        GlobalStrings(LitMap)
 */
{
    //  extern long ShowTask(void);
    x_base lock = 0;
    int ret = EOK;
    uint8 task_stat = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = st_before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(st_before), abs_ktask_prio_set(sg, task, prio), X) &&
        Crtos_RTrans(st_before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        exists desc,
          safeExec(LastSeen(st_before), ktask_prio_set_body(task, prio), X) &&
          0 <= prio && prio <= 31 &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(st_before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */
    /* Checked safety is consumed at the first observation, as in startup. */
    /*@ Assert exists lock_saved,
        safeExec(LastSeen(st_before), ktask_prio_set_body(task@pre, prio@pre), X) &&
        0 <= prio@pre && prio@pre <= 31 &&
        st_lock.os_tasks.task_desc_map(task@pre) == Some(desc) &&
        Crtos_RTrans(st_before, st_lock) &&
        store_ptr(&task, task@pre) * store_uchar(&prio, prio@pre) *
        store_int(&lock, lock_saved) * store_int(&ret, 0) *
        store_uchar(&task_stat, 0) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock) *
        GlobalStrings(LitMap)
     */
    /*@ Given lock_saved */

    if (0 == strncmp("ktaskidle",task->task_base_info.name, strlen("ktaskidle")))
    {
        // KPrintf("IDLE task [%s] is forbidden to change priority.\n",task->task_base_info.name);
        CriticalAreaUnLock(lock) /*@ where (stable) */;
        return -ERROR;
    }
    /*@ Given retval */
    /*@ ktask_strncmp_result(ktask_idle_prefix, desc.tdBaseInfo.tbName, 9, retval) &&
        retval != 0 && emp
        which implies !ktask_name_is_idle(desc.tdBaseInfo.tbName) && emp */
    task_stat = KTaskStatGet(task);

    /* Enter the priority transaction: the ready vector may temporarily disagree
       with the descriptor while remove/write/reinsert is in progress. */
    /*@ InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        os_global_context(sg) &&
        assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
        InsideCritical(sg, st_lock) * task_fields(sg, st_lock) *
        ktask_prio_set_frame(sg, st_lock) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), st_lock.os_assign.assignReadyVector) *
        store_prio_lookup_table
     */

    switch(task_stat)
    {
        case KTASK_READY:
            /*@ task_status_matches(desc.tdSchedMember.tsmStat, task_stat) &&
                task_stat == 1 && emp
                which implies desc.tdSchedMember.tsmStat == TSK_READY &&
                  store_uchar(&task_stat, 1) */
            /*@ st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
                desc.tdSchedMember.tsmStat == TSK_READY &&
                ktask_prio_set_frame(sg, st_lock)
                which implies
                exists prefix suffix,
                  Znth(desc.tdSchedMember.tsmCurPrio, st_lock.os_assign.assignReadyVector.orvBuckets, nil) ==
                    app(prefix, cons(ready_task_node(task), suffix)) &&
                  ktask_prio_set_frame(sg, st_lock)
             */
            /*@ Given prefix suffix */
// #ifdef ARCH_SMP
//             HwLockSpinlock(&AssignSpinLock);
// #endif
            KTaskOsAssignRemoveKTask(task) /*@ where (linked_ic) sg = sg, st = st_lock, desc = desc,
                before = st_lock.os_assign.assignReadyVector,
                prefix = prefix, suffix = suffix */;
            /*@ Given removed */
            task->task_dync_sched_member.cur_prio = prio;
            __BitmapSiteMask(task);
            /* The scalar update commits one descriptor; the ready container is
               still transient until the verified insertion call returns. */
            /*@ 0 <= prio && prio <= 31 &&
                assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
                st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
                assign_remove_member_step_ic(st_lock.os_tasks.task_desc_map, task, desc,
                  st_lock.os_assign.assignReadyVector, prefix, suffix, removed) &&
                task_fields_except_sched(sg, st_lock, task, desc) *
                store_task_sched_member(sched_link_of(task),
                  mkTaskSchedMemberAbs(desc.tdSchedMember.tsmStat, desc.tdSchedMember.tsmAdvanceCnt,
                    prio, desc.tdSchedMember.tsmOriginTimeslice, desc.tdSchedMember.tsmRestTimeslice, 1 << prio)) *
                ktask_prio_set_frame(sg, st_lock) *
                store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), removed) *
                store_node_self_linked(sched_link_of(task))
                which implies
                exists updated,
                  updated == ktask_prio_set_state(st_lock, task,
                    update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, prio)), removed) &&
                  updated.os_tasks.task_desc_map(task) == Some(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, prio))) &&
                  !In(ready_task_node(task), os_ready_nodes(removed.orvBuckets)) &&
                  task_fields(sg, updated) * assign_ready_pending(sg, updated) *
                  occupy_dll_node(sched_link_of(task)) * ktask_prio_set_frame(sg, st_lock)
             */
            /*@ Given updated */
            KTaskInsertToReadyVector(task)
                /*@ where sg = sg, st = updated,
                  desc = update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, prio)) */;
// #ifdef ARCH_SMP
//             HwUnlockSpinlock(&AssignSpinLock);
// #endif
            break;
        case KTASK_INIT:
        case KTASK_SUSPEND:
        case KTASK_RUNNING:
             task->task_dync_sched_member.cur_prio = prio;
             __BitmapSiteMask(task);
             break;
        case KTASK_CLOSE:
            // KPrintf("the close stat task is forbidden to change priority.\n");

            ret = EOK;
            break;
        default:
            // KPrintf("invalid stat task is forbidden to change priority.\n");
            ret = -EINVALED;
            break;
    }
    /*@ Assert exists after ret_saved task_stat_saved,
        safeExec(LastSeen(after), return(ret_saved), X) &&
        Crtos_GTrans(st_lock, after) &&
        store_ptr(&task, task@pre) * store_uchar(&prio, prio@pre) *
        store_uchar(&task_stat, task_stat_saved) *
        store_int(&lock, lock_saved) * store_int(&ret, ret_saved) *
        InsideCritical(sg, st_lock) * os_inv(sg, after) *
        GlobalStrings(LitMap)
     */
    /*@ Given after ret_saved */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = after */;

    return ret;
}
