From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete.
Import ListNotations DLL IDNode MonadErr.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 循环借出等待哨兵next单元后，归还同值即可恢复同一个os_inv。
    此wand是空间资源，不是额外可信事实；拆出义务由which implies生成。 *)
Definition event_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写入exstatus后的归还视图，st已经是只更新该描述符exstatus的新状态。 *)
Definition event_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** task ID只读；归还同值恢复当前os_inv以满足通用KTaskWakeup合同。 *)
Definition event_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 已处理前缀的数学进度：完成当前剩余队列的整体效果，足以完成原waiting
    的整体效果。不重定义逐步唤醒或公共批量语义，不包含堆所有权。 *)
Definition event_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall after,
    event_resume_all_effect p remaining current after ->
    event_resume_all_effect p waiting before after.

Lemma dllseg_payload_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (x px y py : addr) (l1 l2 : list (DL_Node A)) (e : DL_Node A), dllseg storeA x px y py (l1 ++ e :: l2) |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* dllseg storeA x px y py (l1 ++ e :: l2)).
Proof.
intros.
pose proof (dllseg_split storeA x px y py l1 (e::l2)) as Hsplit.
rewrite Hsplit at 1.
clear Hsplit.
Intros q pq.
simpl dllseg at 2.
Intros z.
subst q.
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
sep_apply_r_atomic (dllseg_concat storeA x px e.(ptr) pq y py l1 (e::l2)).
simpl dllseg at 4.
Exists z.
split_pure_spatial.
- cancel.
cancel (storeA e.(ptr) e.(data)).
cancel (dllseg storeA x px e.(ptr) pq l1).
cancel (dllseg storeA z e.(ptr) y py l2).
match goal with |- ?P ** _ |-- _ => cancel P end.
match goal with |- ?P |-- _ => cancel P end.
- dump_pre_spatial.
reflexivity.
Qed.
Lemma dll_payload_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (head : addr) (l : list (DL_Node A)) (e : DL_Node A), In e l -> store_dll storeA head l |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* store_dll storeA head l).
Proof.
intros A storeA head l e Hin.
apply in_split in Hin.
destruct Hin as [l1 [l2 Hl]].
subst l.
unfold store_dll at 1.
Intros h pt.
sep_apply_l_atomic (dllseg_payload_borrow__pending_head_access A storeA h head head pt l1 l2 e).
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim1 (storeA e.(ptr) e.(data)) (dllseg storeA h head head pt (l1 ++ e :: l2))).
unfold store_dll.
Exists h pt.
split_pure_spatial.
- repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
- dump_pre_spatial.
auto.
Qed.
Lemma dll_head_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (head : addr) (l : list (DL_Node A)), store_dll storeA head l |-- EX next, “ (match l with nil => next = head | a :: _ => next = a.(ptr) /\ next <> head end) ” && (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) ** ((&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* store_dll storeA head l).
Proof.
intros.
unfold store_dll at 1.
Intros h pt.
destruct l as [|a l].
- simpl dllseg at 1.
Intros.
destruct H0.
subst h pt.
Exists head.
split_pure_spatial.
+ cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head).
apply_sepcon_adjoint.
unfold store_dll.
Exists head head.
simpl dllseg.
split_pure_spatial.
* sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
* split_pures; dump_pre_spatial; tauto.
+ dump_pre_spatial.
reflexivity.
- simpl dllseg at 1.
Intros z.
subst h.
destruct (Z.eq_dec a.(ptr) head) as [Heq|Hneq].
+ rewrite Heq.
sep_apply_l_atomic (dup_store_ptr (&(head # "SysDoubleLinklistNode" ->ₛ "node_next")) z head).
Intros.
contradiction.
+ Exists a.(ptr).
split_pure_spatial.
* match goal with |- _ |-- ?P ** _ => cancel P end.
apply_sepcon_adjoint.
unfold store_dll.
Exists a.(ptr) pt.
simpl dllseg.
Exists z.
split_pure_spatial.
-- sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
-- split_pures; dump_pre_spatial; tauto.
* dump_pre_spatial.
auto.
Qed.
Lemma pending_head_borrow__pending_head_access : forall id p remaining sg st head, head = event_pending_head p -> event_pending_at id p remaining st -> os_inv sg st |-- EX next, “ (match remaining with nil => next = head | first :: _ => next = sched_link_of first /\ next <> head end) ” && (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) ** event_resume_next_restore sg st head next.
Proof.
intros id p remaining sg st head Hhead [e [Hin [Haddr [Hid Hremaining]]]].
unfold os_inv at 1.
cbv zeta.
Intros.
unfold event_inv at 1.
Intros.
pose proof (in_map event_link_node (os_events st) e Hin) as Hmember.
sep_apply_l_atomic (dll_payload_borrow__pending_head_access EventAbs (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st)))) (event_list_head (os_event_stable sg)) (map event_link_node (os_events st)) (event_link_node e) Hmember).
cbn [event_link_node getPtr getData].
unfold store_event at 1.
cbv zeta.
Intros.
subst p remaining.
unfold event_pending_head in Hhead.
rewrite <- Hhead.
sep_apply_l_atomic (dll_head_borrow__pending_head_access addr (pure_suspend_sched_link (task_desc_map (os_tasks st))) head (map event_wait_node (event_pending_addrs e))).
Intros next.
Exists next.
split_pure_spatial.
- cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next).
unfold event_resume_next_restore.
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim1 (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) head (map event_wait_node (event_pending_addrs e)))).
unfold os_inv, event_inv.
cbv zeta.
split_pure_spatial.
+ sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P end.
sep_apply_r_atomic (derivable1_wand_elim1 (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st))) (getPtr (event_link_node e)) e) (store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st)))) (event_list_head (os_event_stable sg)) (map event_link_node (os_events st)))).
cbn [event_link_node getPtr].
match goal with |- _ |-- ?P ** _ => cancel P end.
unfold store_event.
cbv zeta.
rewrite <- Hhead.
split_pure_spatial.
* sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
* dump_pre_spatial.
exact H1.
+ split_pures; dump_pre_spatial; assumption.
- dump_pre_spatial.
destruct (event_pending_addrs e); exact H2.
Qed.
