#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

/* Canonical: AllocId. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:24. */
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
*/
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;
    do { if (manager == (0)) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", __FUNCTION__, 31, "manager"); while (1) ; } } while (0);
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
