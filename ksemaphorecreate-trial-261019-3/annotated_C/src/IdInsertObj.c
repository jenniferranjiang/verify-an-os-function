#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 &&
      store_idmanager(sidm, before, manager)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager))
      ||
      (0 <= __return && __return < sidm.idmax &&
        store_idmanager_allocated_unlinked(sidm, before, manager, __return))
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager) (id : Z)
    Require manager != 0 && idnode != 0 &&
      store_idmanager_allocated_unlinked(sidm, before, manager, id) *
      AssignedIdNode(idnode, id)
    Ensure
      store_idmanager(sidm,
        idmanager_link(sidm, idmanager_add(before, id), id, idnode), manager)
*/;

/* Canonical: IdInsertObj. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:106. */
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && idnode != 0 &&
      store_idmanager(sidm, before, manager) * ZeroIdNode(idnode)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager) * ZeroIdNode(idnode))
      ||
      (0 <= __return && __return < sidm.idmax &&
        idmanager_min_free_id(sidm, before, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(before, __return), __return, idnode),
          manager))
*/
{
    int id = 0;
    do { if (manager == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 110, "manager"); while (1) ; } } while (0);
    do { if (idnode == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 111, "idnode"); while (1) ; } } while (0);
    if ((id = AllocId(manager) /*@ where sidm = sidm, before = before */) < 0)
        return -1;
    idnode->id = id;
    InsertObj(manager, idnode) /*@ where sidm = sidm, before = before, id = id */;
    return id;
}
