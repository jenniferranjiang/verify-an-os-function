#include "m_ktask.h"
#include "xs_isr.h"
/*
 * update the exception status
 *
 */

static volatile int __exstatus;

// 先审计代码，实际上


void KUpdateExstatus(x_err_t status)
{
    if (status < EOK || status >= INVALID_TASK_ERROR) {
        // KPrintf("Illegal status code %d\n", status);
        return;
    }

    if (isrManager.done->getCounter() == 0) {
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor();
        if (CurrentTask != NONE) {
            CurrentTask->exstatus = -status;
        } else {
            __exstatus = -status;
            return;
        }
    } else {
        __exstatus = -status;
        return;
    }   
}


/**
 * obtain current exception status
 *
 */
int *KObtainExstatus(void)
{
    if (isrManager.done->getCounter() == 0) {
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor();
        if (CurrentTask != NONE) {
            return (int *) & (CurrentTask->exstatus);
        } else {
            return (int *)&__exstatus;
        }
    } else {
        return (int *)&__exstatus;
    }
}