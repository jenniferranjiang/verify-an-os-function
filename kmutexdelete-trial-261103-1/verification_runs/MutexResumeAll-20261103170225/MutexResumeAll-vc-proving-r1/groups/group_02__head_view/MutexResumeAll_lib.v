From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete.
Local Open Scope string.
Local Open Scope sac.

(** 等待哨兵next的借出/归还资源：wand不能被当成可复制的纯事实。 *)
Definition mutex_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写exstatus后恢复新的task-map索引全局资源；构造此wand必须证明关联保持。 *)
Definition mutex_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** 任务ID只读字段，原值归还后重新得到完整os_inv，供Wakeup调用。 *)
Definition mutex_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列完成后的整体结果仍是原drain临界区的批量效果。
    复用已审阅逐步关系，不另定义一套执行链；初始化/保持均是显式VC义务。 *)
Definition mutex_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    mutex_resume_all_steps p remaining current final ->
    mutex_resume_all_effect p waiting before final.

Lemma dllseg_payload__head_view : forall {A} (P:addr -> A -> Assertion) l n x px y py,
 In n l -> DLL.dllseg P x px y py l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.dllseg P x px y py l).
Proof.
 intros A P l. induction l as [|a l IH]; intros n x px y py Hin; [contradiction|].
 simpl in Hin. simpl DLL.dllseg. Intros z. subst x.
 destruct Hin as [Heq|Hin].
 - subst a. cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
 - sep_apply_l_atomic (IH n z (getPtr a) y py Hin).
   cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P z (getPtr a) y py l)).
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
Qed.
Lemma dll_payload__head_view : forall {A} (P:addr -> A -> Assertion) l n head,
 In n l -> DLL.store_dll P head l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.store_dll P head l).
Proof.
 intros A P l n head Hin. unfold DLL.store_dll at 1. Intros h pt.
 sep_apply_l_atomic (dllseg_payload__head_view P l n h head head pt Hin).
 cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
 sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P h head head pt l)).
 unfold DLL.store_dll. Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; tauto].
Qed.
Lemma pending_borrow__head_view : forall sg st sem nodes,
 mutex_pending_nodes sem st nodes ->
 os_inv sg st |-- DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes **
 (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes -* os_inv sg st).
Proof.
 intros sg st sem nodes [obj [Hin [Haddr Hnodes]]].
 unfold os_inv at 1. Intros.
 unfold mutex_inv at 1. Intros.
 sep_apply_l_atomic (dll_payload__head_view (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) (map mutex_link_node st.(os_mutexes)) (mutex_link_node obj) sg.(os_mutex_stable).(mutex_list_head) (in_map mutex_link_node _ _ Hin)).
 cbn [mutex_link_node getPtr getData].
 unfold store_mutex at 1. Intros.
 change (map mutex_wait_node (mutex_pending_addrs obj)) with (map sched_link_node (mutex_pending_addrs obj)).
 rewrite Hnodes, Haddr.
 change (&(sem # "Mutex" ->ₛ "pend_list")) with (mutex_pending_head sem).
 cancel (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes).
 apply_sepcon_adjoint.
 unfold os_inv, mutex_inv. split_pure_spatial.
 - sepcon_right_assoc. sep_apply_r_atomic (derivable1_wand_elim1 (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Mutex" ->ₛ "link")) obj) (DLL.store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes)))).
   cancel (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Mutex" ->ₛ "link")) obj -* DLL.store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes))).
   unfold store_mutex. rewrite Haddr. change (map mutex_wait_node (mutex_pending_addrs obj)) with (map sched_link_node (mutex_pending_addrs obj)). rewrite Hnodes.
   unfold mutex_pending_head. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; rewrite <- Haddr; tauto].
 - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma pending_desc__head_view : forall sg st sem target rest,
 mutex_pending_nodes sem st (sched_link_node target :: rest) ->
 os_inv sg st |-- “ exists desc, task_desc_map (os_tasks st) target = Some desc /\ tsmStat (tdSchedMember desc) = TSK_SUSPEND ”.
Proof.
 intros sg st sem target rest Hpending.
 sep_apply_l_atomic (pending_borrow__head_view sg st sem (sched_link_node target :: rest) Hpending).
 unfold DLL.store_dll at 1. Intros h pt.
 cbn [DLL.dllseg sched_link_node getPtr getData]. Intros z. subst h.
 unfold pure_suspend_sched_link, pure_published_slink. Intros desc.
 dump_pre_spatial. exists desc. tauto.
Qed.
Lemma task_alignment__head_view : forall sg st task desc,
 task_desc_map (os_tasks st) task = Some desc ->
 os_inv sg st |-- “ addr_aligned task ALIGN_SIZE ”.
Proof.
 intros sg st task desc Hlookup. unfold os_inv, task_inv. Intros.
 dump_pre_spatial. eapply task_wf_aligned; eauto.
Qed.
