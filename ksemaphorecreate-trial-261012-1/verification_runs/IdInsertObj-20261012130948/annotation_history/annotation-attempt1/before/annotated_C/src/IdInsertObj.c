#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Candidate contracts use the compiled OSHeap transport; bodies await verification. */
int AllocId(struct IdManager *manager)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && OSHeap(store_idmanager(sm, before, manager))
    Ensure
      (__return == -1 && idmanager_full(sm, before) &&
        OSHeap(store_idmanager(sm, before, manager))) ||
      (idmanager_min_free_id(sm, before, __return) &&
        OSHeap(store_idmanager_allocated_unlinked(sm, before, manager, __return)))
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
*/;
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
/*@ Require emp
    Ensure emp
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
         (old_id : Z) (previous : Z) (next : Z)
    Require manager != 0 && idnode != 0 &&
      OSHeap(store_idmanager(sm, before, manager)) *
      OSHeap(store_sem_id_detached(idnode, old_id, previous, next))
    Ensure
      (__return == -1 && idmanager_full(sm, before) &&
        OSHeap(store_idmanager(sm, before, manager)) *
        OSHeap(store_sem_id_detached(idnode, old_id, previous, next))) ||
      (idmanager_min_free_id(sm, before, __return) &&
        OSHeap(store_idmanager(sm,
          idmanager_link(sm, idmanager_add(before, __return), __return, idnode), manager)))
*/
{
    int id = 0;

    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 110, "manager");
            while (1)
                ;
        }
    } while (0);
    do {
        if (idnode == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 111, "idnode");
            while (1)
                ;
        }
    } while (0);

    id = AllocId(manager) /*@ where sm = sm, before = before */;
    if (id < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode) /*@ where sm = sm, before = before, id = id, previous = previous, next = next */;

    return id;
}
