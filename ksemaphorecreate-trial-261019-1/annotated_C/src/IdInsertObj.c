#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager)
    Require (manager == 0 && emp) ||
            (manager != 0 && store_idmanager(sidm, idm, manager))
    Ensure manager != 0 &&
      ((__return == -1 && idmanager_full(sidm, idm) &&
        store_idmanager(sidm, idm, manager)) ||
       (idmanager_min_free_id(sidm, idm, __return) &&
        store_idmanager_allocated_unlinked(sidm, idm, manager, __return)))
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
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/id.c:106. */
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager)
         (old_id old_prev old_next : Z)
    Require ((manager == 0 || idnode == 0) && emp) ||
            (manager != 0 && idnode != 0 &&
             store_idmanager(sidm, idm, manager) *
             idnode_private(idnode, old_id, old_prev, old_next))
    Ensure manager != 0 && idnode != 0 &&
      ((__return == -1 && idmanager_full(sidm, idm) &&
        store_idmanager(sidm, idm, manager) *
        idnode_private(idnode, old_id, old_prev, old_next)) ||
       (idmanager_min_free_id(sidm, idm, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
          manager)))
*/
{
    int id = 0;

    do { if (manager == NONE) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 110, "manager"); while (1) ; } } while (0);
    do { if (idnode == NONE) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 111, "idnode"); while (1) ; } } while (0);

    id = AllocId(manager)
        /*@ where sidm = sidm, idm = idm */;
    if (id < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode)
        /*@ where sidm = sidm, idm = idm, id = id */;

    return id;
}
