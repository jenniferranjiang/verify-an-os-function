Require Import Coq.ZArith.ZArith.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.sem.CrtosOSProtocol CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocolProof CRTOS_Verify.sem.SemaphoreCritical.
Local Open Scope Z_scope.

Example task_pointer_is_32_bit : Task_C_Rules.ptr_size_Z = 4.
Proof. reflexivity. Qed.
Example os_pointer_is_32_bit : Crtos_C_Rules.ptr_size_Z = 4.
Proof. reflexivity. Qed.
Example task_little_endian_16 : Task_C_Rules.merge_short 2 1 258.
Proof. reflexivity. Qed.
Example os_little_endian_16 : Crtos_C_Rules.merge_short 2 1 258.
Proof. reflexivity. Qed.
Example task_little_endian_32 : Task_C_Rules.merge_int 4 3 2 1 16909060.
Proof. reflexivity. Qed.
Example os_little_endian_32 : Crtos_C_Rules.merge_int 4 3 2 1 16909060.
Proof. reflexivity. Qed.
Example task_big_endian_16_rejected : ~ Task_C_Rules.merge_short 0 1 1.
Proof. vm_compute; discriminate. Qed.
Example os_big_endian_16_rejected : ~ Crtos_C_Rules.merge_short 0 1 1.
Proof. vm_compute; discriminate. Qed.

Print Assumptions task_pointer_is_32_bit.
Print Assumptions os_pointer_is_32_bit.
Print Assumptions task_little_endian_16.
Print Assumptions os_little_endian_16.
Print Assumptions task_little_endian_32.
Print Assumptions os_little_endian_32.
Print Assumptions SemaphoreIRQExit_protocol_step.
Print Assumptions SemaphoreInsideCritical_borrow_for_nested_call.

Example official_record_reused : CrtosProtocolState =
  @CRTOS_Verify.framework.NestedCriticalSTS.nested_critical_state Crtos_C_STS.c_sts.
Proof. reflexivity. Qed.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Print Assumptions CrtosSchedulerViews.store_scheduler_split_nest.
Print Assumptions CrtosSchedulerViews.store_scheduler_merge_nest.
Print Assumptions OSHeap_ushort_eq.
Print Assumptions SemaphoreOSInvariant_split_nest.
Print Assumptions SemaphoreOSInvariant_merge_nest.
Print Assumptions SemaphoreCriticalFrame_with_nest.
Print Assumptions CrtosOSValid_with_nest.
Print Assumptions SemaphoreOSInvariant_merge_updated_nest.
Print Assumptions SemaphoreOSInvariant_merge_increment.
Print Assumptions SemaphoreOSInvariant_merge_decrement.
