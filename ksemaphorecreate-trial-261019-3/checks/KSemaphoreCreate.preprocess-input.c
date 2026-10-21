#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 246 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c"
int32 KSemaphoreCreate(uint16 val)
{
    KDEBUG_NOT_IN_INTERRUPT;

    return done.SemaphoreCreate(val);
}
