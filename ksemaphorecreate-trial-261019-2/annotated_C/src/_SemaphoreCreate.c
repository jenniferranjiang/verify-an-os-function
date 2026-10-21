/* Fresh extraction: kernel/thread/semaphore.c:33; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

void *x_malloc(x_size_t nbytes)
/*@ Require nbytes == 32 && emp
    Ensure (__return == 0 && emp) ||
           (__return != 0 && semaphore_allocated(__return))
*/;
void x_free(void *ptr)
/*@ Require semaphore_zero(ptr)
    Ensure emp
*/;
void *memset(void *dest, int c, size_t n)
/*@ Require c == 0 && n == 32 && semaphore_allocated(dest)
    Ensure __return == dest && semaphore_zero(dest)
*/;
x_base CriticalAreaLock(void)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z)
    Require
      (owned == false && OutsideCriticalIRQ(saved, sg, before)) ||
      (owned == true && saved == 1 && InsideCritical(sg, anchor) *
       critical_projection(sg, before) * critical_nest(n))
    Ensure exists acquired old_n,
      __return == saved &&
      ((owned == false &&
        ((saved == 0 && Crtos_RTrans(before, acquired)) ||
         (saved == 1 && acquired == before))) ||
       (owned == true && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(owned, anchor, acquired)) *
      critical_projection(sg, acquired) * critical_nest(critical_nest_inc(old_n))
*/;
void CriticalAreaUnLock(x_base lock)
/*@ With (owned : bool) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require (lock == 0 || lock == 1) &&
            (owned == false || lock == 1) && Crtos_GTrans(anchor, current) &&
            InsideCritical(sg, anchor) * critical_projection(sg, current) * critical_nest(n)
    Ensure
      (owned == false && OutsideCriticalIRQ(lock, sg, current)) ||
      (owned == true && InsideCritical(sg, anchor) *
       critical_projection(sg, current) * critical_nest(critical_nest_dec(n)))
*/;
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager)
         (initial_id initial_prev initial_next : Z)
    Require ((manager == 0 || idnode == 0) && emp) ||
            (manager != 0 && idnode != 0 &&
             store_idmanager(sidm, idm, manager) *
             store_private_idnode(idnode, initial_id, initial_prev, initial_next))
    Ensure manager != 0 && idnode != 0 &&
      ((__return == -1 && idmanager_full(sidm, idm) &&
        store_idmanager(sidm, idm, manager) *
        store_private_idnode(idnode, initial_id, initial_prev, initial_next)) ||
       (idmanager_min_free_id(sidm, idm, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode), manager)))
*/;
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (payload : Z -> A -> Assertion)
    Require linklist_head != 0 && store_uninit_dlnode(linklist_head)
    Ensure store_dll(payload, linklist_head, nil)
*/;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (payload : Z -> A -> Assertion)
         (old_nodes : list(DL_Node A)) (new_data : A)
    Require linklist_node != 0 &&
            store_dll(payload, linklist, old_nodes) *
            payload(linklist_node, new_data) * store_uninit_dlnode(linklist_node)
    Ensure store_dll(payload, linklist,
                     cons(Build_DL_Node(new_data, linklist_node), old_nodes))
*/;
void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;
extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;

int32 _SemaphoreCreate(uint16 val)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z) X Y
    Require
      (owned == false && saved == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCriticalIRQ(0, sg, before)) ||
      (owned == false && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       OutsideCriticalIRQ(1, sg, before)) ||
      (owned == true && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, before) * critical_nest(n))
    Ensure
      (exists after, owned == false && saved == 0 && __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 0 && 0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 1 && __return == -5 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after, owned == false && saved == 1 && 0 <= __return && __return < 128 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after count_after, owned == true && saved == 1 && __return == -5 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, count_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) * critical_nest(count_after)) ||
      (exists after, owned == true && saved == 1 && 0 <= __return && __return < 128 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, critical_nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) *
       critical_nest(critical_nest_roundtrip(n)))
*/
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock()
        /*@ where owned = owned, saved = saved, sg = sg, anchor = anchor,
                  before = before, n = n */;
    /*@ Given acquired old_n */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
        /*@ where sidm = sem_idmanager_stable(os_semaphore_stable(sg)),
                  idm = sem_idmanager_abs(os_semaphores(acquired)),
                  initial_id = 0, initial_prev = 0, initial_next = 0 */;
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock)
            /*@ where owned = owned, sg = sg,
                      anchor = critical_anchor(owned, anchor, acquired), current = acquired,
                      n = critical_nest_inc(old_n) */;
        return -ENOMEMORY;
    }

    /* semaphore_registered retains the ID owner; semaphore_after_id is private. */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list)
        /*@ where payload = pure_suspend_sched_link(task_desc_map(os_tasks(acquired))); A = Z */;

    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        /*@ where payload = store_semaphore_member(pure_suspend_sched_link(task_desc_map(os_tasks(acquired)))),
                  old_nodes = map(semaphore_node, sem_objects(os_semaphores(acquired))),
                  new_data = Build_SemaphoreObject(sem, id, Build_SemaphoreAbs(val, nil));
                  A = SemaphoreObject */;
    CriticalAreaUnLock(lock)
        /*@ where owned = owned, sg = sg,
                  anchor = critical_anchor(owned, anchor, acquired),
                  current = semaphore_publish(acquired, sem, id, val),
                  n = critical_nest_inc(old_n) */;

    do { if (0) { KPrintf("[%s:%d] ", "_SemaphoreCreate", 59);
        KPrintf("created semaphore: id %d, value %d\n", id, (int)val); } } while (0);

    return id;
}
