#ifndef CRTOS_SEMAPHORE_RUNTIME_LOGIC_H
#define CRTOS_SEMAPHORE_RUNTIME_LOGIC_H
#include "semaphore_delete_logic.h"
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon */
/*@ Extern Coq
(abs_semaphore_abandon : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
(semaphore_resume_head_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain */
/*@ Extern Coq
(abs_semaphore_obtain : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
(tick_from_time_ms : Z -> Z)
(linklist_suspend_prio : Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
(linklist_suspend_admissible : Z -> Z -> VarGlobalState -> Prop)
(ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
(linklist_suspend_step : Z -> Z -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
(delay_list_window : Z -> list(DL_Node TaskDelayAbs) -> Prop)
(KTICK_HALF_RANGE : Z)
(tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
(ktask_set_delay_step : Z -> TaskDescriptorAbs -> Z -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
*/
#endif
