#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.GetTaskWithIdnode */
/*@ Import Coq Require Import CRTOS_Verify.libai.CriticalViews */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_suspend_lib */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskSafeExec */

/*@ Extern Coq
      (DL_Node :: * => *)
      (option :: * => *)
 */

/*@ Extern Coq
      (os_task_fields_frame : StableGlobalState -> VarGlobalState -> Assertion)
      (task_fields_id_frame : StableGlobalState -> VarGlobalState -> Assertion)
      (KNONE : Z)
      (LastSeen :
        VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_task_with_idnode :
        StableGlobalState -> Z ->
        program (VarGlobalState -> Prop) (option Z))
      (Some : {A} -> A -> option A)
      (None : {A} -> option A)
      (task_link_nodes : list Z -> list(DL_Node Z))
      (task_world_wf : VarGlobalState -> Prop)
      (pure_task_link_member : Z -> Z -> Assertion)
      (store_published_task :
        Z -> TaskDescriptorAbs -> Assertion)
      (store_map : {A} {B} ->
        (A -> B -> Assertion) -> (A -> option B) -> Assertion)
      (delay_inv :
        StableGlobalState -> VarGlobalState -> Assertion)
      (assign_inv :
        StableGlobalState -> VarGlobalState -> Assertion)
      (get_task_with_idnode_success :
        StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 */

/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_id_view.strategies" */

KTaskDescriptorType CONTAINER_OF_TASK_ID(struct IdNode *id_ptr)
/*@ With (task : Z)
    Require id_ptr == field_addr(task, struct TaskDescriptor, id) && emp
    Ensure __return == task &&
           id_ptr == &(__return->id)
*/;

inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ With (sg : StableGlobalState)
         (before : VarGlobalState)
         X
    Require id < 65536 &&
        safeExec(
            LastSeen(before),
            abs_get_task_with_idnode(sg, id), X) &&
        OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == KNONE &&
        safeExec(
          LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        safeExec(
          LastSeen(after), return(Some(__return)), X) &&
        OutsideCritical(sg, after))
*/
{
    struct TaskDescriptor *task = NONE;
    struct IdNode *idnode = NONE;
    x_base lock = 0;

    if (id < 0)
        /*@ id < 0 &&
            safeExec(
              LastSeen(before),
              abs_get_task_with_idnode(sg, id), X) &&
            OutsideCritical(sg, before)
            which implies
            safeExec(
              LastSeen(before), return(None), X) &&
            OutsideCritical(sg, before) *
            store(&id, signed int, id)
         */
        return NONE;

    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    idnode = IdGetObj(&k_task_id_manager, id);
    if (idnode == NONE){
        /*@ 0 <= id && id < 65536 &&
            Crtos_RTrans(before, st_lock) &&
            idmanager_query(st_lock.os_tasks.task_idmanager_abs, id) == false &&
            safeExec(
              LastSeen(before),
              abs_get_task_with_idnode(sg, id), X) &&
            task_world_wf(st_lock) &&
            InsideCritical(sg, st_lock) *
            os_inv(sg, st_lock)
            which implies
            safeExec(
              LastSeen(st_lock), return(None), X) &&
            Crtos_GTrans(st_lock, st_lock) &&
            store(&id, signed int, id) *
            InsideCritical(sg, st_lock) *
            os_inv(sg, st_lock)
         */
        CriticalAreaUnLock(lock)
            /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return NONE;
    }
    /*@ task_world_wf(st_lock) &&
        idmanager_query(st_lock.os_tasks.task_idmanager_abs, id) == true &&
        InsideCritical(sg, st_lock) *
        store_idmanager_found(
          sg.os_task_stable.task_stable_ids, st_lock.os_tasks.task_idmanager_abs,
          &k_task_id_manager, idnode, id) *
        task_fields_id_frame(sg, st_lock) *
          os_task_fields_frame(sg, st_lock)
        which implies
        exists found_task,
          task_world_wf(st_lock) &&
          idnode == field_addr(found_task, struct TaskDescriptor, id) &&
          get_task_with_idnode_success(
            sg, st_lock, id, found_task) &&
          InsideCritical(sg, st_lock) *
          store_idmanager(
            sg.os_task_stable.task_stable_ids, st_lock.os_tasks.task_idmanager_abs,
            &k_task_id_manager) *
          task_fields_id_frame(sg, st_lock) *
          os_task_fields_frame(sg, st_lock)
     */
    /*@ Given found_task */
    task = CONTAINER_OF_TASK_ID(idnode)
        /*@ where task = found_task */;
    /*@ 0 <= id && id < 65536 &&
        Crtos_RTrans(before, st_lock) &&
        get_task_with_idnode_success(sg, st_lock, id, task) &&
        safeExec(
          LastSeen(before),
          abs_get_task_with_idnode(sg, id), X) &&
        task_world_wf(st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
        which implies
        safeExec(
          LastSeen(st_lock), return(Some(task)), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store(&id, signed int, id) *
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return task;
}
