#include "m_ktask.h"
#include "task_base_info_strategy.h"
/*@ include strategies "task_base_info.strategies" */

/*@ Extern Coq
      (KOK : Z)
      (PRIORITY_MAX : Z)
      (NAME_MAX_SIZE : Z)
      (TSK_INIT : TaskStatus)
      (TASK_STAT_MASK : Z)
      (store_string : Z -> list Z -> Assertion)
      (ktask_init_input_arguments_ok :
        Z -> Z -> Z -> Z -> Z -> Prop)
      (has_permission_ktask_base_info : Z -> Assertion)
      (has_permission_ktask_base_info_start0 : Z -> Assertion)
      (assert_task_base_info_values :
        TaskBaseInfoAbs -> list Z -> Z -> Z -> Z -> Z -> Prop)
      (store_task_base_info : Z -> TaskBaseInfoAbs -> Assertion)
      (store_ktask_stack :
        Z -> Z -> list Z ->
        StackRegisterContextAbs -> Assertion)
      (ktask_context_regs_setup :
        Z -> Z -> Z -> Z -> Z -> StackRegisterContextAbs)
      (CHAR_SHARP : Z)
      (SAVED_MSTATUS : Z)
      (OxFADEFACE : Z)
      (has_permission_task_sched_member : Z -> TaskStatus -> Assertion)
      (has_permission_task_descriptor : Z -> TaskStatus -> Assertion)
      (mkTaskSchedMemberAbs :
        TaskStatus -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
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
;

int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
							void (*entry)(void *parameter),
							void       *parameter,
							uint32 stack_depth,
							uint8  priority)
/*@ With src_name old_stat
    Require
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      store_string(name, src_name) *
      has_permission(&(task->stack_point)) *
      has_permission_ktask_base_info(task) *
      has_permission_task_sched_member(task, old_stat) *
      has_permission(&(task->exstatus))
    Ensure
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      task != 0 && name != 0 && entry != 0 &&
      store_string(name, src_name) *
      (
        ( __return == -1 && 
          has_permission(&(task->stack_point)) *
          has_permission_task_sched_member(task, old_stat) *
          has_permission(&(task->exstatus)) *
          (
            (priority >= PRIORITY_MAX &&
                  has_permission_ktask_base_info(task)) ||
            (priority < PRIORITY_MAX &&
                  has_permission_ktask_base_info_start0(task))
          )
        ) ||
        (__return == KOK &&
          exists info,
            info.tbStackStart != 0 &&
            priority < PRIORITY_MAX &&
            assert_task_base_info_values(
              info, sublist(0, NAME_MAX_SIZE - 1, src_name),
              entry, parameter, stack_depth, priority) &&
            store(&(task->stack_point), kss_context_addr(info)) *
            store_task_base_info(task, info) *
            store_ktask_stack(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(
                CHAR_SHARP,
                kss_context_addr(info) - info.tbStackStart),
              ktask_context_regs_setup(
                info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                SAVED_MSTATUS, OxFADEFACE)) *
            (&(task->task_dync_sched_member.sched_link) != 0 &&
              store_node_self_linked(
                &(task->task_dync_sched_member.sched_link))) *
            store_task_sched_member(
              &(task->task_dync_sched_member.sched_link),
              mkTaskSchedMemberAbs(
                TSK_INIT,
                0, priority, 10, 10, 0)) *
            store(&(task->exstatus), int, 0))
      )
 */
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
