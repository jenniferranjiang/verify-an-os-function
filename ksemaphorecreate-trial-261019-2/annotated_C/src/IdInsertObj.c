/* Fresh extraction: kernel/thread/id.c:106; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

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
void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager)
         (initial_id initial_prev initial_next : Z)
    Require ((manager == 0 || idnode == 0) && emp) ||
            (manager != 0 && idnode != 0 &&
             store_idmanager(sidm, idm, manager) *
             store_private_idnode(idnode, initial_id, initial_prev, initial_next))
    Ensure manager != 0 && idnode != 0 &&
      ((__return == -1 && idmanager_full(sidm, idm) &&
        store_idmanager(sidm, idm, manager) *
        store_private_idnode(idnode, initial_id, initial_prev, initial_next)) ||
       (idmanager_min_free_id(sidm, idm, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode), manager)))
*/
{
    int id = 0;

    do { if (manager == NONE) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 110, "manager");
        while (RET_TRUE) ;
    } } while (0);
    do { if (idnode == NONE) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 111, "idnode");
        while (RET_TRUE) ;
    } } while (0);

    if ((id = AllocId(manager)
        /*@ where sidm = sidm, idm = idm */) < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode)
        /*@ where sidm = sidm, idm = idm, id = id */;

    return id;
}
