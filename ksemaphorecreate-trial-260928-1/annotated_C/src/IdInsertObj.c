/* Source: kernel/thread/id.c:106-120. Assignment-in-condition is split into
 * assignment plus comparison; active NULL_PARAM_CHECKs are expanded with source
 * lines 110 and 111. QCP does not parse a variadic prototype, so trusted KPrintf
 * is declared with the exact four argument types used by these expansions; the
 * Cortex-M3 cdecl ABI and actual call arguments are unchanged. Paths, values and
 * side effects are otherwise unchanged. */
typedef unsigned char uint8;
typedef unsigned short uint16;
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
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

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *) */
/*@ Extern Coq (semaphore_first_free : SemaphoreStable -> SemaphoreState -> option Z)
               (semaphore_reserve_state : SemaphoreState -> Z -> Z -> SemaphoreState)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (semaphore_layout_32_ok : Z -> Prop)
               (store_semaphore_id_manager :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (store_sem_manager_id_allocated :
                 SemaphoreStable -> SemaphoreState -> Z -> Assertion)
               
               (store_sem_id_node_zeroed : Z -> Assertion)
               (store_sem_id_node_insert_ready : Z -> Z -> Assertion)
               (store_sem_id_node_zeroed_rest : Z -> Assertion)
               (semaphore_manager_addr : SemaphoreStable -> Z)
               (semaphore_id_limit : SemaphoreStable -> Z)
 */

int AllocId(struct IdManager *manager)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState)
    Require manager != 0 && SemaphoreStableContext(stable) &&
      manager == semaphore_manager_addr(stable) &&
      store_semaphore_id_manager(stable, before)
    Ensure manager != 0 && SemaphoreStableContext(stable) &&
      ((__return == -1 && semaphore_first_free(stable, before) == None &&
       store_semaphore_id_manager(stable, before))
      ||
      (0 <= __return && semaphore_first_free(stable, before) == Some(__return) &&
       store_sem_manager_id_allocated(stable, before, __return)))
 */;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState) sem id
    Require manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      manager == semaphore_manager_addr(stable) &&
      idnode == field_addr(sem, struct Semaphore, id) &&
      store_sem_manager_id_allocated(stable, before, id) *
      store_sem_id_node_insert_ready(sem, id)
    Ensure manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      store_semaphore_id_manager(stable, semaphore_reserve_state(before, sem, id))
 */;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState) sem
    Require manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      manager == semaphore_manager_addr(stable) &&
      idnode == field_addr(sem, struct Semaphore, id) &&
      store_semaphore_id_manager(stable, before) *
      store_sem_id_node_zeroed(sem)
    Ensure manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      ((__return == -1 && semaphore_first_free(stable, before) == None &&
       store_semaphore_id_manager(stable, before) *
       store_sem_id_node_zeroed(sem))
      ||
      (0 <= __return && semaphore_first_free(stable, before) == Some(__return) &&
       store_semaphore_id_manager(
         stable, semaphore_reserve_state(before, sem, __return))))
 */
{
    int id = 0;
    if (manager == 0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "IdInsertObj", 110, "manager");
        while (1)
            ;
    }
    if (idnode == 0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "IdInsertObj", 111, "idnode");
        while (1)
            ;
    }
    id = AllocId(manager)
      /*@ where stable = stable, before = before */;
    if (id < 0)
        return -1;
    /*@ semaphore_layout_32_ok(sem) &&
        idnode@pre == field_addr(sem, struct Semaphore, id) &&
        store_sem_id_node_zeroed(sem)
        which implies
          store(&(idnode@pre->id), unsigned short, 0) *
          store_sem_id_node_zeroed_rest(sem)
    */
    idnode->id = id;
    /*@ SemaphoreStableContext(stable) &&
        semaphore_layout_32_ok(sem) &&
        idnode@pre == field_addr(sem, struct Semaphore, id) &&
        0 <= id && id < semaphore_id_limit(stable) &&
        store(&(idnode@pre->id), unsigned short,
          unsigned_last_nbits(id, 16)) *
        store_sem_id_node_zeroed_rest(sem)
        which implies store_sem_id_node_insert_ready(sem, id)
     */
    InsertObj(manager, idnode)
      /*@ where stable = stable, before = before, sem = sem, id = id */;
    return id;
}
