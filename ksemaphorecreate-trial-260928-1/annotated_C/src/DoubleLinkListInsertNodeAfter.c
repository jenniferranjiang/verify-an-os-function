/* Source: kernel/thread/double_link.c:42-49. The canonical slice restricts
 * linklist to the sentinel/head case used by this verification closure. */
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreProofLocal */

/*@ Extern Coq (SemDLNode :: * => *) */
/*@ Extern Coq (Build_SemDLNode : {A} -> A -> Z -> SemDLNode A)
               (store_sem_dll :
                 {A} -> (Z -> A -> Assertion) -> Z -> list(SemDLNode A) -> Assertion)
               (store_sem_standalone_node :
                 {A} -> (Z -> A -> Assertion) -> Z -> A -> Assertion)
               (sem_dll_front :
                 {A} -> Z -> list(SemDLNode A) -> Z)
               (store_sem_dll_insert_rest :
                 {A} -> (Z -> A -> Assertion) -> Z ->
                   list(SemDLNode A) -> Assertion)
 */

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         (payload : A) (nodes : list(SemDLNode A))
    Require
      linklist_node != 0 &&
      store_sem_dll(store_payload, linklist, nodes) *
      store_sem_standalone_node(store_payload, linklist_node, payload)
    Ensure
      store_sem_dll(store_payload, linklist,
        cons(Build_SemDLNode(payload, linklist_node), nodes))
 */
{
    /*@ store_sem_dll(store_payload, linklist, nodes) *
        store_sem_standalone_node(store_payload, linklist_node, payload)
        which implies
          linklist != 0 &&
          store(&(linklist->node_next), struct SysDoubleLinklistNode *,
            sem_dll_front(linklist, nodes)) *
          store(&(sem_dll_front(linklist, nodes)->node_prev),
            struct SysDoubleLinklistNode *, linklist) *
          store_sem_dll_insert_rest(store_payload, linklist, nodes) *
          store_payload(linklist_node, payload) *
          has_permission(&(linklist_node->node_prev)) *
          has_permission(&(linklist_node->node_next))
     */
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;
    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
