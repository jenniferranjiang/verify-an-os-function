#include "../slice_types.h"
#include "../logic.h"

/* Canonical: DoubleLinkListInsertNodeAfter. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c:42. */
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (next : Z) (oldprev : Z) (oldnext : Z)
    Require DllInsertAfterCut(linklist, next, linklist_node, oldprev, oldnext)
    Ensure DllInsertedCut(linklist, next, linklist_node)
*/
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;
    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
