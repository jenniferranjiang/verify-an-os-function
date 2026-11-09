#include "xs_event.h"
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#define DO_KTASK_ASSIGN KTaskOsAssign()
extern struct IdManager k_event_id_manager;
x_base CriticalAreaLock(void);
void CriticalAreaUnLock(x_base lock);
x_err_t LinklistResumeAll(DoubleLinklistType *list);
void x_free(void *ptr);
void KTaskOsAssign(void);
static void _EventDelete(int32 id)
{
    int resched = 0;
    x_base lock = 0;
    struct IdNode *idnode = NONE;
    struct Event *event = NONE;

    if (id < 0)
        return;

    /* Keep lookup, waiter draining and unpublishing in one critical section. */
    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_event_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock);
        return;
    }
    event = CONTAINER_OF(idnode, struct Event, id);

    if (!IsDoubleLinkListEmpty(&event->pend_list)) {
        resched = 1;
        LinklistResumeAll(&event->pend_list);
    }

    IdRemoveObj(&k_event_id_manager, event->id.id);
    DoubleLinkListRmNode(&event->link);
    CriticalAreaUnLock(lock);

    x_free(event);

    if (resched)
        DO_KTASK_ASSIGN;
}

static EventDoneType done = { .EventDelete = _EventDelete };
void KEventDelete(int32 id)
{
    KDEBUG_NOT_IN_INTERRUPT;

    done.EventDelete(id);
}
