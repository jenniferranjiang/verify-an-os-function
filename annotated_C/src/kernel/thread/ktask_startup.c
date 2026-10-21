#include "startup_views_strategy.h"
#include "delay_views_strategy.h"
#include "m_assign.h"
#include "ktask_set_status.h"
#include "ktask_unset_delay.h"
#include "ktask_assign_oc.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskStartupFrame */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskStartupChecked */
/*@ Import Coq Import DLL */

/*@ Extern Coq
      (OsAssignReadyVectorAbs :: *) (VarAssignAbs :: *)
 */
/*@ Extern Coq
      (Zlength : {A} -> list A -> Z)
      (update_sched_member : TaskDescriptorAbs -> TaskSchedMemberAbs -> TaskDescriptorAbs)
      (set_sched_member_priority : TaskSchedMemberAbs -> Z -> TaskSchedMemberAbs)
      (ktask_startup_state :
        VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
      (ktask_startup_frame :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (ktask_startup_insert_frame : StableGlobalState -> VarGlobalState -> Z -> Assertion)
      (ktask_startup_get_post :
        (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (ktask_startup_assign_post :
        (Z -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
      (task_addr_aligned : Z -> OsAssignReadyVectorAbs -> Prop)
      (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
      (update_task_desc_map :
        Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) ->
        Z -> option TaskDescriptorAbs)
      (assign_insert_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
      (abs_ktask_startup :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (ktask_startup_body : Z -> program (VarGlobalState -> Prop) Z)
      (abs_get_ktask_descriptor : program (VarGlobalState -> Prop) Z)
 */

/*
 * The insertion Spec below is copied verbatim from assign_ready_insert.c.
 * ktask_unset_delay.h supplies null_delay for the first-start case.
 * Status queries come from ktask_set_status.h.
 * Lock Specs are primitive boundaries;
 * the NULL-check model is verified in null_paramter_check.c. The OC getter
 * contract below matches its verified source.
 */
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
 * Inclusive priority domain approved for startup. The isolated bitmap31
 * proof covers this contract in the current QCP integer model, including 31.
 * The original signed expression is 1 << cur_prio; this is not an ISO C11
 * signed-shift safety claim. bitmap_site_mask.c verifies the approved
 * outer-parentheses normalization of the original assignment.
 */
static inline void __BitmapSiteMask(struct TaskDescriptor *task)
/*@ With (prio : Z)
    Require 0 <= prio && prio <= 31 &&
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      has_permission(&(task->task_dync_sched_member.bitmap_column))
    Ensure
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      store_uint(&(task->task_dync_sched_member.bitmap_column), 1 << prio)
 */;

KTaskDescriptorType GetKTaskDescriptor(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_get_ktask_descriptor, X) &&
      OutsideCritical(sg, before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after)
 */;

/*
 * Use this project's remove_self case from m_double_linklist.h, whose
 * implementation slice is double_link_remove_self.c. The sched-member
 * payload remains the caller's frame. Its node != 0 obligation must still
 * be derived at this call site. No crtosverify carrier adaptation is used.
 */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/* remove_self is already declared in m_double_linklist.h. */;

/*
 * The checked OC contract preserves the original caller obligation.
 * Internal proof annotations below
 * rebuild task-owned scalar resources. Before
 * KTaskInsertToReadyVector, the modified scalar fields must be folded back
 * into task_fields; its returned task_fields then owns the READY descriptor.
 *
 * The caller establishes safeExec of abs_ktask_startup, including
 * its assertS entry condition. The ordinary lock and Crtos_CS stay unchanged.
 * The first lock's local view extracts this precondition at its actual state.
 * The checked condition supplies registration, masked INIT and delay == 0
 * for the same descriptor at first lock entry. Field permissions must still
 * be extracted from os_inv's descriptor cell; its detached view supplies only sched_link.
 * Extract the checked condition only there, then drop the checked safety
 * premise at the full Assert cut, retaining relational safeExec of the body.
 * Later VCs must use the fixed entry facts and resources, never this premise
 * again (including unfolded or copied forms). It is an ordinary Prop, so
 * which-implies alone cannot enforce this proof boundary.
 * task_world_wf, the bitmap helper and the locked relation all cover [0,31]
 * in the current QCP integer model. Callee closure and local resource proofs
 * still require concrete verification.
 * A partial abstract relation cannot supply missing C memory permissions.
 * On success, the whole final if is modeled by one empty critical section.
 */

x_err_t _StartupKTask(KTaskDescriptorType task)
/*@ outside_critica
    With (sg : StableGlobalState) (st_before : VarGlobalState) X
    Require
      safeExec(LastSeen(st_before), abs_ktask_startup(sg, task), X) &&
      OutsideCritical(sg, st_before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after)
 */
{
    x_base lock = 0;

    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = st_before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(st_before), abs_ktask_startup(sg, task), X) &&
        Crtos_RTrans(st_before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        exists desc,
        safeExec(LastSeen(st_before), ktask_startup_body(task), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        desc.tdSchedMember.tsmStat == TSK_INIT && desc.tdDelay == 0 &&
        Crtos_RTrans(st_before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */
    /*
     * Full proof cut: do not carry checked safety into any later VC.
     * Preserve both local slots; the ordinary lock's return is unspecified.
     * Entry facts concern this fixed st_lock, not a later observed state.
     */
    /*@ Assert exists lock_saved,
        safeExec(LastSeen(st_before), ktask_startup_body(task@pre), X) &&
        st_lock.os_tasks.task_desc_map(task@pre) == Some(desc) &&
        desc.tdSchedMember.tsmStat == TSK_INIT && desc.tdDelay == 0 &&
        Crtos_RTrans(st_before, st_lock) &&
        store_ptr(&task, task@pre) *
        store(&lock, signed long, lock_saved) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given lock_saved */

    /*@ st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        desc.tdSchedMember.tsmStat == TSK_INIT && desc.tdDelay == 0 &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
          os_global_context(sg) &&
          assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          desc.tdSchedMember.tsmStat == TSK_INIT &&
          desc.tdDelay == 0 &&
          0 <= desc.tdBaseInfo.tbOriginPrio &&
          desc.tdBaseInfo.tbOriginPrio <= 31 &&
          task_addr_aligned(task, st_lock.os_assign.assignReadyVector) &&
          sched_link_of(task) != 0 &&
          Zlength(st_lock.os_assign.assignReadyVector.orvBuckets) == 32 &&
          InsideCritical(sg, st_lock) * ktask_startup_frame(sg, st_lock, task, desc) * delay_inv(sg, st_lock) *
          store_uchar(&(task->task_base_info.origin_prio), desc.tdBaseInfo.tbOriginPrio) *
          store_ptr(&(task->task_dync_sched_member.delay), 0) *
          store_task_status(&(task->task_dync_sched_member.stat), desc.tdSchedMember.tsmStat) *
          store_uchar(&(task->task_dync_sched_member.advance_cnt), desc.tdSchedMember.tsmAdvanceCnt) *
          store_uchar(&(task->task_dync_sched_member.cur_prio), desc.tdSchedMember.tsmCurPrio) *
          store_uint(&(task->task_dync_sched_member.origin_timeslice), desc.tdSchedMember.tsmOriginTimeslice) *
          store_uint(&(task->task_dync_sched_member.rest_timeslice), desc.tdSchedMember.tsmRestTimeslice) *
          store_uint(&(task->task_dync_sched_member.bitmap_column), desc.tdSchedMember.tsmBitmapColumn) *
          store_node_self_linked(sched_link_of(task)) *
          store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), st_lock.os_assign.assignReadyVector)
     */
    NULL_PARAM_CHECK_1(task);

    if(JudgeKTaskStatIsInit(task) != RET_TRUE) {
        /*@ Assert 0 == 1 && emp */
    //    SYS_KDEBUG_LOG(KDBG_KTASK, ("task [%s] stat [%d] is not init\n",
    //                                task->task_base_info.name, task->task_dync_sched_member.stat));
        CriticalAreaUnLock(lock) /*@ where (stable) */;
        return -ERROR;
    }

    task->task_dync_sched_member.cur_prio = task->task_base_info.origin_prio;

    
    __BitmapSiteMask(task);

    
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
        /*@ where (remove_self) */;
    
    /*
     * The framed delay slot still contains 0: preceding writes and callees
     * touch only scheduling fields and sched_link. Prove this from the cut's
     * resources; do not reapply the entry premise. No delay view split here.
     */
    
    KTaskUnSetDelay(task)
        /*@ where (null_delay) sg = sg, st_before = st_lock, desc = desc */;
    
// #ifdef ARCH_SMP
//     HwLockSpinlock(&AssignSpinLock);
// #endif
    /*@ assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        desc.tdDelay == 0 &&
        0 <= desc.tdBaseInfo.tbOriginPrio &&
        desc.tdBaseInfo.tbOriginPrio <= 31 &&
        ktask_startup_frame(sg, st_lock, task, desc) * delay_inv(sg, st_lock) *
        store_uchar(&(task->task_base_info.origin_prio), desc.tdBaseInfo.tbOriginPrio) *
        store_ptr(&(task->task_dync_sched_member.delay), 0) *
        store_task_status(&(task->task_dync_sched_member.stat), desc.tdSchedMember.tsmStat) *
        store_uchar(&(task->task_dync_sched_member.advance_cnt), desc.tdSchedMember.tsmAdvanceCnt) *
        store_uchar(&(task->task_dync_sched_member.cur_prio), desc.tdBaseInfo.tbOriginPrio) *
        store_uint(&(task->task_dync_sched_member.origin_timeslice), desc.tdSchedMember.tsmOriginTimeslice) *
        store_uint(&(task->task_dync_sched_member.rest_timeslice), desc.tdSchedMember.tsmRestTimeslice) *
        store_uint(&(task->task_dync_sched_member.bitmap_column), 1 << desc.tdBaseInfo.tbOriginPrio) *
        store_node_self_linked(sched_link_of(task)) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), st_lock.os_assign.assignReadyVector)
        which implies
        (replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map(task) == Some(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))) &&
        ktask_startup_insert_frame(sg, st_lock, task) *
        task_fields(sg, replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock)) *
        occupy_dll_node(sched_link_of(task)) *
        assign_ready_pending(sg, replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock))
     */
    KTaskInsertToReadyVector(task)
        /*@ where sg = sg, st = replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock),
                  desc = update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)) */;
    /*@ Given before after st' */
// #ifdef ARCH_SMP
//     HwUnlockSpinlock(&AssignSpinLock);
// #endif
    /*@ st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        desc.tdSchedMember.tsmStat == TSK_INIT &&
        desc.tdDelay == 0 &&
        Zlength(st_lock.os_assign.assignReadyVector.orvBuckets) == 32 &&
        Crtos_RTrans(st_before, st_lock) &&
        safeExec(LastSeen(st_before), ktask_startup_body(task), X) &&
        assign_insert_step_ic((replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map, task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), before, after) &&
        before == st_lock.os_assign.assignReadyVector &&
        st' == replace_global_ready_vector(after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))), (replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map), replace_task_desc_map(update_task_desc_map(task, update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio)), st_lock.os_tasks.task_desc_map), st_lock))) &&
        InsideCritical(sg, st_lock) * ktask_startup_insert_frame(sg, st_lock, task) *
        task_fields(sg, st') * assign_ready_pending(sg, st')
        which implies
        safeExec(LastSeen(ktask_startup_state(st_lock, task, set_task_desc_ready(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))), after)), abs_get_ktask_descriptor, ktask_startup_get_post(X)) &&
        Crtos_GTrans(st_lock, ktask_startup_state(st_lock, task, set_task_desc_ready(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))), after)) &&
        InsideCritical(sg, st_lock) * os_inv(sg, ktask_startup_state(st_lock, task, set_task_desc_ready(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))), after))
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = ktask_startup_state(st_lock, task, set_task_desc_ready(update_sched_member(desc, set_sched_member_priority(desc.tdSchedMember, desc.tdBaseInfo.tbOriginPrio))), after) */;

    // SYS_KDEBUG_LOG(KDBG_KTASK, ("task [%s] is ready to run,the priority is [%d]\n",
    //                                task->task_base_info.name, task->task_base_info.origin_prio));

    if (GetKTaskDescriptor()
          /*@ where (outside_critical) X = ktask_startup_get_post(X) */ != NONE) {
        /*@ Assert exists observed running,
            running != 0 &&
            safeExec(LastSeen(observed), return(running), ktask_startup_get_post(X)) &&
            store_ptr(&task, task@pre) * store(&lock, signed long, lock_saved) *
            OutsideCritical(sg, observed) */
        /*@ Given observed running */
        /*@ running != 0 &&
            safeExec(LastSeen(observed), return(running), ktask_startup_get_post(X)) &&
            OutsideCritical(sg, observed)
            which implies
            safeExec(LastSeen(observed), abs_ktask_assign, ktask_startup_assign_post(X)) &&
            OutsideCritical(sg, observed)
         */
        KTASK_ASSIGN()
            /*@ where (outside_critical) before = observed, X = ktask_startup_assign_post(X) */;
        /*@ exists after,
            safeExec(LastSeen(after), return(tt), ktask_startup_assign_post(X)) &&
            OutsideCritical(sg, after)
            which implies
            exists after,
              safeExec(LastSeen(after), return(KOK), X) && OutsideCritical(sg, after)
         */
    }
    /*@ Assert exists after,
        safeExec(LastSeen(after), return(KOK), X) &&
        store_ptr(&task, task@pre) *
        store(&lock, signed long, lock_saved) * OutsideCritical(sg, after)
     */

    return EOK;
}
