/* Extraction: kernel/thread/double_link.c:30-34. */

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Extern Coq (store_dll_node_uninitialized : Z -> Assertion)
               (store_dll_node_standalone : Z -> Assertion) */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoublyLinkedList */

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require store_dll_node_uninitialized(linklist_head)
    Ensure store_dll_node_standalone(linklist_head)
*/
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
