From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 本case导入已审阅共享定义与Event模型ABI接口；不另增公理或占位证明。
    ABI接口只固定36字节展开模型的大小及顶层字段偏移，字节转换仍须证明。 *)
Require Import CRTOS_Verify.lib.KEventCreate CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.EventLayoutABI.
Require Import CRTOS_Verify.lib.SemaphoreInv.


From Coq Require Import Lia String.
From Coq Require Import Lia.
Lemma event_byte_layout__zero_layout : forall p, addr_aligned p 4 -> event_byte_layout p.
Proof.
intros p Ha.
pose proof (event_top_level_field_offset_axiom p Ha) as E.
pose proof (mutex_field_offset_axiom p Ha) as M.
unfold event_top_level_field_offset_ok in E.
unfold mutex_field_offset_ok in M.
unfold event_byte_layout.
destruct E as [E1 [E2 [E3 [E4 E5]]]].
destruct M as [_ [M1 [M2 [_ [_ [_ [_ [_ [_ Mn]]]]]]]]].
repeat split; try assumption.
all: simpl in H; destruct H as [<-|[<-|[<-|[]]]]; apply Mn; simpl; auto.
Qed.
Lemma four_zero_uint__zero_layout : forall p, addr_aligned p 4 -> (CharArray.full p 4 (repeat_Z 0 4) |-- p # UInt |-> 0)%sac.
Proof.
intros p Ha.
sep_apply_l_atomic (semaphore_four_zero_bytes_ptr p Ha).
unfold store_ptr, store_uint.
change ptr_size with 4%nat.
Intros.
split_pure_spatial.
- cancel.
- dump_pre_spatial.
unfold isvalidptr, isvalidptr_int, CommonAssertion.aligned_4, addr_aligned in *.
change ptr_size_Z with 4 in *.
change (CArch.Arch32.aligned CArch.Arch32.ptr_align p) with (p mod 4 = 0) in *.
change Integers.Int.max_unsigned with 4294967295.
tauto || lia.
Qed.
Lemma event_zero_bytes__zero_layout : forall p, 0 < p -> p <= 4294967295-36 -> addr_aligned p 4 -> (CharArray.full p 36 (repeat_Z 0 36) |-- EventZero p)%sac.
Proof.
intros p Hp Hb Ha.
sep_apply_l_atomic (CharArray.full_split_to_full p 2 36 (repeat_Z 0 36) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 2 (repeat_Z 0 36)) with (repeat_Z 0 2).
change (ListLib.Base.Positional.sublist 2 36 (repeat_Z 0 36)) with (repeat_Z 0 34).
change (36-2) with 34.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace (p+2*1) with (p+2) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+2) 2 34 (repeat_Z 0 34) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 2 (repeat_Z 0 34)) with (repeat_Z 0 2).
change (ListLib.Base.Positional.sublist 2 34 (repeat_Z 0 34)) with (repeat_Z 0 32).
change (34-2) with 32.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+2)+2*1) with (p+4) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+4) 4 32 (repeat_Z 0 32) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 32)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 32 (repeat_Z 0 32)) with (repeat_Z 0 28).
change (32-4) with 28.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+4)+4*1) with (p+8) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+8) 4 28 (repeat_Z 0 28) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 28)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 28 (repeat_Z 0 28)) with (repeat_Z 0 24).
change (28-4) with 24.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+8)+4*1) with (p+12) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+12) 4 24 (repeat_Z 0 24) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 24)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 24 (repeat_Z 0 24)) with (repeat_Z 0 20).
change (24-4) with 20.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+12)+4*1) with (p+16) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+16) 4 20 (repeat_Z 0 20) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 20)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 20 (repeat_Z 0 20)) with (repeat_Z 0 16).
change (20-4) with 16.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+16)+4*1) with (p+20) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+20) 4 16 (repeat_Z 0 16) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 16)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 16 (repeat_Z 0 16)) with (repeat_Z 0 12).
change (16-4) with 12.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+20)+4*1) with (p+24) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+24) 4 12 (repeat_Z 0 12) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 12)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 12 (repeat_Z 0 12)) with (repeat_Z 0 8).
change (12-4) with 8.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+24)+4*1) with (p+28) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+28) 4 8 (repeat_Z 0 8) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 8 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (8-4) with 4.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+28)+4*1) with (p+32) by lia.
assert (Ha2 : addr_aligned p 2).
{ unfold addr_aligned in *.
apply Z.mod_divide in Ha; [|lia].
destruct Ha as [k Hk].
apply Z.mod_divide; [lia|].
exists (2*k).
lia.
} sep_apply_l_atomic (semaphore_two_zero_bytes_ushort p Ha2).
assert (Ha4 : addr_aligned (p+4) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+4) Ha4).
assert (Ha8 : addr_aligned (p+8) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+8) Ha8).
assert (Ha12 : addr_aligned (p+12) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (four_zero_uint__zero_layout (p+12) Ha12).
assert (Ha16 : addr_aligned (p+16) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (four_zero_uint__zero_layout (p+16) Ha16).
assert (Ha20 : addr_aligned (p+20) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+20) Ha20).
assert (Ha24 : addr_aligned (p+24) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+24) Ha24).
assert (Ha28 : addr_aligned (p+28) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+28) Ha28).
assert (Ha32 : addr_aligned (p+32) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+32) Ha32).
pose proof (event_byte_layout__zero_layout p Ha) as Hl.
destruct Hl as [Hid [Hidval [Hidlink [Hopt [Hevt [Hpend [Hlink Hnodes]]]]]]].
destruct (Hnodes 4 ltac:(simpl; auto)) as [Hnext4 Hprev4].
destruct (Hnodes 20 ltac:(simpl; auto)) as [Hnext20 Hprev20].
destruct (Hnodes 28 ltac:(simpl; auto)) as [Hnext28 Hprev28].
unfold EventZero, ZeroIdNode, NodeZero, EventPadding.
rewrite Hid, Hidval, Hidlink, Hopt, Hevt, Hpend, Hlink.
rewrite Hnext4, Hprev4, Hnext20, Hprev20, Hnext28, Hprev28.
replace (p+4+4) with (p+8) by lia.
replace (p+20+4) with (p+24) by lia.
replace (p+28+4) with (p+32) by lia.
split_pure_spatial.
- cancel.
cancel (p # UShort |-> 0)%sac.
cancel ((p+4) # Ptr |-> 0)%sac.
cancel ((p+8) # Ptr |-> 0)%sac.
cancel ((p+12) # UInt |-> 0)%sac.
cancel ((p+16) # UInt |-> 0)%sac.
cancel ((p+20) # Ptr |-> 0)%sac.
cancel ((p+24) # Ptr |-> 0)%sac.
cancel ((p+28) # Ptr |-> 0)%sac.
cancel ((p+32) # Ptr |-> 0)%sac.
- split_pures; dump_pre_spatial.
all: split; assumption || lia.
Qed.
Lemma dll_event_fresh__open_event_state : forall wait es x px y py p,
  (DLL.dllseg (store_event wait) x px y py (map event_link_node es) ** EventZero p
  |-- “ ~ In p (map event_addr es) ”)%sac.
Proof.
  intros wait es. induction es as [|e es IH]; intros x px y py p.
  - simpl. dump_pre_spatial. tauto.
  - simpl map. destruct (Z.eq_dec p (event_addr e)) as [Heq|Hneq].
    + cbn [DLL.dllseg event_link_node]. Intros z.
      unfold store_event, EventZero. Intros. subst p.
      unfold store_uint. Intros. unfold event_link_node. cbn.
      match goal with |- context [store_4byte ?a (event_options e)] =>
        prop_apply_p (dup_store_4bytes a (event_options e) 0) end.
      Intros_p Hfalse. dump_pre_spatial. contradiction.
    + cbn [DLL.dllseg event_link_node]. Intros z.
      fold (DLL.dllseg (store_event wait) z x y py (map event_link_node es)).
      prop_apply_p (IH z x y py p). Intros_p Hfresh.
      dump_pre_spatial. simpl. intuition congruence.
Qed.
Lemma event_fresh__open_event_state : forall sg st p,
  (os_inv sg st ** EventZero p |-- “ ~ In p (map event_addr (os_events st)) ”)%sac.
Proof.
  intros sg st p. unfold os_inv, event_inv. Intros.
  unfold DLL.store_dll at 1. Intros h pt.
  prop_apply_p (dll_event_fresh__open_event_state
    (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_events st)
    h (event_list_head (os_event_stable sg))
    (event_list_head (os_event_stable sg)) pt p).
  Intros_p Hfresh. dump_pre_spatial. exact Hfresh.
Qed.
Lemma event_publish_world__publish_world : event_publish_world_obligation.
Proof.
  intros sg before p id options H.
  destruct H; constructor; cbn [replace_events]; try assumption.
  - unfold service_slot_wf in *; simpl.
    destruct (service_phase (os_recycle before)); try assumption.
    destruct os_wf_recycler as [d Hd]. exists d.
    destruct Hd; constructor; assumption.
  - simpl. eapply List.Forall_impl; [|eassumption].
    intros x Hx. unfold service_slot_wf in *.
    destruct (service_phase x); try assumption.
    destruct Hx as [d Hd]. exists d.
    destruct Hd; constructor; assumption.
Qed.
Lemma event_publish_manager__publish_world : event_publish_manager_obligation.
Proof.
  intros sg before p id options Hctx Hmin.
  destruct Hctx as [_ [_ [Hoff _]]].
  unfold event_manager, event_publish, IDNode.idmanager_link, IDNode.idmanager_add,
    IDNode.idmanager_insert_bucket, IDNode.idlist_add.
  cbn [idlist idbuckets]. rewrite Hoff.
  assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  cbn [map filter event_created event_id].
  remember (id mod 16) as k eqn:Hk.
  assert (Hcases : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 \/
    k = 5 \/ k = 6 \/ k = 7 \/ k = 8 \/ k = 9 \/ k = 10 \/
    k = 11 \/ k = 12 \/ k = 13 \/ k = 14 \/ k = 15) by lia.
  repeat destruct Hcases as [Hcases | Hcases]; rewrite Hcases; reflexivity.
Qed.
