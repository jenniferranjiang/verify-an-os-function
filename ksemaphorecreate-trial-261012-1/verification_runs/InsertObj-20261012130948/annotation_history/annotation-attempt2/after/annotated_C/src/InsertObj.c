#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"


/*@ Extern Coq
    (IdNodeAbs :: *)
    (DL_Node :: * => *)
*/
/*@ Extern Coq
    (idmax : StableIdmanager -> Z)
    (hoffset : StableIdmanager -> Z)
    (id_map : StableIdmanager -> Z)
    (htable : StableIdmanager -> Z)
    (idlist : VarIdmanager -> list Z)
    (idbuckets : VarIdmanager -> list (list IdNodeAbs))
    (idlist_add : Z -> list Z -> list Z)
    (idbuckets_ok : Z -> Z -> list Z -> list (list IdNodeAbs) -> Prop)
    (store_id_map : Z -> Z -> list Z -> Task_C_Rules::expr)
    (store_idbuckets : Z -> Z -> list (list IdNodeAbs) -> Task_C_Rules::expr)
    (store_idbuckets_except : Z -> Z -> list IdNodeAbs -> list (list IdNodeAbs) -> Task_C_Rules::expr)
    (idnodes_nonzero : list IdNodeAbs -> Prop)
    (idnodes_dllseg : Z -> Z -> Z -> Z -> list IdNodeAbs -> Task_C_Rules::expr)
    (idnodes_to_dll : list IdNodeAbs -> list (DL_Node IdNodeAbs))
    (store_idnode : Z -> IdNodeAbs -> Task_C_Rules::expr)
    (DLL::dllseg_shift_rev : {A} -> (Z -> A -> Task_C_Rules::expr) -> Z -> Z -> list (DL_Node A) -> Task_C_Rules::expr)
*/

/* Candidate contracts use the compiled OSHeap transport; bodies await verification. */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With (head : Z)
    Require linklist_head == head && head != 0 &&
      undef_data_at(&(linklist_head->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_head->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist_head->node_next), struct SysDoubleLinklistNode *, head) *
      store(&(linklist_head->node_prev), struct SysDoubleLinklistNode *, head)
*/;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (successor : Z) (previous : Z)
    Require linklist != 0 && linklist_node != 0 && successor != 0 &&
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, previous) *
      undef_data_at(&(linklist_node->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_node->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(linklist_node->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(linklist_node->node_prev), struct SysDoubleLinklistNode *, linklist)
*/;
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
/*@ Require emp
    Ensure emp
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
         (id : Z) (previous : Z) (next : Z)
    Require manager != 0 && idnode != 0 &&
      OSHeap(store_idmanager_allocated_unlinked(sm, before, manager, id)) *
      OSHeap(store_sem_id_detached(idnode, id, previous, next))
    Ensure
      OSHeap(store_idmanager(sm,
        idmanager_link(sm, idmanager_add(before, id), id, idnode), manager))
*/
{
    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 64, "manager");
            /*@ Inv Assert 0 == 1 && emp */
            while (1)
                ;
        }
    } while (0);
    do {
        if (idnode == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 65, "idnode");
            /*@ Inv Assert 0 == 1 && emp */
            while (1)
                ;
        }
    } while (0);

    /*@ Assert
      manager == manager@pre && idnode == idnode@pre &&
      manager != 0 && idnode != 0 && &(idnode->link) != 0 &&
      idmanager_min_free_id(sm, before, id) &&
      idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
      0 <= id && id <= 65535 && 0 < hoffset(sm) && hoffset(sm) <= 65535 &&
      store(&(manager->id_max), unsigned short, idmax(sm)) *
      store(&(manager->hoffset), unsigned short, hoffset(sm)) *
      store(&(manager->id_map), unsigned char *, id_map(sm)) *
      store(&(manager->htable), struct SysDoubleLinklistNode *, htable(sm)) *
      OSHeap(store_id_map(id_map(sm), idmax(sm), idlist_add(id, idlist(before)))) *
      store(&(idnode->id), unsigned short, id) *
      undef_data_at(&(idnode->link.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(idnode->link.node_next), struct SysDoubleLinklistNode *) *
      OSHeap(store_idbuckets(htable(sm), hoffset(sm), idbuckets(before))) */
    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    /*@ Assert exists (bucket : list IdNodeAbs),
      head == htable(sm) + (id % hoffset(sm)) * sizeof(struct SysDoubleLinklistNode) &&
      head != 0 && bucket == Znth(id % hoffset(sm), idbuckets(before), nil) &&
      manager == manager@pre && idnode == idnode@pre &&
      manager != 0 && idnode != 0 && &(idnode->link) != 0 &&
      idmanager_min_free_id(sm, before, id) &&
      idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
      0 <= id && id <= 65535 && 0 < hoffset(sm) && hoffset(sm) <= 65535 &&
      store(&(manager->id_max), unsigned short, idmax(sm)) *
      store(&(manager->hoffset), unsigned short, hoffset(sm)) *
      store(&(manager->id_map), unsigned char *, id_map(sm)) *
      store(&(manager->htable), struct SysDoubleLinklistNode *, htable(sm)) *
      OSHeap(store_id_map(id_map(sm), idmax(sm), idlist_add(id, idlist(before)))) *
      store(&(idnode->id), unsigned short, id) *
      undef_data_at(&(idnode->link.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(idnode->link.node_next), struct SysDoubleLinklistNode *) *
      OSHeap(store_idbuckets_except(htable(sm), id % hoffset(sm), bucket, idbuckets(before))) *
      ((bucket == nil &&
        store(&(head->node_prev), struct SysDoubleLinklistNode *, 0) *
        store(&(head->node_next), struct SysDoubleLinklistNode *, 0)) ||
       (exists (hp : Z) (hn : Z), hp != 0 && hn != 0 && idnodes_nonzero(bucket) &&
        store(&(head->node_prev), struct SysDoubleLinklistNode *, hp) *
        store(&(head->node_next), struct SysDoubleLinklistNode *, hn) *
        OSHeap(idnodes_dllseg(hn, head, head, hp, bucket)))) */
    if (head->node_prev == NONE)
        InitDoubleLinkList(head);

    /*@ Assert exists (bucket : list IdNodeAbs) (successor : Z),
      head == htable(sm) + (id % hoffset(sm)) * sizeof(struct SysDoubleLinklistNode) &&
      head != 0 && successor != 0 && &(idnode->link) != 0 &&
      bucket == Znth(id % hoffset(sm), idbuckets(before), nil) &&
      idnodes_nonzero(bucket) &&
      manager == manager@pre && idnode == idnode@pre &&
      manager != 0 && idnode != 0 &&
      idmanager_min_free_id(sm, before, id) &&
      idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
      0 <= id && id <= 65535 && 0 < hoffset(sm) && hoffset(sm) <= 65535 &&
      store(&(manager->id_max), unsigned short, idmax(sm)) *
      store(&(manager->hoffset), unsigned short, hoffset(sm)) *
      store(&(manager->id_map), unsigned char *, id_map(sm)) *
      store(&(manager->htable), struct SysDoubleLinklistNode *, htable(sm)) *
      OSHeap(store_id_map(id_map(sm), idmax(sm), idlist_add(id, idlist(before)))) *
      store(&(idnode->id), unsigned short, id) *
      undef_data_at(&(idnode->link.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(idnode->link.node_next), struct SysDoubleLinklistNode *) *
      OSHeap(store_idbuckets_except(htable(sm), id % hoffset(sm), bucket, idbuckets(before))) *
      store(&(head->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, head) *
      OSHeap(DLL::dllseg_shift_rev(store_idnode, successor, head, idnodes_to_dll(bucket))) */
    DoubleLinkListInsertNodeAfter(head, &idnode->link);
}
