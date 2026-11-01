#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c. Current 32-bit non-SMP configuration. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sidm, idm, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/;

KTaskDescriptorType CONTAINER_OF_TASK_ID(struct IdNode *id_ptr)
/*@ With (task : Z)
    Require id_ptr == field_addr(task, struct TaskDescriptor, id) && emp
    Ensure __return == task &&
           id_ptr == &(__return->id)
*/;

struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
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
{
    struct TaskDescriptor *task = NONE;
    struct IdNode *idnode = NONE;
    x_base lock = 0;

    if (id < 0)
        return NONE;

    /* Nested critical operation removed under the documented inside-critical adaptation. */
    idnode = IdGetObj(&k_task_id_manager, id);
    if (idnode == NONE){
        
        return NONE;
    }
    task =CONTAINER_OF_TASK_ID(idnode);
    
    return task;
}
