#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c. Current 32-bit non-SMP configuration. */
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
*/
;

void FreeId(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require store_idmanager_found(sm, m, manager, idnode, id)
    Ensure store_idmanager_remove_ready(sm, m, manager, idnode, id)
*/
;

struct IdNode *RemoveObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sm, m, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sm, m, manager, idnode, id)
*/
;

void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ high_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sm, idmanager_add(m, id), id, idnode), id)
              == true &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           (idnode->link.node_prev == &(idnode->link)) *
           (idnode->link.node_next == &(idnode->link))
*/
/*@ low_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            store_idmanager(sm, m, manager)
    Ensure (idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (exists idnode,
              idmanager_query(m, id) == true &&
              idmanager_contains(sm, m, id, idnode) &&
              idnode != 0 &&
              &(idnode->link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              (idnode->id == 65535) *
              (idnode->link.node_prev == &(idnode->link)) *
              (idnode->link.node_next == &(idnode->link)))
*/
{
    if (manager == NONE) { while (1) { } }
    
    struct IdNode *idnode = IdGetObj(manager, id);

    if (idnode == NONE)
        return;

    FreeId(manager, idnode->id);
    RemoveObj(manager, idnode);
    idnode->id = -1;
}
