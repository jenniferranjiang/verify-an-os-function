#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
void *x_malloc(x_size_t nbytes)
/*@ Require nbytes == 32 && emp
    Ensure (__return == 0 && emp) ||
           (__return != 0 && sem_allocated(__return))
*/;

void *memset(void *dest, int c, size_t count)
/*@ Require c == 0 && count == 32 && sem_allocated(dest)
    Ensure __return == dest && sem_zero(dest)
*/;

x_base CriticalAreaLock(void)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z)
    Require
      (mode == 0 && OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure exists acquired old_n,
      ((mode == 0 && __return == irq && Crtos_RTrans(before, acquired)) ||
       (mode == 1 && __return == 1 && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(mode, anchor, acquired)) *
      slice_OS_inv(sg, acquired, nest_inc(old_n)) * IRQMask(1)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (idm : VarIdmanager)
         (old_id old_prev old_next : Z)
    Require ((manager == 0 || idnode == 0) && emp) ||
            (manager != 0 && idnode != 0 &&
             store_idmanager(sidm, idm, manager) *
             idnode_private(idnode, old_id, old_prev, old_next))
    Ensure manager != 0 && idnode != 0 &&
      ((__return == -1 && idmanager_full(sidm, idm) &&
        store_idmanager(sidm, idm, manager) *
        idnode_private(idnode, old_id, old_prev, old_next)) ||
       (idmanager_min_free_id(sidm, idm, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
          manager)))
*/;

void x_free(void *ptr)
/*@ Require sem_zero(ptr)
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With {A} (storeA : Z -> A -> Assertion)
    Require linklist_head != 0 && occupy_dll_node(linklist_head)
    Ensure store_dll(storeA, linklist_head, nil)
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With {A} (storeA : Z -> A -> Assertion)
         (nodes : list(DL_Node A)) (inserted_data : A)
    Require linklist_node != 0 &&
            store_dll(storeA, linklist, nodes) *
            storeA(linklist_node, inserted_data) * occupy_dll_node(linklist_node)
    Ensure store_dll(storeA, linklist,
             cons(Build_DL_Node(inserted_data, linklist_node), nodes))
*/;

void CriticalAreaUnLock(x_base lock)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require
      (mode == 0 && Crtos_GTrans(anchor, current) &&
       (lock == 0 || lock == 1) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1)) ||
      (mode == 1 && lock == 1 &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1))
    Ensure
      (mode == 0 && OutsideCritical(sg, current) * IRQMask(lock)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, current, nest_dec(n)) * IRQMask(1))
*/;

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/semaphore.c:33. */
int32 _SemaphoreCreate(uint16 val)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z) X Y
    Require
      (mode == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_nested(sg, val), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure
      (exists after, mode == 0 &&
       __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after, mode == 0 &&
       0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after n_after, mode == 1 &&
       __return == -5 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, n_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, after, n_after) * IRQMask(1)) ||
      (exists after, mode == 1 &&
       0 <= __return && __return < 128 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) *
       slice_OS_inv(sg, after, nest_roundtrip(n)) * IRQMask(1))
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
        /*@ where mode = mode, sg = sg, anchor = anchor, before = before,
                  n = n, irq = irq */;
    /*@ Given acquired old_n */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
        /*@ where sidm = sem_idmanager_stable(os_semaphore_stable(sg)),
                  idm = semaphore_idmanager(os_semaphore_stable(sg), os_semaphores(acquired)),
                  old_id = 0, old_prev = 0, old_next = 0 */;
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock)
            /*@ where mode = mode, sg = sg,
                      anchor = critical_anchor(mode, anchor, acquired),
                      current = acquired, n = nest_inc(old_n) */;
        return -ENOMEMORY;
    }

    /* The ID manager now owns sem->id fields; sem_id_registered(sem)
       owns the remaining value/padding/pend_list/link bytes. */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list)
        /*@ where storeA = pure_semaphore_link_member; A = Z */;

    
    /* sem_ready_to_publish(sem,val) retains the private payload and link. */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        /*@ where storeA = pure_semaphore_link_member,
                  nodes = semaphore_link_nodes(sem_ptr_list(os_semaphores(acquired))),
                  inserted_data = sem; A = Z */;
    CriticalAreaUnLock(lock)
        /*@ where mode = mode, sg = sg,
                  anchor = critical_anchor(mode, anchor, acquired),
                  current = replace_semaphores(
                    semaphore_publish(sem, id, val, os_semaphores(acquired)), acquired),
                  n = nest_inc(old_n) */;

    do { if (0) { KPrintf("[%s:%d] ", "_SemaphoreCreate", 59); KPrintf("created semaphore: id %d, value %d\n", id, (int)val); } } while (0);

    return id;
}
