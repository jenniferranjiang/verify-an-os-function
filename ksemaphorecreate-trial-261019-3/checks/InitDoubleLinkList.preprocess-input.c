#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 30 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c"
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
