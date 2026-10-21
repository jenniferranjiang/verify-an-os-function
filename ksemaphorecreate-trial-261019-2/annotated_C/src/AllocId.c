/* Fresh extraction: kernel/thread/id.c:24; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

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
*/
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    do { if (manager == NONE) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "AllocId", 31, "manager");
        while (RET_TRUE) ;
    } } while (0);

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
