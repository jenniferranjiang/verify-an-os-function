Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export KMutexDeleteTrial.lib.Pendlist CRTOS_Verify.lib.common.MutexInv.
Import ListNotations DLL IDNode MonadErr.
Import Monad MonadNotation.
Local Open Scope string.
Local Open Scope sac.
Local Open Scope list.
Local Open Scope Z_scope.
Local Open Scope monad.

(** 原 KMutexDelete 的条件化设计：用户于2026-11-03批准 A1（查找命中的
    同一分配对象在本次注销前不被他人删除/回收/复用）、A2（本次排空后到
    注销前不再加入新waiter）。原C的两个解锁窗口保留，不是源码修复。
    以下守卫是重新取得锁时可观察的后果，不独自证明分配世代；排除ABA依赖
    A1本身。既有RTrans/OutsideCritical/InsideCritical/os_inv全部复用。 *)

(** p为分配基址，id为登记的uint16 ID；这是历史状态关联，不拥有对象字节，
    也不能由它推出任意未来状态里对象仍存在。 *)
Definition mutex_delete_live (p id : Z) (st : VarGlobalState) : Prop :=
  p <> 0 /\ 0 <= id < 65536 /\
  exists m, In m st.(os_mutexes) /\ m.(mutex_addr) = p /\ m.(mutex_id) = id.

(** 排空后的历史观察；A1/A2限定本次注销的下一次锁acquisition保留同对象与
    空链，不保留val/holder/recursive_cnt/origin_prio或其他模块的值。 *)
Definition mutex_delete_drained (p id : Z) (st : VarGlobalState) : Prop :=
  p <> 0 /\ 0 <= id < 65536 /\
  exists m, In m st.(os_mutexes) /\ m.(mutex_addr) = p /\
    m.(mutex_id) = id /\ m.(mutex_pending_addrs) = nil.

Definition mutex_pending_head (p : addr) : addr :=
  &(p # "Mutex" ->ₛ "pend_list").

(** Mutex等待链的纯投影；实际哨兵与节点权限由mutex_inv/os_inv提供。
    直接使用Task的sched_link_node，不复制任务字段或链结构。 *)
Definition mutex_pending_nodes (p : addr) (st : VarGlobalState)
    (nodes : list (DL_Node addr)) : Prop :=
  exists m, In m st.(os_mutexes) /\ m.(mutex_addr) = p /\
    map sched_link_node m.(mutex_pending_addrs) = nodes.

(** drain只改目标pending，保留标量和管理顺序。合法heap中的地址唯一性来自
    实际分离资源；此map不为任意损坏纯状态证明地址唯一。 *)
Definition mutex_delete_set_pending (p : addr) (waiting : list addr)
    (before : MutexState) : MutexState := mutex_set_pending p waiting before.

(** 注销同一个已排空对象；ID manager和管理DLL继续从唯一对象序列派生。
    空队列是退回完整私有对象资源的必要条件，不是忽略等待节点的借口。 *)
Definition mutex_delete_unpublish (p : addr) (before : MutexState) : MutexState :=
  filter (fun m => negb (Z.eqb m.(mutex_addr) p)) before.

(** 整条等待队列的整体效果：waiting取自实际drain加锁时，而非较早lookup。
    任务批量READY/-ERROR、延时取消、RRR按原队列顺序插入，目标pending清空。
    replace_*精确保留其余对象、标量和全局分量；空队列无效果。
    NoDup/SUSPEND由原invariant导出，不增加调用者业务前提。 *)
Definition mutex_resume_all_effect (p id : addr) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  linklist_resume_all_step (PendMutex p id)
    (map sched_link_node waiting) before after.

(** 单步先写队首exstatus=-1，再用根库KTaskWakeup通用关系唤醒。
    未把mutex场景冒称为semaphore合同的特化；其余队列由全局唯一归属保持。 *)
Definition mutex_resume_one (p task : addr) (tail : list addr)
    (before after : VarGlobalState) : Prop :=
  exists m desc,
    In m before.(os_mutexes) /\ m.(mutex_addr) = p /\
    m.(mutex_pending_addrs) = task :: tail /\
    before.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
    let failed := set_task_desc_exstatus desc (-1) in
    let marked := replace_task_desc_map
      (update_task_desc_map task failed before.(os_tasks).(task_desc_map)) before in
    ktask_wakeup_step task failed marked after.

(** 仅供循环证明连接整体效果；公开接口使用上面的批量关系。 *)
Fixpoint mutex_resume_all_steps (p : addr) (waiting : list addr)
    (before after : VarGlobalState) : Prop :=
  match waiting with
  | nil => after = before
  | task :: tail => exists middle,
      mutex_resume_one p task tail before middle /\
      mutex_resume_all_steps p tail middle after
  end.

(** 原查询接收uint16：非负int32 ID按低16位查询，65536会查ID 0。
    lazy空桶初始化不改逻辑集合，after=before不承诺所有bucket字节未写。
    None未命中；Some只在内部携带对象地址/实际ID，公开void API不泄漏地址。 *)
Definition abs_mutex_delete_lookup_locked (id : Z)
    : program VarGlobalState (option (addr * Z)) :=
  {| nrm := fun before result after =>
       after = before /\
       match result with
       | None => forall m, In m before.(os_mutexes) ->
           m.(mutex_id) <> unsigned_last_nbits id 16
       | Some (p, key) => key = unsigned_last_nbits id 16 /\
           mutex_delete_live p key before
       end;
     err := fun _ => False |}.

(** 一次真实drain临界区内处理全部等待者；对象入口关联使空分支也对应
    真实登记对象，不把LinklistResumeAll本身设为trusted。 *)
Definition abs_mutex_resume_all_locked (p id : Z) : program VarGlobalState unit :=
  linklist_resume_all_locked (PendMutex p id).

(** 注销只改Mutex模块，按最后取得锁时的当前对象读id与保存标量。
    私有退休字节由MutexRetired接管，随后锁外free消费。 *)
Definition abs_mutex_retire_locked (p id : Z) : program VarGlobalState unit :=
  {| nrm := fun before _ after =>
       mutex_delete_drained p id before /\
       after = replace_mutexes (mutex_delete_unpublish p before.(os_mutexes)) before;
     err := fun _ => False |}.

(** A1/A2限定观察的抽象提升。没有新建锁协议，解锁后的观察集合仍是原
    Crtos_RTrans；只是本次具名CriticalAreaLock环境合同在acquisition过滤
    用户排除的行为。guard同时限制nrm和err，不声称可从ordinary合同证明。
    不使用对RTrans=True的全部状态断言对象存活的不可满足前提，也不冻结
    其他状态；后续受限acquisition重新应用对应guard。 *)
Definition mutex_delete_scoped_atomic {A : Type}
    (guard : VarGlobalState -> Prop) (cmd : program VarGlobalState A)
    : program (VarGlobalState -> Prop) A :=
  {| nrm := fun states_before result states_after =>
       exists before after,
         states_before before /\ guard before /\ cmd.(nrm) before result after /\
         (forall current, states_after current <-> Crtos_RTrans after current);
     err := fun states_before =>
       exists before, states_before before /\ guard before /\ cmd.(err) before |}.

(** LinklistResumeAll自己的真实lock/unlock：A1保证查到的分配对象仍登记，
    但lookup后到此处的队列及标量可由环境改变。 *)
Definition abs_mutex_resume_all (p id : Z)
    : program (VarGlobalState -> Prop) unit :=
  abs_linklist_resume_all (PendMutex p id).

(** _MutexDelete的第二次真实lock/unlock：A1/A2只保留对象身份与空pending，
    其余当前状态重新读取。该纯程序自身不提供free的字节资源权限。 *)
Definition abs_mutex_retire (p id : Z)
    : program (VarGlobalState -> Prop) unit :=
  mutex_delete_scoped_atomic (mutex_delete_drained p id)
    (abs_mutex_retire_locked p id).

(** 原helper分成两段独立临界区；free在最后解锁后消费私有退休对象，
    不改变共享抽象状态。本路径没有DO_KTASK_ASSIGN。 *)
Definition abs_mutex_delete_object_with_id (p id : Z)
    : program (VarGlobalState -> Prop) unit :=
  abs_mutex_resume_all p id ;; abs_mutex_retire p id.

(** 完整路径：负ID直接返回，普通锁查询未命中直接返回，命中后按A1/A2
    组合drain与注销。三个临界区没有压成一次原子操作；函数契约在C中。 *)
Definition abs_mutex_delete (id : Z) : program (VarGlobalState -> Prop) unit :=
  if Z.ltb id 0 then @MonadErr.ret (VarGlobalState -> Prop) unit tt else
  found <- task_atomic_cmd (abs_mutex_delete_lookup_locked id) ;;
  match found with
  | None => @MonadErr.ret (VarGlobalState -> Prop) unit tt
  | Some (p, key) => abs_mutex_delete_object_with_id p key
  end.

(** 注销并摘管理链后的完整私有对象。m取自最后注销临界区，不能使用lookup
    或drain的过时标量。id.id=65535，两个外部link及空pending哨兵自环；
    四个值字段与padding保持，覆盖全部36字节。holder仅是指针值，不拥有
    pointee。对象从os_inv中移出，可frame过解锁，再以原malloc基址free。 *)
Definition MutexRetired (m : MutexAbs) : Assertion :=
  let p := m.(mutex_addr) in
  “ p <> 0 /\ addr_aligned p 4 /\ m.(mutex_pending_addrs) = nil /\
    &(p # "Mutex" ->ₛ "id" .ₛ "link") <> 0 /\
    &(p # "Mutex" ->ₛ "pend_list") <> 0 /\
    &(p # "Mutex" ->ₛ "link") <> 0 ” &&
  store_idnode (&(p # "Mutex" ->ₛ "id" .ₛ "link"))
    (Build_IdNodeAbs 65535 (&(p # "Mutex" ->ₛ "id"))) **
  store_node_self_linked (&(p # "Mutex" ->ₛ "id" .ₛ "link")) **
  &(p # "Mutex" ->ₛ "val") # UShort |-> m.(mutex_value) **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> m.(mutex_recursive_count) **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> m.(mutex_original_priority) **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> m.(mutex_holder) **
  store_node_self_linked (&(p # "Mutex" ->ₛ "pend_list")) **
  store_node_self_linked (&(p # "Mutex" ->ₛ "link")) ** MutexPadding p.

(** 以下Definition仅是待证命题，不能作为已证明事实应用。
    本阶段仅编译/审阅陈述，证明留到未来用户批准的implement。 *)
Definition mutex_retired_raw_obligation : Prop :=
  forall m, MutexRetired m |-- MutexRaw m.(mutex_addr).

(** 从真实合法资源和登记对象出发，连接逐个wakeup与整体效果，不对任意
    损坏状态声称等价。 *)
Definition mutex_resume_all_steps_effect_obligation : Prop :=
  forall sg before m after,
    In m before.(os_mutexes) ->
    os_inv sg before |--
      “ (mutex_resume_all_steps m.(mutex_addr) m.(mutex_pending_addrs) before after <->
         mutex_resume_all_effect m.(mutex_addr) m.(mutex_id)
           m.(mutex_pending_addrs) before after) ”.

(** 派生manager的注销操作与IdRemoveObj一致；地址和ID唯一性均须从原资源
    导出，不能把这个statement当作已经建立的不变量。 *)
Definition mutex_delete_manager_obligation : Prop :=
  forall sg before m,
    In m before.(os_mutexes) -> m.(mutex_pending_addrs) = nil ->
    os_inv sg before |--
      “ mutex_manager (mutex_delete_unpublish m.(mutex_addr) before.(os_mutexes)) =
        idmanager_remove sg.(os_mutex_stable).(mutex_manager_stable)
          (mutex_manager before.(os_mutexes)) m.(mutex_id) ”.

(** 非真空义务：合法登记对象的drain有正常后态，并仍是同一登记空链对象。
    它与A1/A2的环境选择是不同问题，不能靠环境假设代替循环效果的证明。 *)
Definition mutex_resume_all_enabled_obligation : Prop :=
  forall sg before p id,
    mutex_delete_live p id before ->
    os_inv sg before |-- “ exists after,
      (abs_mutex_resume_all_locked p id).(nrm) before tt after /\
      mutex_delete_drained p id after ”.

(** 复用既有mutex_create_frame的精确非Mutex资源，不另复制第二份全局
    frame；名字虽来自创建，footprint正好是这里借出Mutex模块后的剩余。
    这是split陈述，绝不在两边同时拥有同一对象。 *)
Definition mutex_delete_split_obligation : Prop :=
  forall sg before,
    os_inv sg before |-- mutex_create_frame sg before **
      mutex_inv (pure_suspend_sched_link before.(os_tasks).(task_desc_map))
        sg.(os_mutex_stable) before.(os_mutexes).

(** C已经完成IdRemoveObj和管理DLL摘链后的重组接口。入参逐项给出实际
    修改后的manager、剩余管理DLL、借出的payload、两条已脱离自环link和
    ID值65535。重组出更新的os_inv及唯一私有退休对象；不是从旧os_inv
    凭空变出新heap。纯m.pending=nil确保没有未转移的等待task节点。
    地址唯一性和manager等式须在拆毁旧资源前从原空间资源/上一待证桥
    导出并跨C调用保留；否则旧纯状态可虚构同地址的另一非空等待队列，
    删除后的资源无法反推它从未存在。此处NoDup只为保证仅移除m的空队列，
    不加到公开Require。其他模块和未触及字节来自原frame。 *)
Definition mutex_delete_restore_obligation : Prop :=
  forall sg before m,
    In m before.(os_mutexes) -> m.(mutex_pending_addrs) = nil ->
    NoDup (map mutex_addr before.(os_mutexes)) ->
    mutex_manager (mutex_delete_unpublish m.(mutex_addr) before.(os_mutexes)) =
      idmanager_remove sg.(os_mutex_stable).(mutex_manager_stable)
        (mutex_manager before.(os_mutexes)) m.(mutex_id) ->
    let p := m.(mutex_addr) in
    let ms := sg.(os_mutex_stable) in
    let wait := pure_suspend_sched_link before.(os_tasks).(task_desc_map) in
    mutex_create_frame sg before **
    store_idmanager ms.(mutex_manager_stable)
      (idmanager_remove ms.(mutex_manager_stable)
        (mutex_manager before.(os_mutexes)) m.(mutex_id)) ms.(mutex_manager_ptr) **
    store_dll (store_mutex wait) ms.(mutex_list_head)
      (map mutex_link_node (mutex_delete_unpublish p before.(os_mutexes))) **
    store_mutex wait (&(p # "Mutex" ->ₛ "link")) m **
    store_node_self_linked (&(p # "Mutex" ->ₛ "link")) **
    store_idnode (&(p # "Mutex" ->ₛ "id" .ₛ "link"))
      (Build_IdNodeAbs 65535 (&(p # "Mutex" ->ₛ "id"))) **
    store_node_self_linked (&(p # "Mutex" ->ₛ "id" .ₛ "link"))
    |-- os_inv sg (replace_mutexes
          (mutex_delete_unpublish p before.(os_mutexes)) before) ** MutexRetired m.

(** 批量唤醒的纯一致性桥：来源sched节点转到ready，任务map状态同步，
    其他模块的任务关联仍成立。此义务仅断言纯world条件，不用纯effect
    直接兑换任何修改后的heap；具体字段更新与空间重组仍需实现阶段证明。 *)
Definition mutex_resume_all_world_obligation : Prop :=
  forall sg before m after,
    In m before.(os_mutexes) ->
    mutex_resume_all_effect m.(mutex_addr) m.(mutex_id)
      m.(mutex_pending_addrs) before after ->
    os_inv sg before |-- “ os_world_wf sg after ”.

(** 从旧管理DLL的互斥对象字段权限导出地址唯一性，供restore跨删除保留。
    该命题须在旧资源完整时证明/使用，不把NoDup额外加到函数Require。 *)
Definition mutex_delete_addresses_unique_obligation : Prop :=
  forall sg before, os_inv sg before |--
    “ NoDup (map mutex_addr before.(os_mutexes)) ”.

