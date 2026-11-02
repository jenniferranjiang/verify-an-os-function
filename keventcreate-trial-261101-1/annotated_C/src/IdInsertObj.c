#include "../include/slice_types.h"
#include "../include/logic.h"

/* reused-spec: root annotated_C/src/headers/id_module_spec.h. */
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sm, m, __return) &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, __return), __return, idnode),
              manager))
*/;
