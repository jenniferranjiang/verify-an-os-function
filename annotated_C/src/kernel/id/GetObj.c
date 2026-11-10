#include "m_id.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c. Current 32-bit non-SMP configuration. */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */
;

struct IdNode *CONTAINER_OF_IDNODE_LINK(DoubleLinklistType *link_ptr)
/*@ With (idnode_ptr : addr)
    Require link_ptr == field_addr(idnode_ptr, struct IdNode, link) && emp
    Ensure __return == idnode_ptr && link_ptr == &(__return->link) && emp
 */;

struct IdNode *GetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < sm.idmax && store_idmanager(sm, m, manager)
    Ensure (__return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (__return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/
{
    if (manager == NONE) { while (1) { } }

    DoubleLinklistType *head = &manager->htable[id % manager->hoffset];
    DoubleLinklistType *node = NONE;
    struct IdNode *idnode = NONE;

    if (head->node_prev == NONE) {
        InitDoubleLinkList(head);
        return NONE;
    }

    for (node = head->node_next; node != head; node = node->node_next) {
        idnode =CONTAINER_OF_IDNODE_LINK(node);
        if (idnode->id == id)
            break;
        idnode = NONE;
    }

    return idnode;
}
