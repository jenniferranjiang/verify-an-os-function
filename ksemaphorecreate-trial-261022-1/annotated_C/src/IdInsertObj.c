#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager)
    Ensure (idmanager_first_free_id(sidm, idm) == Some(__return) &&
            __return < 65536 &&
            store_idmanager_allocated_unlinked(sidm, idm, manager, __return))
           ||
           (idmanager_first_free_id(sidm, idm) == None &&
            __return == -1 &&
            store_idmanager(sidm, idm, manager))
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sidm, idm, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sidm,
             idmanager_link(sidm, idmanager_add(idm, id), id, idnode), manager)
*/;

/* Canonical: IdInsertObj. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:106. */
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sidm, idm) == None &&
            store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sidm, idm, __return) &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
              manager))
*/
{
    int id = 0;
    do { if (manager == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 110, "manager"); while (1) ; } } while (0);
    do { if (idnode == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 111, "idnode"); while (1) ; } } while (0);
    if ((id = AllocId(manager)) < 0)
        return -1;
    idnode->id = id;
    InsertObj(manager, idnode);
    return id;
}
