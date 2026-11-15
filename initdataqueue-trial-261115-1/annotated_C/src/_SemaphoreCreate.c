/* New IC low-level design, not an OC refinement or reused implementation proof.
 * Global OC source remains unchanged: annotated_C/src/kernel/semaphore/_SemaphoreCreate.c
 * Source SHA256 1521af39810c3bc745e81800ac6ea3d38a761116e82522b0c3ecc684f878659b.
 * C baseline: kernel/thread/semaphore.c; done-table resolved to static functions.
 * No QCP execution or implementation proof has been performed in this trial.
 */
#include "../headers/semaphore.h"

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

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sm, m, __return) &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, __return), __return, idnode),
              manager))
*/;

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

int32 _SemaphoreCreate(uint16 val)
/*@ inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, __return, before, after) &&
      os_inv(sg, after)
 */
{
    
    int32 id = 0;
    /* Original nested-lock local, unused after the documented adaptation: x_base lock = 0; */
    struct Semaphore *sem = (0);

    sem = (struct Semaphore *)x_malloc(32);
    if (sem == (0))
        return -5;

    memset(sem, 0, 32);
    /* Convert the complete zero byte array, retaining embedded-node validity. */
    
    /* Nested critical operation removed by source-processing rule: lock = CriticalAreaLock(); */
    
    /* Expose the frozen ID interface while framing the complete payload. */
    
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        /* The ID API returns unknown-owned fields, sufficient for full reclamation. */
        
        x_free(sem);
        /* Nested critical operation removed by source-processing rule: CriticalAreaUnLock(lock); */
        return -5;
    }
    sem->value = val;

    /* Expose exactly the pending-list fields overwritten by initialization. */
    
    InitDoubleLinkList(&sem->pend_list);
    /* Pack the newly initialized payload for VRTOS's complete-DLL interface. */
    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        ;
    /* Restore the complete invariant for the newly published abstract object. */
    
    /* Nested critical operation removed by source-processing rule: CriticalAreaUnLock(lock); */

    return id;
}
