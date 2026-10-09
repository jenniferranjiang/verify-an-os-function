/* Source: kernel/thread/id.c:62-73. TU-static helper externalized; active
 * NULL_PARAM_CHECKs are expanded with source lines 64 and 65. QCP does not parse
 * a variadic prototype, so trusted KPrintf is declared with the exact four
 * argument types used by these expansions; the Cortex-M3 cdecl ABI and actual
 * call arguments are unchanged. */
typedef unsigned char uint8;
typedef unsigned short uint16;
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import Coq.Lists.List */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphorePure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreProofLocal */
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct Semaphore {
    struct IdNode id; uint16 value;
    DoubleLinklistType pend_list; DoubleLinklistType link;
};
struct IdManager {
    uint16 id_max; uint16 hoffset; uint8 *id_map; DoubleLinklistType *htable;
};

void KPrintf(const char *fmt, const char *function, int line,
             const char *parameter)
/*@ Require emp Ensure emp */;

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *)
               (SemaphoreObject :: *) (SemDLNode :: * => *)
               (unit :: *) */
/*@ Extern Coq (semaphore_unit_empty : Z -> unit -> Assertion)
               (map : {A B} -> (A -> B) -> list A -> list B)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (semaphore_layout_32_ok : Z -> Prop)
               (Build_SemaphoreObject : Z -> Z -> Z -> list Z -> SemaphoreObject)
               (Build_SemDLNode : {A} -> A -> Z -> SemDLNode A)
               (semaphore_reserve_state : SemaphoreState -> Z -> Z -> SemaphoreState)
               (store_sem_manager_id_allocated :
                 SemaphoreStable -> SemaphoreState -> Z -> Assertion)
               (store_sem_id_node_insert_ready : Z -> Z -> Assertion)
               (store_sem_id_node_insert_ready_rest : Z -> Z -> Assertion)
               (store_semaphore_id_manager :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (store_semaphore_bitmap_ids :
                 SemaphoreStable -> list Z -> Assertion)
               (store_semaphore_buckets :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (store_sem_dll :
                 {A} -> (Z -> A -> Assertion) -> Z -> list(SemDLNode A) -> Assertion)
               (store_sem_dll_without_prev :
                 {A} -> (Z -> A -> Assertion) -> Z -> list(SemDLNode A) -> Z -> Assertion)
               (store_sem_standalone_node :
                 {A} -> (Z -> A -> Assertion) -> Z -> A -> Assertion)
               (store_sem_buckets_none_rest :
                 SemaphoreStable -> SemaphoreState -> Z -> Assertion)
               (store_sem_buckets_some_rest :
                 SemaphoreStable -> SemaphoreState -> Z -> Assertion)
               (store_semaphore_id_payload : Z -> SemaphoreObject -> Assertion)
               (semaphore_objects : SemaphoreState -> list SemaphoreObject)
               (semaphore_ids : list SemaphoreObject -> list Z)
               (semaphore_objects_in_bucket :
                 SemaphoreStable -> Z -> list SemaphoreObject -> list SemaphoreObject)
               (semaphore_id_node : SemaphoreObject -> SemDLNode SemaphoreObject)
               (semaphore_manager_addr : SemaphoreStable -> Z)
               (semaphore_id_limit : SemaphoreStable -> Z)
               (semaphore_bucket_count : SemaphoreStable -> Z)
               (semaphore_bitmap_addr : SemaphoreStable -> Z)
               (semaphore_buckets_addr : SemaphoreStable -> Z)
 */

void InitDoubleLinkList(DoubleLinklistType *head)
/*@ With old_next old_prev
    Require
      head != 0 &&
      store(&(head->node_next), void *, old_next) *
      store(&(head->node_prev), void *, old_prev)
    Ensure
      store_sem_dll(semaphore_unit_empty, head, nil)
 */;

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *head, DoubleLinklistType *node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         (payload : A) (nodes : list(SemDLNode A))
    Require
      node != 0 &&
      store_sem_dll(store_payload, head, nodes) *
      store_sem_standalone_node(store_payload, node, payload)
    Ensure
      store_sem_dll(store_payload, head,
        cons(Build_SemDLNode(payload, node), nodes))
 */;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState) sem id
    Require
      manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      manager == semaphore_manager_addr(stable) &&
      idnode == field_addr(sem, struct Semaphore, id) &&
      store_sem_manager_id_allocated(stable, before, id) *
      store_sem_id_node_insert_ready(sem, id)
    Ensure
      manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      store_semaphore_id_manager(
        stable, semaphore_reserve_state(before, sem, id))
 */
{
    if (manager == 0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "InsertObj", 64, "manager");
        while (1)
            ;
    }
    if (idnode == 0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "InsertObj", 65, "idnode");
        while (1)
            ;
    }
    /*@ manager@pre == semaphore_manager_addr(stable) &&
        store_sem_manager_id_allocated(stable, before, id)
        which implies
          store(&(manager@pre->id_max), unsigned short,
            semaphore_id_limit(stable)) *
          store(&(manager@pre->hoffset), unsigned short,
            semaphore_bucket_count(stable)) *
          store(&(manager@pre->id_map), unsigned char *,
            semaphore_bitmap_addr(stable)) *
          store(&(manager@pre->htable), struct SysDoubleLinklistNode *,
            semaphore_buckets_addr(stable)) *
          store_semaphore_bitmap_ids(stable,
            cons(id, semaphore_ids(semaphore_objects(before)))) *
          store_semaphore_buckets(stable, before)
     */
    /*@ SemaphoreStableContext(stable) &&
        semaphore_layout_32_ok(sem) &&
        idnode@pre == field_addr(sem, struct Semaphore, id) &&
        store_sem_id_node_insert_ready(sem, id)
        which implies
          sem != 0 && 0 <= id && id < semaphore_id_limit(stable) &&
          field_addr(idnode@pre, struct IdNode, link) != 0 &&
          store(&(idnode@pre->id), unsigned short, id) *
          store_sem_id_node_insert_ready_rest(sem, id)
     */
    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];
    /*@ SemaphoreStableContext(stable) &&
        0 <= id && id < semaphore_id_limit(stable) &&
        store_semaphore_buckets(stable, before)
        which implies
          (pointer_offset(semaphore_buckets_addr(stable),
               id % semaphore_bucket_count(stable),
               sizeof(struct SysDoubleLinklistNode),
               struct SysDoubleLinklistNode) != 0 &&
           store(field_addr(pointer_offset(semaphore_buckets_addr(stable),
                    id % semaphore_bucket_count(stable),
                    sizeof(struct SysDoubleLinklistNode),
                    struct SysDoubleLinklistNode),
                  struct SysDoubleLinklistNode, node_prev),
                  struct SysDoubleLinklistNode *, 0) *
           store(field_addr(pointer_offset(semaphore_buckets_addr(stable),
                    id % semaphore_bucket_count(stable),
                    sizeof(struct SysDoubleLinklistNode),
                    struct SysDoubleLinklistNode),
                  struct SysDoubleLinklistNode, node_next),
                  struct SysDoubleLinklistNode *, 0) *
           store_sem_buckets_none_rest(stable, before, id % 16))
          ||
          (exists previous,
             pointer_offset(semaphore_buckets_addr(stable),
               id % semaphore_bucket_count(stable),
               sizeof(struct SysDoubleLinklistNode),
               struct SysDoubleLinklistNode) != 0 && previous != 0 &&
             store(field_addr(pointer_offset(semaphore_buckets_addr(stable),
                       id % semaphore_bucket_count(stable),
                       sizeof(struct SysDoubleLinklistNode),
                       struct SysDoubleLinklistNode),
                     struct SysDoubleLinklistNode, node_prev),
                   struct SysDoubleLinklistNode *, previous) *
             store_sem_dll_without_prev(store_semaphore_id_payload,
               pointer_offset(semaphore_buckets_addr(stable),
                 id % semaphore_bucket_count(stable),
                 sizeof(struct SysDoubleLinklistNode),
                 struct SysDoubleLinklistNode),
               map(semaphore_id_node,
                 semaphore_objects_in_bucket(stable, id % 16,
                   semaphore_objects(before))), previous) *
             store_sem_buckets_some_rest(stable, before, id % 16))
     */
    if (head->node_prev == 0)
        InitDoubleLinkList(head)
          /*@ where old_next = 0, old_prev = 0 */;
    /*@ ((store_sem_dll(semaphore_unit_empty,
              pointer_offset(semaphore_buckets_addr(stable),
                id % semaphore_bucket_count(stable),
                sizeof(struct SysDoubleLinklistNode),
                struct SysDoubleLinklistNode), nil) *
            store_sem_buckets_none_rest(stable, before, id % 16))
          ||
          (exists previous,
             previous != 0 &&
             store(field_addr(pointer_offset(semaphore_buckets_addr(stable),
                       id % semaphore_bucket_count(stable),
                       sizeof(struct SysDoubleLinklistNode),
                       struct SysDoubleLinklistNode),
                     struct SysDoubleLinklistNode, node_prev),
                   struct SysDoubleLinklistNode *, previous) *
             store_sem_dll_without_prev(store_semaphore_id_payload,
               pointer_offset(semaphore_buckets_addr(stable),
                 id % semaphore_bucket_count(stable),
                 sizeof(struct SysDoubleLinklistNode),
                 struct SysDoubleLinklistNode),
               map(semaphore_id_node,
                 semaphore_objects_in_bucket(stable, id % 16,
                   semaphore_objects(before))), previous) *
             store_sem_buckets_some_rest(stable, before, id % 16)))
        which implies
          (store_sem_dll(store_semaphore_id_payload,
             pointer_offset(semaphore_buckets_addr(stable),
               id % semaphore_bucket_count(stable),
               sizeof(struct SysDoubleLinklistNode),
               struct SysDoubleLinklistNode),
             map(semaphore_id_node,
               semaphore_objects_in_bucket(stable, id % 16,
                 semaphore_objects(before)))) *
           store_sem_buckets_none_rest(stable, before, id % 16))
          ||
          (store_sem_dll(store_semaphore_id_payload,
             pointer_offset(semaphore_buckets_addr(stable),
               id % semaphore_bucket_count(stable),
               sizeof(struct SysDoubleLinklistNode),
               struct SysDoubleLinklistNode),
             map(semaphore_id_node,
               semaphore_objects_in_bucket(stable, id % 16,
                 semaphore_objects(before)))) *
           store_sem_buckets_some_rest(stable, before, id % 16))
     */
    /*@ semaphore_layout_32_ok(sem) &&
        idnode@pre == field_addr(sem, struct Semaphore, id) &&
        store(&(idnode@pre->id), unsigned short, id) *
        store_sem_id_node_insert_ready_rest(sem, id)
        which implies
          store_sem_standalone_node(store_semaphore_id_payload,
            field_addr(idnode@pre, struct IdNode, link),
            Build_SemaphoreObject(sem, id, 0, nil))
     */
    DoubleLinkListInsertNodeAfter(head, &idnode->link)
      /*@ where store_payload = store_semaphore_id_payload,
                  payload = Build_SemaphoreObject(sem, id, 0, nil),
                  nodes = map(semaphore_id_node,
                    semaphore_objects_in_bucket(stable,
                      id % 16, semaphore_objects(before)));
                  A = SemaphoreObject */;
}
