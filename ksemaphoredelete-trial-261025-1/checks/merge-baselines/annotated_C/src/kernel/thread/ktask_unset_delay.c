#include "ktask_unset_delay.h"
#include "delay_views_strategy.h"

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
      (store_node_self_linked : Z -> Assertion)
      (store_delay_dll_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (delay_nodes_wf : list(DL_Node TaskDelayAbs) -> Prop)
      (mkTaskDelayAbs : Z -> Z -> Z -> TaskDelayAbs)
      (TASK_DELAY_INACTIVE_VALUE : Z)
      (TASK_DELAY_ACTIVE_VALUE : Z)
*/


// KTaskUnSetDelay总在临界区内被调用，故注释其内部锁

x_err_t KTaskUnSetDelay(KTaskDescriptorType task)
/*@ unset_delay_unified */
{
	x_base lock = 0;
    struct Delay *delay = NONE;

	NULL_PARAM_CHECK_1(task);

	/*@ store_ktask_unset_delay_pre(task, delay_view)
        which implies
        (delay_view == vDelayNull &&
         store_ptr(
           &(task->task_dync_sched_member.delay), 0))
        ||
        (exists delay_ptr_inactive delay_abs_inactive,
           delay_view ==
             vDelayInactive(delay_ptr_inactive, delay_abs_inactive) &&
           delay_ptr_inactive != 0 &&
           addr_aligned(delay_ptr_inactive, ALIGN_SIZE) &&
           delay_abs_inactive.tdStatus ==
             TASK_DELAY_INACTIVE_VALUE &&
           delay_abs_inactive.tdStatus == 0 &&
           store_ptr(
             &(task->task_dync_sched_member.delay),
             delay_ptr_inactive) *
           store_ptr(
             field_addr(delay_ptr_inactive, struct Delay, task),
             delay_abs_inactive.tdTaskPtr) *
           store_uint(
             field_addr(delay_ptr_inactive, struct Delay, ticks),
             delay_abs_inactive.tdTicks) *
           store_uchar(
             field_addr(delay_ptr_inactive, struct Delay, status),
             delay_abs_inactive.tdStatus) *
           CharArray::full(
             delay_ptr_inactive + 9,
             3, cons(0, cons(0, cons(0, nil)))))
        ||
        (exists delay_ptr_active delay_abs_before_active
                prefix_active suffix_active,
           delay_view ==
             vDelayActive(
               delay_ptr_active, delay_abs_before_active,
               prefix_active, suffix_active) &&
           delay_ptr_active != 0 &&
           addr_aligned(delay_ptr_active, ALIGN_SIZE) &&
           delay_abs_before_active.tdTaskPtr == task &&
           delay_abs_before_active.tdStatus ==
             TASK_DELAY_ACTIVE_VALUE &&
           delay_abs_before_active.tdStatus == 1 &&
           delay_nodes_wf(app(prefix_active, suffix_active)) &&
           store_ptr(
             &(task->task_dync_sched_member.delay),
             delay_ptr_active) *
           store_delay_dll_frame(
             &xiaoshan_delay_head,
             prefix_active,
             Build_DL_Node(
               delay_abs_before_active,
               field_addr(delay_ptr_active, struct Delay, link)),
             suffix_active) *
           store_ptr(
             field_addr(delay_ptr_active, struct Delay, task),
             delay_abs_before_active.tdTaskPtr) *
           store_uint(
             field_addr(delay_ptr_active, struct Delay, ticks),
             delay_abs_before_active.tdTicks) *
           store_uchar(
             field_addr(delay_ptr_active, struct Delay, status),
             delay_abs_before_active.tdStatus) *
           CharArray::full(
             delay_ptr_active + 9,
             3, cons(0, cons(0, cons(0, nil)))))
     */

	delay = task->task_dync_sched_member.delay;
   
	if( delay != NONE && delay->status == TASK_DELAY_ACTIVE) {
	    /*@ Assert
	          exists delay_ptr_active delay_abs_before_active
	                 prefix_active suffix_active,
	            lock == 0 &&
	            task == task@pre &&
	            delay == delay_ptr_active &&
	            delay_view ==
	              vDelayActive(
	                delay_ptr_active, delay_abs_before_active,
	                prefix_active, suffix_active) &&
	            delay_ptr_active != 0 &&
	            addr_aligned(delay_ptr_active, ALIGN_SIZE) &&
	            delay_abs_before_active.tdTaskPtr == task &&
	            delay_abs_before_active.tdStatus ==
	              TASK_DELAY_ACTIVE_VALUE &&
	            delay_abs_before_active.tdStatus == 1 &&
	            delay_nodes_wf(app(prefix_active, suffix_active)) &&
	            store_ptr(
	              &(task->task_dync_sched_member.delay),
	              delay_ptr_active) *
	            store_delay_dll_frame(
	              &xiaoshan_delay_head,
	              prefix_active,
	              Build_DL_Node(
	                delay_abs_before_active,
	                field_addr(delay_ptr_active, struct Delay, link)),
	              suffix_active) *
	            store_ptr(
	              field_addr(delay_ptr_active, struct Delay, task),
	              delay_abs_before_active.tdTaskPtr) *
	            store_uint(
	              field_addr(delay_ptr_active, struct Delay, ticks),
	              delay_abs_before_active.tdTicks) *
	            store_uchar(
	              field_addr(delay_ptr_active, struct Delay, status),
	              delay_abs_before_active.tdStatus) *
	            CharArray::full(
	              delay_ptr_active + 9,
	              3, cons(0, cons(0, cons(0, nil))))
	     */
	    /*@ Given delay_ptr_active delay_abs_before_active
	              prefix_active suffix_active */
	    // lock = CriticalAreaLock();
        delay->status = TASK_DELAY_INACTIVE;
        
        DoubleLinkListRmNode(&(delay->link))
          /*@ where (remove_member)
              storeA = store_delay_info,
              head = &xiaoshan_delay_head,
              a = mkTaskDelayAbs(
                delay_abs_before_active.tdTaskPtr,
                delay_abs_before_active.tdTicks,
                TASK_DELAY_INACTIVE_VALUE),
              prefix = prefix_active,
              suffix = suffix_active;
              A = TaskDelayAbs */;
        // CriticalAreaUnLock(lock);
	}

    /*@ Assert exists delay_value,
          lock == 0 &&
          task == task@pre &&
          delay == delay_value &&
          store_ktask_unset_delay_post(task, delay_view)
     */
    /*@ Given delay_value */

	return EOK;
}
