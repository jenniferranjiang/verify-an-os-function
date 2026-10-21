#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 117 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/CriticalArea.c"
x_base CriticalAreaLock(void) {
    x_base lock;

    lock = DISABLE_INTERRUPT();

    KTaskOsAssignLockNest ++;

    return lock;
}
