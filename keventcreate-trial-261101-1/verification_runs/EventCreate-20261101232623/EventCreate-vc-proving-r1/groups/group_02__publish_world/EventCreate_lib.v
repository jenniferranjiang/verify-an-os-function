From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 本case导入已审阅共享定义与Event模型ABI接口；不另增公理或占位证明。
    ABI接口只固定36字节展开模型的大小及顶层字段偏移，字节转换仍须证明。 *)
Require Import CRTOS_Verify.lib.KEventCreate CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.EventLayoutABI.
Require Import CRTOS_Verify.lib.SemaphoreInv.

From Coq Require Import Lia.

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
