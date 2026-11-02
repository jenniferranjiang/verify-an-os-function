From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import CRTOS_Verify.lib.KMutexCreate CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.SemaphoreInv.
Import DLL IDNode.

From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope sac.

(** 拆出mutex模块时保留系统其他模块及跨模块一致性；创建结束后与新的
    mutex_inv重组os_inv。它只描述真实未触达资源，不断言新的调用前提。 *)
Definition mutex_create_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map)
    sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  msgqueue_inv wait sg.(os_msgqueue_stable) st.(os_msgqueues) **
  event_inv wait sg.(os_event_stable) st.(os_events) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st **
  semaphore_inv wait sg.(os_semaphore_stable) st.(os_semaphores).

Require Import Coq.micromega.Lia Coq.Strings.String.

Lemma mutex_two_zero_uchars__zero_bytes : forall p,
  CharArray.full p 2 (repeat_Z 0 2) |--
  p # UChar |-> 0 ** (p+1) # UChar |-> 0.
Proof.
  intros p. change (repeat_Z 0 2) with [0;0].
  unfold CharArray.full, store_array. cbn [store_array_rec].
  unfold StoreCharAsElement.storeA. rewrite sizeof_char.
  replace (p+0*1) with p by lia.
  replace (p+(0+1)*1) with (p+1) by lia.
  unfold store_char, store_uchar. Intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; unfold Byte.max_unsigned; intuition lia.
Qed.

Lemma mutex_zero_bytes__zero_bytes : forall p,
  0 < p -> p <= UINT_MAX - sizeof("Mutex"%string) -> addr_aligned p 4 ->
  CharArray.full p sizeof("Mutex"%string) (repeat_Z 0 sizeof("Mutex"%string)) |-- MutexZero p.
Proof.
  intros p Hpos Hbound Halign.
  assert (Hsize : sizeof("Mutex"%string) = 36) by exact mutex_size_axiom.
  rewrite Hsize.
  sep_apply (CharArray.full_split_to_full p 32 36 (repeat_Z 0 36)); try lia.
  change (sublist 0 32 (repeat_Z 0 36)) with (repeat_Z 0 32).
  change (sublist 32 36 (repeat_Z 0 36)) with (repeat_Z 0 4).
  change (36-32) with 4.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace (p+32*1) with (p+32) by lia.
  sep_apply (semaphore_zero_bytes_fields p Halign).
  sep_apply (mutex_two_zero_uchars__zero_bytes (p+14)).
  replace (p+14+1) with (p+15) by lia.
  assert (Ha32 : addr_aligned (p+32) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+32) Ha32).
  pose proof (mutex_field_offset_axiom p Halign) as Hlayout.
  destruct Hlayout as [Hid [Hidval [Hidlink [Hval [Hrec [Hprio [Hholder [Hpend [Hlink Hnodes]]]]]]]]].
  destruct (Hnodes (p+4) ltac:(simpl; auto)) as [Hnext4 Hprev4].
  destruct (Hnodes (p+20) ltac:(simpl; auto)) as [Hnext20 Hprev20].
  destruct (Hnodes (p+28) ltac:(simpl; auto)) as [Hnext28 Hprev28].
  unfold MutexZero, ZeroIdNode, NodeZero, MutexPadding.
  rewrite Hid, Hidval, Hidlink, Hval, Hrec, Hprio, Hholder, Hpend, Hlink.
  rewrite Hnext4, Hprev4, Hnext20, Hprev20, Hnext28, Hprev28.
  replace (p+4+4) with (p+8) by lia.
  replace (p+20+4) with (p+24) by lia.
  replace (p+28+4) with (p+32) by lia.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; intuition lia.
Qed.
