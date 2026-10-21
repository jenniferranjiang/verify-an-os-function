#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 132 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/CriticalArea.c"
void CriticalAreaUnLock(x_base lock) {
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    ENABLE_INTERRUPT(lock);
}
