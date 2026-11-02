From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 本case导入已审阅共享定义与Event模型ABI接口；不另增公理或占位证明。
    ABI接口只固定36字节展开模型的大小及顶层字段偏移，字节转换仍须证明。 *)
Require Import CRTOS_Verify.lib.KEventCreate CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.EventLayoutABI.
Require Import CRTOS_Verify.lib.SemaphoreInv.


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
