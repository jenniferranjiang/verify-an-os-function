static void _EventDelete(struct Event *event)
{
    int resched = 0;
    x_base lock = 0;

    NULL_PARAM_CHECK(event);

    if (!IsDoubleLinkListEmpty(&event->pend_list)) {
        resched = 1;
        LinklistResumeAll(&event->pend_list);
    }

    lock = CriticalAreaLock();
    IdRemoveObj(&k_event_id_manager, event->id.id);

    DoubleLinkListRmNode(&event->link);
    CriticalAreaUnLock(lock);

    x_free(event);

    if (resched)
        DO_KTASK_ASSIGN;
}
