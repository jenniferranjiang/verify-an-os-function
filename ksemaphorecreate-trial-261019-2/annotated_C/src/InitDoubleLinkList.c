/* Fresh extraction: kernel/thread/double_link.c:30; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"



void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (payload : Z -> A -> Assertion)
    Require linklist_head != 0 && store_uninit_dlnode(linklist_head)
    Ensure store_dll(payload, linklist_head, nil)
*/
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
