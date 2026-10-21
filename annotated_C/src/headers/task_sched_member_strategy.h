#ifndef CRTOS_TASK_SCHED_MEMBER_STRATEGY_H
#define CRTOS_TASK_SCHED_MEMBER_STRATEGY_H

#include "xsconfig.h"
#include "xs_base.h"
#include "m_ktask.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSchedMemberStrategy */
/*@ Extern Coq
      (has_permission_task_sched_member : Z -> TaskStatus -> Assertion)
      (has_permission_task_sched_scalars : Z -> TaskStatus -> Assertion)
      (store_assign_insert_sched_except_stat :
        Z -> TaskSchedMemberAbs -> Assertion)
 */
/*@ include strategies "task_sched_member.strategies" */

#endif
