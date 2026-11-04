void KEventDelete(int32 id)
{
    KDEBUG_NOT_IN_INTERRUPT;

    struct Event *event = FindEventById(id);

    if (event == NONE)
        return;

    done.EventDelete(event);
}
