Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Import CRTOS_Verify.lib.dll_abs.
Require Import CRTOS_Verify.lib.idnode_abs.
Require Import CRTOS_Verify.lib.KTaskPure.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.

(**
  本文件只定义 [KTaskCreate] 当前所需的纯逻辑状态。
*)

Inductive VirtualTaskStatus : Type :=
  | VTS_NORMAL          (** 正常访问当前任务 *)
  | VTS_CRITICAL.       (** 任务创建尚未完成 *)

(**
  [TaskDoneAbs] 保存 C 中 [struct KTaskDone Done] 的八个函数指针值。

  [Done] 在静态初始化后不再写入。它被记录在 [StableGlobalState]
  中，以便规格把 [task->Done] 与相同的函数表关联起来；STS
  只管理可变共享状态，不拥有该函数表的内存资源。
*)
Record TaskDoneAbs : Type := {
  task_done_init : addr;
  task_done_start : addr;
  task_done_delete : addr;
  task_done_delay : addr;
  task_done_mdelay : addr;
  task_done_prioset : addr;
  task_done_suspend : addr;
  task_done_wake : addr;
}.

(**
  [StableGlobalState] 记录本轮任务共享资源的稳定地址。

  字段与 C 全局对象的对应关系如下：

  - [task_id_bitmap_ptr]：
    [__id_map_k_task_id_manager[0]]；
  - [task_id_htable_ptr]：
    [__htable_k_task_id_manager[0]]；
  - [task_idmanager_ptr]：
    [k_task_id_manager]；
  - [task_list_head]：
    [xiaoshan_task_head]；
  - [task_done_ptr]：
    静态函数表 [Done]。

  该 record 只保存地址值。地址对应的内存所有权由
  [CrtosRules.v] 中的谓词描述。
*)

(* Record StableIDManagerAbs : Type := mk_StableIDManagerAbs {
  id_max_num: Z;
  bucket_num: Z;
  bitmap_ptr : addr;  (** -->  list Z *)
  htable_ptr : addr;  (** -->  list (list Z) *)
}. *)

Record StableGlobalState : Type := {

  task_idmanager_ptr : addr;  (** --> Stable/VarIDManagerAbs *)

  task_list_head : addr;      (** --> task link list: list unit *)

  task_done_ptr : addr;       (** --> TaskDoneAbs *)

  task_done_abs: TaskDoneAbs;

  stable_idmanager_abs: StableIdmanager;
}.

(* Record VarIDManagerAbs : Type := mk_VarIDManagerAbs {
  id_bitmap: list Z;
  id_htable: list (list Z);
}. *)

(** 全局任务注册表以 [TaskDescriptor] 基址及其顺序作为权威纯表示。 *)
Definition TaskAddrList := list addr.

(**
  [TaskDescriptorAbs] 是已经完成初始化并发布到全局不变量的任务抽象。

  [tdStackPoint] 与 [tdStackContext] 描述当前候选设计中的已保存栈上下文；
  [tdBaseInfo] 和 [tdSchedMember] 复用下沉后的纯任务类型；其余字段对应
  TaskDescriptor 中除三个独立嵌入链表节点以外的直接字段。该 record
  本身不拥有内存，空间解释位于 [CrtosInv.v]。
*)
Record TaskDescriptorAbs : Type := Build_TaskDescriptorAbs {
  tdStackPoint : addr;
  tdStackContext : StackRegisterContextAbs;
  tdBaseInfo : TaskBaseInfoAbs;
  tdSchedMember : TaskSchedMemberAbs;
  tdDelay : addr;
  tdEventIdTrigger : Z;
  tdEventMode : Z;
  tdExstatus : Z;
  tdDone : addr;
}.

(**
  [VarGlobalState] 明确区分任务注册、创建阶段与完整描述符发布：

  - [task_ptr_list] 记录已进入全局 task DLL 的 TaskDescriptor 基址；
  - [task_virtual_status] 以任务基址为键记录 Critical/Normal 协议阶段；
  - [task_desc_map] 只为已经最终发布的 Normal 任务保存完整抽象；
  - [task_idmanager_abs] 保存 ID 位图及哈希桶内容。

  因而任务可以已经注册且仍为 Critical，此时 descriptor map 必须为
  [None]；任务完成初始化并变为 Normal 后，map cell 才拥有描述符和栈。
*)
Record VarGlobalState : Type := Build_VarGlobalState {
  task_virtual_status : addr -> VirtualTaskStatus;
  task_idmanager_abs : VarIdmanager;
  task_ptr_list : TaskAddrList;
  task_desc_map : addr -> option TaskDescriptorAbs;
}.

(** 从任务基址直接派生全局 task DLL 使用的嵌入 [task->link] 节点。 *)
Definition task_link_node (task : addr) : DL_Node unit :=
  Build_DL_Node tt (&(task # "TaskDescriptor" ->ₛ "link")).

(** 从权威任务地址顺序派生物理 DLL 节点顺序，不保存第二份可变列表。 *)
Definition task_link_nodes (tasks : TaskAddrList) : list (DL_Node unit) :=
  map task_link_node tasks.

(** 兼容现有局部 DLL 规格使用的只读物理链表投影。 *)
Definition task_link_list (st : VarGlobalState) : list (DL_Node unit) :=
  task_link_nodes st.(task_ptr_list).

(** 汇总 ID manager 各哈希桶中的抽象 ID 节点。 *)
Definition task_id_nodes (st : VarGlobalState) : list IdNodeAbs :=
  List.concat st.(task_idmanager_abs).(idbuckets).

(**
  [task_world_wf] 是正式 Global State 当前所需的最小纯一致性条件。

  注册表成员的 descriptor map 是否存在由其虚拟状态决定；注册表外不能
  存在 map cell。最后一项只把 ID manager 节点地址多重集合与任务地址
  派生的嵌入 [task->id] 地址关联。这里不增加地址非零、[NoDup] 或地址
  唯一性条件；相关重叠由后续 separation-logic 空间断言排除。
*)
Definition task_world_wf (st : VarGlobalState) : Prop :=
  (forall task,
    In task st.(task_ptr_list) ->
    match st.(task_virtual_status) task with
    | VTS_CRITICAL => st.(task_desc_map) task = None
    | VTS_NORMAL =>
        exists desc, st.(task_desc_map) task = Some desc
    end) /\
  (forall task,
    ~ In task st.(task_ptr_list) ->
    st.(task_desc_map) task = None) /\
  Permutation
    (map idnode_addr (task_id_nodes st))
    (map
      (fun task => &(task # "TaskDescriptor" ->ₛ "id"))
      st.(task_ptr_list)).

(**
  [replace_id_manager new_manager before] 只替换 ID 管理器抽象值，
  保持任务管理链表不变。不可变 [Done] 状态位于单独的
  [StableGlobalState]，不受该更新影响。
*)
Definition replace_id_manager
    (new_manager : VarIdmanager)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status := before.(task_virtual_status);
    task_idmanager_abs := new_manager;
    task_ptr_list := before.(task_ptr_list);
    task_desc_map := before.(task_desc_map);
  |}.

(**
  [update_task_id_map ids before] 替换 ID 管理器中的已分配 ID 列表，
  保持 [idmax]、[hoffset] 和哈希桶不变。

  这是描述 [AllocId]/[FreeId] 局部中间状态的辅助函数。单独更新位图
  后，ID 列表与哈希桶可能暂时不满足 [idbuckets_ok]；只有在后续
  哈希桶更新也完成并重新满足 shared 中的合法性条件后，才应折叠回
  完整 [store_idmanager]。
*)
Definition update_task_id_bitmap
    (ids : list Z)
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager ids idm.(idbuckets))
    before.

(**
  [update_task_htable buckets before] 替换 ID 管理器中的哈希桶内容，
  保持 [idmax]、[hoffset] 和已分配 ID 列表不变。

  与 [update_task_id_map] 一样，该函数可以表示内部函数之间的局部
  中间状态；完整临界区操作提交前仍需恢复 [store_idmanager] 所要求
  的位图、ID 列表和桶内容一致性。
*)
Definition update_task_htable
    (buckets : list (list IdNodeAbs))
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager idm.(idlist) buckets)
    before.

(** 只替换权威任务地址顺序；物理 DLL 节点由 [task_link_nodes] 派生。 *)
Definition replace_task_ptr_list
    (tasks : TaskAddrList)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status := before.(task_virtual_status);
    task_idmanager_abs := before.(task_idmanager_abs);
    task_ptr_list := tasks;
    task_desc_map := before.(task_desc_map);
  |}.

(**
  [replace_task_virtual_status phase before] 只替换任务创建协议
  的当前阶段，保持 ID 管理器和任务链表的抽象状态不变。
*)
Definition replace_task_virtual_status
    (vts : addr -> VirtualTaskStatus)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status := vts;
    task_idmanager_abs := before.(task_idmanager_abs);
    task_ptr_list := before.(task_ptr_list);
    task_desc_map := before.(task_desc_map);
  |}.

(** 只替换 descriptor map，保持注册表、ID manager 和虚拟状态不变。 *)
Definition replace_task_desc_map
    (descs : addr -> option TaskDescriptorAbs)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status := before.(task_virtual_status);
    task_idmanager_abs := before.(task_idmanager_abs);
    task_ptr_list := before.(task_ptr_list);
    task_desc_map := descs;
  |}.

(** 按任务基址更新单个虚拟状态，不改变其他地址。 *)
Definition update_task_virtual_status
    (task : addr)
    (status : VirtualTaskStatus)
    (before : addr -> VirtualTaskStatus) : addr -> VirtualTaskStatus :=
  fun current =>
    if Z.eq_dec current task then status else before current.

(** 按任务基址更新单个 descriptor map cell，不改变其他地址。 *)
Definition update_task_desc_map
    (task : addr)
    (value : option TaskDescriptorAbs)
    (before : addr -> option TaskDescriptorAbs)
    : addr -> option TaskDescriptorAbs :=
  fun current =>
    if Z.eq_dec current task then value else before current.

(**
  [task_stack_wf] 保留 KTaskStackSetup 建立的栈地址等式、范围和对齐条件。
  该纯命题不拥有 descriptor 字段或外部任务栈。
*)
Definition task_stack_wf (desc : TaskDescriptorAbs) : Prop :=
  let info := desc.(tdBaseInfo) in
  desc.(tdStackPoint) = kss_context_addr info /\
  ktask_stack_setup_layout_ok
    info.(tbStackStart) info.(tbStackDepth) REG_LENGTH /\
  aligned_reglen desc.(tdStackPoint) /\
  aligned_reglen (kss_aligned_top info).

(** Task Create 成功时栈中应保存的精确初始寄存器上下文和数值范围。 *)
Definition task_create_stack_ready (desc : TaskDescriptorAbs) : Prop :=
  let info := desc.(tdBaseInfo) in
  task_stack_wf desc /\
  desc.(tdStackContext) =
    ktask_stack_context_region
      info.(tbFuncEntry) info.(tbFuncParam) &("KTaskQuit") /\
  ktask_xubase_value info.(tbFuncEntry) /\
  ktask_xubase_value info.(tbFuncParam) /\
  ktask_xubase_value &("KTaskQuit").

(** 最终发布只接受完整初始栈且调度状态低位为 [TASK_INIT] 的描述符。 *)
Definition task_create_finalize_ready (desc : TaskDescriptorAbs) : Prop :=
  task_create_stack_ready desc /\
  Z.land (desc.(tdSchedMember)).(tsmStat) TASK_STAT_MASK = TASK_INIT.

(** 第一次临界区提交后的状态：注册任务，标记 Critical，map 保持缺项。 *)
Definition task_publish_state
    (task : addr)
    (published_idmanager : VarIdmanager)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status :=
      update_task_virtual_status
        task VTS_CRITICAL before.(task_virtual_status);
    task_idmanager_abs := published_idmanager;
    task_ptr_list := task :: before.(task_ptr_list);
    task_desc_map :=
      update_task_desc_map task None before.(task_desc_map);
  |}.

(** 失败回滚后的状态：移除精确注册项并继续保持 map 缺项。 *)
Definition task_rollback_state
    (task : addr)
    (rolled_back_manager : VarIdmanager)
    (remaining_tasks : TaskAddrList)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status := before.(task_virtual_status);
    task_idmanager_abs := rolled_back_manager;
    task_ptr_list := remaining_tasks;
    task_desc_map := before.(task_desc_map);
  |}.

(** 成功初始化后的原子纯状态更新：Critical/None 变为 Normal/Some。 *)
Definition task_finalize_state
    (task : addr)
    (desc : TaskDescriptorAbs)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    task_virtual_status :=
      update_task_virtual_status
        task VTS_NORMAL before.(task_virtual_status);
    task_idmanager_abs := before.(task_idmanager_abs);
    task_ptr_list := before.(task_ptr_list);
    task_desc_map :=
      update_task_desc_map task (Some desc) before.(task_desc_map);
  |}.

(**
  [task_finalize_publication] 是最终逻辑空临界区必须满足的纯关系。
  物理 descriptor/map 资源转移由 [CrtosInv] 上的独立机器证明规则提供。
*)
Definition task_finalize_publication
    (task : addr)
    (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop :=
  task_world_wf before /\
  task_create_finalize_ready desc /\
  In task before.(task_ptr_list) /\
  before.(task_virtual_status) task = VTS_CRITICAL /\
  before.(task_desc_map) task = None /\
  after = task_finalize_state task desc before /\
  task_world_wf after.
