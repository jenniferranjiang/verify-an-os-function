#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require NodeStorage(linklist_head)
    Ensure store_node_self_linked(linklist_head)
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (next : Z) (oldprev : Z) (oldnext : Z)
    Require DllInsertAfterCut(linklist, next, linklist_node, oldprev, oldnext)
    Ensure DllInsertedCut(linklist, next, linklist_node)
*/;

/* Canonical: InsertObj. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:62. */
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager) (id : Z)
    Require manager != 0 && idnode != 0 &&
      store_idmanager_allocated_unlinked(sidm, before, manager, id) *
      AssignedIdNode(idnode, id)
    Ensure
      store_idmanager(sidm,
        idmanager_link(sidm, idmanager_add(before, id), id, idnode), manager)
*/
{
    do { if (manager == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 64, "manager"); while (1) ; } } while (0);
    do { if (idnode == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 65, "idnode"); while (1) ; } } while (0);
    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];
    if (head->node_prev == (0))
        InitDoubleLinkList(head);
    DoubleLinkListInsertNodeAfter(head, &idnode->link)
        /*@ where next = idbucket_first_link(sidm, before, id), oldprev = 0, oldnext = 0 */;
}
