/*
 * Extraction: kernel/thread/id.c:106-120.
 * The assignment-in-condition is split into an assignment followed by the
 * identical comparison; NULL_PARAM_CHECK is expanded.
 */

typedef unsigned char uint8;
typedef unsigned short uint16;

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

struct IdNode {
    uint16 id;
    DoubleLinklistType link;
};

struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

/*@ Extern Coq (StableIdManager :: *)
               (IdManagerState :: *)
               (id_manager_after_insert : StableIdManager -> IdManagerState -> Z -> Z -> IdManagerState)
               (id_manager_min_free_id : StableIdManager -> IdManagerState -> Z -> Prop)
               (id_manager_full : StableIdManager -> IdManagerState -> Prop)
               (store_id_manager : StableIdManager -> IdManagerState -> Z -> Assertion)
               (store_id_manager_allocated_unlinked : StableIdManager -> IdManagerState -> Z -> Z -> Assertion)
               (store_id_manager_insert_ready : StableIdManager -> IdManagerState -> Z -> Z -> Z -> Assertion)
               (store_id_node_insert_ready : Z -> Assertion)) */
/*@ Import Coq Require Import CRTOS_Verify.lib.IdManagerRep */

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sm : StableIdManager) (st : IdManagerState)
    Require manager != 0 && store_id_manager(sm, st, manager)
    Ensure (__return == -1 && id_manager_full(sm, st) &&
            store_id_manager(sm, st, manager)) ||
           (exists id,
             __return == id &&
             store_id_manager_allocated_unlinked(sm, st, manager, id))
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdManager) (before : IdManagerState) id
    Require manager != 0 && idnode != 0 &&
            store_id_manager_insert_ready(sm, before, manager, id, idnode)
    Ensure id_manager_min_free_id(sm, before, id) &&
           store_id_manager(sm,
             id_manager_after_insert(sm, before, id, idnode), manager)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdManager) (before : IdManagerState)
    Require manager != 0 && idnode != 0 &&
            store_id_manager(sm, before, manager) *
            store_id_node_insert_ready(idnode)
    Ensure (__return == -1 && id_manager_full(sm, before) &&
            store_id_manager(sm, before, manager) *
            store_id_node_insert_ready(idnode)) ||
           (exists id,
             __return == id &&
             id_manager_min_free_id(sm, before, id) &&
             store_id_manager(sm,
               id_manager_after_insert(sm, before, id, idnode), manager))
*/
{
    int id = 0;

    if (manager == (void *)0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "IdInsertObj", 110, "manager");
        while (1)
            ;
    }
    if (idnode == (void *)0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "IdInsertObj", 111, "idnode");
        while (1)
            ;
    }

    id = AllocId(manager) /*@ where sm = sm, st = before */;
    if (id < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode)
      /*@ where sm = sm, before = before, id = id */;

    return id;
}
