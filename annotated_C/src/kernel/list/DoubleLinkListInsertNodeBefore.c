#include "m_double_linklist.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: Z -> A -> Assertion)
             (head: Z) (nodes: list(DL_Node A)) (inserted_data: A)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, inserted_data) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_before_dispatch(
               head, nodes, linklist,
               Build_DL_Node(inserted_data, linklist_node)))
*/
{
    linklist->node_prev->node_next = linklist_node;
    linklist_node->node_prev = linklist->node_prev;

    linklist->node_prev = linklist_node;
    linklist_node->node_next = linklist;
}
