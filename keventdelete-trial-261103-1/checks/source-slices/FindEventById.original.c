static struct Event *FindEventById(int32 id)
{
    x_base lock = 0;
    struct IdNode *idnode = NONE;
    struct Event *event = NONE;

    if (id < 0)
        return NONE;
    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_event_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock);
        return NONE;
    }

    event = CONTAINER_OF(idnode, struct Event, id);
    CriticalAreaUnLock(lock);
    
    return event;
}
