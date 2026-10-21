#include "../slice_types.h"
#include "../logic.h"

void *x_malloc(x_size_t nbytes)
/*@ Require nbytes == 32 && emp
    Ensure (__return == 0 && emp) ||
      (__return != 0 && SemaphoreRaw(__return))
*/;

void *memset(void *dest, int c, size_t n)
/*@ Require c == 0 && n == 32 && SemaphoreRaw(dest)
    Ensure __return == dest && SemaphoreZero(dest)
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
x_base CriticalAreaLock(void)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists locked,
      Crtos_RTrans(before, locked) &&
      InsideCritical(sg, locked) * os_inv(sg, locked)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && idnode != 0 &&
      store_idmanager(sidm, before, manager) * ZeroIdNode(idnode)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager) * ZeroIdNode(idnode))
      ||
      (0 <= __return && __return < sidm.idmax &&
        idmanager_min_free_id(sidm, before, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(before, __return), __return, idnode),
          manager))
*/;

void x_free(void *ptr)
/*@ Require SemaphoreZero(ptr)
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require NodeStorage(linklist_head)
    Ensure store_node_self_linked(linklist_head)
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (next : Z) (oldprev : Z) (oldnext : Z)
    Require DllInsertAfterCut(linklist, next, linklist_node, oldprev, oldnext)
    Ensure DllInsertedCut(linklist, next, linklist_node)
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
void CriticalAreaUnLock(x_base lock)
/*@ With (sg : StableGlobalState) (locked : VarGlobalState)
         (after : VarGlobalState)
    Require Crtos_GTrans(locked, after) &&
      InsideCritical(sg, locked) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
*/;

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

/* Canonical: _SemaphoreCreate. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c:33. */
int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(-5), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
*/
{
    /*@ 0 <= val && val <= 65535 by local */
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = (0);
    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == (0))
        return -5;
    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock() /*@ where sg = sg, before = before */;
    /*@ Given locked */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
        /*@ where sidm = sg.os_semaphore_stable.semaphore_manager_stable,
                  before = semaphore_manager(locked.os_semaphores) */;
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock) /*@ where sg = sg, locked = locked, after = locked */;
        return -5;
    }
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list);
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        /*@ where next = semaphore_first_link(sg.os_semaphore_stable, locked.os_semaphores),
                  oldprev = 0, oldnext = 0 */;
    CriticalAreaUnLock(lock)
        /*@ where sg = sg, locked = locked,
                  after = replace_semaphores(semaphore_publish(sem, id, val, locked.os_semaphores), locked) */;
    do { if (0) { KPrintf("[%s:%d] ", __func__, 59); KPrintf ("created semaphore: id %d, value %d\n", id, (int)val); } } while (0);
    return id;
}
