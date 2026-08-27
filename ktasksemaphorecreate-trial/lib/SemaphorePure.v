Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Relations.Relation_Operators.
From SimpleC.SL Require Import SeparationLogic.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.

(**
  一个等待者记录 semaphore pend-list 中实际被容器接管的调度链节点，
  同时保留所属任务地址与当前优先级。KTaskPrioSet 可在不重排 pend-list
  的情况下修改该优先级，所以链表顺序本身不带永久排序不变量。
*)
Record SemaphoreWaiter : Type := Build_SemaphoreWaiter {
  sem_waiter_link : addr;
  sem_waiter_task : addr;
  sem_waiter_priority : Z
}.

(**
  [SemaphoreObject] 是客户端可观察的单个 semaphore 状态。全局链表顺序
  由外层 list 顺序表示；对象记录保存裸 ID、动态对象地址、16 位计数与
  pend-list 顺序。ID 可在删除后复用，这是源码允许的 ABA 行为。
*)
Record SemaphoreObject : Type := Build_SemaphoreObject {
  sem_object_id : Z;
  sem_object_addr : addr;
  sem_object_value : Z;
  sem_object_waiters : list SemaphoreWaiter
}.

(** sched-link 在 semaphore 与外部 Task port 之间的跨模块 owner 状态。 *)
Inductive SemaphoreTaskLinkOwner : Type :=
| SEM_TASK_READY
| SEM_TASK_RUNNING
| SEM_TASK_WAITING (sem_addr : addr)
| SEM_TASK_OTHER.

(**
  Task/Delay/ready direct-callee interface 提供给 semaphore 的投影。它只记录
  跨模块协议真正需要的身份、当前优先级、link owner 与 delay membership；
  TaskDescriptor 其余内存仍由对应模块 predicate 独占。
*)
Record SemaphoreTaskBoundary : Type := Build_SemaphoreTaskBoundary {
  sem_task_addr : addr;
  sem_task_sched_link : addr;
  sem_task_current_priority : Z;
  sem_task_link_owner : SemaphoreTaskLinkOwner;
  sem_task_exstatus : Z;
  sem_task_delay_active : bool
}.

(**
  semaphore 模块抽象状态：对象 projection 加上 external Task port boundary。
  Task/ready/Delay 的 concrete heap 不由本状态或本模块 predicate 持有。
  外层对象 list 仍按 [k_sem_list] 表头顺序排列。
*)
Record SemaphoreState : Type := Build_SemaphoreState {
  sem_objects : list SemaphoreObject;
  sem_task_boundary : list SemaphoreTaskBoundary
}.

(**
  固定当前验证配置及所有静态对象地址。普通 API 状态变化必须复用同一
  [SemaphoreStable]，不能改变 ID 容量、哈希桶数或全局符号地址。
*)
Record SemaphoreStable : Type := Build_SemaphoreStable {
  sem_id_max : Z;
  sem_bucket_count : Z;
  sem_manager_addr : addr;
  sem_bitmap_addr : addr;
  sem_buckets_addr : addr;
  sem_list_head_addr : addr;
  sem_done_addr : addr
}.

(** 当前 KD233 LP64、非 SMP verification slice 的唯一稳定配置来源。 *)
Definition semaphore_fixed_stable : SemaphoreStable :=
  Build_SemaphoreStable
    128 16 &("k_sem_id_manager") &("__id_map_k_sem_id_manager")
    &("__htable_k_sem_id_manager") &("k_sem_list") &("done").

Definition semaphore_ids (st : SemaphoreState) : list Z :=
  map sem_object_id st.(sem_objects).

Definition semaphore_addrs (st : SemaphoreState) : list addr :=
  map sem_object_addr st.(sem_objects).

Definition semaphore_waiter_links (st : SemaphoreState) : list addr :=
  List.concat
    (map (fun sem => map sem_waiter_link sem.(sem_object_waiters))
         st.(sem_objects)).

Definition semaphore_id_used (st : SemaphoreState) (id : Z) : Prop :=
  In id (semaphore_ids st).

(** [semaphore_min_free_id] 精确描述 [AllocId] 从低到高选择首个空闲位。 *)
Definition semaphore_min_free_id
    (sg : SemaphoreStable) (st : SemaphoreState) (id : Z) : Prop :=
  0 <= id < sg.(sem_id_max) /\
  ~ semaphore_id_used st id /\
  forall lower, 0 <= lower < id -> semaphore_id_used st lower.

Definition semaphore_task_addrs (st : SemaphoreState) : list addr :=
  map sem_task_addr st.(sem_task_boundary).

Definition semaphore_task_links (st : SemaphoreState) : list addr :=
  map sem_task_sched_link st.(sem_task_boundary).

(** CONTAINER_OF 反算 TaskDescriptor 所需的精确 embedded-link 地址关系。 *)
Definition semaphore_waiter_layout_ok (waiter : SemaphoreWaiter) : Prop :=
  let task := waiter.(sem_waiter_task) in
  waiter.(sem_waiter_link) =
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "sched_link").

Definition semaphore_waiter_matches_task
    (sem : SemaphoreObject) (waiter : SemaphoreWaiter)
    (task : SemaphoreTaskBoundary) : Prop :=
  task.(sem_task_addr) = waiter.(sem_waiter_task) /\
  task.(sem_task_sched_link) = waiter.(sem_waiter_link) /\
  task.(sem_task_current_priority) = waiter.(sem_waiter_priority) /\
  task.(sem_task_link_owner) = SEM_TASK_WAITING sem.(sem_object_addr) /\
  task.(sem_task_exstatus) = 0.

Definition semaphore_task_boundary_entry_valid
    (task : SemaphoreTaskBoundary) : Prop :=
  let p := task.(sem_task_addr) in
  p <> 0 /\
  task.(sem_task_sched_link) =
    &(p # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "sched_link") /\
  0 <= task.(sem_task_current_priority) < 256.

Definition semaphore_waiters_match_tasks
    (objects : list SemaphoreObject)
    (tasks : list SemaphoreTaskBoundary) : Prop :=
  forall sem waiter,
    In sem objects ->
    In waiter sem.(sem_object_waiters) ->
    exists task,
      In task tasks /\ semaphore_waiter_matches_task sem waiter task.

(**
  反向约束保证 boundary 中标成 semaphore-waiting 的 sched-link 必且只在
  相应 pend-list 中；READY/OTHER link 不能同时被任何 semaphore 接管。
*)
Definition semaphore_tasks_match_waiters
    (objects : list SemaphoreObject)
    (tasks : list SemaphoreTaskBoundary) : Prop :=
  forall task,
    In task tasks ->
    match task.(sem_task_link_owner) with
    | SEM_TASK_WAITING sem_addr =>
        exists sem waiter,
          In sem objects /\
          sem.(sem_object_addr) = sem_addr /\
          In waiter sem.(sem_object_waiters) /\
          semaphore_waiter_matches_task sem waiter task
    | SEM_TASK_READY | SEM_TASK_RUNNING | SEM_TASK_OTHER =>
        ~ In task.(sem_task_sched_link)
            (List.concat
              (map (fun sem => map sem_waiter_link sem.(sem_object_waiters))
                   objects))
    end.

Definition semaphore_object_valid
    (sg : SemaphoreStable) (sem : SemaphoreObject) : Prop :=
  0 <= sem.(sem_object_id) < sg.(sem_id_max) /\
  sem.(sem_object_addr) <> 0 /\
  0 <= sem.(sem_object_value) < 65536 /\
  Forall
    (fun waiter =>
       waiter.(sem_waiter_link) <> 0 /\
       waiter.(sem_waiter_task) <> 0 /\
       0 <= waiter.(sem_waiter_priority) < 256 /\
       semaphore_waiter_layout_ok waiter)
    sem.(sem_object_waiters) /\
  (sem.(sem_object_waiters) <> [] -> sem.(sem_object_value) = 0).

(**
  有效性把 semaphore heap projection 与 Task/Delay 边界投影组合起来：
  每个 pend node 可唯一恢复 TaskDescriptor，且该 sched-link 的 owner 是
  对应 semaphore。Task/Delay 的其余 concrete bytes 不在本 predicate 中。
*)
Definition semaphore_state_valid
    (sg : SemaphoreStable) (st : SemaphoreState) : Prop :=
  sg.(sem_id_max) = 128 /\
  sg.(sem_bucket_count) = 16 /\
  Forall (semaphore_object_valid sg) st.(sem_objects) /\
  NoDup (semaphore_ids st) /\
  NoDup (semaphore_addrs st) /\
  NoDup (semaphore_waiter_links st) /\
  Forall semaphore_task_boundary_entry_valid st.(sem_task_boundary) /\
  NoDup (semaphore_task_addrs st) /\
  NoDup (semaphore_task_links st) /\
  semaphore_waiters_match_tasks st.(sem_objects) st.(sem_task_boundary) /\
  semaphore_tasks_match_waiters st.(sem_objects) st.(sem_task_boundary).

Definition waiter_is_in (waiters : list SemaphoreWaiter)
    (task : SemaphoreTaskBoundary) : bool :=
  existsb
    (fun waiter => Z.eqb waiter.(sem_waiter_link) task.(sem_task_sched_link))
    waiters.

Definition semaphore_task_not_waiting
    (task : SemaphoreTaskBoundary) : Prop :=
  match task.(sem_task_link_owner) with
  | SEM_TASK_WAITING _ => False
  | SEM_TASK_READY | SEM_TASK_RUNNING | SEM_TASK_OTHER => True
  end.

(** LinklistSuspend 只可从真实 current/RUNNING 或源码接受的 READY 源接管。 *)
Definition semaphore_task_suspend_source
    (task : SemaphoreTaskBoundary) : Prop :=
  task.(sem_task_link_owner) = SEM_TASK_RUNNING \/
  task.(sem_task_link_owner) = SEM_TASK_READY.

(** Resume/ResumeAll 把指定 waiter links 交回 ready owner 并取消 delay。 *)
Definition resume_task_if_waiting
    (status : Z) (waiters : list SemaphoreWaiter)
    (task : SemaphoreTaskBoundary)
    : SemaphoreTaskBoundary :=
  if waiter_is_in waiters task then
    Build_SemaphoreTaskBoundary
      task.(sem_task_addr) task.(sem_task_sched_link)
      task.(sem_task_current_priority) SEM_TASK_READY status false
  else task.

Definition resume_waiters
    (status : Z) (waiters : list SemaphoreWaiter)
    (tasks : list SemaphoreTaskBoundary)
    : list SemaphoreTaskBoundary :=
  map (resume_task_if_waiting status waiters) tasks.

(** ready vector 只有 32 个 buckets；源码允许写入任意 uint8 priority，但
    priority>=32 的 suspended task 不存在内存安全的 wake transition。 *)
Definition semaphore_waiters_ready_safe
    (waiters : list SemaphoreWaiter) : Prop :=
  Forall (fun waiter => 0 <= waiter.(sem_waiter_priority) < 32) waiters.

Definition waiter_insert_point
    (left right : list SemaphoreWaiter) (priority : Z) : Prop :=
  Forall (fun old => old.(sem_waiter_priority) <= priority) left /\
  match right with
  | [] => True
  | first :: _ => priority < first.(sem_waiter_priority)
  end.

(**
  [semaphore_step] 汇总整个 semaphore 模块与 timeout 回收路径允许的一次
  抽象变化。Create/Delete 操作保持列表的真实插入或删除位置；计数递减、
  abandon 的 16 位回绕、SetValue 清空等待者以及 timeout 移除单个 waiter
  都按当前 C 实现建模，而非按注释中的理想行为建模。
*)
Inductive semaphore_step (sg : SemaphoreStable)
    : SemaphoreState -> SemaphoreState -> Prop :=
| SemStepCreate : forall before id sem_addr value,
    semaphore_min_free_id sg before id ->
    sem_addr <> 0 ->
    ~ In sem_addr (semaphore_addrs before) ->
    0 <= value < 65536 ->
    semaphore_step sg before
      (Build_SemaphoreState
        (Build_SemaphoreObject id sem_addr value [] :: before.(sem_objects))
        before.(sem_task_boundary))
| SemStepDelete : forall prefix sem suffix tasks,
    semaphore_waiters_ready_safe sem.(sem_object_waiters) ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix) tasks)
      (Build_SemaphoreState (prefix ++ suffix)
        (resume_waiters (-1) sem.(sem_object_waiters) tasks))
| SemStepObtainCount : forall prefix sem suffix tasks,
    0 < sem.(sem_object_value) ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix) tasks)
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr)
           (sem.(sem_object_value) - 1) sem.(sem_object_waiters) :: suffix)
        tasks)
| SemStepObtainWait : forall
    prefix sem suffix left waiter right
    task_prefix task task_suffix delay_after,
    sem.(sem_object_value) = 0 ->
    sem.(sem_object_waiters) = left ++ right ->
    waiter_insert_point left right waiter.(sem_waiter_priority) ->
    waiter.(sem_waiter_task) = task.(sem_task_addr) ->
    waiter.(sem_waiter_link) = task.(sem_task_sched_link) ->
    waiter.(sem_waiter_priority) = task.(sem_task_current_priority) ->
    semaphore_task_suspend_source task ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix)
        (task_prefix ++ task :: task_suffix))
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr) 0
           (left ++ waiter :: right) :: suffix)
        (task_prefix ++
         Build_SemaphoreTaskBoundary
           task.(sem_task_addr) task.(sem_task_sched_link)
           task.(sem_task_current_priority)
           (SEM_TASK_WAITING sem.(sem_object_addr)) 0 delay_after :: task_suffix))
| SemStepAbandonWait : forall
    prefix sem suffix waiter rest task_prefix task task_suffix,
    sem.(sem_object_waiters) = waiter :: rest ->
    0 <= waiter.(sem_waiter_priority) < 32 ->
    semaphore_waiter_matches_task sem waiter task ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix)
        (task_prefix ++ task :: task_suffix))
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr)
           sem.(sem_object_value) rest :: suffix)
        (task_prefix ++
         Build_SemaphoreTaskBoundary
           task.(sem_task_addr) task.(sem_task_sched_link)
           task.(sem_task_current_priority) SEM_TASK_READY 0 false :: task_suffix))
| SemStepAbandonCount : forall prefix sem suffix tasks,
    sem.(sem_object_waiters) = [] ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix) tasks)
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr)
           ((sem.(sem_object_value) + 1) mod 65536) [] :: suffix)
        tasks)
| SemStepSetValue : forall prefix sem suffix value tasks,
    sem.(sem_object_value) <> value ->
    0 <= value < 65536 ->
    semaphore_waiters_ready_safe sem.(sem_object_waiters) ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix) tasks)
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr) value [] :: suffix)
        (resume_waiters (-1) sem.(sem_object_waiters) tasks))
| SemStepTimeout : forall
    prefix sem suffix left waiter right task_prefix task task_suffix,
    sem.(sem_object_waiters) = left ++ waiter :: right ->
    0 <= waiter.(sem_waiter_priority) < 32 ->
    semaphore_waiter_matches_task sem waiter task ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix)
        (task_prefix ++ task :: task_suffix))
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr)
           sem.(sem_object_value) (left ++ right) :: suffix)
        (task_prefix ++
         Build_SemaphoreTaskBoundary
           task.(sem_task_addr) task.(sem_task_sched_link)
           task.(sem_task_current_priority) SEM_TASK_READY (-2) false :: task_suffix))
| SemStepTaskPriority : forall
    prefix sem suffix left waiter right
    task_prefix task task_suffix new_priority,
    sem.(sem_object_waiters) = left ++ waiter :: right ->
    semaphore_waiter_matches_task sem waiter task ->
    0 <= new_priority < 256 ->
    semaphore_step sg
      (Build_SemaphoreState (prefix ++ sem :: suffix)
        (task_prefix ++ task :: task_suffix))
      (Build_SemaphoreState
        (prefix ++
         Build_SemaphoreObject
           sem.(sem_object_id) sem.(sem_object_addr) sem.(sem_object_value)
           (left ++
            Build_SemaphoreWaiter waiter.(sem_waiter_link)
              waiter.(sem_waiter_task) new_priority :: right) :: suffix)
        (task_prefix ++
         Build_SemaphoreTaskBoundary
           task.(sem_task_addr) task.(sem_task_sched_link) new_priority
           task.(sem_task_link_owner) task.(sem_task_exstatus)
           task.(sem_task_delay_active) :: task_suffix))
| SemStepTaskPublish : forall objects tasks task,
    semaphore_task_boundary_entry_valid task ->
    semaphore_task_not_waiting task ->
    ~ In task.(sem_task_addr) (map sem_task_addr tasks) ->
    ~ In task.(sem_task_sched_link) (map sem_task_sched_link tasks) ->
    semaphore_step sg
      (Build_SemaphoreState objects tasks)
      (Build_SemaphoreState objects (task :: tasks))
| SemStepTaskRetire : forall objects prefix task suffix,
    semaphore_task_not_waiting task ->
    semaphore_step sg
      (Build_SemaphoreState objects (prefix ++ task :: suffix))
      (Build_SemaphoreState objects (prefix ++ suffix))
| SemStepTaskExternal : forall
    objects prefix task suffix priority owner exstatus delay_active,
    semaphore_task_not_waiting task ->
    (match owner with
     | SEM_TASK_WAITING _ => False
     | SEM_TASK_READY | SEM_TASK_RUNNING | SEM_TASK_OTHER => True
     end) ->
    0 <= priority < 256 ->
    semaphore_step sg
      (Build_SemaphoreState objects (prefix ++ task :: suffix))
      (Build_SemaphoreState objects
        (prefix ++
         Build_SemaphoreTaskBoundary
           task.(sem_task_addr) task.(sem_task_sched_link) priority owner
           exstatus delay_active :: suffix)).

Definition semaphore_valid_step (sg : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  semaphore_state_valid sg before /\
  semaphore_step sg before after /\
  semaphore_state_valid sg after.

(**
  Critical STS 使用一次真实模块变化的自反传递闭包。它允许进入 critical
  前观察到其他合法 API 已推进状态；具体函数 spec 仍须另外证明自己的
  精确一步 effect，不能仅凭该闭包任意改写状态。
*)
Definition SemaphoreTransition (sg : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  clos_refl_trans SemaphoreState (semaphore_valid_step sg) before after.
