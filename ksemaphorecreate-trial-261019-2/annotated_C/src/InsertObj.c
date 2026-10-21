/* Fresh extraction: kernel/thread/id.c:62; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (payload : Z -> A -> Assertion)
    Require linklist_head != 0 && store_uninit_dlnode(linklist_head)
    Ensure store_dll(payload, linklist_head, nil)
*/;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (payload : Z -> A -> Assertion)
         (old_nodes : list(DL_Node A)) (new_data : A)
    Require linklist_node != 0 &&
            store_dll(payload, linklist, old_nodes) *
            payload(linklist_node, new_data) * store_uninit_dlnode(linklist_node)
    Ensure store_dll(payload, linklist,
                     cons(Build_DL_Node(new_data, linklist_node), old_nodes))
*/;
void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager) (id : Z)
    Require ((manager == 0 || idnode == 0) && emp) ||
            (manager != 0 && idnode != 0 &&
             store_idmanager_allocated_unlinked(sidm, idm, manager, id) *
             store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode)))
    Ensure manager != 0 && idnode != 0 &&
           store_idmanager(sidm,
             idmanager_link(sidm, idmanager_add(idm, id), id, idnode), manager)
*/
{
    do { if (manager == NONE) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 64, "manager");
        while (RET_TRUE) ;
    } } while (0);
    do { if (idnode == NONE) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 65, "idnode");
        while (RET_TRUE) ;
    } } while (0);

    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == NONE)
        InitDoubleLinkList(head)
            /*@ where payload = store_idnode; A = IdNodeAbs */;

    DoubleLinkListInsertNodeAfter(head, &idnode->link)
        /*@ where payload = store_idnode,
                  old_nodes = idnodes_to_dll(Znth(id % hoffset(sidm), idbuckets(idm), nil)),
                  new_data = Build_IdNodeAbs(id, idnode); A = IdNodeAbs */;
}
