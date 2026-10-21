#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Candidate contracts use the compiled OSHeap transport; bodies await verification. */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With (head : Z)
    Require linklist_head == head && head != 0 &&
      undef_data_at(&(linklist_head->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_head->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist_head->node_next), struct SysDoubleLinklistNode *, head) *
      store(&(linklist_head->node_prev), struct SysDoubleLinklistNode *, head)
*/;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (successor : Z) (previous : Z)
    Require linklist != 0 && linklist_node != 0 && successor != 0 &&
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, previous) *
      undef_data_at(&(linklist_node->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_node->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(linklist_node->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(linklist_node->node_prev), struct SysDoubleLinklistNode *, linklist)
*/;
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
/*@ Require emp
    Ensure emp
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
         (id : Z) (previous : Z) (next : Z)
    Require manager != 0 && idnode != 0 &&
      OSHeap(store_idmanager_allocated_unlinked(sm, before, manager, id)) *
      OSHeap(store_sem_id_detached(idnode, id, previous, next))
    Ensure
      OSHeap(store_idmanager(sm,
        idmanager_link(sm, idmanager_add(before, id), id, idnode), manager))
*/
{
    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 64, "manager");
            while (1)
                ;
        }
    } while (0);
    do {
        if (idnode == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 65, "idnode");
            while (1)
                ;
        }
    } while (0);

    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == NONE)
        InitDoubleLinkList(head) /*@ where head = head */;

    DoubleLinkListInsertNodeAfter(head, &idnode->link)
      /*@ where successor = head->node_next,
                previous = head->node_next->node_prev */;
}
