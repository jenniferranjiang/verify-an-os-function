From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KSemaphoreDelete.
Local Open Scope string.
Local Open Scope sac.

(** 借出等待哨兵 next 槽后的空间归还条件。调用者还回读出的原值时，
    恢复同一状态的 os_inv；此 wand 本身不重复拥有该槽。 *)
Definition resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 借出 exstatus 写槽后的归还条件；st 是写入后应重建的状态，value 是
    写入后的值。构造这个 wand 的 VC 必须证明所有 task-map 关联重索引。 *)
Definition resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** ID 只读槽的归还条件。先读取调用参数再交回该槽，避免在调用 Wakeup
    时同时声称完整 os_inv 与独立 ID 字段的重复所有权。 *)
Definition resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列的完成条件：从当前状态完成 remaining 的任意合法逐步唤醒，
    均应得到原 waiting 相对 before 的整体效果。仅封装原循环不变量中的
    高阶量化语句，不增加前提或改变函数输出关系。 *)
Definition resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    semaphore_resume_all_steps p remaining current final ->
    semaphore_resume_all_effect p waiting before final.

Lemma dllseg_payload__pending_head : forall {A} (P:addr -> A -> Assertion) l n x px y py,
 In n l -> dllseg P x px y py l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* dllseg P x px y py l).
Proof.
 intros A P l. induction l as [|a l IH]; intros n x px y py Hin; [contradiction|].
 simpl in Hin. simpl dllseg. Intros z. subst x.
 destruct Hin as [Heq|Hin].
 - subst a. cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
 - sep_apply_l_atomic (IH n z (getPtr a) y py Hin).
   cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (dllseg P z (getPtr a) y py l)).
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
Qed.
Lemma dll_payload__pending_head : forall {A} (P:addr -> A -> Assertion) l n head,
 In n l -> store_dll P head l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* store_dll P head l).
Proof.
 intros A P l n head Hin. unfold store_dll at 1. Intros h pt.
 sep_apply_l_atomic (dllseg_payload__pending_head P l n h head head pt Hin).
 cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
 sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (dllseg P h head head pt l)).
 unfold store_dll. Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; tauto].
Qed.

Lemma pending_borrow__pending_head : forall sg st sem nodes,
 semaphore_pending_nodes sem st nodes ->
 os_inv sg st |-- store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes **
 (store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes -* os_inv sg st).
Proof.
 intros sg st sem nodes [obj [Hin [Haddr Hnodes]]].
 unfold os_inv at 1. Intros.
 unfold semaphore_inv at 1. Intros.
 sep_apply_l_atomic (dll_payload__pending_head (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) (map semaphore_link_node st.(os_semaphores)) (semaphore_link_node obj) sg.(os_semaphore_stable).(semaphore_list_head) (in_map semaphore_link_node _ _ Hin)).
 cbn [semaphore_link_node getPtr getData].
 unfold store_semaphore at 1. Intros.
 change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
 rewrite Hnodes, Haddr.
 change (&(sem # "Semaphore" ->ₛ "pend_list")) with (semaphore_pending_head sem).
 cancel (store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes).
 apply_sepcon_adjoint.
 unfold os_inv, semaphore_inv. split_pure_spatial.
 - sep_apply_r_atomic (derivable1_wand_elim1 (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Semaphore" ->ₛ "link")) obj) (store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_semaphore_stable).(semaphore_list_head) (map semaphore_link_node st.(os_semaphores)))).
   cancel (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Semaphore" ->ₛ "link")) obj -* store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_semaphore_stable).(semaphore_list_head) (map semaphore_link_node st.(os_semaphores))).
   unfold store_semaphore. rewrite Haddr. change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)). rewrite Hnodes.
   unfold semaphore_pending_head. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; rewrite <- Haddr; tauto].
 - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma pending_desc__pending_head : forall sg st sem target rest,
 semaphore_pending_nodes sem st (sched_link_node target :: rest) ->
 os_inv sg st |-- “ exists desc, task_desc_map (os_tasks st) target = Some desc /\ tsmStat (tdSchedMember desc) = TSK_SUSPEND ”.
Proof.
 intros sg st sem target rest Hpending.
 sep_apply_l_atomic (pending_borrow__pending_head sg st sem (sched_link_node target :: rest) Hpending).
 unfold store_dll at 1. Intros h pt.
 cbn [dllseg sched_link_node getPtr getData]. Intros z. subst h.
 unfold pure_suspend_sched_link, pure_published_slink. Intros desc.
 dump_pre_spatial. exists desc. tauto.
Qed.

Lemma task_alignment__pending_head : forall sg st task desc,
 task_desc_map (os_tasks st) task = Some desc ->
 os_inv sg st |-- “ addr_aligned task ALIGN_SIZE ”.
Proof.
 intros sg st task desc Hlookup. unfold os_inv, task_inv. Intros.
 dump_pre_spatial. eapply task_wf_aligned; eauto.
Qed.
