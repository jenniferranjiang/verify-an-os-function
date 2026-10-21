#include "m_assign.h"
#include "xs_isr.h"

/***************** isr.h | isr.c *********************/

// ARCH_MAX_IRQ_NUM is defined as 66.

struct InterruptServiceRoutines {
    volatile uint16 isr_count ;
    volatile uint8  isr_switch_trigger_flag;
    struct IrqDesc irq_table[ARCH_MAX_IRQ_NUM];
    struct IsrDone *done;
};

struct InterruptServiceRoutines isrManager = { 0} ;

/**************************************/

/**
 * task schedule function.getting the highest priority task then switching to it
 */
void KTaskOsAssign(void)
{
    x_ubase highest_prio = 0;
    int need_insert_from_task = 0;
    struct TaskDescriptor *new_task = NONE;
    struct TaskDescriptor *from_task = NONE;

    if(GetOsAssignLockLevel() >= 1) {
        goto exit;
    }

    // if( isrManager.done->isInIsr() ){
    //     isrManager.done->setSwitchTrigerFlag();
    //     goto exit;
    // }
    if(IsInIsr() ){
        SetIsrSwitchTrigerFlag();
        goto exit;
    }

    /* if the bitmap is empty then do not switch */
    if (RET_TRUE == JudgeAssignReadyBitmapIsEmpty(&Assign.os_assign_ready_vector)) {
        goto exit;
    }

    highest_prio = Assign.os_assign_ready_vector.highest_prio;
    new_task = ChooseTaskWithHighestPrio(&Assign.os_assign_ready_vector);

    if(RET_TRUE != JudgeKTaskStatIsRunning(Assign.os_running_task)) {
        CHECK(NONE != new_task);
        goto SWITCH;
    }

    /* if the running task’ priority is the highest and this task is not be yield then do not switch */
    if(highest_prio < Assign.os_running_task->task_dync_sched_member.cur_prio) {
        goto exit;
    } else {
        need_insert_from_task = 1;
    }

SWITCH:
    if (new_task != Assign.os_running_task) {
        Assign.current_priority = (uint8)highest_prio;
        from_task = Assign.os_running_task;

        // HOOK(hook.assign.hook_Assign, (from_task, new_task));

        if (need_insert_from_task) {
            Assign.ready_vector_done->insert(from_task);
        }

        Assign.ready_vector_done->remove(new_task);
        KTaskStatSetAsRunning(new_task);
        Assign.os_running_task = new_task;

        // SYS_KDEBUG_LOG(KDBG_SCHED,
        //     ("[%d]switch to priority#%d "
        //      "task:%.*s(sp:0x%08x), "
        //      "from task:%.*s(sp: 0x%08x)\n",
        //         isrManager.done->getCounter(), highest_prio,
        //         NAME_NUM_MAX, new_task->task_base_info.name, new_task->stack_point,
        //         NAME_NUM_MAX, from_task->task_base_info.name, from_task->stack_point));

#ifdef KERNEL_STACK_OVERFLOW_CHECK
        _KTaskOsAssignStackCheck(new_task);
#endif

        SwitchKtaskContext((x_ubase)&from_task->stack_point,
                    (x_ubase)&new_task->stack_point, new_task);

    } else {
        Assign.ready_vector_done->remove(Assign.os_running_task);
        KTaskStatSetAsRunning(Assign.os_running_task);
    }

exit:
    return;
}