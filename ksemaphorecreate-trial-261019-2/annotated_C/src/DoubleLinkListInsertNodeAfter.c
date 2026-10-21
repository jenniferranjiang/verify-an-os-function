/* Fresh extraction: kernel/thread/double_link.c:42; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"



void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (payload : Z -> A -> Assertion)
         (old_nodes : list(DL_Node A)) (new_data : A)
    Require linklist_node != 0 &&
            store_dll(payload, linklist, old_nodes) *
            payload(linklist_node, new_data) * store_uninit_dlnode(linklist_node)
    Ensure store_dll(payload, linklist,
                     cons(Build_DL_Node(new_data, linklist_node), old_nodes))
*/
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
