#include "../slice_types.h"
#include "../logic.h"

void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */;

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sidm, idm) == None &&
            store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sidm, idm, __return) &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
              manager))
*/;

/* Trusted KERNEL_FREE macro target (xs_memory.h): reclaim the complete private
 * allocation; its field values need not remain zero after IdInsertObj failure.
 * The caller supplies the original malloc base and all 32 bytes of ownership.
 * This is a trial-specific free interface, not a copied VRTOS helper proof. */
void x_free(void *ptr)
/*@ Require SemaphoreRaw(ptr)
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist,
                                   DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */;

/* Trusted debug removal (TrustBase.md): variadic KPrintf declaration omitted. */

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

    sem = (struct Semaphore *)x_malloc(32);
    if (sem == (0))
        return -5;

    memset(sem, 0, 32);
    lock = CriticalAreaLock();
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock);
        return -5;
    }
    sem->value = val;

    InitDoubleLinkList(&sem->pend_list);
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link);
    CriticalAreaUnLock(lock);

    return id;
}
