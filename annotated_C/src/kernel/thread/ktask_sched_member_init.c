#include "xsconfig.h"
#include "xs_base.h"
#include "ktask_set_status.h"
#include "task_sched_member_strategy.h"

/*@ Extern Coq
      (mkTaskSchedMemberAbs :
        TaskStatus -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
      (has_permission_task_sched_member : Z -> TaskStatus -> Assertion)
 */

// Copied from /home/cheng/osroot/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assign_roundrobinremain.c

void RoundRobinRemainTaskTimesliceInit(struct TaskDescriptor *task)
/*@ Require
      has_permission(
        &(task->task_dync_sched_member.origin_timeslice)) *
      has_permission(
        &(task->task_dync_sched_member.rest_timeslice))
    Ensure
      task != 0 &&
      store(
        &(task->task_dync_sched_member.origin_timeslice),
        unsigned int, 10) *
      store(
        &(task->task_dync_sched_member.rest_timeslice),
        unsigned int, 10)
 */
{
    NULL_PARAM_CHECK_1(task);

    task->task_dync_sched_member.origin_timeslice = 10;
	task->task_dync_sched_member.rest_timeslice = 10;
}

/**
 *
 * This function will init a kernel task's dynamic member .
 *
 * @param task task descriptor
 * @param tick task time slice
 */
static void _KTaskDyncMemberInit(KTaskDescriptorType task)
/*@ With origin_prio old_stat
    Require
      store(&(task->task_base_info.origin_prio),
        unsigned char, origin_prio) *
      has_permission_task_sched_member(task, old_stat) *
      has_permission(&(task->exstatus))
    Ensure
      task != 0 &&
      (&(task->task_dync_sched_member.sched_link) != 0 &&
        store_node_self_linked(
          &(task->task_dync_sched_member.sched_link))) *
      store_task_sched_member(&(task->task_dync_sched_member.sched_link),
        mkTaskSchedMemberAbs(
          TSK_INIT,
          0, origin_prio, 10, 10, 0)) *
      store(&(task->task_base_info.origin_prio),
            unsigned char, origin_prio) *
      store(&(task->exstatus), int, 0)
 */
{
    NULL_PARAM_CHECK_1(task);


    InitDoubleLinkList(&(task->task_dync_sched_member.sched_link));

    task->task_dync_sched_member.cur_prio = task->task_base_info.origin_prio;
	task->task_dync_sched_member.bitmap_column = 0;

    RoundRobinRemainTaskTimesliceInit(task);

	task->task_dync_sched_member.advance_cnt = 0;
    task->exstatus = EOK;
    KTaskStatSetAsInit(task);


}
