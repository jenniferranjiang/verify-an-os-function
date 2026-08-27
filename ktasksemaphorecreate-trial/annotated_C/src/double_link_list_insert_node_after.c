typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Import DLL */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq (DL_Node :: * => *) */
/*@ Extern Coq
      (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
      (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion)
      (occupy_dll_node : Z -> Assertion)
      (dllseg_shift_rev :
        {A} -> (Z -> A -> Assertion) -> Z -> Z -> list (DL_Node A) -> Assertion)
 */

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (storeA : Z -> A -> Assertion)
         (nodes : list (DL_Node A)) (a : A)
    Require occupy_dll_node(linklist_node) * storeA(linklist_node, a) *
      store_dll(storeA, linklist, nodes)
    Ensure store_dll(storeA, linklist,
      cons(Build_DL_Node(a, linklist_node), nodes))
 */
{
    /*@ occupy_dll_node(linklist_node) * storeA(linklist_node, a) *
        store_dll(storeA, linklist, nodes)
        which implies
        exists next old_node_next old_node_prev,
          (linklist->node_next == next) *
          (next->node_prev == linklist) *
          dllseg_shift_rev(storeA, next, linklist, nodes) *
          (linklist_node->node_next == old_node_next) *
          (linklist_node->node_prev == old_node_prev) *
          storeA(linklist_node, a)
     */

    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;

    /*@ exists next,
          (linklist->node_next == linklist_node) *
          (linklist_node->node_prev == linklist) *
          (linklist_node->node_next == next) *
          (next->node_prev == linklist_node) *
          dllseg_shift_rev(storeA, next, linklist, nodes) *
          storeA(linklist_node, a)
        which implies store_dll(storeA, linklist,
          cons(Build_DL_Node(a, linklist_node), nodes))
     */
}
