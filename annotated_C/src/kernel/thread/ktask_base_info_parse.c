/*
 * Verification slice for _KTaskBaseInfoParse.
 *
 * Active configuration for this slice:
 * - SEPARATE_COMPILE is undefined;
 * - TASK_ISOLATION is undefined;
 * - KERNEL_CAPABILITY is undefined;
 * - ARCH_SMP is undefined.
 *
 * The executable success-path statements are copied from
 * annotated_C/src/kernel/thread/ktask.c under that configuration. Callees are
 * specified as extern functions and are not expanded here.
 */
#include "xsconfig.h"
#include "xs_base.h"
#include "m_ktask.h"
#include "task_base_info_strategy.h"
/*@ include strategies "task_base_info.strategies" */

static x_err_t _KTaskBaseInfoParse(KTaskDescriptorType task,
                            const char *name,
                            void (*entry)(void *parameter),
                            void       *parameter,
                            uint32 stack_depth,
                            uint8  priority)
/*@ With src_name
    Require ktask_init_input_arguments_ok(
              entry, parameter, &KTaskQuit,
              stack_depth, priority) &&
            has_permission(&(task->stack_point)) *
            has_permission_ktask_base_info(task) *
            store_string(name, src_name)
    Ensure ktask_init_input_arguments_ok(
             entry, parameter, &KTaskQuit,
             stack_depth, priority) &&
           task != 0 && name != 0 && entry != 0 &&
           ((__return == -INVALID &&
              priority >= PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info(task) *
              store_string(name, src_name)) ||
            (__return == -NOMEMORY &&
              priority < PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info_start0(task) *
              store_string(name, src_name)) ||
            (__return == KOK &&
              exists info,
              info.tbStackStart != 0 &&
              priority < PRIORITY_MAX &&
              assert_task_base_info_values(
                info, sublist(0, NAME_MAX_SIZE - 1, src_name),
                entry, parameter, stack_depth, priority) &&
              store(&(task->stack_point), kss_context_addr(info)) *
              store_task_base_info(task, info) *
              store_string(name, src_name) *
              store_ktask_stack(
                info.tbStackStart, info.tbStackDepth,
                repeat_Z(
                  CHAR_SHARP,
                  kss_context_addr(info) - info.tbStackStart),
                ktask_context_regs_setup(
                  info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                  SAVED_MSTATUS, OxFADEFACE))))
 */
{

    NULL_PARAM_CHECK_1(task);
    NULL_PARAM_CHECK_1(name);
    NULL_PARAM_CHECK_2(entry);

    /*@ ktask_init_input_arguments_ok(
          entry, parameter, &KTaskQuit,
          stack_depth, priority)
        which implies
        ktask_init_input_arguments_ok(
          entry, parameter, &KTaskQuit,
          stack_depth, priority) &&
        ktask_xubase_value(entry) &&
        ktask_xubase_value(parameter) &&
        ktask_xubase_value(&KTaskQuit) &&
        0 <= stack_depth && stack_depth <= UINT_MAX &&
        sizeof(struct StackRegisterContext) + REG_LENGTH - 1 <=
          stack_depth &&
        0 <= priority && priority <= 255
     */

    if (priority >= KTASK_PRIORITY_MAX) {
        // KPrintf("%s %d Invalid task priority[%d] set.\n",__func__,__LINE__,priority);
        return  -EINVALED;
    }


    {
        task->task_base_info.stack_start = (void *)KERNEL_MALLOC(stack_depth);
    }

    if (task->task_base_info.stack_start == NONE) {
        // KPrintf("%s %d malloc task %s stack depth %d failed.\n",__func__,__LINE__,name,stack_depth);

        /*@ has_permission_ktask_base_info_start0(task) */

        return -ENOMEMORY;
    }

    /*@ exists stack_start,
          0 < stack_start &&
          stack_start + stack_depth <= UINT_MAX &&
          store(&(task->task_base_info.stack_start), stack_start) *
          CharArray::undef_full(stack_start, stack_depth)
     */
    /*@ Given stack_start */

    /*@ 0 < stack_start &&
        stack_start + stack_depth <= UINT_MAX &&
        sizeof(struct StackRegisterContext) + REG_LENGTH - 1 <=
          stack_depth
        which implies
        ktask_stack_setup_layout_ok(
          stack_start, stack_depth, REG_LENGTH)
     */

    task->task_base_info.stack_depth = stack_depth;

    memset(task->task_base_info.stack_start, '#', task->task_base_info.stack_depth);

    strncpy(task->task_base_info.name, name, NAME_NUM_MAX - 1)
        /*@ where src_str = src_name */;
    task->task_base_info.name[NAME_NUM_MAX - 1] = '\0';

    task->task_base_info.func_entry = (void *)entry;
    task->task_base_info.func_param = parameter;
    task->task_base_info.origin_prio = priority;



    KTaskStackSetup(task)
      /*@ where info = mkTaskBaseInfoAbs(
                    sublist(0, 31, src_name),
                    entry, parameter, priority, stack_depth, stack_start) */;

    return EOK;

}
