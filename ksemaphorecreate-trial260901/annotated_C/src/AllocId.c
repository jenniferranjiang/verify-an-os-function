/*
 * Extraction: kernel/thread/id.c:24-53.
 * NULL_PARAM_CHECK is expanded; its KPrintf target is user-approved trusted.
 * The static function is externalized only for the one-function slice.
 */

typedef unsigned char uint8;
typedef unsigned short uint16;

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

/*@ Extern Coq (StableIdManager :: *)
               (IdManagerState :: *)
               (store_id_manager : StableIdManager -> IdManagerState -> Z -> Assertion)
               (store_id_manager_allocated_unlinked : StableIdManager -> IdManagerState -> Z -> Z -> Assertion)
               (id_manager_full : StableIdManager -> IdManagerState -> Prop) */
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
*/
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    if (manager == (void *)0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "AllocId", 31, "manager");
        while (1)
            ;
    }

    end = (manager->id_max + 7) / 8;

    for (index = 0; index < end; index++)
        if (manager->id_map[index] != 0xff)
            break;
    if (index == end)
        return -1;

    id = index * 8;
    entry = manager->id_map[index];
    while (entry & 0x1) {
        id++;
        entry >>= 1;
    }
    if (id >= manager->id_max)
        return -1;

    manager->id_map[index] |= (0x1 << (id % 8));

    return id;
}
