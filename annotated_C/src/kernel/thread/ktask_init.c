#include "ktask_init.h"
#include "task_base_info_strategy.h"
/*@ include strategies "task_base_info.strategies" */

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
;

int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
							void (*entry)(void *parameter),
							void       *parameter,
							uint32 stack_depth,
							uint8  priority)
/*@ init_task */
{
    int32 ret = 0;
    NULL_PARAM_CHECK_1(task);

    /*@ emp
        which implies
        KOK == 0 && NOMEMORY == 5 && INVALID == 10 && emp
     */

    ret = _KTaskBaseInfoParse(task, name, entry, parameter, stack_depth, priority);
    if (ret < 0) {
        // KPrintf("%s %d task %s baseinfo parse failed.\n",__func__,__LINE__,name);
        return -ERROR;
    }

    /*@ Given info */


    _KTaskDyncMemberInit(task);


	return EOK;
}
