#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 106 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c"
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
{
    int id = 0;

    NULL_PARAM_CHECK(manager);
    NULL_PARAM_CHECK(idnode);

    if ((id = AllocId(manager)) < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode);

    return id;
}
