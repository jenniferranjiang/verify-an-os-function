#include "dataqueue_semaphore_create_logic.h"
/* Active body source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c
 * SHA256 d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec; done-table dispatch resolved from its static initializer. */

/* Source canonical (original OC contract/body, unchanged there):
 * ../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c
 * SHA256 86010ac7d389c6b895a673444d19c96a70b0af365136fe67502838a7f0853a28
 * This file's only active contract is the NEW dataqueue_ic design.
 * OC provenance does not establish this IC contract or C implementation proof.
 * Nested locks are removed only for execution under the caller's critical/IRQ
 * ownership, as authorized by the source-processing rule. */

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
/* Reused canonical API: annotated_C/src/headers/id_module_spec.h
 * SHA256 2f293057ec98604ae558d528291db8ebc0081975aa3bdb741298730adc085fea */
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


/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
void x_free(void *ptr)
/*@ Require SemaphoreRaw(ptr)
    Ensure emp
*/;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreCreate.c; same source revision above. */
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
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      (__return == -5 || (0 <= __return && __return < 128)) &&
      dq_semaphore_create_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
 */
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    /* Nested lock acquisition omitted: caller owns the critical region. */
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        x_free(sem);
        /* Nested unlock omitted: caller retains the critical region. */
        return -ENOMEMORY;
    }

    sem->value = val;
    InitDoubleLinkList(&sem->pend_list);

    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link);
    /* Nested unlock omitted: caller retains the critical region. */

    /* Diagnostic removed under TrustBase. */

    return id;
}
