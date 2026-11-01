Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KTaskWakeup CRTOS_Verify.lib.SemaphoreOps.
Require Export CRTOS_Verify.lib.KTaskOsAssign.
Import ListNotations DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.
Local Open Scope list.
Local Open Scope Z_scope.

(** 从 Semaphore 基址取得内嵌 pend_list 哨兵；等待链的节点属于 task，
    哨兵属于此 Semaphore 对象。 *)
Definition semaphore_pending_head (p : addr) : addr :=
  &(p # "Semaphore" ->ₛ "pend_list").

(** ResumeAll 的一轮：写首任务 exstatus=-ERROR，取消其 delay，迁到 READY，
    再从当前信号量的等待序列移除首项。原 sem 的 value/ID、其他对象以及
    未触及的任务字段由这些精确局部更新保留。每轮重新读取当前队首。 *)
Definition semaphore_resume_one (p task : addr) (tail : list addr)
    (before after : VarGlobalState) : Prop :=
  exists sem desc awake,
    In sem before.(os_semaphores) /\ sem.(semaphore_addr) = p /\
    sem.(semaphore_pending_addrs) = task :: tail /\
    before.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
    let failed := set_task_desc_exstatus desc (-1) in
    let marked := replace_task_desc_map
      (update_task_desc_map task failed before.(os_tasks).(task_desc_map)) before in
    ktask_wakeup_step task failed marked awake /\
    after = replace_semaphores
      (semaphore_set_pending p tail awake.(os_semaphores)) awake.

(** 按原等待队列顺序反复执行一轮；末态必须仍有同一已发布对象且等待链为空。
    这是可检查的有限关系，终止的实现证明需从 SUSPEND 登记关系和成功摘链
    得到长度严格下降。坏链表/未登记任务不会被当作成功返回。 *)
Fixpoint semaphore_resume_all_steps (p : addr) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  match waiting with
  | nil => after = before /\ exists sem,
      In sem before.(os_semaphores) /\ sem.(semaphore_addr) = p /\
      sem.(semaphore_pending_addrs) = nil
  | task :: tail => exists middle,
      semaphore_resume_one p task tail before middle /\
      semaphore_resume_all_steps p tail middle after
  end.

(** 锁内删除的纯效果，p=0 为未找到；找到则唤醒所有原等待任务，注销 ID
    并从管理链移除同一个对象。resched 恰记录原等待队列是否非空。
    IdGetObj 的 lazy 空桶初始化不改变此抽象对象序列；具体桶两种形态仍由
    store_idbucket 拥有，不能据 before=after 宣称失败路径的字节完全不变。 *)
Definition semaphore_delete_locked_effect (id p : Z) (resched : bool)
    (before after : VarGlobalState) : Prop :=
  (p = 0 /\ resched = false /\ after = before /\
   (forall sem, In sem before.(os_semaphores) ->
     sem.(semaphore_id) <> semaphore_query_id id)) \/
  (exists sem drained,
    In sem before.(os_semaphores) /\
    sem.(semaphore_id) = semaphore_query_id id /\
    p = sem.(semaphore_addr) /\ p <> 0 /\
    resched = negb (Nat.eqb (List.length sem.(semaphore_pending_addrs)) 0) /\
    semaphore_resume_all_steps p sem.(semaphore_pending_addrs) before drained /\
    after = replace_semaphores (semaphore_unpublish p drained.(os_semaphores)) drained).

(** 返回的布尔值仅决定锁外调度；私有待释放对象地址在内存契约中存在量化，
    不泄漏到公开 void API。此 program 没有给非法堆提供权限。 *)
Definition abs_semaphore_delete_locked (id : Z) : program VarGlobalState bool :=
  {| nrm := fun before resched after =>
       exists p, semaphore_delete_locked_effect id p resched before after;
     err := fun _ => False |}.

(** 负 ID 直接返回；其余路径做一次锁内抽象操作，锁外 free 消费私有对象，
    最后仅在原等待队列非空时调用文档规定的 KTASK_ASSIGN 模型。
    该模型不证明硬件调度实现；其 rely 变化和临界区交接复用全系统协议。 *)
Definition abs_semaphore_delete (sg : StableGlobalState) (id : Z)
    : program (VarGlobalState -> Prop) unit :=
  if Z.ltb id 0 then MonadErr.ret tt
  else MonadErr.bind (task_atomic_cmd (abs_semaphore_delete_locked id))
         (fun resched => if resched then abs_ktask_assign else MonadErr.ret tt).

(** ID 注销且管理 link 摘除后的完整私有对象：ID 值65535，两条外部链自环，
    等待哨兵为空，value和padding保持。此对象不再属于 semaphore_inv；其
    所有权可独立穿过解锁，合为 SemaphoreRaw 后由 x_free 消费。
    p 是创建时 malloc 的对象基址，不是内部节点地址。 *)
Definition SemaphoreRetired (p value : Z) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 /\
    &(p # "Semaphore" ->ₛ "id" .ₛ "link") <> 0 /\
    &(p # "Semaphore" ->ₛ "pend_list") <> 0 /\
    &(p # "Semaphore" ->ₛ "link") <> 0 ” &&
  store_idnode
    (&(p # "Semaphore" ->ₛ "id" .ₛ "link"))
    (Build_IdNodeAbs 65535 (&(p # "Semaphore" ->ₛ "id"))) **
  store_node_self_linked (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> value **
  store_node_self_linked (&(p # "Semaphore" ->ₛ "pend_list")) **
  store_node_self_linked (&(p # "Semaphore" ->ₛ "link")) **
  SemaphorePadding p.

(** 资源桥的待证命题，仅是 typechecked statement，不是已证明引理。
    不能以此 Definition 为证明事实。实现阶段需由字段forget与布局组合证明。 *)
Definition semaphore_retired_raw_obligation : Prop :=
  forall p value, SemaphoreRetired p value |-- SemaphoreRaw p.

