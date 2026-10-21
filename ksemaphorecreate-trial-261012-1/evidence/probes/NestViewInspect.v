From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Logic.FunctionalExtensionality Coq.Logic.PropExtensionality.
Require Import Coq.micromega.Lia SetsClass.SetsClass.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosHeapBridge CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep CRTOS_Verify.sem.CrtosOSInv.
Import SetsNotation.
Local Open Scope Z_scope.
Local Open Scope string_scope.

Module CrtosSchedulerViews.
Import Task_C_Rules CrtosBorrowedRep.
Local Open Scope sac.

(** CriticalAreaLock/UnLock共同使用的调度资源拆分：Assign全部字段及padding，
    不含独立全局KTaskOsAssignLockNest。它直接列出原store_scheduler_view的
    非nest资源，拆分/合并等价在下文证明；不建立第二份调度状态或资源。 *)
Definition store_scheduler_assign (s : SchedulerState) : Assertion :=
  let assign := &("Assign") in
  let ready := &(assign # "Assign" ->ₛ "os_assign_ready_vector") in
  let vectors := &(ready # "OsAssignReadyVector" ->ₛ "priority_ready_vector") in
  store_array store_scheduler_queue vectors 32 s.(scheduler_ready) **
  &(ready # "OsAssignReadyVector" ->ₛ "priority_ready_group") # UInt
    |-> s.(scheduler_ready_group) **
  &(ready # "OsAssignReadyVector" ->ₛ "highest_prio") # UInt
    |-> s.(scheduler_highest_priority) **
  &(assign # "Assign" ->ₛ "os_running_task") # Ptr |-> s.(scheduler_running) **
  (EX done : addr, &(assign # "Assign" ->ₛ "ready_vector_done") # Ptr |-> done) **
  &(assign # "Assign" ->ₛ "current_priority") # UChar
    |-> s.(scheduler_current_priority) **
  CharArray.undef_full (&("Assign") + 273) 3.

Lemma store_scheduler_split_nest : forall s,
  store_scheduler_view s |--
  &("KTaskOsAssignLockNest") # UShort |-> s.(scheduler_lock_nest) **
  store_scheduler_assign s.
Proof. intros; unfold store_scheduler_view, store_scheduler_assign; entailer!; cancel. Show. Abort.


End CrtosSchedulerViews.
