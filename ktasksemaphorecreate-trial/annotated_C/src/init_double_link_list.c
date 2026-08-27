typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Import DLL */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq (DL_Node :: * => *) */
/*@ Extern Coq
      (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion)
      (occupy_dll_node : Z -> Assertion)
 */

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (storeA : Z -> A -> Assertion)
    Require occupy_dll_node(linklist_head)
    Ensure store_dll(storeA, linklist_head, nil)
 */
{
    /*@ occupy_dll_node(linklist_head)
        which implies
        undef_data_at(&(linklist_head->node_next),
          struct SysDoubleLinklistNode*) *
        undef_data_at(&(linklist_head->node_prev),
          struct SysDoubleLinklistNode*)
     */

    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;

    /*@ (linklist_head->node_next == linklist_head) *
        (linklist_head->node_prev == linklist_head)
        which implies store_dll(storeA, linklist_head, nil)
     */
}
