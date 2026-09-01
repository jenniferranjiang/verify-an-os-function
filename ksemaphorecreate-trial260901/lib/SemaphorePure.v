Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Relations.Relation_Operators.
Require Import Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
From MonadLib.StateRelMonad Require Export StateRelMonad.
Require Export CRTOS_Verify.lib.IdManagerPure.

Import ListNotations.
Import MonadNotation.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope monad.

(** pending DLL 只记录外围 task 地址；任务字段不复制到 semaphore state。 *)
Record SemaphoreWaiter : Type := Build_SemaphoreWaiter {
  waiter_task : addr;
}.

(**
  task 模块在 critical scope 内可线性转交的查询视图。它是
  [task,id,priority,name,exstatus] 与真实 C 字段的唯一关联载体；
  semaphore invariant 本身不持有这些字段。
*)
Record SemaphoreTaskView : Type := Build_SemaphoreTaskView {
  sem_task_addr : addr;
  sem_task_id : Z;
  sem_task_priority : Z;
  sem_task_name : list Z;
  sem_task_exstatus : Z;
}.

(**
  [SemaphoreObject] 对应一个已经发布的 [struct Semaphore]。列表顺序是
  [k_sem_list] 的物理顺序，等待者列表保存 pending DLL 的当前物理顺序；ID
  bucket 和 bitmap 都由这些对象派生，不另存第二份业务状态。
*)
Record SemaphoreObject : Type := Build_SemaphoreObject {
  semaphore_addr : addr;
  semaphore_id : Z;
  semaphore_value : Z;
  semaphore_waiters : list SemaphoreWaiter;
}.

(**
  [SemaphoreDoneAbs] 保存静态 dispatch 表的五个函数地址。C 初始化后不再
  修改该表；空间所有权由 representation 文件中的独立谓词提供。
*)
Record SemaphoreDoneAbs : Type := Build_SemaphoreDoneAbs {
  sem_done_create : addr;
  sem_done_delete : addr;
  sem_done_obtain : addr;
  sem_done_abandon : addr;
  sem_done_set_value : addr;
}.

(**
  [SemaphoreStable] 只保存当前配置正常运行阶段不变的地址、容量和 dispatch
  内容。它是纯逻辑值，不提供任何 C 内存权限。
*)
Record SemaphoreStable : Type := Build_SemaphoreStable {
  sem_manager_addr : addr;
  sem_bitmap_addr : addr;
  sem_buckets_addr : addr;
  sem_list_head_addr : addr;
  sem_done_addr : addr;
  sem_id_max : Z;
  sem_bucket_count : Z;
  sem_done_abs : SemaphoreDoneAbs;
}.

(** 当前 semaphore 模块的可变抽象状态只有已经发布对象的有序集合。 *)
Record SemaphoreState : Type := Build_SemaphoreState {
  sem_objects : list SemaphoreObject;
}.

Definition semaphore_ids (objects : list SemaphoreObject) : list Z :=
  map semaphore_id objects.

Definition semaphore_addrs (objects : list SemaphoreObject) : list addr :=
  map semaphore_addr objects.

Definition semaphore_id_node (sem : SemaphoreObject) : IdNodeAbs :=
  Build_IdNodeAbs sem.(semaphore_id) sem.(semaphore_addr).

Definition semaphore_id_nodes
    (objects : list SemaphoreObject) : list IdNodeAbs :=
  map semaphore_id_node objects.

Definition waiter_tasks (waiters : list SemaphoreWaiter) : list addr :=
  map waiter_task waiters.

Definition semaphore_task_view_addrs
    (views : list SemaphoreTaskView) : list addr :=
  map sem_task_addr views.

Definition semaphore_task_view_ids
    (views : list SemaphoreTaskView) : list Z :=
  map sem_task_id views.

Definition semaphore_task_view_wf (view : SemaphoreTaskView) : Prop :=
  view.(sem_task_addr) <> 0 /\
  0 <= view.(sem_task_id) < 128 /\
  0 <= view.(sem_task_priority) <= 255 /\
  Zlength view.(sem_task_name) = 32 /\
  Forall (fun byte => 0 <= byte <= 255) view.(sem_task_name) /\
  -2147483648 <= view.(sem_task_exstatus) <= 2147483647.

Definition semaphore_task_views_wf
    (views : list SemaphoreTaskView) : Prop :=
  Forall semaphore_task_view_wf views /\
  NoDup (semaphore_task_view_addrs views) /\
  NoDup (semaphore_task_view_ids views).

Definition semaphore_task_lookup
    (views : list SemaphoreTaskView) (task : addr)
    (view : SemaphoreTaskView) : Prop :=
  In view views /\ view.(sem_task_addr) = task.

Definition semaphore_waiter_has_view
    (views : list SemaphoreTaskView) (waiter : SemaphoreWaiter) : Prop :=
  exists view, semaphore_task_lookup views waiter.(waiter_task) view.

Definition semaphore_task_views_cover
    (views : list SemaphoreTaskView) (waiters : list SemaphoreWaiter) : Prop :=
  semaphore_task_views_wf views /\
  Forall (semaphore_waiter_has_view views) waiters.

Definition semaphore_waiter_wf (waiter : SemaphoreWaiter) : Prop :=
  waiter.(waiter_task) <> 0.

Definition semaphore_object_wf
    (sg : SemaphoreStable) (sem : SemaphoreObject) : Prop :=
  sem.(semaphore_addr) <> 0 /\
  0 <= sem.(semaphore_id) < sg.(sem_id_max) /\
  0 <= sem.(semaphore_value) <= 65535 /\
  Forall semaphore_waiter_wf sem.(semaphore_waiters) /\
  NoDup (waiter_tasks sem.(semaphore_waiters)).

Definition semaphore_all_waiter_tasks
    (objects : list SemaphoreObject) : list addr :=
  List.concat (map (fun sem => waiter_tasks sem.(semaphore_waiters)) objects).

Definition semaphore_all_waiters
    (objects : list SemaphoreObject) : list SemaphoreWaiter :=
  List.concat (map semaphore_waiters objects).

(**
  [semaphore_world_wf] 连接公开对象、ID manager 和 pending membership 的
  纯语义：对象地址与 ID 唯一，每个对象及其等待队列均满足当前配置范围。
  它不拥有内存，实际 ownership 在 [semaphore_inv] 中给出。
*)
Definition semaphore_world_wf
    (sg : SemaphoreStable) (st : SemaphoreState) : Prop :=
  sg.(sem_id_max) = 128 /\
  sg.(sem_bucket_count) = 16 /\
  NoDup (semaphore_addrs st.(sem_objects)) /\
  NoDup (semaphore_ids st.(sem_objects)) /\
  Forall (semaphore_object_wf sg) st.(sem_objects) /\
  NoDup (semaphore_all_waiter_tasks st.(sem_objects)).

(** 绑定当前非 SMP 配置中的真实全局 symbol、容量和静态 dispatch。 *)
Definition SemaphoreStableContext (sg : SemaphoreStable) : Prop :=
  sg.(sem_manager_addr) = &("k_sem_id_manager") /\
  sg.(sem_bitmap_addr) = &("__id_map_k_sem_id_manager") /\
  sg.(sem_buckets_addr) = &("__htable_k_sem_id_manager") /\
  sg.(sem_list_head_addr) = &("k_sem_list") /\
  sg.(sem_done_addr) = &("done") /\
  sg.(sem_id_max) = 128 /\
  sg.(sem_bucket_count) = 16 /\
  sg.(sem_done_abs).(sem_done_create) = &("_SemaphoreCreate") /\
  sg.(sem_done_abs).(sem_done_delete) = &("_SemaphoreDelete") /\
  sg.(sem_done_abs).(sem_done_obtain) = &("_SemaphoreObtain") /\
  sg.(sem_done_abs).(sem_done_abandon) = &("_SemaphoreAbandon") /\
  sg.(sem_done_abs).(sem_done_set_value) = &("_SemaphoreSetValue").

(** 把 semaphore 稳定地址投影为通用 ID-manager 的固定配置。 *)
Definition semaphore_id_stable (sg : SemaphoreStable) : StableIdManager :=
  Build_StableIdManager
    sg.(sem_id_max) sg.(sem_bucket_count)
    sg.(sem_bitmap_addr) sg.(sem_buckets_addr).

(**
  [id_manager_matches_semaphores] 连接通用 manager state 与 published
  semaphore 集合；bucket 顺序由 manager 自身 wf 管理，这里只要求 ID 和
  `(id,address)` nodes 与公开对象互为排列。
*)
Definition id_manager_matches_semaphores
    (st : SemaphoreState) (idm : IdManagerState) : Prop :=
  Permutation idm.(id_manager_ids) (semaphore_ids st.(sem_objects)) /\
  Permutation (id_manager_nodes idm) (semaphore_id_nodes st.(sem_objects)).

Fixpoint semaphore_find
    (id : Z) (objects : list SemaphoreObject) : option SemaphoreObject :=
  match objects with
  | nil => None
  | sem :: rest =>
      if Z.eq_dec sem.(semaphore_id) id
      then Some sem
      else semaphore_find id rest
  end.

Fixpoint semaphore_remove
    (id : Z) (objects : list SemaphoreObject) : list SemaphoreObject :=
  match objects with
  | nil => nil
  | sem :: rest =>
      if Z.eq_dec sem.(semaphore_id) id
      then semaphore_remove id rest
      else sem :: semaphore_remove id rest
  end.

Fixpoint semaphore_replace
    (updated : SemaphoreObject)
    (objects : list SemaphoreObject) : list SemaphoreObject :=
  match objects with
  | nil => nil
  | sem :: rest =>
      if Z.eq_dec sem.(semaphore_id) updated.(semaphore_id)
      then updated :: rest
      else sem :: semaphore_replace updated rest
  end.

Definition semaphore_with_value
    (sem : SemaphoreObject) (value : Z) : SemaphoreObject :=
  Build_SemaphoreObject
    sem.(semaphore_addr) sem.(semaphore_id) value sem.(semaphore_waiters).

Definition semaphore_with_waiters
    (sem : SemaphoreObject)
    (waiters : list SemaphoreWaiter) : SemaphoreObject :=
  Build_SemaphoreObject
    sem.(semaphore_addr) sem.(semaphore_id) sem.(semaphore_value) waiters.

Definition semaphore_state_add
    (sem : SemaphoreObject) (before : SemaphoreState) : SemaphoreState :=
  Build_SemaphoreState (sem :: before.(sem_objects)).

Definition semaphore_state_remove
    (id : Z) (before : SemaphoreState) : SemaphoreState :=
  Build_SemaphoreState (semaphore_remove id before.(sem_objects)).

Definition semaphore_state_replace
    (sem : SemaphoreObject) (before : SemaphoreState) : SemaphoreState :=
  Build_SemaphoreState (semaphore_replace sem before.(sem_objects)).

Definition semaphore_id_used (id : Z) (st : SemaphoreState) : Prop :=
  In id (semaphore_ids st.(sem_objects)).

(** [semaphore_min_free_id] 对应 [AllocId] 从低地址 bitmap byte 开始扫描。 *)
Definition semaphore_min_free_id
    (sg : SemaphoreStable) (st : SemaphoreState) (id : Z) : Prop :=
  0 <= id < sg.(sem_id_max) /\
  ~ semaphore_id_used id st /\
  forall earlier,
    0 <= earlier < id -> semaphore_id_used earlier st.

Definition semaphore_full
    (sg : SemaphoreStable) (st : SemaphoreState) : Prop :=
  forall id, 0 <= id < sg.(sem_id_max) -> semaphore_id_used id st.

(** 从等待队列中精确删除指定 task 的第一个节点。 *)
Fixpoint semaphore_remove_waiter
    (task : addr) (waiters : list SemaphoreWaiter)
    : option (list SemaphoreWaiter) :=
  match waiters with
  | nil => None
  | waiter :: rest =>
      if Z.eq_dec waiter.(waiter_task) task
      then Some rest
      else
        match semaphore_remove_waiter task rest with
        | None => None
        | Some updated => Some (waiter :: updated)
        end
  end.

Definition semaphore_waiter_view
    (views : list SemaphoreTaskView) (waiter : SemaphoreWaiter)
    (view : SemaphoreTaskView) : Prop :=
  semaphore_task_lookup views waiter.(waiter_task) view.

(**
  [LinklistSuspend(..., LINKLIST_FLAG_PRIO)] 扫描到第一个严格低于
  新 task priority 的节点前停止。既有 pending task 可被
  [_KTaskPrioSet] 修改，因此此关系只精确描述当次扫描，不声称
  队列持久 Sorted。
*)
Definition semaphore_waiter_insert_by_priority
    (views : list SemaphoreTaskView) (fresh : SemaphoreWaiter)
    (before after : list SemaphoreWaiter) : Prop :=
  exists (prefix suffix : list SemaphoreWaiter)
         (fresh_view : SemaphoreTaskView),
    before = List.app prefix suffix /\
    after = List.app prefix (fresh :: suffix) /\
    semaphore_waiter_view views fresh fresh_view /\
    Forall
      (fun waiter =>
        exists view,
          semaphore_waiter_view views waiter view /\
          view.(sem_task_priority) <= fresh_view.(sem_task_priority))
      prefix /\
    match suffix with
    | nil => True
    | first :: _ =>
        exists first_view,
          semaphore_waiter_view views first first_view /\
          fresh_view.(sem_task_priority) < first_view.(sem_task_priority)
    end.

(**
  [SemaphoreAction] 枚举模块全部实现可能提交到临界区协议的局部变化。
  task 模块对 suspend/wakeup/delay/ready 的同步变化由跨模块接口承担，
  不在这里伪装成 semaphore 自有内存。
*)
Inductive SemaphoreAction (sg : SemaphoreStable)
    : SemaphoreState -> SemaphoreState -> Prop :=
| SemStepCreate : forall before sem,
    semaphore_min_free_id sg before sem.(semaphore_id) ->
    sem.(semaphore_waiters) = nil ->
    ~ In sem.(semaphore_addr) (semaphore_addrs before.(sem_objects)) ->
    semaphore_object_wf sg sem ->
    SemaphoreAction sg before (semaphore_state_add sem before)
| SemStepDelete : forall before sem views,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    semaphore_task_views_cover views sem.(semaphore_waiters) ->
    SemaphoreAction sg before (semaphore_state_remove sem.(semaphore_id) before)
| SemStepObtainDecrement : forall before sem,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    0 < sem.(semaphore_value) ->
    SemaphoreAction sg before
      (semaphore_state_replace
        (semaphore_with_value sem (sem.(semaphore_value) - 1)) before)
| SemStepSuspendByPriority : forall before sem views waiter waiters,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    sem.(semaphore_value) = 0 ->
    semaphore_task_views_cover views
      (waiter :: sem.(semaphore_waiters)) ->
    semaphore_waiter_insert_by_priority views waiter
      sem.(semaphore_waiters) waiters ->
    semaphore_object_wf sg (semaphore_with_waiters sem waiters) ->
    SemaphoreAction sg before
      (semaphore_state_replace (semaphore_with_waiters sem waiters) before)
| SemStepWakeHead : forall before sem views waiter rest view,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    sem.(semaphore_waiters) = waiter :: rest ->
    semaphore_task_views_cover views sem.(semaphore_waiters) ->
    semaphore_waiter_view views waiter view ->
    semaphore_object_wf sg (semaphore_with_waiters sem rest) ->
    SemaphoreAction sg before
      (semaphore_state_replace (semaphore_with_waiters sem rest) before)
| SemStepTimeoutRemove : forall before sem views waiter rest,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    semaphore_task_views_cover views sem.(semaphore_waiters) ->
    semaphore_remove_waiter waiter.(waiter_task) sem.(semaphore_waiters) =
      Some rest ->
    semaphore_object_wf sg (semaphore_with_waiters sem rest) ->
    SemaphoreAction sg before
      (semaphore_state_replace (semaphore_with_waiters sem rest) before)
| SemStepAbandonIncrement : forall before sem,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    sem.(semaphore_waiters) = nil ->
    SemaphoreAction sg before
      (semaphore_state_replace
        (semaphore_with_value sem ((sem.(semaphore_value) + 1) mod 65536))
        before)
| SemStepSetSameValue : forall before sem value,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    value = sem.(semaphore_value) ->
    SemaphoreAction sg before before
| SemStepSetValueWakeAll : forall before sem views value,
    semaphore_find sem.(semaphore_id) before.(sem_objects) = Some sem ->
    value <> sem.(semaphore_value) ->
    0 <= value <= 65535 ->
    semaphore_task_views_cover views sem.(semaphore_waiters) ->
    SemaphoreAction sg before
      (semaphore_state_replace
        (semaphore_with_waiters (semaphore_with_value sem value) nil) before).

(** 每一条 rely/guarantee 边都从合法 world 出发并到达合法 world。 *)
Definition SemaphoreStep (sg : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  semaphore_world_wf sg before /\
  SemaphoreAction sg before after /\
  semaphore_world_wf sg after.

(** 环境在两次公开 API 观察之间可执行任意有限个合法 semaphore 步骤。 *)
Definition SemaphoreRTrans (sg : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  clos_refl_trans SemaphoreState (SemaphoreStep sg) before after.

Definition SemaphoreGTrans := SemaphoreStep.

(** 一次外层 critical exit 只能提交恒等或一个精确源码步。 *)
Definition SemaphoreOneCallGTrans (sg : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  before = after \/ SemaphoreStep sg before after.

Definition SemaphoreLastSeen
    (sg : SemaphoreStable) (before : SemaphoreState)
    : SemaphoreState -> Prop :=
  fun current => SemaphoreRTrans sg before current.

(** C 中的 [KTaskOsAssignLockNest] 与 ghost handler 栈长度一致。 *)
Definition semaphore_handler_depth (handlers : list Z) : Z :=
  Z.of_nat (List.length handlers).

(**
  创建失败可能来自 trusted allocator 或 ID 耗尽，均返回 [-ENOMEMORY]
  且不改变 semaphore state；成功严格发布 [AllocId] 选出的最小空闲 ID。
*)
Inductive SemaphoreCreateEffect
    (sg : SemaphoreStable) (value : Z)
    : SemaphoreState -> Z -> SemaphoreState -> Prop :=
| SemaphoreCreateFailure : forall before,
    SemaphoreCreateEffect sg value before (-5) before
| SemaphoreCreateSuccess : forall before sem,
    sem.(semaphore_value) = value ->
    0 <= value <= 65535 ->
    sem.(semaphore_waiters) = nil ->
    semaphore_min_free_id sg before sem.(semaphore_id) ->
    ~ In sem.(semaphore_addr) (semaphore_addrs before.(sem_objects)) ->
    semaphore_object_wf sg sem ->
    SemaphoreCreateEffect sg value before sem.(semaphore_id)
      (semaphore_state_add sem before).

(** [SemaphoreCreateAtomic] 是公开创建 API 使用的原子抽象命令。 *)
Definition SemaphoreCreateAtomic
    (sg : SemaphoreStable) (value : Z)
    : program SemaphoreState Z :=
  fun before result after =>
    SemaphoreCreateEffect sg value before result after.
