/* Extraction: kernel/thread/double_link.c:42-51. */

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Extern Coq (DllNode :: * => *)
               (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DllNode A) -> Assertion)
               (store_dll_node_uninitialized : Z -> Assertion)
               (dll_insert_after : {A} -> Z -> Z -> DllNode A -> list (DllNode A) -> list (DllNode A) -> Prop)
               (dll_link_addr : {A} -> DllNode A -> Z)
               (dll_payload : {A} -> DllNode A -> A)) */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoublyLinkedList */

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *linklist,
    DoubleLinklistType *linklist_node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         head focus (new_node : DllNode A) before after
    Require focus == linklist &&
            dll_link_addr(new_node) == linklist_node &&
            dll_insert_after(head, focus, new_node, before, after) &&
            store_dll(store_payload, head, before) *
            store_payload(linklist_node, dll_payload(new_node)) *
            store_dll_node_uninitialized(linklist_node)
    Ensure store_dll(store_payload, head, after)
*/
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
