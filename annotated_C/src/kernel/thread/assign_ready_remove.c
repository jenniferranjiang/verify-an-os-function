// 本文件是设定assign.c的KTaskInsertToReadyVector与KTaskOsAssignRemoveKTask在临界区内被调用版本

#include "assign_ready_remove.h"
#include "task_sched_view.h"
#include "ready_cache_strategy.h"
#include "ready_views_strategy.h"
/*@ include strategies "ready_cache.strategies" */
/*@ include strategies "ready_views.strategies" */
/*@ include strategies "dll.strategies" */
/*@ include strategies "task_sched_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignCommon */
/*@ Import Coq Require Import CRTOS_Verify.libai.Bitmap */

/*@ Extern Coq (bitmap_highest_priority : Z -> Z) */

/* Functional bitmap interface; bitmap.c remains a separate Stage-2 target. */
int PrioCaculate(uint32 bitmap)
/*@ functional
    Require
      0 <= bitmap && bitmap <= UINT_MAX &&
      store_prio_lookup_table
    Ensure
      __return == bitmap_highest_priority(bitmap) &&
      store_prio_lookup_table
 */
;

/*
 * a task will be removed from ready table.
 *
 * @param task  task descriptor
 *
 * All three behaviors describe the same interrupt-free core.  Critical-section
 * protocol resources are caller frames and are intentionally absent here.
 */
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ linked_ic */
/*@ detached_ic */
/*@ external_list_ic */
{
    /* 纯成员事实在调用 DLL helper 时才转为局部切分，不暴露到公开 With。 */
    /*@ In(sched_link_node(task), Znth(desc_linked_ic.tdSchedMember.tsmCurPrio, before_linked_ic.orvBuckets, nil)) && emp
        $ linked_ic
        which implies
        exists prefix suffix,
          Znth(desc_linked_ic.tdSchedMember.tsmCurPrio, before_linked_ic.orvBuckets, nil) ==
            app(prefix, cons(sched_link_node(task), suffix)) && emp */
    /*@ Given prefix suffix $ linked_ic */

    /*@ In(sched_link_node(task), l_external_list_ic) && emp
        $ external_list_ic
        which implies
        exists external_prefix external_suffix,
          l_external_list_ic ==
            app(external_prefix, cons(sched_link_node(task), external_suffix)) && emp */
    /*@ Given external_prefix external_suffix $ external_list_ic */

    x_base lock = 0;
    x_ubase number = 0;
    x_ubase highest_priority = 0;

    NULL_PARAM_CHECK_1(task);

    /*@ sched_link_of(task) ==
          &(task->task_dync_sched_member.sched_link) by local */

    // lock = DISABLE_INTERRUPT();

    // SYS_KDEBUG_LOG(KDBG_SCHED, ("remove task[%.*s], the priority: %d\n", NAME_NUM_MAX, task->task_base_info.name, task->task_dync_sched_member.cur_prio));


    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
        /*@ where (remove_ready_member)
              head = &(Assign.os_assign_ready_vector.priority_ready_vector[desc_linked_ic.tdSchedMember.tsmCurPrio]),
              task = task,
              prefix = prefix,
              suffix = suffix
              $ linked_ic
            where (remove_self)
              node = sched_link_of(task)
              $ detached_ic
            where (remove_member)
              storeA = storeA_external_list_ic,
              head = head_external_list_ic,
              a = task,
              prefix = external_prefix,
              suffix = external_suffix;
              A = Z $ external_list_ic */;


    if (IsDoubleLinkListEmpty(&(Assign.os_assign_ready_vector.priority_ready_vector[task->task_dync_sched_member.cur_prio]))
        /*@ where (ready_dll)
              nodes = app(prefix, suffix)
              $ linked_ic
            where (ready_dll)
              nodes = Znth(
                desc_detached_ic.tdSchedMember.tsmCurPrio,
                before_detached_ic.orvBuckets, nil)
              $ detached_ic
            where (ready_dll)
              nodes = Znth(
                desc_external_list_ic.tdSchedMember.tsmCurPrio,
                before_external_list_ic.orvBuckets, nil)
              $ external_list_ic */
            ) {

        Assign.os_assign_ready_vector.priority_ready_group &=
            ~task->task_dync_sched_member.bitmap_column;
        highest_priority = PrioCaculate(Assign.os_assign_ready_vector.priority_ready_group)
            /*@ where (functional) $ linked_ic detached_ic external_list_ic */;

        Assign.os_assign_ready_vector.highest_prio = highest_priority;
    }

    // ENABLE_INTERRUPT(lock);
}
