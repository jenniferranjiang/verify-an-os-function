#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist,
                                   DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/;

/* Canonical: InsertObj. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:62. */
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sidm, idm, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sidm,
             idmanager_link(sidm, idmanager_add(idm, id), id, idnode), manager)
*/
{
    do { if (manager == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 64, "manager"); while (1) ; } } while (0);
    do { if (idnode == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 65, "idnode"); while (1) ; } } while (0);
    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];
    if (head->node_prev == (0))
        InitDoubleLinkList(head);
    DoubleLinkListInsertNodeAfter(head, &idnode->link);
}
