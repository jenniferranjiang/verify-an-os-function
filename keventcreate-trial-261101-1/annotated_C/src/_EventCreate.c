#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import CRTOS_Verify.VC.EventCreate_lib */
/*@ Extern Coq
  (In : {A} -> A -> list A -> Prop)
  (event_addr : EventAbs -> addr)
  (event_context : EventStable -> Prop)
  (event_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (EventZero : addr -> Assertion)
  (EventPadding : addr -> Assertion)
  (NodeZero : addr -> Assertion)
*/

/* TrustBase primitive boundary; no implementation claim. */
void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */
;

/* TrustBase primitive boundary; no implementation claim. */
void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/
;

/* TrustBase primitive boundary; no implementation claim. */
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

/* reused-spec: root annotated_C/src/headers/id_module_spec.h. */
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

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
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

/* TrustBase primitive boundary; no implementation claim. */
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

/* TrustBase KERNEL_FREE boundary, instantiated for this complete allocation.
 * EventRaw owns every model byte; conversion to raw allocation bytes is a
 * separately recorded, unproved design obligation in EventInv. */
void x_free(void *ptr)
/*@ event_object
    Require EventRaw(ptr)
    Ensure emp
 */;

/* Source event.c::_EventCreate; static-to-slice-external normalization. */
int32 _EventCreate(uint32 options)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_event_create(sg, options), X) &&
            OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
 */
{
    /*@ 0 <= options@pre && options@pre <= 4294967295 by local */
    int32 id = 0;
    x_base lock = 0;
    struct Event *event = NONE;

    event = (struct Event *)x_malloc(sizeof(struct Event));
    if (event == NONE)
        return -ENOMEMORY;

    memset(event, 0, sizeof(struct Event));
    /*@ 0 < event && event <= 4294967295 - sizeof(struct Event) &&
        addr_aligned(event, 4) &&
        CharArray::full(event, sizeof(struct Event), repeat_Z(0, sizeof(struct Event))) *
        data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) &&
        &event->pend_list != 0 && &event->link != 0 && EventZero(event) *
        data_at(&options, unsigned int, options@pre)
    */
    lock = CriticalAreaLock()
      /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock) * EventZero(event) * data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) &&
        event_context(os_event_stable(sg)) &&
        !(In(event, map(event_addr, os_events(st_lock)))) &&
        event_create_frame(sg, st_lock) *
        store_idmanager(event_manager_stable(os_event_stable(sg)),
                        event_manager(os_events(st_lock)), &k_event_id_manager) *
        store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
                  &k_event_list, map(event_link_node, os_events(st_lock))) *
        store_idnode_insert_ready(&event->id) *
        data_at(&event->options, unsigned int, 0) *
        data_at(&event->events, unsigned int, 0) *
        NodeZero(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
        data_at(&options, unsigned int, options@pre)
    */
    id = IdInsertObj(&k_event_id_manager, &event->id)
      /*@ where sm = event_manager_stable(os_event_stable(sg)),
                m = event_manager(os_events(st_lock)) */;
    /*@ idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), id) => (0 <= id && id < 128) by local */
    if (id < 0) {
        /*@ event != 0 && addr_aligned(event, 4) &&
            &event->pend_list != 0 && &event->link != 0 &&
            safeExec(LastSeen(before), abs_event_create(sg, options@pre), X) &&
            Crtos_RTrans(before, st_lock) &&
            event_create_frame(sg, st_lock) *
            store_idmanager(event_manager_stable(os_event_stable(sg)),
                            event_manager(os_events(st_lock)), &k_event_id_manager) *
            store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
                      &k_event_list, map(event_link_node, os_events(st_lock))) *
            store_idnode_insert_ready(&event->id) *
            data_at(&event->options, unsigned int, 0) *
            data_at(&event->events, unsigned int, 0) *
            NodeZero(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
            data_at(&options, unsigned int, options@pre)
            which implies
            safeExec(LastSeen(st_lock), return(-5), X) &&
            Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock) * EventRaw(event) *
            data_at(&options, unsigned int, options@pre)
        */
        CriticalAreaUnLock(lock)
          /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        x_free(event);
        return -ENOMEMORY;
    }

    /* Preserve original unsigned 3-bit assignment after field expansion. */
    event->options = options & 7U;
    /*@ NodeZero(&event->pend_list)
        which implies
        undef_data_at(&event->pend_list.node_prev) *
        undef_data_at(&event->pend_list.node_next)
    */
    InitDoubleLinkList(&event->pend_list);
    /*@ event != 0 && addr_aligned(event, 4) && &event->link != 0 &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        data_at(&event->options, unsigned int, options@pre & 7) *
        data_at(&event->events, unsigned int, 0) *
        store_node_self_linked(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
        data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) && &event->link != 0 &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))),
                    &event->link, event_created(event, id, options@pre)) *
        occupy_dll_node(&event->link) * data_at(&options, unsigned int, options@pre)
    */

    DoubleLinkListInsertNodeAfter(&k_event_list, &event->link)
      /*@ where (dispatch_case)
          storeA = store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
          nodes = map(event_link_node, os_events(st_lock)),
          a = event_created(event, id, options@pre), head = &k_event_list; A = EventAbs */;
    /*@ event != 0 && addr_aligned(event, 4) &&
        event_context(os_event_stable(sg)) &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        !(In(event, map(event_addr, os_events(st_lock)))) &&
        safeExec(LastSeen(before), abs_event_create(sg, options@pre), X) &&
        Crtos_RTrans(before, st_lock) &&
        data_at(&options, unsigned int, options@pre) *
        event_create_frame(sg, st_lock) *
        store_idmanager(event_manager_stable(os_event_stable(sg)),
          idmanager_link(event_manager_stable(os_event_stable(sg)),
            idmanager_add(event_manager(os_events(st_lock)), id), id, &event->id),
          &k_event_id_manager) *
        store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
          &k_event_list,
          dll_insert_after_dispatch(&k_event_list, map(event_link_node, os_events(st_lock)),
            &k_event_list, Build_DL_Node(event_created(event, id, options@pre), &event->link)))
        which implies
        0 <= id && id < 128 &&
        safeExec(LastSeen(replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)),
                 return(id), X) &&
        Crtos_GTrans(st_lock, replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)) &&
        os_inv(sg, replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)) *
        data_at(&options, unsigned int, options@pre)
    */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock,
          st2 = replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock) */;

    return id;
}
