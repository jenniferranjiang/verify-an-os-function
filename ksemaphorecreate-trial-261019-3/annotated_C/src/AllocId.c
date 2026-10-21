#include "../slice_types.h"
#include "../logic.h"

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

/* Canonical: AllocId. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:24. */
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
