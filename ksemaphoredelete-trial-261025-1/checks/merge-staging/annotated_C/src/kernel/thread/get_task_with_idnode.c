#include "m_ktask.h"

/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */

/*@ Extern Coq
      (task_world_wf : VarGlobalState -> Prop)
      (get_task_with_idnode_success :
        StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 */

KTaskDescriptorType CONTAINER_OF_TASK_ID(struct IdNode *id_ptr)
/*@ With (task : Z)
    Require id_ptr == field_addr(task, struct TaskDescriptor, id) && emp
    Ensure __return == task &&
           id_ptr == &(__return->id)
*/
;

/*
 * 锁内只读查询只借用 ID-manager；调用方其余临界区资源作为 frame 保留。
 * outside_critical/get_task_with_idnode_oc.c 保留原本加锁/解锁版本。
 */
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      id < 65536 &&
      task_world_wf(st) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      ((__return == 0 &&
        (id < 0 || idmanager_query(st.os_tasks.task_idmanager_abs, id) == false))
       ||
       get_task_with_idnode_success(sg, st, id, __return)) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
 */
;

inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_known <= inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState) (target : Z)
    Require
      id < 65536 &&
      task_world_wf(st) &&
      get_task_with_idnode_success(sg, st, id, target) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      __return == target &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
 */
;

/*
 * 验证切片中按本次人工授权注释原 CriticalArea 调用；
 * 其余可执行语句与原查询实现保持一致。
 */
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical */
{
    struct TaskDescriptor *task = NONE;
    struct IdNode *idnode = NONE;
    x_base lock = 0;

    if (id < 0)
        return NONE;

    // lock = CriticalAreaLock();
    idnode = IdGetObj(&k_task_id_manager, id);
    if (idnode == NONE){
        // CriticalAreaUnLock(lock);
        return NONE;
    }
    /*@ task_world_wf(st) &&
        idmanager_query(st.os_tasks.task_idmanager_abs, id) == true &&
        store_idmanager_found(
          sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
          &k_task_id_manager, idnode, id)
        which implies
        exists found_task,
          idnode == field_addr(found_task, struct TaskDescriptor, id) &&
          get_task_with_idnode_success(sg, st, id, found_task) &&
          store_idmanager(
            sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
            &k_task_id_manager)
     */
    /*@ Given found_task */
    task = CONTAINER_OF_TASK_ID(idnode)
        /*@ where task = found_task */;
    // CriticalAreaUnLock(lock);
    return task;
}
