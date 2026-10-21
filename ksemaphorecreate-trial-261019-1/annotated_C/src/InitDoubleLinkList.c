#include "../include/types.h"
#include "../include/logic.h"

/* Source kernel/thread/double_link.c:30. */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (storeA : Z -> A -> Assertion)
    Require linklist_head != 0 && occupy_dll_node(linklist_head)
    Ensure store_dll(storeA, linklist_head, nil)
*/
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
