#ifndef CRTOS_DELAY_VIEWS_STRATEGY_H
#define CRTOS_DELAY_VIEWS_STRATEGY_H
#include "ktask_unset_delay.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelayTaskFrame */
/*@ Extern Coq
      (ktask_set_delay_task_frame :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 */
/*@ include strategies "delay_views.strategies" */
#endif
