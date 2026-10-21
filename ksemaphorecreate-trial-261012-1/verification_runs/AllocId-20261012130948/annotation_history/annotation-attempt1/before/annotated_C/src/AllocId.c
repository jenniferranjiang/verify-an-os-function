#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Candidate contracts use the compiled OSHeap transport; bodies await verification. */
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && OSHeap(store_idmanager(sm, before, manager))
    Ensure
      (__return == -1 && idmanager_full(sm, before) &&
        OSHeap(store_idmanager(sm, before, manager))) ||
      (idmanager_min_free_id(sm, before, __return) &&
        OSHeap(store_idmanager_allocated_unlinked(sm, before, manager, __return)))
*/
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "AllocId", 31, "manager");
            while (1)
                ;
        }
    } while (0);

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
