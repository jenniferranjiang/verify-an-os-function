#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c. Current 32-bit non-SMP configuration. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sidm, idm, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/;

void FreeId(struct IdManager *manager, uint16 id)
/*@ found_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
 */;

struct IdNode *RemoveObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sidm, idm, manager, idnode, id)
*/;

void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ known_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id)
              == true &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sidm,
             idmanager_remove(sidm,
               idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           store_node_self_linked(&(idnode->link))
*/
/*@ current_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ found_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ absent_node
    With (sidm : StableIdmanager) (idm : VarIdmanager)
    Require idmanager_query(idm, id) == false && store_idmanager(sidm, idm, manager)
    Ensure store_idmanager(sidm, idm, manager)
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
