/*
 * Extraction: kernel/thread/id.c:62-73.
 * NULL_PARAM_CHECK is expanded; the static function is slice-externalized.
 */

typedef unsigned char uint8;
typedef unsigned short uint16;

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

struct IdNode {
    uint16 id;
    DoubleLinklistType link;
};

struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

/*@ Extern Coq (StableIdManager :: *)
               (IdManagerState :: *)
               (IdNodeAbs :: *)
               (IdBucket :: *)
               (DllNode :: * => *)
               (Build_IdNodeAbs : Z -> Z -> IdNodeAbs)
               (id_manager_bucket_index : StableIdManager -> Z -> Z)
               (id_manager_buckets : IdManagerState -> list IdBucket)
               (id_bucket_nodes : IdBucket -> list IdNodeAbs)
               (id_manager_after_insert : StableIdManager -> IdManagerState -> Z -> Z -> IdManagerState)
               (id_manager_min_free_id : StableIdManager -> IdManagerState -> Z -> Prop)
               (store_id_manager : StableIdManager -> IdManagerState -> Z -> Assertion)
               (store_id_manager_insert_ready : StableIdManager -> IdManagerState -> Z -> Z -> Z -> Assertion)
               (store_id_node_payload : Z -> IdNodeAbs -> Assertion)
               (id_node_to_dll : IdNodeAbs -> DllNode IdNodeAbs)
               (id_nodes_to_dll : list IdNodeAbs -> list (DllNode IdNodeAbs))
               (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DllNode A) -> Assertion)
               (store_dll_node_uninitialized : Z -> Assertion)
               (store_dll_node_standalone : Z -> Assertion)
               (dll_insert_after : {A} -> Z -> Z -> DllNode A -> list (DllNode A) -> list (DllNode A) -> Prop)
               (dll_link_addr : {A} -> DllNode A -> Z)
               (dll_payload : {A} -> DllNode A -> A)
               (Znth : {A} -> Z -> list A -> A -> A)) */
/*@ Import Coq Require Import CRTOS_Verify.lib.IdManagerRep */

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require store_dll_node_uninitialized(linklist_head)
    Ensure store_dll_node_standalone(linklist_head)
*/;

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *linklist,
    DoubleLinklistType *linklist_node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         head focus (new_node : DllNode A) before_nodes after_nodes
    Require focus == linklist &&
            dll_link_addr(new_node) == linklist_node &&
            dll_insert_after(head, focus, new_node,
                             before_nodes, after_nodes) &&
            store_dll(store_payload, head, before_nodes) *
            store_payload(linklist_node, dll_payload(new_node)) *
            store_dll_node_uninitialized(linklist_node)
    Ensure store_dll(store_payload, head, after_nodes)
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdManager) (before : IdManagerState) id
    Require manager != 0 && idnode != 0 &&
            store_id_manager_insert_ready(sm, before, manager, id, idnode)
    Ensure id_manager_min_free_id(sm, before, id) &&
           store_id_manager(sm,
             id_manager_after_insert(sm, before, id, idnode), manager)
*/
{
    if (manager == (void *)0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "InsertObj", 64, "manager");
        while (1)
            ;
    }
    if (idnode == (void *)0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "InsertObj", 65, "idnode");
        while (1)
            ;
    }

    DoubleLinklistType *head =
        &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == (void *)0)
        InitDoubleLinkList(head);

    DoubleLinkListInsertNodeAfter(head, &idnode->link)
      /*@ where A = IdNodeAbs,
                   store_payload = store_id_node_payload,
                   head = head,
                   focus = head,
                   new_node = id_node_to_dll(
                     Build_IdNodeAbs(id, idnode)),
                   before_nodes = id_nodes_to_dll(
                     id_bucket_nodes(
                       Znth(id_manager_bucket_index(sm, id),
                            id_manager_buckets(before), None))),
                   after_nodes = cons(
                     id_node_to_dll(Build_IdNodeAbs(id, idnode)),
                     id_nodes_to_dll(
                       id_bucket_nodes(
                         Znth(id_manager_bucket_index(sm, id),
                              id_manager_buckets(before), None)))) */;
}
