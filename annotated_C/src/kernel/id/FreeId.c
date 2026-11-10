#include "m_id.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c. Current 32-bit non-SMP configuration. */


void FreeId(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require store_idmanager_found(sm, m, manager, idnode, id)
    Ensure store_idmanager_remove_ready(sm, m, manager, idnode, id)
*/
{
    if (manager == NONE) { while (1) { } }

    manager->id_map[id / 8] &= ~(0x1 << (id % 8));
}
