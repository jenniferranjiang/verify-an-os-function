#include "ktask_delete_name.h"
#include "ktask_delete_resource.h"
#include "ktask_zombie_nonempty.h"
#include "ktask_assign_oc.h"
#include "ktask_wakeup.h"
#include "zombie_views.h"
#include "task_delete_views.h"
/*@ include strategies "zombie_views.strategies" */
/*@ include strategies "task_delete_views.strategies" */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteRestore */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_delete_oc_lib */
/*@ Extern Coq (ServicePhase :: *) */
/*@ Extern Coq
 (service_phase : ServiceSlotAbs -> ServicePhase)
 (ServiceRegistered : Z -> ServicePhase)
 (abs_ktask_delete : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (ktask_delete_body : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (ktask_delete_checked_body : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (delete_name_post : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
 (ktask_startup_assign_post : (Z -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
 (ktask_delete_not_service : Z -> VarGlobalState -> Prop)
 (ktask_delete_enqueue_transition : Z -> VarGlobalState -> VarGlobalState -> Prop)
 (delete_outer_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 (delete_enqueue_restore : StableGlobalState -> VarGlobalState -> VarGlobalState -> Z -> list(DL_Node Z) -> Assertion)
 (pure_close_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
 */

extern int32 zombie_recycle;
/* ktask_delete.c 中外层函数的独立验证切片，函数体语句保持一致。
 * 两个 helper 从其已验证 header 导入；锁、调度和 libc 仍沿用现有边界。
 * 状态更新及两次锁之间的 checked 消费属于本算法，显式标记证明 cut；
 * 删除资源的借还与入队后恢复由 task_delete_views 策略完成；
 * 队列与 recycler ID 的只读借还由 zombie_views 策略完成。 */
x_err_t _DeleteKTask(KTaskDescriptorType task)
/*@ delete_oc
    With LitMap (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_delete(sg, task), X) &&
      OutsideCritical(sg, before) * GlobalStrings(LitMap)
    Ensure exists after,
      ((__return == -INVALID && safeExec(LastSeen(after), return(-INVALID), X)) ||
       (__return == KOK && safeExec(LastSeen(after), return(KOK), X))) &&
      OutsideCritical(sg, after) * GlobalStrings(LitMap)
 */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);
    /*@ safeExec(LastSeen(before), abs_ktask_delete(sg, task), X) &&
        OutsideCritical(sg, before)
        which implies
        safeExec(LastSeen(before), abs_ktask_delete_name(sg, task), delete_name_post(sg, task, X)) &&
        OutsideCritical(sg, before)
     */
    if(RET_TRUE == __JudgeKTaskIsIdleOrZombierecycle(task)
        /*@ where (delete_name_oc) sg = sg, before = before, X = delete_name_post(sg, task, X), LitMap = LitMap */) {
        /*@ Given after_name from after */
        /*@ Assert
          safeExec(LastSeen(after_name), return(1), delete_name_post(sg, task@pre, X)) &&
          store_ptr(&task, task@pre) * store(&lock, signed long, 0) *
          OutsideCritical(sg, after_name) * GlobalStrings(LitMap)
         */
        /*@ task == task@pre &&
            safeExec(LastSeen(after_name), return(1), delete_name_post(sg, task, X)) &&
            OutsideCritical(sg, after_name)
            which implies
            safeExec(LastSeen(after_name), return(-INVALID), X) &&
            store_ptr(&task, task@pre) * OutsideCritical(sg, after_name)
         */
        return -EINVALED;
    }
    /*@ Given after_name from after */
    /*@ Assert
      task@pre != 0 &&
      safeExec(LastSeen(after_name), return(0), delete_name_post(sg, task@pre, X)) &&
      store_ptr(&task, task@pre) * store(&lock, signed long, 0) *
      OutsideCritical(sg, after_name) * GlobalStrings(LitMap)
     */
    /*@ safeExec(LastSeen(after_name), return(0), delete_name_post(sg, task, X)) &&
        OutsideCritical(sg, after_name)
        which implies
        safeExec(LastSeen(after_name), ktask_delete_checked_body(sg, task), X) &&
        OutsideCritical(sg, after_name)
     */

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = after_name */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(after_name), ktask_delete_checked_body(sg, task), X) &&
        Crtos_RTrans(after_name, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc initial_nodes registered_recycler,
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        ktask_delete_not_service(task, st_lock) &&
        zombie_queue(st_lock) == ZombieLinked(initial_nodes) &&
        service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
        service_id(os_recycle(st_lock)) < 65536 &&
        safeExec(LastSeen(after_name), ktask_delete_body(sg, task), X) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc initial_nodes registered_recycler */
    /* checked 安全性在此完整 cut 消耗，后续只保留固定观察及关系体。 */
    /*@ Assert exists saved_lock,
        task@pre != 0 && Crtos_RTrans(after_name, st_lock) &&
        st_lock.os_tasks.task_desc_map(task@pre) == Some(desc) &&
        ktask_delete_not_service(task@pre, st_lock) &&
        zombie_queue(st_lock) == ZombieLinked(initial_nodes) &&
        service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
        service_id(os_recycle(st_lock)) < 65536 &&
        safeExec(LastSeen(after_name), ktask_delete_body(sg, task@pre), X) &&
        store_ptr(&task, task@pre) * store(&lock, signed long, saved_lock) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * GlobalStrings(LitMap)
     */
    /*@ Given saved_lock */
    _KTaskResourceDelete(task)
        /*@ where (resource_delete_registered_ic) sg = sg, before = st_lock, desc = desc */;
    /*@ Given removed from after */
    /* 保存本算法的状态关系与 continuation；资源展开由入队需求触发。 */
    /*@ Assert exists queued nodes,
        task == task@pre && task != 0 && Crtos_RTrans(after_name, st_lock) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        ktask_delete_not_service(task, st_lock) &&
        zombie_queue(st_lock) == ZombieLinked(initial_nodes) &&
        service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
        service_id(os_recycle(st_lock)) < 65536 &&
        safeExec(LastSeen(after_name), ktask_delete_body(sg, task), X) &&
        ktask_resource_delete_transition(task, desc, st_lock, removed) && os_world_wf(sg, removed) &&
        ktask_delete_enqueue_transition(task, removed, queued) &&
        os_recycle(queued) == os_recycle(st_lock) &&
        zombie_queue(queued) == ZombieLinked(cons(sched_link_node(task), nodes)) &&
        sched_link_of(task) != 0 && sched_link_of(task) == &(task->task_dync_sched_member.sched_link) &&
        &(task->task_dync_sched_member.sched_link) != 0 &&
        dll_insert_anchor(&KTaskZombie, nodes, &KTaskZombie) &&
        store_dll(pure_close_sched_link(removed.os_tasks.task_desc_map), &KTaskZombie, nodes) *
        pure_close_sched_link(removed.os_tasks.task_desc_map, &(task->task_dync_sched_member.sched_link), task) *
        occupy_dll_node(&(task->task_dync_sched_member.sched_link)) *
        delete_enqueue_restore(sg, removed, queued, task, nodes) *
        store(&lock, signed long, saved_lock) * InsideCritical(sg, st_lock) * GlobalStrings(LitMap)
     */
    /*@ Given queued nodes */
    DoubleLinkListInsertNodeAfter(&KTaskZombie, &(task->task_dync_sched_member.sched_link))
        /*@ where (dispatch_case) head = &KTaskZombie, nodes = nodes,
            storeA = pure_close_sched_link(removed.os_tasks.task_desc_map), a = task; A = Z */;
    if (JudgeZombieKTaskIsNotEmpty()
        /*@ where (zombie_known_nonempty_ic) T = queued.os_tasks.task_desc_map, nodes = cons(sched_link_node(task@pre), nodes) */) {
        /* QCP 的直接全局变量读取不进入解引用策略；在这里显式提出只读需求。
         * 原 ID 槽由 core 规则在 Wakeup 的 os_inv 需求处收回。 */
        /*@ service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
            os_recycle(queued) == os_recycle(st_lock) && os_inv(sg, queued)
            which implies
            ktask_wakeup_detached_null_condition(sg, queued, service_id(os_recycle(queued))) &&
            store_int(&zombie_recycle, service_id(os_recycle(queued))) * os_recycler_id_frame(sg, queued)
         */
        KTaskWakeup(zombie_recycle)
            /*@ where (detached_sched_null_delay) sg = sg, before = queued */;
        /*@ Given recycler from task */
        /*@ Given rdesc from desc */
        /*@ Given after_wakeup from after */
    }
    /*@ Assert exists final_locked,
        Crtos_GTrans(st_lock, final_locked) &&
        safeExec(LastSeen(final_locked), abs_ktask_assign, ktask_startup_assign_post(X)) &&
        store_ptr(&task, task@pre) * store(&lock, signed long, saved_lock) *
        InsideCritical(sg, st_lock) * os_inv(sg, final_locked) * GlobalStrings(LitMap)
     */
    /*@ Given final_locked */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = final_locked */;

    KTASK_ASSIGN()
        /*@ where (outside_critical) sg = sg, before = final_locked, X = ktask_startup_assign_post(X) */;
    /*@ Given final_seen from after */
    /*@ safeExec(LastSeen(final_seen), return(tt), ktask_startup_assign_post(X)) &&
        OutsideCritical(sg, final_seen)
        which implies safeExec(LastSeen(final_seen), return(KOK), X) && OutsideCritical(sg, final_seen)
     */
    return EOK;
}
