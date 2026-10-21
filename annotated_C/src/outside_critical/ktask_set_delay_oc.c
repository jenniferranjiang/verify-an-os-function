
#include "m_ktask.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Import DLL */

/*@ Extern Coq (DL_Node :: * => *)
*/
/*@ Extern Coq Record TaskDelayAbs {
      tdTaskPtr: Z;
      tdTicks: Z;
      tdStatus: Z;
    }
*/
/*@ Extern Coq
      (store_delay_info : Z -> TaskDelayAbs -> Assertion)
      (store_task_delay_opt :
        Z -> Z -> list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_unlinked_info :
        Z -> TaskDelayAbs -> Assertion)
      (store_delay_dll_focus :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_head_frame :
        Z -> list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_dll_next_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_scan :
        Z -> Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (delay_prefix_scanned :
        Z -> list(DL_Node TaskDelayAbs) -> Prop)
      (delay_nodes_wf : list(DL_Node TaskDelayAbs) -> Prop)
      (mkTaskDelayAbs : Z -> Z -> Z -> TaskDelayAbs)
      (delay_remove_old :
        Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (delay_insert_by_ticks :
        DL_Node TaskDelayAbs -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (TASK_DELAY_INACTIVE_VALUE : Z)
      (TASK_DELAY_ACTIVE_VALUE : Z)
      (heartbeat_ticks_addr : Z)
*/

x_ticks_t CurrentTicksGain(void)
/*@ With os_tick
    Require store_uint(heartbeat_ticks_addr, os_tick)
    Ensure __return == os_tick &&
           store_uint(heartbeat_ticks_addr, os_tick)
 */
;

struct Delay *CONTAINER_OF_DELAY_LINK(DoubleLinklistType *link_ptr)
/*@ With delay_ptr
    Require link_ptr == field_addr(delay_ptr, struct Delay, link) && emp
    Ensure __return == delay_ptr &&
           link_ptr == &(__return->link)
 */
;

// ** 当前为临界区内版本 **

/* store_task_delay_opt有以下三种情况：
  Let store(&(task -> ... .ₛ "delay"), delay_before) in 
  
  - delay_before = NONE;
  - store(delay_before, node), node不在delay link list中；
  - node在delay link list中；

  三种情况在设置完ticks后，都会把一个node插入delay link list；
*/

x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
/*@ With (delay_nodes : list(DL_Node TaskDelayAbs))
         (os_tick delay_before : Z)
    Require task != 0 &&
            0 <= ticks && ticks <= UINT_MAX &&
            delay_nodes_wf(delay_nodes) &&
            store_dll(
              store_delay_info, &xiaoshan_delay_head, delay_nodes) *
            store_uint(heartbeat_ticks_addr, os_tick) *
            store_task_delay_opt(task, delay_before, delay_nodes)
    Ensure store_uint(heartbeat_ticks_addr, os_tick) *
           (
             (__return == -NOMEMORY &&
              delay_before == 0 &&
              delay_nodes_wf(delay_nodes) &&
              store_dll(
                store_delay_info, &xiaoshan_delay_head, delay_nodes) *
              store_task_delay_opt(task, delay_before, delay_nodes))
             ||
             (__return == KOK &&
              exists delay_after delay_nodes_after,
                delay_after != 0 &&
                delay_nodes_after ==
                  delay_insert_by_ticks(
                    Build_DL_Node(
                      mkTaskDelayAbs(
                        task,
                        unsigned_last_nbits(os_tick + ticks, 32),
                        TASK_DELAY_ACTIVE_VALUE),
                      field_addr(delay_after, struct Delay, link)),
                    delay_remove_old(delay_before, delay_nodes)) &&
                delay_nodes_wf(delay_nodes_after) &&
                store_dll(
                  store_delay_info,
                  &xiaoshan_delay_head,
                  delay_nodes_after) *
                store_ptr(
                  &(task->task_dync_sched_member.delay), delay_after))
           )
 */
{
	x_base lock = 0;
    struct Delay *delay = NONE;
    struct Delay *dnode = NONE;
    DoubleLinklistType *nodelink = NONE;

    NULL_PARAM_CHECK_1(task);

    if (task->task_dync_sched_member.delay == NONE) {
	   delay = (struct Delay *)x_malloc(sizeof(struct Delay))
           /*@ where (delay_object) */;
       if (delay == NONE)
       {
           return -ENOMEMORY;
       }
       memset(delay, 0x0, sizeof(struct Delay));
       task->task_dync_sched_member.delay = delay;
    } else {
        delay = task->task_dync_sched_member.delay;

        lock = CriticalAreaLock();
        if(delay->status == TASK_DELAY_ACTIVE){
            delay->status = TASK_DELAY_INACTIVE;

            DoubleLinkListRmNode(&(delay->link))
                /*@ where (remove_member); A = TaskDelayAbs */;
        }
        CriticalAreaUnLock(lock);
    }

	delay->ticks = CurrentTicksGain() + ticks;
    delay->task = task;
    delay->status = TASK_DELAY_ACTIVE;

	lock = CriticalAreaLock();

    for (nodelink = xiaoshan_delay_head.node_next;
         nodelink != &xiaoshan_delay_head;
         nodelink = nodelink->node_next) {

        /*@ Given current_delay */
        dnode = CONTAINER_OF_DELAY_LINK(nodelink)
            /*@ where delay_ptr = current_delay */;
        if (delay->ticks < dnode->ticks) {

            DoubleLinkListInsertNodeBefore(nodelink, &delay->link);

            break;
        }

    }

    if (nodelink == &xiaoshan_delay_head) {

        DoubleLinkListInsertNodeBefore(&xiaoshan_delay_head, &(delay->link));

    }

    CriticalAreaUnLock(lock);

	return EOK;
}
