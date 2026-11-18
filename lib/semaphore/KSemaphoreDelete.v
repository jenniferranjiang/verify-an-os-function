Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.task.KTaskWakeup CRTOS_Verify.lib.semaphore.SemaphoreOps.
Require Export CRTOS_Verify.lib.assign.KTaskOsAssign.
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
    由 semaphore_pending_head_ic 对应的关系精确移除当前等待队首。原 sem 的 value/ID、其他对象以及
    未触及的任务字段由这些精确局部更新保留。每轮重新读取当前队首。 *)
Definition semaphore_resume_one (p task : addr) (tail : list addr)
    (before after : VarGlobalState) : Prop :=
  exists sem desc,
    In sem before.(os_semaphores) /\ sem.(semaphore_addr) = p /\
    sem.(semaphore_pending_addrs) = task :: tail /\
    before.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
    let failed := set_task_desc_exstatus desc (-1) in
    let marked := replace_task_desc_map
      (update_task_desc_map task failed before.(os_tasks).(task_desc_map)) before in
    wakeup_semaphore_head p task failed marked after.

(** 循环证明使用的逐步关系。空序列仅表示没有后续操作；信号量存在及
    pending 与剩余序列一致，由调用前提和各轮更新保持，不在基例重复要求。
    此关系不再作为公开函数的整体效果；与整体效果的连接须在合法前态下证明。 *)
Fixpoint semaphore_resume_all_steps (p : addr) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  match waiting with
  | nil => after = before
  | task :: tail => exists middle,
      semaphore_resume_one p task tail before middle /\
      semaphore_resume_all_steps p tail middle after
  end.

(** 处理完整条等待队列的整体效果：任务表批量改为 READY/-ERROR，
    延时结构批量取消，ready 按原队列顺序插入，信号量 pending 最后一次置空。
    replace_* 保留 task ID/管理链、运行任务及其余全局分量；sem ID/value
    保持。非空队列的任务须原已登记且 SUSPEND、无重复，这些条件由实际
    等待 DLL 及任务资源给出，不额外加强 C spec 的前置。
    入口的信号量成员及 pending 对应关系由 caller 给出。空队列完全不改
    状态，避免无条件 set_pending 改写 caller 尚未重组的同地址 ghost 项。
    延时批量更新与逐步取消的等价只在 delay_inv 等合法资源前提下成立。 *)
Definition semaphore_resume_all_effect (p : addr) (waiting : list addr)
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
        after = replace_semaphores
          (semaphore_set_pending p nil before.(os_semaphores))
          (replace_global_ready_vector ready_after
            (replace_global_delays (resume_all_delays T waiting before.(os_delays))
              (replace_task_desc_map (resume_all_task_map T waiting) before)))
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
    semaphore_resume_all_effect p sem.(semaphore_pending_addrs) before drained /\
    after = replace_semaphores (semaphore_unpublish p drained.(os_semaphores)) drained).

(** 返回的布尔值仅决定锁外调度；私有待释放对象地址在内存契约中存在量化，
    不泄漏到公开 void API。此 program 没有给非法堆提供权限。 *)
Definition abs_semaphore_delete_locked (id : Z) : program VarGlobalState bool :=
  {| nrm := fun before resched after =>
       exists p, semaphore_delete_locked_effect id p resched before after;
     err := fun _ => False |}.

(** id<0或id>65535直接返回；通过SemIdInvalid检查后才做锁内抽象操作，
    锁外free消费私有对象，
    最后仅在原等待队列非空时调用文档规定的 KTASK_ASSIGN 模型。
    该模型不证明硬件调度实现；其 rely 变化和临界区交接复用全系统协议。 *)
Definition abs_semaphore_delete (sg : StableGlobalState) (id : Z)
    : program (VarGlobalState -> Prop) unit :=
  if semaphore_id_invalid id then MonadErr.ret tt
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

(** 待证的连接命题，不是已证明引理。限定于实际借出的合法资源及信号量
    入口关联；不声称两个关系在任意损坏或未登记的纯状态上都等价。
    后续循环证明需证明逐步结果满足整体效果，反向连接用于核对抽象行为范围。 *)
Definition semaphore_resume_all_effect_steps_obligation : Prop :=
  forall sg before sem after,
    os_global_context sg -> In sem before.(os_semaphores) ->
    os_inv sg before |--
    “ (semaphore_resume_all_steps sem.(semaphore_addr)
         sem.(semaphore_pending_addrs) before after <->
       semaphore_resume_all_effect sem.(semaphore_addr)
         sem.(semaphore_pending_addrs) before after) ”.


(** 只对通过SemIdInvalid范围检查的输入约束实际会找到的对象；
    负ID、超过65535的ID和lookup失败均保留真实早返回路径。
    Init 回滚尚未发布 queue，且新 semaphore 无等待者，满足此场景。
    非空等待队列的一般删除不由本轮 IC 规格覆盖。 *)
Definition semaphore_delete_quiescent (id : Z) (st : VarGlobalState) : Prop :=
  0 <= id <= 65535 ->
  (forall s, In s st.(os_semaphores) ->
    s.(semaphore_id) = semaphore_query_id id -> s.(semaphore_pending_addrs) = nil) /\
  (forall p q, st.(os_dataqueues).(dataqueue_map) p = Some q ->
    q.(dq_sem_blank) <> semaphore_query_id id /\
    q.(dq_sem_data) <> semaphore_query_id id).

(** Delete先检查完整int32 ID范围，越界直接保持状态；有效范围内的转窄
    不改变ID。不存在时只允许抽象状态不变，存在时只摘除
    查到的同一地址，free 由具体内存契约回收，不冒充纯函数释放内存。 *)
Definition semaphore_delete_ic_effect (id : Z)
    (before after : VarGlobalState) : Prop :=
  ((id < 0 \/ 65535 < id) /\ after = before) \/
  (0 <= id <= 65535 /\
    (( (forall s, In s before.(os_semaphores) ->
          s.(semaphore_id) <> semaphore_query_id id) /\ after = before) \/
     (exists s, In s before.(os_semaphores) /\
       s.(semaphore_id) = semaphore_query_id id /\
       s.(semaphore_pending_addrs) = nil /\
       after = replace_semaphores
         (semaphore_unpublish s.(semaphore_addr) before.(os_semaphores)) before))).



(** dataqueue调用使用的锁内命名接口，与既有完整ResumeAll效果定义相同。 *)
Definition semaphore_resume_all_ic_effect := semaphore_resume_all_effect.

(** 保留caller既定名称但直接描述本轮state中的真实pending节点，不依赖旧投影。 *)
Definition semaphore_pending_nodes_ic (p : Z) (st : VarGlobalState)
    (nodes : list (DL_Node Z)) : Prop :=
  exists obj, In obj st.(os_semaphores) /\ obj.(semaphore_addr) = p /\
    map CRTOS_Verify.lib.task.KTaskWakeup.sched_link_node obj.(semaphore_pending_addrs) = nodes.

(** 调用实际effect保持queue对象、相关semaphore地址/ID；普通待证义务，非信任。 *)
Definition resume_all_dataqueue_refs_obligation : Prop := forall p waiting before after q,
  semaphore_resume_all_ic_effect p waiting before after ->
  dataqueue_semaphores before.(os_semaphores) q ->
  dataqueue_semaphores after.(os_semaphores) q.
Definition resume_all_dataqueue_state_obligation : Prop := forall p waiting before after,
  semaphore_resume_all_ic_effect p waiting before after ->
  after.(os_dataqueues) = before.(os_dataqueues).

(** 统一native资源下queue部分按真实semaphore effect原样frame。
    原LinklistResumeAll证明须在这些native共享接口下实例化并检查，不能把旧carrier
    theorem直接作为新Assertion结论。此义务只说明新增queue分量，不隐藏任务等更新。 *)
Definition resume_all_frame_obligation : Prop := forall p waiting before after,
  semaphore_resume_all_ic_effect p waiting before after ->
  Crtos_C_Rules.derivable1
    (dataqueue_inv before.(os_semaphores) before.(os_dataqueues))
    (dataqueue_inv after.(os_semaphores) after.(os_dataqueues)).
