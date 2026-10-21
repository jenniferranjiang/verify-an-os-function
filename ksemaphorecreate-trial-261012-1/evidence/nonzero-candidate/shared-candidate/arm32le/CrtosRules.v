Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Relations.Relation_Operators.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.
Require Export CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.CrtosGlobState.
Require Export CRTOS_Verify.lib.TaskProtocolSTS.

Import ListNotations.

Local Open Scope Z_scope.

Local Open Scope sets.
Local Open Scope string.

(**
  [C_STS_Task] 把 [TaskProtocolSTS] 的 owner-sensitive STS 接到本项目唯一
  的并发 assertion carrier。旧版 [CriticalSTS] 只有一枚 [unit] token，且
  rely/guarantee 共用同一关系，无法区分创建者与环境，故不再使用。
*)
Module C_STS_Task <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS := tmp_task_protocol_STS.
End C_STS_Task.

(**
  [Task_C_Rules] 是 KTaskCreate 共享资源唯一使用的并发断言模型。
  它实现 [C_ASSERTION_RULES]，因此可直接实例化 shared 中的通用
  DLL 和 ID manager 谓词。
*)

Module Task_C_Rules.
  Include C_STS_Task.
  Include ConAssertion.CSL.
  Include DerivedPredSig Arch32 LittleEndian.
  Include StoreLibSig Arch32 LittleEndian.
  Include ArrayLibSig Arch32 LittleEndian.
  Include MapLibSig Arch32 LittleEndian.
  Include StringLibSig Arch32 LittleEndian.
End Task_C_Rules.

Export Task_C_Rules.

Local Open Scope sac.

Definition ID_MAX_NUM : Z := 128.
Definition BUCKET_NUM : Z := 16.

(**
  [task_stable_context_ok sg] 将 [StableGlobalState] 中的每个稳定字段
  绑定到当前 CRTOS 配置对应的 C 全局符号或固定初始化值。

  具体对应关系如下：

  - [task_idmanager_ptr] 对应 [k_task_id_manager]；
  - [task_list_head] 对应 [xiaoshan_task_head]；
  - [task_done_ptr] 对应静态函数表 [Done]；
  - ID manager 的固定配置为 [ID_NUM_MAX = 128]、桶数 [16]，其两个
    指针分别指向位图数组和哈希桶数组；
  - [task_done_abs] 的八个函数地址对应 [Done] 的静态初始化器。

  该命题只约束纯逻辑记录，不提供任何 C 内存读写权限。实际可变共享
  内存仍由 [crtos_inv] 描述；[Done] 表的线性内存权限仍由
  [store_task_done] 单独描述。
*)
Definition TaskStableContext (sg : StableGlobalState) : Prop :=
  sg.(task_idmanager_ptr) = &("k_task_id_manager") /\
  sg.(task_list_head) = &("xiaoshan_task_head") /\
  sg.(task_done_ptr) = &("Done") /\
  (sg.(stable_idmanager_abs)).(idmax) = ID_MAX_NUM /\
  (sg.(stable_idmanager_abs)).(hoffset) = BUCKET_NUM /\
  (sg.(stable_idmanager_abs)).(id_map) = &("__id_map_k_task_id_manager") /\
  (sg.(stable_idmanager_abs)).(htable) = &("__htable_k_task_id_manager") /\
  (sg.(task_done_abs)).(task_done_init) = &("_InitKTask") /\
  (sg.(task_done_abs)).(task_done_start) = &("_StartupKTask") /\
  (sg.(task_done_abs)).(task_done_delete) = &("_DeleteKTask") /\
  (sg.(task_done_abs)).(task_done_delay) = &("_DelayKTask") /\
  (sg.(task_done_abs)).(task_done_mdelay) = &("_MdelayKTask") /\
  (sg.(task_done_abs)).(task_done_prioset) = &("_KTaskPrioSet") /\
  (sg.(task_done_abs)).(task_done_suspend) = &("_SuspendKTask") /\
  (sg.(task_done_abs)).(task_done_wake) = &("_KTaskWakeup").


(**
  [store_task_done sg done] 拥有静态 [struct KTaskDone Done] 的八个
  函数指针字段。

  该谓词是普通线性内存权限，应在 KTaskCreate 的前后条件中原样
  传递，使解锁后的 [task->Done->init] 读取合法。它不允许重复复制；
  若以后证明多个线程无锁并发读取同一函数表，需要另行引入 QCP
  已证明的只读/分数权限机制，不能简单写两份 [store_task_done]。
*)
Definition store_task_done
    (sg : StableGlobalState)
    (done : TaskDoneAbs) : Assertion :=
  let table := sg.(task_done_ptr) in
  &(table # "KTaskDone" ->ₛ "init")
      # Ptr |-> done.(task_done_init) **
  &(table # "KTaskDone" ->ₛ "start")
      # Ptr |-> done.(task_done_start) **
  &(table # "KTaskDone" ->ₛ "Delete")
      # Ptr |-> done.(task_done_delete) **
  &(table # "KTaskDone" ->ₛ "delay")
      # Ptr |-> done.(task_done_delay) **
  &(table # "KTaskDone" ->ₛ "mdelay")
      # Ptr |-> done.(task_done_mdelay) **
  &(table # "KTaskDone" ->ₛ "prioset")
      # Ptr |-> done.(task_done_prioset) **
  &(table # "KTaskDone" ->ₛ "suspend")
      # Ptr |-> done.(task_done_suspend) **
  &(table # "KTaskDone" ->ₛ "wake")
      # Ptr |-> done.(task_done_wake).

(**
  [TaskProtocolView states held] 在一个不可拆分的 low-state 中同时记录 STS
  状态集合与当前线程持有的 token。不能把 state guard 与 owner token 写成
  两个可分离断言，否则会重复或丢失唯一 carrier 中的线性权限。
*)
Definition TaskProtocolView
    (states : TaskProtocolState -> Prop)
    (held : TaskProtocolTokenSet) : Assertion :=
  fun low_state =>
    low_state.(ConAssertion.s_mem) = empty_mem /\
    states == low_state.(ConAssertion.s_STS) /\
    held == low_state.(ConAssertion.s_token).

(** 固定本线程 token 时，协议允许的任意多步真实环境执行。 *)
Definition TaskProtocolRReachable
    (held : TaskProtocolTokenSet)
    (before after : TaskProtocolState) : Prop :=
  @Relation_Operators.clos_refl_trans
    TaskProtocolState (task_environment_step held) before after.

(** 普通线程在两次 Outside 观察之间的 rely 闭包。 *)
Definition TaskRReachable
    (before after : VarGlobalState) : Prop :=
  TaskProtocolRReachable
    task_no_tokens
    (Build_TaskProtocolState TPP_OUTSIDE before)
    (Build_TaskProtocolState TPP_OUTSIDE after).

(** 持有 owner token 时，在两次 Outside 观察之间的 rely 闭包。 *)
Definition TaskOwnerRReachable
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  TmpTaskRReachable
    owner
    (Build_TaskProtocolState TPP_OUTSIDE before)
    (Build_TaskProtocolState TPP_OUTSIDE after).

(** 精确 Inside 状态；当前线程只持 lock token。 *)
Definition TaskInsideProtocol (st : VarGlobalState) : Assertion :=
  TaskProtocolView
    (Sets.singleton (Build_TaskProtocolState TPP_INSIDE st))
    task_lock_token.

(** 普通 Outside view；环境从最后观察状态开始按普通 rely 闭包推进。 *)
Definition TaskOutsideProtocol (st : VarGlobalState) : Assertion :=
  TaskProtocolView
    (fun current =>
       TaskProtocolRReachable
         task_no_tokens
         (Build_TaskProtocolState TPP_OUTSIDE st)
         current)
    task_no_tokens.

(** 精确 owner-Inside 状态；同一线程同时持 lock 与唯一 owner token。 *)
Definition TaskInsideProtocolOwner
    (owner : KTaskReservation) (st : VarGlobalState) : Assertion :=
  “ task_reservation_active owner st ” &&
  TaskProtocolView
    (Sets.singleton (Build_TaskProtocolState TPP_INSIDE st))
    (task_lock_and_owner owner).

(**
  owner-Outside view 是成功 publish 后跨越 [_InitKTask] 保存的单一组合资源。
  它已经包含唯一 owner token，调用者不得再与另一个 owner-token 断言相乘。
*)
Definition TaskOutsideProtocolOwner
    (owner : KTaskReservation) (st : VarGlobalState) : Assertion :=
  “ task_reservation_active owner st ” &&
  TaskProtocolView
    (fun current =>
       TmpTaskRReachable
         owner
         (Build_TaskProtocolState TPP_OUTSIDE st)
         current)
    (task_owner_token owner).

(** 普通临界区内 view；共享 C 内存仍由 [crtos_inv] 单独给出。 *)
Definition TaskInsideCritical
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ TaskStableContext sg ” && store_task_done sg sg.(task_done_abs) **
  TaskInsideProtocol st.

(** 普通临界区外 view。 *)
Definition TaskOutsideCritical
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ TaskStableContext sg ” && store_task_done sg sg.(task_done_abs) **
  TaskOutsideProtocol st.

(** 创建者第二次进入临界区后的 owner view。 *)
Definition TaskInsideCriticalOwner
    (sg : StableGlobalState)
    (owner : KTaskReservation)
    (st : VarGlobalState) : Assertion :=
  “ TaskStableContext sg ” && store_task_done sg sg.(task_done_abs) **
  TaskInsideProtocolOwner owner st.

(** 第一次 publish 解锁后、rollback 前的 owner view。 *)
Definition TaskOutsideCriticalOwner
    (sg : StableGlobalState)
    (owner : KTaskReservation)
    (st : VarGlobalState) : Assertion :=
  “ TaskStableContext sg ” && store_task_done sg sg.(task_done_abs) **
  TaskOutsideProtocolOwner owner st.

(** 普通锁获取使用的 rely；它是环境步骤的自反传递闭包。 *)
Definition TaskRTrans := TaskRReachable.

(** owner 第二次锁获取使用的 rely。 *)
Definition TaskOwnerRTrans := TaskOwnerRReachable.

(** owner rely 的机器检查投影：环境闭包不能解除创建者的 reservation。 *)
Lemma TaskOwnerRTrans_preserves_active :
  forall owner before after,
    task_reservation_active owner before ->
    TaskOwnerRTrans owner before after ->
    task_reservation_active owner after.
Proof.
  intros owner before after Hactive Hreachable.
  unfold TaskOwnerRTrans, TaskOwnerRReachable in Hreachable.
  pose proof
    (tmp_task_rely_reachable_preserves_owner
      owner
      (Build_TaskProtocolState TPP_OUTSIDE before)
      (Build_TaskProtocolState TPP_OUTSIDE after)
      Hactive Hreachable) as Hpreserved.
  exact Hpreserved.
Qed.

(** 普通及 owner rely 都允许零步环境执行。 *)
Lemma TaskRTrans_refl : forall st, TaskRTrans st st.
Proof.
  intros st. unfold TaskRTrans, TaskRReachable, TaskProtocolRReachable.
  apply Relation_Operators.rt_refl.
Qed.

Lemma TaskOwnerRTrans_refl :
  forall owner st, TaskOwnerRTrans owner st st.
Proof.
  intros owner st.
  unfold TaskOwnerRTrans, TaskOwnerRReachable, TmpTaskRReachable.
  apply Relation_Operators.rt_refl.
Qed.

(** 普通退出只允许保持全部 reservation 的 active 性。 *)
Definition TaskGTrans := all_reservations_stable.

(** 第一次解锁的 publish guarantee。 *)
Definition TaskPublishGTrans := tmp_task_publish.

(** 初始化失败后第二次解锁的 rollback guarantee。 *)
Definition TaskRollbackGTrans := tmp_task_rollback.

(**
  owner 持锁完成 descriptor/stack 发布后使用的 finalize guarantee。
  它只能配合 [TaskInsideCriticalOwner] 与更新后的 [crtos_inv] 用于退出规则，
  不能作为 Outside-to-Outside 的普通 entailment 或无锁 ghost update 使用。
*)
Definition TaskFinalizeGTrans := tmp_task_finalize.
