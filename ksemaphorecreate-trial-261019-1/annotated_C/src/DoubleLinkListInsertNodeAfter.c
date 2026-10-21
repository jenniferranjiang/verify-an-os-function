#include "../include/types.h"
#include "../include/logic.h"

/* Source kernel/thread/double_link.c:42. */
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (storeA : Z -> A -> Assertion)
         (nodes : list(DL_Node A)) (inserted_data : A)
    Require linklist_node != 0 &&
            store_dll(storeA, linklist, nodes) *
            storeA(linklist_node, inserted_data) * occupy_dll_node(linklist_node)
    Ensure store_dll(storeA, linklist,
             cons(Build_DL_Node(inserted_data, linklist_node), nodes))
*/
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
