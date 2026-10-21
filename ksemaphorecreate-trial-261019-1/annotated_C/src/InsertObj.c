#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (storeA : Z -> A -> Assertion)
    Require linklist_head != 0 && occupy_dll_node(linklist_head)
    Ensure store_dll(storeA, linklist_head, nil)
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (storeA : Z -> A -> Assertion)
         (nodes : list(DL_Node A)) (inserted_data : A)
    Require linklist_node != 0 &&
            store_dll(storeA, linklist, nodes) *
            storeA(linklist_node, inserted_data) * occupy_dll_node(linklist_node)
    Ensure store_dll(storeA, linklist,
             cons(Build_DL_Node(inserted_data, linklist_node), nodes))
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/id.c:62. */
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
    do { if (manager == NONE) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 64, "manager"); while (1) ; } } while (0);
    do { if (idnode == NONE) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 65, "idnode"); while (1) ; } } while (0);

    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == NONE)
        InitDoubleLinkList(head)
            /*@ where storeA = store_idnode; A = IdNodeAbs */;

    DoubleLinkListInsertNodeAfter(head, &idnode->link)
        /*@ where storeA = store_idnode,
                  nodes = idnodes_to_dll(Znth(id % hoffset(sidm), idbuckets(idm), nil)),
                  inserted_data = Build_IdNodeAbs(id, idnode); A = IdNodeAbs */;
}
