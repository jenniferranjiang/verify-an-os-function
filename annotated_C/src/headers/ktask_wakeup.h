#ifndef CRTOS_VERIFY_KTASK_WAKEUP_H
#define CRTOS_VERIFY_KTASK_WAKEUP_H

#include "m_assign.h"
#include "m_double_linklist.h"
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Extern Coq
 (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 (ktask_wakeup_step : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop)
 (ktask_wakeup_detached_null_step : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (semaphore_pending_nodes : Z -> VarGlobalState -> list(DL_Node Z) -> Prop)
 (wakeup_semaphore_head : Z -> Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 */

/* 锁内 ID 包装层；保持通用接口，查询失败路径不承诺正常返回。 */
x_err_t KTaskWakeup(int32 id)
/*@ wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
        ktask_wakeup_step(task, desc, before, after))) && os_inv(sg, after)
 */;

/* 只限制实际 ID 查询结果。SUSPEND 时自持、Delay 为 NULL；非 SUSPEND
 * 仍按原实现返回 -ERROR。自持节点由 os_inv 管理，不另行重复提供。 */
x_err_t KTaskWakeup(int32 id)
/*@ detached_sched_null_delay <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && ktask_wakeup_detached_null_condition(sg, before, id) &&
      os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) && desc.tdDelay == 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
          ktask_wakeup_detached_null_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */;

/* 已知队首的派生接口；上游状态精化引理位于 KTaskWakeupProof，本地作为导入契约使用。
 * ID 关联由读取队首 task->id.id 建立，不能仅凭 id 数值猜测 task。
 * 队首 SUSPEND/发布/唯一归属由 os_inv 推出，不重复列为调用者前提。
 * KTaskWakeup 自身保持 task->exstatus；调用前的字段写入属于调用者。 */
x_err_t KTaskWakeup(int32 id)
/*@ semaphore_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (sem task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      semaphore_pending_nodes(sem, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_semaphore_head(sem, task, desc, before, after) &&
      semaphore_pending_nodes(sem, after, rest) && os_inv(sg, after)
 */;

#endif
