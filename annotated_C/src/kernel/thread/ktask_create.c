#include "m_id.h"
#include "m_ktask.h"
#include "kdebug_not_in_interrupt.h"
#include "ktask_init.h"
#include "ktask_create.h"
#include "task_create_strategy.h"
/*@ include strategies "task_create.strategies" */

/* Stage-2 verification: source-preserving multi-critical-section creation.
 * The two reentry proofs use the user's explicit strengthened CreateAxiom.
 * That axiom is imported only by their dedicated manual proof file.
 * Source: ../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c.
 * KERNEL_CAPABILITY is undefined in this slice's xsconfig.h.
 * Logging/hooks and the init function pointer follow 源代码处理.md;
 * the additional success-path critical section is explicitly authorized.
 */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskCreateSafeExec */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskCreateRegistry */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskCreatePublish */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskCreateMemory */
/*@ Extern Coq
      (ID_MAX_NUM : Z)
      (idbuckets_ok : Z -> Z -> list Z -> list (list IdNodeAbs) -> Prop)
      (In : {A} -> A -> list A -> Prop)
      (ktask_create_after_reserve : StableGlobalState -> Z -> list Z -> Z -> Z -> Z -> Z -> Z -> option Z ->
        program (VarGlobalState -> Prop) Z)
      (ktask_create_after_initialize : StableGlobalState -> Z -> Z -> option TaskBaseInfoAbs ->
        program (VarGlobalState -> Prop) Z)
      (ktask_create_rollback_step : StableGlobalState -> Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
      (ktask_create_register_step : StableGlobalState -> Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
      (ktask_create_publish_step : StableGlobalState -> Z -> Z -> TaskBaseInfoAbs -> VarGlobalState -> VarGlobalState -> Prop)
      (ktask_create_info_matches : list Z -> Z -> Z -> Z -> Z -> TaskBaseInfoAbs -> Prop)
      (ktask_create_debug_cont : StableGlobalState -> Z -> list Z -> Z -> Z -> Z -> Z ->
        (Z -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
      (ktask_create_after_debug : StableGlobalState -> Z -> list Z -> Z -> Z -> Z -> Z ->
        program (VarGlobalState -> Prop) Z)
      (ktask_create_after_allocate : StableGlobalState -> Z -> list Z -> Z -> Z -> Z -> Z -> Z ->
        program (VarGlobalState -> Prop) Z)
      (ktask_create_pending : StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
      (store_created_task_descriptor : Z -> Z -> TaskBaseInfoAbs ->
        TaskSchedMemberAbs -> StableGlobalState -> Assertion)
      (store_ktask_create_init_failure_private : Z -> TaskStatus -> Z -> Assertion)
      (store_ktask_create_init_frame : Z -> Assertion)
      (store_task_descriptor_free_ready : Z -> TaskStatus -> Assertion)
      (task_done_ptr : TaskStable -> Z)
 */

/* Local trusted dynamic-descriptor allocator boundary, paired with the actual
 * preceding KERNEL_MALLOC in this function. free_ready covers fields/nodes/padding;
 * allocator metadata and allocation provenance are not modeled by that predicate.
 */
void KERNEL_FREE(void *pointer)
/*@ With (status : TaskStatus)
    Require pointer != 0 && store_task_descriptor_free_ready(pointer, status)
    Ensure emp
 */;

/**
 * 
 * This function init a kernel task in dynamic way .
 *
 * @param name task name
 * @param parameter task process function
 * @param parameter task arg
 * @param stack_depth task stack size
 * @param priority task priority
 * @param tick task time slice
 * 
 * @return EOK on success; ERROR/ENOMEMORY on failure
 */

int32 KTaskCreate(const char *name,
							void (*entry)(void *parameter),
							void       *parameter,
							uint32 stack_depth,
							uint8  priority)
/*@ ktask_create_oc */
{
	struct TaskDescriptor *task = NONE;
    int32 id = 0;
    x_base lock = 0;

    /*@ safeExec(LastSeen(before),
          abs_ktask_create(sg, name, src_name, entry, parameter, stack_depth, priority), X) &&
        OutsideCritical(sg, before)
        which implies
        safeExec(LastSeen(before), abs_kdebug_not_in_interrupt,
          ktask_create_debug_cont(sg, name, src_name, entry, parameter, stack_depth, priority, X)) &&
        OutsideCritical(sg, before)
     */
	KDEBUG_NOT_IN_INTERRUPT()
      /*@ where (outside_critical) sg = sg, before = before,
          X = ktask_create_debug_cont(sg, name, src_name, entry, parameter, stack_depth, priority, X) */;
    /*@ Given after */
    /*@ safeExec(LastSeen(after), return(tt),
          ktask_create_debug_cont(sg, name, src_name, entry, parameter, stack_depth, priority, X)) &&
        OutsideCritical(sg, after)
        which implies
        safeExec(LastSeen(after),
          ktask_create_after_debug(sg, name, src_name, entry, parameter, stack_depth, priority), X) &&
        OutsideCritical(sg, after)
     */
	task = (struct TaskDescriptor *)KERNEL_MALLOC(sizeof(struct TaskDescriptor));
	if (task == NONE) {
        // KPrintf("%s %d TaskDescriptor %s malloc failed.\n",__func__,__LINE__,name);

        /*@ task == 0 && safeExec(LastSeen(after),
              ktask_create_after_debug(sg, name, src_name, entry, parameter, stack_depth, priority), X) &&
            OutsideCritical(sg, after)
            which implies
            safeExec(LastSeen(after), return(-NOMEMORY), X) &&
            ktask_create_result(sg, src_name, entry, parameter, stack_depth, priority, -NOMEMORY, after) &&
            task == 0 && name == name && OutsideCritical(sg, after)
         */
		return -ENOMEMORY;
	}
    /*@ 0 < task && task <= UINT_MAX - sizeof(struct TaskDescriptor) &&
        addr_aligned(task, ALIGN_SIZE) &&
        safeExec(LastSeen(after),
          ktask_create_after_debug(sg, name, src_name, entry, parameter, stack_depth, priority), X) &&
        OutsideCritical(sg, after)
        which implies
        safeExec(LastSeen(after),
          ktask_create_after_allocate(sg, name, src_name, entry, parameter, stack_depth, priority, task), X) &&
        OutsideCritical(sg, after)
     */
	memset(task, 0x0, sizeof(struct TaskDescriptor));

  lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = after */;
  /* QCP 的 Given 不能重复命名；局部换名保留首次 lock 的存在见证。 */
  /*@ exists first_observation,
        Crtos_RTrans(after, first_observation) &&
        InsideCritical(sg, first_observation) * os_inv(sg, first_observation)
      which implies
      exists reserve_observed,
        Crtos_RTrans(after, reserve_observed) &&
        InsideCritical(sg, reserve_observed) * os_inv(sg, reserve_observed)
   */
  /*@ Given reserve_observed */

    /* Uses the authoritative idnode-branch contract from id_module_spec.h. */
    id = IdInsertObj(&k_task_id_manager, &task->id);

    if (id < 0) {
          // KPrintf("%s %d task id malloc failed.\n",__func__,__LINE__);

          CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = reserve_observed, st2 = reserve_observed */;

          KERNEL_FREE(task);

          /*@ safeExec(LastSeen(after),
                ktask_create_after_allocate(sg, name, src_name, entry, parameter, stack_depth, priority, task), X) &&
              Crtos_RTrans(after, reserve_observed) && task != 0 && name == name && OutsideCritical(sg, reserve_observed)
              which implies
              safeExec(LastSeen(reserve_observed), return(-NOMEMORY), X) &&
              ktask_create_result(sg, src_name, entry, parameter, stack_depth, priority, -NOMEMORY, reserve_observed) &&
              task != 0 && name == name && OutsideCritical(sg, reserve_observed)
           */

          return -ENOMEMORY;
      }

    // fp (* 初始化==插入*)

    /* 新鲜性来自新节点与旧管理链的分离所有权，不能额外假定。 */
    /*@ occupy_dll_node(&(task->link)) *
        store_dll(pure_task_link_member, &xiaoshan_task_head,
          task_link_nodes(reserve_observed.os_tasks.task_ptr_list))
        which implies
        !In(task, reserve_observed.os_tasks.task_ptr_list) &&
        occupy_dll_node(&(task->link)) *
        store_dll(pure_task_link_member, &xiaoshan_task_head,
          task_link_nodes(reserve_observed.os_tasks.task_ptr_list))
     */

    DoubleLinkListInsertNodeAfter(&xiaoshan_task_head, &(task->link))
      /*@ where (dispatch_case) storeA = pure_task_link_member,
          head = &xiaoshan_task_head, nodes = task_link_nodes(reserve_observed.os_tasks.task_ptr_list),
          a = task; A = Z */;

    task->Done = &Done;

    /* 这里同时推进首次登记的抽象步骤并重建更新后共享不变量。 */
    /*@ task != 0 && task_world_wf(reserve_observed) &&
        !In(task, reserve_observed.os_tasks.task_ptr_list) &&
        idmanager_min_free_id(sg.os_task_stable.task_stable_ids,
          reserve_observed.os_tasks.task_idmanager_abs, id) &&
        Crtos_RTrans(after, reserve_observed) &&
        safeExec(LastSeen(after),
          ktask_create_after_allocate(sg, name, src_name, entry, parameter, stack_depth, priority, task), X) &&
        InsideCritical(sg, reserve_observed) *
        store_idmanager(sg.os_task_stable.task_stable_ids,
          idmanager_link(sg.os_task_stable.task_stable_ids,
            idmanager_add(reserve_observed.os_tasks.task_idmanager_abs, id), id, &(task->id)),
          &k_task_id_manager) *
        store_dll(pure_task_link_member, &xiaoshan_task_head,
          dll_insert_after_dispatch(&xiaoshan_task_head,
            task_link_nodes(reserve_observed.os_tasks.task_ptr_list), &xiaoshan_task_head,
            Build_DL_Node(task, &(task->link)))) *
        store_map(store_published_task, reserve_observed.os_tasks.task_desc_map) *
        store_task_done(task_done_ptr(sg.os_task_stable), task_done_abs(sg.os_task_stable)) *
        os_task_fields_frame(sg, reserve_observed)
        which implies
        exists registered,
        ktask_create_pending(sg, registered, task, id) &&
        ktask_create_register_step(sg, task, id, reserve_observed, registered) &&
        safeExec(LastSeen(registered),
          ktask_create_after_reserve(sg, name, src_name, entry, parameter, stack_depth, priority, task, Some(id)), X) &&
        InsideCritical(sg, reserve_observed) * os_inv(sg, registered)
     */
    /*@ Given registered */
  CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = reserve_observed, st2 = registered */;

  // `task->Done->init` changed to `_InitKTask(...)` before funct pointer supported
  /*@ emp which implies KOK == 0 && emp */
  if( _InitKTask(task, name, entry, parameter, stack_depth, priority)
      /*@ where (init_task) */ == EOK ) {
      /*@ Given info */
      /*@ task != 0 && name != 0 && entry != 0 &&
          addr_aligned(task, ALIGN_SIZE) && 0 <= id && id < ID_MAX_NUM &&
          info.tbStackStart != 0 && 0 <= priority && priority < PRIORITY_MAX &&
          assert_task_base_info_values(info, sublist(0, NAME_MAX_SIZE - 1, src_name),
            entry, parameter, stack_depth, priority) &&
          safeExec(LastSeen(registered),
            ktask_create_after_reserve(sg, name, src_name, entry, parameter, stack_depth, priority, task, Some(id)), X) &&
          OutsideCritical(sg, registered) *
          store(&(task->stack_point), kss_context_addr(info)) *
          store_task_base_info(task, info) *
          store_ktask_stack(info.tbStackStart, info.tbStackDepth,
            repeat_Z(CHAR_SHARP, kss_context_addr(info) - info.tbStackStart),
            ktask_context_regs_setup(info.tbFuncEntry, info.tbFuncParam, &KTaskQuit, SAVED_MSTATUS, OxFADEFACE)) *
          store_node_self_linked(&(task->task_dync_sched_member.sched_link)) *
          store_task_sched_member(&(task->task_dync_sched_member.sched_link),
            mkTaskSchedMemberAbs(TSK_INIT, 0, priority, 10, 10, 0)) *
          store(&(task->exstatus), int, 0) * store(&(task->Done), &Done) *
          store_ktask_create_init_frame(task)
          which implies
          name != 0 &&
          ktask_create_info_matches(src_name, entry, parameter, stack_depth, priority, info) &&
          safeExec(LastSeen(registered),
            ktask_create_after_initialize(sg, task, id, Some(info)), X) &&
          OutsideCritical(sg, registered) *
          store_created_task_descriptor(task, id, info,
            mkTaskSchedMemberAbs(TSK_INIT, 0, priority, 10, 10, 0), sg)
       */
      // HOOK(hook.task.hook_TaskCreate, (task));
      lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = registered */;
      /*@ Given st_lock */
      /* CREATE_PUBLICATION_REENTRY: the user-specified strengthened axiom is
       * applied only in this obligation and the rollback reentry obligation.
       * It is not a consequence of ordinary lock or True rely.
       * Derive unpublished from private_task_done_unpublished; publish into observed. */

      /*@ ktask_create_pending(sg, registered, task, id) &&
          Crtos_RTrans(registered, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) *
          store_created_task_descriptor(task, id, info,
            mkTaskSchedMemberAbs(TSK_INIT, 0, priority, 10, 10, 0), sg)
          which implies
          ktask_create_pending(sg, st_lock, task, id) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) *
          store_created_task_descriptor(task, id, info,
            mkTaskSchedMemberAbs(TSK_INIT, 0, priority, 10, 10, 0), sg)
       */

		 // When normal exiting, publish the local task memory predicates to os_inv.
      /*@ ktask_create_pending(sg, st_lock, task, id) &&
          ktask_create_info_matches(src_name, entry, parameter, stack_depth, priority, info) &&
          0 <= priority && priority < PRIORITY_MAX && entry != 0 &&
          Crtos_RTrans(registered, st_lock) &&
          safeExec(LastSeen(registered),
            ktask_create_after_initialize(sg, task, id, Some(info)), X) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) *
          store_created_task_descriptor(task, id, info,
            mkTaskSchedMemberAbs(TSK_INIT, 0, priority, 10, 10, 0), sg)
          which implies
          exists published,
          ktask_create_result(sg, src_name, entry, parameter, stack_depth, priority, id, published) &&
          safeExec(LastSeen(published), return(id), X) &&
          task != 0 && InsideCritical(sg, st_lock) * os_inv(sg, published)
       */
      /*@ Given published */
      CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = published */;
      return id;
  } else {
      // KPrintf("%s %d task init failed.\n",__func__,__LINE__);
      /*@ name != 0 && entry != 0 &&
          ktask_init_input_arguments_ok(entry, parameter, &KTaskQuit, stack_depth, priority) &&
          safeExec(LastSeen(registered),
            ktask_create_after_reserve(sg, name, src_name, entry, parameter, stack_depth, priority, task, Some(id)), X) &&
          OutsideCritical(sg, registered) *
          store_ktask_create_init_failure_private(task, TSK_INIT, priority)
          which implies
          name != 0 &&
          ktask_init_input_arguments_ok(entry, parameter, &KTaskQuit, stack_depth, priority) &&
          safeExec(LastSeen(registered),
            ktask_create_after_initialize(sg, task, id, None), X) &&
          OutsideCritical(sg, registered) *
          store_ktask_create_init_failure_private(task, TSK_INIT, priority)
       */
      lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = registered */;
      /*@ Given st_lock */
      /* CREATE_ROLLBACK_REENTRY: use the same user-specified strengthened axiom
       * only at this obligation. Remove the target from the current containers;
       * neither the ordinary lock Spec nor the rely relation is strengthened. */
      /*@ ktask_create_pending(sg, registered, task, id) &&
          Crtos_RTrans(registered, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * store(&(task->Done), &Done)
          which implies
          ktask_create_pending(sg, st_lock, task, id) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * store(&(task->Done), &Done)
       */
      /*@ ktask_create_pending(sg, st_lock, task, id) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
          which implies
          exists prefix suffix,
          ktask_create_pending(sg, st_lock, task, id) &&
          0 <= id && id < 65536 &&
          st_lock.os_tasks.task_ptr_list == app(prefix, cons(task, suffix)) &&
          task_world_wf(st_lock) &&
          idmanager_query(st_lock.os_tasks.task_idmanager_abs, id) == true &&
          idbuckets_ok(sg.os_task_stable.task_stable_ids.idmax,
            sg.os_task_stable.task_stable_ids.hoffset,
            st_lock.os_tasks.task_idmanager_abs.idlist,
            st_lock.os_tasks.task_idmanager_abs.idbuckets) &&
          (forall found, idmanager_contains(sg.os_task_stable.task_stable_ids,
            st_lock.os_tasks.task_idmanager_abs, id, found) => found == &(task->id)) &&
          InsideCritical(sg, st_lock) *
          store_idmanager(sg.os_task_stable.task_stable_ids, st_lock.os_tasks.task_idmanager_abs, &k_task_id_manager) *
          store_dll(pure_task_link_member, &xiaoshan_task_head,
            app(task_link_nodes(prefix), cons(Build_DL_Node(task, &(task->link)), task_link_nodes(suffix)))) *
          store_map(store_published_task, st_lock.os_tasks.task_desc_map) *
          store_task_done(task_done_ptr(sg.os_task_stable), task_done_abs(sg.os_task_stable)) *
          os_task_fields_frame(sg, st_lock)
       */
      /*@ Given prefix suffix */
        DoubleLinkListRmNode(&task->link)
          /*@ where (remove_member) storeA = pure_task_link_member,
              head = &xiaoshan_task_head, a = task,
              prefix = task_link_nodes(prefix), suffix = task_link_nodes(suffix); A = Z */;
        /*@ emp which implies true != false && emp */
        /*@ ktask_create_pending(sg, st_lock, task, id) &&
            0 <= id && id < 65536 && emp
            which implies
            ktask_create_pending(sg, st_lock, task, id) &&
            0 <= id && id < 65536 && unsigned_last_nbits(id, 16) == id && emp
         */
        IdRemoveObj(&k_task_id_manager, id) /*@ where (low_level_spec) */;
        /*@ Given idnode */
        /*@ 0 <= id && idmanager_contains(sg.os_task_stable.task_stable_ids,
              st_lock.os_tasks.task_idmanager_abs, id, idnode) &&
            (forall found, idmanager_contains(sg.os_task_stable.task_stable_ids,
              st_lock.os_tasks.task_idmanager_abs, id, found) => found == &(task->id)) && emp
            which implies
            idnode == &(task->id) && 0 <= id && emp
         */
      /*@ task != 0 && ktask_init_input_arguments_ok(entry, parameter, &KTaskQuit, stack_depth, priority) &&
          ktask_create_pending(sg, st_lock, task, id) && task_world_wf(st_lock) &&
          st_lock.os_tasks.task_ptr_list == app(prefix, cons(task, suffix)) &&
          idbuckets_ok(sg.os_task_stable.task_stable_ids.idmax,
            sg.os_task_stable.task_stable_ids.hoffset,
            st_lock.os_tasks.task_idmanager_abs.idlist,
            st_lock.os_tasks.task_idmanager_abs.idbuckets) &&
          Crtos_RTrans(registered, st_lock) &&
          safeExec(LastSeen(registered), ktask_create_after_initialize(sg, task, id, None), X) &&
          InsideCritical(sg, st_lock) *
          store_idmanager(sg.os_task_stable.task_stable_ids,
            idmanager_remove(sg.os_task_stable.task_stable_ids, st_lock.os_tasks.task_idmanager_abs, id),
            &k_task_id_manager) *
          store_dll(pure_task_link_member, &xiaoshan_task_head, app(task_link_nodes(prefix), task_link_nodes(suffix))) *
          store_map(store_published_task, st_lock.os_tasks.task_desc_map) *
          store_task_done(task_done_ptr(sg.os_task_stable), task_done_abs(sg.os_task_stable)) *
          os_task_fields_frame(sg, st_lock)
          which implies
          exists rolled_back,
          ktask_create_result(sg, src_name, entry, parameter, stack_depth, priority, -1, rolled_back) &&
          safeExec(LastSeen(rolled_back), return(-1), X) &&
          task != 0 && 0 <= id && InsideCritical(sg, st_lock) * os_inv(sg, rolled_back)
       */
      /*@ Given rolled_back */
      CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = rolled_back */;

      /*@ idnode == &(task->id) && idnode != 0 &&
          field_addr(idnode, struct IdNode, link) != 0 &&
          task != 0 && 0 <= priority &&
          store_ktask_create_init_failure_private(task, TSK_INIT, priority) *
          store_ktask_create_init_frame(task) * store(&(task->Done), &Done) *
          store_node_self_linked(&(task->link)) *
          store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
          store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
          store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link))
          which implies
          task != 0 && 0 <= priority && store_task_descriptor_free_ready(task, TSK_INIT)
       */

      KERNEL_FREE(task);
      return -ERROR;
  }
}
