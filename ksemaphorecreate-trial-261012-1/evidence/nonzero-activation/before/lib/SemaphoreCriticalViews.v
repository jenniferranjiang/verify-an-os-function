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
Proof. intros; unfold store_scheduler_view, store_scheduler_assign; Intros done; Exists done; entailer!. Qed.

Lemma store_scheduler_merge_nest : forall s,
  &("KTaskOsAssignLockNest") # UShort |-> s.(scheduler_lock_nest) **
  store_scheduler_assign s |-- store_scheduler_view s.
Proof. intros; unfold store_scheduler_view, store_scheduler_assign; Intros done; Exists done; entailer!. Qed.
End CrtosSchedulerViews.

Local Set Warnings "-notation-overridden".
Import Crtos_C_Rules.
Local Set Warnings "notation-overridden".
Local Open Scope sac.

(** Lock/UnLock读写nest期间共同保留的精确余项：task借用视图、Assign全部
    资源及完整semaphore模块。纯CrtosOSValid单独暴露，允许对新nest重建。
    此内部拆分不改变函数对外spec，也不持有nest单元或任何IRQ token。 *)
Definition SemaphoreCriticalFrame (sg : CrtosOSStable) (s : CrtosOSState) : Assertion :=
  OSHeap (CrtosBorrowedRep.store_task_semaphore_views s.(os_tasks)) **
  OSHeap (CrtosSchedulerViews.store_scheduler_assign s.(os_scheduler)) **
  OSHeap (store_semaphore sg.(os_sem_stable) s.(os_semaphores)).

(** heap bridge只搬移真实heap断言；以下局部等式把已证分离保持用于单元访问。
    字节解释保留同一内存、空token和全集协议状态，因此不会转换IRQ权限。 *)
Local Lemma OSHeap_sep_eq : forall P Q,
  OSHeap (Task_C_Rules.sepcon P Q) = OSHeap P ** OSHeap Q.
Proof.
  intros; apply functional_extensionality; intro m.
  apply propositional_extensionality; apply crtos_heap_lift_sep.
Qed.

Local Lemma OSHeap_pure_and_eq : forall P Q,
  OSHeap (Task_C_Rules.andp (Task_C_Rules.coq_prop P) Q) = “ P ” && OSHeap Q.
Proof.
  intros; apply functional_extensionality; intro m.
  apply propositional_extensionality.
  unfold OSHeap, crtos_heap_lift, Task_C_Rules.andp, Task_C_Rules.coq_prop,
    andp, coq_prop; tauto.
Qed.

Local Lemma OSHeap_exp_eq : forall A (P : A -> Task_C_Rules.expr),
  OSHeap (Task_C_Rules.exp P) = EX x : A, OSHeap (P x).
Proof.
  intros; apply functional_extensionality; intro m.
  apply propositional_extensionality.
  unfold OSHeap, crtos_heap_lift, Task_C_Rules.exp, exp.
  split.
  - intros [Ht [Hs [x HP]]]. exists x; tauto.
  - intros [x [Ht [Hs HP]]]. split; [exact Ht|]. split; [exact Hs|].
    exists x; exact HP.
Qed.

Local Lemma OSHeap_byte_eq : forall p v,
  OSHeap (Task_C_Rules.store_byte p v) = store_byte p v.
Proof.
  intros; apply functional_extensionality; intro m.
  apply propositional_extensionality.
  unfold OSHeap, crtos_heap_lift, Task_C_Rules.store_byte, Task_C_Rules.mstore,
    store_byte, mstore, crtos_heap_state; simpl.
  split.
  - intros [Ht [Hs [w [Hv [Hm _]]]]]. exists w; tauto.
  - intros [w [Hv [Hm [Hs Ht]]]]. split; [exact Ht|]. split; [exact Hs|].
    exists w; split; [exact Hv|]. split; [exact Hm|].
    split; intro x; reflexivity.
Qed.

Local Lemma OSHeap_entails : forall P Q,
  Task_C_Rules.derivable1 P Q -> OSHeap P |-- OSHeap Q.
Proof. intros P Q H; exact (crtos_heap_lift_entails Crtos_STS.sts P Q H). Qed.

(** 根库UShort和当前OS载体UShort是同一两字节单元，保留地址有效性、
    16位值范围和当前已加载库的字节关系，不把已拥有单元当作纯事实。 *)
Lemma OSHeap_ushort_eq : forall p v,
  OSHeap (Task_C_Rules.store_ushort p v) = p # UShort |-> v.
Proof.
  intros; unfold Task_C_Rules.store_ushort, store_ushort.
  rewrite OSHeap_pure_and_eq.
  f_equal.
  unfold Task_C_Rules.store_2byte, store_2byte.
  rewrite OSHeap_exp_eq; f_equal.
  apply functional_extensionality; intro z1.
  rewrite OSHeap_exp_eq; f_equal.
  apply functional_extensionality; intro z2.
  rewrite OSHeap_pure_and_eq, OSHeap_sep_eq, !OSHeap_byte_eq.
  reflexivity.
Qed.

Lemma SemaphoreOSInvariant_split_nest : forall sg s,
  SemaphoreOSInvariant sg s |--
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> s.(os_scheduler).(scheduler_lock_nest) **
  SemaphoreCriticalFrame sg s.
Proof.
  intros; unfold SemaphoreOSInvariant, SemaphoreCriticalFrame; Intros.
  sep_apply (OSHeap_entails _ _
    (CrtosSchedulerViews.store_scheduler_split_nest s.(os_scheduler))).
  rewrite OSHeap_sep_eq, OSHeap_ushort_eq; entailer!.
Qed.

Lemma SemaphoreOSInvariant_merge_nest : forall sg s,
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> s.(os_scheduler).(scheduler_lock_nest) **
  SemaphoreCriticalFrame sg s |-- SemaphoreOSInvariant sg s.
Proof.
  intros; unfold SemaphoreOSInvariant, SemaphoreCriticalFrame; Intros.
  pose proof (OSHeap_entails _ _
    (CrtosSchedulerViews.store_scheduler_merge_nest s.(os_scheduler))) as Hmerge.
  rewrite OSHeap_sep_eq, OSHeap_ushort_eq in Hmerge.
  sep_apply Hmerge; entailer!.
Qed.

(** 非nest余项仅依赖未改的字段；两临界函数的计数写入不会改变这些资源。 *)
Lemma SemaphoreCriticalFrame_with_nest : forall sg s n,
  SemaphoreCriticalFrame sg
    (os_with_scheduler (scheduler_with_nest n s.(os_scheduler)) s) =
  SemaphoreCriticalFrame sg s.
Proof. intros; reflexivity. Qed.

(** CrtosOSValid中只有uint16范围涉及nest；任务身份、pending/ready关系和
    所有调度字段约束在仅修改nest时原样保留。 *)
Lemma CrtosOSValid_with_nest : forall s n,
  CrtosOSValid s -> 0 <= n <= 65535 ->
  CrtosOSValid (os_with_scheduler (scheduler_with_nest n s.(os_scheduler)) s).
Proof.
  intros s n [Hsem [Htask [Hnest Hrest]]] Hnew.
  unfold CrtosOSValid, os_with_scheduler, scheduler_with_nest; cbn.
  split; [exact Hsem|]. split; [exact Htask|]. split; assumption.
Qed.

(** 写后仍持有实际UShort单元及原余项时，按新的16位计数重建唯一invariant。
    旧有效性是拆分时留下的纯事实；本lemma不会凭纯状态参数制造heap。 *)
Lemma SemaphoreOSInvariant_merge_updated_nest : forall sg s n,
  0 <= n <= 65535 ->
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> n ** SemaphoreCriticalFrame sg s |--
  SemaphoreOSInvariant sg
    (os_with_scheduler (scheduler_with_nest n s.(os_scheduler)) s).
Proof.
  intros sg s n Hrange. Intros.
  pose proof (CrtosOSValid_with_nest s n H Hrange) as Hvalid.
  rewrite <- (SemaphoreCriticalFrame_with_nest sg s n).
  eapply derivable1_trans.
  2: apply (SemaphoreOSInvariant_merge_nest sg
    (os_with_scheduler (scheduler_with_nest n s.(os_scheduler)) s)).
  entailer!.
Qed.

(** CriticalAreaLock的++对应原已批准入口域内的n+1；65534可写到65535，
    没有把内部65535状态排除。原16位模运算和这里实际写值相等。 *)
Lemma SemaphoreOSInvariant_merge_increment : forall sg s,
  s.(os_scheduler).(scheduler_lock_nest) < 65535 ->
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> (s.(os_scheduler).(scheduler_lock_nest) + 1) **
  SemaphoreCriticalFrame sg s |-- SemaphoreOSInvariant sg (semaphore_nest_increment s).
Proof.
  intros sg s Hbound. Intros.
  assert (Hnest : 0 <= s.(os_scheduler).(scheduler_lock_nest) <= 65535).
  { destruct H as [_ [_ [Hnest _]]]; exact Hnest. }
  unfold semaphore_nest_increment.
  rewrite Z.mod_small by lia.
  eapply derivable1_trans.
  2: apply (SemaphoreOSInvariant_merge_updated_nest sg s
    (s.(os_scheduler).(scheduler_lock_nest) + 1)); lia.
  entailer!.
Qed.

(** CriticalAreaUnLock在nest>=1时实际写n-1；nest=0分支没有写，均可由
    饱和定义重组。此接口不要求正nest，因而明确包含0时不减的源码路径。 *)
Lemma SemaphoreOSInvariant_merge_decrement : forall sg s,
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |->
    (Z.max 0 (s.(os_scheduler).(scheduler_lock_nest) - 1)) **
  SemaphoreCriticalFrame sg s |-- SemaphoreOSInvariant sg (semaphore_nest_decrement s).
Proof.
  intros sg s. Intros.
  assert (Hnest : 0 <= s.(os_scheduler).(scheduler_lock_nest) <= 65535).
  { destruct H as [_ [_ [Hnest _]]]; exact Hnest. }
  unfold semaphore_nest_decrement.
  eapply derivable1_trans.
  2: apply (SemaphoreOSInvariant_merge_updated_nest sg s
    (Z.max 0 (s.(os_scheduler).(scheduler_lock_nest) - 1))); lia.
  entailer!.
Qed.
