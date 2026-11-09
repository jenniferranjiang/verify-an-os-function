Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
From MonadLib.MonadErr Require Import MonadErrHoare monadesafe_lib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.common.CrtosInv.
Require Export CRTOS_Verify.lib.task.KTaskWakeup.
Require Export CRTOS_Verify.lib.event.EventOps.
Require Export CRTOS_Verify.lib.mutex.MutexOps.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreOps.
Import ListNotations MonadErr.
Import Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope monad.

(** LinklistResumeAll 的共享目标。对象的基址与登记 ID 一起标识本次仍存活
    的实例；head 只取决于基址，ID 用于排除把另一个登记对象当作同一目标。 *)
Inductive PendlistTarget : Type :=
| PendSemaphore (p id : addr)
| PendMutex (p id : addr)
| PendEvent (p id : addr).

Definition pendlist_head (target : PendlistTarget) : addr :=
  match target with
  | PendSemaphore p _ => &(p # "Semaphore" ->ₛ "pend_list")
  | PendMutex p _ => &(p # "Mutex" ->ₛ "pend_list")
  | PendEvent p _ => &(p # "Event" ->ₛ "pend_list")
  end.

(** 目标对象及其当前等待序列的纯投影；链表字节仍由各模块 invariant
    唯一拥有。三个分支只做同一通用接口的实例化。 *)
Definition pendlist_waiting (target : PendlistTarget) (st : VarGlobalState)
    (waiting : list addr) : Prop :=
  match target with
  | PendSemaphore p id => exists obj,
      In obj st.(os_semaphores) /\ obj.(semaphore_addr) = p /\
      obj.(semaphore_id) = id /\ obj.(semaphore_pending_addrs) = waiting
  | PendMutex p id => exists obj,
      In obj st.(os_mutexes) /\ obj.(mutex_addr) = p /\
      obj.(mutex_id) = id /\ obj.(mutex_pending_addrs) = waiting
  | PendEvent p id => exists obj,
      In obj st.(os_events) /\ obj.(event_addr) = p /\
      obj.(event_id) = id /\ obj.(event_pending_addrs) = waiting
  end.

Definition pendlist_nodes (target : PendlistTarget) (st : VarGlobalState)
    (nodes : list (DL_Node addr)) : Prop :=
  exists waiting, pendlist_waiting target st waiting /\
    nodes = map sched_link_node waiting.

Definition pendlist_live (target : PendlistTarget) (st : VarGlobalState) : Prop :=
  exists waiting, pendlist_waiting target st waiting.

Definition pendlist_drained (target : PendlistTarget) (st : VarGlobalState) : Prop :=
  pendlist_waiting target st nil.

Definition mutex_set_pending (p : addr) (pending : list addr)
    (mutexes : MutexState) : MutexState :=
  map (fun m => if Z.eq_dec m.(mutex_addr) p then
    {| mutex_addr := m.(mutex_addr); mutex_id := m.(mutex_id);
       mutex_value := m.(mutex_value);
       mutex_recursive_count := m.(mutex_recursive_count);
       mutex_original_priority := m.(mutex_original_priority);
       mutex_holder := m.(mutex_holder); mutex_pending_addrs := pending |}
    else m) mutexes.

(** 只清空 target 指定的一个 pending 字段；其余模块以及该对象的标量
    均来自 before/updated 的对应分量，不在模块 spec 中再复制此更新。 *)
Definition pendlist_clear (target : PendlistTarget)
    (before updated : VarGlobalState) : VarGlobalState :=
  match target with
  | PendSemaphore p _ =>
      replace_semaphores (semaphore_set_pending p nil before.(os_semaphores)) updated
  | PendMutex p _ =>
      replace_mutexes (mutex_set_pending p nil before.(os_mutexes)) updated
  | PendEvent p _ =>
      replace_events (event_set_pending p nil before.(os_events)) updated
  end.

(** 整条等待链的共同前后态关系。空链不产生写效果；非空链统一完成
    READY/-ERROR、Delay 取消、RRR 插入和目标 pending 清空。 *)
Definition linklist_resume_all_step (target : PendlistTarget)
    (nodes : list (DL_Node addr)) (before after : VarGlobalState) : Prop :=
  let waiting := map (@getData addr) nodes in
  match nodes with
  | nil => after = before
  | _ =>
      let T := before.(os_tasks).(task_desc_map) in
      NoDup waiting /\
      Forall (fun task => exists desc,
        T task = Some desc /\ desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND)
        waiting /\
      exists ready_after,
        resume_all_ready T waiting before.(os_assign).(assignReadyVector) ready_after /\
        after = pendlist_clear target before
          (replace_global_ready_vector ready_after
            (replace_global_delays (resume_all_delays T waiting before.(os_delays))
              (replace_task_desc_map (resume_all_task_map T waiting) before)))
  end.

Definition linklist_resume_all_locked (target : PendlistTarget)
    : program VarGlobalState unit :=
  {| nrm := fun before _ after => exists nodes,
       pendlist_nodes target before nodes /\
       linklist_resume_all_step target nodes before after;
     err := fun _ => False |}.

(** OC safeExec 必须保证实际取得锁时 target 仍有当前对象；这是共享 checked
    条件，不属于 Mutex/Event/Semaphore 任一模块的私有 abstract program。 *)
Definition linklist_resume_all_entry_condition (target : PendlistTarget)
    (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed -> pendlist_live target observed.

Definition abs_linklist_resume_all (target : PendlistTarget)
    : program (VarGlobalState -> Prop) unit :=
  assertS (linklist_resume_all_entry_condition target) ;;
  task_atomic_cmd (linklist_resume_all_locked target).

Lemma pendlist_assertS_safe {S A : Type} (I P : S -> Prop)
    (c : program S A) (X : A -> S -> Prop) :
  safeExec I (assertS P ;; c) X <->
  safeExec (fun s => I s /\ P s) c X.
Proof.
  unfold safeExec, safe. split.
  - intros [s [HI Hwp]].
    change (weakestpre (assertS P ;; c) X s) in Hwp.
    rewrite (wp_bind _ _ _ s), (wp_assertS _ _ s) in Hwp.
    exists s. tauto.
  - intros [s [[HI HP] Hwp]]. exists s. split; [exact HI |].
    change (weakestpre (assertS P ;; c) X s).
    rewrite (wp_bind _ _ _ s), (wp_assertS _ _ s). auto.
Qed.

(** canonical OC spec 在真实加锁前使用的 checked 分解；前半恰好建立
    pendlist_live_target 的 Require，后半保留原子操作的 continuation。 *)
Lemma linklist_resume_all_checked target before X :
  safeExec (LastSeen before) (abs_linklist_resume_all target) X ->
  linklist_resume_all_entry_condition target (Crtos_RTrans before) /\
  safeExec (LastSeen before)
    (task_atomic_cmd (linklist_resume_all_locked target)) X.
Proof.
  unfold abs_linklist_resume_all. rewrite pendlist_assertS_safe.
  unfold safeExec, safe. intros [states [[Hlast Hentry] Hwp]]. split.
  - intros observed Hobserved. apply Hentry.
    apply (proj2 (Hlast observed)). exact Hobserved.
  - exists states. auto.
Qed.

