(** KMutexDelete fresh experiment: 共享任务模型上的纯状态增量。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From Logic.lib Require Import Coqlib.
From SimpleC.SL Require Import Mem CNotation IntLib.
Require Export CRTOS_Verify.lib.KTaskWakeup.
Require Export CRTOS_Verify.lib.MutexOps.

Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.

(** Mutex 内嵌等待队列哨兵地址；不拥有内存。 *)
Definition mutex_pending_head (p : addr) : addr :=
  &(p # "Mutex" ->ₛ "pend_list").

Fixpoint mutex_delete_find_addr (p : addr) (mutexes : MutexState)
    : option MutexAbs :=
  match mutexes with
  | nil => None
  | mutex :: rest =>
      if Z.eq_dec mutex.(mutex_addr) p then Some mutex
      else mutex_delete_find_addr p rest
  end.

Fixpoint mutex_delete_find_id (id : Z) (mutexes : MutexState)
    : option MutexAbs :=
  match mutexes with
  | nil => None
  | mutex :: rest =>
      if Z.eq_dec mutex.(mutex_id) id then Some mutex
      else mutex_delete_find_id id rest
  end.

Definition mutex_delete_with_pending
    (mutex : MutexAbs) (pending : list addr) : MutexAbs :=
  {| mutex_addr := mutex.(mutex_addr);
     mutex_id := mutex.(mutex_id);
     mutex_value := mutex.(mutex_value);
     mutex_recursive_count := mutex.(mutex_recursive_count);
     mutex_original_priority := mutex.(mutex_original_priority);
     mutex_holder := mutex.(mutex_holder);
     mutex_pending_addrs := pending |}.

Fixpoint mutex_delete_set_pending (p : addr) (pending : list addr)
    (mutexes : MutexState) : MutexState :=
  match mutexes with
  | nil => nil
  | mutex :: rest =>
      if Z.eq_dec mutex.(mutex_addr) p
      then mutex_delete_with_pending mutex pending :: rest
      else mutex :: mutex_delete_set_pending p pending rest
  end.

Fixpoint mutex_delete_remove (p : addr) (mutexes : MutexState) : MutexState :=
  match mutexes with
  | nil => nil
  | mutex :: rest =>
      if Z.eq_dec mutex.(mutex_addr) p
      then rest
      else mutex :: mutex_delete_remove p rest
  end.

(** LinklistResumeAll 在调用 KTaskWakeup 前先写 exstatus=-ERROR。 *)
Definition mutex_delete_set_exstatus (task : addr) (desc : TaskDescriptorAbs)
    (st : VarGlobalState) : VarGlobalState :=
  replace_task_desc_map
    (update_task_desc_map task (set_task_desc_exstatus desc (-1))
      st.(os_tasks).(task_desc_map)) st.

(**
  一次 fresh 队首迭代：先提交 exstatus 中间态，再复用 共享任务模型的通用
  [ktask_wakeup_step]；额外等式把 generic remove 精化为本 p 的真实队首删除。
*)
Definition mutex_delete_wakeup_head_step (p task : addr)
    (before after : VarGlobalState) : Prop :=
  exists mutex rest desc middle,
    mutex_delete_find_addr p before.(os_mutexes) = Some mutex /\
    mutex.(mutex_pending_addrs) = task :: rest /\
    before.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
    middle = mutex_delete_set_exstatus task desc before /\
    ktask_wakeup_step task (set_task_desc_exstatus desc (-1)) middle after /\
    after.(os_mutexes) =
      mutex_delete_set_pending p rest before.(os_mutexes).

(** 仅供循环证明使用的逐头轨迹；公开批量接口见下方前后态效果。 *)
Inductive mutex_delete_resume_waiters (p : addr)
    : list addr -> VarGlobalState -> VarGlobalState -> Prop :=
| mutex_delete_resume_nil : forall st mutex,
    mutex_delete_find_addr p st.(os_mutexes) = Some mutex ->
    mutex.(mutex_pending_addrs) = nil ->
    mutex_delete_resume_waiters p nil st st
| mutex_delete_resume_cons : forall task rest before middle after,
    mutex_delete_wakeup_head_step p task before middle ->
    mutex_delete_resume_waiters p rest middle after ->
    mutex_delete_resume_waiters p (task :: rest) before after.

(** 整条 pending 的公开效果：清空本 mutex 的等待序列，整批更新任务表、
    取消相应延时，并按原等待顺序应用已有 ready 插入关系。嵌套 replace
    保留其余全部全局分量，包括其他 mutex、holder、ID 与管理链。
    这里没有暴露循环中间状态；ready 的次序由共享调度策略接口决定。 *)
Definition mutex_delete_resume_all_step (p : addr)
    (before after : VarGlobalState) : Prop :=
  exists mutex ready,
    mutex_delete_find_addr p before.(os_mutexes) = Some mutex /\
    let waiting := mutex.(mutex_pending_addrs) in
    let tasks := before.(os_tasks).(task_desc_map) in
    resume_all_ready tasks waiting
      before.(os_assign).(assignReadyVector) ready /\
    after = replace_mutexes (mutex_delete_set_pending p nil before.(os_mutexes))
      (replace_global_ready_vector ready
        (replace_global_delays (resume_all_delays tasks waiting before.(os_delays))
          (replace_task_desc_map (resume_all_task_map tasks waiting) before))).

(** IdRemoveObj + 管理 DLL remove 后只撤销 p 对应的发布对象。 *)
Definition mutex_delete_detach_step (p : addr)
    (before after : VarGlobalState) : Prop :=
  exists mutex,
    mutex_delete_find_addr p before.(os_mutexes) = Some mutex /\
    mutex.(mutex_pending_addrs) = nil /\
    after = replace_mutexes (mutex_delete_remove p before.(os_mutexes)) before.

Definition mutex_delete_query_id (id : Z) : Z := unsigned_last_nbits id 16.

(** 以 C 对象地址描述已发布域；对象内部 ID 不进入公开接口。
    这只是纯关联，内存权限仍由系统 os_inv 提供。 *)
Definition mutex_present (p : addr) (st : VarGlobalState) : Prop :=
  exists mutex, mutex_delete_find_addr p st.(os_mutexes) = Some mutex.

