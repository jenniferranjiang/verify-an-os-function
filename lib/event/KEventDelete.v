Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.task.KTaskWakeup CRTOS_Verify.lib.assign.KTaskOsAssign.
Require Export CRTOS_Verify.lib.event.EventInv CRTOS_Verify.lib.event.EventOps.
Import ListNotations DLL IDNode MonadErr SetsNotation.
Local Open Scope string.
Local Open Scope sac.
Local Open Scope list.
Local Open Scope Z_scope.
Local Open Scope sets.

(** 事件等待哨兵的实际地址；pending 保存的元素仍是 task 基址，而不是
    sched_link 地址。纯关系只定位已发布对象，不提供读写权限。 *)
Definition event_pending_head (p : addr) : addr :=
  &(p # "Event" ->ₛ "pend_list").
Definition event_pending_at (id p : Z) (waiting : list addr)
    (st : VarGlobalState) : Prop :=
  exists e, In e st.(os_events) /\ e.(event_addr) = p /\
    e.(event_id) = id /\ e.(event_pending_addrs) = waiting.

(** 本轮用户批准的生命周期限制在各真实加锁点的前态/后态条件。
    empty=false只要求查询所得的同一p/id仍已发布，允许options/events、
    pending及其他OS分量变化；empty=true再要求先前已观察/清空的pending
    保持空。p非零来自命中路径。它是纯关系，不能代替os_inv的所有权。
    只有本次Delete运行假设适用时，才可使用相应具名trusted Lock contract；
    该contract不是由全系统ordinary Lock（rely=True）推出的。
    D1运行假设要求同一allocation从查找命中到本次注销前不被其他操作
    回收或复用；下面p/id端点关系不表示allocation世代，不能单独排除
    地址与ID先释放再重用的ABA。可信Lock边界依赖这项完整区间假设。 *)
Definition event_delete_guard (id p : Z) (empty : bool)
    (st : VarGlobalState) : Prop :=
  p <> 0 /\ exists e,
    In e st.(os_events) /\ e.(event_addr) = p /\ e.(event_id) = id /\
    (empty = true -> e.(event_pending_addrs) = nil).
Definition event_delete_gap (id p : Z) (empty : bool)
    (before after : VarGlobalState) : Prop :=
  Crtos_RTrans before after /\ event_delete_guard id p empty after.

(** 在统一CRTOS断言载体上描述本轮受限环境的一个真实临界区。
    只从用户批准条件允许的实际加锁观察执行cmd，解锁后仍返回普通
    Crtos_RTrans集合，并继续使用LastSeen/InsideCritical/OutsideCritical。
    这不是修改全局rely，也不是取得新token；筛选的依据必须是本轮具名
    trusted环境Lock contract，而不能从普通Lock的结果凭空assume。
    err只检查允许观察，保留cmd本身的错误语义；不是丢弃错误来证明安全。 *)
Definition event_delete_atomic_cmd {A : Type} (id p : Z) (empty : bool)
    (cmd : program VarGlobalState A) : program (VarGlobalState -> Prop) A :=
  {| nrm := fun states result next_states =>
       exists before after,
         states before /\ event_delete_guard id p empty before /\
         cmd.(nrm) before result after /\
         next_states == Crtos_RTrans after;
     err := fun states => exists before,
       states before /\ event_delete_guard id p empty before /\ cmd.(err) before |}.

(** FindEventById返回NULL或对应ID的Event基址。它只观察当前对象集合；
    ID懒桶初始化允许改变具体桶形态，不改变抽象对象序列。ID的uint16
    调用转换在本轮0<=id<65536前提下保持值，不取模或过滤其他合法路径。 *)
Definition event_lookup_result (id p : Z) (st : VarGlobalState) : Prop :=
  (p = 0 /\ forall e, In e st.(os_events) -> e.(event_id) <> id) \/
  (p <> 0 /\ exists e, In e st.(os_events) /\
    e.(event_id) = id /\ e.(event_addr) = p).
Definition abs_find_event_locked (id : Z) : program VarGlobalState addr :=
  {| nrm := fun before p after => after = before /\ event_lookup_result id p before;
     err := fun _ => False |}.
Definition abs_find_event (id : Z) : program (VarGlobalState -> Prop) addr :=
  if Z.ltb id 0 then MonadErr.ret 0
  else task_atomic_cmd (abs_find_event_locked id).

(** 锁外IsDoubleLinkListEmpty共享读取按源码处理规则单独包围临界区。
    返回true表示原C的!IsDoubleLinkListEmpty分支被选中；不对后续环境
    保留这份waiting快照。resched取此时结果，不取ResumeAll后队列长度。 *)
Definition abs_event_pending_nonempty_locked (id p : Z)
    : program VarGlobalState bool :=
  {| nrm := fun before nonempty after =>
       after = before /\ exists waiting,
         event_pending_at id p waiting before /\
         nonempty = negb (Nat.eqb (List.length waiting) 0);
     err := fun _ => False |}.

(** 清空当前事件等待队列的整体效果。waiting是ResumeAll真正加锁后
    的序列，允许先前检查非空而此时已空。批量复用现有task/Delay/ready
    更新，保留其他模块、任务注册和运行槽；目标事件只将pending置空。
    非空队列的NoDup和SUSPEND关联由合法os_inv导出，不另加强C前提。 *)
Definition event_resume_all_effect (p : addr) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  match waiting with
  | nil => after = before
  | _ =>
      let T := before.(os_tasks).(task_desc_map) in
      NoDup waiting /\
      Forall (fun task => exists desc,
        T task = Some desc /\ desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND)
        waiting /\
      exists ready_after,
        resume_all_ready T waiting before.(os_assign).(assignReadyVector) ready_after /\
        after = replace_events (event_set_pending p nil before.(os_events))
          (replace_global_ready_vector ready_after
            (replace_global_delays (resume_all_delays T waiting before.(os_delays))
              (replace_task_desc_map (resume_all_task_map T waiting) before)))
  end.

(** 一轮循环先写exstatus=-1，再调用根库KTaskWakeup通用关系。
    来源由事件当前队首及os_inv的唯一sched_link归属确定，不把semaphore
    场景的唤醒contract改名充当事件证明。 *)
Definition event_resume_one (id p task : Z) (tail : list addr)
    (before after : VarGlobalState) : Prop :=
  event_pending_at id p (task :: tail) before /\
  exists desc,
    before.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
    let failed := set_task_desc_exstatus desc (-1) in
    let marked := replace_task_desc_map
      (update_task_desc_map task failed before.(os_tasks).(task_desc_map)) before in
    ktask_wakeup_step task failed marked after.
Fixpoint event_resume_all_steps (id p : Z) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  match waiting with
  | nil => after = before
  | task :: tail => exists middle,
      event_resume_one id p task tail before middle /\
      event_resume_all_steps id p tail middle after
  end.
Definition abs_event_resume_all_locked (id p : Z) : program VarGlobalState unit :=
  {| nrm := fun before _ after => exists waiting,
       event_pending_at id p waiting before /\
       event_resume_all_effect p waiting before after;
     err := fun _ => False |}.

(** LinklistResumeAll在本调用链是锁外调用，保留自身真实加锁与解锁。
    具名program对应该函数边界，以当前加锁观察的waiting完成批量唤醒。 *)
Definition abs_event_resume_all (id p : Z)
    : program (VarGlobalState -> Prop) unit :=
  event_delete_atomic_cmd id p false (abs_event_resume_all_locked id p).

(** 最后一次删除临界区只撤销已经空pending的对象：ID与管理链同步移除，
    其他对象及OS分量保持。实际对象的字段资源从共享不变量转为EventRetired，
    后续锁外free消费它；纯状态移除本身不声称已经释放字节。 *)
Definition event_unpublish_effect (id p : Z)
    (before after : VarGlobalState) : Prop :=
  event_pending_at id p nil before /\
  after = replace_events (event_unpublish p before.(os_events)) before.
Definition abs_event_unpublish_locked (id p : Z) : program VarGlobalState unit :=
  {| nrm := fun before _ after => event_unpublish_effect id p before after;
     err := fun _ => False |}.

(** _EventDelete的原始分段控制流：独立共享读取；必要时ResumeAll的
    真实临界区；最后注销临界区；仅先前读取非空时在free后调度。
    不合并临界区、不把期间环境变化说成函数自身写入。free无共享抽象
    状态改变，其完整私有资源交接单独由EventRetired及x_free规格表达。 *)
Definition abs_event_delete_at (id p : Z) : program (VarGlobalState -> Prop) unit :=
  MonadErr.bind
    (event_delete_atomic_cmd id p false (abs_event_pending_nonempty_locked id p))
    (fun nonempty =>
       MonadErr.bind
         (if nonempty then
            abs_event_resume_all id p
          else MonadErr.ret tt)
         (fun _ =>
            MonadErr.bind
              (event_delete_atomic_cmd id p true (abs_event_unpublish_locked id p))
              (fun _ => if nonempty then abs_ktask_assign else MonadErr.ret tt))).

(** 公开API保留查询未命中直接返回；命中后按用户排除D1/D2的环境
    运行上述分段删除。C仍为int32参数，spec另列0<=id<65536。
    不承诺原入口与出口所有其他状态相等，因为期间环境可以运行。 *)
Definition abs_event_delete (id : Z) : program (VarGlobalState -> Prop) unit :=
  MonadErr.bind (abs_find_event id)
    (fun p => if Z.eqb p 0 then MonadErr.ret tt else abs_event_delete_at id p).

(** 以下均为设计阶段待证义务：Definition保存命题，不提供证明事实。
    当before满足相应guard时不变化的环境步可满足gap，排除用空关系
    假装D1/D2成立；实际C执行的scope授权仍是具名trusted contract的前提。 *)
Definition event_delete_gap_nonempty_obligation : Prop :=
  forall id p empty before,
    event_delete_guard id p empty before -> event_delete_gap id p empty before before.

(** 批量效果与逐步循环只在实际事件/任务/延时资源合法时连接。
    不在任意损坏的纯状态上宣称等价，也不把类型检查当成该义务的证明。 *)
Definition event_resume_all_effect_steps_obligation : Prop :=
  forall sg before e after,
    In e before.(os_events) ->
    os_inv sg before |--
    “ (event_resume_all_steps e.(event_id) e.(event_addr)
         e.(event_pending_addrs) before after <->
       event_resume_all_effect e.(event_addr) e.(event_pending_addrs) before after) ”.

(** ID注销与管理序列移除之间的一致性，由合法manager/DLL推出地址及ID
    唯一性后证明；不另往公开Require加入未经用户批准的NoDup条件。 *)
Definition event_unpublish_manager_obligation : Prop :=
  forall sg before e,
    In e before.(os_events) ->
    os_inv sg before |--
    “ event_manager (event_unpublish e.(event_addr) before.(os_events)) =
      idmanager_remove sg.(os_event_stable).(event_manager_stable)
        (event_manager before.(os_events)) e.(event_id) ”.

(** 复用CrtosInv已有event_create_frame：虽然沿用历史名字，该资源正是
    除event_inv之外的所有OS内存和world关联，不为Delete复制第二套frame。
    最后注销空pending对象不改变任何sched_link所有者，因此可恢复world。
    EventRetired继续归当前调用者，不能重放回event_inv造成重复所有权。 *)
Definition event_delete_restore_obligation : Prop :=
  forall sg before id p options events,
    event_pending_at id p nil before ->
    NoDup (map event_addr before.(os_events)) ->
    idmanager_remove sg.(os_event_stable).(event_manager_stable)
      (event_manager before.(os_events)) id =
      event_manager (event_unpublish p before.(os_events)) ->
    event_create_frame sg before **
    store_idmanager sg.(os_event_stable).(event_manager_stable)
      (idmanager_remove sg.(os_event_stable).(event_manager_stable)
        (event_manager before.(os_events)) id) sg.(os_event_stable).(event_manager_ptr) **
    store_dll (store_event (pure_suspend_sched_link before.(os_tasks).(task_desc_map)))
      sg.(os_event_stable).(event_list_head)
      (map event_link_node (event_unpublish p before.(os_events))) **
    EventRetired p options events
    |-- os_inv sg (replace_events (event_unpublish p before.(os_events)) before) **
        EventRetired p options events.
