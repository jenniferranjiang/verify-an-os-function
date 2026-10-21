#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 62 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c"
static void InsertObj(struct IdManager *manager, struct IdNode *idnode)
{
    NULL_PARAM_CHECK(manager);
    NULL_PARAM_CHECK(idnode);

    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == NONE)
        InitDoubleLinkList(head);

    DoubleLinkListInsertNodeAfter(head, &idnode->link);
}
