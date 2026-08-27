typedef unsigned short uint16;
typedef unsigned char uint8;

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

extern struct IdManager k_sem_id_manager;

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *) */
/*@ Extern Coq
      (semaphore_layout_ok : Z -> Prop)
      (semaphore_min_free_id : SemaphoreStable -> SemaphoreState -> Z -> Prop)
      (semaphore_no_free_id : SemaphoreStable -> SemaphoreState -> Prop)
      (semaphore_mark_bucket_initialized :
        SemaphoreStable -> Z -> list bool -> list bool)
      (semaphore_create_state : SemaphoreState -> Z -> Z -> Z -> SemaphoreState)
      (store_sem_id_manager : SemaphoreStable -> SemaphoreState -> list bool -> Assertion)
      (store_sem_id_manager_reserved :
        SemaphoreStable -> SemaphoreState -> list bool -> Z -> Assertion)
      (store_sem_idnode_insert_ready : Z -> Assertion)
      (occupy_dll_node : Z -> Assertion)
 */

/* Nested implementation API: canonical declaration-only spec. */
void NullParameterCheck(void *param)
/*@ Require param != 0 && emp Ensure emp */
;

/* Nested implementation API: canonical declaration-only spec. */
int AllocId(struct IdManager *manager)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState) (flags : list bool)
    Require manager == &k_sem_id_manager &&
      store_sem_id_manager(sg, st, flags)
    Ensure
      (__return == -1 && semaphore_no_free_id(sg, st) &&
       store_sem_id_manager(sg, st, flags)) ||
      (0 <= __return && __return < 128 &&
       semaphore_min_free_id(sg, st, __return) &&
       store_sem_id_manager_reserved(sg, st, flags, __return))
 */
;

/* Nested implementation API: canonical declaration-only spec. */
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState)
         (flags : list bool) (id : Z)
    Require manager == &k_sem_id_manager &&
      store_sem_id_manager_reserved(sg, st, flags, id) *
      (idnode->id == id) * occupy_dll_node(&(idnode->link))
    Ensure store_sem_id_manager(
      sg, semaphore_create_state(st, id, idnode, 0),
      semaphore_mark_bucket_initialized(sg, id, flags))
 */
;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState)
         (flags : list bool) (sem : Z)
    Require manager == &k_sem_id_manager && idnode == sem &&
      semaphore_layout_ok(sem) &&
      store_sem_id_manager(sg, st, flags) *
      store_sem_idnode_insert_ready(sem)
    Ensure
      (__return == -1 && semaphore_no_free_id(sg, st) &&
       store_sem_id_manager(sg, st, flags) *
       store_sem_idnode_insert_ready(sem)) ||
      (0 <= __return && __return < 128 &&
       semaphore_min_free_id(sg, st, __return) &&
       store_sem_id_manager(
         sg, semaphore_create_state(st, __return, sem, 0),
         semaphore_mark_bucket_initialized(sg, __return, flags)))
 */
{
    int id = 0;

    NullParameterCheck(manager);
    NullParameterCheck(idnode);

    id = AllocId(manager)
      /*@ where sg = sg, st = st, flags = flags */;
    if (id < 0)
        return -1;

    /*@ store_sem_idnode_insert_ready(sem)
        which implies
        idnode@pre == sem &&
        undef_data_at(&(idnode@pre->id), unsigned short) *
        occupy_dll_node(&(idnode@pre->link))
     */

    idnode->id = id;

    InsertObj(manager, idnode)
      /*@ where sg = sg, st = st, flags = flags,
          id = id */;

    return id;
}
