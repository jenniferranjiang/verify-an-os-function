Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Export CRTOS_Verify.lib.pendlist.LinklistSuspend.
Require Export CRTOS_Verify.lib.delay.KTaskSetDelayState.
Require Export CRTOS_Verify.lib.common.TickConversion.
Import ListNotations MonadErr Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.
Local Open Scope sac.

(** 0和-1不经毫秒转换；有限等待使用当前源码64位乘法转换。 *)
Definition semaphore_wait_ticks (msec : Z) : Z :=
  if Z.eq_dec msec 0 then 0 else if Z.eq_dec msec KWAIT_FOREVER then KWAIT_FOREVER
  else tick_from_time_ms msec.

(** 挂起前仅将当前任务exstatus清零。 *)
Definition semaphore_clear_status (task : Z) (d : TaskDescriptorAbs)
    (st : VarGlobalState) : VarGlobalState :=
  replace_task_desc_map (update_task_desc_map task (set_task_desc_exstatus d KOK)
    st.(os_tasks).(task_desc_map)) st.

(** result为Left错误/成功立即返回，或Right保存待调度任务地址。
    所有写入通过已有精确局部变换描述；无限等待不创建delay。 *)
Definition semaphore_obtain_effect (id ticks : Z) (before : VarGlobalState)
    (result : Z + Z) (after : VarGlobalState) : Prop :=
  ((forall sem, In sem before.(os_semaphores) -> sem.(semaphore_id) <> id) /\
    result = inl (-KERROR) /\ after = before) \/
  exists sem, In sem before.(os_semaphores) /\ sem.(semaphore_id) = id /\
    ((0 < sem.(semaphore_value) /\ result = inl KOK /\
      after = replace_semaphores
        (semaphore_set_value sem.(semaphore_addr) (sem.(semaphore_value)-1)
          before.(os_semaphores)) before) \/
     (sem.(semaphore_value) = 0 /\
      ((ticks = 0 /\ result = inl (-KTIMEOUT) /\ after = before) \/
       (ticks <> 0 /\ exists task desc suspended,
        task = before.(os_assign).(assignRunningTask) /\ task <> 0 /\
        before.(os_tasks).(task_desc_map) task = Some desc /\
        linklist_suspend_prio sem.(semaphore_addr) task
          (semaphore_clear_status task desc before) suspended /\
        ((ticks < 0 /\ result = inr task /\ after = suspended) \/
         (0 < ticks /\ exists sd delayed delay_ptr rc,
          suspended.(os_tasks).(task_desc_map) task = Some sd /\
          ktask_set_delay_step task sd ticks delay_ptr suspended rc delayed /\
          ((rc = KOK /\ result = inr task /\ after = delayed) \/
           (rc <> KOK /\ result = inl (-NOMEMORY) /\ exists dd,
             delayed.(os_tasks).(task_desc_map) task = Some dd /\
             ktask_wakeup_step task dd delayed after)))))))).

(** 获取锁后可能实际阻塞的路径，必须有可挂起的当前任务；这是内存/调用
    合法性条件，不限制非法ID、空计数、超时失败等返回路径。 *)
Definition semaphore_obtain_entry (sg : StableGlobalState) (id ticks : Z)
    (states : VarGlobalState -> Prop) : Prop :=
  forall st, states st -> os_inv sg st |--
    “ forall sem, In sem st.(os_semaphores) -> sem.(semaphore_id) = id ->
      sem.(semaphore_value) = 0 -> ticks <> 0 ->
      (linklist_suspend_admissible st.(os_assign).(assignRunningTask) 1 st /\
       forall desc suspended sd,
         st.(os_tasks).(task_desc_map) st.(os_assign).(assignRunningTask) = Some desc ->
         linklist_suspend_prio sem.(semaphore_addr) st.(os_assign).(assignRunningTask)
           (semaphore_clear_status st.(os_assign).(assignRunningTask) desc st) suspended ->
         suspended.(os_tasks).(task_desc_map) st.(os_assign).(assignRunningTask) = Some sd ->
         0 < ticks ->
         (sd.(tdDelay) = 0 \/
          suspended.(os_delays).(delay_inactive_map) sd.(tdDelay) <> None) /\
         delay_list_window suspended.(os_tick) suspended.(os_delays).(delay_active_nodes)) ”.
Definition abs_semaphore_obtain_locked (id ticks : Z) : program VarGlobalState (Z + Z) :=
  {| nrm := semaphore_obtain_effect id ticks; err := fun _ => False |}.

(** 调度后只读缓存任务的exstatus，不把调度前后状态强行相等。
    调度可能不终止；正常恢复时该任务仍须存在，条件由assertS承担。 *)
Definition semaphore_status_entry (sg : StableGlobalState) (task : Z)
    (states : VarGlobalState -> Prop) : Prop :=
  forall st, states st -> os_inv sg st |--
    “ exists d, st.(os_tasks).(task_desc_map) task = Some d ”.
Definition semaphore_read_status (task : Z) : program VarGlobalState Z :=
  {| nrm := fun before r after => after = before /\ exists d,
       before.(os_tasks).(task_desc_map) task = Some d /\ r = d.(tdExstatus);
     err := fun _ => False |}.

(** KTASK_ASSIGN正常返回后的原有后续：检查缓存任务仍存在，再在新的
    临界区观察中只读exstatus。具名接口供调用注解连接continuation，
    不要求调度前后状态相等，也不承诺调度终止。 *)
Definition semaphore_obtain_after_assign (sg : StableGlobalState) (task : Z)
    : program (VarGlobalState -> Prop) Z :=
  assertS (semaphore_status_entry sg task) ;;
  task_atomic_cmd (semaphore_read_status task).

(** 锁内结果为inl时直接返回；inr保留待调度任务，先调度再读取恢复状态。
    这是原abs_semaphore_obtain的结果分支提取，保持顺序及错误/等待路径。 *)
Definition semaphore_obtain_after_locked (sg : StableGlobalState) (result : Z + Z)
    : program (VarGlobalState -> Prop) Z :=
  match result with
  | inl r => ret r
  | inr task => abs_ktask_assign ;; semaphore_obtain_after_assign sg task
  end.

Definition abs_semaphore_obtain (sg : StableGlobalState) (id msec : Z)
    : program (VarGlobalState -> Prop) Z :=
  IF (semaphore_id_invalid id \/
      (msec < 0 /\ msec <> KWAIT_FOREVER))
    (ret (-KERROR))
    (let ticks := semaphore_wait_ticks msec in
     assertS (semaphore_obtain_entry sg id ticks) ;;
     result <- task_atomic_cmd (abs_semaphore_obtain_locked id ticks) ;;
     semaphore_obtain_after_locked sg result).
