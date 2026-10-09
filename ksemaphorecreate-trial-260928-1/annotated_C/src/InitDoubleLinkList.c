/* Source: kernel/thread/double_link.c:30-34. No executable normalization. */
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreProofLocal */

/*@ Extern Coq (SemDLNode :: * => *) (unit :: *) */
/*@ Extern Coq (semaphore_unit_empty : Z -> unit -> Assertion)
               (store_sem_dll :
      {A} -> (Z -> A -> Assertion) -> Z -> list(SemDLNode A) -> Assertion)
 */

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With old_next old_prev
    Require
      linklist_head != 0 &&
      store(&(linklist_head->node_next), void *, old_next) *
      store(&(linklist_head->node_prev), void *, old_prev)
    Ensure
      store_sem_dll(semaphore_unit_empty, linklist_head, nil)
 */
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
