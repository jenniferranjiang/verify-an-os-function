#include "../include/slice_types.h"
#include "../include/logic.h"

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/;
