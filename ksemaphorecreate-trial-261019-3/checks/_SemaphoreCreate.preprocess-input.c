#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 33 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c"
static int32 _SemaphoreCreate(uint16 val)
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock();
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock);
        return -ENOMEMORY;
    }

    sem->value = val;
    InitDoubleLinkList(&sem->pend_list);

    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link);
    CriticalAreaUnLock(lock);

    SYS_KDEBUG_LOG(KDBG_IPC, ("created semaphore: id %d, value %d\n", id, (int)val));

    return id;
}
